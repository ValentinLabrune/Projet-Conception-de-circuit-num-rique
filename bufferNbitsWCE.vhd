library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity bufferNbitsWCE is -- buffer N bits with chip enabler
    generic(
        N : integer
    );
    port (
        e : in std_logic_vector (N-1 downto 0);
        ce : in std_logic;
        reset : in std_logic;
        clock : in std_logic;
        s : out std_logic_vector (N-1 downto 0)
    );
end bufferNbitsWCE;

architecture bufferNbitsWCE_Arch of bufferNbitsWCE is

    signal my_e : std_logic_veactor(N-1 downto 0);
    signal my_ce : std_logic;
    signal my_reset, my_clock : std_logic;
    signal my_s : std_logic_vector (N-1 downto 0);


    begin
        
        BufferNbitsProc : process (reset, clock)
        begin 
            if (reset = '1') then
                s <= (others => '0');
            elsif (rising_edge(clock) and my_ce = '1') then
                s <= e;
            end if;
        end process;

end bufferNbitsWCE_Arch;

