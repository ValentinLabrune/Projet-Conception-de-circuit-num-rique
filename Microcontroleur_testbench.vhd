library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity MicrocontroleurTestbench is
end MicrocontroleurTestbench;

architecture MicrocontroleurTestbench_Arch of MicrocontroleurTestbench is

    component Microcontroleur is
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
    end component;

    signal My_A_IN_G, My_B_IN_G : std_logic_vector (3 downto 0);
    signal My_SR_IN_L, My_SR_IN_R : std_logic;
    signal My_clock_G, My_reset_G : std_logic;
    signal My_RES_OUT : std_logic_vector (7 downto 0);
    signal My_SR_OUT_L, My_SR_OUT_R : std_logic;

begin

    MicrocontroleurUnderTest : Microcontroleur
        port map(
            A_IN_G => My_A_IN_G,
            B_IN_G => My_B_IN_G,
            SR_IN_L => My_SR_IN_L,
            SR_IN_R => My_SR_IN_R,
            clock_G => My_clock_G,
            reset_G => My_reset_G,
            RES_OUT => My_RES_OUT,
            SR_OUT_L => My_SR_OUT_L,
            SR_OUT_R => My_SR_OUT_R
        );
    
    
    process
    begin
        My_A_IN_G <= "0110"
        My_B_IN_G <= "0011"
        My_SR_IN_L <= '0'
        My_SR_IN_R <= '0'
        wait for 10 ns;

        for i in 0 to 127 loop
            My_clock_G <= '1';
            wait for 10 ns;
            My_clock_G <= '0';
            wait for 10 ns;
            report "A_IN = " & integer'image(to_integer(unsigned(My_A_IN_G))) & "B_IN = " & integer'image(to_integer(unsigned(My_B_IN_G))) & "SR_IN_L = " & std_logic'image(My_SR_IN_L) & "SR_IN_R = " & std_logic'image(My_SR_IN_R);
            report "RES_OUT = " & integer'image(to_integer(unsigned(My_RES_OUT))) & "SR_OUT_L = " & std_logic'image(My_SR_OUT_L) & "SR_OUT_R = " & std_logic'image(My_SR_OUT_R);
        end loop;
        wait;
    end process;

end MicrocontroleurTestbench_Arch;

