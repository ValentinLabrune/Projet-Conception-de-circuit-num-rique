library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity selroute is
    Port ( 
        -- Sel route
        Buf_A_out : in STD_LOGIC_VECTOR (3 downto 0);
        Buf_B_out : in STD_LOGIC_VECTOR (3 downto 0);
        Mem_1_out : in STD_LOGIC_VECTOR (7 downto 0);
        Mem_2_out : in STD_LOGIC_VECTOR (7 downto 0);
        Buf_A_in : out STD_LOGIC_VECTOR (3 downto 0);
        Buf_B_in : out STD_LOGIC_VECTOR (3 downto 0);
        Mem_1_In : out STD_LOGIC_VECTOR (7 downto 0);
        Mem_2_In : out STD_LOGIC_VECTOR (7 downto 0);
        S : in STD_LOGIC_VECTOR (7 downto 0);
        CE_Buf_A : out STD_LOGIC;
        CE_Buf_B : out STD_LOGIC;
        CE_Mem_1 : out STD_LOGIC;
        CE_Mem_2 : out STD_LOGIC  
    
    );
end selroute;

architecture selroute_Arch of selroute is
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

        component mem8bits
        generic ( N : integer);
        port(
                e1 : in std_logic_vector (N-1 downto 0);
                ce : in std_logic;
                reset : in std_logic;
                preset : in std_logic;
                clock : in std_logic;
                s1 : out std_logic_vector (N-1 downto 0)
        ); end component;
        signal mem8bits_s1 : std_logic_vector (N-1 downto 0)

        component mem4bits
        generic ( N : integer);
        port(
                e1 : in std_logic_vector (N-1 downto 0);
                reset : in std_logic;
                preset : in std_logic;
                ce : in std_logic;
                clock : in std_logic;
                s1 : out std_logic_vector (N-1 downto 0)
        ); end component;
        signal mem4bits_s1 : std_logic_vector (N-1 downto 0)

