library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_signed.all;

entity ALUTestbench is

end ALUTestbench;

architecture ALUTestbench_Arch of ALUTestbench is

    signal My_A, My_B : std_logic_vector(3 downto 0) := (others => '0');
    signal My_SR_IN_R, My_SR_IN_L, My_SR_OUT_R, My_SR_OUT_L : std_logic := '0';
    signal My_S : std_logic_vector(7 downto 0) := (others => '0');
    signal My_SEL_FCT : std_logic_vector(3 downto 0) := (others => '0');

    component ALUCompo is
        port(
        A : in std_logic_vector (3 downto 0);
        B : in std_logic_vector (3 downto 0);
        SR_IN_L : in std_logic;
        SR_IN_R : in std_logic;
        SEL_FCT : in std_logic_vector (3 downto 0);
        S : out std_logic_vector (7 downto 0);
        SR_OUT_L : out std_logic;
        SR_OUT_R : out std_logic
        );
    end component;


begin

    ALUCompoUnderTest : ALUCompo
    
        port map (
            A => My_A,
            B => My_B,  
            SR_IN_R => My_SR_IN_R,
            SR_IN_L => My_SR_IN_L,
            SEL_FCT => My_SEL_FCT,
            S => My_S,
            SR_OUT_L => My_SR_OUT_L,
            SR_OUT_R => My_SR_OUT_R
        );




    ALUProc : process
    begin
        -- test pour décalage à gauche
        My_SEL_FCT <= "0010";
        My_A <= "1010";
        My_B <= "0111";
        My_SR_IN_L <= '0';
        My_SR_IN_R <= '1';
        wait for 10 ns;
        report "décalage a gauche : ";
        report " | SEL_FCT =" & integer'image(to_integer(unsigned(My_SEL_FCT))) & " | My_A = " & integer'image(to_integer(signed(My_A))) & " |My_B = " & integer'image(to_integer(signed(My_B)))  & " | S = " & integer'image(to_integer(signed(My_S))) & " | SR_IN_R = " & std_logic'image(My_SR_IN_R) & " | SR_IN_L = " & std_logic'image(My_SR_IN_L) & " |  SR_OUT_R = " & std_logic'image(My_SR_OUT_R) & " | SR_OUT_L = " & std_logic'image(My_SR_OUT_L) ;
        wait for 10 ns;
        
        -- test pour decalage à droite
        My_SEL_FCT <= "0001";
        wait for 10 ns;
        report "décalage a droite :";
        report " | SEL_FCT =" & integer'image(to_integer(unsigned(My_SEL_FCT))) & " | My_A = " & integer'image(to_integer(signed(My_A))) & " |My_B = " & integer'image(to_integer(signed(My_B)))  & " | S = " & integer'image(to_integer(signed(My_S))) & " | SR_IN_R = " & std_logic'image(My_SR_IN_R) & " | SR_IN_L = " & std_logic'image(My_SR_IN_L) & " |  SR_OUT_R = " & std_logic'image(My_SR_OUT_R) & " | SR_OUT_L = " & std_logic'image(My_SR_OUT_L) ;
        wait for 10 ns;
        
        -- test pour addition avec retenue entrante
        My_SEL_FCT <= "1010";
        wait for 10 ns;
        report "addition simple : ";
        report " | SEL_FCT=" & integer'image(to_integer(unsigned(My_SEL_FCT))) & " | My_A = " & integer'image(to_integer(signed(My_A))) & " |My_B = " & integer'image(to_integer(signed(My_B)))  & " | S = " & integer'image(to_integer(signed(My_S))) & " | SR_IN_R = " & std_logic'image(My_SR_IN_R) & " | SR_IN_L = " & std_logic'image(My_SR_IN_L) & " |  SR_OUT_R = " & std_logic'image(My_SR_OUT_R) & " | SR_OUT_L = " & std_logic'image(My_SR_OUT_L) ;
        wait;
        
        
    end process;


end ALUTestbench_Arch;