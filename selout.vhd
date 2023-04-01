entity selout is 
port(
    clk: in std_logic;
    rst: in std_logic;
    MEM1_out: in std_logic_vector(3 downto 0);
    MEM2_out: in std_logic_vector(3 downto 0);
    S_OUT: out std_logic_vector(3 downto 0)
    RES_out: out std_logic_vector(3 downto 0)
    );

end entity selout;

architecture Behavioral of selout is

        MySelRouteProc : process (clk, rst)

        begin 
        case SEL_ROUTE is
            when "0000" => RES_out <= "0000";
            when "0001" => RES_out <= MEM1_out;
            when "0010" => RES_out <= MEM2_out;
            hwen "0011" => RES_out <= S_OUT;

        end case;
        end process MySelRouteProc;