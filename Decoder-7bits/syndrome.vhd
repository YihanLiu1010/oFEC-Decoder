library ieee;
use ieee.std_logic_1164.all;

--PACKAGE arr_pkg_8 IS
--    type input_data_array is array (natural range <>) of std_logic_vector(5 downto 0); -- 6 bits
--END; 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use ieee.math_real.all;
use work.arr_pkg_1.all;
use work.arr_pkg_2.all;
use work.arr_pkg_3.all;

entity syndrome is
	generic(    
		data_length             : positive := 255
	);
	port (
		clk             		: in std_logic; 							    -- system clock
		reset           		: in std_logic; 							    -- reset
		hard_input	         	: in std_logic_vector(data_length downto 0);	
		soft_input				: in input_data_array(data_length downto 0);	-- Soft input will be passed onto BCH block

		hard_output     		: out std_logic_vector(data_length downto 0);   -- This should be the same as 'hard_input' and will be used in the BCH decoder
		s1              		: out std_logic_vector(7 downto 0);
		s3              		: out std_logic_vector(7 downto 0);
		soft_output 			: out input_data_array(data_length downto 0)
	);
end syndrome;

architecture rtl of syndrome is 
--------------------------------------------------------------------------------------------
-- CLK 0
signal hard_input_in 			: std_logic_vector(data_length downto 0);
signal soft_input_in 			: input_data_array(data_length downto 0);
--------------------------------------------------------------------------------------------
-- CLK 1
signal soft_input_1				: input_data_array(data_length downto 0);
signal s1_xor_result_0			: std_logic;	-- xor result of the 0th bit for syndrome s1
signal s1_xor_result_1			: std_logic;
signal s1_xor_result_2			: std_logic;
signal s1_xor_result_3			: std_logic;
signal s1_xor_result_4			: std_logic;
signal s1_xor_result_5			: std_logic;
signal s1_xor_result_6			: std_logic;
signal s1_xor_result_7			: std_logic;
signal s3_xor_result_0			: std_logic;	-- xor result of the 0th bit for syndrome s3
signal s3_xor_result_1			: std_logic;
signal s3_xor_result_2			: std_logic;
signal s3_xor_result_3			: std_logic;
signal s3_xor_result_4			: std_logic;
signal s3_xor_result_5			: std_logic;
signal s3_xor_result_6			: std_logic;
signal s3_xor_result_7			: std_logic;
signal hard_input_1      		: std_logic_vector(data_length downto 0);
--------------------------------------------------------------------------------------------
-- CLK 2
signal soft_input_2				: input_data_array(data_length downto 0);
signal s1_xor_result_0_1		: std_logic;
signal s1_xor_result_1_1		: std_logic;
signal s1_xor_result_2_1		: std_logic;
signal s1_xor_result_3_1		: std_logic;
signal s1_xor_result_4_1		: std_logic;
signal s1_xor_result_5_1		: std_logic;
signal s1_xor_result_6_1		: std_logic;
signal s1_xor_result_7_1		: std_logic;
signal s3_xor_result_0_1		: std_logic;
signal s3_xor_result_1_1		: std_logic;
signal s3_xor_result_2_1		: std_logic;
signal s3_xor_result_3_1		: std_logic;
signal s3_xor_result_4_1		: std_logic;
signal s3_xor_result_5_1		: std_logic;
signal s3_xor_result_6_1		: std_logic;
signal s3_xor_result_7_1		: std_logic;
signal hard_input_2      		: std_logic_vector(data_length downto 0);
--------------------------------------------------------------------------------------------
-- CLK 3
signal soft_input_3				: input_data_array(data_length downto 0);
signal s1_xor_result_0_2		: std_logic;
signal s1_xor_result_1_2		: std_logic;
signal s1_xor_result_2_2		: std_logic;
signal s1_xor_result_3_2		: std_logic;
signal s1_xor_result_4_2		: std_logic;
signal s1_xor_result_5_2		: std_logic;
signal s1_xor_result_6_2		: std_logic;
signal s1_xor_result_7_2		: std_logic;
signal s3_xor_result_0_2		: std_logic;
signal s3_xor_result_1_2		: std_logic;
signal s3_xor_result_2_2		: std_logic;
signal s3_xor_result_3_2		: std_logic;
signal s3_xor_result_4_2		: std_logic;
signal s3_xor_result_5_2		: std_logic;
signal s3_xor_result_6_2		: std_logic;
signal s3_xor_result_7_2		: std_logic;
signal hard_input_3      		: std_logic_vector(data_length downto 0);
--------------------------------------------------------------------------------------------
-- CLK 4
signal soft_input_4				: input_data_array(data_length downto 0);
signal s1_xor_result_0_3		: std_logic;
signal s1_xor_result_1_3		: std_logic;
signal s1_xor_result_2_3		: std_logic;
signal s1_xor_result_3_3		: std_logic;
signal s1_xor_result_4_3		: std_logic;
signal s1_xor_result_5_3		: std_logic;
signal s1_xor_result_6_3		: std_logic;
signal s1_xor_result_7_3		: std_logic;
signal s3_xor_result_0_3		: std_logic;
signal s3_xor_result_1_3		: std_logic;
signal s3_xor_result_2_3		: std_logic;
signal s3_xor_result_3_3		: std_logic;
signal s3_xor_result_4_3		: std_logic;
signal s3_xor_result_5_3		: std_logic;
signal s3_xor_result_6_3		: std_logic;
signal s3_xor_result_7_3		: std_logic;
signal hard_input_4      		: std_logic_vector(data_length downto 0);
--------------------------------------------------------------------------------------------
-- CLK 5
signal soft_input_5				: input_data_array(data_length downto 0);
signal s1_xor_result_0_4		: std_logic;
signal s1_xor_result_1_4		: std_logic;
signal s1_xor_result_2_4		: std_logic;
signal s1_xor_result_3_4		: std_logic;
signal s1_xor_result_4_4		: std_logic;
signal s1_xor_result_5_4		: std_logic;
signal s1_xor_result_6_4		: std_logic;
signal s1_xor_result_7_4		: std_logic;
signal s3_xor_result_0_4		: std_logic;
signal s3_xor_result_1_4		: std_logic;
signal s3_xor_result_2_4		: std_logic;
signal s3_xor_result_3_4		: std_logic;
signal s3_xor_result_4_4		: std_logic;
signal s3_xor_result_5_4		: std_logic;
signal s3_xor_result_6_4		: std_logic;
signal s3_xor_result_7_4		: std_logic;
signal hard_input_5      		: std_logic_vector(data_length downto 0);
--------------------------------------------------------------------------------------------
-- CLK 6
signal soft_input_6				: input_data_array(data_length downto 0);
signal s1_xor_result_0_5		: std_logic;
signal s1_xor_result_1_5		: std_logic;
signal s1_xor_result_2_5		: std_logic;
signal s1_xor_result_3_5		: std_logic;
signal s1_xor_result_4_5		: std_logic;
signal s1_xor_result_5_5		: std_logic;
signal s1_xor_result_6_5		: std_logic;
signal s1_xor_result_7_5		: std_logic;
signal s3_xor_result_0_5		: std_logic;
signal s3_xor_result_1_5		: std_logic;
signal s3_xor_result_2_5		: std_logic;
signal s3_xor_result_3_5		: std_logic;
signal s3_xor_result_4_5		: std_logic;
signal s3_xor_result_5_5		: std_logic;
signal s3_xor_result_6_5		: std_logic;
signal s3_xor_result_7_5		: std_logic;
signal hard_input_6      		: std_logic_vector(data_length downto 0);
--------------------------------------------------------------------------------------------
-- CLK 7
signal soft_input_7				: input_data_array(data_length downto 0);
signal s1_xor_result_0_6		: std_logic;
signal s1_xor_result_1_6		: std_logic;
signal s1_xor_result_2_6		: std_logic;
signal s1_xor_result_3_6		: std_logic;
signal s1_xor_result_4_6		: std_logic;
signal s1_xor_result_5_6		: std_logic;
signal s1_xor_result_6_6		: std_logic;
signal s1_xor_result_7_6		: std_logic;
signal s3_xor_result_0_6		: std_logic;
signal s3_xor_result_1_6		: std_logic;
signal s3_xor_result_2_6		: std_logic;
signal s3_xor_result_3_6		: std_logic;
signal s3_xor_result_4_6		: std_logic;
signal s3_xor_result_5_6		: std_logic;
signal s3_xor_result_6_6		: std_logic;
signal s3_xor_result_7_6		: std_logic;
signal hard_input_7      		: std_logic_vector(data_length downto 0);
--------------------------------------------------------------------------------------------
-- CLK 8
signal soft_input_8				: input_data_array(data_length downto 0);
signal s1_xor_result_0_7		: std_logic;
signal s1_xor_result_1_7		: std_logic;
signal s1_xor_result_2_7		: std_logic;
signal s1_xor_result_3_7		: std_logic;
signal s1_xor_result_4_7		: std_logic;
signal s1_xor_result_5_7		: std_logic;
signal s1_xor_result_6_7		: std_logic;
signal s1_xor_result_7_7		: std_logic;
signal s3_xor_result_0_7		: std_logic;
signal s3_xor_result_1_7		: std_logic;
signal s3_xor_result_2_7		: std_logic;
signal s3_xor_result_3_7		: std_logic;
signal s3_xor_result_4_7		: std_logic;
signal s3_xor_result_5_7		: std_logic;
signal s3_xor_result_6_7		: std_logic;
signal s3_xor_result_7_7		: std_logic;
signal hard_input_8      		: std_logic_vector(data_length downto 0);
--------------------------------------------------------------------------------------------
-- CLK 9
signal soft_input_9				: input_data_array(data_length downto 0);
signal s1_xor_result_0_8		: std_logic;
signal s1_xor_result_1_8		: std_logic;
signal s1_xor_result_2_8		: std_logic;
signal s1_xor_result_3_8		: std_logic;
signal s1_xor_result_4_8		: std_logic;
signal s1_xor_result_5_8		: std_logic;
signal s1_xor_result_6_8		: std_logic;
signal s1_xor_result_7_8		: std_logic;
signal s3_xor_result_0_8		: std_logic;
signal s3_xor_result_1_8		: std_logic;
signal s3_xor_result_2_8		: std_logic;
signal s3_xor_result_3_8		: std_logic;
signal s3_xor_result_4_8		: std_logic;
signal s3_xor_result_5_8		: std_logic;
signal s3_xor_result_6_8		: std_logic;
signal s3_xor_result_7_8		: std_logic;
signal hard_input_9      		: std_logic_vector(data_length downto 0);
--------------------------------------------------------------------------------------------
-- CLK 10
signal soft_input_10			: input_data_array(data_length downto 0);
signal s1_xor_result_0_9		: std_logic;
signal s1_xor_result_1_9		: std_logic;
signal s1_xor_result_2_9		: std_logic;
signal s1_xor_result_3_9		: std_logic;
signal s1_xor_result_4_9		: std_logic;
signal s1_xor_result_5_9		: std_logic;
signal s1_xor_result_6_9		: std_logic;
signal s1_xor_result_7_9		: std_logic;
signal s3_xor_result_0_9		: std_logic;
signal s3_xor_result_1_9		: std_logic;
signal s3_xor_result_2_9		: std_logic;
signal s3_xor_result_3_9		: std_logic;
signal s3_xor_result_4_9		: std_logic;
signal s3_xor_result_5_9		: std_logic;
signal s3_xor_result_6_9		: std_logic;
signal s3_xor_result_7_9		: std_logic;
signal hard_input_10      		: std_logic_vector(data_length downto 0);
--------------------------------------------------------------------------------------------
-- CLK 11
signal soft_input_11			: input_data_array(data_length downto 0);
signal s1_xor_result_0_10		: std_logic;
signal s1_xor_result_1_10		: std_logic;
signal s1_xor_result_2_10		: std_logic;
signal s1_xor_result_3_10		: std_logic;
signal s1_xor_result_4_10		: std_logic;
signal s1_xor_result_5_10		: std_logic;
signal s1_xor_result_6_10		: std_logic;
signal s1_xor_result_7_10		: std_logic;
signal s3_xor_result_0_10		: std_logic;
signal s3_xor_result_1_10		: std_logic;
signal s3_xor_result_2_10		: std_logic;
signal s3_xor_result_3_10		: std_logic;
signal s3_xor_result_4_10		: std_logic;
signal s3_xor_result_5_10		: std_logic;
signal s3_xor_result_6_10		: std_logic;
signal s3_xor_result_7_10		: std_logic;
signal hard_input_11      		: std_logic_vector(data_length downto 0);
--------------------------------------------------------------------------------------------
-- CLK 12
signal soft_input_12			: input_data_array(data_length downto 0);
signal s1_xor_result_0_11		: std_logic;
signal s1_xor_result_1_11		: std_logic;
signal s1_xor_result_2_11		: std_logic;
signal s1_xor_result_3_11		: std_logic;
signal s1_xor_result_4_11		: std_logic;
signal s1_xor_result_5_11		: std_logic;
signal s1_xor_result_6_11		: std_logic;
signal s1_xor_result_7_11		: std_logic;
signal s3_xor_result_0_11		: std_logic;
signal s3_xor_result_1_11		: std_logic;
signal s3_xor_result_2_11		: std_logic;
signal s3_xor_result_3_11		: std_logic;
signal s3_xor_result_4_11		: std_logic;
signal s3_xor_result_5_11		: std_logic;
signal s3_xor_result_6_11		: std_logic;
signal s3_xor_result_7_11		: std_logic;
signal hard_input_12      		: std_logic_vector(data_length downto 0);
--------------------------------------------------------------------------------------------
-- CLK 13
signal soft_input_13			: input_data_array(data_length downto 0);
signal s1_xor_result_0_12		: std_logic;
signal s1_xor_result_1_12		: std_logic;
signal s1_xor_result_2_12		: std_logic;
signal s1_xor_result_3_12		: std_logic;
signal s1_xor_result_4_12		: std_logic;
signal s1_xor_result_5_12		: std_logic;
signal s1_xor_result_6_12		: std_logic;
signal s1_xor_result_7_12		: std_logic;
signal s3_xor_result_0_12		: std_logic;
signal s3_xor_result_1_12		: std_logic;
signal s3_xor_result_2_12		: std_logic;
signal s3_xor_result_3_12		: std_logic;
signal s3_xor_result_4_12		: std_logic;
signal s3_xor_result_5_12		: std_logic;
signal s3_xor_result_6_12		: std_logic;
signal s3_xor_result_7_12		: std_logic;
signal hard_input_13      		: std_logic_vector(data_length downto 0);
--------------------------------------------------------------------------------------------
-- CLK 14
signal soft_input_14			: input_data_array(data_length downto 0);
signal s1_xor_result_0_13		: std_logic;
signal s1_xor_result_1_13		: std_logic;
signal s1_xor_result_2_13		: std_logic;
signal s1_xor_result_3_13		: std_logic;
signal s1_xor_result_4_13		: std_logic;
signal s1_xor_result_5_13		: std_logic;
signal s1_xor_result_6_13		: std_logic;
signal s1_xor_result_7_13		: std_logic;
signal s3_xor_result_0_13		: std_logic;
signal s3_xor_result_1_13		: std_logic;
signal s3_xor_result_2_13		: std_logic;
signal s3_xor_result_3_13		: std_logic;
signal s3_xor_result_4_13		: std_logic;
signal s3_xor_result_5_13		: std_logic;
signal s3_xor_result_6_13		: std_logic;
signal s3_xor_result_7_13		: std_logic;
signal hard_input_14      		: std_logic_vector(data_length downto 0);
--------------------------------------------------------------------------------------------
-- CLK 15
signal soft_input_15			: input_data_array(data_length downto 0);
signal s1_xor_result_0_14		: std_logic;
signal s1_xor_result_1_14		: std_logic;
signal s1_xor_result_2_14		: std_logic;
signal s1_xor_result_3_14		: std_logic;
signal s1_xor_result_4_14		: std_logic;
signal s1_xor_result_5_14		: std_logic;
signal s1_xor_result_6_14		: std_logic;
signal s1_xor_result_7_14		: std_logic;
signal s3_xor_result_0_14		: std_logic;
signal s3_xor_result_1_14		: std_logic;
signal s3_xor_result_2_14		: std_logic;
signal s3_xor_result_3_14		: std_logic;
signal s3_xor_result_4_14		: std_logic;
signal s3_xor_result_5_14		: std_logic;
signal s3_xor_result_6_14		: std_logic;
signal s3_xor_result_7_14		: std_logic;
signal hard_input_15      		: std_logic_vector(data_length downto 0);
--------------------------------------------------------------------------------------------
-- CLK 16
signal soft_input_16			: input_data_array(data_length downto 0);
signal s1_xor_result_0_15		: std_logic;
signal s1_xor_result_1_15		: std_logic;
signal s1_xor_result_2_15		: std_logic;
signal s1_xor_result_3_15		: std_logic;
signal s1_xor_result_4_15		: std_logic;
signal s1_xor_result_5_15		: std_logic;
signal s1_xor_result_6_15		: std_logic;
signal s1_xor_result_7_15		: std_logic;
signal s3_xor_result_0_15		: std_logic;
signal s3_xor_result_1_15		: std_logic;
signal s3_xor_result_2_15		: std_logic;
signal s3_xor_result_3_15		: std_logic;
signal s3_xor_result_4_15		: std_logic;
signal s3_xor_result_5_15		: std_logic;
signal s3_xor_result_6_15		: std_logic;
signal s3_xor_result_7_15		: std_logic;
signal hard_input_16      		: std_logic_vector(data_length downto 0);
--------------------------------------------------------------------------------------------
-- CLK 17
signal soft_input_17			: input_data_array(data_length downto 0);
signal s1_xor_result_0_16		: std_logic;
signal s1_xor_result_1_16		: std_logic;
signal s1_xor_result_2_16		: std_logic;
signal s1_xor_result_3_16		: std_logic;
signal s1_xor_result_4_16		: std_logic;
signal s1_xor_result_5_16		: std_logic;
signal s1_xor_result_6_16		: std_logic;
signal s1_xor_result_7_16		: std_logic;
signal s3_xor_result_0_16		: std_logic;
signal s3_xor_result_1_16		: std_logic;
signal s3_xor_result_2_16		: std_logic;
signal s3_xor_result_3_16		: std_logic;
signal s3_xor_result_4_16		: std_logic;
signal s3_xor_result_5_16		: std_logic;
signal s3_xor_result_6_16		: std_logic;
signal s3_xor_result_7_16		: std_logic;
signal hard_input_17      		: std_logic_vector(data_length downto 0);
--------------------------------------------------------------------------------------------
-- CLK 18
signal soft_input_18			: input_data_array(data_length downto 0);
signal s1_xor_result_0_17		: std_logic;
signal s1_xor_result_1_17		: std_logic;
signal s1_xor_result_2_17		: std_logic;
signal s1_xor_result_3_17		: std_logic;
signal s1_xor_result_4_17		: std_logic;
signal s1_xor_result_5_17		: std_logic;
signal s1_xor_result_6_17		: std_logic;
signal s1_xor_result_7_17		: std_logic;
signal s3_xor_result_0_17		: std_logic;
signal s3_xor_result_1_17		: std_logic;
signal s3_xor_result_2_17		: std_logic;
signal s3_xor_result_3_17		: std_logic;
signal s3_xor_result_4_17		: std_logic;
signal s3_xor_result_5_17		: std_logic;
signal s3_xor_result_6_17		: std_logic;
signal s3_xor_result_7_17		: std_logic;
signal hard_input_18      		: std_logic_vector(data_length downto 0);
--------------------------------------------------------------------------------------------
-- CLK 19
signal soft_input_19			: input_data_array(data_length downto 0);
signal s1_xor_result_0_18		: std_logic;
signal s1_xor_result_1_18		: std_logic;
signal s1_xor_result_2_18		: std_logic;
signal s1_xor_result_3_18		: std_logic;
signal s1_xor_result_4_18		: std_logic;
signal s1_xor_result_5_18		: std_logic;
signal s1_xor_result_6_18		: std_logic;
signal s1_xor_result_7_18		: std_logic;
signal s3_xor_result_0_18		: std_logic;
signal s3_xor_result_1_18		: std_logic;
signal s3_xor_result_2_18		: std_logic;
signal s3_xor_result_3_18		: std_logic;
signal s3_xor_result_4_18		: std_logic;
signal s3_xor_result_5_18		: std_logic;
signal s3_xor_result_6_18		: std_logic;
signal s3_xor_result_7_18		: std_logic;
signal hard_input_19      		: std_logic_vector(data_length downto 0);
--------------------------------------------------------------------------------------------
-- CLK 20
signal soft_input_20			: input_data_array(data_length downto 0);
signal s1_xor_result_0_19		: std_logic;
signal s1_xor_result_1_19		: std_logic;
signal s1_xor_result_2_19		: std_logic;
signal s1_xor_result_3_19		: std_logic;
signal s1_xor_result_4_19		: std_logic;
signal s1_xor_result_5_19		: std_logic;
signal s1_xor_result_6_19		: std_logic;
signal s1_xor_result_7_19		: std_logic;
signal s3_xor_result_0_19		: std_logic;
signal s3_xor_result_1_19		: std_logic;
signal s3_xor_result_2_19		: std_logic;
signal s3_xor_result_3_19		: std_logic;
signal s3_xor_result_4_19		: std_logic;
signal s3_xor_result_5_19		: std_logic;
signal s3_xor_result_6_19		: std_logic;
signal s3_xor_result_7_19		: std_logic;
signal hard_input_20      		: std_logic_vector(data_length downto 0);
--------------------------------------------------------------------------------------------
-- CLK 21
signal soft_input_21			: input_data_array(data_length downto 0);
signal s1_xor_result_0_20		: std_logic;
signal s1_xor_result_1_20		: std_logic;
signal s1_xor_result_2_20		: std_logic;
signal s1_xor_result_3_20		: std_logic;
signal s1_xor_result_4_20		: std_logic;
signal s1_xor_result_5_20		: std_logic;
signal s1_xor_result_6_20		: std_logic;
signal s1_xor_result_7_20		: std_logic;
signal s3_xor_result_0_20		: std_logic;
signal s3_xor_result_1_20		: std_logic;
signal s3_xor_result_2_20		: std_logic;
signal s3_xor_result_3_20		: std_logic;
signal s3_xor_result_4_20		: std_logic;
signal s3_xor_result_5_20		: std_logic;
signal s3_xor_result_6_20		: std_logic;
signal s3_xor_result_7_20		: std_logic;
signal hard_input_21      		: std_logic_vector(data_length downto 0);
--------------------------------------------------------------------------------------------
-- CLK 22
signal soft_output_f			: input_data_array(data_length downto 0); 
signal s1_f						: std_logic_vector(7 downto 0);						
signal s3_f						: std_logic_vector(7 downto 0);
signal hard_output_f      		: std_logic_vector(data_length downto 0);

