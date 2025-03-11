
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fullAdder is
  Port (
    A, B, Cin: in std_logic;
    Sum: out std_logic
   );
end fullAdder;

architecture Dataflow of fullAdder is
begin

    Sum <= A xor B xor Cin;
    --Cout <= (A and B) or (A and Cin) or (B and Cin);

end Dataflow;
