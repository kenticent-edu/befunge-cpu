library IEEE;
use IEEE.std_logic_1164.all;

entity rom is
	 port(
		 ALU_source : out STD_LOGIC;
		 AddrC_source : out STD_LOGIC;
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
		 Select_MUXA : out STD_LOGIC;
		 Address : in STD_LOGIC_VECTOR(7 downto 0);
		 ALU_CU : out STD_LOGIC_VECTOR(2 downto 0);
		 AddrC_CU : out STD_LOGIC_VECTOR(2 downto 0);
		 AddrA_CU : out STD_LOGIC_VECTOR(2 downto 0);
		 AddrA_source : out STD_LOGIC_VECTOR(1 downto 0);
		 AddrB_CU : out STD_LOGIC_VECTOR(2 downto 0);
		 Select_MUXB : out STD_LOGIC_VECTOR(1 downto 0)
	     );
end rom;

architecture rom_arc of rom is
type memory is array (0 to 255) of std_logic_vector(35 downto 0);
constant my_rom : memory := (
	others => "000000000000000000000000000000000000");
begin	
end rom_arc;
