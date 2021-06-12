library IEEE;
use IEEE.std_logic_1164.all;

entity MUX_A is
	 port(
		 Select_MUXA : in STD_LOGIC;
		 PortA_RF : in STD_LOGIC_VECTOR(17 downto 0);
		 MR_Out : in STD_LOGIC_VECTOR(17 downto 0);
		 OutA : out STD_LOGIC_VECTOR(17 downto 0)
	     );
end MUX_A;

architecture MUX_A_arc of MUX_A is
begin
	with Select_MUXA select
	OutA <= PortA_RF when '0',
			MR_Out when '1',
			(others => '0') when others;
end MUX_A_arc;
