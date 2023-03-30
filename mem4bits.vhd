entity mem4bits is
    generic (
        N : integer := 4
    );
    port (
        e1 : in std_logic_vector (N-1 downto 0);
        reset : in std_logic;
        preset : in std_logic;
        ce : in std_logic;
        clock : in std_logic;
        s1 : out std_logic_vector (N-1 downto 0)
    );
end mem4bits;

architecture mem4bits_Arch of mem4bits is

    begin
        -- process explicite - instructions séquentielle
        mem4bitsProc : process (reset, clock)
        begin 
            if (reset = '1') then
                s1 <= (others => '0');
            elsif (rising_edge(clock)) and (ce = 1)then
                if (preset = '1') then
                    s1 <= (others => '1');
                else
                    s1 <= e1;
                end if;
            end if;
        end process;

end mem4bits_Arch;