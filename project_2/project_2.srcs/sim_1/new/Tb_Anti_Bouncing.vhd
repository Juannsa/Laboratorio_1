----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.05.2022 16:38:51
-- Design Name: 
-- Module Name: Tb_Anti_Bouncing - Behavioral
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


 LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
 
ENTITY Tb_Anti_Bouncing IS
END Tb_Anti_Bouncing;
 
ARCHITECTURE behavior OF Tb_Anti_Bouncing IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Anti_Bouncing
    PORT(
         clk : IN  std_logic;
         button_in : IN  std_logic;
         rst : IN  std_logic;
         button_out : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '1';
   signal button_in : std_logic := '0';

    --Outputs
   signal button_out : std_logic;

   -- Clock period definitions
   constant Clock_period : time := 10 ns;
 
BEGIN
 
    -- Instantiate the Unit Under Test (UUT)
   UUT: Anti_Bouncing PORT MAP (
          clk => clk,
          rst => rst,
          button_in => button_in,
          button_out => button_out
        );

   -- Clock process definitions
   Clock_process :process
   begin
        clk <= '0';
        wait for Clock_period/2;
        clk <= '1';
        wait for Clock_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin        
        button_in <= '0';
        rst <= '0';
      -- hold reset state for 100 ns.
      wait for 100 ns;
        rst <= '1';
      wait for Clock_period*10;
        --first activity
        button_in <= '1';   wait for Clock_period*2;
        button_in <= '0';   wait for Clock_period*1;
        button_in <= '1';   wait for Clock_period*1;
        button_in <= '0';   wait for Clock_period*20;
        --second activity
        button_in <= '1';   wait for Clock_period*1;
        button_in <= '0';   wait for Clock_period*1;
        button_in <= '1';   wait for Clock_period*1;
        button_in <= '0';   wait for Clock_period*2;
        button_in <= '1';   wait for Clock_period*20;
        button_in <= '0';   
      wait;
   end process;






end behavior;
