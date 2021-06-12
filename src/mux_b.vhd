library IEEE;
use IEEE.std_logic_1164.all;

entity MUX_B is
	 port(
		 VC_Out : in STD_LOGIC_VECTOR(17 downto 0);
		 PortB_RF : in STD_LOGIC_VECTOR(17 downto 0);
		 Select_MUXB : in STD_LOGIC_VECTOR(1 downto 0);
		 OutB : out STD_LOGIC_VECTOR(17 downto 0)
	     );
end MUX_B;

architecture MUX_B_arc of MUX_B is
begin
	with Select_MUXB select
	OutB <= VC_Out when "00",
			PortB_RF when "01",
			(others => '0') when others;
end MUX_B_arc;
