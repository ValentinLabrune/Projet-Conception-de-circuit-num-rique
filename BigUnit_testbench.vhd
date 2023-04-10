library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_signed.all;

entity BigUnitTestbench is
end BigUnitTestbench;

architecture BigUnitTestbench_Arch of BIgUnitTestbench is

    component BigUnit is 
        port(
            A_IN : in std_logic_vector (3 downto 0);
            B_IN : in std_logic_vector (3 downto 0);
            SR_IN_L_G : in std_logic;
            SR_IN_R_G : in std_logic;

            SEL_FCT_IN : in std_logic_vector (3 downto 0);
            SEL_ROUTE_IN : in std_logic_vector (3 downto 0);
            SEL_OUT : in std_logic_vector (1 downto 0);

            clock_in : in std_logic;
            reset_in : in std_logic;

            SR_OUT_L_G : out std_logic;
            SR_OUT_R_G : out std_logic;
            RES_OUT_G : out std_logic_vector (7 downto 0)
        );
    end component;

    signal My_A_IN, My_B_IN : std_logic_vector (3 downto 0);
    signal My_SR_IN_L_G, My_SR_IN_R_G : std_logic;
    signal My_SEL_FCT_IN, My_SEL_ROUTE_IN : std_logic_vector (3 downto 0);
    signal My_SEL_OUT : std_logic_vector (1 downto 0);
    signal My_clock_in, My_reset_in : std_logic;
    signal My_SR_OUT_L_G, My_SR_OUT_R_G : std_logic;
    signal My_RES_OUT_G : std_logic_vector (7 downto 0);

begin

    BigUnitUnderTest : BigUnit
        port map(
            A_IN => My_A_IN,
            B_IN => My_B_IN,
            SR_IN_L_G => My_SR_IN_L_G,
            SR_IN_R_G => My_SR_IN_R_G,
            SEL_FCT_IN => My_SEL_FCT_IN,
            SEL_ROUTE_IN => My_SEL_ROUTE_IN,
            SEL_OUT => My_SEL_OUT,
            clock_in => My_clock_in,
            reset_in => My_reset_in,
            SR_OUT_L_G => My_SR_OUT_L_G,
            SR_OUT_R_G => My_SR_OUT_R_G,
            RES_OUT_G => My_RES_OUT_G
        );

    BigUnitUnderTest : process (clock)
    begin
        My_A_IN <= "0010";
        My_B_IN <= "0110";
        My_SR_IN_L_G <= '0';
        My_SR_IN_R_G <= '0';

        My_SEL_FCT_IN <= "0010";
        My_SEL_ROUTE_IN <= "0010";
        My_SEL_OUT <= "00";

        wait for 5 ns;
        My_Clock <= '0';
        wait for 5 ns;
        My_Clock <= '1';
        wait for 5 ns;
        report -- finir le report avec toutes les valeurs

    



end BigUnitTestbench_Arch;