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
            SEL_OUT_IN : in std_logic_vector (1 downto 0);

            clock_IN : in std_logic;
            reset_IN : in std_logic;

            SR_OUT_L_G : out std_logic;
            SR_OUT_R_G : out std_logic;
            RES_OUT_G : out std_logic_vector (7 downto 0)
        );
    end component;

    signal My_A_IN, My_B_IN : std_logic_vector (3 downto 0);
    signal My_SR_IN_L_G, My_SR_IN_R_G : std_logic;
    signal My_SEL_FCT_IN, My_SEL_ROUTE_IN : std_logic_vector (3 downto 0);
    signal My_SEL_OUT_IN : std_logic_vector (1 downto 0);
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
            SEL_OUT_IN => My_SEL_OUT_IN,
            clock_IN => My_clock_in,
            reset_IN => My_reset_in,
            SR_OUT_L_G => My_SR_OUT_L_G,
            SR_OUT_R_G => My_SR_OUT_R_G,
            RES_OUT_G => My_RES_OUT_G
        );

    BigUnitUnderTestProc : process (My_clock_in)
    begin
        
            My_A_IN <= "0010"; -- 2
            My_B_IN <= "0110"; -- 6
            My_SR_IN_L_G <= '0'; -- 0
            My_SR_IN_R_G <= '0'; -- 0

            My_SEL_FCT_IN <= "1111"; -- décalage a gauche de A --> 4
            My_SEL_ROUTE_IN <= "0111"; -- stockage de A_in dans buffer A
            My_SEL_OUT_IN <= "11"; -- Res_out <= S
        
        for i in 0 to 9 loop
            -- wait for 5 ns;
            My_clock_in <= '0';
            -- wait for 5 ns;
            My_clock_in <= '1';
            -- wait for 5 ns;
            report " entrée : " ;
            report "A_IN = " & integer'image(to_integer(unsigned(My_A_IN))) & " , B_IN = " & integer'image(to_integer(unsigned(My_B_IN))) & " , SR_IN_L = " & std_logic'image(My_SR_IN_L_G) & " , SR_IN_R = " & std_logic'image(My_SR_IN_R_G);
            report " sel : ";
            report "SEL_FCT_IN = " & integer'image(to_integer(unsigned(My_SEL_FCT_IN))) & " , SEL_ROUTE_IN = " & integer'image(to_integer(unsigned(My_SEL_ROUTE_IN))) & " , SEL_OUT_IN = " & integer'image(to_integer(unsigned(My_SEL_OUT_IN)));
            report " sortie : ";
            report "RES_OUT = " & integer'image(to_integer(unsigned(My_RES_OUT_G))) & " , SR_OUT_L = " & std_logic'image(My_SR_OUT_L_G) & " , SR_OUT_R = " & std_logic'image(My_SR_OUT_R_G);
        end loop;
    end process;



end BigUnitTestbench_Arch;