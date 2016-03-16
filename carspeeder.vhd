library ieee;                                    
    use ieee.std_logic_1164.all;
    use ieee.std_logic_unsigned.all ;
    use ieee.std_logic_arith.all;

library work;
    use work.carspeeder_utils_package.all;

entity carspeeder is
	port(        
        s1, s2, clk, reset : in std_logic;
	    speed1, speed10, speed100 : in std_logic_vector(3 downto 0);
        speeding : out std_logic;
        digit1, digit10, digit100 : out std_logic_vector(7 downto 0) 
    );
end carspeeder;

architecture structure of carspeeder is
    -- internal signals 
    signal srff, carry1, carry10, carry100, digit_equal : std_logic;
    signal sp10, sp100, eq_100, less_100, eq_10, less_10 : std_logic;
    signal bcd1, bcd10, bcd100 : std_logic_vector(3 downto 0);

-- components
for latch : sr_ff use entity work.sr_ff;
for first_BCD_counter : up_counter_base10 use entity work.up_counter_base10;
for second_BCD_counter: up_counter_base10 use entity work.up_counter_base10;
for third_BCD_counter: up_counter_base10 use entity work.up_counter_base10;
for first_seven_segment: seven_segment_decoder use entity work.seven_segment_decoder;
for second_seven_segment: seven_segment_decoder use entity work.seven_segment_decoder;
for third_seven_segment: seven_segment_decoder use entity work.seven_segment_decoder;
for compare1: compare_function use entity work.compare_function;
for compare2: compare_function use entity work.compare_function;

begin 
    -- connect various signals in tablet circuit!
    latch : sr_ff                 
        port map(s1, s2, reset, srff);
    first_BCD_counter : up_counter_base10     
        port map(clk, reset, srff, bcd1, carry1);
    second_BCD_counter : up_counter_base10     
        port map(carry1, reset, srff, bcd10, carry10);
    third_BCD_counter : up_counter_base10     
        port map(carry10, reset, srff, bcd100, carry100);
    first_seven_segment : seven_segment_decoder 
        port map(bcd1, digit1);
    second_seven_segment : seven_segment_decoder 
        port map(bcd10, digit10);
    third_seven_segment : seven_segment_decoder 
        port map(bcd100, digit100);
    compare1 : compare_function      
        generic map ( word_size => 4)
        port map(bcd10, speed10, less_10, eq_10);
    compare2 : compare_function      
        generic map ( word_size => 4)
        port map(bcd100, speed100, less_100, eq_100);
    digit_equal <= eq_100 and less_10;
    speeding <= digit_equal or less_100;
end structure;
----------
