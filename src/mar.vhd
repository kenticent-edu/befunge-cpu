library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;  	
use IEEE.STD_LOGIC_UNSIGNED.all;

entity MAR is
	port(
		 MAR_In : in std_logic_vector(17 downto 0);
		 MAR_OE : in std_logic; -- Remove? 
		 MARWrite : in std_logic;
		 clk : in std_logic;
		 MAR_Out : out std_logic_vector(17 downto 0)
	);
end MAR;

architecture MAR_arc of MAR is
signal reg : std_logic_vector(17 downto 0);
begin

	process(clk) -- Removed MAR_OE, MAR_Out, MARWrite
	begin
		if (rising_edge(clk) and MARWrite='1') then
				reg <= MAR_In;
		end if;
	end process;

	MAR_Out <= reg when MAR_OE='1' else 
				(others => 'Z');

end MAR_arc;
