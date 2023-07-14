--10 clock cycles for sorting_merge
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use ieee.math_real.all;
use work.arr_pkg_1.all;
use work.arr_pkg_2.all;
use work.arr_pkg_3.all;
entity sorting_pass_2 is
	generic(    
        data_length     : positive := 255                                 -- we can start from sorting 8 inputs 
        );
	port (
		clk             : in std_logic; 					                    -- system clock
		reset           : in std_logic; 					                    -- reset
		soft_input      : in input_data_array(data_length downto 0); 	        -- 6 bits
		soft_output     : out input_data_array(data_length downto 0)            -- soft output should be the same as soft input, I think we only need the index
	);
end sorting_pass_2;

architecture rtl of sorting_pass_2 is 
------------------------------------------------------------------------------------------------------------
--CLK 1
signal soft_input_pass_1			: input_data_array(data_length downto 0);
------------------------------------------------------------------------------------------------------------
--CLK 2
signal soft_input_pass_2			: input_data_array(data_length downto 0);
------------------------------------------------------------------------------------------------------------
--CLK 3
signal soft_input_pass_3			: input_data_array(data_length downto 0);
------------------------------------------------------------------------------------------------------------
--CLK 4
signal soft_input_pass_4			: input_data_array(data_length downto 0);
------------------------------------------------------------------------------------------------------------
--CLK 5
signal soft_input_pass_5			: input_data_array(data_length downto 0);
------------------------------------------------------------------------------------------------------------
--CLK 6
signal soft_input_pass_6			: input_data_array(data_length downto 0);
------------------------------------------------------------------------------------------------------------
--CLK 7
signal soft_input_pass_7			: input_data_array(data_length downto 0);
------------------------------------------------------------------------------------------------------------
--CLK 8
signal soft_input_pass_8			: input_data_array(data_length downto 0);
begin
------------------------------------------------------------------------------------------------------------
-- Define processes : (CLK 1)
------------------------------------------------------------------------------------------------------------
process(clk, reset)
begin
	if (reset = '1') then
		soft_input_pass_1 <= (others => (others => '0'));
    elsif (rising_edge(clk)) then    
        soft_input_pass_1 <= soft_input;
	end if;
end process;
------------------------------------------------------------------------------------------------------------
-- Define processes : (CLK 2)
------------------------------------------------------------------------------------------------------------
process(clk, reset)
begin
	if (reset = '1') then
		soft_input_pass_2 <= (others => (others => '0'));
    elsif (rising_edge(clk)) then   
        soft_input_pass_2 <= soft_input_pass_1;
	end if;
end process;
------------------------------------------------------------------------------------------------------------
-- Define processes : (CLK 3)
------------------------------------------------------------------------------------------------------------
process(clk, reset)
begin
	if (reset = '1') then
		soft_input_pass_3 <= (others => (others => '0'));
    elsif (rising_edge(clk)) then   
        soft_input_pass_3 <= soft_input_pass_2;
	end if;
end process;
------------------------------------------------------------------------------------------------------------
-- Define processes : (CLK 4)
------------------------------------------------------------------------------------------------------------
process(clk, reset)
begin
	if (reset = '1') then
		soft_input_pass_4 <= (others => (others => '0'));
    elsif (rising_edge(clk)) then   
        soft_input_pass_4 <= soft_input_pass_3;
	end if;
end process;
------------------------------------------------------------------------------------------------------------
-- Define processes : (CLK 5)
------------------------------------------------------------------------------------------------------------
process(clk, reset)
begin
	if (reset = '1') then
		soft_input_pass_5 <= (others => (others => '0'));
    elsif (rising_edge(clk)) then   
        soft_input_pass_5 <= soft_input_pass_4;
	end if;
end process;
------------------------------------------------------------------------------------------------------------
-- Define processes : (CLK 6)
------------------------------------------------------------------------------------------------------------
process(clk, reset)
begin
	if (reset = '1') then
		soft_input_pass_6 <= (others => (others => '0'));
    elsif (rising_edge(clk)) then   
        soft_input_pass_6 <= soft_input_pass_5;
	end if;
end process;
------------------------------------------------------------------------------------------------------------
-- Define processes : (CLK 7)
------------------------------------------------------------------------------------------------------------
process(clk, reset)
begin
	if (reset = '1') then
		soft_input_pass_7 <= (others => (others => '0'));
    elsif (rising_edge(clk)) then   
        soft_input_pass_7 <= soft_input_pass_6;
	end if;
end process;
------------------------------------------------------------------------------------------------------------
-- Define processes : (CLK 9)
------------------------------------------------------------------------------------------------------------
process(clk, reset)
begin
	if (reset = '1') then
		soft_input_pass_8 <= (others => (others => '0'));
    elsif (rising_edge(clk)) then   
        soft_input_pass_8 <= soft_input_pass_7;
	end if;
end process;
------------------------------------------------------------------------------------------------------------
-- Define processes : (CLK 10)
------------------------------------------------------------------------------------------------------------
process(clk, reset)
begin
	if (reset = '1') then
		soft_output     <= (others => (others => '0'));
    elsif (rising_edge(clk)) then    
		soft_output     <= soft_input_pass_8;
	end if;
end process;
end architecture;