library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity shift_reg is
  Port (
        clk:in std_logic;
        data_in : in STD_LOGIC_VECTOR(31 downto 0); 
        dir : in STD_LOGIC;
        ready: out std_logic;
        data_out : out STD_LOGIC_VECTOR(31 downto 0)
  
   );
end shift_reg;

architecture Behavioral of shift_reg is
signal data: std_logic_vector(31 downto 0):= x"00000000";
signal readyy: std_logic:='0';
begin
process(clk)
begin
    if rising_edge(clk) then
            if dir = '0' then
                data <= data_in(30 downto 0) & data_in(31);
                readyy <= '1';
                
            else
                data <= data_in(0) & data_in(31 downto 1);
                readyy <= '1';

            end if;
    end if;
end process;
data_out <= data;
ready <= readyy;
end Behavioral;