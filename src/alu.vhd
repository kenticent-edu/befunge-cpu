library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;  	
use IEEE.STD_LOGIC_UNSIGNED.all;

entity BEFUNGE_ALU is
	port(
	a,b : in std_logic_vector(17 downto 0); -- src1, src2
	mask_mode : in std_logic_vector(1 downto 0); -- vector,X,Y,Scalar 
	opcode : in std_logic_vector(2 downto 0); -- 000 to 111
	c : out std_logic_vector(17 downto 0) -- ALU Output Result
	);
end BEFUNGE_ALU;


architecture Behavioral of BEFUNGE_ALU is
begin
	process(opcode,a,b)	
	begin
		case opcode is
			when "000" => -- add
			case mask_mode is 
				when "00" => -- vector mode
				c(17 downto 8) <= a(17 downto 8)+b(17 downto 8);
				c(8 downto 0) <= a(8 downto 0)+b(8 downto 0);
				when "01" => -- X mode	   
				c(8 downto 0) <= a(8 downto 0)+b(8 downto 0);
				when "10" => -- Y mode
				c(17 downto 8) <= a(17 downto 8)+b(17 downto 8);
				when others => c <= a+b; -- "11" Scalar mode
			end case;

			when "001" =>	 -- sub
			case mask_mode is 
				when "00" => -- vector mode
				c(17 downto 8) <= a(17 downto 8)-b(17 downto 8);
				c(8 downto 0) <= a(8 downto 0)-b(8 downto 0);
				when "01" => -- X mode	   
				c(8 downto 0) <= a(8 downto 0)-b(8 downto 0);
				when "10" => -- Y mode
				c(17 downto 8) <= a(17 downto 8)-b(17 downto 8);
				when others => c <= a-b; --- "11" Scalar mode
			end case;

			when "010" => -- and
			case mask_mode is 
				when "00" => -- vector mode
				c(17 downto 8) <= a(17 downto 8) and b(17 downto 8);
				c(8 downto 0) <= a(8 downto 0) and b(8 downto 0);
				when "01" => -- X mode	   
				c(8 downto 0) <= a(8 downto 0) and b(8 downto 0);
				when "10" => -- Y mode
				c(17 downto 8) <= a(17 downto 8) and b(17 downto 8);
				when others => c <= a and b; --- "11" Scalar mode
			end case;

			when "011" => -- or
			case mask_mode is 
				when "00" => -- vector mode
				c(17 downto 8) <= a(17 downto 8) or b(17 downto 8);
				c(8 downto 0) <= a(8 downto 0) or b(8 downto 0);
				when "01" => -- X mode	   
				c(8 downto 0) <= a(8 downto 0) or b(8 downto 0);
				when "10" => -- Y mode
				c(17 downto 8) <= a(17 downto 8) or b(17 downto 8);
				when others => c <= a or b; --- "11" Scalar mode
			end case; 

			when "100" => -- xor
			case mask_mode is 
				when "00" => -- vector mode
				c(17 downto 8) <= a(17 downto 8) xor b(17 downto 8);
				c(8 downto 0) <= a(8 downto 0) xor b(8 downto 0);
				when "01" => -- X mode	   
				c(8 downto 0) <= a(8 downto 0) xor b(8 downto 0);
				when "10" => -- Y mode
				c(17 downto 8) <= a(17 downto 8) xor b(17 downto 8);
				when others => c <= a xor b; --- "11" Scalar mode
			end case;

			when others => c <= "000000000000000000"; -- add
			end case;
		end process;
end Behavioral;	 


entity BEFUNGE_ALU_TB is
end BEFUNGE_ALU_TB;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;  	
use IEEE.STD_LOGIC_UNSIGNED.all;

architecture test of BEFUNGE_ALU_TB is
signal a,b,c : std_logic_vector(17 downto 0);
signal mask_mode : std_logic_vector(1 downto 0);
signal opcode : std_logic_vector(2 downto 0);
uut : BEFUNGE_ALU port map(
	a =>a,
	b =>b,
	c => c,
	mask_mode =>mask_mode,
	opcode=>opcode);

	process(a,b,c,mask_mode,opcode)	
	begin
		opcode <= "000";
		mask_mode <= "00";
		a <= "0100000010100000001";
		b <= "0100000010100000010";
		assert(c="1000000100000000011") report "sum failed";
	end process;
end test;
