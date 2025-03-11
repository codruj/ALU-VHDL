
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity logicOp32 is
  Port (
    A,B: in std_logic_vector(31 downto 0);
    andd, orr, nott: in std_logic;
    Y: out std_logic_vector(31 downto 0)
  );
end logicOp32;

architecture Structural of logicOp32 is
    component logicOp1 is
      Port (
        A,B: in std_logic;
        andd, orr, nott: in std_logic;
        Y: out std_logic
      );
    end component;
begin

    generateLogic: for i in 0 to 31 generate
        logicOp1Inst: logicOp1 port map (A(i), B(i), andd, orr, nott, Y(i));
    end generate;
end Structural;
