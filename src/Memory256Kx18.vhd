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

type MemoryArray is array (0 to 64) of std_logic_vector (17 downto 0);
signal Contents : MemoryArray := (
	-- Set detaPC to any delta (reg3 instead of delta reg3 is used for demonstration)
	--0 => "000001100111111111", -- deltaPC = ( 0, -1)
	--1 => "000001100000000001", -- deltaPC = ( 0,  1)
	--2 => "000010100000000000", -- deltaPC = ( 0,  0) -- changing y requires 2 steps
	--3 => "010010100111111111", -- deltaPC = ( -1, 0)	
	--4 => "000010100000000000", -- deltaPC = ( 1,  0) -- changing y requires 2 steps
	--5 => "010010100000000001", -- deltaPC = ( 1,  0)
	--others => (others => '0'));
	--1 => "001111011111011010", -- reg3 += (0, 1)
	--2 => "001111011111011010", -- reg3 += (0, 1)
	--3 => "010111011111011010", -- reg3 += (1, 0)
	--4 => "010111011111011010", -- reg3 += (1, 0)
	--5 => "010111011111011010", -- reg3 += (1, 0)-
	--0 => "000001010000000001", -- deltaPC = (0, 1)
	--1 => "100111100000011011", -- reg2 = A-B
	--3 => "100111100000011011", -- deltaPC = (0, 1)
	--4 => "100111100000011011", -- reg2 = 0-reg2
	-- Load Word TEST
	--0 => "000001011000000010", -- load literal into reg3
	--1 => "100001101000100011", -- reg5 = Memory(reg3+reg4)
	--2 => "111111111111111111",-- willl be loaded into reg
	--Store Word TEST set address 4 to 1001 = 9
	0 => "000001011000000011", -- load literal into reg3
	1 => "000001100000000001", -- load literal into reg4
	2 => "000001101000001001", -- load literal into reg5
	3 => "100100101000100011", -- memory(reg3+reg4) = reg5
	4 => "111111111111111111",
	-- MaskingModes TEST
	--0 => "000001011000000001", -- load literal into reg3
	--1 => "000010011001010100", -- load literal x 2 into reg4
	-- 100011110000011100
	-- AND
	--2 => "100010110101011100",
	--3 => "101010110101011100",
	--4 => "110010110101011100",
	--5 => "111010110101011100",
	-- OR
	--2 => "100011110101011100",
	--3 => "101011110101011100",
	--4 => "110011110101011100",
	--5 => "111011110101011100",
	-- MaskingMode TEST
	--0 => "000111011111011010", -- reg3 += (1, 1)
	--1 => "011111011111011010", -- reg3 += (1, 1)
	--2 => "001111100111100010", -- reg4 += (0, 1)
	--3 => "010111101111101010", -- reg5 += (1, 0)
	-- Arithmetic Logic TEST
	--0 => "000001011000000001", -- load literal into reg 011
	--1 => "000010100000010100", -- load literal x 2 into reg 101
	--2 => "100000110000011100",-- reg6 = A+B
	--3 => "100001110000100011",-- reg6 = A-B
	--4 => "100010110000011100", -- reg6 = A and B
	--5 => "100011110000011100", -- reg6 = A or B
	--6 => "100100110000011100", -- reg6 = A xor B
	-- INV & DEC TEST
	--0 => "000001011111111111", -- load literal reg3
	--1 => "100111100000011010", -- reg4 = reg3 + (1, 1)
	--2 => "100111100000011011", -- reg4 = reg3 - (1, 1)
	--3 => "000001101000000001", -- load literal reg5
	--4 => "100111110000011010", -- reg6 = reg5 + (1, 1)
	--5 => "100111110000011011", -- reg6 = reg5 - (1, 1)
	--2 => "100111101000011000", -- reg5 = not reg3
	--3 => "100111101000011001", -- reg5 = shr reg3
	-- Skip TESTS
	--0 =>  "000001011000000000", -- reg3 = literal = 0
	--1 =>  "000011011000000000", -- SZ
	--2 =>  "001111100111100010", -- reg3 += 1 -- will skip + extra IncPC 
	--3 =>  "000100011000011011", -- SNZ 
	--4 =>  "001111100111100010", -- reg3 += 1 -- will execute
	--5 =>  "000011011000000000", -- SZ
	--6 =>  "001111100111100010", -- reg3 += 1 -- will skip + extra IncPC
	--7 =>  "000100011000011011", -- SNZ
	--8 =>  "001111100111100010", -- reg3 += 1 -- will 
	-- Increment\Decrement Scalar TESTS
	--0 => "100000011111011100", --reg3 += 1
	--1 => "100000011111011100", --reg3 += 1
	--3 => "100000100111011100", --reg4 = reg3 + 1
	--4 => "100000011111011101", --reg3 -= 1
	--5 => "100000011111011101", --reg3 -= 1
	--6 => "100000100111011101", --reg4 = reg3 - 1
	--2 => "000011011000000000", -- reg 3 = 0
	--2 => "100000101000011100",
	others => (others => '0'));
signal temp	: std_logic_vector(17 downto 0);
signal AddressInt : integer;
--type MemoryArray is array (0 to 16) of std_logic_vector (17 downto 0);
--signal Contents : MemoryArray := (
	-- 2D Snake Cycle
--	0 => "001010010111111111", -- deltaPC = (-1, 0)
--	1 => "111000010111010000", -- deltaPC = (0, -1)
--	5 => "011010010000000001", -- deltaPC = (2, 2)
--	others => "100100001000000001"); -- Memory(PC)=PC
begin
	process(clk)
	variable x, y : integer;
	--variable AddressInt : integer;
	begin
		--x := to_integer(unsigned(Address(10 downto 9)));
		--y := to_integer(unsigned(Address(1 downto 0)));
		--AddressInt	<= x*4+y;
		x := to_integer(unsigned(Address(12 downto 9)));
		y := to_integer(unsigned(Address(3 downto 0)));
		AddressInt <= x*8+y;
		if (rising_edge(clk)) then
			if Read = '1' then
				--temp <= Contents(to_integer(unsigned(Address)));
				temp <= Contents(AddressInt);
			elsif Write = '1' then
				--Contents(to_integer(unsigned(Address))) <= Data;
				Contents(AddressInt) <= Data;
			elsif Read='0' then
				temp <= "ZZZZZZZZZZZZZZZZZZ";
			end if;
		end if;
	end process;
	Data <= temp;
end Memory256Kx18;
