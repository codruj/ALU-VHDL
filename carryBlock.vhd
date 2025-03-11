
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity carryBlock is
  Port ( 
    A, B: in std_logic_vector(3 downto 0);
    Cin: in std_logic;
    C: out std_logic_vector(3 downto 0)
  );
end carryBlock;

architecture DataFlow of carryBlock is
begin

    C(0) <= (A(0) AND B(0)) OR ((A(0) OR B(0)) AND Cin);
    C(1) <= (A(1) AND B(1)) OR ((A(1) OR B(1)) AND ((A(0) AND B(0)) OR ((A(0) OR B(0)) AND Cin)));
    C(2) <= (A(2) AND B(2)) OR ((A(2) OR B(2)) AND ((A(1) AND B(1)) OR ((A(1) OR B(1)) AND ((A(0) AND B(0)) OR ((A(0) OR B(0)) AND Cin)))) );
    C(3) <= (A(3) AND B(3)) OR ((A(3) OR B(3)) AND ((A(2) AND B(2)) OR ((A(2) OR B(2)) AND ((A(1) AND B(1)) OR ((A(1) OR B(1)) AND ((A(0) AND B(0)) OR ((A(0) OR B(0)) AND Cin)))))));

end DataFlow;