begin
------------------------------------------------------------------------------------------------------------
-- Define processes : (CLK 0)
------------------------------------------------------------------------------------------------------------
process(clk, reset)
begin
	if (reset = '1') then
		hard_input_in 	<= (others => '0');
		soft_input_in	<= (others => (others => '0'));
    elsif (rising_edge(clk)) then   
		hard_input_in 	<= hard_input;
		soft_input_in	<= soft_input;
	end if;
end process;
------------------------------------------------------------------------------------------------------------
-- Define processes : (CLK 1)
------------------------------------------------------------------------------------------------------------
process(clk, reset)
begin
	if (reset = '1') then
		s1_xor_result_0	<= '0';	-- xor result of the 0th bit for syndrome s1
		s1_xor_result_1	<= '0';
		s1_xor_result_2	<= '0';
		s1_xor_result_3	<= '0';
		s1_xor_result_4	<= '0';
		s1_xor_result_5	<= '0';
		s1_xor_result_6	<= '0';
		s1_xor_result_7	<= '0';
		s3_xor_result_0	<= '0';	-- xor result of the 0th bit for syndrome s3
		s3_xor_result_1	<= '0';
		s3_xor_result_2	<= '0';
		s3_xor_result_3	<= '0';
		s3_xor_result_4	<= '0';
		s3_xor_result_5	<= '0';
		s3_xor_result_6	<= '0';
		s3_xor_result_7	<= '0';
		hard_input_1    <= (others => '0');
		soft_input_1    <= (others => (others => '0'));
    elsif (rising_edge(clk)) then   
		soft_input_1	<= soft_input_in; 
		s1_xor_result_0 <= hard_input_in(1) xor hard_input_in(2) xor hard_input_in(6) xor hard_input_in(7)  xor hard_input_in(8)  xor hard_input_in(9)  xor hard_input_in(11) xor hard_input_in(16); -- xor 8 bits each clock cycle 
		s1_xor_result_1	<= hard_input_in(0) xor hard_input_in(1) xor hard_input_in(5) xor hard_input_in(6)  xor hard_input_in(7)  xor hard_input_in(8)  xor hard_input_in(10) xor hard_input_in(15);
		s1_xor_result_2	<= hard_input_in(0) xor hard_input_in(1) xor hard_input_in(2) xor hard_input_in(4)  xor hard_input_in(5)  xor hard_input_in(8)  xor hard_input_in(11) xor hard_input_in(14);
		s1_xor_result_3	<= hard_input_in(0) xor hard_input_in(2) xor hard_input_in(3) xor hard_input_in(4)  xor hard_input_in(6)  xor hard_input_in(8)  xor hard_input_in(9)  xor hard_input_in(10);
		s1_xor_result_4	<= hard_input_in(3) xor hard_input_in(5) xor hard_input_in(6) xor hard_input_in(10) xor hard_input_in(11) xor hard_input_in(12) xor hard_input_in(13) xor hard_input_in(15);
		s1_xor_result_5	<= hard_input_in(2) xor hard_input_in(4) xor hard_input_in(5) xor hard_input_in(9)  xor hard_input_in(10) xor hard_input_in(11) xor hard_input_in(12) xor hard_input_in(14);
		s1_xor_result_6	<= hard_input_in(1) xor hard_input_in(3) xor hard_input_in(4) xor hard_input_in(8)  xor hard_input_in(9)  xor hard_input_in(10) xor hard_input_in(11) xor hard_input_in(13);
		s1_xor_result_7	<= hard_input_in(0) xor hard_input_in(2) xor hard_input_in(3) xor hard_input_in(7)  xor hard_input_in(8)  xor hard_input_in(9)  xor hard_input_in(10) xor hard_input_in(12);
		s3_xor_result_0	<= hard_input_in(0) xor hard_input_in(2) xor hard_input_in(3) xor hard_input_in(5)  xor hard_input_in(6)  xor hard_input_in(7)  xor hard_input_in(8)  xor hard_input_in(12);
		s3_xor_result_1	<= hard_input_in(1) xor hard_input_in(2) xor hard_input_in(5) xor hard_input_in(6)  xor hard_input_in(10) xor hard_input_in(11) xor hard_input_in(12) xor hard_input_in(13);
		s3_xor_result_2	<= hard_input_in(0) xor hard_input_in(1) xor hard_input_in(2) xor hard_input_in(3)  xor hard_input_in(4)  xor hard_input_in(7)  xor hard_input_in(8)  xor hard_input_in(9) ;
		s3_xor_result_3	<= hard_input_in(0) xor hard_input_in(2) xor hard_input_in(3) xor hard_input_in(4)  xor hard_input_in(5)  xor hard_input_in(6)  xor hard_input_in(8)  xor hard_input_in(10);
		s3_xor_result_4	<= hard_input_in(1) xor hard_input_in(3) xor hard_input_in(6) xor hard_input_in(7)  xor hard_input_in(8)  xor hard_input_in(11) xor hard_input_in(13) xor hard_input_in(14);
		s3_xor_result_5	<= hard_input_in(0) xor hard_input_in(1) xor hard_input_in(3) xor hard_input_in(4)  xor hard_input_in(6)  xor hard_input_in(7)  xor hard_input_in(8)  xor hard_input_in(9) ;
		s3_xor_result_6	<= hard_input_in(2) xor hard_input_in(3) xor hard_input_in(6) xor hard_input_in(7)  xor hard_input_in(11) xor hard_input_in(12) xor hard_input_in(13) xor hard_input_in(14);
		s3_xor_result_7	<= hard_input_in(0) xor hard_input_in(2) xor hard_input_in(5) xor hard_input_in(6)  xor hard_input_in(7)  xor hard_input_in(10) xor hard_input_in(12) xor hard_input_in(13);
		hard_input_1    <= hard_input_in;																																	  -- passing the input down to next clock cycle
	end if;
end process;
------------------------------------------------------------------------------------------------------------
-- Define processes : (CLK 2)
------------------------------------------------------------------------------------------------------------
process(clk, reset)
begin
	if (reset = '1') then
		s1_xor_result_0_1 <= '0';
        s1_xor_result_1_1 <= '0';
        s1_xor_result_2_1 <= '0';
        s1_xor_result_3_1 <= '0';
        s1_xor_result_4_1 <= '0';
        s1_xor_result_5_1 <= '0';
        s1_xor_result_6_1 <= '0';
        s1_xor_result_7_1 <= '0';
		s3_xor_result_0_1 <= '0';
        s3_xor_result_1_1 <= '0';
        s3_xor_result_2_1 <= '0';
        s3_xor_result_3_1 <= '0';
        s3_xor_result_4_1 <= '0';
        s3_xor_result_5_1 <= '0';
        s3_xor_result_6_1 <= '0';
        s3_xor_result_7_1 <= '0';
		hard_input_2      <= (others => '0');
		soft_input_2      <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
		soft_input_2	  <= soft_input_1;
		s1_xor_result_0_1 <= s1_xor_result_0 xor hard_input_1(17) xor hard_input_1(18) xor hard_input_1(19) xor hard_input_1(20) xor hard_input_1(21) xor hard_input_1(22) xor hard_input_1(23);
		s1_xor_result_1_1 <= s1_xor_result_1 xor hard_input_1(16) xor hard_input_1(17) xor hard_input_1(18) xor hard_input_1(19) xor hard_input_1(20) xor hard_input_1(21) xor hard_input_1(22);
		s1_xor_result_2_1 <= s1_xor_result_2 xor hard_input_1(15) xor hard_input_1(22) xor hard_input_1(23) xor hard_input_1(24) xor hard_input_1(26) xor hard_input_1(29) xor hard_input_1(33); 
		s1_xor_result_3_1 <= s1_xor_result_3 xor hard_input_1(11) xor hard_input_1(13) xor hard_input_1(14) xor hard_input_1(16) xor hard_input_1(17) xor hard_input_1(18) xor hard_input_1(19);
		s1_xor_result_4_1 <= s1_xor_result_4 xor hard_input_1(20) xor hard_input_1(21) xor hard_input_1(22) xor hard_input_1(23) xor hard_input_1(24) xor hard_input_1(25) xor hard_input_1(26);
		s1_xor_result_5_1 <= s1_xor_result_5 xor hard_input_1(19) xor hard_input_1(20) xor hard_input_1(21) xor hard_input_1(22) xor hard_input_1(23) xor hard_input_1(24) xor hard_input_1(25);
		s1_xor_result_6_1 <= s1_xor_result_6 xor hard_input_1(18) xor hard_input_1(19) xor hard_input_1(20) xor hard_input_1(21) xor hard_input_1(22) xor hard_input_1(23) xor hard_input_1(24);
		s1_xor_result_7_1 <= s1_xor_result_7 xor hard_input_1(17) xor hard_input_1(18) xor hard_input_1(19) xor hard_input_1(20) xor hard_input_1(21) xor hard_input_1(22) xor hard_input_1(23);
		s3_xor_result_0_1 <= s3_xor_result_0 xor hard_input_1(14) xor hard_input_1(16) xor hard_input_1(18) xor hard_input_1(21) xor hard_input_1(25) xor hard_input_1(26) xor hard_input_1(27);
		s3_xor_result_1_1 <= s3_xor_result_1 xor hard_input_1(15) xor hard_input_1(18) xor hard_input_1(20) xor hard_input_1(21) xor hard_input_1(22) xor hard_input_1(24) xor hard_input_1(25);
		s3_xor_result_2_1 <= s3_xor_result_2 xor hard_input_1(11) xor hard_input_1(15) xor hard_input_1(16) xor hard_input_1(18) xor hard_input_1(19) xor hard_input_1(21) xor hard_input_1(22);
		s3_xor_result_3_1 <= s3_xor_result_3 xor hard_input_1(14) xor hard_input_1(16) xor hard_input_1(17) xor hard_input_1(22) xor hard_input_1(25) xor hard_input_1(28) xor hard_input_1(30);
		s3_xor_result_4_1 <= s3_xor_result_4 xor hard_input_1(16) xor hard_input_1(17) xor hard_input_1(21) xor hard_input_1(24) xor hard_input_1(25) xor hard_input_1(26) xor hard_input_1(27);
		s3_xor_result_5_1 <= s3_xor_result_5 xor hard_input_1(13) xor hard_input_1(15) xor hard_input_1(17) xor hard_input_1(19) xor hard_input_1(22) xor hard_input_1(26) xor hard_input_1(27);
		s3_xor_result_6_1 <= s3_xor_result_6 xor hard_input_1(16) xor hard_input_1(19) xor hard_input_1(21) xor hard_input_1(22) xor hard_input_1(23) xor hard_input_1(25) xor hard_input_1(26);
		s3_xor_result_7_1 <= s3_xor_result_7 xor hard_input_1(15) xor hard_input_1(16) xor hard_input_1(20) xor hard_input_1(23) xor hard_input_1(24) xor hard_input_1(25) xor hard_input_1(26);
		hard_input_2      <= hard_input_1;
	end if;
