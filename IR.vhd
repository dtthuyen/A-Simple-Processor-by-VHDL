--IR
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.Sys_Definition.all;

entity IR is
    GENERIC (DATA_WIDTH : integer := 16);
    Port ( clk : in STD_LOGIC;
           IR_in : in STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
           IRld : in STD_LOGIC;
           IR_out : out STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0));
end IR;

architecture IR of IR is

begin
    process(clk)
    begin
        if clk'event and clk = '1' then
            if IRld = '1' then
                IR_out <= IR_in;
            end if;
        end if;
    end process;
end IR;