library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.all;  	
use IEEE.STD_LOGIC_UNSIGNED.all;

entity MUXB is
	port(
		CS_Out   : in std_logic_vector(17 downto 0); -- in 1
		VC_Out   : in std_logic_vector(17 downto 0); -- in 2
		PortB_RF : in std_logic_vector(17 downto 0); -- in 3
		Select_MUXB : in std_logic_vector(1 downto 0); -- S signal
		OutB : out std_logic_vector(17 downto 0) -- out
	);
end MUXB;

architecture MUXB of MUXB is
begin
	process(CS_Out, VC_Out, PortB_RF, Select_MUXB)
	begin
		if Select_MUXB(0)='0'
			then OutB <= VC_Out;
		elsif Select_MUXB(0)='1'
			then OutB <= PortB_RF;
		end if;
		--if Select_MUXB="00"
		--	then OutB <= CS_Out;
		--elsif Select_MUXB="01"
		--	then OutB <= VC_Out;
		--elsif Select_MUXB="10"
		--	then OutB <= PortB_RF;
		--else OutB <= "ZZZZZZZZZZZZZZZZZZ";
		--end if;
	end process;
end MUXB;