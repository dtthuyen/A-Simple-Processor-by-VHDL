--PC
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.Sys_Definition.all;

entity PC is
    GENERIC (DATA_WIDTH : integer := 16);
    Port ( clk : in STD_LOGIC;
           PCclr : in STD_LOGIC;
           PCincr : in STD_LOGIC;
           PCld : in STD_LOGIC;
           PC_in : in STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
           PC_out : out STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0));
end PC;

architecture PC of PC is
signal p_c : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
begin
    process(clk)
    begin
       if PCclr = '1' then --reset
                p_c <= (others => '0');
       elsif clk'event and clk = '1' then
            if PCld = '1' then --branch
                p_c <= PC_in;
            elsif PCincr = '1' then --increment
                p_c <= p_c + 1;
            end if;
        end if;
    end process;
    PC_out <= p_c;    
end PC;