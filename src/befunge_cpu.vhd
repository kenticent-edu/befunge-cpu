library IEEE;
use IEEE.std_logic_1164.all;

entity befunge_cpu is
	 port(
		 Reset : in STD_LOGIC;
		 clk : in STD_LOGIC;
		 PortC : in STD_LOGIC_VECTOR(17 downto 0);
		 VC_Out : in STD_LOGIC_VECTOR(17 downto 0);
		 MR_Out : in STD_LOGIC_VECTOR(17 downto 0);
		 lliteral : out std_logic_vector(8 downto 0)
	     );
end befunge_cpu;

architecture befunge_cpu_arc of befunge_cpu is

	component reg18_8 is
		port(
	--		RgMask : in std_logic_vector(1 downto 0);
			Reset : in std_logic;
			PortC : in std_logic_vector(17 downto 0);
			AddrA : in std_logic_vector(2 downto 0);
			AddrB : in std_logic_vector(2 downto 0);
			AddrC : in std_logic_vector(2 downto 0);
			RgFileRW : in std_logic;
			clk : in std_logic;
			PortB_RF : out std_logic_vector(17 downto 0);
			PortA_RF : out std_logic_vector(17 downto 0)
	--		I_en : in std_logic;
	--		GPIO : out std_logic_vector(17 downto 0)
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
			InA,InB : in std_logic_vector(17 downto 0);
			ALU, AddrB : in std_logic_vector(2 downto 0); 
			Zero_flag : out std_logic;
			OutC : out std_logic_vector(17 downto 0)
		);
	end component;
	
	component MAR is
		port (
			MAR_In : in std_logic_vector(17 downto 0);
			MAR_OE : in std_logic; -- Remove? 
			MARWrite : in std_logic;
			clk : in std_logic;
			MAR_Out : out std_logic_vector(17 downto 0));
	end component;
	
	component MemoryMUX is
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
	end component;
	
	component Memory256Kx18 is
		port(
			Address : in std_logic_vector(17 downto 0);
			Read : in std_logic;
			Write : in std_logic;
			clk : in std_logic;
			Data : inout std_logic_vector(17 downto 0)
		);
	end component;
	
	component IR is
		port (
			IR_In : in std_logic_vector(17 downto 0);
			IRWrite : in std_logic;
			clk : in std_logic;
			IR_Out : out std_logic_vector(17 downto 0);
			lliteral : out std_logic_vector(8 downto 0));
	end component;
	
	component control_unit is
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
			 Select_MUXB : out STD_LOGIC_VECTOR(1 downto 0)
		     );
	end component;
		
	signal PortB_RF,PortA_RF,OutB,OutA,OutC,MAR_Out,Address,Data : std_logic_vector(17 downto 0);
	signal Read,Write,Zero_flag : std_logic;
	signal MAR_OE,MARWrite,MR_OE_InOut,MRWrite_fromMem,MRWrite_fromALU,MemRead,MemWrite,IRWrite,RgFileRW,Control_VC,Select_MUXA : std_logic;
	signal IR_Out : std_logic_vector(17 downto 0);
	signal ALU_out,AddrA,AddrB,AddrC : std_logic_vector(2 downto 0);
	signal Select_MUXB : std_logic_vector(1 downto 0);

begin
	r1: reg18_8 port map (Reset,PortC,AddrA,AddrB,AddrC,RgFileRW,clk,PortB_RF,PortA_RF);
	mb1: MUX_B port map (VC_Out,PortB_RF,Select_MUXB,OutB);
	ma1: MUX_A port map (Select_MUXA,PortA_RF,MR_Out,OutA);
	a1: ALU port map (OutA,OutB,ALU_out,AddrB,Zero_flag,OutC);
	mar1: MAR port map (OutC,MAR_OE,MARWrite,clk,MAR_Out);
	mmux1: MemoryMUX port map (MemRead,MemWrite,Reset,MAR_Out,Address,Read,Write);
	mem1: Memory256Kx18 port map (Address,Read,Write,clk,Data);
	ir1: IR port map (Data,IRWrite,clk,IR_Out,lliteral);
	cu1: control_unit port map (Zero_flag,Reset,clk,MAR_OE,MARWrite,MR_OE_InOut,MRWrite_fromMem,MRWrite_fromALU,MemRead,MemWrite,IRWrite,RgFileRW,Control_VC,Select_MUXA,IR_Out,ALU_out,AddrA,AddrB,AddrC,Select_MUXB);
end befunge_cpu_arc;
