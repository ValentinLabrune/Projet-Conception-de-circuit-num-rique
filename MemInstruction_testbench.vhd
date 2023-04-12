library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_signed.all;

entity MemInstructionTestbench is
end MemInstructionTestbench;

architecture MemInstructionTestbench_Arch of MemInstructionTestbench is

    component MemInstruction is
        port(
            clock_IN : in std_logic;
            reset_IN : in std_logic;

            SEL_FCT_OUT : out std_logic_vector (3 downto 0);
            SEL_ROUTE_OUT : out std_logic_vector (3 downto 0);
            SEL_OUT_OUT : out std_logic_vector (1 downto 0)
        );
    end component MemInstruction;

    signal My_clock_IN, my_reset_IN : std_logic;
    signal My_SEL_FCT_OUT, My_SEL_ROUTE_OUT : std_logic_vector (3 downto 0);
    signal My_SEL_OUT_OUT : std_logic_vector (1 downto 0);

    begin

        MemInstructionUnderTest : MemInstruction
            port map(
                clock_IN => My_clock_IN,
                reset_IN => my_reset_IN,

                SEL_FCT_OUT => My_SEL_FCT_OUT,
                SEL_ROUTE_OUT => My_SEL_ROUTE_OUT,
                SEL_OUT_OUT => My_SEL_OUT_OUT
            );

        MemInstructionProc : process
        begin
            My_clock_IN <= '0';
            wait for 10 ns;
            My_clock_IN <= '1';
            wait for 10 ns;
            report "SEL FCT = " & integer'image(to_integer(unsigned(My_SEL_FCT_OUT)));
            report "SEL ROUTE = " & integer'image(to_integer(unsigned(My_SEL_ROUTE_OUT)));
            report "SEL OUT = " & integer'image(to_integer(unsigned(My_SEL_OUT_OUT)));
            wait;
        end process MemInstructionProc;

    end MemInstructionTestbench_Arch;