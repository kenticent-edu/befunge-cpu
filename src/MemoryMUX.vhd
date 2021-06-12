library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.all;  	
use IEEE.STD_LOGIC_UNSIGNED.all;

entity MemoryMUX is
	port(
		 --UARTAddress : in std_logic_vector(17 downto 0);
		 --UARTMemRead : in std_logic;
		 --UARTMemWrite : in std_logic;
		 MAR_Out : in std_logic_vector(17 downto 0);
		 MemRead : in std_logic;
		 MemWrite : in std_logic;
		 Reset : in std_logic;
		 Address : out std_logic_vector(17 downto 0);
		 Read : out std_logic;
		 Write : out std_logic
	);
end MemoryMUX;

architecture MemoryMUX_arc of MemoryMUX is
begin
	Address <= MAR_Out;
	Read <= MemRead;
	Write <= MemWrite;         
end MemoryMUX_arc;
