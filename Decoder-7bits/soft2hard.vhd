--library ieee;
--use ieee.std_logic_1164.all;

--PACKAGE arr_pkg_7 IS
--    type input_data_array is array (natural range <>) of std_logic_vector(5 downto 0); -- 6 bits
--END; 

library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.std_logic_unsigned.all;
use ieee.math_real.all;
use work.arr_pkg_1.all;
use work.arr_pkg_2.all;
use work.arr_pkg_3.all;

entity soft2hard is
	generic(    
        data_length             : positive := 255
        );
	port (
		clk             : in std_logic; 					-- system clock
		reset           : in std_logic; 					-- reset
		soft_input      : in input_data_array(data_length downto 0); 	        -- 6 bits
		hard_output     : out std_logic_vector(data_length downto 0);          -- An array of integer
        soft_output     : out input_data_array(data_length downto 0)
	);
end soft2hard;
architecture rtl of soft2hard is 
------------------------------------------------------------------------------------------------------------
--CLK 0
signal soft_input_pass_in : input_data_array(255 downto 0);
------------------------------------------------------------------------------------------------------------
--CLK 1
signal soft_input_1      : input_data_array(255 downto 16);
signal hard_input_16     : std_logic_vector(15 downto 0);
signal soft_input_pass_1 : input_data_array(255 downto 0); 
-------------------------------------------------------------------------------------------------------------
--CLK 2
signal soft_input_2      : input_data_array(255 downto 32);
signal hard_input_16_1   : std_logic_vector(15 downto 0);
signal hard_input_32     : std_logic_vector(31 downto 16);
signal soft_input_pass_2 : input_data_array(255 downto 0); 
-------------------------------------------------------------------------------------------------------------
--CLK 3
signal soft_input_3      : input_data_array(255 downto 48);
signal hard_input_48     : std_logic_vector(47 downto 32);
signal hard_input_2      : std_logic_vector(31 downto 0);
signal soft_input_pass_3 : input_data_array(255 downto 0); 
-------------------------------------------------------------------------------------------------------------
--CLK 4
signal soft_input_4      : input_data_array(255 downto 64);
signal hard_input_64     : std_logic_vector(63 downto 48);
signal hard_input_3      : std_logic_vector(47 downto 0);
signal soft_input_pass_4 : input_data_array(255 downto 0); 
-------------------------------------------------------------------------------------------------------------
--CLK 5
signal soft_input_5        : input_data_array(255 downto 80);
signal hard_input_80       : std_logic_vector(79 downto 64);
signal hard_input_4        : std_logic_vector(63 downto 0);
signal soft_input_pass_5   : input_data_array(255 downto 0); 
-------------------------------------------------------------------------------------------------------------
--CLK 6
signal soft_input_6      : input_data_array(255 downto 96);
signal hard_input_96     : std_logic_vector(95 downto 80);
signal hard_input_5      : std_logic_vector(79 downto 0); 
signal soft_input_pass_6 : input_data_array(255 downto 0); 
-------------------------------------------------------------------------------------------------------------
--CLK 7
signal soft_input_7      : input_data_array(255 downto 112); 
signal hard_input_112    : std_logic_vector(111 downto 96);
signal hard_input_6      : std_logic_vector(95 downto 0); 
signal soft_input_pass_7 : input_data_array(255 downto 0); 
-------------------------------------------------------------------------------------------------------------
--CLK 8
signal soft_input_8      : input_data_array(255 downto 128);
signal hard_input_128    : std_logic_vector(127 downto 112);
signal hard_input_7      : std_logic_vector(111 downto 0); 
signal soft_input_pass_8 : input_data_array(255 downto 0);   
-------------------------------------------------------------------------------------------------------------
--CLK 9
signal soft_input_9       : input_data_array(255 downto 144);
signal hard_input_144     : std_logic_vector(143 downto 128);
signal hard_input_8       : std_logic_vector(127 downto 0); 
signal soft_input_pass_9  : input_data_array(255 downto 0); 
-------------------------------------------------------------------------------------------------------------
--CLK 10
signal soft_input_10      : input_data_array(255 downto 160);
signal hard_input_160     : std_logic_vector(159 downto 144);
signal hard_input_9       : std_logic_vector(143 downto 0);  
signal soft_input_pass_10 : input_data_array(255 downto 0);  
-------------------------------------------------------------------------------------------------------------
--CLK 11
signal soft_input_11      : input_data_array(255 downto 176);
signal hard_input_176     : std_logic_vector(175 downto 160);
signal hard_input_10      : std_logic_vector(159 downto 0);  
signal soft_input_pass_11 : input_data_array(255 downto 0);  
-------------------------------------------------------------------------------------------------------------
--CLK 12
signal soft_input_12      : input_data_array(255 downto 192);
signal hard_input_192     : std_logic_vector(191 downto 176);
signal hard_input_11      : std_logic_vector(175 downto 0);   
signal soft_input_pass_12 : input_data_array(255 downto 0);  
-------------------------------------------------------------------------------------------------------------
--CLK 13
signal soft_input_13      : input_data_array(255 downto 208); 
signal hard_input_208     : std_logic_vector(207 downto 192);
signal hard_input_12      : std_logic_vector(191 downto 0); 
signal soft_input_pass_13 : input_data_array(255 downto 0);  
-------------------------------------------------------------------------------------------------------------
--CLK 14
signal soft_input_14      : input_data_array(255 downto 224); 
signal hard_input_224     : std_logic_vector(223 downto 208);
signal hard_input_13      : std_logic_vector(207 downto 0); 
signal soft_input_pass_14 : input_data_array(255 downto 0);  
-------------------------------------------------------------------------------------------------------------
--CLK 15
signal soft_input_15         : input_data_array(255 downto 240); 
signal hard_input_240        : std_logic_vector(239 downto 224);
signal hard_input_14         : std_logic_vector(223 downto 0); 
signal soft_input_pass_15    : input_data_array(255 downto 0);  
-------------------------------------------------------------------------------------------------------------
--CLK 16
signal hard_input_256        : std_logic_vector(255 downto 240);
signal hard_input_15         : std_logic_vector(239 downto 0);  
signal soft_input_pass_16    : input_data_array(255 downto 0);  
-------------------------------------------------------------------------------------------------------------
--CLK 17
signal hard_input_f          : std_logic_vector(255 downto 0);  
signal soft_input_pass_17    : input_data_array(255 downto 0);  
begin
------------------------------------------------------------------------------------------------------------
-- Define process(CLK 0)
------------------------------------------------------------------------------------------------------------
process(clk, reset)
begin
	if (reset = '1') then
        soft_input_pass_in   <= (others => (others => '0'));
    elsif rising_edge(clk) then
        soft_input_pass_in  <= soft_input;
    end if;
