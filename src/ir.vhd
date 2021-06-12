library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;  	
use IEEE.STD_LOGIC_UNSIGNED.all;

entity IR is
	port(
		 IR_In : in std_logic_vector(17 downto 0);
		 IRWrite : in std_logic;
		 clk : in std_logic;
		 IR_Out : out std_logic_vector(17 downto 0);
		 lliteral : out std_logic_vector(8 downto 0)
	);
end IR;

architecture IR_arc of IR is
signal reg : std_logic_vector(17 downto 0);
begin

	process(clk)
	begin
		if (rising_edge(clk) and IRWrite='1') then
				reg <= IR_In;
		end if;
	end process;

	IR_Out <= reg;
	lliteral <= reg(8 downto 0);

end IR_arc;
