library IEEE;
use IEEE.std_logic_1164.all;

entity mux_2_1 is
	 port(
		 SEL : in STD_LOGIC;
		 A : in STD_LOGIC_VECTOR(2 downto 0);
		 B : in STD_LOGIC_VECTOR(2 downto 0);
		 MUX_OUT : out STD_LOGIC_VECTOR(2 downto 0)
	     );
end mux_2_1;

architecture mux_2_1_arc of mux_2_1 is
begin
	with SEL select
	MUX_OUT <= A when '0',
			   B when '1',
			   (others => '0') when others;
end mux_2_1_arc;
