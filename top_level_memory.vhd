library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top_level_memory is
    Port (
        opcode : in std_logic_vector(3 downto 0);
        clk : in std_logic;
        address1 : in std_logic_vector(4 downto 0); -- Memory address
        address2 : in std_logic_vector(4 downto 0);
        result1 : out std_logic_vector(31 downto 0);
        result2 : out std_logic_vector(31 downto 0);
        cout : out std_logic;
        overflow: out std_logic;
        div0: out std_logic
    );
end top_level_memory;

architecture Structural of top_level_memory is
    -- Memory1
    component Memory1 is
        Port (
            clk : in std_logic;
            address : in std_logic_vector(4 downto 0);
            data_out : out std_logic_vector(31 downto 0)
        );
    end component;

    -- Memory2
    component Memory2 is
        Port (
            clk : in std_logic;
            address : in std_logic_vector(4 downto 0);
            data_out : out std_logic_vector(31 downto 0)
        );
    end component;

    signal A, B : std_logic_vector(31 downto 0);

    -- ALU control
    component aluControl is
        Port (
            opCode : in std_logic_vector(3 downto 0);
            add, sub, inc, dec, neg, nott, andd, orr, sl, sr, mul, div : out std_logic
        );
    end component;
    signal s_add, s_sub, s_inc, s_dec, s_neg, s_nott, s_andd, s_orr, s_sl, s_sr, s_mul, s_div : std_logic;

    -- Add, Sub, Inc, Dec
    component Adder32 is
        Port (
            add, sub, inc, dec : in std_logic;
            A, B : in std_logic_vector(31 downto 0);
            Cin : in std_logic;
            Sum : out std_logic_vector(31 downto 0);
            Cout : out std_logic;
            overflow: out std_logic
        );
    end component;
    signal sumres : std_logic_vector(31 downto 0);
    signal coutres : std_logic;
    signal overflowres: std_logic;

    -- Neg
    component negation is
        Port (
            A : in std_logic_vector(31 downto 0);
            Y : out std_logic_vector(31 downto 0)
        );
    end component;
    signal yres : std_logic_vector(31 downto 0);

    -- Logic Op
    component logicOp32 is
        Port (
            A, B : in std_logic_vector(31 downto 0);
            andd, orr, nott : in std_logic;
            Y : out std_logic_vector(31 downto 0)
        );
    end component;
    signal logicres : std_logic_vector(31 downto 0);

    -- Div
    component dividerGood is
        Port (
            x, y : in std_logic_vector(31 downto 0);
            q, r : out std_logic_vector(31 downto 0)
        );
    end component;
    signal quotient, remainder : std_logic_vector(31 downto 0);

    -- Mul
    component multiplier is
      Port (
        clk:in std_logic;
        x: in std_logic_vector(31 downto 0);
        y: in std_logic_vector(31 downto 0);
        ready:out std_logic;
        res: out std_Logic_Vector(63 downto 0)
     );
    end component;
    signal mulres : std_logic_vector(63 downto 0);
    signal resReady : std_logic;

    -- Result signals
    signal resultt1 : std_logic_vector(31 downto 0) := X"00000000";
    signal resultt2 : std_logic_vector(31 downto 0) := X"00000000";
    signal coutt : std_logic := '0';

    signal divv0: std_logic := '0';
begin

    -- Memory Instantiations
    memory1_inst : Memory1 port map (clk, address1, A);
    memory2_inst : Memory2 port map (clk, address2, B);

    -- ALU Control
    enables : aluControl port map (opcode, s_add, s_sub, s_inc, s_dec, s_neg, s_nott, s_andd, s_orr, s_sl, s_sr, s_mul, s_div);

    -- Arithmetic Operations
    arithmeticOp : Adder32 port map (s_add, s_sub, s_inc, s_dec, A, B, '0', sumres, coutres, overflowres);

    -- Negation
    neg : negation port map (B, yres);

    -- Logic Operations
    logic : logicOp32 port map (A, B, s_andd, s_orr, s_nott, logicres);

    -- Division
    div : dividerGood port map (A, B, quotient, remainder);

    -- Multiplication
    mul : multiplier port map (clk, A, B, resReady, mulres);

    -- Result Selection Logic
    process(A, B, clk, opcode)
    begin
        if s_add = '1' OR s_sub = '1' OR s_inc = '1' OR s_dec = '1' then
            resultt1 <= sumres;
            coutt <= coutres;
        elsif s_neg = '1' then
            resultt1 <= yres;
        elsif s_andd = '1' OR s_orr = '1' OR s_nott = '1' then
            resultt1 <= logicres;
        elsif s_div = '1' then
            if B = x"00000000" then
                divv0 <= '1';
            else
                resultt1 <= quotient;
                resultt2 <= remainder;
            end if;
        elsif s_mul = '1' then
            resultt1 <= mulres(63 downto 32);
            resultt2 <= mulres(31 downto 0);
        end if;
    end process;

    -- Output Signals
    result1 <= resultt1;
    result2 <= resultt2;
    cout <= coutt;
    overflow <= overflowres;
    div0 <= divv0;
end Structural;