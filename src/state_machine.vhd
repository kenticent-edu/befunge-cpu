library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity state_machine is
	 port(
		 Group_Com : in STD_LOGIC;
		 Zero_flag : in STD_LOGIC;
		 clk : in STD_LOGIC;
		 Reset : in STD_LOGIC;
		 OpCode_Com : in STD_LOGIC_VECTOR(2 downto 0);
		 Address : out STD_LOGIC_VECTOR(7 downto 0)
	     );
end state_machine;

architecture state_machine_arc of state_machine is

type state_type is (IF_state,ID,Execute0,Execute1,Check_flag,IncPC);
signal State : state_type;

signal counter : std_logic_vector(7 downto 0) := "00000000";
signal IncPC_counter : std_logic_vector(7 downto 0) := "11111100";

type memory is array (0 to 15) of std_logic_vector(7 downto 0);
constant ROMSA : memory := (
	1 =>  "00000101", -- 0 & 001 - Load literal
	2 =>  "00000111", -- 0 & 010 - Load double literal
	3 =>  "00010000", -- SZ
	4 =>  "00010000", -- SNZ
	7 =>  "00001001",
	8 =>  "00001001",
	9 =>  "00010010",
	10 => "00001001",
	11 => "00001001",
	12 => "00011000",
	15 => "00001111",
	others => "00000000");
constant ROMFA : memory := (
	1 =>  "00000110",
	2 =>  "00001000",
	3 =>  "00010001", -- SZ
	4 =>  "00010001", -- SNZ
	7 =>  "00001010",
	8 =>  "00001010",
	9 =>  "00010111",
	10 => "00001010",
	11 => "00001010",
	12 => "00011100",
	15 => "00001111",
	others => "00000000");

signal opcode : std_logic_vector(3 downto 0);

signal Start_Address : std_logic_vector(7 downto 0); 
signal Finish_Address : std_logic_vector(7 downto 0);
signal cur_address : std_logic_vector(7 downto 0);

constant SZ : std_logic_vector(3 downto 0) := "0011";
constant SNZ : std_logic_vector(3 downto 0) := "0100";  
constant DZ : std_logic_vector(3 downto 0) := "0101";
constant DNZ : std_logic_vector(3 downto 0) := "0110";

begin
	opcode <= Group_Com & OpCode_Com;
	
	super_proc: process(clk,Reset)
	variable temp : integer;
	begin
		if (Reset = '1') then
			counter <= "00000000";
			State <= IF_state;
		elsif (rising_edge(clk)) then
			case State is
				when IF_state =>
					if (counter = "00000100") then -- IR = MEM[PC]
						State <= ID;
					else
						counter <= std_logic_vector(unsigned(counter) + 1);
					end if;
					cur_address <= counter;
				when ID =>
					temp := to_integer(unsigned(opcode)); 
					Start_Address <= std_logic_vector(unsigned( ROMSA(temp) ) + 1);
					Finish_Address <= ROMFA(to_integer(unsigned(opcode)));
					cur_address <= ROMSA(to_integer(unsigned(opcode)));
					if (opcode=SZ or opcode=SNZ or opcode=DZ or opcode=DNZ) then
						State <= Execute1;
					else
						State <= Execute0;
					end if;
				when Execute1 =>
					cur_address <= Start_Address;
					if (cur_address >= Finish_Address) then -- the result of comparison must be done by now
						State <= Check_flag;
					else
						cur_address <= std_logic_vector(unsigned(cur_address) + 1);
					end if;	
				when Check_flag =>
					case opcode is
						when SZ =>
							if (Zero_flag = '1') then -- should be 1?
								cur_address <= "11111101";
								Start_Address <= "11111101";
								Finish_Address <= "11111111";
								State <= Execute0;
							else
								State <= IncPC;
								IncPC_counter <= std_logic_vector(unsigned(IncPC_counter) + 1);
								cur_address <= std_logic_vector(unsigned(IncPC_counter) + 1);
							end if;	    
						when SNZ =>
							if (Zero_flag = '0') then
								cur_address <= "11111101";
								Start_Address <= "11111101";
								Finish_Address <= "11111111";
								State <= Execute0;
							else
								State <= IncPC;
								IncPC_counter <= std_logic_vector(unsigned(IncPC_counter) + 1);
								cur_address <= std_logic_vector(unsigned(IncPC_counter) + 1);
							end if;
						-- when DZ =>
						-- when DNZ =>
						when others =>
							null;
					end case;	
				when Execute0 =>
					cur_address <= Start_Address;
					if (cur_address >= Finish_Address) then
						State <= IncPC;
						IncPC_counter <= std_logic_vector(unsigned(IncPC_counter) + 1);
						cur_address <= std_logic_vector(unsigned(IncPC_counter) + 1);
					else
						cur_address <= std_logic_vector(unsigned(cur_address) + 1);
					end if;	
				when IncPC =>
					if (IncPC_counter = "11111111") then
						State <= IF_state;
						counter <= "00000001";
						cur_address <= "00000000";
						IncPC_counter <= "11111100";
					else
						IncPC_counter <= std_logic_vector(unsigned(IncPC_counter) + 1);
						cur_address <= std_logic_vector(unsigned(IncPC_counter) + 1);
					end if;
				end case;
			end if;
	end process super_proc;
	Address <= cur_address;
end state_machine_arc;