end process;
------------------------------------------------------------------------------------------------------------
-- Define processes : (CLK 3)
------------------------------------------------------------------------------------------------------------
process(clk, reset)
begin
	if (reset = '1') then
		s1_xor_result_0_2 <= '0';
        s1_xor_result_1_2 <= '0';
        s1_xor_result_2_2 <= '0';
        s1_xor_result_3_2 <= '0';
        s1_xor_result_4_2 <= '0';
        s1_xor_result_5_2 <= '0';
        s1_xor_result_6_2 <= '0';
        s1_xor_result_7_2 <= '0';
		s3_xor_result_0_2 <= '0';
        s3_xor_result_1_2 <= '0';
        s3_xor_result_2_2 <= '0';
        s3_xor_result_3_2 <= '0';
        s3_xor_result_4_2 <= '0';
        s3_xor_result_5_2 <= '0';
        s3_xor_result_6_2 <= '0';
        s3_xor_result_7_2 <= '0';
		hard_input_3      <= (others => '0');
		soft_input_3      <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
		soft_input_3	  <= soft_input_2;
		s1_xor_result_0_2 <= s1_xor_result_0_1 xor hard_input_2(26) xor hard_input_2(31) xor hard_input_2(33) xor hard_input_2(36) xor hard_input_2(37) xor hard_input_2(38) xor hard_input_2(39); 
		s1_xor_result_1_2 <= s1_xor_result_1_1 xor hard_input_2(25) xor hard_input_2(30) xor hard_input_2(32) xor hard_input_2(35) xor hard_input_2(36) xor hard_input_2(37) xor hard_input_2(38);
		s1_xor_result_2_2 <= s1_xor_result_2_1 xor hard_input_2(34) xor hard_input_2(35) xor hard_input_2(39) xor hard_input_2(47) xor hard_input_2(49) xor hard_input_2(50) xor hard_input_2(54);
		s1_xor_result_3_2 <= s1_xor_result_3_1 xor hard_input_2(20) xor hard_input_2(25) xor hard_input_2(26) xor hard_input_2(28) xor hard_input_2(31) xor hard_input_2(32) xor hard_input_2(34);
		s1_xor_result_4_2 <= s1_xor_result_4_1 xor hard_input_2(27) xor hard_input_2(30) xor hard_input_2(35) xor hard_input_2(37) xor hard_input_2(40) xor hard_input_2(41) xor hard_input_2(42);
		s1_xor_result_5_2 <= s1_xor_result_5_1 xor hard_input_2(26) xor hard_input_2(29) xor hard_input_2(34) xor hard_input_2(36) xor hard_input_2(39) xor hard_input_2(40) xor hard_input_2(41);
		s1_xor_result_6_2 <= s1_xor_result_6_1 xor hard_input_2(25) xor hard_input_2(28) xor hard_input_2(33) xor hard_input_2(35) xor hard_input_2(38) xor hard_input_2(39) xor hard_input_2(40);
		s1_xor_result_7_2 <= s1_xor_result_7_1 xor hard_input_2(24) xor hard_input_2(27) xor hard_input_2(32) xor hard_input_2(34) xor hard_input_2(37) xor hard_input_2(38) xor hard_input_2(39);
		s3_xor_result_0_2 <= s3_xor_result_0_1 xor hard_input_2(29) xor hard_input_2(30) xor hard_input_2(31) xor hard_input_2(34) xor hard_input_2(35) xor hard_input_2(37) xor hard_input_2(38);
		s3_xor_result_1_2 <= s3_xor_result_1_1 xor hard_input_2(27) xor hard_input_2(30) xor hard_input_2(31) xor hard_input_2(33) xor hard_input_2(41) xor hard_input_2(42) xor hard_input_2(44);
		s3_xor_result_2_2 <= s3_xor_result_2_1 xor hard_input_2(23) xor hard_input_2(24) xor hard_input_2(28) xor hard_input_2(30) xor hard_input_2(32) xor hard_input_2(34) xor hard_input_2(37);
		s3_xor_result_3_2 <= s3_xor_result_3_1 xor hard_input_2(35) xor hard_input_2(36) xor hard_input_2(39) xor hard_input_2(40) xor hard_input_2(44) xor hard_input_2(45) xor hard_input_2(46);
		s3_xor_result_4_2 <= s3_xor_result_4_1 xor hard_input_2(28) xor hard_input_2(29) xor hard_input_2(30) xor hard_input_2(31) xor hard_input_2(33) xor hard_input_2(34) xor hard_input_2(37);
		s3_xor_result_5_2 <= s3_xor_result_5_1 xor hard_input_2(28) xor hard_input_2(30) xor hard_input_2(31) xor hard_input_2(32) xor hard_input_2(35) xor hard_input_2(36) xor hard_input_2(38);
		s3_xor_result_6_2 <= s3_xor_result_6_1 xor hard_input_2(28) xor hard_input_2(31) xor hard_input_2(32) xor hard_input_2(34) xor hard_input_2(42) xor hard_input_2(43) xor hard_input_2(45);
		s3_xor_result_7_2 <= s3_xor_result_7_1 xor hard_input_2(27) xor hard_input_2(28) xor hard_input_2(29) xor hard_input_2(30) xor hard_input_2(32) xor hard_input_2(33) xor hard_input_2(36);
		hard_input_3      <= hard_input_2;
	end if;
end process;
------------------------------------------------------------------------------------------------------------
-- Define processes : (CLK 4)
------------------------------------------------------------------------------------------------------------
process(clk, reset)
begin
	if (reset = '1') then
		s1_xor_result_0_3 <= '0';
        s1_xor_result_1_3 <= '0';
        s1_xor_result_2_3 <= '0';
        s1_xor_result_3_3 <= '0';
        s1_xor_result_4_3 <= '0';
        s1_xor_result_5_3 <= '0';
        s1_xor_result_6_3 <= '0';
        s1_xor_result_7_3 <= '0';
		s3_xor_result_0_3 <= '0';
        s3_xor_result_1_3 <= '0';
        s3_xor_result_2_3 <= '0';
        s3_xor_result_3_3 <= '0';
        s3_xor_result_4_3 <= '0';
        s3_xor_result_5_3 <= '0';
        s3_xor_result_6_3 <= '0';
        s3_xor_result_7_3 <= '0';
		soft_input_4      <= (others => (others => '0'));
		hard_input_4      <= (others => '0');
    elsif (rising_edge(clk)) then
		soft_input_4	  <= soft_input_3;
		s1_xor_result_0_3 <= s1_xor_result_0_2 xor hard_input_3(40) xor hard_input_3(42) xor hard_input_3(44) xor hard_input_3(46) xor hard_input_3(48) xor hard_input_3(49) xor hard_input_3(50);
		s1_xor_result_1_3 <= s1_xor_result_1_2 xor hard_input_3(39) xor hard_input_3(41) xor hard_input_3(43) xor hard_input_3(45) xor hard_input_3(47) xor hard_input_3(48) xor hard_input_3(49); 
		s1_xor_result_2_3 <= s1_xor_result_2_2 xor hard_input_3(55) xor hard_input_3(56) xor hard_input_3(57) xor hard_input_3(59) xor hard_input_3(64) xor hard_input_3(65) xor hard_input_3(66);
		s1_xor_result_3_3 <= s1_xor_result_3_2 xor hard_input_3(36) xor hard_input_3(37) xor hard_input_3(39) xor hard_input_3(40) xor hard_input_3(42) xor hard_input_3(44) xor hard_input_3(50);
		s1_xor_result_4_3 <= s1_xor_result_4_2 xor hard_input_3(43) xor hard_input_3(44) xor hard_input_3(46) xor hard_input_3(48) xor hard_input_3(50) xor hard_input_3(52) xor hard_input_3(53);
		s1_xor_result_5_3 <= s1_xor_result_5_2 xor hard_input_3(42) xor hard_input_3(43) xor hard_input_3(45) xor hard_input_3(47) xor hard_input_3(49) xor hard_input_3(51) xor hard_input_3(52);
		s1_xor_result_6_3 <= s1_xor_result_6_2 xor hard_input_3(41) xor hard_input_3(42) xor hard_input_3(44) xor hard_input_3(46) xor hard_input_3(48) xor hard_input_3(50) xor hard_input_3(51);
		s1_xor_result_7_3 <= s1_xor_result_7_2 xor hard_input_3(40) xor hard_input_3(41) xor hard_input_3(43) xor hard_input_3(45) xor hard_input_3(47) xor hard_input_3(49) xor hard_input_3(50);
		s3_xor_result_0_3 <= s3_xor_result_0_2 xor hard_input_3(39) xor hard_input_3(41) xor hard_input_3(43) xor hard_input_3(44) xor hard_input_3(45) xor hard_input_3(52) xor hard_input_3(54);
		s3_xor_result_1_3 <= s3_xor_result_1_2 xor hard_input_3(46) xor hard_input_3(47) xor hard_input_3(49) xor hard_input_3(51) xor hard_input_3(53) xor hard_input_3(54) xor hard_input_3(55);
		s3_xor_result_2_3 <= s3_xor_result_2_2 xor hard_input_3(41) xor hard_input_3(42) xor hard_input_3(43) xor hard_input_3(45) xor hard_input_3(46) xor hard_input_3(47) xor hard_input_3(50);
		s3_xor_result_3_3 <= s3_xor_result_3_2 xor hard_input_3(47) xor hard_input_3(49) xor hard_input_3(52) xor hard_input_3(54) xor hard_input_3(55) xor hard_input_3(56) xor hard_input_3(58);
		s3_xor_result_4_3 <= s3_xor_result_4_2 xor hard_input_3(40) xor hard_input_3(41) xor hard_input_3(44) xor hard_input_3(46) xor hard_input_3(48) xor hard_input_3(49) xor hard_input_3(52);
		s3_xor_result_5_3 <= s3_xor_result_5_2 xor hard_input_3(39) xor hard_input_3(40) xor hard_input_3(42) xor hard_input_3(44) xor hard_input_3(45) xor hard_input_3(46) xor hard_input_3(53);
		s3_xor_result_6_3 <= s3_xor_result_6_2 xor hard_input_3(47) xor hard_input_3(48) xor hard_input_3(50) xor hard_input_3(52) xor hard_input_3(54) xor hard_input_3(55) xor hard_input_3(56);
		s3_xor_result_7_3 <= s3_xor_result_7_2 xor hard_input_3(39) xor hard_input_3(40) xor hard_input_3(43) xor hard_input_3(45) xor hard_input_3(47) xor hard_input_3(48) xor hard_input_3(51);		
		hard_input_4      <= hard_input_3;
	end if;
end process;
------------------------------------------------------------------------------------------------------------
-- Define processes : (CLK 5)
------------------------------------------------------------------------------------------------------------
process(clk, reset)
begin
	if (reset = '1') then
		s1_xor_result_0_4 <= '0';
        s1_xor_result_1_4 <= '0';
        s1_xor_result_2_4 <= '0';
        s1_xor_result_3_4 <= '0';
        s1_xor_result_4_4 <= '0';
        s1_xor_result_5_4 <= '0';
        s1_xor_result_6_4 <= '0';
        s1_xor_result_7_4 <= '0';
		s3_xor_result_0_4 <= '0';
        s3_xor_result_1_4 <= '0';
        s3_xor_result_2_4 <= '0';
        s3_xor_result_3_4 <= '0';
        s3_xor_result_4_4 <= '0';
        s3_xor_result_5_4 <= '0';
        s3_xor_result_6_4 <= '0';
        s3_xor_result_7_4 <= '0';
		hard_input_5      <= (others => '0');
		soft_input_5      <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
		soft_input_5	  <= soft_input_4;
		s1_xor_result_0_4 <= s1_xor_result_0_3 xor hard_input_4(56) xor hard_input_4(57) xor hard_input_4(61) xor hard_input_4(63) xor hard_input_4(65) xor hard_input_4(66) xor hard_input_4(69);
		s1_xor_result_1_4 <= s1_xor_result_1_3 xor hard_input_4(55) xor hard_input_4(56) xor hard_input_4(60) xor hard_input_4(62) xor hard_input_4(64) xor hard_input_4(65) xor hard_input_4(68);
		s1_xor_result_2_4 <= s1_xor_result_2_3 xor hard_input_4(67) xor hard_input_4(68) xor hard_input_4(69) xor hard_input_4(70) xor hard_input_4(71) xor hard_input_4(74) xor hard_input_4(79);
		s1_xor_result_3_4 <= s1_xor_result_3_3 xor hard_input_4(53) xor hard_input_4(54) xor hard_input_4(55) xor hard_input_4(57) xor hard_input_4(58) xor hard_input_4(61) xor hard_input_4(64);
		s1_xor_result_4_4 <= s1_xor_result_4_3 xor hard_input_4(54) xor hard_input_4(60) xor hard_input_4(61) xor hard_input_4(65) xor hard_input_4(67) xor hard_input_4(69) xor hard_input_4(70);
		s1_xor_result_5_4 <= s1_xor_result_5_3 xor hard_input_4(53) xor hard_input_4(59) xor hard_input_4(60) xor hard_input_4(64) xor hard_input_4(66) xor hard_input_4(68) xor hard_input_4(69);
		s1_xor_result_6_4 <= s1_xor_result_6_3 xor hard_input_4(52) xor hard_input_4(58) xor hard_input_4(59) xor hard_input_4(63) xor hard_input_4(65) xor hard_input_4(67) xor hard_input_4(68);
		s1_xor_result_7_4 <= s1_xor_result_7_3 xor hard_input_4(51) xor hard_input_4(57) xor hard_input_4(58) xor hard_input_4(62) xor hard_input_4(64) xor hard_input_4(66) xor hard_input_4(67);
		s3_xor_result_0_4 <= s3_xor_result_0_3 xor hard_input_4(55) xor hard_input_4(56) xor hard_input_4(57) xor hard_input_4(59) xor hard_input_4(60) xor hard_input_4(61) xor hard_input_4(62);
		s3_xor_result_1_4 <= s3_xor_result_1_3 xor hard_input_4(56) xor hard_input_4(57) xor hard_input_4(59) xor hard_input_4(61) xor hard_input_4(65) xor hard_input_4(67) xor hard_input_4(68);
		s3_xor_result_2_4 <= s3_xor_result_2_3 xor hard_input_4(51) xor hard_input_4(53) xor hard_input_4(54) xor hard_input_4(55) xor hard_input_4(57) xor hard_input_4(59) xor hard_input_4(60);
		s3_xor_result_3_4 <= s3_xor_result_3_3 xor hard_input_4(59) xor hard_input_4(61) xor hard_input_4(64) xor hard_input_4(65) xor hard_input_4(67) xor hard_input_4(75) xor hard_input_4(76);
		s3_xor_result_4_4 <= s3_xor_result_4_3 xor hard_input_4(53) xor hard_input_4(54) xor hard_input_4(55) xor hard_input_4(58) xor hard_input_4(64) xor hard_input_4(65) xor hard_input_4(66);
		s3_xor_result_5_4 <= s3_xor_result_5_3 xor hard_input_4(55) xor hard_input_4(56) xor hard_input_4(57) xor hard_input_4(58) xor hard_input_4(60) xor hard_input_4(61) xor hard_input_4(62);
		s3_xor_result_6_4 <= s3_xor_result_6_3 xor hard_input_4(57) xor hard_input_4(58) xor hard_input_4(60) xor hard_input_4(62) xor hard_input_4(66) xor hard_input_4(68) xor hard_input_4(69);
		s3_xor_result_7_4 <= s3_xor_result_7_3 xor hard_input_4(52) xor hard_input_4(53) xor hard_input_4(54) xor hard_input_4(57) xor hard_input_4(63) xor hard_input_4(64) xor hard_input_4(65);
		hard_input_5      <= hard_input_4;
	end if;
