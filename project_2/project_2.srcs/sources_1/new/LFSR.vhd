library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity LFSR is
        generic(
                lsft_width: natural :=5);
                
        Port(
             clk       :in  std_logic;
             rst       :in  std_logic;
             sel       :in  std_logic_vector  (1  downto 0);
             q_lfsr4    :out std_logic_vector (3  downto 0);
             q_lfsr8    :out std_logic_vector (7  downto 0);
             q_lfsr16    :out std_logic_vector(15 downto 0);
             q_lfsr32    :out std_logic_vector(31 downto 0));
end LFSR;

architecture Behavioral of LFSR is

constant max_width:  natural :=32;
constant i_value4 :std_logic_vector(3 downto 0):="1000";
constant i_value8 :std_logic_vector(7 downto 0):="10000000";
constant i_value16 :std_logic_vector(15 downto 0):="1000000000000000";
constant i_value32 :std_logic_vector(31 downto 0):="10000000000000000000000000000000";

type feedback_array_type is array (4 to max_width) of std_logic_vector(max_width -1 downto 0);

constant feedback_equation: feedback_array_type:=
                         
                        (4  => (1 | 0             => '1' , others => '0'),
                        5  => (1 | 0             => '1' , others => '0'),
                        6  => (1 | 0             => '1' , others => '0'),
                        7  => (1 | 0             => '1' , others => '0'),
                         8  => (4 | 3 | 2 | 0     => '1' , others => '0'),
                         9  => (1 | 0             => '1' , others => '0'),
                         10  => (1 | 0             => '1' , others => '0'),
                         11 => (1 | 0             => '1' , others => '0'),
                         12  => (1 | 0             => '1' , others => '0'),
                         13  => (1 | 0             => '1' , others => '0'),
                         14  => (1 | 0             => '1' , others => '0'),
                         15  => (1 | 0             => '1' , others => '0'),
                         16 => (5 | 4 | 3 | 2 | 0 => '1' , others => '0'),
                         17  => (1 | 0             => '1' , others => '0'),
                         18 => (1 | 0             => '1' , others => '0'),
                         19 => (1 | 0             => '1' , others => '0'),
                         20 => (1 | 0             => '1' , others => '0'),
                         21 => (1 | 0             => '1' , others => '0'),
                         22 => (1 | 0             => '1' , others => '0'),
                         23 => (1 | 0             => '1' , others => '0'),
                         24 => (1 | 0             => '1' , others => '0'),
                         25 => (1 | 0             => '1' , others => '0'),
                         26 => (1 | 0             => '1' , others => '0'),
                         27 => (1 | 0             => '1' , others => '0'),
                         28 => (1 | 0             => '1' , others => '0'),
                         29 => (1 | 0             => '1' , others => '0'),
                         30 => (1 | 0             => '1' , others => '0'),
                         31 => (1 | 0             => '1' , others => '0'),
                         32 => (22| 2 | 1 | 0     => '1' , others => '0'));
                         
                          
 
signal width: natural:=4;
signal initial_value : std_logic_vector((width - 1) downto 0);                      
signal sel_i: std_logic_vector(1 downto 0);
signal q_lfsr_i: std_logic_vector(width -1 downto 0);
signal serial_in: std_logic;
signal feedback: std_logic;
begin

feedb: process(q_lfsr_i)
constant tap_constant: std_logic_vector(max_width -1 downto 0)
         := feedback_equation(width);
         
variable tmp: std_logic;
begin
        tmp :='0';
        bit_xor: for i in 0 to width -1 loop
                 tmp :=  tmp xor(q_lfsr_i(i) and tap_constant(i));
                 end loop bit_xor;
        feedback <= tmp;
end process feedb;

serial_in <= feedback;
shift: process(clk,rst)
begin
           if(rst = '1') then
              q_lfsr_i <= initial_value;
              
            elsif (rising_edge(clk)) then
               shifter_loop: for i in  q_lfsr_i'high downto 1 loop
                            q_lfsr_i(i-1) <= q_lfsr_i(i);
                            end loop shifter_loop;
            q_lfsr_i(q_lfsr_i'high) <= serial_in;
            end if;    
    Output: case sel is
                when "00" => q_lfsr4 <= q_lfsr_i;
                when "01" => q_lfsr8 <= q_lfsr_i;
                when "10" => q_lfsr16 <= q_lfsr_i;
                when "11" => q_lfsr32 <= q_lfsr_i;
             end case Output;
end process shift;

        sel_i <= sel;
  MW_p:process(sel)
       begin 
       MW:case sel_i is
               when "00" => width <= 4; initial_value <= i_value4;
               when "01" => width <= 8; initial_value <= i_value8;
               when "10" => width <= 16; initial_value <= i_value16;
               when "11" => width <= 32; initial_value <= i_value32;
               when others => width <= 4; initial_value <= i_value4;
          end case;
        end process;
 
 
 
end Behavioral;
