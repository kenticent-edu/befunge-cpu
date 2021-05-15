library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.all;  	
use IEEE.STD_LOGIC_UNSIGNED.all;

entity ALU_MUX is
	port(
		ALU_CU : in std_logic_vector(2 downto 0); -- in 1
		ALU_Com : in std_logic_vector(2 downto 0); -- in 2
		ALU_source : in std_logic; -- S signal
		ALU : out std_logic_vector(2 downto 0) -- out
	);
end ALU_MUX;

architecture ALU_MUX of ALU_MUX is
begin
	process(ALU_CU, ALU_Com, ALU_source)
	begin
		if ALU_source='0' then ALU <= ALU_CU;
		else ALU <= ALU_Com;
		end if;
	end process;
end ALU_MUX;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.all;  	
use IEEE.STD_LOGIC_UNSIGNED.all;

entity ALU_MUX is
	port(
		ALU_CU : in std_logic_vector(2 downto 0); -- in 1
		ALU_Com : in std_logic_vector(2 downto 0); -- in 2
		ALU_source : in std_logic; -- S signal
		ALU : out std_logic_vector(2 downto 0) -- out
	);
end ALU_MUX;

architecture behavioral of ALU_MUX is
begin
	process(ALU_CU, ALU_Com, ALU_source)
	begin 
		if ALU_source='0' then ALU <= ALU_CU;
		else ALU <= ALU_Com; end if;
	end process;
end behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.all;  	
use IEEE.STD_LOGIC_UNSIGNED.all;

entity AddrA_MUX is
	port(
		AddrA_CU : in std_logic_vector(2 downto 0); -- in 1
		AddrA_Com : in std_logic_vector(2 downto 0); -- in 2
		AddrC_Com : in std_logic_vector(2 downto 0); -- in 3
		AddrA_source : in std_logic_vector(1 downto 0); -- S signal
		AddrA : out std_logic_vector(2 downto 0) -- out
	);
end AddrA_MUX;

architecture AddrA_MUX of AddrA_MUX is
begin
	process(AddrA_CU, AddrA_Com, AddrC_Com, AddrA_source)
	begin
		case AddrA_source is
			when "00" => AddrA <= AddrA_CU;
			when "01" => AddrA <= AddrA_Com;
			when "10" => AddrA <= AddrC_Com;
			when others => AddrA <= "ZZZ";
		end case;
	end process;
end AddrA_MUX;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.all;  	
use IEEE.STD_LOGIC_UNSIGNED.all;

entity AddrC_MUX is
	port(
		AddrC_CU : in std_logic_vector(2 downto 0); -- in 1
		AddrC_Com : in std_logic_vector(2 downto 0); -- in 2
		AddrC_source : in std_logic; -- S signal
		AddrC : out std_logic_vector(2 downto 0) -- out
	);
end AddrC_MUX;

architecture AddrC_MUX of AddrC_MUX is
begin
	process(AddrC_CU, AddrC_Com, AddrC_source)
	begin
		if AddrC_source='0' then AddrC <= AddrC_CU;
		else AddrC <= AddrC_Com; end if;
	end process;
end AddrC_MUX;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.all;  	
use IEEE.STD_LOGIC_UNSIGNED.all;

entity AddrB_MUX is
	port(
		AddrB_CU : in std_logic_vector(2 downto 0); -- in 1
		AddrB_Com : in std_logic_vector(2 downto 0); -- in 2
		AddrB_source : in std_logic; -- S signal
		AddrB : out std_logic_vector(2 downto 0) -- out
	);
end AddrB_MUX;

architecture AddrB_MUX of AddrB_MUX is
begin
	process(AddrB_CU, AddrB_Com, AddrB_source)
	begin
		if AddrB_source='0' then AddrB <= AddrB_CU;
		else AddrB <= AddrB_Com; end if;
	end process;
end AddrB_MUX;


library IEEE;
use IEEE.std_logic_1164.all;

entity mux_2_1 is
	 port(
		 SEL : in STD_LOGIC;
		 A : in STD_LOGIC_VECTOR(2 downto 0);
		 B : in STD_LOGIC_VECTOR(2 downto 0);
		 MUX_OUT : out STD_LOGIC_VECTOR(2 downto 0)
	     );
end mux_2_1;

architecture mux_2_1_arc of mux_2_1 is
begin
	with SEL select
	MUX_OUT <= A when '0',
			   B when '1',
			   (others => '0') when others;
end mux_2_1_arc;


library IEEE;
use IEEE.std_logic_1164.all;

entity mux_3_1 is
	 port(
		 SEL : in STD_LOGIC_VECTOR(1 downto 0);
		 A : in STD_LOGIC_VECTOR(2 downto 0);
		 B : in STD_LOGIC_VECTOR(2 downto 0);
		 C : in STD_LOGIC_VECTOR(2 downto 0);
		 MUX_OUT : out STD_LOGIC_VECTOR(2 downto 0)
	     );
end mux_3_1;

architecture mux_3_1_arc of mux_3_1 is
begin
	with SEL select
	MUX_OUT <= A when "00",
			   B when "01",
			   C when "10",
			   (others => '0') when others;
end mux_3_1_arc;