end process;
------------------------------------------------------------------------------------------------------------
-- Define processes : (CLK 6)
------------------------------------------------------------------------------------------------------------
process(clk, reset)
begin
	if (reset = '1') then
		s1_xor_result_0_5 <= '0';
        s1_xor_result_1_5 <= '0';
        s1_xor_result_2_5 <= '0';
        s1_xor_result_3_5 <= '0';
        s1_xor_result_4_5 <= '0';
        s1_xor_result_5_5 <= '0';
        s1_xor_result_6_5 <= '0';
        s1_xor_result_7_5 <= '0';
		s3_xor_result_0_5 <= '0';
        s3_xor_result_1_5 <= '0';
        s3_xor_result_2_5 <= '0';
        s3_xor_result_3_5 <= '0';
        s3_xor_result_4_5 <= '0';
        s3_xor_result_5_5 <= '0';
        s3_xor_result_6_5 <= '0';
        s3_xor_result_7_5 <= '0';
		hard_input_6      <= (others => '0');
		soft_input_6      <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
		soft_input_6	  <= soft_input_5;
		s1_xor_result_0_5 <= s1_xor_result_0_4 xor hard_input_5(70) xor hard_input_5(73) xor hard_input_5(75) xor hard_input_5(76) xor hard_input_5(77) xor hard_input_5(78) xor hard_input_5(79);
		s1_xor_result_1_5 <= s1_xor_result_1_4 xor hard_input_5(69) xor hard_input_5(72) xor hard_input_5(74) xor hard_input_5(75) xor hard_input_5(76) xor hard_input_5(77) xor hard_input_5(78);
		s1_xor_result_2_5 <= s1_xor_result_2_4 xor hard_input_5(81) xor hard_input_5(84) xor hard_input_5(85) xor hard_input_5(86) xor hard_input_5(87) xor hard_input_5(88) xor hard_input_5(90);
		s1_xor_result_3_5 <= s1_xor_result_3_4 xor hard_input_5(67) xor hard_input_5(68) xor hard_input_5(75) xor hard_input_5(76) xor hard_input_5(77) xor hard_input_5(79) xor hard_input_5(82);
		s1_xor_result_4_5 <= s1_xor_result_4_4 xor hard_input_5(73) xor hard_input_5(74) xor hard_input_5(77) xor hard_input_5(79) xor hard_input_5(80) xor hard_input_5(81) xor hard_input_5(82);
		s1_xor_result_5_5 <= s1_xor_result_5_4 xor hard_input_5(72) xor hard_input_5(73) xor hard_input_5(76) xor hard_input_5(78) xor hard_input_5(79) xor hard_input_5(80) xor hard_input_5(81);
		s1_xor_result_6_5 <= s1_xor_result_6_4 xor hard_input_5(71) xor hard_input_5(72) xor hard_input_5(75) xor hard_input_5(77) xor hard_input_5(78) xor hard_input_5(79) xor hard_input_5(80);
		s1_xor_result_7_5 <= s1_xor_result_7_4 xor hard_input_5(70) xor hard_input_5(71) xor hard_input_5(74) xor hard_input_5(76) xor hard_input_5(77) xor hard_input_5(78) xor hard_input_5(79);
		s3_xor_result_0_5 <= s3_xor_result_0_4 xor hard_input_5(63) xor hard_input_5(64) xor hard_input_5(69) xor hard_input_5(70) xor hard_input_5(71) xor hard_input_5(72) xor hard_input_5(73);
		s3_xor_result_1_5 <= s3_xor_result_1_4 xor hard_input_5(73) xor hard_input_5(76) xor hard_input_5(79) xor hard_input_5(81) xor hard_input_5(86) xor hard_input_5(87) xor hard_input_5(90);
		s3_xor_result_2_5 <= s3_xor_result_2_4 xor hard_input_5(61) xor hard_input_5(68) xor hard_input_5(70) xor hard_input_5(71) xor hard_input_5(72) xor hard_input_5(73) xor hard_input_5(75);
		s3_xor_result_3_5 <= s3_xor_result_3_4 xor hard_input_5(78) xor hard_input_5(80) xor hard_input_5(81) xor hard_input_5(83) xor hard_input_5(85) xor hard_input_5(87) xor hard_input_5(88);
		s3_xor_result_4_5 <= s3_xor_result_4_4 xor hard_input_5(70) xor hard_input_5(71) xor hard_input_5(77) xor hard_input_5(81) xor hard_input_5(86) xor hard_input_5(88) xor hard_input_5(91);
		s3_xor_result_5_5 <= s3_xor_result_5_4 xor hard_input_5(63) xor hard_input_5(64) xor hard_input_5(65) xor hard_input_5(70) xor hard_input_5(71) xor hard_input_5(72) xor hard_input_5(73);
		s3_xor_result_6_5 <= s3_xor_result_6_4 xor hard_input_5(74) xor hard_input_5(77) xor hard_input_5(80) xor hard_input_5(82) xor hard_input_5(87) xor hard_input_5(88) xor hard_input_5(91);
		s3_xor_result_7_5 <= s3_xor_result_7_4 xor hard_input_5(69) xor hard_input_5(70) xor hard_input_5(76) xor hard_input_5(80) xor hard_input_5(85) xor hard_input_5(87) xor hard_input_5(90);
		hard_input_6      <= hard_input_5;
	end if;
end process;
------------------------------------------------------------------------------------------------------------
-- Define processes : (CLK 7)
------------------------------------------------------------------------------------------------------------
process(clk, reset)
begin
	if (reset = '1') then
		s1_xor_result_0_6 <= '0';
        s1_xor_result_1_6 <= '0';
        s1_xor_result_2_6 <= '0';
        s1_xor_result_3_6 <= '0';
        s1_xor_result_4_6 <= '0';
        s1_xor_result_5_6 <= '0';
        s1_xor_result_6_6 <= '0';
        s1_xor_result_7_6 <= '0';
		s3_xor_result_0_6 <= '0';
        s3_xor_result_1_6 <= '0';
        s3_xor_result_2_6 <= '0';
        s3_xor_result_3_6 <= '0';
        s3_xor_result_4_6 <= '0';
        s3_xor_result_5_6 <= '0';
        s3_xor_result_6_6 <= '0';
        s3_xor_result_7_6 <= '0';
		hard_input_7      <= (others => '0');
		soft_input_7      <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
		soft_input_7	  <= soft_input_6;
		s1_xor_result_0_6 <= s1_xor_result_0_5 xor hard_input_6(80) xor hard_input_6(82) xor hard_input_6(83) xor hard_input_6(84) xor hard_input_6(85)  xor hard_input_6(88)  xor hard_input_6(89);
		s1_xor_result_1_6 <= s1_xor_result_1_5 xor hard_input_6(79) xor hard_input_6(81) xor hard_input_6(82) xor hard_input_6(83) xor hard_input_6(84)  xor hard_input_6(87)  xor hard_input_6(88);
		s1_xor_result_2_6 <= s1_xor_result_2_5 xor hard_input_6(92) xor hard_input_6(94) xor hard_input_6(96) xor hard_input_6(97) xor hard_input_6(98)  xor hard_input_6(104) xor hard_input_6(105);
		s1_xor_result_3_6 <= s1_xor_result_3_5 xor hard_input_6(86) xor hard_input_6(87) xor hard_input_6(88) xor hard_input_6(92) xor hard_input_6(100) xor hard_input_6(102) xor hard_input_6(103);
		s1_xor_result_4_6 <= s1_xor_result_4_5 xor hard_input_6(83) xor hard_input_6(84) xor hard_input_6(86) xor hard_input_6(87) xor hard_input_6(88)  xor hard_input_6(89)  xor hard_input_6(92);
		s1_xor_result_5_6 <= s1_xor_result_5_5 xor hard_input_6(82) xor hard_input_6(83) xor hard_input_6(85) xor hard_input_6(86) xor hard_input_6(87)  xor hard_input_6(88)  xor hard_input_6(91);
		s1_xor_result_6_6 <= s1_xor_result_6_5 xor hard_input_6(81) xor hard_input_6(82) xor hard_input_6(84) xor hard_input_6(85) xor hard_input_6(86)  xor hard_input_6(87)  xor hard_input_6(90);
		s1_xor_result_7_6 <= s1_xor_result_7_5 xor hard_input_6(80) xor hard_input_6(81) xor hard_input_6(83) xor hard_input_6(84) xor hard_input_6(85)  xor hard_input_6(86)  xor hard_input_6(89);
		s3_xor_result_0_6 <= s3_xor_result_0_5 xor hard_input_6(76) xor hard_input_6(77) xor hard_input_6(78) xor hard_input_6(80) xor hard_input_6(84)  xor hard_input_6(85)  xor hard_input_6(87) ;
		s3_xor_result_1_6 <= s3_xor_result_1_5 xor hard_input_6(91) xor hard_input_6(95) xor hard_input_6(96) xor hard_input_6(97) xor hard_input_6(98)  xor hard_input_6(100) xor hard_input_6(103);
		s3_xor_result_2_6 <= s3_xor_result_2_5 xor hard_input_6(76) xor hard_input_6(77) xor hard_input_6(78) xor hard_input_6(79) xor hard_input_6(80)  xor hard_input_6(85)  xor hard_input_6(86) ;
		s3_xor_result_3_6 <= s3_xor_result_3_5 xor hard_input_6(89) xor hard_input_6(90) xor hard_input_6(91) xor hard_input_6(93) xor hard_input_6(95)  xor hard_input_6(99)  xor hard_input_6(101);
		s3_xor_result_4_6 <= s3_xor_result_4_5 xor hard_input_6(92) xor hard_input_6(93) xor hard_input_6(96) xor hard_input_6(98) xor hard_input_6(99)  xor hard_input_6(101) xor hard_input_6(102);
		s3_xor_result_5_6 <= s3_xor_result_5_5 xor hard_input_6(74) xor hard_input_6(77) xor hard_input_6(78) xor hard_input_6(79) xor hard_input_6(81)  xor hard_input_6(85)  xor hard_input_6(86) ;
		s3_xor_result_6_6 <= s3_xor_result_6_5 xor hard_input_6(92) xor hard_input_6(96) xor hard_input_6(97) xor hard_input_6(98) xor hard_input_6(99)  xor hard_input_6(101) xor hard_input_6(104);
		s3_xor_result_7_6 <= s3_xor_result_7_5 xor hard_input_6(91) xor hard_input_6(92) xor hard_input_6(95) xor hard_input_6(97) xor hard_input_6(98)  xor hard_input_6(100) xor hard_input_6(101);
		hard_input_7      <= hard_input_6;
	end if;
end process;
------------------------------------------------------------------------------------------------------------
-- Define processes : (CLK 8)
------------------------------------------------------------------------------------------------------------
process(clk, reset)
begin
	if (reset = '1') then
		s1_xor_result_0_7 <= '0';
        s1_xor_result_1_7 <= '0';
        s1_xor_result_2_7 <= '0';
        s1_xor_result_3_7 <= '0';
        s1_xor_result_4_7 <= '0';
        s1_xor_result_5_7 <= '0';
        s1_xor_result_6_7 <= '0';
        s1_xor_result_7_7 <= '0';
		s3_xor_result_0_7 <= '0';
        s3_xor_result_1_7 <= '0';
        s3_xor_result_2_7 <= '0';
        s3_xor_result_3_7 <= '0';
        s3_xor_result_4_7 <= '0';
        s3_xor_result_5_7 <= '0';
        s3_xor_result_6_7 <= '0';
        s3_xor_result_7_7 <= '0';
		hard_input_8      <= (others => '0');
		soft_input_8      <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
		soft_input_8	  <= soft_input_7;
		s1_xor_result_0_7 <= s1_xor_result_0_6 xor hard_input_7(91)  xor hard_input_7(92)  xor hard_input_7(93)  xor hard_input_7(95)  xor hard_input_7(96)  xor hard_input_7(97)  xor hard_input_7(100);
		s1_xor_result_1_7 <= s1_xor_result_1_6 xor hard_input_7(90)  xor hard_input_7(91)  xor hard_input_7(92)  xor hard_input_7(94)  xor hard_input_7(95)  xor hard_input_7(96)  xor hard_input_7(99);
		s1_xor_result_2_7 <= s1_xor_result_2_6 xor hard_input_7(109) xor hard_input_7(111) xor hard_input_7(113) xor hard_input_7(114) xor hard_input_7(117) xor hard_input_7(118) xor hard_input_7(121);
		s1_xor_result_3_7 <= s1_xor_result_3_6 xor hard_input_7(107) xor hard_input_7(108) xor hard_input_7(109) xor hard_input_7(110) xor hard_input_7(112) xor hard_input_7(117) xor hard_input_7(118);
		s1_xor_result_4_7 <= s1_xor_result_4_6 xor hard_input_7(93)  xor hard_input_7(95)  xor hard_input_7(96)  xor hard_input_7(97)  xor hard_input_7(99)  xor hard_input_7(100) xor hard_input_7(101);
		s1_xor_result_5_7 <= s1_xor_result_5_6 xor hard_input_7(92)  xor hard_input_7(94)  xor hard_input_7(95)  xor hard_input_7(96)  xor hard_input_7(98)  xor hard_input_7(99)  xor hard_input_7(100);
		s1_xor_result_6_7 <= s1_xor_result_6_6 xor hard_input_7(91)  xor hard_input_7(93)  xor hard_input_7(94)  xor hard_input_7(95)  xor hard_input_7(97)  xor hard_input_7(98)  xor hard_input_7(99);
		s1_xor_result_7_7 <= s1_xor_result_7_6 xor hard_input_7(90)  xor hard_input_7(92)  xor hard_input_7(93)  xor hard_input_7(94)  xor hard_input_7(96)  xor hard_input_7(97)  xor hard_input_7(98);
		s3_xor_result_0_7 <= s3_xor_result_0_6 xor hard_input_7(88)  xor hard_input_7(90)  xor hard_input_7(91)  xor hard_input_7(92)  xor hard_input_7(93)  xor hard_input_7(97)  xor hard_input_7(99) ;
		s3_xor_result_1_7 <= s3_xor_result_1_6 xor hard_input_7(105) xor hard_input_7(106) xor hard_input_7(107) xor hard_input_7(109) xor hard_input_7(110) xor hard_input_7(112) xor hard_input_7(115);
		s3_xor_result_2_7 <= s3_xor_result_2_6 xor hard_input_7(87)  xor hard_input_7(88)  xor hard_input_7(89)  xor hard_input_7(92)  xor hard_input_7(93)  xor hard_input_7(94)  xor hard_input_7(96) ;
		s3_xor_result_3_7 <= s3_xor_result_3_6 xor hard_input_7(102) xor hard_input_7(107) xor hard_input_7(110) xor hard_input_7(113) xor hard_input_7(115) xor hard_input_7(120) xor hard_input_7(121);
		s3_xor_result_4_7 <= s3_xor_result_4_6 xor hard_input_7(106) xor hard_input_7(109) xor hard_input_7(110) xor hard_input_7(111) xor hard_input_7(112) xor hard_input_7(113) xor hard_input_7(114);
		s3_xor_result_5_7 <= s3_xor_result_5_6 xor hard_input_7(88)  xor hard_input_7(89)  xor hard_input_7(91)  xor hard_input_7(92)  xor hard_input_7(93)  xor hard_input_7(94)  xor hard_input_7(98) ;
		s3_xor_result_6_7 <= s3_xor_result_6_6 xor hard_input_7(106) xor hard_input_7(107) xor hard_input_7(108) xor hard_input_7(110) xor hard_input_7(111) xor hard_input_7(113) xor hard_input_7(116);
		s3_xor_result_7_7 <= s3_xor_result_7_6 xor hard_input_7(105) xor hard_input_7(108) xor hard_input_7(109) xor hard_input_7(110) xor hard_input_7(111) xor hard_input_7(112) xor hard_input_7(113);
		hard_input_8      <= hard_input_7;
	end if;
