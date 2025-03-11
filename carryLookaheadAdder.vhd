
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity carryLookaheadAdder is
  Port ( 
    A, B: in std_logic_vector(3 downto 0);
    Cin: in std_logic;
    Sum: out std_logic_vector(3 downto 0);
    Cout: out std_logic
  );
end carryLookaheadAdder;

architecture Structural of carryLookaheadAdder is
    component fullAdder is
      Port (
        A, B, Cin: in std_logic;
        Sum: out std_logic
       );
    end component;
    
    component carryBlock is
      Port ( 
        A, B: in std_logic_vector(3 downto 0);
        Cin: in std_logic;
        C: out std_logic_vector(3 downto 0)
      );
    end component;
    
    signal c: std_logic_vector(3 downto 0);
    
begin

    --Instantiate the carry blocks
    CB: carryBlock port map(A, B, Cin, c);

    -- Instantiate 4 full adders
    FA0: fullAdder port map(A(0), B(0), Cin, Sum(0));
    FA1: fullAdder port map(A(1), B(1), c(0), Sum(1));
    FA2: fullAdder port map(A(2), B(2), c(1), Sum(2));
    FA3: fullAdder port map(A(3), B(3), c(2), Sum(3));   
    
    Cout <= c(3);


end Structural;
