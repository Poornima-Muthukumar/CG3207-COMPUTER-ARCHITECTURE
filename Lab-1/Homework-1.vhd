----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:54:33 09/01/2013 
-- Design Name: 
-- Module Name:    case_change - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity case_change is
    Port ( clock : in  STD_LOGIC;
           leds : out  STD_LOGIC_VECTOR (3 downto 0);
           reset : in  STD_LOGIC;
           display : in  STD_LOGIC;
           OP : in  STD_LOGIC_VECTOR (1 downto 0));
end case_change;

architecture Behavioral of case_change is

-- The following code must appear before the "begin" keyword in the architecture
-- body.
type rom_type is array (15 downto 0) of std_logic_vector (7 downto 0);
constant ROM : rom_type :=(X"50", X"4F", X"4F", X"52",
                           X"50", X"4F", X"4F", X"52",
                           X"50", X"4F", X"4F", X"52",
                           X"50", X"4F", X"4F", X"52");  

signal rom_data :rom_type;
signal count: std_logic :="0000";
signal led_result: rom_type;
			
begin
process(clock)
begin
if clock='1' and clock'event then

if reset='1' then
count := "0000";
end if;

case OP is
when "00" => --no op

when "01" => --convert to lower
--read from ROM
rom_data(count) <= ROM(conv_integer(count));
count := count +1;

if rom_data(count) <=X"5A" and rom_data(count) >= X"41" then
led_result = rom_data(count)+ X"20";
else
led_result = rom_data(count);
end if;


when "10" => --convert to upper
-- read from ROM
rom_data(count) <= ROM(conv_integer(count));
count := count +1;


if rom_data(count) <=X"7A" and rom_data(count) >= X"61" then
led_result = rom_data(count) - X"20";
else
led_result= rom_data(count);
end if;


when "11" => --no op
end case;

if display = '1' then
leds <= led_result(7 downto 4);
else
leds <= led_result(3 downto 0);
end if;

end process;
end Behavioral;

