library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity top_levelf is
  Port (
    opcode: in std_logic_vector(3 downto 0);
    address1: in std_logic_vector(4 downto 0);
    address2: in std_logic_vector(4 downto 0);
    clk:in std_logic;
    cat: out std_logic_Vector(6 downto 0);
    an: out std_logic_vector(3 downto 0);
    btn1:in std_logic;
    btn2: in std_logic;
    btn3: in std_logic;
    divisionFlag:out std_logic;
    overflowFlag: out std_logic
  );
end top_levelf;

architecture Behavioral of top_levelf is
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
    
    -- ALU control
    component aluControl is
        Port (
            opCode : in std_logic_vector(3 downto 0);
            add, sub, inc, dec, neg, nott, andd, orr, sl,sr, mul, div : out std_logic
        );
    end component;

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

    -- Neg
    component negation is
        Port (
            A : in std_logic_vector(31 downto 0);
            Y : out std_logic_vector(31 downto 0)
        );
    end component;

    -- Logic Op
    component logicOp32 is
        Port (
            A, B : in std_logic_vector(31 downto 0);
            andd, orr, nott : in std_logic;
            Y : out std_logic_vector(31 downto 0)
        );
    end component;

    -- Div
    component dividerGood is
        Port (
            x, y : in std_logic_vector(31 downto 0);
            q, r : out std_logic_vector(31 downto 0)
        );
    end component;

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

    -- Shift Register
    component shift_reg is
       Port (
            clk:in std_logic;
            data_in : in STD_LOGIC_VECTOR(31 downto 0); 
            dir : in STD_LOGIC;
            ready: out std_logic;
            data_out : out STD_LOGIC_VECTOR(31 downto 0)
      
       );
    end component;
    
    -- SSD
    component display_7seg is
        Port ( digit0 : in STD_LOGIC_VECTOR (3 downto 0);
               digit1 : in STD_LOGIC_VECTOR (3 downto 0);
               digit2 : in STD_LOGIC_VECTOR (3 downto 0);
               digit3 : in STD_LOGIC_VECTOR (3 downto 0);
               clk : in STD_LOGIC;
               cat : out STD_LOGIC_VECTOR (6 downto 0);
               an : out STD_LOGIC_VECTOR (3 downto 0));
    end component;
    
    
    -- Signals
    signal A, B : std_logic_vector(31 downto 0) := x"00000000";
    signal s_add, s_sub, s_inc, s_dec, s_neg, s_nott, s_andd, s_orr, s_sl, s_sr, s_mul, s_div : std_logic := '0';
    signal sumres : std_logic_vector(31 downto 0) := x"00000000";
    signal coutres : std_logic := '0';
    signal overflowres: std_logic := '0';
    signal yres : std_logic_vector(31 downto 0) := x"00000000";
    signal logicres : std_logic_vector(31 downto 0) := x"00000000";
    signal quotient, remainder : std_logic_vector(31 downto 0) := x"00000000";
    signal mulres : std_logic_vector(63 downto 0) := x"0000000000000000";
    signal resReady : std_logic := '0';
    signal readyshift: std_logic := '0';
    signal startShift: std_logic := '0';
    signal dataoutShift: std_logic_vector(31 downto 0) := x"00000000";
    signal selDir: std_logic := '0';
    signal aa, bb: std_logic_vector(31 downto 0) := x"00000000";
    -- Result signals
    signal resultt1 : std_logic_vector(31 downto 0) := X"00000000";
    signal resultt2 : std_logic_vector(31 downto 0) := X"00000000";
    signal coutt : std_logic := '0';
    signal overr: std_logic := '0';
    signal div0: std_logic := '0';
    
    signal ssd_result: std_logic_vector(15 downto 0) := X"0000";
    
begin
    --led <= '1';
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

    -- Shift
    shift: shift_reg port map (clk, B, selDir, readyShift, dataoutShift);

    
    -- Result Selection Logic
    process(A, B, clk, opcode)
    begin
        if s_add = '1' OR s_sub = '1' OR s_inc = '1' OR s_dec = '1' then
            resultt1 <= sumres;
            coutt <= coutres;
            overr <= overflowres;
        elsif s_neg = '1' then
            resultt1 <= yres;
        elsif s_andd = '1' OR s_orr = '1' OR s_nott = '1' then
            resultt1 <= logicres;
        elsif s_div = '1' then
            if B = x"00000000" then
                div0 <= '1';
            else
                resultt1 <= quotient;
                resultt2 <= remainder;
             end if;
        elsif s_mul = '1' then
            if resReady = '1' then
                resultt2 <= mulres(63 downto 32);
                resultt1 <= mulres(31 downto 0);
            end if;
        elsif s_sl = '1' then
            selDir <= '0';
            if readyShift = '1' then
                resultt1 <= dataoutShift;
                startShift <= '0';
            else
                startShift <= '1';
            end if;
        elsif s_sr = '1' then
            selDir <= '1';
            if readyShift = '1' then
                resultt1 <= dataoutShift;
                startShift <= '0';
            else
                startShift <= '1';
            end if;
        end if;
    end process;
    divisionFlag <= div0;
    overflowFlag <= overr;
    process(btn1, btn2, btn3)
    begin
        if btn1 = '0' then
            if btn2 = '0' then
                if btn3 = '1' then
                    ssd_result <= resultt2(31 downto 16);
                 else            
                    ssd_result <= resultt1(15  downto 0);
                end if;
            else
                ssd_result <= resultt2(15 downto 0);
            end if;
        else
            ssd_result <= resultt1(31 downto 16);
        end if;
    end process;
    
    SSD1:display_7seg
    port map(
        digit0 =>ssd_result(3 downto 0),
        digit1 =>ssd_result(7 downto 4),
        digit2 =>ssd_result(11 downto 8),
        digit3 =>ssd_result (15 downto 12),
        clk => clk,
        cat =>cat,
        an =>an
    );
    
    -- Output Signals
    --result1 <= resultt1;
    --result2 <= resultt2;
    --cout <= coutt;
    --overflow <= overr;

end Behavioral;
