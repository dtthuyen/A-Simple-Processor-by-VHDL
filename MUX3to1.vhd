library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.sys_definition.ALL;

entity mux3to1 is
    GENERIC (DATA_WIDTH : integer := 16);
    port( 
	data_in0, data_in1,data_in2 : in STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);
        ms : in STD_LOGIC_VECTOR(1 downto 0);
        data_out : out STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0)
    );
end mux3to1;
architecture mux3to1 of mux3to1 is
begin
    with ms select
        data_out <= data_in0 when "00",
                    data_in1 when "01",
                    data_in2 when "10",
		    (OTHERS => 'U') when others;
end mux3to1;