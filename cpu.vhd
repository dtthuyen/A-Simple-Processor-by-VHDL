-- cpu : the top level entity

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use work.Sys_Definition.all;

-- 
entity cpu is
   Generic (
    DATA_WIDTH : integer   := 16;     -- Data Width
    ADDR_WIDTH : integer   := 16      -- Address width
    );
   port ( reset, clk : in STD_LOGIC);
end cpu;

architecture struc of cpu is
	signal RFwa, OPr1a, OPr2a : STD_LOGIC_VECTOR(3 downto 0);
        signal RFwe, OPr1e, OPr2e, ALUz : STD_LOGIC;
	signal RFs, ALUs: std_logic_vector(1 downto 0);
	signal Mre, Mwe : std_logic;
	signal addr_out, addr, mux_in1: std_logic_vector(DATA_WIDTH -1 downto 0);
	signal cu_out_dp : STD_LOGIC_VECTOR(7 downto 0);
	signal Datain : std_logic_vector(DATA_WIDTH -1 downto 0);
	signal Dataout : std_logic_vector(DATA_WIDTH -1 downto 0) ;
begin
  mux_in1 <= "00000000" & cu_out_dp;

  ctrl_U: control_unit
  port map(
	reset => reset,
        clk => clk,
	IR_in => dataout,
	cu_out_dp => cu_out_dp,
	RFs => RFs,
	Mre => Mre,
	Mwe => Mwe,
	RFwa => RFwa,
        RFwe => RFwe,        
	OPr1a => OPr1a,
        OPr1e => OPr1e,
        OPr2a => OPr2a,
        OPr2e => OPr2e,
	ALUs => ALUs,
	ALUz => ALUz,
	data_in0 => Addr_out,
        addr => addr );

  Dp_U: datapath 
  port map(
	reset => reset,
        clk => clk,
        data_in1 => mux_in1,
        data_in2 => dataout,
        RFs => RFs,
	RFwa => RFwa,
        RFwe => RFwe,        
	OPr1a => OPr1a,
        OPr1e => OPr1e,
        OPr2a => OPr2a,
        OPr2e => OPr2e,
	ALUs => ALUs,
	ALUz => ALUz,
        Addr_out => Addr_out,
        data_out => datain );

  Mem_U: dpmem 
  port map(
    clk => clk,
    nReset => reset,
    addr => addr,
    Wen => Mwe,
    Datain => Datain,
    Ren => Mre,
    Dataout => dataout   );

end struc;




