LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all; -- Use numeric_std for arithmetic operations

ENTITY divider IS
  PORT (
    x, y : in std_logic_vector(31 downto 0);
    q, r : out std_logic_vector(31 downto 0)
  );
END divider;

ARCHITECTURE structural OF divider IS
    component carryLookaheadAdder32 is
      Port (
        A, B: in std_logic_vector(31 downto 0);
        Cin: in std_logic;
        Sum: out std_logic_vector(31 downto 0);
        Cout: out std_logic
      );
    end component;
    component negation is
      Port ( 
        A: in std_logic_vector(31 downto 0);
        Y: out std_logic_vector(31 downto 0)
      );
    end component;
    signal remainder_dividend: std_logic_vector(31 downto 0);
    signal remainder1: std_logic_vector(31 downto 0);
    signal subresult: std_logic_vector(31 downto 0);
    signal addresult: std_logic_vector(31 downto 0);
    signal negresult: std_logic_vector(31 downto 0);
    signal dividend : unsigned(63 downto 0); 
    signal divisor  : unsigned(31 downto 0);
    signal quotient : unsigned(31 downto 0);
    signal remainder : unsigned(31 downto 0);
    signal cin1, cout1, cin2, cout2: std_logic;
BEGIN
    dividend <= unsigned(x) & x"00000000"; 
    divisor <= unsigned(y);
    quotient <= (others => '0');
    remainder <= (others => '0');
    cin1 <= '0';
    cin2<= '0';
    
  remainder_dividend <= std_logic_vector(remainder(30 downto 0) & dividend(63));
  neg: negation port map (std_logic_vector(divisor), negresult);
  subtractor: carryLookaheadAdder32 port map (remainder_dividend, negresult, cin1, subresult, cout1);
  adder: carryLookaheadAdder32 port map (std_logic_vector(remainder), std_logic_vector(divisor), cin2, addresult, cout2);
  
  PROCESS(x, y)
  BEGIN
    
    FOR i IN 31 DOWNTO 0 LOOP
      
      remainder <= unsigned(subresult);
      dividend <= dividend(62 downto 0) & '0'; 

      
      IF remainder(31) = '1' THEN
        remainder <= unsigned(addresult); 
        quotient <= quotient(30 downto 0) & '0'; 
      ELSE
        quotient <= quotient(30 downto 0) & '1'; 
      END IF;
    END LOOP;

   
    q <= std_logic_vector(quotient);
    r <= std_logic_vector(remainder);
  END PROCESS;

END structural;