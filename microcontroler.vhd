library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity microcontroler 
port(
    --Sel route 
    Sel_route_Buf_B_out : in STD_LOGIC_VECTOR (3 downto 0);
    Sel_route_Buf_A_out : in STD_LOGIC_VECTOR (3 downto 0);
    Sel_route_Mem_1_out : in STD_LOGIC_VECTOR (7 downto 0);
    Sel_route_Mem_2_out : in STD_LOGIC_VECTOR (7 downto 0);
    Sel_route_Buf_A_in : out STD_LOGIC_VECTOR (3 downto 0);
    Sel_route_Buf_B_in : out STD_LOGIC_VECTOR (3 downto 0);
    Sel_route_Mem_1_In : out STD_LOGIC_VECTOR (7 downto 0);
    Sel_route_Mem_2_In : out STD_LOGIC_VECTOR (7 downto 0);
    Sel_route_CE_Buf_A : out STD_LOGIC;
    Sel_route_CE_Buf_B : out STD_LOGIC;
    Sel_route_CE_Mem_1 : out STD_LOGIC;
    Sel_route_CE_Mem_2 : out STD_LOGIC  

    --Sel out 
    Sel_out_MEM1_out: in std_logic_vector(3 downto 0);
    Sel_out_MEM2_out: in std_logic_vector(3 downto 0);
    Sel_out_S_OUT: out std_logic_vector(3 downto 0)
    Sel_out_RES_out: out std_logic_vector(3 downto 0)

    -- ALU 
    ALU_SR_IN_L_buff : in std_logic;
    ALU_SR_IN_R_buff : in std_logic;
    ALU_CLK : in std_logic;
    ALU_RESET : in std_logic;
    ALU_A : in std_logic_vector(3 downto 0);
    ALU_B : in std_logic_vector(3 downto 0);
    ALU_SEL_FCT_mem : in std_logic_vector(3 downto 0);
    ALU_ce_Buff_SR_IN : in std_logic;
    ALU_ce_Buff_SR_OUT : in std_logic;
    ALU_SR_OUT_L : out std_logic;
    ALU_SR_OUT_R : out std_logic;
    ALU_SR_OUT_L_R : out std_logic_vector(1 downto 0);
    ALU_S : out std_logic_vector(7 downto 0)
    );
end microcontroler;
architecture arch_microncontroler of microcontroler is

    component selout is
        port(
            clk: in std_logic;
            rst: in std_logic;
            MEM1_out: in std_logic_vector(3 downto 0);
            MEM2_out: in std_logic_vector(3 downto 0);
            S_OUT: out std_logic_vector(3 downto 0)
            RES_out: out std_logic_vector(3 downto 0)
            );
    end component selout;

    component selroute is 
    Port ( 
        -- Sel route
        Buf_A_out : in STD_LOGIC_VECTOR (3 downto 0);
        Buf_B_out : in STD_LOGIC_VECTOR (3 downto 0);
        Mem_1_out : in STD_LOGIC_VECTOR (7 downto 0);
        Mem_2_out : in STD_LOGIC_VECTOR (7 downto 0);
        Buf_A_in : out STD_LOGIC_VECTOR (3 downto 0);
        Buf_B_in : out STD_LOGIC_VECTOR (3 downto 0);
        Mem_1_In : out STD_LOGIC_VECTOR (7 downto 0);
        Mem_2_In : out STD_LOGIC_VECTOR (7 downto 0);
        CE_Buf_A : out STD_LOGIC;
        CE_Buf_B : out STD_LOGIC;
        CE_Mem_1 : out STD_LOGIC;
        CE_Mem_2 : out STD_LOGIC  
    
    );
    end component selroute;

    component ALU is 
    Port(
        SR_IN_L_buff : in std_logic;
        SR_IN_R_buff : in std_logic;
        CLK : in std_logic;
        RESET : in std_logic;
        A : in std_logic_vector(3 downto 0);
        B : in std_logic_vector(3 downto 0);
        SEL_FCT_mem : in std_logic_vector(3 downto 0);
        ce_Buff_SR_IN : in std_logic;
        ce_Buff_SR_OUT : in std_logic;
        SR_OUT_L : out std_logic;
        SR_OUT_R : out std_logic;
        SR_OUT_L_R : out std_logic_vector(1 downto 0);
        S : out std_logic_vector(7 downto 0)
    );
    end component ALU;

    begin
        selroute : selroute
        port map(
        Buf_A_out => Sel_route_Buf_A_out,
        Buf_B_out => sel_route_Buf_B_out,
        Mem_1_out => Sel_route_Mem_1_out,
        Mem_2_out => Sel_route_Mem_2_out,
        Buf_A_in => Sel_route_Buf_A_in,
        Buf_B_in => Sel_route_Buf_B_in,
        Mem_1_In => Sel_route_Mem_1_In,
        Mem_2_In => Sel_route_Mem_2_In,
        S => ALU_S,
        CE_Buf_A => Sel_route_CE_Buf_A,
        CE_Buf_B => Sel_route_CE_Buf_B,
        CE_Mem_1 => Sel_route_CE_Mem_1,
        CE_Mem_2 => Sel_route_CE_Mem_2
        );

    begin 
        selout : selout 
        port map(
            clk => clk,
            rst => rst,
            MEM1_out => Sel_rout_MEM1_out,
            MEM2_out => Sel_rout_MEM2_out,
            S_OUT => Sel_out_S_OUT,
            RES_out => Sel_out_RES_out
        );

        ALU : ALU
        port map(
            SR_IN_L_buff => ALU_SR_IN_L_buff,
            SR_IN_R_buff => ALU_SR_IN_R_buff,
            CLK => ALU_CLK,
            RESET => ALU_RESET,
            A => Sel_route_Buf_A_out,
            B => Sel_route_Buf_B_out,
            SEL_FCT_mem => ALU_SEL_FCT_mem,
            ce_Buff_SR_IN => ALU_ce_Buff_SR_IN,
            ce_Buff_SR_OUT => ALU_ce_Buff_SR_OUT,
            SR_OUT_L : out std_logic;
            SR_OUT_R : out std_logic;
            SR_OUT_L_R => ALU_SR_OUT_L_R,
            S : out std_logic_vector(7 downto 0)
        );

        selout : selout
        port map(
            clk => clk,
            rst => rst,
            MEM1_out => Sel_route_MEM1_out,
            MEM2_out => Sel_route_MEM2_out,
            S_OUT => ALU_S,
            RES_out => Sel_out_RES_out
        );
    

    