end process;
------------------------------------------------------------------------------------------------------------
-- Define process(CLK 1)
------------------------------------------------------------------------------------------------------------
process(clk, reset)
begin
	if (reset = '1') then
        soft_input_1        <= (others => (others => '0'));
        hard_input_16       <= (others => '0');
        soft_input_pass_1   <= (others => (others => '0'));
    elsif rising_edge(clk) then
        soft_input_pass_1  <= soft_input_pass_in;
        for i in 0 to 15 loop  -- SIHO, turn 16 soft bits into hard bits at one clock cycle
            hard_input_16(i) <=  not soft_input_pass_in(i)(7); -- Hard input = the first bit of soft input
        end loop;
        soft_input_1 <= soft_input_pass_in(255 downto 16); -- pass the rest likelihood to next clk
    end if;
end process;
------------------------------------------------------------------------------------------------------------
-- Define process(CLK 2)
------------------------------------------------------------------------------------------------------------
process(clk, reset)
begin
	if (reset = '1') then
        soft_input_2        <= (others => (others => '0'));
        hard_input_16_1     <= (others => '0');
        hard_input_32       <= (others => '0');
        soft_input_pass_2   <= (others => (others => '0'));
    elsif rising_edge(clk) then   
        soft_input_pass_2  <= soft_input_pass_1;      
        for i in 16 to 31 loop 
            hard_input_32(i) <= not soft_input_1(i)(7);
        end loop;
        soft_input_2     <= soft_input_1(255 downto 32);
        hard_input_16_1  <= hard_input_16;              -- hard input
    end if;
