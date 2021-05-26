library IEEE;
use IEEE.std_logic_1164.all;

entity alu_regfile is
	port(
	clk : in STD_LOGIC; -- clock
	-- register  file
	RgMask : in std_logic_vector(1 downto 0);
	Reset : in std_logic;
	PortC : in std_logic_vector(17 downto 0);
	AddrA, AddrB, AddrC : in std_logic_vector(2 downto 0);
	RgFileRW : in std_logic;
	-- clk
	I_en : in std_logic;
	-- MUXB
	VC_Out : in std_logic_vector(17 downto 0); -- EXTERNAL
	CS_Out : in std_logic_vector(17 downto 0); -- EXTERNAL
	-- PortB_RF
	Select_MUXB : in std_logic_vector(1 downto 0);
	-- MUXA
	-- PortA_RF
	Select_MUXA : in std_logic;
	MR_out : in std_logic_vector(17 downto 0); -- EXTERNAL
	-- ALU
	ALU_operation : in std_logic_vector(2 downto 0);
	-- AddrB
	Zero_flag : out std_logic;
	OutC : out std_logic_vector(17 downto 0)
);
end alu_regfile;


architecture arch of alu_regfile is
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

signal PortB_RF, PortA_RF : std_logic_vector(17 downto 0);
signal OperandA, OperandB : std_logic_vector(17 downto 0); --OutA for MUXB, InA for ALU, OutB for MUXA, InB for ALU 

begin
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
		OutC => OutC
	);
	process(clk, Reset)
	begin
	end process;
end arch;





