library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity multiplier is
  Port (
        clk:in std_logic;
        x: in std_logic_vector(31 downto 0);
        y: in std_logic_vector(31 downto 0);
        ready:out std_logic;
        res: out std_Logic_Vector(63 downto 0)
   );
end multiplier;

architecture Behavioral of multiplier is

component carryLookaheadAdder32 is
  Port (
    A, B: in std_logic_vector(31 downto 0);
    Cin: in std_logic;
    Sum: out std_logic_vector(31 downto 0);
    Cout: out std_logic;
    overflow: out std_logic
  );
end component;
component negation is
  Port ( 
    A: in std_logic_vector(31 downto 0);
    Y: out std_logic_vector(31 downto 0)
  );
end component;

signal xNeg, yNeg: std_logic_vector(31 downto 0) := x"00000000";
signal A,B: std_logic_vector(63 downto 0) := x"0000000000000000";
signal S1,S2: std_logic_vector(31 downto 0) := x"00000000";
signal cout1, cout2: std_logic;
signal overflow1, overflow2: std_logic;
signal Q: std_logic_vector(31 downto 0) := x"00000000";
signal readyy:std_logic := '0';
signal N : integer := 32;
signal nr1,nr2:std_logic_vector(31 downto 0) := x"00000000";
  type state is (sleep, init, handle, impl, done);
  signal currState: state := sleep;
begin


negx: negation port map (
    A => x,
    Y => xNeg
);
negy: negation port map (
    A => y,
    Y => yNeg
);
add1: carryLookaheadAdder32 port map(
    A => A(31 downto 0),
    B => B(31 downto 0),
    Cin => '0',
    Sum => S1,
    Cout => cout1,
    overflow => overflow1
);
add2: carryLookaheadAdder32 port map(
    A => A(63 downto 32),
    B => B(63 downto 32),
    Cin => cout1,
    Sum => S2,
    Cout => cout2,
    overflow => overflow2
);

  process(clk)
  begin
    if rising_edge(clk) then
      case currState is
        when sleep =>
            readyy <= '0';
            currState <= handle;
            
        when handle =>
            if x(31) = '1' then
                nr1 <= xNeg;
            else
                nr1 <= x;
            end if;
            
            if y(31) = '0' then
                nr2 <= y;
            else
                nr2 <= yNeg;
            end if;
            
            currState <= init;
            
        when init =>
            N <= 32;
            Q <= nr2;
            B <= "00000000000000000000000000000000" & nr1;  
            A<= x"0000000000000000";
            currState <= impl;

        when impl =>
            if (N > 0) then
                  if Q(0) = '1' then
                        A <= S2 & S1;
                   end if;   
             Q <= '0' & Q(31 downto 1);  
             B <= B(62 downto 0) & '0';
             N <= N - 1;
            else
              currState <= done;
            end if;

        when done =>
            if (x(31) XOR y(31)) = '1' then
                A<= std_logic_vector(unsigned(not A) + 1);
            end if;
            readyy <= '1';
            currState <=sleep;
      end case;
    end if;
  end process;
  
res <= A;
ready <= readyy;
end Behavioral;
