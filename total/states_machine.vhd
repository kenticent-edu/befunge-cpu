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

type state_type is (reset_state,IF_state,ID,Execute0,Execute1,Check_flag,IncPC);
signal Next_state,State : state_type;

signal counter : std_logic_vector(7 downto 0) := "00000000";

type memory is array (0 to 15) of std_logic_vector(7 downto 0);
constant ROMSA : memory := (
	others => "00000000");
constant ROMFA : memory := (
	others => "00000000");

signal opcode : std_logic_vector(3 downto 0);

signal Start_Address : std_logic_vector(7 downto 0); 
signal Finish_Address : std_logic_vector(7 downto 0);
signal cur_address : std_logic_vector(7 downto 0);

constant SZ : std_logic_vector(3 downto 0) := "0000";
constant SNZ : std_logic_vector(3 downto 0) := "0000";  
constant DZ : std_logic_vector(3 downto 0) := "0000";
constant DNZ : std_logic_vector(3 downto 0) := "0000";

begin
	opcode <= Group_Com & OpCode_Com;
	
	sync_proc: process(clk,Next_state,Reset)
	begin
		if (Reset = '1') then
			State <= reset_state;
		elsif (rising_edge(clk)) then
			State <= Next_state;
		end if;	
	end process sync_proc;
	
	comb_proc: process(State)
	begin
		case State is
			when reset_state =>
				counter <= "00000000";
				Next_state <= IF_state;
			when IF_state =>
				if (counter = "00000011") then -- IR = MEM[PC]
					Next_state <= ID;
				else
					counter <= std_logic_vector(unsigned(counter) + 1);
				end if;
				cur_address <= counter;
			when ID =>
				Start_Address <= std_logic_vector(unsigned( ROMSA(to_integer(unsigned(opcode))) ) + 1);
				Finish_Address <= ROMFA(to_integer(unsigned(opcode)));
				cur_address <= ROMSA(to_integer(unsigned(opcode)));
				if (opcode=SZ or opcode=SNZ or opcode=DZ or opcode=DNZ) then
					Next_state <= Execute1;
				else
					Next_state <= Execute0;
				end if;
			when Execute1 =>
				cur_address <= Start_Address;
				if (cur_address = Finish_Address) then
					Next_state <= Check_flag;
				else
					Start_Address <= std_logic_vector(unsigned(Start_Address) + 1);
				end if;	
			when Check_flag =>
				case opcode is
					when SZ =>
						if (Zero_flag = '0') then
							cur_address <= std_logic_vector(unsigned(Start_Address) + 1);
							Start_Address <= std_logic_vector(unsigned(Start_Address) + 2);
							Finish_Address <= std_logic_vector(unsigned(Start_Address) + 2);
							Next_state <= Execute0;
						else
							Next_state <= IncPC;
						end if;	    
					-- when SNZ =>
					-- when DZ =>
					-- when DNZ =>
					when others =>
						null;
				end case;	
			when Execute0 =>
				cur_address <= Start_Address;
				if (cur_address = Finish_Address) then
					Next_state <= IncPC;
				else
					Start_Address <= std_logic_vector(unsigned(Start_Address) + 1);
				end if;	
			when IncPC =>
				if (counter = std_logic_vector(to_unsigned(254, 8))) then -- PC	= PC + deltaPC
					cur_address <= std_logic_vector(to_unsigned(255, 8));	
					Next_state <= IF_state;
					counter <= std_logic_vector(to_unsigned(0, 8));
				else
					cur_address <= std_logic_vector(to_unsigned(254, 8));
					counter <= std_logic_vector(to_unsigned(254, 8));
				end if;
			end case;	
	end process comb_proc;
	Address <= cur_address;
end state_machine_arc;