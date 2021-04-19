library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.NUMERIC_STD.ALL;


entity RAM is
	port(
		writeMode : in BOOLEAN;
		Addr : in STD_LOGIC_VECTOR(0 to 7);	---64 words
		Din : in STD_LOGIC_VECTOR(17 downto 0);
		Dout : out STD_LOGIC_VECTOR(17 downto 0)
	);
end RAM;


architecture RAM_basic of RAM is

type RAM_ARRAY is array (0 to 7) of std_logic_vector (17 downto 0);
-- initial values in the RAM
signal DATA: RAM_ARRAY :=(
0 => "000000000000000000",
1 => "000000000000000000",
2 => "000000000000000000",
3 => "000000000000000000",
4 => "000000000000000000",
5 => "000000000000000000",
6 => "000000000000000000",
7 => "000000000000000000");

signal address : integer;
begin	
	process(Addr,writeMode)
	begin
		address <= to_integer(unsigned(Addr));
		if writeMode then
			DATA(address) <= Din;
		else Dout <= DATA(address);
		end if;	 
	end process;
end RAM_basic;