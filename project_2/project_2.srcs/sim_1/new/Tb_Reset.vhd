library ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;

entity Tb_Reset is
--  Port ( );
end Tb_Reset;

architecture Behavioral of Tb_Reset is

    component Reset is
            port(
                    sys_clk     : in  std_logic;
                    sys_rst     : in  std_logic;
                    rst_aa_sd   : out std_logic);
    end component;                

signal Tb_sys_clk : std_logic  :='0';
signal Tb_sys_rst : std_logic := '1' ;
signal Tb_rst_aa_sd: std_logic ;
constant  clk_period: time := 10ns;

begin

    UUT: Reset port map (sys_clk => Tb_sys_clk, sys_rst => Tb_sys_rst, rst_aa_sd =>Tb_rst_aa_sd );
    
        clk_gen: process
            begin
                    Tb_sys_clk <= '0';
                    wait for clk_period/2;
                    Tb_sys_clk <= '1';
                    wait for clk_period/2;
            
            end process clk_gen;
            
            
       -- Data stimulus generation
       
       rst_gen: process 
            begin
                    Tb_sys_rst <= '1';
                    wait for clk_period*4;
                    wait until falling_edge(Tb_sys_clk);
                    Tb_sys_rst <= '0';
                    wait for clk_period*3;
                    Tb_sys_rst <= '1';
                    wait for clk_period*4;
                    Tb_sys_rst <= '0';
                    wait for clk_period*4;
                    Tb_sys_rst <= '1';
                    wait;
                    
             end process rst_gen;
                    

end Behavioral;
