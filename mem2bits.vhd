
entity mem2bitsbits is
    generic (
        N : integer := 1
    );
    port (
        e1 : in std_logic_vector (N-1 downto 0);
        e2 : in std_logic_vector (N-1 downto 0);
        reset : in std_logic;
        ce : in std_logic;
        preset : in std_logic;
        clock : in std_logic;
        s1 : out std_logic_vector (N-1 downto 0)
    );
end mmem2bits;

architecture mem2bits_Arch of mem2bits is

    begin
        -- process explicite - instructions séquentielle
        mem2bitsProc : process (reset, clock)
        begin 
            if (reset = '1') then
                s1 <= (others => '0');
            elsif (rising_edge(clock)) and (ce = 1) then
                if (preset = '1') then
                    s1 <= (others => '1');
                else
                    s1(1) <= e1;
                    s1(0) <= e2;
                end if;
            end if;
        end process;

end mem2bits_Arch;