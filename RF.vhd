--RF
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use WORK.Sys_Definition.ALL;

ENTITY register_file IS
    Generic ( 
		    DATA_WIDTH : integer := 16;
		    ADDR_WIDTH : integer := 16);
    PORT ( 
	reset, clk, RFwe, OPr1e, OPr2e : IN STD_LOGIC;
        RFin : IN STD_LOGIC_VECTOR (DATA_WIDTH - 1 DOWNTO 0);
        RFwa, OPr1a, OPr2a : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
        OPr1, OPr2 : OUT STD_LOGIC_VECTOR (DATA_WIDTH - 1 DOWNTO 0));
END register_file;

ARCHITECTURE register_file OF register_file IS
    type DATA_ARRAY is array (integer range<>) of STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);
    signal RF : DATA_ARRAY(0 to 15) := (others => (others => '0')); -- Memory model
BEGIN
    RW_Proc: process(clk, reset)
    BEGIN
        if reset = '1' then
            OPr1 <= (others => '0');
            OPr2 <= (others => '0');
            RF <= (others => (others => '0'));
        elsif clk'event and clk = '1' then
            if RFwe = '1' then
	RF(conv_integer(RFwa)) <= RFin;
            END if;
        if OPr1e = '1' then
            OPr1 <= RF(conv_integer(OPr1a));
            END if;
        if OPr2e = '1' then
            OPr2 <= RF(conv_integer(OPr2a));
            END if;
        END if;
    END PROCESS RW_Proc;
END register_file;