begin
        BufferA : Buffer4Bits 
        generic map (N => 4)
        port(
                e1 => Buf_A_in;
                reset => '0';
                preset => '0';
                ce => CE_Buf_A;
                clock => '0';
                s1 => BufferA_out
        );

        BufferB : Buffer4Bits
        generic map (N => 4)
        port(
                e1 => Buf_B_in;
                reset => '0';
                preset => '0';
                ce => CE_Buf_B;
                clock => '0';
                s1 => BufferB_out
        );

        Mem_1 : mem8bits
        generic map (N => 8)
        port(
                e1 => Mem_1_In;
                reset => '0';
                preset => '0';
                ce => CE_Mem_1;
                clock => '0';
                s1 => Mem_1_out
        );

        Mem_2 : mem8bits
        generic map (N => 8)
        port(
                e1 => Mem_2_In;
                reset => '0';
                preset => '0';
                ce => CE_Mem_2;
                clock => '0';
                s1 => Mem_2_out
        );

        

    MySelRouteProc : process (SEL_ROUTE, S, A, B, Buf_A_out, Buf_B_out, Mem_1_out, Mem_2_out)
    begin
        
        case SEL_ROUTE is

		when "0000" => -- Stockage de S dans MEM_CACHE_1
                CE_Buf_A <= '0'; CE_Buf_B <= '0'; CE_Mem_1 <= '1'; CE_Mem_2 <= '0';
                Buf_A_in <= (others => '0'); Buf_B_in <= (others => '0'); Mem_1_In <= S; Mem_2_In <= (others => '0');

                when "0001" => -- Stockage de MEM_CACHE_2 dans Buffer_A (4 bits de poids faibles)
                CE_Buf_A <= '1'; CE_Buf_B <= '0'; CE_Mem_1 <= '0'; CE_Mem_2 <= '0';
                Buf_A_in <= Mem_2_out(3 downto 0); Buf_B_in <= (others => '0'); Mem_1_In <= (others => '0'); Mem_2_In <= (others => '0');

		when "0010"  => -- Stockage de MEM_CACHE_2 dans Buffer_A (4 bits de poids fort)
                CE_Buf_A <= '1'; CE_Buf_B <= '0'; CE_Mem_1 <= '0'; CE_Mem_2 <= '0';
                Buf_A_in <= Mem_2_out(7 downto 4); Buf_B_in <= (others => '0'); Mem_1_In <= (others => '0'); Mem_2_In <= (others => '0');

		when "0011"  => -- Stockage de MEM_CACHE_1 dans Buffer_A (4 bits de poids faible)
                CE_Buf_A <= '1'; CE_Buf_B <= '0'; CE_Mem_1 <= '0'; CE_Mem_2 <= '0';
                Buf_A_in <= Mem_1_out(3 downto 0); Buf_B_in <= (others => '0'); Mem_1_In <= (others => '0'); Mem_2_In <= (others => '0');
            
                when "0100" => -- Stockage de MEM_CACHE_1 dans Buffer_A (4 bits de poids forts)
                CE_Buf_A <= '1'; CE_Buf_B <= '0'; CE_Mem_1 <= '0'; CE_Mem_2 <= '0';
                Buf_A_in <= Mem_1_out(7 downto 4); Buf_B_in <= (others => '0'); Mem_1_In <= (others => '0'); Mem_2_In <= (others => '0');
		
                when "0101" => -- Stockage de S dans Buffer_A (4 bits de poids faibles)
                CE_Buf_A <= '1'; CE_Buf_B <= '0'; CE_Mem_1 <= '0'; CE_Mem_2 <= '0';
                Buf_A_in <= S(3 downto 0); Buf_B_in <= (others => '0'); Mem_1_In <= (others => '0'); Mem_2_In <= (others => '0');

                when "0110" => -- Stockage de S dans Buffer_A (4 bits de poids forts)
                CE_Buf_A <= '1'; CE_Buf_B <= '0'; CE_Mem_1 <= '0'; CE_Mem_2 <= '0';
                Buf_A_in <= S(7 downto 4); Buf_B_in <= (others => '0'); Mem_1_In <= (others => '0'); Mem_2_In <= (others => '0');

		when "0111" => -- Stockage de l'entree A_IN dans Buffer_A
                CE_Buf_A <= '1'; CE_Buf_B <= '0'; CE_Mem_1 <= '0'; CE_Mem_2 <= '0';
                Buf_A_in <= A; Buf_B_in <= (others => '0'); Mem_1_In <= (others => '0'); Mem_2_In <= (others => '0'); 
            
		when "1000" => -- Stockage de S dans MEM_CACHE_2
                CE_Buf_A <= '0'; CE_Buf_B <= '0'; CE_Mem_1 <= '0'; CE_Mem_2 <= '1';
                Buf_A_in <= (others => '0'); Buf_B_in <= (others => '0'); Mem_1_In <= (others => '0'); Mem_2_In <= S;

                when "1001" => -- Stockage de MEM_CACHE_2 dans Buffer_B (4 bits de poids faibles)
                CE_Buf_A <= '0'; CE_Buf_B <= '1'; CE_Mem_1 <= '0'; CE_Mem_2 <= '0';
                Buf_A_in <= (others => '0'); Buf_B_in <= Mem_1_out(3 downto 0); Mem_1_In <= (others => '0'); Mem_2_In <= (others => '0');

		when "1010" -- Stockage de MEM_CACHE_2 dans Buffer_B (4 bits de poids forts)
                CE_Buf_A <= '0'; CE_Buf_B <= '1'; CE_Mem_1 <= '0'; CE_Mem_2 <= '0';
                Buf_A_in <= (others => '0'); Buf_B_in <= Mem_1_out(7 downto 4); Mem_1_In <= (others => '0'); Mem_2_In <= (others => '0');

                when "1011" => -- Stockage de MEM_CACHE_1 dans Buffer_B (4 bits de poids faibles)
                CE_Buf_A <= '0'; CE_Buf_B <= '1'; CE_Mem_1 <= '0'; CE_Mem_2 <= '0';
                Buf_A_in <= (others => '0'); Buf_B_in <= Mem_1_out(3 downto 0); Mem_1_In <= (others => '0'); Mem_2_In <= (others => '0');

		when "1100" => -- Stockage de MEM_CACHE_1 dans Buffer_B (4 bits de poids fort)
                CE_Buf_A <= '0'; CE_Buf_B <= '1'; CE_Mem_1 <= '0'; CE_Mem_2 <= '0';
                Buf_A_in <= (others => '0'); Buf_B_in <= Mem_1_out(7 downto 4); Mem_1_In <= (others => '0'); Mem_2_In <= (others => '0');
            
                when "1101" => -- Stockage de S dans Buffer_B (4 bits de poids faibles)
                CE_Buf_A <= '0'; CE_Buf_B <= '1'; CE_Mem_1 <= '0'; CE_Mem_2 <= '0';
                Buf_A_in <= (others => '0'); Buf_B_in <= S(3 downto 0); Mem_1_In <= (others => '0'); Mem_2_In <= (others => '0');
            
                when "1110" => -- Stockage de S dans Buffer_B (4 bits de poids forts)
                CE_Buf_A <= '0'; CE_Buf_B <= '1'; CE_Mem_1 <= '0'; CE_Mem_2 <= '0';
                Buf_A_in <= (others => '0'); Buf_B_in <= S(7 downto 4); Mem_1_In <= (others => '0'); Mem_2_In <= (others => '0');
            
                when "1111"  => -- Stockage de l'entree B_IN dans Buffer_B
                CE_Buf_A <= '0'; CE_Buf_B <= '1'; CE_Mem_1 <= '0'; CE_Mem_2 <= '0';
                Buf_A_in <= (others => '0'); Buf_B_in <= B; Mem_1_In <= (others => '0'); Mem_2_In <= (others => '0');  

        end case;

    end process;

end selroute_Arch;