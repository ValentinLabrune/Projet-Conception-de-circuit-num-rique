library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity ALUCompo is
port(
    -- entrées
    A : in std_logic_vector(3 downto 0);
    B : in std_logic_vector(3 downto 0);
    SR_IN_L : in std_logic := '0';
    SR_IN_R : in std_logic := '0';
    
    -- sel fct
    SEL_FCT_MEM : in std_logic_vector(3 downto 0);

    -- sorties  
    S : out std_logic_vector(7 downto 0);
    SR_OUT_L : out std_logic := '0';
    SR_OUT_R : out std_logic := '0'
);
end ALUCompo;

architecture arch_ALUCompo of ALUCompo is
    signal My_A, My_B : std_logic_vector(3 downto 0);
    signal My_S : std_logic_vector(7 downto   0);
    signal My_SR_IN_L, My_SR_IN_R, My_SR_OUT_L, My_SR_OUT_R : std_logic;
    signal My_SEL_FCT_MEM : std_logic_vector(3 downto 0);

   begin

        ALUCompo_Proc : process(A, B, SR_IN_L, SR_IN_R, SEL_FCT_MEM)
            variable S_var, A_var, B_var : std_logic_vector(7 downto 0);
        begin
              case SEL_FCT_MEM is
                  when "0000" => -- no op : toutes les sorties a 0
                      S <= "00000000";
                      SR_OUT_L <= '0';
                      SR_OUT_R <= '0';

                  when "0001" => -- S = décallage à droite B sur 4 bits, SR_IN_L bit entrant
                      S(7 downto 4) <= (others => '0');
                      S(3) <= SR_IN_L;
                      S(2 downto 0) <= B(3 downto 1);
                      SR_OUT_R <= B(0);
                      SR_OUT_L <= '0';

                  when "0010" => -- S = décallage à gauche B sur 4 bits, SR_IN_R bit entrant
                      S(7 downto 4) <= (others => '0');
                      S(0) <= SR_IN_R;
                      S(3 downto 1) <= B(2 downto 0);
                      SR_OUT_L <= B(3);
                      SR_OUT_R <= '0';

                  when "0011" => -- S = A
                      S(7 downto 4) <= (others => '0');
                      S(3 downto 0) <= A;
                      SR_OUT_L <= '0';
                      SR_OUT_R <= '0';

                  when "0100" => -- S = B
                      S(7 downto 4) <= (others => '0');
                      S(3 downto 0) <= B;
                      SR_OUT_L <= '0';
                      SR_OUT_R <= '0';

                  when "0101" => -- S = not A
                      S(7 downto 4) <= (others => '0');
                      S(3 downto 0) <= not A;
                      SR_OUT_L <= '0';
                      SR_OUT_R <= '0';

                  when "0110" => -- S = not B
                      S(7 downto 4) <= (others => '0');
                      S(3 downto 0) <= not B;
                      SR_OUT_L <= '0';
                      SR_OUT_R <= '0';

                  when "0111" => -- S = A and B
                      S(7 downto 4) <= (others => '0');
                      S(3 downto 0) <= A and B;
                      SR_OUT_L <= '0';
                      SR_OUT_R <= '0';

                  when "1000" => -- S = A or B
                      S(7 downto 4) <= (others => '0');
                      S(3 downto 0) <= A or B;
                      SR_OUT_L <= '0';
                      SR_OUT_R <= '0';

                  when "1001" => -- S = A xor B
                      S(7 downto 4) <= (others => '0');
                      S(3 downto 0) <= A xor B;
                      SR_OUT_L <= '0';
                      SR_OUT_R <= '0';

                  when "1010" => -- S = A + B, SR_IN_R = retenue d'entrée
                      A_var(3 downto 0) := A;
                      A_var(7 downto 4) := (others => A(3));
                      B_var(3 downto 0) := B;
                      B_var(7 downto 4) := (others => B(3));
                      S_var := A_var + B_var;
                      S_var := S_var + ("00000000" & SR_IN_R);
                      S <= S_var;
                      SR_OUT_L <= '0';
                      SR_OUT_R <= '0';

                  when "1011" => -- S = A + B, pas de retenue d'entrée
                      A_var(3 downto 0) := A;
                      A_var(7 downto 4) := (others => A(3));
                      B_var(3 downto 0) := B;
                      B_var(7 downto 4) := (others => B(3));
                      S_var := A_var + B_var;
                      S <= S_var;
                      SR_OUT_L <= '0';
                      SR_OUT_R <= '0';

                  when "1100" => -- S = A - B binaire
                      A_var(3 downto 0) := A;
                      A_var(7 downto 4) := (others => A(3));
                      B_var(3 downto 0) := B;
                      B_var(7 downto 4) := (others => B(3));
                      S_var := A_var - B_var;
                      S <= S_var;
                      SR_OUT_L <= '0';
                      SR_OUT_R <= '0';

                  when "1101" => -- S = A * B
                      S <= A * B;
                      SR_OUT_L <= '0';
                      SR_OUT_R <= '0';

                  when "1110" => -- S = décallage à droite A sur 4 bits, SR_IN_L bit entrant
                      S(7 downto 4) <= (others => '0');
                      S(3) <= SR_IN_L;
                      S(2 downto 0) <= A(3 downto 1);
                      SR_OUT_R <= A(0);
                      SR_OUT_L <= '0';

                  when "1111" => -- S = décallage à gauche A sur 4 bits, SR_IN_R bit entrant
                      S(7 downto 4) <= (others => '0');
                      S(0) <= SR_IN_R;
                      S(3 downto 1) <= A(2 downto 0);
                      SR_OUT_L <= A(3);
                      SR_OUT_R <= '0';

                  when others =>
                  	S <= "00000000";
                      SR_OUT_L <= '0';
                      SR_OUT_R <= '0';
              end case;
        end process;
end arch_ALUCompo;

