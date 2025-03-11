library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Memory1 is
    Port (
        clk : in std_logic;
        address : in std_logic_vector(4 downto 0); -- Supports up to 32 addresses
        data_out : out std_logic_vector(31 downto 0)
    );
end Memory1;

architecture Behavioral of Memory1 is
    type memory_array is array (0 to 31) of std_logic_vector(31 downto 0);
    constant memory1 : memory_array := (
        X"7FFFFFFF",
        x"12345678",
        x"0000FFFF",
        X"FFFFFFFF",
        X"55555555",
        X"77359400",
        others => X"00000000" -- Default (unused entries)
    );
begin
    process(clk)
    begin
        if rising_edge(clk) then
            data_out <= memory1(conv_integer(address));
        end if;
    end process;
end Behavioral;