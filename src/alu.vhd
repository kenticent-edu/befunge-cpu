library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.all;  	
use IEEE.STD_LOGIC_UNSIGNED.all;

entity ALU is
	port(
		InA,InB : in std_logic_vector(17 downto 0);
		ALU, AddrB : in std_logic_vector(2 downto 0); 
		Zero_flag : out std_logic;
		OutC : out std_logic_vector(17 downto 0)
	);
end ALU;


architecture ALU of ALU is
begin
	process(ALU,AddrB,InA,InB)	
	begin
		case ALU is
			when "111" =>
				case AddrB is 
					when "000" => -- NOT
					OutC <= not InA;
				    when "001" => -- SHR
					OutC <= "000000000000000000";
					OutC(16 downto 0) <= InA(17 downto 1);
					when others => OutC <= "ZZZZZZZZZZZZZZZZZZ";
				end case;
			when "000" => OutC <= InA + InB;   -- ADD
			when "001" => OutC <= InA - InB;   -- SUB
			when "010" => OutC <= InA and InB; -- AND
			when "011" => OutC <= InA or InB;  -- OR
			when "100" => OutC <= InA xor InB; -- XOR
			when others => OutC <= "ZZZZZZZZZZZZZZZZZZ";
		end case;
	end process;
end ALU;
