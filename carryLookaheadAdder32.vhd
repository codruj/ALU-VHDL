library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity carryLookaheadAdder32 is
  Port (
    A, B: in std_logic_vector(31 downto 0);
    Cin: in std_logic;
    Sum: out std_logic_vector(31 downto 0);
    Cout: out std_logic;
    overflow: out std_logic
  );
end carryLookaheadAdder32;

architecture Structural of carryLookaheadAdder32 is

    component carryLookaheadAdder is
      Port (
        A, B: in std_logic_vector(3 downto 0);
        Cin: in std_logic;
        Sum: out std_logic_vector(3 downto 0);
        Cout: out std_logic
      );
    end component;

    signal c: std_logic_vector(7 downto 0); 
    signal co: std_logic; 
begin

    CLA0: carryLookaheadAdder port map(A(3 downto 0), B(3 downto 0), Cin, Sum(3 downto 0), c(0));
    CLA1: carryLookaheadAdder port map(A(7 downto 4), B(7 downto 4), c(0), Sum(7 downto 4), c(1));
    CLA2: carryLookaheadAdder port map(A(11 downto 8), B(11 downto 8), c(1), Sum(11 downto 8), c(2));
    CLA3: carryLookaheadAdder port map(A(15 downto 12), B(15 downto 12), c(2), Sum(15 downto 12), c(3));
    CLA4: carryLookaheadAdder port map(A(19 downto 16), B(19 downto 16), c(3), Sum(19 downto 16), c(4));
    CLA5: carryLookaheadAdder port map(A(23 downto 20), B(23 downto 20), c(4), Sum(23 downto 20), c(5));
    CLA6: carryLookaheadAdder port map(A(27 downto 24), B(27 downto 24), c(5), Sum(27 downto 24), c(6));
    CLA7: carryLookaheadAdder port map(A(31 downto 28), B(31 downto 28), c(6), Sum(31 downto 28), Co);
    overflow <= c(6) xor Co;
    Cout <= co;
end Structural;