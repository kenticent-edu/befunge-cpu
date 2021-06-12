library IEEE;
use IEEE.std_logic_1164.all;

entity befunge_cpu is
	 port(
		 Reset : in STD_LOGIC;
		 clk : in STD_LOGIC
	     );
end befunge_cpu;

architecture befunge_cpu_arc of befunge_cpu is

	component RegisterFile8x18 is
		 port(
			 Reset : in STD_LOGIC;
			 RgFileRW : in STD_LOGIC;
			 clk : in STD_LOGIC;
			 RgMask : in STD_LOGIC_VECTOR(1 downto 0);
			 PortC : in STD_LOGIC_VECTOR(17 downto 0);
			 AddrA : in STD_LOGIC_VECTOR(2 downto 0);
			 AddrB : in STD_LOGIC_VECTOR(2 downto 0);
			 AddrC : in STD_LOGIC_VECTOR(2 downto 0);
			 PortB_RF : out STD_LOGIC_VECTOR(17 downto 0);
			 PortA_RF : out STD_LOGIC_VECTOR(17 downto 0)
		     );
	end component;
	
	component MUX_B is
		 port(
			 VC_Out : in STD_LOGIC_VECTOR(17 downto 0);
			 PortB_RF : in STD_LOGIC_VECTOR(17 downto 0);
			 Select_MUXB : in STD_LOGIC_VECTOR(1 downto 0);
			 OutB : out STD_LOGIC_VECTOR(17 downto 0)
		 );
	end component;
	
	component MUX_A is
		 port(
			 Select_MUXA : in STD_LOGIC;
			 PortA_RF : in STD_LOGIC_VECTOR(17 downto 0);
			 MR_Out : in STD_LOGIC_VECTOR(17 downto 0);
			 OutA : out STD_LOGIC_VECTOR(17 downto 0)
		 );
	end component;
	
	component ALU is
		 port(
			 Zero_flag : out STD_LOGIC;
			 InB : in STD_LOGIC_VECTOR(17 downto 0);
			 InA : in STD_LOGIC_VECTOR(17 downto 0);
			 ALU_Sel : in STD_LOGIC_VECTOR(2 downto 0);
			 AddrB : in STD_LOGIC_VECTOR(2 downto 0);
			 OutC : out STD_LOGIC_VECTOR(17 downto 0);
			 ALUMask : in STD_LOGIC_VECTOR(1 downto 0)
		     );
	end component;
	
	component MAR is
		port (
			MAR_In : in std_logic_vector(17 downto 0);
			MAR_OE : in std_logic; 
			MARWrite : in std_logic;
			clk : in std_logic;
			MAR_Out : out std_logic_vector(17 downto 0)
		);
	end component;
	
	component MemoryMUX is
		port(
			 MAR_Out : in std_logic_vector(17 downto 0);
			 MemRead : in std_logic;
			 MemWrite : in std_logic;
			 Reset : in std_logic;
			 Address : out std_logic_vector(17 downto 0);
			 Read : out std_logic;
			 Write : out std_logic
			 );
	end component;
	
	component Memory256Kx18 is
		port(
			Address : in std_logic_vector(17 downto 0);
			 Read : in std_logic;
			 Write : in std_logic;
			 clk : in std_logic;
			 Data : inout std_logic_vector(17 downto 0)
			--MemMask : in std_logic_vector(1 downto 0)
			 );
	end component;
	
	component IR is
		port (
			IR_In : in std_logic_vector(17 downto 0);
			IRWrite : in std_logic;
			clk : in std_logic;
			IR_Out : out std_logic_vector(17 downto 0);
			lliteral : out std_logic_vector(8 downto 0)
		);
	end component;
	
	component ControlUnit is
		 port(
			 Zero_flag : in STD_LOGIC;
			 Reset : in STD_LOGIC;
			 clk : in STD_LOGIC;
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
			 Instruction : in STD_LOGIC_VECTOR(17 downto 0);
			 ALU : out STD_LOGIC_VECTOR(2 downto 0);
			 AddrA : out STD_LOGIC_VECTOR(2 downto 0);
			 AddrB : out STD_LOGIC_VECTOR(2 downto 0);
			 AddrC : out STD_LOGIC_VECTOR(2 downto 0);
			 Select_MUXB : out STD_LOGIC_VECTOR(1 downto 0);
			 ALUMask : out STD_LOGIC_VECTOR(1 downto 0);
			 RgMask : out STD_LOGIC_VECTOR(1 downto 0)
		 );
	end component;
	
	component VC is
		 port(
			 Control_VC : in STD_LOGIC;
			 literal_in : in STD_LOGIC_VECTOR(8 downto 0);
			 VC_Out : out STD_LOGIC_VECTOR(17 downto 0)
		 );
	end component;
	
	component MR is
		 port(
			 MR_InALU : in std_logic_vector(17 downto 0);
			 MR_OE_InOut : in std_logic;
			 MRWrite_fromMem : in std_logic;
			 MRWrite_fromALU : in std_logic;
			 clk : in std_logic;
			 MR_InOut : inout std_logic_vector(17 downto 0);
			 MR_Out : out std_logic_vector(17 downto 0)
			 );
	end component;
		
	signal RgFileRW : STD_LOGIC;
	signal RgMask : STD_LOGIC_VECTOR(1 downto 0);
	signal OutC : STD_LOGIC_VECTOR(17 downto 0);
	signal PortC : STD_LOGIC_VECTOR(17 downto 0);
	signal AddrA : STD_LOGIC_VECTOR(2 downto 0);
	signal AddrB : STD_LOGIC_VECTOR(2 downto 0);
	signal AddrC : STD_LOGIC_VECTOR(2 downto 0);
	signal PortB_RF : STD_LOGIC_VECTOR(17 downto 0);
	signal PortA_RF : STD_LOGIC_VECTOR(17 downto 0);
	signal VC_Out : STD_LOGIC_VECTOR(17 downto 0);
	signal Select_MUXB : STD_LOGIC_VECTOR(1 downto 0);
	signal OutB : STD_LOGIC_VECTOR(17 downto 0);
	signal Select_MUXA : STD_LOGIC;
	signal MR_Out : STD_LOGIC_VECTOR(17 downto 0);
	signal OutA : STD_LOGIC_VECTOR(17 downto 0);
	signal Zero_flag : STD_LOGIC;
	signal ALU_Sel : STD_LOGIC_VECTOR(2 downto 0);
	signal ALUMask : STD_LOGIC_VECTOR(1 downto 0);
	signal MAR_OE : std_logic; 
	signal MARWrite : std_logic;
	signal MAR_Out : std_logic_vector(17 downto 0);
	signal MemRead : std_logic;
	signal MemWrite : std_logic;
	signal Address : std_logic_vector(17 downto 0);
	signal Read : std_logic;
	signal Write : std_logic;
	signal Data : std_logic_vector(17 downto 0);
	signal MemMask : std_logic_vector(1 downto 0);
	signal IRWrite : std_logic;
	signal IR_Out : std_logic_vector(17 downto 0);
	signal lliteral : std_logic_vector(8 downto 0);
	signal MR_OE_InOut : STD_LOGIC;
	signal MRWrite_fromMem : STD_LOGIC;
	signal MRWrite_fromALU : STD_LOGIC;
	signal Control_VC : STD_LOGIC;
	
