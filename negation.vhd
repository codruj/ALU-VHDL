
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity negation is
  Port ( 
    A: in std_logic_vector(31 downto 0);
    Y: out std_logic_vector(31 downto 0)
  );
end negation;

architecture Behavioral of negation is
    component logicOp32 is
      Port (
        A,B: in std_logic_vector(31 downto 0);
        andd, orr, nott: in std_logic;
        Y: out std_logic_vector(31 downto 0)
      );
    end component;
    component carryLookaheadAdder32 is
      Port (
        A, B: in std_logic_vector(31 downto 0);
        Cin: in std_logic;
        Sum: out std_logic_vector(31 downto 0);
        Cout: out std_logic;
        overflow: out std_logic
      );
    end component;
    signal notA: std_logic_vector(31 downto 0);
    signal cou: std_logic;
    signal over: std_logic;
begin
    
  nottA: logicOp32 port map (A, x"00000000", '0', '0', '1', notA);
  res: carryLookaheadAdder32 port map (notA, x"00000001", '0', Y, cou, over);
    
end Behavioral;
