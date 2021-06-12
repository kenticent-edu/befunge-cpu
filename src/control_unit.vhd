library IEEE;
use IEEE.std_logic_1164.all;

entity ControlUnit is
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
end ControlUnit;

architecture control_unit_arc of ControlUnit is

	-- state machine -----------------
	component state_machine is
		 port(
			 Group_Com : in STD_LOGIC;
			 Zero_flag : in STD_LOGIC;
			 clk : in STD_LOGIC;
			 Reset : in STD_LOGIC;
			 OpCode_Com : in STD_LOGIC_VECTOR(2 downto 0);
			 Address : out STD_LOGIC_VECTOR(7 downto 0)
		     );
	end component;
	
	-- ROM ---------------------------
	component rom is
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
	end component;
	
	-- MUX_2_1 -----------------------
	component mux_2_1 is
		 port(
			 SEL : in STD_LOGIC;
			 A : in STD_LOGIC_VECTOR(2 downto 0);
			 B : in STD_LOGIC_VECTOR(2 downto 0);
			 MUX_OUT : out STD_LOGIC_VECTOR(2 downto 0)
		     );
	end component;
	
	-- MUX_3_1 -----------------------
	component mux_3_1 is
		 port(
			 SEL : in STD_LOGIC_VECTOR(1 downto 0);
			 A : in STD_LOGIC_VECTOR(2 downto 0);
			 B : in STD_LOGIC_VECTOR(2 downto 0);
			 C : in STD_LOGIC_VECTOR(2 downto 0);
			 MUX_OUT : out STD_LOGIC_VECTOR(2 downto 0)
		     );
	end component;

	component mux_1_1 is
	 port(
		 SEL : in STD_LOGIC;
		 A : in STD_LOGIC_VECTOR(1 downto 0);
		 B : in STD_LOGIC_VECTOR(1 downto 0);
		 MUX_OUT : out STD_LOGIC_VECTOR(1 downto 0)
	     );
	end component;
	
	-- intermediate	signal declaration
	signal p1_out : std_logic_vector(7 downto 0);
	signal p2_out,p4_out,p6_out,p8_out : std_logic_vector(2 downto 0);
	signal p3_out,p5_out,p9_out,p11_out,p13_out : std_logic;
	signal p7_out,p10_out,p12_out : std_logic_vector(1 downto 0);
	
begin
	sm1: state_machine port map (Group_Com => Instruction(17),
								 OpCode_Com => Instruction(14 downto 12),
								 Zero_flag => Zero_flag,
								 clk => clk,
								 Reset => Reset,
								 Address => p1_out);
	rom1: rom port map (Address => p1_out,
						ALU_CU => p2_out,
						ALU_source => p3_out,
					    AddrC_CU => p4_out,
					    AddrC_source => p5_out,
					    AddrA_CU => p6_out,
					    AddrA_source => p7_out,
					    AddrB_CU => p8_out,
					    AddrB_source =>	p9_out,
					    MAR_OE => MAR_OE,
					    MARWrite => MARWrite,
					    MR_OE_InOut => MR_OE_InOut,
					    MRWrite_fromMem => MRWrite_fromMem,
					    MRWrite_fromALU => MRWrite_fromALU,
					    MemRead => MemRead,
					    MemWrite =>	MemWrite,
					    IRWrite => IRWrite,
					    RgFileRW =>	RgFileRW,
					    Control_VC => Control_VC,
					    Select_MUXB => Select_MUXB,
					    Select_MUXA => Select_MUXA,
						ALUMask_CU => p10_out,
						ALUMask_source => p11_out,
						RgMask_CU => p12_out,
						RgMask_source => p13_out);
	m1: MUX_2_1 port map (A => p2_out,
						  B => Instruction(8 downto 6),			
						  SEL => p3_out,
						  MUX_OUT => ALU);
	m2: MUX_2_1 port map (A => p4_out,
						  B => Instruction(11 downto 9),
						  SEL => p5_out,
						  MUX_OUT => AddrC);
	m3: MUX_3_1 port map (A => p6_out,
						  B => Instruction(5 downto 3),
						  C => Instruction(11 downto 9),
						  SEL => p7_out,
						  MUX_OUT => AddrA);
	m4: MUX_2_1 port map (A => p8_out,
						  B => Instruction(2 downto 0),
						  SEL => p9_out,
						  MUX_OUT => AddrB);
	m5: MUX_1_1 port map (A => p10_out,
						  B => Instruction(16 downto 15),
						  SEL => p11_out,
						  MUX_OUT => ALUMask);
	m6: MUX_1_1 port map (A => p12_out,
						  B => Instruction(16 downto 15),
						  SEL => p13_out,
						  MUX_OUT => RgMask);
end control_unit_arc;
