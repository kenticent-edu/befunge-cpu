library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity state_machine_tb is
end state_machine_tb;

architecture state_machine_tb_arch of state_machine_tb is
  
-- Component Declaration for the Unit Under Test (UUT)

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

-- Inputs
signal Group_Com,Zero_flag,clk,Reset : std_logic;
signal OpCode_Com : std_logic_vector(2 downto 0);

-- Outputs
signal Address : std_logic_vector(7 downto 0);

-- Clock period definitions
constant I_clk_period : time := 10 ns;

begin
	
	-- Instantiate the Unit Under Test (UUT)
   uut: state_machine PORT MAP (
          Group_Com => Group_Com,
		 Zero_flag => Zero_flag,
		 clk => clk,
		 Reset => Reset,
		 OpCode_Com => OpCode_Com,
		 Address => Address
        );
		
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
	  Group_Com <= '0';
	  Zero_flag <= '0';
	  OpCode_Com <= "001";
	  	wait for I_clk_period;
	  
	  wait;
	 end process;
	
end state_machine_tb_arch;	
