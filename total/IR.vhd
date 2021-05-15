library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;  	
use IEEE.STD_LOGIC_UNSIGNED.all;

entity IR is
	port(
		IR_In : in std_logic_vector(17 downto 0); -- in
		IRWrite : in std_logic; -- flag
		clk : in std_logic; -- clock
		IR_Out : out std_logic_vector(17 downto 0); -- out
		lliteral : out std_logic_vector(8 downto 0)
	);
end IR;

architecture IR of IR is
signal memory: std_logic_vector(17 downto 0);
begin
	process(clk, IRWrite)
	begin
		if (rising_edge(clk) and IRWrite='1') then
			memory <= IR_In;
		end if;
	end process;
	IR_Out <= memory;
	lliteral <= memory(8 downto 0);
end IR;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;  	
use IEEE.STD_LOGIC_UNSIGNED.all;

entity IR_TB is
end IR_TB;

architecture test of IR_TB is

component IR is 
	port(
		IR_In : in std_logic_vector(17 downto 0); -- in
		IRWrite : in std_logic; -- flag
		clk : in std_logic; -- clock
		IR_Out : out std_logic_vector(17 downto 0); -- out
		lliteral : out std_logic_vector(8 downto 0)
	);
end component;

signal IR_In, IR_Out : std_logic_vector(17 downto 0);
signal lliteral : std_logic_vector(8 downto 0);
signal IRWrite : std_logic;

signal clk : std_logic:='0';

begin
	uut : IR port map(
		IR_In =>IR_In,
		IRWrite =>IRWrite,
		clk =>clk,
		IR_Out =>IR_Out,
		lliteral =>lliteral
	);
	clk <= not clk after 20 ns;
	process	
		begin
		wait until clk'event and clk='1';
			IRWrite <= '1';
			IR_In <= "000000000000000001";
		assert IR_Out = "000000000000000001"
		report "fail" severity warning;

		wait until clk'event and clk='1';
			IRWrite <= '0';
			IR_In <= "000000000000000111";
		assert IR_Out = "000000000000000001"
		report "fail" severity warning;
	end process;
end test;	 
