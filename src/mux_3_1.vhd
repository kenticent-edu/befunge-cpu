library IEEE;
use IEEE.std_logic_1164.all;

entity mux_3_1 is
	 port(
		 SEL : in STD_LOGIC_VECTOR(1 downto 0);
		 A : in STD_LOGIC_VECTOR(2 downto 0);
		 B : in STD_LOGIC_VECTOR(2 downto 0);
		 C : in STD_LOGIC_VECTOR(2 downto 0);
		 MUX_OUT : out STD_LOGIC_VECTOR(2 downto 0)
	     );
end mux_3_1;

architecture mux_3_1_arc of mux_3_1 is
begin
	with SEL select
	MUX_OUT <= A when "00",
			   B when "01",
			   C when "10",
			   (others => '0') when others;
end mux_3_1_arc;