end process;
------------------------------------------------------------------------------------------------------------
-- Define processes : (CLK 9)
------------------------------------------------------------------------------------------------------------
process(clk, reset)
begin
	if (reset = '1') then
		s1_xor_result_0_8 <= '0';
        s1_xor_result_1_8 <= '0';
        s1_xor_result_2_8 <= '0';
        s1_xor_result_3_8 <= '0';
        s1_xor_result_4_8 <= '0';
        s1_xor_result_5_8 <= '0';
        s1_xor_result_6_8 <= '0';
        s1_xor_result_7_8 <= '0';
		s3_xor_result_0_8 <= '0';
        s3_xor_result_1_8 <= '0';
        s3_xor_result_2_8 <= '0';
        s3_xor_result_3_8 <= '0';
        s3_xor_result_4_8 <= '0';
        s3_xor_result_5_8 <= '0';
        s3_xor_result_6_8 <= '0';
        s3_xor_result_7_8 <= '0';
		hard_input_9      <= (others => '0');
		soft_input_9      <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
		soft_input_9	  <= soft_input_8;
		s1_xor_result_0_8 <= s1_xor_result_0_7 xor hard_input_8(102) xor hard_input_8(104) xor hard_input_8(107) xor hard_input_8(109) xor hard_input_8(113) xor hard_input_8(116) xor hard_input_8(118);
		s1_xor_result_1_8 <= s1_xor_result_1_7 xor hard_input_8(101) xor hard_input_8(103) xor hard_input_8(106) xor hard_input_8(108) xor hard_input_8(112) xor hard_input_8(115) xor hard_input_8(117);
		s1_xor_result_2_8 <= s1_xor_result_2_7 xor hard_input_8(123) xor hard_input_8(124) xor hard_input_8(125) xor hard_input_8(126) xor hard_input_8(127) xor hard_input_8(128) xor hard_input_8(130);
		s1_xor_result_3_8 <= s1_xor_result_3_7 xor hard_input_8(119) xor hard_input_8(120) xor hard_input_8(121) xor hard_input_8(122) xor hard_input_8(123) xor hard_input_8(124) xor hard_input_8(127);
		s1_xor_result_4_8 <= s1_xor_result_4_7 xor hard_input_8(104) xor hard_input_8(106) xor hard_input_8(108) xor hard_input_8(111) xor hard_input_8(113) xor hard_input_8(117) xor hard_input_8(120);
		s1_xor_result_5_8 <= s1_xor_result_5_7 xor hard_input_8(103) xor hard_input_8(105) xor hard_input_8(107) xor hard_input_8(110) xor hard_input_8(112) xor hard_input_8(116) xor hard_input_8(119);
		s1_xor_result_6_8 <= s1_xor_result_6_7 xor hard_input_8(102) xor hard_input_8(104) xor hard_input_8(106) xor hard_input_8(109) xor hard_input_8(111) xor hard_input_8(115) xor hard_input_8(118);
		s1_xor_result_7_8 <= s1_xor_result_7_7 xor hard_input_8(101) xor hard_input_8(103) xor hard_input_8(105) xor hard_input_8(108) xor hard_input_8(110) xor hard_input_8(114) xor hard_input_8(117);
		s3_xor_result_0_8 <= s3_xor_result_0_7 xor hard_input_8(101) xor hard_input_8(103) xor hard_input_8(106) xor hard_input_8(110) xor hard_input_8(111) xor hard_input_8(112) xor hard_input_8(114);
		s3_xor_result_1_8 <= s3_xor_result_1_7 xor hard_input_8(116) xor hard_input_8(118) xor hard_input_8(126) xor hard_input_8(127) xor hard_input_8(129) xor hard_input_8(131) xor hard_input_8(132);
		s3_xor_result_2_8 <= s3_xor_result_2_7 xor hard_input_8(100) xor hard_input_8(101) xor hard_input_8(103) xor hard_input_8(104) xor hard_input_8(106) xor hard_input_8(107) xor hard_input_8(108);
		s3_xor_result_3_8 <= s3_xor_result_3_7 xor hard_input_8(124) xor hard_input_8(125) xor hard_input_8(129) xor hard_input_8(130) xor hard_input_8(131) xor hard_input_8(132) xor hard_input_8(134);
		s3_xor_result_4_8 <= s3_xor_result_4_7 xor hard_input_8(115) xor hard_input_8(116) xor hard_input_8(118) xor hard_input_8(119) xor hard_input_8(122) xor hard_input_8(125) xor hard_input_8(126);
		s3_xor_result_5_8 <= s3_xor_result_5_7 xor hard_input_8(100) xor hard_input_8(102) xor hard_input_8(104) xor hard_input_8(107) xor hard_input_8(111) xor hard_input_8(112) xor hard_input_8(113);
		s3_xor_result_6_8 <= s3_xor_result_6_7 xor hard_input_8(117) xor hard_input_8(119) xor hard_input_8(127) xor hard_input_8(128) xor hard_input_8(130) xor hard_input_8(132) xor hard_input_8(133);
		s3_xor_result_7_8 <= s3_xor_result_7_7 xor hard_input_8(114) xor hard_input_8(115) xor hard_input_8(117) xor hard_input_8(118) xor hard_input_8(121) xor hard_input_8(124) xor hard_input_8(125);
		hard_input_9      <= hard_input_8;
	end if;
end process;
------------------------------------------------------------------------------------------------------------
-- Define processes : (CLK 10)
------------------------------------------------------------------------------------------------------------
process(clk, reset)
begin
	if (reset = '1') then
		s1_xor_result_0_9 <= '0';
        s1_xor_result_1_9 <= '0';
        s1_xor_result_2_9 <= '0';
        s1_xor_result_3_9 <= '0';
        s1_xor_result_4_9 <= '0';
        s1_xor_result_5_9 <= '0';
        s1_xor_result_6_9 <= '0';
        s1_xor_result_7_9 <= '0';
		s3_xor_result_0_9 <= '0';
        s3_xor_result_1_9 <= '0';
        s3_xor_result_2_9 <= '0';
        s3_xor_result_3_9 <= '0';
        s3_xor_result_4_9 <= '0';
        s3_xor_result_5_9 <= '0';
        s3_xor_result_6_9 <= '0';
        s3_xor_result_7_9 <= '0';
		hard_input_10     <= (others => '0');
		soft_input_10     <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
		soft_input_10	  <= soft_input_9;
		s1_xor_result_0_9 <= s1_xor_result_0_8 xor hard_input_9(119) xor hard_input_9(121) xor hard_input_9(125) xor hard_input_9(126) xor hard_input_9(129) xor hard_input_9(130) xor hard_input_9(131);
		s1_xor_result_1_9 <= s1_xor_result_1_8 xor hard_input_9(118) xor hard_input_9(120) xor hard_input_9(124) xor hard_input_9(125) xor hard_input_9(128) xor hard_input_9(129) xor hard_input_9(130);
		s1_xor_result_2_9 <= s1_xor_result_2_8 xor hard_input_9(131) xor hard_input_9(132) xor hard_input_9(133) xor hard_input_9(136) xor hard_input_9(137) xor hard_input_9(139) xor hard_input_9(140);
		s1_xor_result_3_9 <= s1_xor_result_3_8 xor hard_input_9(132) xor hard_input_9(134) xor hard_input_9(137) xor hard_input_9(138) xor hard_input_9(139) xor hard_input_9(140) xor hard_input_9(141);
		s1_xor_result_4_9 <= s1_xor_result_4_8 xor hard_input_9(122) xor hard_input_9(123) xor hard_input_9(125) xor hard_input_9(129) xor hard_input_9(130) xor hard_input_9(133) xor hard_input_9(134);
		s1_xor_result_5_9 <= s1_xor_result_5_8 xor hard_input_9(121) xor hard_input_9(122) xor hard_input_9(124) xor hard_input_9(128) xor hard_input_9(129) xor hard_input_9(132) xor hard_input_9(133); 
		s1_xor_result_6_9 <= s1_xor_result_6_8 xor hard_input_9(120) xor hard_input_9(121) xor hard_input_9(123) xor hard_input_9(127) xor hard_input_9(128) xor hard_input_9(131) xor hard_input_9(132);
		s1_xor_result_7_9 <= s1_xor_result_7_8 xor hard_input_9(119) xor hard_input_9(120) xor hard_input_9(122) xor hard_input_9(126) xor hard_input_9(127) xor hard_input_9(130) xor hard_input_9(131);
		s3_xor_result_0_9 <= s3_xor_result_0_8 xor hard_input_9(115) xor hard_input_9(116) xor hard_input_9(119) xor hard_input_9(120) xor hard_input_9(122) xor hard_input_9(123) xor hard_input_9(124);
		s3_xor_result_1_9 <= s3_xor_result_1_8 xor hard_input_9(134) xor hard_input_9(136) xor hard_input_9(138) xor hard_input_9(139) xor hard_input_9(140) xor hard_input_9(141) xor hard_input_9(142);
		s3_xor_result_2_9 <= s3_xor_result_2_8 xor hard_input_9(109) xor hard_input_9(113) xor hard_input_9(115) xor hard_input_9(117) xor hard_input_9(119) xor hard_input_9(122) xor hard_input_9(126);
		s3_xor_result_3_9 <= s3_xor_result_3_8 xor hard_input_9(137) xor hard_input_9(139) xor hard_input_9(140) xor hard_input_9(141) xor hard_input_9(143) xor hard_input_9(144) xor hard_input_9(146);
		s3_xor_result_4_9 <= s3_xor_result_4_8 xor hard_input_9(129) xor hard_input_9(131) xor hard_input_9(133) xor hard_input_9(134) xor hard_input_9(137) xor hard_input_9(138) xor hard_input_9(139);
		s3_xor_result_5_9 <= s3_xor_result_5_8 xor hard_input_9(115) xor hard_input_9(116) xor hard_input_9(117) xor hard_input_9(120) xor hard_input_9(121) xor hard_input_9(123) xor hard_input_9(124);
		s3_xor_result_6_9 <= s3_xor_result_6_8 xor hard_input_9(135) xor hard_input_9(137) xor hard_input_9(139) xor hard_input_9(140) xor hard_input_9(141) xor hard_input_9(142) xor hard_input_9(143);
		s3_xor_result_7_9 <= s3_xor_result_7_8 xor hard_input_9(128) xor hard_input_9(130) xor hard_input_9(132) xor hard_input_9(133) xor hard_input_9(136) xor hard_input_9(137) xor hard_input_9(138);
		hard_input_10     <= hard_input_9;
	end if;
end process;
------------------------------------------------------------------------------------------------------------
-- Define processes : (CLK 11)
------------------------------------------------------------------------------------------------------------
process(clk, reset)
begin
	if (reset = '1') then
		s1_xor_result_0_10 <= '0';
        s1_xor_result_1_10 <= '0';
        s1_xor_result_2_10 <= '0';
        s1_xor_result_3_10 <= '0';
        s1_xor_result_4_10 <= '0';
        s1_xor_result_5_10 <= '0';
        s1_xor_result_6_10 <= '0';
        s1_xor_result_7_10 <= '0';
		s3_xor_result_0_10 <= '0';
        s3_xor_result_1_10 <= '0';
        s3_xor_result_2_10 <= '0';
        s3_xor_result_3_10 <= '0';
        s3_xor_result_4_10 <= '0';
        s3_xor_result_5_10 <= '0';
        s3_xor_result_6_10 <= '0';
        s3_xor_result_7_10 <= '0';
		hard_input_11      <= (others => '0');
		soft_input_11      <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
		soft_input_11	   <= soft_input_10;
		s1_xor_result_0_10 <= s1_xor_result_0_9 xor hard_input_10(134) xor hard_input_10(135) xor hard_input_10(136) xor hard_input_10(137) xor hard_input_10(141) xor hard_input_10(142) xor hard_input_10(144);
		s1_xor_result_1_10 <= s1_xor_result_1_9 xor hard_input_10(133) xor hard_input_10(134) xor hard_input_10(135) xor hard_input_10(136) xor hard_input_10(140) xor hard_input_10(141) xor hard_input_10(143);
		s1_xor_result_2_10 <= s1_xor_result_2_9 xor hard_input_10(141) xor hard_input_10(143) xor hard_input_10(144) xor hard_input_10(145) xor hard_input_10(148) xor hard_input_10(150) xor hard_input_10(152);
		s1_xor_result_3_10 <= s1_xor_result_3_9 xor hard_input_10(143) xor hard_input_10(145) xor hard_input_10(147) xor hard_input_10(149) xor hard_input_10(150) xor hard_input_10(151) xor hard_input_10(157);
		s1_xor_result_4_10 <= s1_xor_result_4_9 xor hard_input_10(135) xor hard_input_10(138) xor hard_input_10(139) xor hard_input_10(140) xor hard_input_10(141) xor hard_input_10(145) xor hard_input_10(146);
		s1_xor_result_5_10 <= s1_xor_result_5_9 xor hard_input_10(134) xor hard_input_10(137) xor hard_input_10(138) xor hard_input_10(139) xor hard_input_10(140) xor hard_input_10(144) xor hard_input_10(145);
		s1_xor_result_6_10 <= s1_xor_result_6_9 xor hard_input_10(133) xor hard_input_10(136) xor hard_input_10(137) xor hard_input_10(138) xor hard_input_10(139) xor hard_input_10(143) xor hard_input_10(144);
		s1_xor_result_7_10 <= s1_xor_result_7_9 xor hard_input_10(132) xor hard_input_10(135) xor hard_input_10(136) xor hard_input_10(137) xor hard_input_10(138) xor hard_input_10(142) xor hard_input_10(143);
		s3_xor_result_0_10 <= s3_xor_result_0_9 xor hard_input_10(126) xor hard_input_10(128) xor hard_input_10(129) xor hard_input_10(130) xor hard_input_10(137) xor hard_input_10(139) xor hard_input_10(140);
		s3_xor_result_1_10 <= s3_xor_result_1_9 xor hard_input_10(144) xor hard_input_10(146) xor hard_input_10(150) xor hard_input_10(152) xor hard_input_10(153) xor hard_input_10(158) xor hard_input_10(161);
		s3_xor_result_2_10 <= s3_xor_result_2_9 xor hard_input_10(127) xor hard_input_10(128) xor hard_input_10(130) xor hard_input_10(131) xor hard_input_10(132) xor hard_input_10(135) xor hard_input_10(136);
		s3_xor_result_3_10 <= s3_xor_result_3_9 xor hard_input_10(149) xor hard_input_10(150) xor hard_input_10(152) xor hard_input_10(160) xor hard_input_10(161) xor hard_input_10(163) xor hard_input_10(165);
		s3_xor_result_4_10 <= s3_xor_result_4_9 xor hard_input_10(140) xor hard_input_10(143) xor hard_input_10(149) xor hard_input_10(150) xor hard_input_10(151) xor hard_input_10(155) xor hard_input_10(156);
		s3_xor_result_5_10 <= s3_xor_result_5_9 xor hard_input_10(125) xor hard_input_10(127) xor hard_input_10(129) xor hard_input_10(130) xor hard_input_10(131) xor hard_input_10(138) xor hard_input_10(140);
		s3_xor_result_6_10 <= s3_xor_result_6_9 xor hard_input_10(145) xor hard_input_10(147) xor hard_input_10(151) xor hard_input_10(153) xor hard_input_10(154) xor hard_input_10(159) xor hard_input_10(162);
		s3_xor_result_7_10 <= s3_xor_result_7_9 xor hard_input_10(139) xor hard_input_10(142) xor hard_input_10(148) xor hard_input_10(149) xor hard_input_10(150) xor hard_input_10(154) xor hard_input_10(155);
		hard_input_11      <= hard_input_10;
	end if;
