

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity LSFT_0 is
       generic (width: natural:=8);
       Port (
             rst : in std_logic;
             clk : in std_logic;
             q_lfsr : out std_logic_vector(width -1 downto 0));
end LSFT_0;

architecture Behavioral of LSFT_0 is

constant max_width: natural := 32; --Max registers

constant initial_value: std_logic_vector(width -1 downto 0) := (0 => '1',others => '0'); --Seed


type feedback_array_type is array (4 to max_width) of
     std_logic_vector(max_width -1 downto 0);
     
constant feedback_equation: feedback_array_type :=
                            (4 => (1 | 0 => '1', others => '0'),
                             8 => (4 |3 | 2 |0 => '1', others=> '0'),
                             16 => (5 | 4 | 3 | 2 | 0 => '1' , others => '0'),
                             32 => (22| 2 | 1 | 0     => '1' , others => '0'),
                             others => (1|0 => '1',others =>'0'));
--signal declarations
signal    q_lfsr_i: std_logic_vector(width -1 downto 0);
signal serial_in: std_logic;
signal feedback: std_logic;
                         
begin

    --Process to get feedback from XOR gate with
    --his feedback equation
    feed_pro:process(q_lfsr_i)
    constant tap_constant: std_logic_vector(max_width-1 downto 0)
                          := feedback_equation(width);
     variable tmp: std_logic;
     begin
     tmp := '0';
     bit_xor: for i in 0 to width-1 loop
            tmp:= tmp xor (q_lfsr_i(i)and tap_constant(i));
     end loop bit_xor;
     feedback <= tmp;
     end process feed_pro;
     
    --shifter process
    lsft_cnt_proc: process(rst,clk)
    begin
            if(rst='0')then
            q_lfsr_i <= initial_value;
            
            elsif (rising_edge(clk)) then
            
                  shifter_loop: for i in width-1 downto 1 loop
                        q_lfsr_i(i-1) <=q_lfsr_i(i);
                   end loop shifter_loop;
             q_lfsr_i(q_lfsr_i'high) <= serial_in; 
             end if;
     end process lsft_cnt_proc;
     serial_in <= feedback;
     q_lfsr <= q_lfsr_i;
     
  



end Behavioral;
