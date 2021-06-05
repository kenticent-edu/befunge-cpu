library ieee;
use ieee.std_logic_1164.all;

entity tb_befunge_cpu is
end tb_befunge_cpu;

architecture tb of tb_befunge_cpu is

    component befunge_cpu
        port (Reset    : in std_logic;
              clk      : in std_logic;
              PortC    : in std_logic_vector (17 downto 0);
              VC_Out   : in std_logic_vector (17 downto 0);
              MR_Out   : in std_logic_vector (17 downto 0);
              lliteral : out std_logic_vector (8 downto 0));
    end component;

    signal Reset    : std_logic;
    signal clk      : std_logic;
    signal PortC    : std_logic_vector (17 downto 0);
    signal VC_Out   : std_logic_vector (17 downto 0);
    signal MR_Out   : std_logic_vector (17 downto 0);
    signal lliteral : std_logic_vector (8 downto 0);

    constant TbPeriod : time := 10 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : befunge_cpu
    port map (Reset    => Reset,
              clk      => clk,
              PortC    => PortC,
              VC_Out   => VC_Out,
              MR_Out   => MR_Out,
              lliteral => lliteral);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        PortC <= (others => '0');
        VC_Out <= (others => '0');
        MR_Out <= (others => '0');

        -- Reset generation
        -- EDIT: Check that Reset is really your reset signal
        Reset <= '1';
        wait for 100 ns;
        Reset <= '0';
        wait for 100 ns;

        -- EDIT Add stimuli here
        wait for 100 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_befunge_cpu of tb_befunge_cpu is
    for tb
    end for;
end cfg_tb_befunge_cpu;