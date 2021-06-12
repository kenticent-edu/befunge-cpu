library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ALU is
	 port(
		 Zero_flag : out STD_LOGIC;
		 InB : in STD_LOGIC_VECTOR(17 downto 0);
		 InA : in STD_LOGIC_VECTOR(17 downto 0);
		 ALU_Sel : in STD_LOGIC_VECTOR(2 downto 0);
		 AddrB : in STD_LOGIC_VECTOR(2 downto 0);
		 OutC : out STD_LOGIC_VECTOR(17 downto 0);
		 ALUMask : in STD_LOGIC_VECTOR(1 downto 0)
	     );
end ALU;

architecture ALU_arc of ALU is

-- Masking modes
constant scalar_mode : std_logic_vector(1 downto 0) := "00";
constant x_mode : std_logic_vector(1 downto 0) := "01";
constant y_mode : std_logic_vector(1 downto 0) := "10";
constant vector_mode : std_logic_vector(1 downto 0) := "11";

constant one : std_logic_vector(8 downto 0) := "000000001";
constant zero : std_logic_vector(8 downto 0) := (others => '0');

signal inter_out : std_logic_vector(17 downto 0);
begin
	
	-- Set process sensetivity to all input signals
	process(InA,InB,ALU_Sel,AddrB,ALUMask) 
	
	variable a_wo : std_logic_vector(8 downto 0);
	variable a_rd : std_logic_vector(8 downto 0);
	variable b_wo : std_logic_vector(8 downto 0);
	variable b_rd : std_logic_vector(8 downto 0);
	
	variable temp : std_logic_vector(8 downto 0);
	
	begin
	case ALUMask is
		
		when scalar_mode =>
			if (ALU_Sel = "111") then
				case AddrB is
					when "000" =>
						inter_out <= not InA;
					when "001" =>
						-- TODO: add flor divison by 2
						inter_out <='0'&InA(17 downto 1);
					when "010" =>
						inter_out <= std_logic_vector(signed(InA) + signed(one & one));
					when "011" =>
						inter_out <= std_logic_vector(signed(InA) - signed(one & one));
					when others =>
						inter_out <=	(others => '0');
				end case;
			else 
				case ALU_Sel is
					when "000" =>
						-- DON'T take into account potential carry out in this and future 
						-- cases
						inter_out <= std_logic_vector(signed(InA) + signed(InB)); 
					when "001" =>
						inter_out <= std_logic_vector(signed(InA) - signed(InB));
					when "010" =>	
						inter_out <= InA and InB;
					when "011" =>
						inter_out <= InA or InB;
					when "100" =>
						inter_out <= InA xor InB;
					when others =>
						inter_out <= (others => '0');
				end case;	
			end if;
			
		when x_mode =>
			a_rd := InA(8 downto 0);
			if (ALU_Sel = "111") then
				case AddrB is
					when "000" =>
						temp := not a_rd;
					when "001" =>
						-- TODO: add flor divison by 2
						--temp := InA(17 downto 10)&'0'&InA(8 downto 1);
						temp := '0'&InA(8 downto 1);
					when "010" =>
						temp := std_logic_vector(signed(a_rd) + signed(one));
					when "011" =>
						temp := std_logic_vector(signed(a_rd) - signed(one));
					when others =>
						temp :=	(others => '0');
				end case;
			else
				b_rd := InB(8 downto 0);
				case ALU_Sel is
					when "000" =>
						temp :=	std_logic_vector(signed(a_rd) + signed(b_rd)); 
					when "001" =>
						temp :=	std_logic_vector(signed(a_rd) - signed(b_rd));
					when "010" =>	
						temp :=	a_rd and b_rd;
					when "011" =>
						temp :=	a_rd or b_rd;
					when "100" =>
						temp :=	a_rd xor b_rd;
					when others =>
						temp :=	(others => '0');
				end case;	
			end if;
			inter_out <= zero & temp;
			
		when y_mode =>
			a_wo := InA(17 downto 9);
			if (ALU_Sel = "111") then
				case AddrB is
					when "000" =>
						temp := not a_wo;
					when "001" =>
						-- TODO: add flor divison by 2
						--temp := '0'&InA(17 downto 10)&InA(8 downto 0);
						temp := '0'&InA(17 downto 10);
					when "010" =>
						temp := std_logic_vector(signed(a_wo) + signed(one));
					when "011" =>
						temp := std_logic_vector(signed(a_wo) - signed(one));
					when others =>
						temp :=	(others => '0');
				end case;
			else
				b_wo := InB(17 downto 9);
				case ALU_Sel is
					when "000" =>
						temp :=	std_logic_vector(signed(a_wo) + signed(b_wo)); 
					when "001" =>
						temp :=	std_logic_vector(signed(a_wo) - signed(b_wo));
					when "010" =>	
						temp :=	a_wo and b_wo;
					when "011" =>
						temp :=	a_wo or b_wo;
					when "100" =>
						temp :=	a_wo xor b_wo;
					when others =>
						temp :=	(others => '0');
				end case;	
			end if;
			inter_out <= temp & zero;
			
		when vector_mode =>
			a_wo := InA(17 downto 9);
			a_rd := InA(8 downto 0);
			if (ALU_Sel = "111") then
				case AddrB is
					when "000" =>
						inter_out <= not InA;
					when "001" =>
						-- TODO: add flor divison by 2
						inter_out <= '0'&InA(17 downto 10) & '0'&InA(8 downto 1);
					when "010" =>
						inter_out <= std_logic_vector(signed(a_wo) + signed(one))
							& std_logic_vector(signed(a_rd) + signed(one));
					when "011" =>
						inter_out <= std_logic_vector(signed(a_wo) - signed(one))
							& std_logic_vector(signed(a_rd) - signed(one));
					when others =>
						inter_out <= (others => '0');
				end case;
			else
				b_wo := InB(17 downto 9);
				b_rd := InB(8 downto 0);
				case ALU_Sel is
					when "000" =>
						inter_out <= std_logic_vector(signed(a_wo) + signed(b_wo)) 
							& std_logic_vector(signed(a_rd) + signed(b_rd)); 
					when "001" =>
						inter_out <= std_logic_vector(signed(a_wo) - signed(b_wo)) 
							& std_logic_vector(signed(a_rd) - signed(b_rd));
					when "010" =>	
						inter_out <= (a_wo and b_wo) & (a_rd and b_rd);
					when "011" =>
						inter_out <= (a_wo or b_wo) & (a_rd or b_rd);
					when "100" =>
						inter_out <= (a_wo xor b_wo) & (a_rd xor b_rd);
					when others =>
						inter_out <= (others => '0');
				end case;	
			end if;
			
		when others =>
			inter_out <= (others => '0');
			
		end case;
	end process;
	
	OutC <= inter_out;
	Zero_flag <= '1' when inter_out = (zero & zero) else '0';
		
end ALU_arc;
