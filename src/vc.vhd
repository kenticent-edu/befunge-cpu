library IEEE;
use IEEE.std_logic_1164.all;

entity vc is
	port(
--		 clk : in STD_LOGIC;
		 Control_VC : in STD_LOGIC;
		 literal_in : in STD_LOGIC_VECTOR(8 downto 0);
		 VC_Out : out STD_LOGIC_VECTOR(17 downto 0)
	     );
end vc;

architecture vc_arc of vc is
--signal temp : std_logic_vector(17 downto 0);
begin
	VC_out <= "000000000" & literal_in when Control_VC = '0' else
			  literal_in & literal_in when Control_VC = '1' else
			  (others => '0');
--	process(clk)
--	begin
--		if (rising_edge(clk)) then
--			if (Control_VC = '0') then
--				temp <= "000000000" & literal_in;
--			else
--				temp <= literal_in & literal_in;
--			end if;
--		end if;
--	end process;
--	VC_Out <= temp;	
end vc_arc;
