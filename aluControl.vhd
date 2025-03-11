
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity aluControl is
  Port ( 
    opCode: in std_logic_vector(3 downto 0);
    add, sub, inc, dec, neg, nott, andd, orr, sl,sr, mul, div: out std_logic
  );
end aluControl;

architecture Behavioral of aluControl is
begin
 process(opCode)
  begin
        add <= '0';
        sub <= '0';
        inc <= '0';
        dec <= '0';
        neg <= '0';
        nott <= '0';
        andd <= '0';
        orr <= '0';
        sl <= '0';
        sr <= '0';
        mul <= '0';
        div <= '0';
    
        case opCode is
          when "0001" => add <= '1';
          when "0010" => sub <= '1';
          when "0011" => inc <= '1';
          when "0100" => dec <= '1';
          when "0101" => andd <= '1';
          when "0110" => orr <= '1';
          when "0111" => nott <= '1';
          when "1000" => neg <= '1';
          when "1001" => sl <= '1';
          when "1010" => sr <= '1';
          when "1011" => mul <= '1';
          when "1100" => div <= '1';
          when others => null; -- Do nothing for undefined opCodes
        end case;
  end process;                                                                                                              
end Behavioral;
