-- datapath 

library IEEE;
use IEEE.std_logic_1164.all;
use work.sys_definition.all;

entity datapath is
  Generic (
    DATA_WIDTH : integer   := 16;     -- Data Width
    ADDR_WIDTH : integer   := 16      -- Address width
    );
  Port(
	reset : IN STD_LOGIC;
        clk: in STD_LOGIC;
        data_in1 : in STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);
        data_in2 : in STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);
        RFs : in STD_LOGIC_VECTOR(1 downto 0);
        RFwa, OPr1a, OPr2a : in STD_LOGIC_VECTOR(3 downto 0);
        RFwe, OPr1e, OPr2e : in STD_LOGIC;
        ALUs : in STD_LOGIC_VECTOR(1 downto 0);
        ALUz : out STD_LOGIC;
        Addr_out : out STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);
        data_out : out STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0)
        );
end datapath;

architecture struct of datapath is
	signal OPr1, OPr2 : STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);
    	signal RFin : STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);
    	signal data_in0 :  STD_LOGIC_VECTOR (DATA_WIDTH - 1 downto 0);
   begin
    MUX_U : mux3to1
    port map(data_in0 => data_in0,
         data_in1 => data_in1,
         data_in2 => data_in2,
         ms => RFs,
         data_out => RFin);

    RF_U : register_file
    port map(clk => clk,
        reset => reset,
        RFin => RFin,
        RFwa => RFwa,
        RFwe => RFwe,
        OPr1a => OPr1a,
        OPr1e => OPr1e,
        OPr2a => OPr2a,
        OPr2e => OPr2e,
        OPr1 => OPr1,
        OPr2 => OPr2);

    Addr_out <= OPr2;
    Data_out <= OPR1;

    ALU_U: ALU
    port map( OPr1 => OPr1,
            OPr2 => OPr2,
            ALUs => ALUs,
            ALUr => data_in0,
            ALUz => ALUz);
end struct;


