library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity BigUnit is
    port(
        -- entrées
        A_IN : in std_logic_vector (3 downto 0);
        B_IN : in std_logic_vector (3 downto 0);
        SR_IN_L_G : in std_logic;
        SR_IN_R_G : in std_logic;

        -- SEL
        SEL_FCT_IN : in std_logic_vector (3 downto 0);
        SEL_ROUTE_IN : in std_logic_vector (3 downto 0);
        SEL_OUT_IN : in std_logic_vector (1 downto 0);

        -- others 
        clock_IN : in std_logic;
        reset_IN : in std_logic;

        -- sorties
        SR_OUT_L_G : out std_logic;
        SR_OUT_R_G : out std_logic;
        RES_OUT_G : out std_logic_vector (7 downto 0)
    );
end BigUnit;

architecture BigUnit_Arch of BigUnit is

    -- components 

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

    component bufferNbits is 
        generic(
            N : integer
        );
        port(
            e : in std_logic_vector(N-1 downto 0);
            reset : in std_logic;
            clock : in std_logic;
            s : out std_logic_vector(N-1 downto 0)
        );
    end component;

    -- liste signaux
    -- Buffers : A, B, SR_IN_L, SR_IN_R
    signal My_BufferA_IN, My_BufferB_IN : std_logic_vector (3 downto 0);
    signal My_BufferA_OUT, My_BufferB_OUT : std_logic_vector (3 downto 0);
    signal My_BufferSR_IN_L_OUT, My_BufferSR_IN_R_OUT : std_logic_vector (0 downto 0);

    -- Memoire : Mem_cache1, Mem_cache2 
    signal My_Mem_cache1_IN, My_Mem_cache2_IN : std_logic_vector (7 downto 0);
    signal My_Mem_cache1_OUT, My_Mem_cache2_OUT : std_logic_vector (7 downto 0);

    -- ALU
    signal My_A, My_B : std_logic_vector (3 downto 0);
    signal My_SR_IN_L, My_SR_IN_R : std_logic;
    signal My_SR_OUT_L, My_SR_OUT_R : std_logic;
    signal My_RES_OUT_G : std_logic_vector (7 downto 0);
    

    begin

        BufferA : bufferNbits
            generic map (N => 4)
            port map(
                e => My_BufferA_IN,
                reset => reset_IN,
                clock => clock_IN,
                s => My_BufferA_OUT
            );
        
        BufferB : bufferNbits
            generic map (N => 4)
            port map(
                e => My_BufferB_IN,
                reset => reset_IN,
                clock => clock_IN,
                s => My_BufferB_OUT
            );

        BufferSR_L : bufferNbits
            generic map (N => 1)
            port map(
                e(0) => SR_IN_L_G,
                reset => reset_IN,
                clock => clock_IN,
                s => My_BufferSR_IN_L_OUT 
            );

        BufferSR_R : bufferNbits
            generic map (N => 1)
            port map(
                e(0) => SR_IN_R_G,
                reset => reset_IN,
                clock => clock_IN,
                s => My_BufferSR_IN_R_OUT
            );

        Mem_cache1 : bufferNbits
            generic map (N => 8)
            port map(
                e => My_Mem_cache1_IN,
                reset => reset_IN,
                clock => clock_IN,
                s => My_Mem_cache1_OUT
            );

        Mem_cache2 : bufferNbits
            generic map (N => 8)
            port map(
                e => My_Mem_cache2_IN,
                reset => reset_IN,
                clock => clock_IN,
                s => My_Mem_cache2_OUT
            );

        ALU : ALUCompo
            port map(
                A => My_A,
                B => My_B,
                SR_IN_L => My_SR_IN_L,
                SR_IN_R => My_SR_IN_R,
                SEL_FCT => SEL_FCT_IN,
                S => My_RES_OUT_G,
                SR_OUT_L => My_SR_OUT_L,
                SR_OUT_R => My_SR_OUT_R
            );
        
        -- assignation des signaux
        My_A <= My_BufferA_OUT;
        My_B <= My_BufferB_OUT;
        My_SR_IN_L <= My_BufferSR_IN_L_OUT(0);
        My_SR_IN_R <= My_BufferSR_IN_R_OUT(0);

        routingProc : process(clock_IN, reset_IN)
        begin
            if (rising_edge(clock_IN)) then
                case SEL_ROUTE_IN is
                    when "0000" => -- stockage de S dans Mem_Cache1
                        My_Mem_cache1_IN <= My_RES_OUT_G;

                        -- stockage dans bufferA
                    when "0001" => -- stockage de Mem_Cache2 dans bufferA (4 bits de poids faibles)
                        My_BufferA_IN <= My_Mem_cache2_OUT(3 downto 0);
                    when "0010" => -- stockage de Mem_Cache2 dans bufferA (4 bits de poids forts)
                        My_BufferA_IN <= My_Mem_cache2_OUT(7 downto 4);
                    when "0011" => -- stockage de Mem_Cache1 dans buffer A (4 bits de poids faibles)
                        My_BufferA_IN <= My_Mem_cache1_OUT(3 downto 0);
                    when "0100" =>  -- stockage de Mem_Cache1 dans BufferA (4 bits de poids forts)
                        My_BufferA_IN <= My_Mem_cache1_OUT(7 downto 4);
                    when "0101" => -- stockage de S dans bufferA (4 bits de poids faibles)
                        My_BufferA_IN <= My_RES_OUT_G(3 downto 0);
                    when "0110" => -- stockage de S dans BufferA (4 bits de poids forts) 
                        My_BufferA_IN <= My_RES_OUT_G(7 downto 4);
                    when "0111" => -- stockage de A_IN dans BufferA
                        My_BufferA_IN <= A_IN;

                    when "1000" => -- stockage de S dans Mem_Cache2
                        My_Mem_cache2_IN <= My_RES_OUT_G;

                    when "1001" => -- stockage de Mem_cache2 dans BufferB ( 4 bits de poids faibles)
                        My_BufferB_IN <= My_Mem_cache2_OUT(3 downto 0);
                    when "1010" => -- stockage de Mem_cache2 dans BufferB ( 4 bits de poids forts)
                        My_BufferB_IN <= My_Mem_cache2_OUT(7 downto 4);
                    when "1011" => -- stockage de Mem_cache1 dans BufferB ( 4 bits de poids faibles)
                        My_BufferB_IN <= My_Mem_cache1_OUT(3 downto 0);
                    when "1100" => -- stockage de Mem_cache1 dans BufferB ( 4 bits de poids forts)
                        My_BufferB_IN <= My_Mem_cache1_OUT(7 downto 4);
                    when "1101" => -- stockage de S dans BufferB (4 bits de poids faibles)
                        My_BufferB_IN <= My_RES_OUT_G(3 downto 0);
                    when "1110" => -- stockage de S dans BufferB (4 bits de poids forts)
                        My_BufferB_IN <= My_RES_OUT_G(7 downto 4);
                    when "1111" => -- stockage de B_IN dans BufferB
                        My_BufferB_IN <= B_IN;
                    when others =>

                end case;
            end if;
            if rising_edge(clock_IN) then
                case SEL_OUT_IN is 
                    when "00" => -- RES_OUT = 0
                        RES_OUT_G <= (others => '0');
                    when "01" => -- RES_OUT = Mem_cache1
                        RES_OUT_G <= My_Mem_cache1_OUT;
                    when "10" => -- RES_OUT = Mem_Cache2 
                        RES_OUT_G <= My_Mem_cache2_OUT;
                    when "11" => -- RES_OUT = 0
                        RES_OUT_G <= My_RES_OUT_G;
                    when others =>
                end case;
            end if;
        end process;

    end BigUnit_Arch;
