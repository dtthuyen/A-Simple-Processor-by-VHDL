-- controller

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use work.Sys_Definition.all;

entity controller is             	
  Generic (
    DATA_WIDTH : integer   := 16;     -- Data Width
    ADDR_WIDTH : integer   := 16      -- Address width
    );
   port (
	reset : in STD_LOGIC; -- high active reset signal
	clk    : in STD_LOGIC;    -- Clock
	instr  : in STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
        PCclr  : out STD_LOGIC;
	PCincr : out STD_LOGIC;
        PCld  : out STD_LOGIC;
	IRld  : out STD_LOGIC;
	Ms    : out STD_LOGIC_VECTOR(1 downto 0);
	Mre, Mwe : out std_logic;
	RFs   : out std_logic_vector(1 downto 0);
	RFwa  : out std_logic_vector(3 downto 0);
        RFwe  : out STD_LOGIC;
	OPr1a : out STD_LOGIC_VECTOR(3 downto 0);
        OPr1e : out STD_LOGIC;
        OPr2a : out STD_LOGIC_VECTOR(3 downto 0);
        OPr2e : out STD_LOGIC;
	ALUs  : out STD_LOGIC_VECTOR(1 downto 0);
	ALUz  : in std_logic 
        );                              
 
end controller;

architecture fsm of controller is
-- types and signals are declared here  
	type state_type is (RESET_S, FETCH, FETCHa, FETCHb, DECODE, MOV1, MOV1a, MOV2, MOV2a, 
                    		MOV3, MOV3a, MOV4, ADD, ADDa, SUB, SUBa, 
				OR_S, OR_Sa, AND_S, AND_Sa, JZ, JZa, JMP, NOP);
	signal state : state_type;
	signal rn, rm, OPCODE : STD_LOGIC_VECTOR(3 downto 0);
-- constants declared for ease of reading code
			 
begin
	-- state transition
	rn <= instr(11 downto 8);
	rm <= instr(7 downto 4);
	OPCODE <= instr(15 downto 12);

  FSM_trans:process (reset, clk, OPCODE)
   
  begin
	if reset = '1' then state <= RESET_S;
        elsif clk'event and clk = '1' then
            case state is
                when RESET_S => state <= FETCH;
                when FETCH   => state <= FETCHa;
                when FETCHa  => state <= FETCHb;
                when FETCHb  => state <= DECODE; -- end FETCH
                when DECODE  =>
                    case OPCODE is
                        when "0000" => state <= MOV1;
                        when "0001" => state <= MOV2;
                        when "0010" => state <= MOV3;
                        when "0011" => state <= MOV4;
                        when "0100" => state <= ADD;
                        when "0101" => state <= SUB;
                        when "0110" => state <= JZ;
                        when "0111" => state <= OR_S;
                        when "1000" => state <= AND_S;
                        when "1001" => state <= JMP;
                        when others => state <= NOP;
                    end case;
		-- MOV1: RF[rn] = M[dir]
                when MOV1  => state <= MOV1a; 
                when MOV1a => state <= FETCH;
                -- MOV2: M[dir] = RF[rn]
		when MOV2  => state <= MOV2a; 
                when MOV2a => state <= FETCH;
		-- MOV3: M[rn] = RF[rm]
                when MOV3  => state <= MOV3a;
                when MOV3a => state <= FETCH;
		-- MOV4: RF[rn] = imm
                when MOV4  => state <= FETCH;
		-- ADD: RF[rn] = RF[rn] + RF[rm]
                when ADD   => state <= ADDa;
                when ADDa  => state <= FETCH;
		-- SUB: RF[rn] = RF[rn] - RF[rm] 
                when SUB   => state <= SUBa;
                when SUBa  => state <= FETCH;
		-- JZ: PC=(RF[rn]=0) ?rel :PC
                when JZ    => state <= JZa;
                when JZa   => state <= FETCH;
		-- OR: RF[rn] = RF[rn] OR RF[rm]
		when OR_S  => state <= OR_Sa;
		when OR_Sa => state <= FETCH;
		-- AND: RF[rn] = RF[rn] AND RF[rm]
		when AND_S => state <= AND_Sa;
		when AND_Sa => state <= FETCH;
		-- JMP: PC = Addr
		when JMP    => state <= FETCH;
		-- others
                when others => state <= FETCH;
            end case;
        end if;
  end process;	
  -- write codes to generate control signals 	
	-- PC
	PCClr  <= '1' WHEN (state = RESET_S) ELSE '0';
	PCincr <= '1' WHEN (state = FETCHb) else '0';
	WITH state Select PCld <= ALUz WHEN JZa,
		 		   '1' WHEN JMP,
				   '0' WHEN others;
	-- IR
	IRld <= '1' WHEN (state = FETCHa) ELSE '0';
	--WITH state Select IRld <= '1' WHEN fetcha|fetchb, '0' WHEN others;
	-- M
	WITH state Select Ms <=   "10" WHEN Fetch,
				  "01" WHEN MOV1|MOV2a,
				  "00" WHEN MOV3a,
				  "11" WHEN others ;
	WITH state Select Mre <=   '1' WHEN Fetch|MOV1,
				   '0' WHEN others ;
	WITH state Select Mwe <=   '1' WHEN MOV2a|MOV3a,
				   '0' WHEN others ;
	-- RF
	WITH state Select RFs <=  "10" WHEN MOV1a,
				  "01" WHEN MOv4,
				  "00" WHEN ADDa|SUBa|OR_Sa|AND_Sa,
				  "11" WHEN others;
	WITH state Select RFwe <=  '1' WHEN MOV1a|MOv4|ADDa|SUBa|OR_Sa|AND_Sa,
				   '0' WHEN Others;
	WITH state Select RFwa <=   rn WHEN MOV1a|MOv4|ADDa|SUBa|OR_Sa|AND_Sa,
				"0000" WHEN Others;
	WITH state Select OPr1e <= '1' WHEN MOV2|MOV3|ADD|SUB|JZ|OR_S|AND_S,
				   '0' WHEN OTHERS;
	WITH state Select OPr1a <=  rn WHEN MOV2|MOV3|ADD|SUB|JZ|OR_S|AND_S,
			        "0000" WHEN OTHERS;
	WITH state Select OPr2e <= '1' WHEN MOV3|ADD|SUB|OR_S|AND_S,
				   '0' WHEN OTHERS;
	WITH state Select OPr2a <=  rm WHEN MOV3|ADD|SUB|OR_S|AND_S,
				"0000" WHEN OTHERS;
	-- ALU
	WITH state Select ALUs <= "00" WHEN ADD|ADDa,
				  "01" WHEN SUB|SUBa,
				  "10" WHEN OR_S|OR_Sa|AND_S|AND_Sa,
				  "11" WHEN others;		
end fsm;









