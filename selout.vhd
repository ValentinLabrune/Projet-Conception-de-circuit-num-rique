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
    component calculunite
    port(
  SR_IN_L_buff, SR_IN_R_buff, CLK, RESET : in std_logic;
  Buffer_A_IN, Buffer_B_IN,Buffer_A_OUT, Buffer_B_OUT,  SEL_FCT_mem, SEL_ROUTE: in std_logic_vector(3 downto 0);
  ce_Buff_A, ce_Buff_B, ce_Buff_SR_IN, ce_Buff_SR_OUT : in std_logic;
  SR_OUT_L, SR_OUT_R : out std_logic;
  S : out std_logic_vector(7 downto 0)
);

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

    begin

        ALU : calculunite
        port map(S => S_out);

        MEM1 : mem8bits
        generic map(N => 8)
        port map(
            s1 => MEM1_out
        );

        MEM2 : mem8bits
        generic map(N => 8)
        port map(
            s1 => MEM2_out
        );

        MySelRouteProc : process (clk, rst)

        begin 
        case SEL_ROUTE is
            when "0000" => RES_out <= "0000";
            when "0001" => RES_out <= MEM1_out;
            when "0010" => RES_out <= MEM2_out;
            hwen "0011" => RES_out <= S_OUT;

        end case;
        end process MySelRouteProc;
        



