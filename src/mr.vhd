library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;  	
use IEEE.STD_LOGIC_UNSIGNED.all;

entity MR is
	 port(
		 MR_InALU : in std_logic_vector(17 downto 0);
		 MR_OE_InOut : in std_logic;
		 MRWrite_fromMem : in std_logic;
		 MRWrite_fromALU : in std_logic;
		 clk : in std_logic;
		 MR_InOut : inout std_logic_vector(17 downto 0);
		 MR_Out : out std_logic_vector(17 downto 0)
	);
end MR;

architecture MR_arc of MR is
signal reg : std_logic_vector(17 downto 0);
begin
	
	process(clk)
	begin
		if rising_edge(clk)	then
			if (MRWrite_fromMem = '1') then
				reg <= MR_InOut;
			elsif (MRWrite_fromALU = '1') then
				reg <= MR_InALU;
			end if;
		end if;
	end process;
	
	MR_InOut <= reg when MR_OE_InOut='1' else 
				"ZZZZZZZZZZZZZZZZZZ";
	MR_Out <= reg;
	
end MR_arc;
