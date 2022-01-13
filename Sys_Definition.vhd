library IEEE;
use IEEE.std_logic_1164.all;
USE ieee.numeric_std.all ;
use std.textio.all;

package Sys_Definition is

-- Constant for datapath
  Constant   DATA_WIDTH  :     integer   := 16;     -- Word Width
  Constant   ADDR_WIDTH  :     integer   := 16 ;     -- Address width
--constant PORT_NUM : integer := 5;

-- Type Definition
   -- type ADDR_ARRAY_TYPE is array (VC_NUM-1 DOWNTO 0) of std_logic_vector (ADDR_WIDTH-1 downto 0);
   
-- **************************************************************
--COMPONENTs
-- CPU
COMPONENT cpu
   Generic (
    DATA_WIDTH : integer   := 16;     -- Data Width
    ADDR_WIDTH : integer   := 16      -- Address width
    );
   port ( reset, clk : in STD_LOGIC);
END COMPONENT;
-----------------------------
-- Controller
component controller 
  Generic (
    DATA_WIDTH : integer   := 16;     -- Data Width
    ADDR_WIDTH : integer   := 16      -- Address width
    );
   port (reset : in STD_LOGIC; -- low active reset signal
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
	ALUz  : in std_logic  );
end component;
-----------------------------
-- Control Unit
component control_unit
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
end component;
-----------------------------
-- Datapath
component datapath
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
end component;
-------------------------------------
-- dpmem
component dpmem 
   generic (
     DATA_WIDTH        :     integer   := 16;     -- Word Width
     ADDR_WIDTH        :     integer   := 16      -- Address width
     );
 
   port (-- Writing
    Clk        : in  std_logic;	-- clock
    nReset     : in  std_logic;	-- Reset input
    addr       : in  std_logic_vector(ADDR_WIDTH -1 downto 0);   --  Address
    -- Writing Port
    Wen        : in  std_logic;	-- Write Enable
    Datain     : in  std_logic_vector(DATA_WIDTH -1 downto 0) := (others => '0');   -- Input Data
    -- Reading Port
    Ren        : in  std_logic;	-- Read Enable
    Dataout    : out std_logic_vector(DATA_WIDTH -1 downto 0)   -- Output data  
    );
end component;
------------------------------------------------------
-- Mux 4 to 1
Component mux4to1 
   Generic (DATA_WIDTH : integer := 8);
   PORT (A, B, C, D : IN std_logic_vector (DATA_WIDTH-1 downto 0);
         SEL : IN std_logic_vector (1 downto 0);
         Z   : OUT std_logic_vector (DATA_WIDTH-1 downto 0) );
END Component;
-------------------------------------------------------
-- IR
component IR
   GENERIC (DATA_WIDTH : integer := 16);
   Port ( clk : in STD_LOGIC;
           IR_in : in STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
           IRld : in STD_LOGIC;
           IR_out : out STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0));
end component;
-------------------------------------------------------
-- PC
component PC
   GENERIC (DATA_WIDTH : integer := 16);
   Port ( clk : in STD_LOGIC;
           PCclr : in STD_LOGIC;
           PCincr : in STD_LOGIC;
           PCld : in STD_LOGIC;
           PC_in : in STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
           PC_out : out STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0));
end component;
-------------------------------------------------------
-- mux 3 to 1
Component MUX3to1
   Generic (DATA_WIDTH : integer := 16);
   PORT (
	data_in0, data_in1,data_in2 : in STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);
        ms : in STD_LOGIC_VECTOR(1 downto 0);
        data_out : out STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0)
   );
END Component;
-----------------
-- ALU
Component ALU
   Generic (DATA_WIDTH : integer := 16);
   PORT (
	 OPr1, OPr2 : IN STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
         ALUs : IN STD_LOGIC_VECTOR (1 downto 0);
         ALUr : OUT STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
         ALUz : OUT STD_LOGIC
	);
END Component;
-----------------
Component register_file
	Generic ( 
		    DATA_WIDTH : integer := 16;
		    ADDR_WIDTH : integer := 16);
	PORT ( 
	reset, clk, RFwe, OPr1e, OPr2e : IN STD_LOGIC;
        RFin : IN STD_LOGIC_VECTOR (DATA_WIDTH - 1 DOWNTO 0);
        RFwa, OPr1a, OPr2a : IN STD_LOGIC_VECTOR (3 DOWNTO 0);

        OPr1, OPr2 : OUT STD_LOGIC_VECTOR (DATA_WIDTH - 1 DOWNTO 0));
END Component;
-------------------------------------------------------
end Sys_Definition;

PACKAGE BODY Sys_Definition IS
	-- package body declarations

END PACKAGE BODY Sys_Definition;