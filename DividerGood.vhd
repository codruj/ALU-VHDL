LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all; 

ENTITY dividerGood IS
  PORT (
    x, y : in std_logic_vector(31 downto 0);
    q, r : out std_logic_vector(31 downto 0)
  );
END dividerGood;

ARCHITECTURE structural OF dividerGood IS
BEGIN

  PROCESS(x, y)
    VARIABLE dividend : unsigned(63 downto 0); 
    VARIABLE divisor  : unsigned(31 downto 0);
    VARIABLE quotient : unsigned(31 downto 0);
    VARIABLE remainder : unsigned(31 downto 0);
  BEGIN
    -- Initialize variables
    dividend := unsigned(x) & x"00000000";
    divisor := unsigned(y);
    quotient := (others => '0');
    remainder := (others => '0');

   
    FOR i IN 31 DOWNTO 0 LOOP
      
      remainder := (remainder(30 downto 0) & dividend(63)) - divisor;
      dividend := dividend(62 downto 0) & '0'; 
      IF remainder(31) = '1' THEN
        remainder := remainder + divisor; 
        quotient := quotient(30 downto 0) & '0'; 
      ELSE
        quotient := quotient(30 downto 0) & '1'; 
      END IF;
    END LOOP;

    
    q <= std_logic_vector(quotient);
    r <= std_logic_vector(remainder);
  END PROCESS;

END structural;