library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity MemInstruction is
    port(
        clock_IN : in std_logic;
        reset_IN : in std_logic;

        SEL_FCT_OUT : out std_logic_vector (3 downto 0);
        SEL_ROUTE_OUT : out std_logic_vector (3 downto 0);
        SEL_OUT_OUT : out std_logic_vector (1 downto 0)
    );
end MemInstruction;

architecture MemInstruction_Arch of MemInstruction is

    -- memoire
    type memory is array (0 to 3) of std_logic_vector (9 downto 0); -- (0 to 127) pour la memoire 128bits
    signal pointeur : integer range 0 to 3 := 0; -- 0 to 127 pour que le compteur aille jusqu'a 127

    constant MemInstruction : memory := (
        ("0010000111"),
        ("0011111001"),
        
        -- ajouter les 127 autres lignes
        ("1100010010"),
        ("0110011000")


    );

begin

    process (clock_IN)
    begin
        if (rising_edge(clock_IN)) then
            if (reset_IN = '1') then
                pointeur <= 0;
            else
                pointeur <= pointeur + 1;
            end if;
        end if;
    end process;

    SEL_FCT_OUT <= MemInstruction(pointeur)(9 downto 6);
    SEL_ROUTE_OUT <= MemInstruction(pointeur)(5 downto 2);
    SEL_OUT_OUT <= MemInstruction(pointeur)(1 downto 0);

end MemInstruction_Arch;
    
