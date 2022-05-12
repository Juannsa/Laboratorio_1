library ieee;
use ieee.std_logic_1164.all;
-------------------------------------------------------------------
-- Enitiy --
-------------------------------------------------------------------
entity lsftppp is
generic(
lfsr_width : natural := 4;
all_zeros_state: boolean:= false);
port(
clk : in std_logic;
rst : in std_logic;
q_lfsr_4b: out std_logic_vector(lfsr_width-1 downto 0)
);
end lsftppp;
-----------------------------------------------------------------------------------
-- Architecture --
-----------------------------------------------------------------------------------
architecture beh of lsftppp is
-- constant declarations
constant max_width : natural := 8; -- max # of registers in the LFSR
constant initial_value: std_logic_vector(lfsr_width-1 downto 0) := -- seed
(0=>'1', others =>'0');
type feedback_array_type is array (2 to max_width) of
std_logic_vector(max_width-1 downto 0);
constant feedback_equation: feedback_array_type :=
(2 => (1 | 0 => '1', others => '0'),
3 => (1 | 0 => '1', others => '0'),
4 => (1 | 0 => '1', others => '0'),
5 => (2 | 0 => '1', others => '0'),
6 => (1 | 0 => '1', others => '0'),
7 => (3 | 0 => '1', others => '0'),
8 => (4 | 3 | 2 | 0 => '1', others => '0'));
-- signal declarations
signal q_lfsr_4b_i : std_logic_vector(lfsr_width-1 downto 0);
signal nor_detect_0s: std_logic;
signal serial_in : std_logic;
signal feedback : std_logic;
begin
------------------------------------------------------------
-- Process to get feedback XOR from the feedback equation --
feedb_proc: process(q_lfsr_4b_i)
-- process local declarations
constant tap_constant: std_logic_vector(max_width-1 downto 0)
:= feedback_equation(lfsr_width);
variable tmp: std_logic;
begin
tmp := '0';
bit_xor: for i in 0 to lfsr_width-1 loop
tmp := tmp xor (q_lfsr_4b_i(i) and tap_constant(i));
end loop bit_xor;
feedback <= tmp;
end process feedb_proc;
-------------------------------------------------------------
-------------------------------------------------------------
-- Shifter Process
lfsr_cnt_proc: process(rst, clk)
begin
if(rst= '1' ) then
q_lfsr_4b_i <= initial_value;
elsif (rising_edge(clk)) then
-- shift operation: b3->b2, b2->b1, b1->b0
shifter_loop: for i in 3 downto 1 loop
q_lfsr_4b_i(i-1) <= q_lfsr_4b_i(i);
end loop shifter_loop;
-- Serial Input to the b3 of the LFSR
q_lfsr_4b_i(q_lfsr_4b_i'high) <= serial_in;
end if;
end process lfsr_cnt_proc;
q_lfsr_4b <= q_lfsr_4b_i;
-------------------------------------------------------------
-- piece of code to be generated when the 'all zeros'
-- state is needed
-------------------------------------------------------------
gen_zero: if (all_zeros_state = TRUE) generate
nor_detect_0s <= '1' when q_lfsr_4b_i(lfsr_width-1 downto 1)=
(q_lfsr_4b_i(lfsr_width-1 downto 1)'range=>'0') else
'0';
-- Serial Input to the LFSR
serial_in <= feedback XOR nor_detect_0s;
end generate gen_zero;
-------------------------------------------------------------
-------------------------------------------------------------
-- when the 'all zeros' state is not needed
-------------------------------------------------------------
gen_no_zeros: if (all_zeros_state = FALSE) generate
-- Serial Input to the LFSR
serial_in <= feedback;
end generate gen_no_zeros;
-------------------------------------------------------------
end architecture beh;