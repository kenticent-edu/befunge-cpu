library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity RegisterFile8x18 is
	 port(
		 Reset : in STD_LOGIC;
		 RgFileRW : in STD_LOGIC; -- TODO: Give a more meaningful name
		 clk : in STD_LOGIC;
		 RgMask : in STD_LOGIC_VECTOR(1 downto 0);
		 PortC : in STD_LOGIC_VECTOR(17 downto 0);
		 AddrA : in STD_LOGIC_VECTOR(2 downto 0);
		 AddrB : in STD_LOGIC_VECTOR(2 downto 0);
		 AddrC : in STD_LOGIC_VECTOR(2 downto 0);
		 PortB_RF : out STD_LOGIC_VECTOR(17 downto 0);
		 PortA_RF : out STD_LOGIC_VECTOR(17 downto 0)
	     );
end RegisterFile8x18;

architecture RegisterFile8x18_arc of RegisterFile8x18 is

type store_t is array (0 to 7) of std_logic_vector(17 downto 0);
signal regs : store_t := (others => "000000000000000000");

-- Masking modes
constant scalar_mode : std_logic_vector(1 downto 0) := "00";
constant x_mode : std_logic_vector(1 downto 0) := "01";
constant y_mode : std_logic_vector(1 downto 0) := "10";
constant vector_mode : std_logic_vector(1 downto 0) := "11";

begin
	
	process(clk,Reset)
	begin
		if (Reset = '1') then
			regs <= (others => (others => '0'));
			--regs(6) <= "000000001000000001";
			--regs(7) <= "111111111111111111";
			regs(2) <= "000000000000000001";
		elsif (rising_edge(clk) and RgFileRW='1') then
			case RgMask is
				when scalar_mode | vector_mode =>
					regs(to_integer(unsigned(AddrC))) <= PortC;	
				when x_mode =>
					regs(to_integer(unsigned(AddrC)))(8 downto 0) <= PortC(8 downto 0);
				when y_mode =>
					regs(to_integer(unsigned(AddrC)))(17 downto 9) <= PortC(17 downto 9);
				when others =>
					null;
			end case;	
		end if;	
	end process;
	
	PortA_RF <= regs(to_integer(unsigned(AddrA)));
	PortB_RF <= regs(to_integer(unsigned(AddrB)));
	
end RegisterFile8x18_arc;
