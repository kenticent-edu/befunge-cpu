library IEEE;
use IEEE.std_logic_1164.all;

entity reg18 is
	port ( REG_IN  :  in std_logic_vector(17 downto 0);
	       LD,CLK  :  in std_logic;
		   REG_OUT : out std_logic_vector(17 downto 0));
end reg18;

architecture reg18 of reg18 is
begin
	reg: process(CLK)
	begin
		if (rising_edge(CLK)) then
			if (LD = '1') then
				REG_OUT <= REG_IN;
			end if;
		end if;
	end process;
end reg18;
