------------------------------------------------------------------------
--  Title     	: tb_carspeeder
--  Description	: Test Bench for verifying the car speeding circuit
--
--  (c) Roger Woods
------------------------------------------------------------------------
library IEEE;
   use IEEE.std_logic_1164.all;
   use IEEE.std_logic_arith.all;
   

--------------------
-- Entity Definition 
--------------------
entity tb_carspeeder is
end tb_carspeeder;

--------------------------
-- Architecture Definition
--------------------------
architecture behaviour of tb_carspeeder is
    signal s1, s2, reset, clk        : std_logic;
    signal speed1, speed10, speed100 : std_logic_vector(3 downto 0);
    signal speeding                  : std_logic;
    signal digit1, digit10, digit100 : std_logic_vector(7 downto 0);
     -- 100 kHz Half period:= 5000 ns
    constant clk_hperiod : time :=5000 ns; 
    
    component carspeeder
        port(        
            s1, s2, clk, reset : in std_logic;
            speed1, speed10, speed100 : in std_logic_vector(3 downto 0);
            speeding : out std_logic;
            digit1, digit10, digit100 : out std_logic_vector(7 downto 0)  
        );
end component;

begin
    test_unit : carspeeder
        Port Map (          
            s1 => s1,
            s2 => s2,
            clk => clk, 
            reset => reset, 
            speed1 => speed1,
            speed10 => speed10,
            speed100 => speed100,
            speeding => speeding, 
            digit1 => digit1,
            digit10 => digit10,
            digit100 => digit100
        );	
	
   --------------------------------------------------------
   -- Test Block contains processes to drive inputs.
   --------------------------------------------------------
   test_block : block
   begin
        -- Setting control signals
        --------------------------
        reset    <= '1' , '0' after 50 ns, '1' after 100 ns;
        speed1   <= "0000"; 
        speed10  <= "0110"; 
        speed100 <= "0011"; 
        
        -- Generating speed signals
        traffic_data : process 
            begin
            s1 <='0';
            s2 <='0';
            wait for 1000 ns;
            Traffic_in : for i in 1 to 2 loop 
       	        s1 <='1';
                wait for 1000 ns;
                s1 <='0';
                wait for 38000000 ns;
                s2 <='1';
                wait for 1000 ns;
                s2 <='0';
                wait for 10000 ns;
            end loop;
       
            -- Speeding car
            s1 <='1';
            wait for 1000 ns;
            s1 <='0';
            wait for 1500000 ns;
            s2 <='1';
            wait for 1000 ns;
            s2 <='0';
            wait for 1000 ns;
        end process;
       
        -- Generating Clock Signal
        clk_gen : process 
            begin
                loop 
                    clk <='1';
        	        wait for clk_hperiod;
        	        clk <='0';
        	        wait for clk_hperiod;
                end loop;
        end process;
    end block;   
end behaviour;
