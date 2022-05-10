----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.05.2022 13:06:00
-- Design Name: 
-- Module Name: Reset - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Reset is
generic (rst_width: integer :=2;
         rts_active_value: std_logic := '0');
         
Port (
       sys_clk   : in std_logic;
       sys_rst   : in std_logic;
       rst_aa_sd : out std_logic);
end  entity Reset;

architecture Behavioral of Reset is

signal sys_rst_i: std_logic(rst_width downto 0);

begin

async_ass: process (sys_rst,sys_clk)

    begin
        if (sys_rst = rst_active_value) then
        
                sys_rst_i    <= (others => rst_active_value);
                rst_aa_sd    <= '0';
                
                
        elsif (rising_edge(sys_clk)) then
        
                sys_rst_i(0) <= not rst_active_value;
                    
                    for i in 0 to rst_width-1 loop
                        
                        sys_rst_i(i+1) <= sys_rst_i(i);
                    
                    end loop;
                    
        end if;
        
    rst_aa_sd <= sys_rst_i(rst_width-1);
    
  end process;
  
  end Behavior;
   

end Behavioral;
