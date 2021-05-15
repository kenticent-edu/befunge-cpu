library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.all;  	
use IEEE.STD_LOGIC_UNSIGNED.all;

entity MUXA is
	port(
		PortA_RF : in std_logic_vector(17 downto 0); -- in 1
		MR_Out : in std_logic_vector(17 downto 0); -- in 2
		Select_MUXA : in std_logic; -- S signal
		OutA : out std_logic_vector(17 downto 0) -- out
	);
end MUXA;

architecture MUXA of MUXA is
begin
	process(PortA_RF, MR_Out, Select_MUXA)
	begin
		if Select_MUXA='0' then OutA <= PortA_RF;
		else OutA <= MR_Out;
		end if;
	end process;
end MUXA;