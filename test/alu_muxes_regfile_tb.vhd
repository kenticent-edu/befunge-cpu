library IEEE;
use IEEE.std_logic_1164.all;

entity alu_regfile_tb is
end alu_regfile_tb;

architecture arch of alu_regfile_tb is
component alu_regfile is
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
end component;

constant I_clk_period : time := 10 ns;
signal clk : std_logic;
signal RgMask : std_logic_vector(1 downto 0);
signal Reset : std_logic;
signal PortC : std_logic_vector(17 downto 0);
signal AddrA, AddrB, AddrC : std_logic_vector(2 downto 0);
signal RgFileRW : std_logic;
signal I_en : std_logic;
signal VC_Out, CS_Out : std_logic_vector(17 downto 0); -- EXTERNAL
signal Select_MUXB : std_logic_vector(1 downto 0);
signal Select_MUXA : std_logic;
signal MR_out : std_logic_vector(17 downto 0); -- EXTERNAL
signal ALU_operation : std_logic_vector(2 downto 0);
signal Zero_flag : std_logic;
signal OutC : std_logic_vector(17 downto 0);

begin
	uut : alu_regfile port map(
		clk => clk,
		RgMask => RgMask,
		Reset => Reset,
		PortC => PortC,
		AddrA => AddrA, AddrB => AddrB, AddrC => AddrC,
		RgFileRW => RgFileRW,
		I_en => I_en,
		VC_Out => VC_Out,
		CS_Out => CS_Out,
		Select_MUXB => Select_MUXB,
		Select_MUXA => Select_MUXA,
		MR_out => MR_Out,
		ALU_operation => ALU_operation,
		Zero_flag => Zero_flag,
		OutC => OutC
	);

	I_clk_process :process
	begin
    clk <= '0';
    wait for I_clk_period/2;
    clk <= '1';
    wait for I_clk_period/2;
	end process;
   
	-- Stimulus process
	stim_proc: process
	begin
	   -- hold reset state for 100 ns.
	wait for 100 ns;  
	wait for I_clk_period*10;
	-- insert stimulus here
	Reset <= '1';
	wait for I_clk_period;
	Reset <= '0';
	wait for I_clk_period;
	wait;
	end process;

	MUXES : process
	begin
		
	end process;
end arch;





