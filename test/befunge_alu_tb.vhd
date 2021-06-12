library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity ALU_tb is
end;

architecture bench of ALU_tb is

  component ALU
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

  signal Zero_flag: STD_LOGIC;
  signal InB: STD_LOGIC_VECTOR(17 downto 0);
  signal InA: STD_LOGIC_VECTOR(17 downto 0);
  signal ALU_Sel: STD_LOGIC_VECTOR(2 downto 0);
  signal AddrB: STD_LOGIC_VECTOR(2 downto 0);
  signal OutC: STD_LOGIC_VECTOR(17 downto 0);
  signal ALUMask: STD_LOGIC_VECTOR(1 downto 0) ;

begin

  uut: ALU port map ( Zero_flag => Zero_flag,
                      InB       => InB,
                      InA       => InA,
                      ALU_Sel   => ALU_Sel,
                      AddrB     => AddrB,
                      OutC      => OutC,
                      ALUMask   => ALUMask );

  stimulus: process
  begin
  
    -- Put initialisation code here
	InA <= (others => '0');
	InB <= (others => '0');
	ALU_Sel <= "000";
	AddrB <= "000";
	ALUMask <= "00";
	wait for 10 ns;

    -- Put test bench stimulus code here
	InA <= "001010010010100101";
	InB <= "000111011000000100";
	wait for 10 ns;
	
	InA <= "000000000111111111";
	InB <= "000000000000000001";
	ALUMask <= "11";
	wait for 10 ns;
	
	ALUMask <= "00";
	wait for 10 ns;

    wait;
  end process;


end;
