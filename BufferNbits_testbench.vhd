library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_signed.all;

entity BufferNbitsTestbench is
end BufferNbitsTestbench;

architecture BufferNbitsTestbench_Arch of BufferNbitsTestbench is

    component bufferNbits is
        generic(N : integer);
        port(
            e : in std_logic_vector (N-1 downto 0);
            clock: in std_logic;
            reset: in std_logic;
            s : out std_logic_vector (N-1 downto 0)
        );
    end component;

    signal my_e : std_logic_vector (1 downto 0);
    signal my_clock, my_reset : std_logic;
    signal my_s : std_logic_vector (1 downto 0);

begin

    buffNbits_inst : bufferNbits
        generic map (N => 2)
        port map(
            e => my_e,
            clock => my_clock,
            reset => my_reset,
            s => my_s
        );
        
    

    BuffNbitsProc : process
    begin
        -- initialisation 
        my_reset <= '1';
        wait for 1 ns;
        my_reset <= '0';
        wait for 1 ns;

        -- test 1
        my_clock <= '0';
        my_e <= "11";
        wait for 1 ns;
        my_clock <= '1';
        wait for 1 ns;
        report " | E =" & integer'image(to_integer(unsigned(my_e))) & " | clock = " & std_logic'image(my_clock)  & " | reset = " & std_logic'image(my_reset) & " | s = " & integer'image(to_integer(unsigned(my_s)));
        wait;

    end process;

end BufferNbitsTestbench_Arch;
