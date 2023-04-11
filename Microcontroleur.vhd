library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity Microcontroleur 
port(
    A_IN_G : in std_logic_vector (3 downto 0)
    B_IN_G : in std_logic_vector (3 downto 0)
    SR_IN_L : in std_logic;
    SR_IN_R : in std_logic;

    clock_G : in std_logic;
    reset_G : in std_logic;

    RES_OUT : out std_logic_vectot (7 downto 0);
    SR_OUT_L : out std_logic;
    SR_OUT_R : out std_logic
);  
end Microcontroleur;

architecture Microcontroleur_Arch

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

    begin 

            

    