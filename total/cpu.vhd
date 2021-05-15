library IEEE;
use IEEE.std_logic_1164.all;

entity cpu is
	 port(
		 clk : in STD_LOGIC
	     );
end cpu;

architecture cpu_arc of cpu is
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
component Memory256Kx18 is
	port(
		Address : in std_logic_vector(17 downto 0);
		Read : in std_logic;
		Write : in std_logic;
		clk : in std_logic;
		Data : inout std_logic_vector(17 downto 0)
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
component MAR is 
	port(
		MAR_In : in std_logic_vector(17 downto 0);
		MAR_OE : in std_logic; 
		MARWrite : in std_logic;
		clk : in std_logic;
		MAR_Out : out std_logic_vector(17 downto 0)
	);
end component;
component MemoryMUX is
	port(
		MemRead : in std_logic;
		MemWrite : in std_logic;
		Reset : in std_logic;
		MAR_Out : in std_logic_vector(17 downto 0);
		Address : out std_logic_vector(17 downto 0);
		Read, Write : out std_logic
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
component reg18_8 is
	port (
		RgMask : in std_logic_vector(1 downto 0);
		Reset : in std_logic;
		PortC : in std_logic_vector(17 downto 0);
		AddrA : in std_logic_vector(2 downto 0);
		AddrB : in std_logic_vector(2 downto 0);
		AddrC : in std_logic_vector(2 downto 0);
		RgFileRW : in std_logic;
		clk : in std_logic;
		PortB_RF : out std_logic_vector(17 downto 0);
		PortA_RF : out std_logic_vector(17 downto 0);
		I_en : in std_logic);
end component;	
component MUXA is
	port(
		PortA_RF : in std_logic_vector(17 downto 0); -- in 1
		MR_Out : in std_logic_vector(17 downto 0); -- in 2
		Select_MUXA : in std_logic; -- S signal
		OutA : out std_logic_vector(17 downto 0) -- out
	);
end component;
component MUXB is
	port(
		CS_Out   : in std_logic_vector(17 downto 0); -- in 1
		VC_Out   : in std_logic_vector(17 downto 0); -- in 2
		PortB_RF : in std_logic_vector(17 downto 0); -- in 3
		Select_MUXB : in std_logic_vector(1 downto 0); -- S signal
		OutB : out std_logic_vector(17 downto 0) -- out
	);
end component;
component IR is
	port(
		IR_In : in std_logic_vector(17 downto 0); -- in
		IRWrite : in std_logic; -- flag
		clk : in std_logic; -- clock
		IR_Out : out std_logic_vector(17 downto 0); -- out
		lliteral : out std_logic_vector(8 downto 0)
	);
end component;

-- signal clk : std_logic;
signal Reset : std_logic;
signal AddrA, AddrB, AddrC : std_logic_vector(2 downto 0);
signal MAR_In : std_logic_vector(17 downto 0); -- also connected to ALU
signal MAR_Out : std_logic_vector(17 downto 0);
signal MemRead, MemWrite : std_logic;
signal MR_InALU, MR_InOut, MR_Out : std_logic_vector(17 downto 0);
signal MRWrite_fromMem, MRWrite_fromALU, MR_OE_InOut : std_logic;
signal Address, Data : std_logic_vector(17 downto 0); 
signal Read, Write : std_logic;
signal IRWrite : std_logic;
signal Instruction : std_logic_vector(17 downto 0);
signal  MAR_OE, MARWrite : std_logic;
-- InA, In - ALUA, ALUB
-- signal OutC  : std_logic_vector(17 downto 0); - MAR_In
-- signal ALUMask : std_logic_vector(1 downto 0);
signal Zero_flag : std_logic;
signal ALU_operation : std_logic_vector(2 downto 0);
signal RgMask : std_logic_vector(1 downto 0);
signal regReset, RgFileRW, I_en : std_logic;
signal PortC, PortB_RF, PortA_RF : std_logic_vector(17 downto 0);
signal CS_Out, VC_Out : std_logic_vector(17 downto 0);
signal ControlVC : std_logic;
-- MR_Out - shared with MAR
signal Select_MUXA : std_logic;
signal Select_MUXB : std_logic_vector(1 downto 0);
signal OperandA, OperandB : std_logic_vector(17 downto 0); --OutA for MUXB, InA for ALU, OutB for MUXA, InB for ALU 
signal IR_In, IR_Out : std_logic_vector(17 downto 0);
signal lliteral : std_logic_vector(8 downto 0);

begin
	uut_cu : control_unit port map(
		 Zero_flag => Zero_flag,
		 Reset => Reset,
		 clk => clk,
		 MAR_OE => MAR_OE,
		 MARWrite => MARWrite,
		 MR_OE_InOut => MR_OE_InOut,
		 MRWrite_fromMem => MRWrite_fromMem,
		 MRWrite_fromALU => MRWrite_fromAlu,
		 MemRead => MemRead,
		 MemWrite => MemWrite,
		 IRWrite => IRWrite,
		 RgFileRW => RgFileRW,
		 Control_VC => ControlVC,
		 Select_MUXA => Select_MUXA,
		 Instruction => Instruction,
		 ALU => ALU_operation,
		 AddrA => AddrA,AddrB => AddrB,AddrC => AddrC,
		 Select_MUXB => Select_MUXB
	);
	uut_mr : MR port map(
		MR_InALU => MR_InALU,
		MR_OE_InOut => MR_OE_InOut,
		MRWrite_fromMem => MRWrite_fromMem,
		MRWrite_fromALU => MRWrite_fromALU,
		clk => clk,
		MR_InOut => MR_InOut,
		MR_Out => MR_Out
	);
	uut_mar : MAR port map(
		MAR_In =>MAR_In,
		MAR_OE =>MAR_OE, 
		MARWrite =>MARWrite,
		clk =>clk,
		MAR_Out =>MAR_Out
	);
	uut_memory_mux : MemoryMUX port map(
		MemRead => MemRead,
		MemWrite => MemWrite,
		Reset => Reset,
		MAR_Out => MAR_Out,
		Address => Address,
		Read =>Read, Write => Write
	);
	uut_reg : reg18_8 port map(
		RgMask => RgMask,
		Reset => Reset,
		PortC => PortC,
		AddrA => AddrA,AddrB => AddrB,AddrC => AddrC,
		RgFileRW => RgFileRW,
		clk => clk,
		PortB_RF => PortB_RF,
		PortA_RF => PortB_RF,
		I_en => I_en
	);
	uut_memory : Memory256Kx18 port map(
		Address => Address,
		Read => Read,
		Write => Write,
		clk => clk,
		Data => Data
	);
	uut_muxa : MUXA port map( 
		PortA_RF => PortA_RF,
		MR_Out => MR_Out,
		Select_MUXA => Select_MUXA,
		OutA => OperandA
	);
	uut_muxb : MUXB port map(
		CS_Out => CS_Out,
		VC_Out => VC_Out,
		PortB_RF => PortB_RF,
		Select_MUXB => Select_MUXB,
		OutB => OperandB
	);
	uut_alu : ALU port map(
		InA	=> OperandA,InB => OperandB,
		ALU => ALU_operation,
		AddrB => AddrB, 
		Zero_flag => Zero_flag,
		OutC => MAR_In
	);
	uut_ir : IR port map(
		IR_In => IR_In,
		IRWrite => IRWrite,
		clk => clk,
		IR_Out => IR_Out,
		lliteral => lliteral
	);
end cpu_arc;
