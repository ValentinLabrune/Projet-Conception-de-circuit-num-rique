library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_signed.all;

entity BufferNbitsWBCETestbench is
end BufferNbitsWBCETestbench;

architecture BufferNbitsWCETestbench_Arch of BufferNbitsWCETestbench is

    component bufferNbitsWCE is
        generic (N : integer);
        port(
            e : in std_logic_vector (N-1 downto 0);
            ce : in std_logic;
            clock : in std_logic;
            reset : in std_logic;
            s : out std_logic_vector (N-1 downto 0)
        );
    end component;

        signal my_e : std_logic_vector (1 downto 0);
        signal my_ce : std_logic;
        signal my_clock, my_reset : std_logic;
        signal my_s : std_logic_vector (1 downto 0);

begin

    BuffNbitsWCE_inst : bufferNbitsWCE
        generic map (N => 2)
        port map(
            e => my_e,
            ce => my_ce,
            clock => my_clock,
            reset => my_reset,
            s => my_s
        );


    BuffNbitsWCEProc : process
    begin
        -- initialisation
        my_ce = '0';
        my_reset = '1';
        wait for 5 ns;
        my_reset = '0';
        wait for 5 ns;

        -- test 1
        my_e = "11";
        my_clock = '0';
        wait for 5 ns;
        my_clock = '1';
        wait for 5 ns;
        report " | E =" & integer'image(to_integer(unsigned(my_e))) & " | CE = " & std_logic'image(my_ce) & " | clock = " & std_logic'image(my_clock)  & " | reset = " & std_logic'image(my_reset) & " | s = " & integer'image(to_integer(unsigned(my_s)));
        wait for 5 ns;

        -- test 2
        my_clock = '0';
        wait for 5 ns;
        my_ce = '1';
        wait for 5 ns;
        my_clock = '1';
        wait for 5 ns;
        report " | E =" & integer'image(to_integer(unsigned(my_e))) & " | CE = " & std_logic'image(my_ce) & " | clock = " & std_logic'image(my_clock)  & " | reset = " & std_logic'image(my_reset) & " | s = " & integer'image(to_integer(unsigned(my_s)));
        wait;

    end process;

end BufferNbitsWCETestbench_Arch;