end process;
------------------------------------------------------------------------------------------------------------
-- Define processes : (CLK 12)
------------------------------------------------------------------------------------------------------------
process(clk, reset)
begin
	if (reset = '1') then
		s1_xor_result_0_11 <= '0';
        s1_xor_result_1_11 <= '0';
        s1_xor_result_2_11 <= '0';
        s1_xor_result_3_11 <= '0';
        s1_xor_result_4_11 <= '0';
        s1_xor_result_5_11 <= '0';
        s1_xor_result_6_11 <= '0';
        s1_xor_result_7_11 <= '0';
		s3_xor_result_0_11 <= '0';
        s3_xor_result_1_11 <= '0';
        s3_xor_result_2_11 <= '0';
        s3_xor_result_3_11 <= '0';
        s3_xor_result_4_11 <= '0';
        s3_xor_result_5_11 <= '0';
        s3_xor_result_6_11 <= '0';
        s3_xor_result_7_11 <= '0';
		hard_input_12      <= (others => '0');
		soft_input_12      <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
		soft_input_12	   <= soft_input_11;
		s1_xor_result_0_11 <= s1_xor_result_0_10 xor hard_input_11(145) xor hard_input_11(150) xor hard_input_11(154) xor hard_input_11(156) xor hard_input_11(157) xor hard_input_11(158) xor hard_input_11(160);
		s1_xor_result_1_11 <= s1_xor_result_1_10 xor hard_input_11(144) xor hard_input_11(149) xor hard_input_11(153) xor hard_input_11(155) xor hard_input_11(156) xor hard_input_11(157) xor hard_input_11(159);
		s1_xor_result_2_11 <= s1_xor_result_2_10 xor hard_input_11(155) xor hard_input_11(157) xor hard_input_11(161) xor hard_input_11(164) xor hard_input_11(166) xor hard_input_11(167) xor hard_input_11(169);
		s1_xor_result_3_11 <= s1_xor_result_3_10 xor hard_input_11(158) xor hard_input_11(162) xor hard_input_11(164) xor hard_input_11(166) xor hard_input_11(167) xor hard_input_11(170) xor hard_input_11(171);
		s1_xor_result_4_11 <= s1_xor_result_4_10 xor hard_input_11(148) xor hard_input_11(149) xor hard_input_11(154) xor hard_input_11(158) xor hard_input_11(160) xor hard_input_11(161) xor hard_input_11(162);
		s1_xor_result_5_11 <= s1_xor_result_5_10 xor hard_input_11(147) xor hard_input_11(148) xor hard_input_11(153) xor hard_input_11(157) xor hard_input_11(159) xor hard_input_11(160) xor hard_input_11(161); 
		s1_xor_result_6_11 <= s1_xor_result_6_10 xor hard_input_11(146) xor hard_input_11(147) xor hard_input_11(152) xor hard_input_11(156) xor hard_input_11(158) xor hard_input_11(159) xor hard_input_11(160);
		s1_xor_result_7_11 <= s1_xor_result_7_10 xor hard_input_11(145) xor hard_input_11(146) xor hard_input_11(151) xor hard_input_11(155) xor hard_input_11(157) xor hard_input_11(158) xor hard_input_11(159);
		s3_xor_result_0_11 <= s3_xor_result_0_10 xor hard_input_11(141) xor hard_input_11(142) xor hard_input_11(144) xor hard_input_11(145) xor hard_input_11(146) xor hard_input_11(147) xor hard_input_11(148);
		s3_xor_result_1_11 <= s3_xor_result_1_10 xor hard_input_11(164) xor hard_input_11(166) xor hard_input_11(171) xor hard_input_11(172) xor hard_input_11(175) xor hard_input_11(176) xor hard_input_11(180);
		s3_xor_result_2_11 <= s3_xor_result_2_10 xor hard_input_11(138) xor hard_input_11(139) xor hard_input_11(140) xor hard_input_11(142) xor hard_input_11(144) xor hard_input_11(145) xor hard_input_11(146);
		s3_xor_result_3_11 <= s3_xor_result_3_10 xor hard_input_11(166) xor hard_input_11(168) xor hard_input_11(170) xor hard_input_11(172) xor hard_input_11(173) xor hard_input_11(174) xor hard_input_11(175);
		s3_xor_result_4_11 <= s3_xor_result_4_10 xor hard_input_11(162) xor hard_input_11(166) xor hard_input_11(171) xor hard_input_11(173) xor hard_input_11(176) xor hard_input_11(177) xor hard_input_11(178);
		s3_xor_result_5_11 <= s3_xor_result_5_10 xor hard_input_11(141) xor hard_input_11(142) xor hard_input_11(143) xor hard_input_11(145) xor hard_input_11(146) xor hard_input_11(147) xor hard_input_11(148);
		s3_xor_result_6_11 <= s3_xor_result_6_10 xor hard_input_11(165) xor hard_input_11(167) xor hard_input_11(172) xor hard_input_11(173) xor hard_input_11(176) xor hard_input_11(177) xor hard_input_11(181);
		s3_xor_result_7_11 <= s3_xor_result_7_10 xor hard_input_11(161) xor hard_input_11(165) xor hard_input_11(170) xor hard_input_11(172) xor hard_input_11(175) xor hard_input_11(176) xor hard_input_11(177);
		hard_input_12      <= hard_input_11;
	end if;
end process;
------------------------------------------------------------------------------------------------------------
-- Define processes : (CLK 13)
------------------------------------------------------------------------------------------------------------
process(clk, reset)
begin
	if (reset = '1') then
		s1_xor_result_0_12 <= '0';
        s1_xor_result_1_12 <= '0';
        s1_xor_result_2_12 <= '0';
        s1_xor_result_3_12 <= '0';
        s1_xor_result_4_12 <= '0';
        s1_xor_result_5_12 <= '0';
        s1_xor_result_6_12 <= '0';
        s1_xor_result_7_12 <= '0';
		s3_xor_result_0_12 <= '0';
        s3_xor_result_1_12 <= '0';
        s3_xor_result_2_12 <= '0';
        s3_xor_result_3_12 <= '0';
        s3_xor_result_4_12 <= '0';
        s3_xor_result_5_12 <= '0';
        s3_xor_result_6_12 <= '0';
        s3_xor_result_7_12 <= '0';
		hard_input_13      <= (others => '0');
		soft_input_13      <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
		soft_input_13	   <= soft_input_12;
		s1_xor_result_0_12 <= s1_xor_result_0_11 xor hard_input_12(162) xor hard_input_12(163) xor hard_input_12(164) xor hard_input_12(165) xor hard_input_12(167) xor hard_input_12(168) xor hard_input_12(170);
		s1_xor_result_1_12 <= s1_xor_result_1_11 xor hard_input_12(161) xor hard_input_12(162) xor hard_input_12(163) xor hard_input_12(164) xor hard_input_12(166) xor hard_input_12(167) xor hard_input_12(169);
		s1_xor_result_2_12 <= s1_xor_result_2_11 xor hard_input_12(173) xor hard_input_12(174) xor hard_input_12(177) xor hard_input_12(178) xor hard_input_12(179) xor hard_input_12(182) xor hard_input_12(183);
		s1_xor_result_3_12 <= s1_xor_result_3_11 xor hard_input_12(174) xor hard_input_12(176) xor hard_input_12(177) xor hard_input_12(178) xor hard_input_12(179) xor hard_input_12(180) xor hard_input_12(181);
		s1_xor_result_4_12 <= s1_xor_result_4_11 xor hard_input_12(164) xor hard_input_12(166) xor hard_input_12(167) xor hard_input_12(168) xor hard_input_12(169) xor hard_input_12(171) xor hard_input_12(172);
		s1_xor_result_5_12 <= s1_xor_result_5_11 xor hard_input_12(163) xor hard_input_12(165) xor hard_input_12(166) xor hard_input_12(167) xor hard_input_12(168) xor hard_input_12(170) xor hard_input_12(171);
		s1_xor_result_6_12 <= s1_xor_result_6_11 xor hard_input_12(162) xor hard_input_12(164) xor hard_input_12(165) xor hard_input_12(166) xor hard_input_12(167) xor hard_input_12(169) xor hard_input_12(170);
		s1_xor_result_7_12 <= s1_xor_result_7_11 xor hard_input_12(161) xor hard_input_12(163) xor hard_input_12(164) xor hard_input_12(165) xor hard_input_12(166) xor hard_input_12(168) xor hard_input_12(169);
		s3_xor_result_0_12 <= s3_xor_result_0_11 xor hard_input_12(149) xor hard_input_12(154) xor hard_input_12(155) xor hard_input_12(156) xor hard_input_12(157) xor hard_input_12(158) xor hard_input_12(161);
		s3_xor_result_1_12 <= s3_xor_result_1_11 xor hard_input_12(181) xor hard_input_12(182) xor hard_input_12(183) xor hard_input_12(185) xor hard_input_12(188) xor hard_input_12(190) xor hard_input_12(191);
		s3_xor_result_2_12 <= s3_xor_result_2_11 xor hard_input_12(153) xor hard_input_12(155) xor hard_input_12(156) xor hard_input_12(157) xor hard_input_12(158) xor hard_input_12(160) xor hard_input_12(161);
		s3_xor_result_3_12 <= s3_xor_result_3_11 xor hard_input_12(176) xor hard_input_12(178) xor hard_input_12(180) xor hard_input_12(184) xor hard_input_12(186) xor hard_input_12(187) xor hard_input_12(192);
		s3_xor_result_4_12 <= s3_xor_result_4_11 xor hard_input_12(181) xor hard_input_12(183) xor hard_input_12(184) xor hard_input_12(186) xor hard_input_12(187) xor hard_input_12(191) xor hard_input_12(194);
		s3_xor_result_5_12 <= s3_xor_result_5_11 xor hard_input_12(149) xor hard_input_12(150) xor hard_input_12(155) xor hard_input_12(156) xor hard_input_12(157) xor hard_input_12(158) xor hard_input_12(159);
		s3_xor_result_6_12 <= s3_xor_result_6_11 xor hard_input_12(182) xor hard_input_12(183) xor hard_input_12(184) xor hard_input_12(186) xor hard_input_12(189) xor hard_input_12(191) xor hard_input_12(192);
		s3_xor_result_7_12 <= s3_xor_result_7_11 xor hard_input_12(180) xor hard_input_12(182) xor hard_input_12(183) xor hard_input_12(185) xor hard_input_12(186) xor hard_input_12(190) xor hard_input_12(193);
		hard_input_13      <= hard_input_12;
	end if;
end process;
------------------------------------------------------------------------------------------------------------
-- Define processes : (CLK 14)
------------------------------------------------------------------------------------------------------------
process(clk, reset)
begin
	if (reset = '1') then
		s1_xor_result_0_13 <= '0';
        s1_xor_result_1_13 <= '0';
        s1_xor_result_2_13 <= '0';
        s1_xor_result_3_13 <= '0';
        s1_xor_result_4_13 <= '0';
        s1_xor_result_5_13 <= '0';
        s1_xor_result_6_13 <= '0';
        s1_xor_result_7_13 <= '0';
		s3_xor_result_0_13 <= '0';
        s3_xor_result_1_13 <= '0';
        s3_xor_result_2_13 <= '0';
        s3_xor_result_3_13 <= '0';
        s3_xor_result_4_13 <= '0';
        s3_xor_result_5_13 <= '0';
        s3_xor_result_6_13 <= '0';
        s3_xor_result_7_13 <= '0';
		hard_input_14      <= (others => '0');
		soft_input_14      <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
		soft_input_14	   <= soft_input_13;
		s1_xor_result_0_13 <= s1_xor_result_0_12 xor hard_input_13(171) xor hard_input_13(172) xor hard_input_13(173) xor hard_input_13(174) xor hard_input_13(179) xor hard_input_13(180) xor hard_input_13(182);
		s1_xor_result_1_13 <= s1_xor_result_1_12 xor hard_input_13(170) xor hard_input_13(171) xor hard_input_13(172) xor hard_input_13(173) xor hard_input_13(178) xor hard_input_13(179) xor hard_input_13(181);
		s1_xor_result_2_13 <= s1_xor_result_2_12 xor hard_input_13(184) xor hard_input_13(185) xor hard_input_13(189) xor hard_input_13(190) xor hard_input_13(192) xor hard_input_13(193) xor hard_input_13(198);
		s1_xor_result_3_13 <= s1_xor_result_3_12 xor hard_input_13(183) xor hard_input_13(184) xor hard_input_13(185) xor hard_input_13(186) xor hard_input_13(189) xor hard_input_13(190) xor hard_input_13(192);
		s1_xor_result_4_13 <= s1_xor_result_4_12 xor hard_input_13(174) xor hard_input_13(175) xor hard_input_13(176) xor hard_input_13(177) xor hard_input_13(178) xor hard_input_13(183) xor hard_input_13(184);
		s1_xor_result_5_13 <= s1_xor_result_5_12 xor hard_input_13(173) xor hard_input_13(174) xor hard_input_13(175) xor hard_input_13(176) xor hard_input_13(177) xor hard_input_13(182) xor hard_input_13(183);
		s1_xor_result_6_13 <= s1_xor_result_6_12 xor hard_input_13(172) xor hard_input_13(173) xor hard_input_13(174) xor hard_input_13(175) xor hard_input_13(176) xor hard_input_13(181) xor hard_input_13(182);
		s1_xor_result_7_13 <= s1_xor_result_7_12 xor hard_input_13(171) xor hard_input_13(172) xor hard_input_13(173) xor hard_input_13(174) xor hard_input_13(175) xor hard_input_13(180) xor hard_input_13(181);
		s3_xor_result_0_13 <= s3_xor_result_0_12 xor hard_input_13(162) xor hard_input_13(163) xor hard_input_13(165) xor hard_input_13(169) xor hard_input_13(170) xor hard_input_13(172) xor hard_input_13(173);
		s3_xor_result_1_13 <= s3_xor_result_1_12 xor hard_input_13(192) xor hard_input_13(194) xor hard_input_13(195) xor hard_input_13(197) xor hard_input_13(200) xor hard_input_13(201) xor hard_input_13(203);
		s3_xor_result_2_13 <= s3_xor_result_2_12 xor hard_input_13(162) xor hard_input_13(163) xor hard_input_13(164) xor hard_input_13(165) xor hard_input_13(170) xor hard_input_13(171) xor hard_input_13(172);
		s3_xor_result_3_13 <= s3_xor_result_3_12 xor hard_input_13(195) xor hard_input_13(198) xor hard_input_13(200) xor hard_input_13(205) xor hard_input_13(206) xor hard_input_13(209) xor hard_input_13(210);
		s3_xor_result_4_13 <= s3_xor_result_4_12 xor hard_input_13(195) xor hard_input_13(196) xor hard_input_13(197) xor hard_input_13(198) xor hard_input_13(199) xor hard_input_13(200) xor hard_input_13(201);
		s3_xor_result_5_13 <= s3_xor_result_5_12 xor hard_input_13(162) xor hard_input_13(163) xor hard_input_13(164) xor hard_input_13(166) xor hard_input_13(170) xor hard_input_13(171) xor hard_input_13(173);
		s3_xor_result_6_13 <= s3_xor_result_6_12 xor hard_input_13(193) xor hard_input_13(195) xor hard_input_13(196) xor hard_input_13(198) xor hard_input_13(201) xor hard_input_13(202) xor hard_input_13(204);
		s3_xor_result_7_13 <= s3_xor_result_7_12 xor hard_input_13(194) xor hard_input_13(195) xor hard_input_13(196) xor hard_input_13(197) xor hard_input_13(198) xor hard_input_13(199) xor hard_input_13(200);
		hard_input_14      <= hard_input_13;
	end if;
