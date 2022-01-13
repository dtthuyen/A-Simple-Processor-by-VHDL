-- ALU
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.sys_definition.ALL;

ENTITY ALU IS
	Generic (DATA_WIDTH : integer := 16);
	PORT (
	 OPr1, OPr2 : IN STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
         ALUs : IN STD_LOGIC_VECTOR (1 downto 0);
         ALUr : OUT STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
         ALUz : OUT STD_LOGIC
	);
END ALU;

ARCHITECTURE ALU OF ALU IS
	SIGNAL result : STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
BEGIN
 process(ALUs, Opr1, Opr2)
    begin
        case(ALUs) is
            when "00" => result <= OPr1 + OPr2; --Add
            when "01" => result <= OPr1 - OPr2; --Sub
            when "10" => result <= OPr1 or OPr2; --Or
            when "11" => result <= OPr1 and OPr2; --And
            when others => result <= (others => '1'); --Preset
        end case;
    end process;
    ALUr <= result;
    ALUz <= '1' when OPr1 = x"0000" else '0';
    
END ALU;
	
