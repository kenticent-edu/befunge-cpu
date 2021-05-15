library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity rom is
	 port(
		 Address : in STD_LOGIC_VECTOR(7 downto 0);
		 ALU_CU : out STD_LOGIC_VECTOR(2 downto 0);
		 ALU_source : out STD_LOGIC;
		 AddrC_CU : out STD_LOGIC_VECTOR(2 downto 0);
		 AddrC_source : out STD_LOGIC;
		 AddrA_CU : out STD_LOGIC_VECTOR(2 downto 0);
		 AddrA_source : out STD_LOGIC_VECTOR(1 downto 0);
		 AddrB_CU : out STD_LOGIC_VECTOR(2 downto 0);
		 AddrB_source : out STD_LOGIC;
		 MAR_OE : out STD_LOGIC;
		 MARWrite : out STD_LOGIC;
		 MR_OE_InOut : out STD_LOGIC;
		 MRWrite_fromMem : out STD_LOGIC;
		 MRWrite_fromALU : out STD_LOGIC;
		 MemRead : out STD_LOGIC;
		 MemWrite : out STD_LOGIC;
		 IRWrite : out STD_LOGIC;
		 RgFileRW : out STD_LOGIC;
		 Control_VC : out STD_LOGIC;
		 Select_MUXB : out STD_LOGIC_VECTOR(1 downto 0);
		 Select_MUXA : out STD_LOGIC
	     );
end rom;

architecture rom_arc of rom is
type memory is array (0 to 255) of std_logic_vector(29 downto 0);
constant my_rom : memory := (
	0 => "000001100000000100000000010010",
	1 => "000000000000000000100000000000",
	2 => "000000000000000001000010000000",
	3 => "000000000000000000000000100000",
	others => "000000000000000000000000000000");
begin
	ALU_CU <= my_rom(to_integer(unsigned(Address)))(29 downto 27);
	ALU_source <= my_rom(to_integer(unsigned(Address)))(26);
	AddrC_CU <= my_rom(to_integer(unsigned(Address)))(25 downto 23);
	AddrC_source <= my_rom(to_integer(unsigned(Address)))(22);
	AddrA_CU <= my_rom(to_integer(unsigned(Address)))(21 downto 19);
	AddrA_source <= my_rom(to_integer(unsigned(Address)))(18 downto 17);
	AddrB_CU <= my_rom(to_integer(unsigned(Address)))(16 downto 14);
	AddrB_source <= my_rom(to_integer(unsigned(Address)))(13);
	MAR_OE <= my_rom(to_integer(unsigned(Address)))(12);
	MARWrite <= my_rom(to_integer(unsigned(Address)))(11);
	MR_OE_InOut <= my_rom(to_integer(unsigned(Address)))(10);
	MRWrite_fromMem <= my_rom(to_integer(unsigned(Address)))(9);
	MRWrite_fromALU <= my_rom(to_integer(unsigned(Address)))(8);
	MemRead <= my_rom(to_integer(unsigned(Address)))(7);
	MemWrite <= my_rom(to_integer(unsigned(Address)))(6);
	IRWrite <= my_rom(to_integer(unsigned(Address)))(5);
	RgFileRW <= my_rom(to_integer(unsigned(Address)))(4);
	Control_VC <= my_rom(to_integer(unsigned(Address)))(3);
	Select_MUXB <= my_rom(to_integer(unsigned(Address)))(2 downto 1);
	Select_MUXA <= my_rom(to_integer(unsigned(Address)))(0);
end rom_arc;