end process;
------------------------------------------------------------------------------------------------------------
-- Define process(CLK 3)
------------------------------------------------------------------------------------------------------------
process(clk, reset)
begin
	if (reset = '1') then
        soft_input_pass_3 <= (others => (others => '0'));
        soft_input_3      <= (others => (others => '0'));
        hard_input_48     <= (others => '0');
        hard_input_2      <= (others => '0');
    elsif rising_edge(clk) then  
        soft_input_pass_3  <= soft_input_pass_2;    
        for i in 32 to 47 loop 
            hard_input_48(i) <=  not soft_input_2(i)(7);
        end loop;
        soft_input_3     <= soft_input_2(255 downto 48);
        hard_input_2     <= hard_input_32 & hard_input_16_1; -- hard input, 64
    end if;
end process;
------------------------------------------------------------------------------------------------------------
-- Define process(CLK 4)
------------------------------------------------------------------------------------------------------------
process(clk, reset)
begin
	if (reset = '1') then
        soft_input_pass_4<= (others => (others => '0'));
        soft_input_4     <= (others => (others => '0'));
        hard_input_64    <= (others => '0');
        hard_input_3     <= (others => '0');
    elsif rising_edge(clk) then  
        soft_input_pass_4  <= soft_input_pass_3;   
        for i in 48 to 63 loop
            hard_input_64(i) <=  not soft_input_3(i)(7);
        end loop;
        soft_input_4     <= soft_input_3(255 downto 64);
        hard_input_3     <= hard_input_48 & hard_input_2;
    end if;
end process;
------------------------------------------------------------------------------------------------------------
-- Define processes : (CLK 5)
------------------------------------------------------------------------------------------------------------
process(clk, reset)
begin
	if (reset = '1') then
        soft_input_pass_5      <= (others => (others => '0'));
        soft_input_5           <= (others => (others => '0'));
        hard_input_80          <= (others => '0');
        hard_input_4           <= (others => '0');
    elsif rising_edge(clk) then  
        soft_input_pass_5  <= soft_input_pass_4;
        for i in 64 to 79 loop
            hard_input_80(i) <=  not soft_input_4(i)(7);
        end loop;
        soft_input_5     <= soft_input_4(255 downto 80);
        hard_input_4     <= hard_input_64 & hard_input_3;
    end if;
end process;
------------------------------------------------------------------------------------------------------------
-- Define processes : (CLK 6)
------------------------------------------------------------------------------------------------------------
process(clk, reset)
begin
	if (reset = '1') then
        soft_input_pass_6      <= (others => (others => '0'));
        soft_input_6           <= (others => (others => '0'));
        hard_input_96          <= (others => '0');
        hard_input_5           <= (others => '0');
    elsif rising_edge(clk) then 
        soft_input_pass_6  <= soft_input_pass_5; 
        for i in 80 to 95 loop
            hard_input_96(i) <=  not soft_input_5(i)(7);
        end loop;
        soft_input_6     <= soft_input_5(255 downto 96);
        hard_input_5     <= hard_input_80 & hard_input_4;
    end if;
end process;
------------------------------------------------------------------------------------------------------------
-- Define processes : (CLK 7)
------------------------------------------------------------------------------------------------------------
process(clk, reset)
begin
	if (reset = '1') then
        soft_input_pass_7       <= (others => (others => '0'));
        soft_input_7            <= (others => (others => '0'));
        hard_input_112          <= (others => '0');
        hard_input_6            <= (others => '0');
    elsif rising_edge(clk) then  
        soft_input_pass_7  <= soft_input_pass_6; 
        for i in 96 to 111 loop
            hard_input_112(i) <=  not soft_input_6(i)(7);
        end loop;
        soft_input_7     <= soft_input_6(255 downto 112);
        hard_input_6     <= hard_input_96 & hard_input_5;
    end if;
