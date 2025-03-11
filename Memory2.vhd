library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Memory2 is
    Port (
        clk : in std_logic;
        address : in std_logic_vector(4 downto 0); -- Supports up to 32 addresses
        data_out : out std_logic_vector(31 downto 0)
    );
end Memory2;

architecture Behavioral of Memory2 is
    type memory_array is array (0 to 31) of std_logic_vector(31 downto 0);
    constant memory2 : memory_array := (
        X"89abcdef",
        X"12345671",
        X"0000FFFF",
        X"00000002",
        X"AAAAAAAA",
        X"00000000",
        X"7FFFFFFF",
        X"59682F00",
        -- Not, Shift, Negation do not use Operand 2
        others => X"00000000" -- Default (unused entries)
    );
begin
    process(clk)
    begin
        if rising_edge(clk) then
            data_out <= memory2(conv_integer(address));
        end if;
    end process;
end Behavioral;