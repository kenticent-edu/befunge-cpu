----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 03/16/2021 06:13:01 PM
-- Design Name:
-- Module Name: rom_64x16_TB - Behavioral
-- Project Name:
-- Target Devices:
-- Tool Versions:
-- Description:
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;


entity rom_64x16_TB is
end entity;

architecture rom_64x16_TB_arch of rom_64x16_TB is

signal address_TB: std_logic_vector(5 downto 0):=(others=>'0');
signal data_out_TB: std_logic_vector(15 downto 0);
signal clk_TB : std_logic:='0';

component rom_64x16
port (address  : in std_logic_vector(5 downto 0);
     clk      : in std_logic;
     data_out : out std_logic_vector(15 downto 0));
end component;

begin
clk_TB <= not clk_TB after 5 ns;
 DUT : rom_64x16 port map (
                  address => address_TB,
                  clk => clk_TB,
                  data_out => data_out_TB
                  );
 
 process
 begin
   wait until clk_TB'event and clk_TB='0';
   address_TB <= address_TB + "000001";
        if address_TB = "111111" then
            wait until clk_TB'event and clk_TB='0';
            wait;
        end if;
end process;

end architecture;