end process;
------------------------------------------------------------------------------------------------------------
-- Define processes : (CLK 8)
------------------------------------------------------------------------------------------------------------
process(clk, reset)
begin
	if (reset = '1') then
        soft_input_pass_8   <= (others => (others => '0'));
        soft_input_8        <= (others => (others => '0'));
        hard_input_128      <= (others => '0');
        hard_input_7        <= (others => '0');
    elsif rising_edge(clk) then 
        soft_input_pass_8  <= soft_input_pass_7; 
        for i in 112 to 127 loop
            hard_input_128(i) <=  not soft_input_7(i)(7);
        end loop;
        soft_input_8     <= soft_input_7(255 downto 128);
        hard_input_7     <= hard_input_112 & hard_input_6;
    end if;
end process;
------------------------------------------------------------------------------------------------------------
-- Define processes : (CLK 9)
------------------------------------------------------------------------------------------------------------
process(clk, reset)
begin
	if (reset = '1') then
        soft_input_pass_9   <= (others => (others => '0'));
        soft_input_9        <= (others => (others => '0'));
        hard_input_144      <= (others => '0');
        hard_input_8        <= (others => '0');
    elsif rising_edge(clk) then  
        soft_input_pass_9 <= soft_input_pass_8;
        for i in 128 to 143 loop
            hard_input_144(i) <=  not soft_input_8(i)(7);
        end loop;
        soft_input_9     <= soft_input_8(255 downto 144);
        hard_input_8     <= hard_input_128 & hard_input_7;
    end if;
end process;
--------------------------------------------------------------------------------------------------------------
---- Define processes : (CLK 10)
--------------------------------------------------------------------------------------------------------------
process(clk, reset)
begin
	if (reset = '1') then
        soft_input_pass_10<= (others => (others => '0'));
        soft_input_10     <= (others => (others => '0'));
        hard_input_160    <= (others => '0');
        hard_input_9      <= (others => '0');
    elsif rising_edge(clk) then  
        soft_input_pass_10 <= soft_input_pass_9;
        for i in 144 to 159 loop
            hard_input_160(i) <=  not soft_input_9(i)(7);
        end loop;
        soft_input_10     <= soft_input_9(255 downto 160);
        hard_input_9      <= hard_input_144 & hard_input_8;
    end if;
end process;
--------------------------------------------------------------------------------------------------------------
---- Define processes : (CLK 11)
--------------------------------------------------------------------------------------------------------------
process(clk, reset)
begin
	if (reset = '1') then
        soft_input_pass_11 <= (others => (others => '0'));
        soft_input_11      <= (others => (others => '0'));
        hard_input_176     <= (others => '0');
        hard_input_10      <= (others => '0');
    elsif rising_edge(clk) then  
        soft_input_pass_11 <= soft_input_pass_10;
        for i in 160 to 175 loop
            hard_input_176(i) <=  not soft_input_10(i)(7);
        end loop;
        soft_input_11      <= soft_input_10(255 downto 176);
        hard_input_10      <= hard_input_160 & hard_input_9;
    end if;
end process;
--------------------------------------------------------------------------------------------------------------
---- Define processes : (CLK 12)
--------------------------------------------------------------------------------------------------------------
process(clk, reset)
begin
	if (reset = '1') then
        soft_input_pass_12 <= (others => (others => '0'));
        soft_input_12      <= (others => (others => '0'));
        hard_input_192     <= (others => '0');
        hard_input_11      <= (others => '0');
    elsif rising_edge(clk) then  
        soft_input_pass_12 <= soft_input_pass_11;
        for i in 176 to 191 loop
            hard_input_192(i) <=  not soft_input_11(i)(7);
        end loop;
        soft_input_12      <= soft_input_11(255 downto 192);
        hard_input_11      <= hard_input_176 & hard_input_10;
    end if;
