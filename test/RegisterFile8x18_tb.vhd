library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity RegisterFile8x18_tb is
end;

architecture bench of RegisterFile8x18_tb is

  component RegisterFile8x18
  	 port(
  		 Reset : in STD_LOGIC;
  		 RgFileRW : in STD_LOGIC;
  		 clk : in STD_LOGIC;
  		 RgMask : in STD_LOGIC_VECTOR(1 downto 0);
  		 PortC : in STD_LOGIC_VECTOR(17 downto 0);
  		 AddrA : in STD_LOGIC_VECTOR(2 downto 0);
  		 AddrB : in STD_LOGIC_VECTOR(2 downto 0);
  		 AddrC : in STD_LOGIC_VECTOR(2 downto 0);
  		 PortB_RF : out STD_LOGIC_VECTOR(17 downto 0);
  		 PortA_RF : out STD_LOGIC_VECTOR(17 downto 0)
  	     );
  end component;

  signal Reset: STD_LOGIC;
  signal RgFileRW: STD_LOGIC;
  signal clk: STD_LOGIC;
  signal RgMask: STD_LOGIC_VECTOR(1 downto 0);
  signal PortC: STD_LOGIC_VECTOR(17 downto 0);
  signal AddrA: STD_LOGIC_VECTOR(2 downto 0);
  signal AddrB: STD_LOGIC_VECTOR(2 downto 0);
  signal AddrC: STD_LOGIC_VECTOR(2 downto 0);
  signal PortB_RF: STD_LOGIC_VECTOR(17 downto 0);
  signal PortA_RF: STD_LOGIC_VECTOR(17 downto 0) ;

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  uut: RegisterFile8x18 port map ( Reset    => Reset,
                                   RgFileRW => RgFileRW,
                                   clk      => clk,
                                   RgMask   => RgMask,
                                   PortC    => PortC,
                                   AddrA    => AddrA,
                                   AddrB    => AddrB,
                                   AddrC    => AddrC,
                                   PortB_RF => PortB_RF,
                                   PortA_RF => PortA_RF );

  stimulus: process
  begin
  
    -- Put initialisation code here
	Reset <= '1';
	wait for clock_period;

    -- Put test bench stimulus code here
	Reset <= '0';
	RgFileRW <= '1';
	RgMask <= "00";
	PortC <= "000111011000000100";
	AddrC <= "011";
	wait for clock_period;

    stop_the_clock <= true;
    wait;
  end process;

  clocking: process
  begin
    while not stop_the_clock loop
      clk <= '0', '1' after clock_period / 2;
      wait for clock_period;
    end loop;
    wait;
  end process;

end;
