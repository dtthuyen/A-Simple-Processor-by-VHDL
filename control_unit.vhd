-- control unit

library IEEE;
use IEEE.std_logic_1164.all;
use work.sys_definition.all;

entity control_unit is
  Generic (
    DATA_WIDTH : integer   := 16;     -- Data Width
    ADDR_WIDTH : integer   := 16      -- Address width
    );
  Port(
	reset : IN STD_LOGIC;
        clk: in STD_LOGIC;
	IR_in : in STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
	cu_out_dp : out STD_LOGIC_VECTOR(7 downto 0);
	Mre, Mwe : out std_logic;
	RFs : out std_logic_vector(1 downto 0);
	RFwa  : out std_logic_vector(3 downto 0);
        RFwe  : out STD_LOGIC;
	OPr1a : out STD_LOGIC_VECTOR(3 downto 0);
        OPr1e : out STD_LOGIC;
        OPr2a : out STD_LOGIC_VECTOR(3 downto 0);
        OPr2e : out STD_LOGIC;
	ALUs  : out STD_LOGIC_VECTOR(1 downto 0);
	ALUz  : in std_logic;
	data_in0 : in STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);
	addr : out std_logic_vector(DATA_WIDTH - 1 downto 0)
        );
end control_unit;

architecture struct of control_unit is
	signal IRld, PCclr, PCincr, PCld : STD_LOGIC;
	signal PC_out : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
	signal ms : std_logic_vector(1 downto 0);
	signal IR_out, IR_out_7dto0 : STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
   begin
    IR_out_7dto0 <= "00000000" & IR_out(7 downto 0);
    cu_out_dp <= IR_out(7 downto 0);

    MUX_U : mux3to1
    port map(data_in0 => data_in0,
         data_in1 => IR_out_7dto0,
         data_in2 => PC_out,
         ms => Ms,
         data_out => addr);

    PC_U : PC
    port map(clk => clk,
           PCclr => PCclr,
           PCincr => PCincr,
           PCld => PCld,
           PC_in => IR_out_7dto0,
           PC_out => PC_out);

    controller_U: controller
    port map(reset => reset,
	clk => clk,
	instr => IR_out,
        PCclr => PCclr,
        PCincr => PCincr,
        PCld => PCld,
	IRld => IRld,
	Ms => Ms, 
	Mre => Mre,
	Mwe => Mwe,
	RFs => RFs,
	RFwa => RFwa,
        RFwe => RFwe,
        OPr1a => OPr1a,
        OPr1e => OPr1e,
        OPr2a => OPr2a,
        OPr2e => OPr2e,
	ALUs => ALUs,
	ALUz => ALUz);

    IR_U: IR
    port map(clk => clk,
           IR_in => IR_in,
           IRld => IRld,
           IR_out => IR_out);

end struct;