end process;
--------------------------------------------------------------------------------------------------------------
---- Define processes : (CLK 13)
--------------------------------------------------------------------------------------------------------------
process(clk, reset)
begin
	if (reset = '1') then
        soft_input_pass_13 <= (others => (others => '0'));
        soft_input_13      <= (others => (others => '0'));
        hard_input_208     <= (others => '0');
        hard_input_12      <= (others => '0');
    elsif rising_edge(clk) then  
        soft_input_pass_13 <= soft_input_pass_12;
        for i in 192 to 207 loop
            hard_input_208(i) <=  not soft_input_12(i)(7);
        end loop;
        soft_input_13      <= soft_input_12(255 downto 208);
        hard_input_12      <= hard_input_192 & hard_input_11;
    end if;
end process;
--------------------------------------------------------------------------------------------------------------
---- Define processes : (CLK 14)
--------------------------------------------------------------------------------------------------------------
process(clk, reset)
begin
	if (reset = '1') then
        soft_input_pass_14 <= (others => (others => '0'));
        soft_input_14      <= (others => (others => '0'));
        hard_input_224     <= (others => '0');
        hard_input_13      <= (others => '0');
    elsif rising_edge(clk) then   
        soft_input_pass_14 <= soft_input_pass_13;
        for i in 208 to 223 loop
            hard_input_224(i) <=  not soft_input_13(i)(7);
        end loop;
        soft_input_14      <= soft_input_13(255 downto 224);
        hard_input_13      <= hard_input_208 & hard_input_12;
    end if;
end process;
--------------------------------------------------------------------------------------------------------------
---- Define processes : (CLK 15)
--------------------------------------------------------------------------------------------------------------
process(clk, reset)
begin
	if (reset = '1') then
        soft_input_pass_15   <= (others => (others => '0'));
        soft_input_15        <= (others => (others => '0'));
        hard_input_240       <= (others => '0');
        hard_input_14        <= (others => '0');
    elsif rising_edge(clk) then  
        soft_input_pass_15 <= soft_input_pass_14;
        for i in 224 to 239 loop
            hard_input_240(i) <=  not soft_input_14(i)(7);
        end loop;
        soft_input_15        <= soft_input_14(255 downto 240);
        hard_input_14        <= hard_input_224 & hard_input_13;
    end if;
end process;
------------------------------------------------------------------------------------------------------------
---- Define processes : (CLK 16)
------------------------------------------------------------------------------------------------------------
process(clk, reset)
begin
	if (reset = '1') then
        hard_input_256      <= (others => '0');
        hard_input_15       <= (others => '0');
        soft_input_pass_16  <= (others => (others => '0'));
    elsif rising_edge(clk) then  
        soft_input_pass_16 <= soft_input_pass_15;
        for i in 240 to 255 loop
            hard_input_256(i) <=  not soft_input_15(i)(7);
        end loop;
        hard_input_15    <= hard_input_240 & hard_input_14;
    end if;
end process;
----------------------------------------------------------------------------------------------------------------
---- Define processes : (CLK 17)
----------------------------------------------------------------------------------------------------------------
process(clk, reset)
begin
	if (reset = '1') then
        hard_input_f        <= (others => '0');
        soft_input_pass_17  <= (others => (others => '0'));
    elsif rising_edge(clk) then  
        soft_input_pass_17 <= soft_input_pass_16;
        hard_input_f       <= hard_input_256 & hard_input_15; -- Here, the hard input is complete
    end if;
end process;
----------------------------------------------------------------------------------------------------------------
---- Define processes : (CLK 18)
----------------------------------------------------------------------------------------------------------------
process(clk, reset)
begin
	if (reset = '1') then
        soft_output     <= (others => (others => '0'));
        hard_output     <= (others => '0');
    elsif rising_edge(clk) then  
        hard_output      <= hard_input_f; -- Here, the hard input is complete
        soft_output      <= soft_input_pass_17;
    end if;
end process;
end architecture;