end process;
------------------------------------------------------------------------------------------------------------
-- Define processes : (CLK 15)
------------------------------------------------------------------------------------------------------------
process(clk, reset)
begin
	if (reset = '1') then
		s1_xor_result_0_14 <= '0';
        s1_xor_result_1_14 <= '0';
        s1_xor_result_2_14 <= '0';
        s1_xor_result_3_14 <= '0';
        s1_xor_result_4_14 <= '0';
        s1_xor_result_5_14 <= '0';
        s1_xor_result_6_14 <= '0';
        s1_xor_result_7_14 <= '0';
		s3_xor_result_0_14 <= '0';
        s3_xor_result_1_14 <= '0';
        s3_xor_result_2_14 <= '0';
        s3_xor_result_3_14 <= '0';
        s3_xor_result_4_14 <= '0';
        s3_xor_result_5_14 <= '0';
        s3_xor_result_6_14 <= '0';
        s3_xor_result_7_14 <= '0';
		hard_input_15      <= (others => '0');
		soft_input_15      <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
		soft_input_15	   <= soft_input_14;
		s1_xor_result_0_14 <= s1_xor_result_0_13 xor hard_input_14(185) xor hard_input_14(186) xor hard_input_14(188) xor hard_input_14(190) xor hard_input_14(191) xor hard_input_14(193) xor hard_input_14(194);
		s1_xor_result_1_14 <= s1_xor_result_1_13 xor hard_input_14(184) xor hard_input_14(185) xor hard_input_14(187) xor hard_input_14(189) xor hard_input_14(190) xor hard_input_14(192) xor hard_input_14(193); 
		s1_xor_result_2_14 <= s1_xor_result_2_13 xor hard_input_14(202) xor hard_input_14(204) xor hard_input_14(205) xor hard_input_14(206) xor hard_input_14(208) xor hard_input_14(210) xor hard_input_14(211);
		s1_xor_result_3_14 <= s1_xor_result_3_13 xor hard_input_14(193) xor hard_input_14(194) xor hard_input_14(196) xor hard_input_14(197) xor hard_input_14(198) xor hard_input_14(201) xor hard_input_14(203);
		s1_xor_result_4_14 <= s1_xor_result_4_13 xor hard_input_14(186) xor hard_input_14(189) xor hard_input_14(190) xor hard_input_14(192) xor hard_input_14(194) xor hard_input_14(195) xor hard_input_14(197);
		s1_xor_result_5_14 <= s1_xor_result_5_13 xor hard_input_14(185) xor hard_input_14(188) xor hard_input_14(189) xor hard_input_14(191) xor hard_input_14(193) xor hard_input_14(194) xor hard_input_14(196);
		s1_xor_result_6_14 <= s1_xor_result_6_13 xor hard_input_14(184) xor hard_input_14(187) xor hard_input_14(188) xor hard_input_14(190) xor hard_input_14(192) xor hard_input_14(193) xor hard_input_14(195);
		s1_xor_result_7_14 <= s1_xor_result_7_13 xor hard_input_14(183) xor hard_input_14(186) xor hard_input_14(187) xor hard_input_14(189) xor hard_input_14(191) xor hard_input_14(192) xor hard_input_14(194);
		s3_xor_result_0_14 <= s3_xor_result_0_13 xor hard_input_14(175) xor hard_input_14(176) xor hard_input_14(177) xor hard_input_14(178) xor hard_input_14(182) xor hard_input_14(184) xor hard_input_14(186);
		s3_xor_result_1_14 <= s3_xor_result_1_13 xor hard_input_14(211) xor hard_input_14(212) xor hard_input_14(214) xor hard_input_14(216) xor hard_input_14(217) xor hard_input_14(219) xor hard_input_14(221);
		s3_xor_result_2_14 <= s3_xor_result_2_13 xor hard_input_14(173) xor hard_input_14(174) xor hard_input_14(177) xor hard_input_14(178) xor hard_input_14(179) xor hard_input_14(181) xor hard_input_14(185);
		s3_xor_result_3_14 <= s3_xor_result_3_13 xor hard_input_14(214) xor hard_input_14(215) xor hard_input_14(216) xor hard_input_14(217) xor hard_input_14(219) xor hard_input_14(222) xor hard_input_14(224);
		s3_xor_result_4_14 <= s3_xor_result_4_13 xor hard_input_14(203) xor hard_input_14(204) xor hard_input_14(207) xor hard_input_14(210) xor hard_input_14(211) xor hard_input_14(214) xor hard_input_14(216);
		s3_xor_result_5_14 <= s3_xor_result_5_13 xor hard_input_14(174) xor hard_input_14(176) xor hard_input_14(177) xor hard_input_14(178) xor hard_input_14(179) xor hard_input_14(183) xor hard_input_14(185);
		s3_xor_result_6_14 <= s3_xor_result_6_13 xor hard_input_14(212) xor hard_input_14(213) xor hard_input_14(215) xor hard_input_14(217) xor hard_input_14(218) xor hard_input_14(220) xor hard_input_14(222);
		s3_xor_result_7_14 <= s3_xor_result_7_13 xor hard_input_14(202) xor hard_input_14(203) xor hard_input_14(206) xor hard_input_14(209) xor hard_input_14(210) xor hard_input_14(213) xor hard_input_14(215);
		hard_input_15      <= hard_input_14;
	end if;
end process;
------------------------------------------------------------------------------------------------------------
-- Define processes : (CLK 16)
------------------------------------------------------------------------------------------------------------
process(clk, reset)
begin
	if (reset = '1') then
		s1_xor_result_0_15 <= '0';
        s1_xor_result_1_15 <= '0';
        s1_xor_result_2_15 <= '0';
        s1_xor_result_3_15 <= '0';
        s1_xor_result_4_15 <= '0';
        s1_xor_result_5_15 <= '0';
        s1_xor_result_6_15 <= '0';
        s1_xor_result_7_15 <= '0';
		s3_xor_result_0_15 <= '0';
        s3_xor_result_1_15 <= '0';
        s3_xor_result_2_15 <= '0';
        s3_xor_result_3_15 <= '0';
        s3_xor_result_4_15 <= '0';
        s3_xor_result_5_15 <= '0';
        s3_xor_result_6_15 <= '0';
        s3_xor_result_7_15 <= '0';
		hard_input_16      <= (others => '0');
		soft_input_16      <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
		soft_input_16	   <= soft_input_15;
		s1_xor_result_0_15 <= s1_xor_result_0_14 xor hard_input_15(196) xor hard_input_15(198) xor hard_input_15(204) xor hard_input_15(207) xor hard_input_15(208) xor hard_input_15(209) xor hard_input_15(211);
		s1_xor_result_1_15 <= s1_xor_result_1_14 xor hard_input_15(195) xor hard_input_15(197) xor hard_input_15(203) xor hard_input_15(206) xor hard_input_15(207) xor hard_input_15(208) xor hard_input_15(210);
		s1_xor_result_2_15 <= s1_xor_result_2_14 xor hard_input_15(212) xor hard_input_15(213) xor hard_input_15(215) xor hard_input_15(216) xor hard_input_15(218) xor hard_input_15(219) xor hard_input_15(220);
		s1_xor_result_3_15 <= s1_xor_result_3_14 xor hard_input_15(205) xor hard_input_15(208) xor hard_input_15(210) xor hard_input_15(214) xor hard_input_15(217) xor hard_input_15(219) xor hard_input_15(220);
		s1_xor_result_4_15 <= s1_xor_result_4_14 xor hard_input_15(198) xor hard_input_15(200) xor hard_input_15(202) xor hard_input_15(208) xor hard_input_15(211) xor hard_input_15(212) xor hard_input_15(213);
		s1_xor_result_5_15 <= s1_xor_result_5_14 xor hard_input_15(197) xor hard_input_15(199) xor hard_input_15(201) xor hard_input_15(207) xor hard_input_15(210) xor hard_input_15(211) xor hard_input_15(212);
		s1_xor_result_6_15 <= s1_xor_result_6_14 xor hard_input_15(196) xor hard_input_15(198) xor hard_input_15(200) xor hard_input_15(206) xor hard_input_15(209) xor hard_input_15(210) xor hard_input_15(211);
		s1_xor_result_7_15 <= s1_xor_result_7_14 xor hard_input_15(195) xor hard_input_15(197) xor hard_input_15(199) xor hard_input_15(205) xor hard_input_15(208) xor hard_input_15(209) xor hard_input_15(210);
		s3_xor_result_0_15 <= s3_xor_result_0_14 xor hard_input_15(188) xor hard_input_15(191) xor hard_input_15(195) xor hard_input_15(196) xor hard_input_15(197) xor hard_input_15(199) xor hard_input_15(200);
		s3_xor_result_1_15 <= s3_xor_result_1_14 xor hard_input_15(223) xor hard_input_15(224) xor hard_input_15(225) xor hard_input_15(226) xor hard_input_15(227) xor hard_input_15(229) xor hard_input_15(231);
		s3_xor_result_2_15 <= s3_xor_result_2_14 xor hard_input_15(186) xor hard_input_15(188) xor hard_input_15(189) xor hard_input_15(191) xor hard_input_15(192) xor hard_input_15(193) xor hard_input_15(194);
		s3_xor_result_3_15 <= s3_xor_result_3_14 xor hard_input_15(225) xor hard_input_15(226) xor hard_input_15(228) xor hard_input_15(229) xor hard_input_15(231) xor hard_input_15(234) xor hard_input_15(235);
		s3_xor_result_4_15 <= s3_xor_result_4_14 xor hard_input_15(218) xor hard_input_15(219) xor hard_input_15(222) xor hard_input_15(223) xor hard_input_15(224) xor hard_input_15(225) xor hard_input_15(228);
		s3_xor_result_5_15 <= s3_xor_result_5_14 xor hard_input_15(187) xor hard_input_15(189) xor hard_input_15(192) xor hard_input_15(196) xor hard_input_15(197) xor hard_input_15(198) xor hard_input_15(200);
		s3_xor_result_6_15 <= s3_xor_result_6_14 xor hard_input_15(224) xor hard_input_15(225) xor hard_input_15(226) xor hard_input_15(227) xor hard_input_15(228) xor hard_input_15(230) xor hard_input_15(232);
		s3_xor_result_7_15 <= s3_xor_result_7_14 xor hard_input_15(217) xor hard_input_15(218) xor hard_input_15(221) xor hard_input_15(222) xor hard_input_15(223) xor hard_input_15(224) xor hard_input_15(227);
		hard_input_16      <= hard_input_15;
	end if;
end process;
------------------------------------------------------------------------------------------------------------
-- Define processes : (CLK 17)
------------------------------------------------------------------------------------------------------------
process(clk, reset)
begin
	if (reset = '1') then
		s1_xor_result_0_16 <= '0';
        s1_xor_result_1_16 <= '0';
        s1_xor_result_2_16 <= '0';
        s1_xor_result_3_16 <= '0';
        s1_xor_result_4_16 <= '0';
        s1_xor_result_5_16 <= '0';
        s1_xor_result_6_16 <= '0';
        s1_xor_result_7_16 <= '0';
		s3_xor_result_0_16 <= '0';
        s3_xor_result_1_16 <= '0';
        s3_xor_result_2_16 <= '0';
        s3_xor_result_3_16 <= '0';
        s3_xor_result_4_16 <= '0';
        s3_xor_result_5_16 <= '0';
        s3_xor_result_6_16 <= '0';
        s3_xor_result_7_16 <= '0';
		hard_input_17      <= (others => '0');
		soft_input_17      <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
		soft_input_17	   <= soft_input_16;
		s1_xor_result_0_16 <= s1_xor_result_0_15 xor hard_input_16(212) xor hard_input_16(215) xor hard_input_16(218) xor hard_input_16(221) xor hard_input_16(222) xor hard_input_16(229) xor hard_input_16(230);
		s1_xor_result_1_16 <= s1_xor_result_1_15 xor hard_input_16(211) xor hard_input_16(214) xor hard_input_16(217) xor hard_input_16(220) xor hard_input_16(221) xor hard_input_16(228) xor hard_input_16(229); 
		s1_xor_result_2_16 <= s1_xor_result_2_15 xor hard_input_16(221) xor hard_input_16(222) xor hard_input_16(227) xor hard_input_16(228) xor hard_input_16(230) xor hard_input_16(233) xor hard_input_16(234);
		s1_xor_result_3_16 <= s1_xor_result_3_15 xor hard_input_16(222) xor hard_input_16(226) xor hard_input_16(227) xor hard_input_16(230) xor hard_input_16(231) xor hard_input_16(232) xor hard_input_16(235); 
		s1_xor_result_4_16 <= s1_xor_result_4_15 xor hard_input_16(215) xor hard_input_16(216) xor hard_input_16(219) xor hard_input_16(222) xor hard_input_16(225) xor hard_input_16(226) xor hard_input_16(233); 
		s1_xor_result_5_16 <= s1_xor_result_5_15 xor hard_input_16(214) xor hard_input_16(215) xor hard_input_16(218) xor hard_input_16(221) xor hard_input_16(224) xor hard_input_16(225) xor hard_input_16(232);
		s1_xor_result_6_16 <= s1_xor_result_6_15 xor hard_input_16(213) xor hard_input_16(214) xor hard_input_16(217) xor hard_input_16(220) xor hard_input_16(223) xor hard_input_16(224) xor hard_input_16(231);
		s1_xor_result_7_16 <= s1_xor_result_7_15 xor hard_input_16(212) xor hard_input_16(213) xor hard_input_16(216) xor hard_input_16(219) xor hard_input_16(222) xor hard_input_16(223) xor hard_input_16(230);
		s3_xor_result_0_16 <= s3_xor_result_0_15 xor hard_input_16(201) xor hard_input_16(204) xor hard_input_16(205) xor hard_input_16(207) xor hard_input_16(208) xor hard_input_16(209) xor hard_input_16(211);
		s3_xor_result_1_16 <= s3_xor_result_1_15 xor hard_input_16(235) xor hard_input_16(237) xor hard_input_16(238) xor hard_input_16(243) xor hard_input_16(246) xor hard_input_16(249) xor hard_input_16(251);
		s3_xor_result_2_16 <= s3_xor_result_2_15 xor hard_input_16(198) xor hard_input_16(200) xor hard_input_16(202) xor hard_input_16(204) xor hard_input_16(207) xor hard_input_16(211) xor hard_input_16(212);
		s3_xor_result_3_16 <= s3_xor_result_3_15 xor hard_input_16(237) xor hard_input_16(245) xor hard_input_16(246) xor hard_input_16(248) xor hard_input_16(250) xor hard_input_16(251) xor hard_input_16(253);
		s3_xor_result_4_16 <= s3_xor_result_4_15 xor hard_input_16(234) xor hard_input_16(235) xor hard_input_16(236) xor hard_input_16(240) xor hard_input_16(241) xor hard_input_16(247) xor hard_input_16(251);
		s3_xor_result_5_16 <= s3_xor_result_5_15 xor hard_input_16(201) xor hard_input_16(202) xor hard_input_16(205) xor hard_input_16(206) xor hard_input_16(208) xor hard_input_16(209) xor hard_input_16(210);
		s3_xor_result_6_16 <= s3_xor_result_6_15 xor hard_input_16(236) xor hard_input_16(238) xor hard_input_16(239) xor hard_input_16(244) xor hard_input_16(247) xor hard_input_16(250) xor hard_input_16(252);
		s3_xor_result_7_16 <= s3_xor_result_7_15 xor hard_input_16(233) xor hard_input_16(234) xor hard_input_16(235) xor hard_input_16(239) xor hard_input_16(240) xor hard_input_16(246) xor hard_input_16(250);
		hard_input_17      <= hard_input_16;
	end if;
