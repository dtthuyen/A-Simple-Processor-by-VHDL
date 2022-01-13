--test bench of cpu
library ieee;
use ieee.std_logic_arith.all;
use ieee.std_logic_1164.all;
use ieee.STD_LOGIC_UNSIGNED.all;
use work.Sys_Definition.all;
 
use std.textio.all;
 
entity cpu_tb is

end cpu_tb;

architecture behavior of cpu_tb is
	CONSTANT CLKTIME : time := 20 ns; 

	signal Reset : std_logic ;
	signal clk   : std_logic := '0';
Begin
  CLK <= NOT CLK AFTER CLKTIME/2;

  cpu_U: cpu port map (reset, clk);
  
  final: process
      begin
          reset <= '1';
          wait for 50 ns;
          reset <= '0';
          wait;
        end process;

End behavior;