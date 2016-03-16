library ieee;                                    
    use ieee.std_logic_1164.all;
    use ieee.std_logic_arith.all;

package carspeeder_utils_package is


-- Modified R Woods Sept 06
--

component up_counter_base10
    port( 
        clk, reset, ful : in std_logic;
        data : out std_logic_vector(3 downto 0);
        carry : out std_logic
    );
end component;
 
component seven_segment_decoder
    port( 
        data_in : in std_logic_vector(3 downto 0);
        data_out : out std_logic_vector(7 downto 0)
    );
    end component;

component compare_function
    generic (word_size : integer:=8);	--  adder word size
    port(               
        a,b : in std_logic_vector(word_size-1 downto 0);
        lessthan, equalto : out std_logic
    );
end component;

component sr_ff 
    port(
        s, r, reset  : in std_logic;
        q : out std_logic
    );
end component;

end carspeeder_utils_package;

--
-- this is the code for the base 10 up_counter
--

library ieee;                                    
    use ieee.std_logic_1164.all;
    use ieee.std_logic_arith.all;

entity up_counter_base10 is
    port( 
        clk, reset, ful : in std_logic;    
        data : out std_logic_vector(3 downto 0);
        carry : out std_logic
    );
end up_counter_base10;

architecture behaviour of up_counter_base10 is
    signal count : unsigned (3 downto 0);
begin
    process(clk, reset, ful) 
        variable scount : unsigned (3 downto 0);
    begin
        if reset ='0' then
            scount := "0000";
            carry <= '0';
        elsif ful ='0' then
            scount := "0000";
            carry <= '0';
        elsif (clk'event and clk='1') then                    
            if count = 9 then
                scount := "0000";
                carry <= '1';
            else 
                scount := scount + '1';
                carry <= '0';
            end if;
        end if;
        count <= scount;
    end process;
    data <= std_logic_vector(count);
end behaviour;

--
-- this is the code for the seven segment decoder
--

library ieee;                                    
    use ieee.std_logic_1164.all;

entity seven_segment_decoder is
    port( 
        data_in : in std_logic_vector(3 downto 0);
        data_out : out std_logic_vector(7 downto 0)
    );
end seven_segment_decoder;
 
architecture behaviour of seven_segment_decoder is
begin
    set_outputs: process(data_in)
    begin
        case data_in is
        when "0000" => data_out <= "11000000" ; 
        when "0001" => data_out <= "11111001" ;
        when "0010" => data_out <= "10100100" ;
        when "0011" => data_out <= "10110000" ;
        when "0100" => data_out <= "10011001" ;
        when "0101" => data_out <= "10010010" ;
        when "0110" => data_out <= "10000010" ;
        when "0111" => data_out <= "11111000" ;
        when "1000" => data_out <= "11000000" ;
        when "1001" => data_out <= "10010000" ;
        when others => data_out <= "11111111" ;
        end case;
    end process;
end behaviour;

--
-- this is the code for the compare function
-- 

library ieee;                                    
    use ieee.std_logic_1164.all;

entity compare_function is
    generic(word_size : integer:=8);	--  adder word size
    port(
        a,b : in std_logic_vector(word_size-1 downto 0);
        lessthan, equalto : out std_logic
    );
end compare_function;

architecture behaviour of compare_function is
begin
    process(a,b)
    begin
        if (a<b) then 
            lessthan <='1';
            equalto <='0';
        elsif (a=b) then
            lessthan <='0';
            equalto <='1';
        else
            lessthan <='0';
            equalto <='0';
        end if;
    end process;
end behaviour;

--
-- this is the code for latching sensor inputs
--
library ieee;                                    
    use ieee.std_logic_1164.all;
    use IEEE.std_logic_unsigned.all;
    use ieee.std_logic_arith.all;

entity sr_ff is
    port(
        s, r, reset   : in std_logic;
        q : out std_logic
    );
end sr_ff;

architecture structure of sr_ff is
begin
    reg : process (s, r, reset)
    begin
        if (r='1' or reset='0') then
            q <= '0';
        elsif (s'event and s ='1') then
            q <= '1';	
		end if;
    end process;
end structure;

