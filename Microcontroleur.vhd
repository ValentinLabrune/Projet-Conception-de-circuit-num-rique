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

    clock : in std_logic;
    reset : in std_logic;

    RES_OUT : out std_logic_vectot (7 downto 0);
    SR_OUT_L : out std_logic;
    SR_OUT_R : out std_logic;
);  
end Microcontroleur;

architecture Microcontroleur_Arch

    component MemInstruction

    