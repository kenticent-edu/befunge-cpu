library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity rom is
	port(
	     Address : in STD_LOGIC_VECTOR(7 downto 0);
	     RgMask_CU : out STD_LOGIC_VECTOR(1 downto 0);
		 RgMask_source : out STD_LOGIC;
		 ALUMask_CU : out STD_LOGIC_VECTOR(1 downto 0);
		 ALUMask_source : out STD_LOGIC;
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

type memory is array (0 to 255) of std_logic_vector(35 downto 0);
constant my_rom : memory := (
	-- Instruction Fetch
	0 =>   "000000000000000000000100000000000010", -- OutC = PC+0 = reg1 + reg0
	1 =>   "000000000000000000000100100000000010", -- MAR=OutC					   
	2 =>   "000000000000000000000001000010000000", -- Memory(MAR) ->Data-> IR
	3 =>   "000000000000000000000000000000100000", -- IR = Memory(MAR)
	4 =>   "000000000000000000000000000000000000", -- IR -> CU
	-- load Literal
	5 =>   "001001000000010000000000000000000000", -- OutC = "00000000"&literal  
	6 =>   "001001000000010000000000000000010000", -- OutC = "00000000"&literal, reg(AddrC_Com)=OutC
	7 =>   "001001000000010000000000000000001000", -- OutC=literal & literal
	8 =>   "001001000000010000000000000000011000", -- OutC=literal & literal, reg(AddrC_Com)=OutC
	-- Arithmetic \ Logic operations
	9 =>   "001001000100010000100010000000000010", -- C = OutC = A + B \ A - B \ A and B \ A and C \ A or B \ A or C
	10 =>  "001001000100010000100010000000010010", -- C = OutC 
	11 =>  "001001111000010000100010000000000010", -- not A \ shr A \ inv A \ dev A \ INC A \ DEC A depending on AddrB - masking mode 
	12 =>  "001001111000010000100010000000010010",
	-- SZ
	16 =>  "001001000100010000100010000000000010", --SZ, SNZ, DZ, DNZ (AddrC=AddrC_Com)
	17 =>  "001001000100010000100010000000000010", --SZ, SNZ, DZ, DNZ (AddrC=AddrC_Com)
	-- Load Word
	18 =>  "001001000100010000100010000000000010", -- OutC = A some_operation B
	19 =>  "001001000100010000100010100000000010", -- MAR = OutC
	20 =>  "000000000000000000000001000010000000", -- Memory(MAR) ->Data-> MR
	21 =>  "000000000000000000000001001000000000", -- MR = Memory(MAR)
	22 =>  "001001000000010000000000001000000011", -- OutC = 0 + MR_Out
	23 =>  "001001000000010000000000001000010011", -- C = OutC
	-- Store Word
	24 =>  "001001000100010000100010000000000010", -- OutC = A some_operation B
	25 =>  "001001000100010000100010100000000010", -- MAR = OutC
	26 =>  "001001000000010001000001000000000010",  -- OutC = 0+regC
	27 =>  "001001000000010001000000000100000010",  -- MR=OutC
	28 =>  "000000000000000000000001010001000000", -- Memory(MAR) = MR
	-- incPC
	253 => "000110000000100010001000000000000010", -- OutC=PC+deltaPC
	254 => "000110000000100010001000000000010010", -- PC = OutC
	255 => "000110000000000000000000000000000000",
	others => (others => '0'));
	
signal temp : std_logic_vector(35 downto 0);

begin
	temp <= my_rom(to_integer(unsigned(Address)));

	RgMask_CU <= temp(35 downto 34);
	RgMask_source <= temp(33);
	ALUMask_CU <= temp(32 downto 31);
	ALUMask_source <= temp(30);
	ALU_CU <= temp(29 downto 27);
	ALU_source <= temp(26);
	AddrC_CU <= temp(25 downto 23);
	AddrC_source <= temp(22);
	AddrA_CU <= temp(21 downto 19);
	AddrA_source <= temp(18 downto 17);
	AddrB_CU <= temp(16 downto 14);
	AddrB_source <= temp(13);
	MAR_OE <= temp(12);
	MARWrite <= temp(11);
	MR_OE_InOut <= temp(10);
	MRWrite_fromMem <= temp(9);
	MRWrite_fromALU <= temp(8);
	MemRead <= temp(7);
	MemWrite <= temp(6);
	IRWrite <= temp(5);
	RgFileRW <= temp(4);
	Control_VC <= temp(3);
	Select_MUXB <= temp(2 downto 1);
	Select_MUXA <= temp(0);

end rom_arc;
