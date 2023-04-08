library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALUCompo is
port(

    BuffA : in std_logic_vector(3 downto 0);
    BuffB : in std_logic_vector(3 downto 0);
    SR_IN : in std_logic_vector(1 downto 0);
    SEL_FCT_MEM : in std_logic_vector(3 downto 0);

    CLK : in std_logic;
    RESET : in std_logic;

    S_OUT : out std_logic_vector(7 downto 0);
    SR_OUT : out std_logic_vector(1 downto 0)
);
end ALUCompo;

architecture arch_ALUCompo of ALUCompo is
    signal BuffA, BuffB : signed(3 downto 0);
    signal S_OUT : signed(7 downto   0);
    signal carry_in, carry_out : std_logic;

   begin

        ALUProc : process(BuffA, BuffB, SR_IN, SEL_FCT_MEM, CLK, RESET)
        begin
            -- if RESET = '1' then
            -- SR_OUT(0) <= '0';
            -- SR_OUT(1) <= '0';
            -- S_OUT <= (others => '0');
            -- carry_in <= '0';
            -- S_OUT <= (others => '0');
            -- elsif rising_edge(CLK) then
            case SEL_FCT_MEM is
                when "0000" => -- no op
                S_OUT <= '0';
                when "0001" => -- shift right B
                    SR_OUT(1) = BuffB(0);
                    S_OUT(2 downto 0) <= BuffB (3 downto 1)
                    S_OUT(3) =  SR_IN(0)
                    SR_OUT(0) <= '0';
                    
                when "0010" => -- shift left B
                    SR_OUT(0) = BuffB(3);
                    S_OUT(3 downto 1) <= BuffB (2 downto 0)
                    S_OUT(0) = SR_IN(1)
                    SR_OUT(1) <= '0';

                when "0011" => -- A 
                    S_OUT <= BuffA;
                    SR_OUT(0) <= '0';
                    SR_OUT(1) <= '0';
                
                when "0100" => -- B
                    S_OUT <= BuffB;
                    SR_OUT(0) <= '0';
                    SR_OUT(1) <= '0';
                
                when "0101" => -- not A
                    S_OUT <= not BuffA;
                    SR_OUT(0) <= '0';
                    SR_OUT(1) <= '0';
                
                when "0110" => -- not B
                    S_OUT <= not BuffB;
                    SR_OUT(0) <= '0';
                    SR_OUT(1) <= '0';
                
                when "0111" => -- A and B
                    S_OUT <= BuffA and BuffB;
                    SR_OUT(0) <= '0';
                    SR_OUT(1) <= '0';
                
                when "1000" => -- A or B
                    S_OUT <= BuffA or BuffB;
                    SR_OUT(0) <= '0';
                    SR_OUT(1) <= '0';
                
                when "1001" => -- A xor B
                    S_OUT <= BuffA xor BuffB;
                    SR_OUT(0) <= '0';
                    SR_OUT(1) <= '0';
                
                when "1010"=> -- A + B with carry in
                    carry_out <= BuffA(0) and BuffB(0);
                    S_OUT <= BuffA + BuffB + unsigned(carry_in);
                    SR_OUT(0) <= '0';
                    SR_OUT(1) <= '0';
                
                when "1011" => -- addition binaire sans retenue d’entrée
                    S_OUT <= BuffA + BuffB;
                    SR_OUT(0) <= '0';
                    SR_OUT(1) <= '0';
                
                when "1100"=> -- soustraction binaire
                    S_OUT <= BuffA - BuffB;
                    SR_OUT(0) <= '0';
                    SR_OUT(1) <= '0';

                when "1101" => -- multiplication binaire
                    S_OUT <= BuffA * BuffB;
                    SR_OUT(0) <= '0';
                    SR_OUT(1) <= '0';

                when "1110"=> -- Déc. droite A sur 4 bits(avec  SR_IN(0))
                    SR_OUT(1) = BuffA(0);
                    S_OUT(2 downto 0) <= BuffA (3 downto 1)
                    S_OUT(3) =  SR_IN(0)
                    SR_OUT(0) <= '0';

                when "1111"=> -- Déc. gauche A sur 4 bits (avec SR_IN(1))
                    SR_OUT(0) = BuffA(3);
                    S_OUT(3 downto 1) <= BuffA (2 downto 0)
                    S_OUT(0) = SR_IN(1)
                    SR_OUT(1) <= '0';
                end case;
            end if;
            S_OUT <= SR_OUT(1) & SR_OUT(0);
        end process;
end arch_ALUCompo;

