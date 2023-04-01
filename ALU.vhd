library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity calculunite is
port(
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
end calculunite;

architecture arch_calculunite of calculunite is
    signal A, B : signed(3 downto 0);
    signal S : signed(7 downto   0);
    signal carry_in, carry_out : std_logic;

    -- declaration du composant a tester -> renvoie vers l'entité BufferNbits

    component Buffer4Bits
    generic ( N : integer );
    port ( 
        e1 : in std_logic_vector (N-1 downto 0);
        reset : in std_logic;
        preset : in std_logic;
        ce : in std_logic;
        clock : in std_logic;
        s1 : out std_logic_vector (N-1 downto 0)
    ); end component;
    signal Buffer4Bits_s1 : std_logic_vector (N-1 downto 0)

    component Buffer2Bits 
    generic ( N : integer );
    port ( 
        e1 : in std_logic_vector (N-1 downto 0);
        e2 : in std_logic_vector (N-1 downto 0);
        reset : in std_logic;
        preset : in std_logic;
        ce : in std_logic;
        clock : in std_logic;
        s1 : out std_logic_vector (N-1 downto 0)
    ); end component;
   
    begin

        BufferA : Buffer4Bits
        generic map (N => 4)
        port map (
            e1 => Buffer_A_IN, -- Dépend du code de martin
            reset => RESET,
            preset => '0',
            ce => ce_Buff_A, 
            clock => CLK,
            s1 => Buffer_A_OUT -- Récupère dans le process SEL_FCT_mem
        );

        

        BufferSR_IN : Buffer2Bits
        generic map (N => 2)
        port map (
            e1 => SR_IN_L,
            e2 => SR_IN_R, 
            reset => RESET,
            preset => '0',
            ce => ce_Buff_SR_IN,
            clock => CLK,
            s1 => SR_IN_L & SR_IN_R -- Récupère dans le process SEL_FCT_mem
        );

        A <= signed(A);
        B <= signed(B);

    process(CLK, RESET)
    begin
        if RESET = '1' then
        SR_OUT_L <= '0';
        SR_OUT_R <= '0';
        S <= (others => '0');
        carry_in <= '0';
        S <= (others => '0');
        elsif rising_edge(CLK) then
            case SEL_FCT_mem is
            when "0000" => -- no op
            S <= '0';
            when "0001" => -- shift right B
                ce_Buff_SR_IN <= '1';
                SR_OUT_R = B(0);
                S(2 downto 0) <= B (3 downto 1)
                S(3) = SR_IN_L
                SR_OUT_L <= '0';
                
            when "0010" => -- shift left B
                ce_Buff_SR_IN <= '1';
                SR_OUT_L = B(3);
                S(3 downto 1) <= B (2 downto 0)
                S(0) = SR_IN_R
                SR_OUT_R <= '0';

            when "0011" => -- A 
                ce_Buff_SR_IN <= '0';
                S <= A;
                SR_OUT_L <= '0';
                SR_OUT_R <= '0';
            
            when "0100" => -- B
                ce_Buff_SR_IN <= '0';
                S <= B;
                SR_OUT_L <= '0';
                SR_OUT_R <= '0';
            
            when "0101" => -- not A
                ce_Buff_SR_IN <= '0';
                S <= not A;
                SR_OUT_L <= '0';
                SR_OUT_R <= '0';
            
            when "0110" => -- not B
                ce_Buff_SR_IN <= '0';
                S <= not B;
                SR_OUT_L <= '0';
                SR_OUT_R <= '0';
            
            when "0111" => -- A and B
                ce_Buff_SR_IN <= '0';
                S <= A and B;
                SR_OUT_L <= '0';
                SR_OUT_R <= '0';
            
            when "1000" => -- A or B
                ce_Buff_SR_IN <= '0';
                S <= A or B;
                SR_OUT_L <= '0';
                Sr_OUT_R <= '0';
            
            when "1001" => -- A xor B
                ce_Buff_SR_IN <= '0';
                S <= A xor B;
                SR_OUT_L <= '0';
                SR_OUT_R <= '0';
            
            when "1010"=> -- A + B with carry in
                ce_Buff_SR_IN <= '0';
                carry_out <= A(0) and B(0);
                S <= A + B + unsigned(carry_in);
                SR_OUT_L <= '0';
                SR_OUT_R <= '0';
            
            when "1011" => -- addition binaire sans retenue d’entrée
                ce_Buff_SR_IN <= '0';
                S <= A + B;
                SR_OUT_L <= '0';
                SR_OUT_R <= '0';
            
            when "1100"=> -- soustraction binaire
                ce_Buff_SR_IN <= '0';
                S <= A - B;
                SR_OUT_L <= '0';
                SR_OUT_R <= '0';

            when "1101" => -- multiplication binaire
                ce_Buff_SR_IN <= '0';
                S <= A * B;
                SR_OUT_L <= '0';
                SR_OUT_R <= '0';

            when "1110"=> -- Déc. droite A sur 4 bits(avec SR_IN_L)
                ce_Buff_SR_IN <= '1';
                SR_OUT_R = A(0);
                S(2 downto 0) <= A (3 downto 1)
                S(3) = SR_IN_L
                SR_OUT_L <= '0';

            when "1111"=> -- Déc. gauche A sur 4 bits (avec SR_IN_R)
                ce_Buff_SR_IN <= '1';
                SR_OUT_L = A(3);
                S(3 downto 1) <= A (2 downto 0)
                S(0) = SR_IN_R
                SR_OUT_R <= '0';
            end case;
        end if;
        S_OUT_R_L <= S_OUT_R & S_OUT_L;
    end process;
end arch_calculunite;









