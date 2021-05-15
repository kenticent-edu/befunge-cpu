library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.NUMERIC_STD.ALL;


entity Memory256Kx18 is
	port(
		Address : in std_logic_vector(17 downto 0);
		Read : in std_logic;
		Write : in std_logic;
		clk : in std_logic;
		Data : inout std_logic_vector(17 downto 0)
	);
end Memory256Kx18;

architecture Memory256Kx18 of Memory256Kx18 is

type MemoryArray is array (0 to 262144) of std_logic_vector (17 downto 0);
signal Contents: MemoryArray := (others => "000000000000000000");
signal tData, tContents : std_logic_vector(17 downto 0);
signal AddressInt : integer;

begin
	process(Read, Write, Address, Data, clk)
	begin
		if rising_edge(clk) then
			AddressInt <= to_integer(unsigned(Address));
			if Read='1' then
				Data <= Contents(AddressInt);
			end if;
			if Write='1' then
				tContents <= Data;
			end if;
		end if;
	end process;
	Contents(AddressInt) <= Data when Write='1' else Contents(AddressInt);
end Memory256Kx18;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.all;  	
use IEEE.STD_LOGIC_UNSIGNED.all;

entity Memory_TB is
end Memory_TB;

architecture test of Memory_TB is

component Memory256Kx18 is 
	port(
		Address : in std_logic_vector(17 downto 0);
		Read : in std_logic;
		Write : in std_logic;
		clk : in std_logic;
		Data : inout std_logic_vector(17 downto 0)
	);
end component;

signal Address, Data : std_logic_vector(17 downto 0);
signal Read, Write: std_logic;

signal clk : std_logic:='0';

begin
	uut : Memory256Kx18 port map(
		Address => Address,
		Read => Read,
		Write => Write,
		clk => clk,
		Data => Data
	);
	clk <= not clk after 20 ns;
	process	
		begin
		wait until clk'event and clk='1';
			Address <= "000000000000000001";
			Data <= "111111111111111111";
			Write <= '1';

		wait until clk'event and clk='1';
			Address <= "000000000000000001";
			Read <= '1';
		assert Data = "000000000000000001"
		report "fail" severity warning;
	end process;
end test;	
