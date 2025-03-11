

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Adder32 is
Port (
    add, sub, inc, dec: in std_logic;
    A, B: in std_logic_vector(31 downto 0);
    Cin: in std_logic;
    Sum: out std_logic_vector(31 downto 0);
    Cout: out std_logic;
    overflow: out std_logic
  );
end Adder32;

architecture Structural of Adder32 is
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
    signal input2: std_logic_vector(31 downto 0);
    signal notB: std_logic_vector(31 downto 0);
    signal input: std_logic_vector(31 downto 0);
    signal temp_Sum: std_logic_vector(31 downto 0);
    signal overfloww: std_logic;
begin

    negationn: negation port map (B, notB);
    process(A,B,add,sub,inc,dec) begin
        if add = '1' then
            input2 <= B;
        elsif sub = '1' then
            input2 <= notB;
        elsif inc = '1' then
            input2 <= "00000000000000000000000000000001";
        elsif dec = '1' then
            input2 <= "11111111111111111111111111111111";
        end if;
    end process;
    input <= input2;
    result: carryLookaheadAdder32 port map (A, input, Cin, temp_sum, Cout, overfloww);
    Sum <= temp_sum;
    overflow <= overfloww;

end Structural;
 