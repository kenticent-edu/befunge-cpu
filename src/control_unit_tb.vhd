LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY control_unit_tb IS
END control_unit_tb;
 
ARCHITECTURE control_unit_tb_arc OF control_unit_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
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
 
   --Inputs
	signal Zero_flag : STD_LOGIC := '0';
	signal Reset : STD_LOGIC := '0';
	signal clk : STD_LOGIC := '0';
	signal Instruction : STD_LOGIC_VECTOR(17 downto 0) := (others => '0');
 
  --Outputs
	signal MAR_OE : STD_LOGIC;
	signal MARWrite : STD_LOGIC;
	signal MR_OE_InOut : STD_LOGIC;
	signal MRWrite_fromMem : STD_LOGIC;
	signal MRWrite_fromALU : STD_LOGIC;
	signal MemRead : STD_LOGIC;
	signal MemWrite : STD_LOGIC;
	signal IRWrite : STD_LOGIC;
	signal RgFileRW : STD_LOGIC;
	signal Control_VC : STD_LOGIC;
	signal Select_MUXA : STD_LOGIC;
	signal ALU : STD_LOGIC_VECTOR(2 downto 0);
	signal AddrA : STD_LOGIC_VECTOR(2 downto 0);
	signal AddrB : STD_LOGIC_VECTOR(2 downto 0);
	signal AddrC : STD_LOGIC_VECTOR(2 downto 0);
	signal Select_MUXB : STD_LOGIC_VECTOR(1 downto 0);
 
   -- Clock period definitions
   constant I_clk_period : time := 10 ns;
 
BEGIN
 
  -- Instantiate the Unit Under Test (UUT)
   uut: control_unit PORT MAP (Zero_flag,Reset,clk,MAR_OE,MARWrite,
		MR_OE_InOut,MRWrite_fromMem,MRWrite_fromALU,MemRead,MemWrite,
		IRWrite,RgFileRW,Control_VC,Select_MUXA,Instruction,ALU,AddrA,
		AddrB,AddrC,Select_MUXB);
 
   -- Clock process definitions
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
		Zero_flag <= '0';
		--Instruction <= (others => '0');
			wait for I_clk_period;
	  
		wait;  
	end process;
	
end control_unit_tb_arc;	
