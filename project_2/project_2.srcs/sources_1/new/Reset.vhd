library ieee;
use ieee.std_logic_1164.all;
entity Reset is
generic(rst_width:integer:=2;
rst_active_value: std_logic:='0');
port(
sys_clk : in std_logic;
sys_rst : in std_logic;
rst_aa_sd: out std_logic);
end entity Reset;

architecture rst_async_ass_synch_deass_beh of Reset is
signal sys_rst_i: std_logic_vector(rst_width downto 0);
begin
asyn_ass: process(sys_rst, sys_clk)
begin
if (sys_rst= rst_active_value) then
sys_rst_i <= (others => rst_active_value);
rst_aa_sd <= '0';
elsif (rising_edge(sys_clk)) then
sys_rst_i(0) <= not rst_active_value;
for i in 0 to rst_width-1 loop
sys_rst_i(i+1) <= sys_rst_i(i);
end loop;
end if;
rst_aa_sd <= sys_rst_i(rst_width-1);
end process asyn_ass;
end rst_async_ass_synch_deass_beh;