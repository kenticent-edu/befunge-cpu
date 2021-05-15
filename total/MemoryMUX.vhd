library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.all;  	
use IEEE.STD_LOGIC_UNSIGNED.all;

entity MemoryMUX is
	port(
		--UARTAddress : in std_logic_vector(17 downto 0);

		--UARTMemRead : in std_logic;
		--UARTMemWrite : in std_logic;

		MemRead : in std_logic;
		MemWrite : in std_logic;

		Reset : in std_logic;

		MAR_Out : in std_logic_vector(17 downto 0);

		Address : out std_logic_vector(17 downto 0);
		Read, Write : out std_logic
	);
end MemoryMUX;

architecture MemoryMUX of MemoryMUX is
begin
	--process(Reset, UARTAddress, UARTMemRead, UARTMemWrite, MAR_Out, MemRead, MemWrite)
	process(Reset, MAR_Out, MemRead, MemWrite)
	begin
		--if Reset='1' then
		--	Address <= UARTAddress;
		--	Read <= UARTMemRead;
		--	Write <= UARTMemWrite;
		--else
			Address <= MAR_Out;
			Read <= MemRead;
			Write <= MemWrite;
		--end if;
	end process;
end MemoryMUX;
