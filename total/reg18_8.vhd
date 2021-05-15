library IEEE;
use IEEE.std_logic_1164.all;

use IEEE.NUMERIC_STD.ALL;	

----------------------------
-- Description of reg18_8 --
----------------------------
entity reg18_8 is
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
end reg18_8;	

architecture behavioral of reg18_8 is
	type store_t is array (0 to 7) of std_logic_vector(17 downto 0);
	signal regs: store_t := (others => "000000000000000000");
begin
	process(clk)
	begin
		if (reset = '1') then
			regs(0) <= "000000000000000000";
			regs(1) <= "000000000000000000";
			regs(2) <= "000000000000000001";
			regs(3) <= "000000000000000000";
			regs(4) <= "000000000000000000";
			regs(5) <= "000000000000000000";
			regs(6) <= "000000000000000000";
			regs(7) <= "000000000000000000"; 
		elsif (rising_edge(clk) and RgFileRW='1') then
			regs(to_integer(unsigned(AddrC))) <= PortC;
		end if;
	end process;
	PortA_RF <= regs(to_integer(unsigned(AddrA)));
	PortB_RF <= regs(to_integer(unsigned(AddrB)));
end behavioral;	