----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.05.2022 14:22:29
-- Design Name: 
-- Module Name: Signal_Synchronizer - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Signal_Synchronizerr is
    Port ( Async : in bit;
           clk  : in std_logic; 
           Sync : out bit;
           Rst : in bit := '1');
end Signal_Synchronizerr;

architecture Synchronizer of Signal_Synchronizerr is
signal T_Sync : bit;


begin
   
   Sync_Proc: process (Rst,clk)
   begin
            if (Rst = '0') then 
            
            Sync <= '0';
            
            elsif (rising_edge(clk)) then
                      T_Sync <= Async;
                      Sync   <= T_Sync;
            end if;
   end process; 
   
end Synchronizer;

