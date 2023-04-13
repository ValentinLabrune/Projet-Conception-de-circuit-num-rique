library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity Microcontroleur is
port(
    A_IN_G : in std_logic_vector (3 downto 0);
    B_IN_G : in std_logic_vector (3 downto 0);
    SR_IN_L : in std_logic;
    SR_IN_R : in std_logic;

    clock_G : in std_logic;
    reset_G : in std_logic;

    RES_OUT : out std_logic_vector (7 downto 0);
    SR_OUT_L : out std_logic;
    SR_OUT_R : out std_logic
);  
end Microcontroleur;

architecture Microcontroleur_Arch of Microcontroleur is

    component MemInstruction is
        port (
            reset_IN : std_logic;
            clock_IN : std_logic;
            
            SEL_FCT_OUT : std_logic_vector (3 downto 0);
            SEL_ROUTE_OUT : std_logic_vector (3 downto 0);
            SEL_OUT_OUT : std_logic_vector (1 downto 0)
            );
    end component;

    component BigUnit is 
        port(
            A_IN : in std_logic_vector (3 downto 0);
            B_IN : in std_logic_vector (3 downto 0);
            SR_IN_L_G : in std_logic;
            SR_IN_R_G : in std_logic;

            SEL_FCT_IN : in std_logic_vector (3 downto 0);
            SEL_ROUTE_IN : in std_logic_vector (3 downto 0);
            SEL_OUT_IN : in std_logic_vector (1 downto 0);

            clock_IN : in std_logic;
            reset_IN : in std_logic;

            SR_OUT_L_G : out std_logic;
            SR_OUT_R_G : out std_logic;
            RES_OUT_G : out std_logic_vector (7 downto 0)
        );
    end component;

    component BufferNbits is
        generic( N : integer);
        port(
            e : in std_logic_vector(N-1 downto 0);
            reset : in std_logic;
            clock : in std_logic;
            s : out std_logic_vector(N-1 downto 0)
        );
    end component;

    -- signaux 
    -- signaux sortant du mem instruction
    signal SEL_FCT_OUT_MEM, SEL_ROUTE_OUT_MEM : std_logic_vector(3 downto 0);
    signal SEL_OUT_OUT_MEM : std_logic_vector(1 downto 0);

    -- signaux entrant et sortant des buffers Selfct et sel out
    signal SEL_FCT_IN_BUF, SEL_FCT_OUT_BUF : std_logic_vector(3 downto 0);
    signal SEL_OUT_IN_BUF, SEL_OUT_OUT_BUF : std_logic_vector(1 downto 0);

    -- signaux entrant dans le big unit
    signal SEL_FCT_IN_BU, SEL_ROUTE_IN_BU : std_logic_vector(3 downto 0);
    signal SEL_OUT_IN_BU : std_logic_vector(1 downto 0);
        

    begin 

        Memoire : MemInstruction
            port map(
                reset_IN => reset_G ,
                clock_IN => clock_G,
                SEL_FCT_OUT => SEL_FCT_OUT_MEM,
                SEL_ROUTE_OUT => SEL_ROUTE_OUT_MEM,
                SEL_OUT_OUT => SEL_OUT_OUT_MEM 
            );

        MEM_SEL_FCT : bufferNbits
            generic map (N => 4)
            port map(
                e => SEL_FCT_IN_BUFF,
                reset => reset_G,
                clock => clock_G,
                s => SEL_OUT_OUT_BUFF
            );

        MEM_SEL_OUT : bufferNbits
            generic map (N => 2)
            port map(
                e => SEL_OUT_IN_BUFF,
                reset => reset_G,
                clock => clock_G,
                s => SEL_OUT_OUT_BUFF
            );

        ALUG : BigUnit
            port map(
                A_IN => A_IN_G,
                B_IN => B_IN_G,
                SR_IN_L_G => SR_IN_L,
                SR_IN_R_G => SR_IN_R,

                SEL_FCT_IN => SEL_FCT_IN_BU,
                SEL_ROUTE_IN => SEL_ROUTE_IN_BU,
                SEL_OUT_IN => SEL_OUT_IN_BU,

                clock_IN => clock_G,
                reset_IN => reset_G,

                SR_OUT_L_G => SR_OUT_L,
                SR_OUT_R_G => SR_OUT_R,
                RES_OUT_G = RES_OUT
                
            );
        
        -- assignation des signaux
        -- mem instruction to buffers
        SEL_FCT_IN_BUFF <= SEL_FCT_OUT_MEM;
        SEL_OUT_IN_BUFF <= SEL_OUT_OUT_MEM;

        -- buffers to big unit
        SEL_FCT_IN_BU <= SEL_FCT_OUT_BUF;
        SEL_OUT_IN_BU <= SEL_OUT_OUT_BUF;

        -- mem instruction to big unit
        SEL_ROUTE_IN_BU <= SEL_ROUTE_OUT_MEM;

    end Microcontroleur_Arch;


    