begin
	rf1: RegisterFile8x18 port map (Reset,RgFileRW,clk,RgMask,OutC,AddrA,AddrB,AddrC,
		PortB_RF,PortA_RF);
	mux_b1: MUX_B port map (VC_Out,PortB_RF,Select_MUXB,OutB);
	mux_a1: MUX_A port map (Select_MUXA,PortA_RF,MR_Out,OutA);
	alu1: ALU port map (Zero_flag,OutB,OutA,ALU_Sel,AddrB,OutC,ALUMask);
	mar1: MAR port map (OutC,MAR_OE,MarWrite,clk,MAR_Out);
	mem_mux1: MemoryMux port map (MAR_Out,MemRead,MemWrite,Reset,Address,Read,Write);
	mem1: Memory256Kx18 port map (Address,Read,Write,clk,Data);--,MemMask);
	ir1: IR port map (Data,IRWrite,clk,IR_Out,lliteral);
	cu1: ControlUnit port map (Zero_flag,Reset,clk,MAR_OE,MARWrite,MR_OE_InOut,
		MRWrite_fromMem,MRWrite_fromALU,MemRead,MemWrite,IRWrite,RgFileRW,Control_VC,
		Select_MUXA,IR_Out,ALU_Sel,AddrA,AddrB,AddrC,Select_MUXB,ALUMask,RgMask);
	vc1: VC port map (Control_VC,lliteral,VC_Out);
	mr1: MR port map (OutC,MR_OE_InOut,MRWrite_fromMem,MRWrite_fromALU,clk,Data,MR_Out);
end befunge_cpu_arc;