end process;
------------------------------------------------------------------------------------------------------------
-- Define processes : (CLK 18)
------------------------------------------------------------------------------------------------------------
process(clk, reset)
begin
	if (reset = '1') then
		s1_xor_result_0_17 <= '0';
        s1_xor_result_1_17 <= '0';
        s1_xor_result_2_17 <= '0';
        s1_xor_result_3_17 <= '0';
        s1_xor_result_4_17 <= '0';
        s1_xor_result_5_17 <= '0';
        s1_xor_result_6_17 <= '0';
        s1_xor_result_7_17 <= '0';
		s3_xor_result_0_17 <= '0';
        s3_xor_result_1_17 <= '0';
        s3_xor_result_2_17 <= '0';
        s3_xor_result_3_17 <= '0';
        s3_xor_result_4_17 <= '0';
        s3_xor_result_5_17 <= '0';
        s3_xor_result_6_17 <= '0';
        s3_xor_result_7_17 <= '0';
		hard_input_18      <= (others => '0');
		soft_input_18      <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
		soft_input_18	   <= soft_input_17;
		s1_xor_result_0_17 <= s1_xor_result_0_16 xor hard_input_17(231) xor hard_input_17(233) xor hard_input_17(236) xor hard_input_17(240) xor hard_input_17(241) xor hard_input_17(242) xor hard_input_17(246);
		s1_xor_result_1_17 <= s1_xor_result_1_16 xor hard_input_17(230) xor hard_input_17(232) xor hard_input_17(235) xor hard_input_17(239) xor hard_input_17(240) xor hard_input_17(241) xor hard_input_17(245);
		s1_xor_result_2_17 <= s1_xor_result_2_16 xor hard_input_17(236) xor hard_input_17(238) xor hard_input_17(239) xor hard_input_17(241) xor hard_input_17(242) xor hard_input_17(244) xor hard_input_17(246);
		s1_xor_result_3_17 <= s1_xor_result_3_16 xor hard_input_17(236) xor hard_input_17(237) xor hard_input_17(238) xor hard_input_17(242) xor hard_input_17(243) xor hard_input_17(245) xor hard_input_17(246);
		s1_xor_result_4_17 <= s1_xor_result_4_16 xor hard_input_17(234) xor hard_input_17(235) xor hard_input_17(237) xor hard_input_17(240) xor hard_input_17(244) xor hard_input_17(245) xor hard_input_17(246);
		s1_xor_result_5_17 <= s1_xor_result_5_16 xor hard_input_17(233) xor hard_input_17(234) xor hard_input_17(236) xor hard_input_17(239) xor hard_input_17(243) xor hard_input_17(244) xor hard_input_17(245);
		s1_xor_result_6_17 <= s1_xor_result_6_16 xor hard_input_17(232) xor hard_input_17(233) xor hard_input_17(235) xor hard_input_17(238) xor hard_input_17(242) xor hard_input_17(243) xor hard_input_17(244);
		s1_xor_result_7_17 <= s1_xor_result_7_16 xor hard_input_17(231) xor hard_input_17(232) xor hard_input_17(234) xor hard_input_17(237) xor hard_input_17(241) xor hard_input_17(242) xor hard_input_17(243);
		s3_xor_result_0_17 <= s3_xor_result_0_16 xor hard_input_17(213) xor hard_input_17(214) xor hard_input_17(215) xor hard_input_17(222) xor hard_input_17(224) xor hard_input_17(225) xor hard_input_17(226);
		s3_xor_result_1_17 <= s3_xor_result_1_16;
		s3_xor_result_2_17 <= s3_xor_result_2_16 xor hard_input_17(213) xor hard_input_17(215) xor hard_input_17(216) xor hard_input_17(217) xor hard_input_17(220) xor hard_input_17(221) xor hard_input_17(223);
		s3_xor_result_3_17 <= s3_xor_result_3_16;
		s3_xor_result_4_17 <= s3_xor_result_4_16;
		s3_xor_result_5_17 <= s3_xor_result_5_16 xor hard_input_17(212) xor hard_input_17(214) xor hard_input_17(215) xor hard_input_17(216) xor hard_input_17(223) xor hard_input_17(225) xor hard_input_17(226);
		s3_xor_result_6_17 <= s3_xor_result_6_16;
		s3_xor_result_7_17 <= s3_xor_result_7_16;
		hard_input_18      <= hard_input_17;
	end if;
end process;
------------------------------------------------------------------------------------------------------------
-- Define processes : (CLK 19)
------------------------------------------------------------------------------------------------------------
process(clk, reset)
begin
	if (reset = '1') then
		s1_xor_result_0_18 <= '0';
        s1_xor_result_1_18 <= '0';
        s1_xor_result_2_18 <= '0';
        s1_xor_result_3_18 <= '0';
        s1_xor_result_4_18 <= '0';
        s1_xor_result_5_18 <= '0';
        s1_xor_result_6_18 <= '0';
        s1_xor_result_7_18 <= '0';
		s3_xor_result_0_18 <= '0';
        s3_xor_result_1_18 <= '0';
        s3_xor_result_2_18 <= '0';
        s3_xor_result_3_18 <= '0';
        s3_xor_result_4_18 <= '0';
        s3_xor_result_5_18 <= '0';
        s3_xor_result_6_18 <= '0';
        s3_xor_result_7_18 <= '0';
		hard_input_19      <= (others => '0');
		soft_input_19      <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
		soft_input_19	   <= soft_input_18;
		s1_xor_result_0_18 <= s1_xor_result_0_17 xor hard_input_18(254); -- The last bit for S1 is done here
		s1_xor_result_1_18 <= s1_xor_result_1_17 xor hard_input_18(253);
		s1_xor_result_2_18 <= s1_xor_result_2_17 xor hard_input_18(252); 
		s1_xor_result_3_18 <= s1_xor_result_3_17 xor hard_input_18(251);
		s1_xor_result_4_18 <= s1_xor_result_4_17 xor hard_input_18(250);
		s1_xor_result_5_18 <= s1_xor_result_5_17 xor hard_input_18(249);
		s1_xor_result_6_18 <= s1_xor_result_6_17 xor hard_input_18(248);
		s1_xor_result_7_18 <= s1_xor_result_7_17 xor hard_input_18(247);
		s3_xor_result_0_18 <= s3_xor_result_0_17 xor hard_input_18(227) xor hard_input_18(229) xor hard_input_18(230) xor hard_input_18(231) xor hard_input_18(232) xor hard_input_18(233) xor hard_input_18(234);
		s3_xor_result_1_18 <= s3_xor_result_1_17 ;
		s3_xor_result_2_18 <= s3_xor_result_2_17 xor hard_input_18(224) xor hard_input_18(225) xor hard_input_18(227) xor hard_input_18(229) xor hard_input_18(230) xor hard_input_18(231) xor hard_input_18(238);
		s3_xor_result_3_18 <= s3_xor_result_3_17 ;
		s3_xor_result_4_18 <= s3_xor_result_4_17 ;
		s3_xor_result_5_18 <= s3_xor_result_5_17 xor hard_input_18(227) xor hard_input_18(228) xor hard_input_18(230) xor hard_input_18(231) xor hard_input_18(232) xor hard_input_18(233) xor hard_input_18(234);
		s3_xor_result_6_18 <= s3_xor_result_6_17 ;
		s3_xor_result_7_18 <= s3_xor_result_7_17 ;
		hard_input_19      <= hard_input_18;						  -- Maybe the input need to be passed to the BCH_DECODER later
	end if;
end process;
------------------------------------------------------------------------------------------------------------
-- Define processes : (CLK 20)
------------------------------------------------------------------------------------------------------------
process(clk, reset)
begin
	if (reset = '1') then
		s1_xor_result_0_19 <= '0';
        s1_xor_result_1_19 <= '0';
        s1_xor_result_2_19 <= '0';
        s1_xor_result_3_19 <= '0';
        s1_xor_result_4_19 <= '0';
        s1_xor_result_5_19 <= '0';
        s1_xor_result_6_19 <= '0';
        s1_xor_result_7_19 <= '0';
		s3_xor_result_0_19 <= '0';
        s3_xor_result_1_19 <= '0';
        s3_xor_result_2_19 <= '0';
        s3_xor_result_3_19 <= '0';
        s3_xor_result_4_19 <= '0';
        s3_xor_result_5_19 <= '0';
        s3_xor_result_6_19 <= '0';
        s3_xor_result_7_19 <= '0';
		hard_input_20      <= (others => '0');
		soft_input_20      <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
		soft_input_20	   <= soft_input_19;
		s1_xor_result_0_19 <= s1_xor_result_0_18; -- The last bit for S1 is done here
		s1_xor_result_1_19 <= s1_xor_result_1_18;
		s1_xor_result_2_19 <= s1_xor_result_2_18; 
		s1_xor_result_3_19 <= s1_xor_result_3_18;
		s1_xor_result_4_19 <= s1_xor_result_4_18;
		s1_xor_result_5_19 <= s1_xor_result_5_18;
		s1_xor_result_6_19 <= s1_xor_result_6_18;
		s1_xor_result_7_19 <= s1_xor_result_7_18;
		s3_xor_result_0_19 <= s3_xor_result_0_18 xor hard_input_19(239) xor hard_input_19(240) xor hard_input_19(241) xor hard_input_19(242) xor hard_input_19(243) xor hard_input_19(246) xor hard_input_19(247);
		s3_xor_result_1_19 <= s3_xor_result_1_18;
		s3_xor_result_2_19 <= s3_xor_result_2_18 xor hard_input_19(240) xor hard_input_19(241) xor hard_input_19(242) xor hard_input_19(243) xor hard_input_19(245) xor hard_input_19(246) xor hard_input_19(247);
		s3_xor_result_3_19 <= s3_xor_result_3_18;
		s3_xor_result_4_19 <= s3_xor_result_4_18;
		s3_xor_result_5_19 <= s3_xor_result_5_18 xor hard_input_19(235) xor hard_input_19(240) xor hard_input_19(241) xor hard_input_19(242) xor hard_input_19(243) xor hard_input_19(244) xor hard_input_19(247);
		s3_xor_result_6_19 <= s3_xor_result_6_18;
		s3_xor_result_7_19 <= s3_xor_result_7_18;
		hard_input_20      <= hard_input_19;						  -- Maybe the input need to be passed to the BCH_DECODER later
	end if;
end process;
--------------------------------------------------------------------------------------------------------------
---- Define processes : (CLK 21)
--------------------------------------------------------------------------------------------------------------
process(clk, reset)
begin
	if (reset = '1') then
		s1_xor_result_0_20 <= '0';
        s1_xor_result_1_20 <= '0';
        s1_xor_result_2_20 <= '0';
        s1_xor_result_3_20 <= '0';
        s1_xor_result_4_20 <= '0';
        s1_xor_result_5_20 <= '0';
        s1_xor_result_6_20 <= '0';
        s1_xor_result_7_20 <= '0';
		s3_xor_result_0_20 <= '0';
        s3_xor_result_1_20 <= '0';
        s3_xor_result_2_20 <= '0';
        s3_xor_result_3_20 <= '0';
        s3_xor_result_4_20 <= '0';
        s3_xor_result_5_20 <= '0';
        s3_xor_result_6_20 <= '0';
        s3_xor_result_7_20 <= '0';
		hard_input_21      <= (others => '0');
		soft_input_21      <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
		soft_input_21	   <= soft_input_20;
		s1_xor_result_0_20 <= s1_xor_result_0_19; -- The last bit for S1 is done here
		s1_xor_result_1_20 <= s1_xor_result_1_19;
		s1_xor_result_2_20 <= s1_xor_result_2_19; 
		s1_xor_result_3_20 <= s1_xor_result_3_19;
		s1_xor_result_4_20 <= s1_xor_result_4_19;
		s1_xor_result_5_20 <= s1_xor_result_5_19;
		s1_xor_result_6_20 <= s1_xor_result_6_19;
		s1_xor_result_7_20 <= s1_xor_result_7_19;
		s3_xor_result_0_20 <= s3_xor_result_0_19 xor hard_input_20(248) xor hard_input_20(250) xor hard_input_20(254);
		s3_xor_result_1_20 <= s3_xor_result_1_19;
		s3_xor_result_2_20 <= s3_xor_result_2_19 xor hard_input_20(248) xor hard_input_20(249) xor hard_input_20(250);
		s3_xor_result_3_20 <= s3_xor_result_3_19;
		s3_xor_result_4_20 <= s3_xor_result_4_19;
		s3_xor_result_5_20 <= s3_xor_result_5_19 xor hard_input_20(248) xor hard_input_20(249) xor hard_input_20(251);
		s3_xor_result_6_20 <= s3_xor_result_6_19;
		s3_xor_result_7_20 <= s3_xor_result_7_19;
		hard_input_21      <= hard_input_20;						  -- Maybe the input need to be passed to the BCH_DECODER later
	end if;
end process;
------------------------------------------------------------------------------------------------------------
-- Define processes : (CLK 22)
------------------------------------------------------------------------------------------------------------
process(clk, reset)
begin
	if (reset = '1') then
		s1_f 				 <= (others => '0');
		s3_f 				 <= (others => '0');
		hard_output_f	     <= (others => '0');
		soft_output_f      	 <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
		soft_output_f  	 	 <= soft_input_21;
		s1_f 				 <= s1_xor_result_7_20 & s1_xor_result_6_20 & s1_xor_result_5_20 & s1_xor_result_4_20 & s1_xor_result_3_20 & s1_xor_result_2_20 & s1_xor_result_1_20 & s1_xor_result_0_20;
		s3_f 				 <= s3_xor_result_7_20 & s3_xor_result_6_20 & s3_xor_result_5_20 & s3_xor_result_4_20 & s3_xor_result_3_20 & s3_xor_result_2_20 & s3_xor_result_1_20 & s3_xor_result_0_20;
		hard_output_f      	 <= hard_input_21;						  -- Maybe the input need to be passed to the BCH_DECODER later
	end if;
end process;
------------------------------------------------------------------------------------------------------------
-- Define processes : (CLK 23)
------------------------------------------------------------------------------------------------------------
process(clk, reset)
begin
	if (reset = '1') then
		s1 				 <= (others => '0');
		s3 				 <= (others => '0');
		hard_output	     <= (others => '0');
		soft_output      <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
		soft_output 	 <= soft_output_f;
		s1 				 <= s1_f;
		s3 				 <= s3_f;
		hard_output      <= hard_output_f;	
	end if;
end process;
end architecture;