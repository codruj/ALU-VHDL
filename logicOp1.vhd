
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity logicOp1 is
  Port (
    A,B: in std_logic;
    andd, orr, nott: in std_logic;
    Y: out std_logic
  );
end logicOp1;

architecture Dataflow of logicOp1 is
begin
    process(A,B,andd, orr, nott)
    begin
        if andd = '1' then
            Y <= A AND B;
        elsif orr = '1' then
            Y <= A OR B;
        elsif nott = '1' then
            Y <= NOT(A);
        end if;
     end process;
end Dataflow;
