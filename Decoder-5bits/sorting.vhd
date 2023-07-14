library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use ieee.math_real.all;
use work.arr_pkg_2.all;
use work.arr_pkg_3.all;

entity sorting is
        generic (
                data_in_length  : positive := 255;
                data_out_length : positive := 7
        );
        port (
                clk        : in std_logic;                                 -- system clock
                reset      : in std_logic;                                 -- reset
                soft_input : in input_data_array(data_in_length downto 0); -- 256 * 6 bits

                index_0       : out index_array(data_out_length downto 0);     -- We only need to output the index of the most 8 unreliable bits, so maybe having 8 index output is enough
                soft_output_0 : out input_data_array(data_in_length downto 0); -- soft output should be the same as soft input, I think we only need the index
                index_1       : out index_array(data_out_length downto 0);
                soft_output_1 : out input_data_array(data_in_length downto 0);
                index_2       : out index_array(data_out_length downto 0);
                soft_output_2 : out input_data_array(data_in_length downto 0);
                index_3       : out index_array(data_out_length downto 0);
                soft_output_3 : out input_data_array(data_in_length downto 0);
                index_4       : out index_array(data_out_length downto 0);
                soft_output_4 : out input_data_array(data_in_length downto 0);
                index_5       : out index_array(data_out_length downto 0);
                soft_output_5 : out input_data_array(data_in_length downto 0);
                index_6       : out index_array(data_out_length downto 0);
                soft_output_6 : out input_data_array(data_in_length downto 0);
                index_7       : out index_array(data_out_length downto 0);
                soft_output_7 : out input_data_array(data_in_length downto 0)
        );
end sorting;

architecture rtl of sorting is
        ------------------------------------------------------------------------------------------------------------
        --CLK 1    
        signal soft_input_temp_1  : input_data_array(7 downto 0);
        signal index_temp_1       : index_array(7 downto 0);
        signal soft_output_temp_1 : input_data_array(7 downto 0);
        signal soft_input_temp_2  : input_data_array(7 downto 0);
        signal index_temp_2       : index_array(7 downto 0);
        signal soft_output_temp_2 : input_data_array(7 downto 0);
        signal soft_input_temp_3  : input_data_array(7 downto 0);
        signal index_temp_3       : index_array(7 downto 0);
        signal soft_output_temp_3 : input_data_array(7 downto 0);
        signal soft_input_temp_4  : input_data_array(7 downto 0);
        signal index_temp_4       : index_array(7 downto 0);
        signal soft_output_temp_4 : input_data_array(7 downto 0);
        signal soft_input_pass_1  : input_data_array(data_in_length downto 0);
        signal soft_output_pass_1 : input_data_array(data_in_length downto 0);
        ------------------------------------------------------------------------------------------------------------
        --CLK 2
        signal soft_input_temp_5  : input_data_array(7 downto 0);
        signal index_temp_5       : index_array(7 downto 0);
        signal soft_output_temp_5 : input_data_array(7 downto 0);
        signal soft_input_temp_6  : input_data_array(7 downto 0);
        signal index_temp_6       : index_array(7 downto 0);
        signal soft_output_temp_6 : input_data_array(7 downto 0);
        signal soft_input_temp_7  : input_data_array(7 downto 0);
        signal index_temp_7       : index_array(7 downto 0);
        signal soft_output_temp_7 : input_data_array(7 downto 0);
        signal soft_input_temp_8  : input_data_array(7 downto 0);
        signal index_temp_8       : index_array(7 downto 0);
        signal soft_output_temp_8 : input_data_array(7 downto 0);
        signal soft_input_pass_2  : input_data_array(data_in_length downto 0);
        signal soft_output_pass_2 : input_data_array(data_in_length downto 0);
        ------------------------------------------------------------------------------------------------------------
        --CLK 3
        signal soft_input_temp_9   : input_data_array(7 downto 0);
        signal index_temp_9        : index_array(7 downto 0);
        signal soft_output_temp_9  : input_data_array(7 downto 0);
        signal soft_input_temp_10  : input_data_array(7 downto 0);
        signal index_temp_10       : index_array(7 downto 0);
        signal soft_output_temp_10 : input_data_array(7 downto 0);
        signal soft_input_temp_11  : input_data_array(7 downto 0);
        signal index_temp_11       : index_array(7 downto 0);
        signal soft_output_temp_11 : input_data_array(7 downto 0);
        signal soft_input_temp_12  : input_data_array(7 downto 0);
        signal index_temp_12       : index_array(7 downto 0);
        signal soft_output_temp_12 : input_data_array(7 downto 0);
        signal soft_input_pass_3   : input_data_array(data_in_length downto 0);
        signal soft_output_pass_3  : input_data_array(data_in_length downto 0);
        ------------------------------------------------------------------------------------------------------------
        --CLK 4
        signal soft_input_temp_13  : input_data_array(7 downto 0);
        signal index_temp_13       : index_array(7 downto 0);
        signal soft_output_temp_13 : input_data_array(7 downto 0);
        signal soft_input_temp_14  : input_data_array(7 downto 0);
        signal index_temp_14       : index_array(7 downto 0);
        signal soft_output_temp_14 : input_data_array(7 downto 0);
        signal soft_input_temp_15  : input_data_array(7 downto 0);
        signal index_temp_15       : index_array(7 downto 0);
        signal soft_output_temp_15 : input_data_array(7 downto 0);
        signal soft_input_temp_16  : input_data_array(7 downto 0);
        signal index_temp_16       : index_array(7 downto 0);
        signal soft_output_temp_16 : input_data_array(7 downto 0);
        signal soft_input_pass_4   : input_data_array(data_in_length downto 0);
        signal soft_output_pass_4  : input_data_array(data_in_length downto 0);
        ------------------------------------------------------------------------------------------------------------
        --CLK 5
        signal soft_input_temp_17  : input_data_array(7 downto 0);
        signal index_temp_17       : index_array(7 downto 0);
        signal soft_output_temp_17 : input_data_array(7 downto 0);
        signal soft_input_temp_18  : input_data_array(7 downto 0);
        signal index_temp_18       : index_array(7 downto 0);
        signal soft_output_temp_18 : input_data_array(7 downto 0);
        signal soft_input_temp_19  : input_data_array(7 downto 0);
        signal index_temp_19       : index_array(7 downto 0);
        signal soft_output_temp_19 : input_data_array(7 downto 0);
        signal soft_input_temp_20  : input_data_array(7 downto 0);
        signal index_temp_20       : index_array(7 downto 0);
        signal soft_output_temp_20 : input_data_array(7 downto 0);
        signal soft_input_pass_5   : input_data_array(data_in_length downto 0);
        signal soft_output_pass_5  : input_data_array(data_in_length downto 0);
        ------------------------------------------------------------------------------------------------------------
        --CLK 6
        signal soft_input_temp_21  : input_data_array(7 downto 0);
        signal index_temp_21       : index_array(7 downto 0);
        signal soft_output_temp_21 : input_data_array(7 downto 0);
        signal soft_input_temp_22  : input_data_array(7 downto 0);
        signal index_temp_22       : index_array(7 downto 0);
        signal soft_output_temp_22 : input_data_array(7 downto 0);
        signal soft_input_temp_23  : input_data_array(7 downto 0);
        signal index_temp_23       : index_array(7 downto 0);
        signal soft_output_temp_23 : input_data_array(7 downto 0);
        signal soft_input_temp_24  : input_data_array(7 downto 0);
        signal index_temp_24       : index_array(7 downto 0);
        signal soft_output_temp_24 : input_data_array(7 downto 0);
        signal soft_input_pass_6   : input_data_array(data_in_length downto 0);
        signal soft_output_pass_6  : input_data_array(data_in_length downto 0);
        ------------------------------------------------------------------------------------------------------------
        --CLK 7
        signal soft_input_temp_25  : input_data_array(7 downto 0);
        signal index_temp_25       : index_array(7 downto 0);
        signal soft_output_temp_25 : input_data_array(7 downto 0);
        signal soft_input_temp_26  : input_data_array(7 downto 0);
        signal index_temp_26       : index_array(7 downto 0);
        signal soft_output_temp_26 : input_data_array(7 downto 0);
        signal soft_input_temp_27  : input_data_array(7 downto 0);
        signal index_temp_27       : index_array(7 downto 0);
        signal soft_output_temp_27 : input_data_array(7 downto 0);
        signal soft_input_temp_28  : input_data_array(7 downto 0);
        signal index_temp_28       : index_array(7 downto 0);
        signal soft_output_temp_28 : input_data_array(7 downto 0);
        ------------------------------------------------------------------------------------------------------------
        --CLK 8
        signal soft_input_temp_29  : input_data_array(7 downto 0);
        signal index_temp_29       : index_array(7 downto 0);
        signal soft_output_temp_29 : input_data_array(7 downto 0);
        signal soft_input_temp_30  : input_data_array(7 downto 0);
        signal index_temp_30       : index_array(7 downto 0);
        signal soft_output_temp_30 : input_data_array(7 downto 0);
        signal soft_input_temp_31  : input_data_array(7 downto 0);
        signal index_temp_31       : index_array(7 downto 0);
        signal soft_output_temp_31 : input_data_array(7 downto 0);
        signal soft_input_temp_32  : input_data_array(7 downto 0);
        signal index_temp_32       : index_array(7 downto 0);
        signal soft_output_temp_32 : input_data_array(7 downto 0);
        ------------------------------------------------------------------------------------------------------------
        signal soft_output_temp_1_in  : input_data_array(7 downto 0);
        signal soft_output_temp_2_in  : input_data_array(7 downto 0);
        signal soft_output_temp_3_in  : input_data_array(7 downto 0);
        signal soft_output_temp_4_in  : input_data_array(7 downto 0);
        signal soft_output_temp_5_in  : input_data_array(7 downto 0);
        signal soft_output_temp_6_in  : input_data_array(7 downto 0);
        signal soft_output_temp_7_in  : input_data_array(7 downto 0);
        signal soft_output_temp_8_in  : input_data_array(7 downto 0);
        signal soft_output_temp_9_in  : input_data_array(7 downto 0);
        signal soft_output_temp_10_in : input_data_array(7 downto 0);
        signal soft_output_temp_11_in : input_data_array(7 downto 0);
        signal soft_output_temp_12_in : input_data_array(7 downto 0);
        signal soft_output_temp_13_in : input_data_array(7 downto 0);
        signal soft_output_temp_14_in : input_data_array(7 downto 0);
        signal soft_output_temp_15_in : input_data_array(7 downto 0);
        signal soft_output_temp_16_in : input_data_array(7 downto 0);
        signal soft_output_temp_17_in : input_data_array(7 downto 0);
        signal soft_output_temp_18_in : input_data_array(7 downto 0);
        signal soft_output_temp_19_in : input_data_array(7 downto 0);
        signal soft_output_temp_20_in : input_data_array(7 downto 0);
        signal soft_output_temp_21_in : input_data_array(7 downto 0);
        signal soft_output_temp_22_in : input_data_array(7 downto 0);
        signal soft_output_temp_23_in : input_data_array(7 downto 0);
        signal soft_output_temp_24_in : input_data_array(7 downto 0);
        signal soft_output_temp_25_in : input_data_array(7 downto 0);
        signal soft_output_temp_26_in : input_data_array(7 downto 0);
        signal soft_output_temp_27_in : input_data_array(7 downto 0);
        signal soft_output_temp_28_in : input_data_array(7 downto 0);
        signal soft_output_temp_29_in : input_data_array(7 downto 0);
        signal soft_output_temp_30_in : input_data_array(7 downto 0);
        signal soft_output_temp_31_in : input_data_array(7 downto 0);
        signal soft_output_temp_32_in : input_data_array(7 downto 0);
        signal index_temp_1_in        : index_array(7 downto 0);
        signal index_temp_2_in        : index_array(7 downto 0);
        signal index_temp_3_in        : index_array(7 downto 0);
        signal index_temp_4_in        : index_array(7 downto 0);
        signal index_temp_5_in        : index_array(7 downto 0);
        signal index_temp_6_in        : index_array(7 downto 0);
        signal index_temp_7_in        : index_array(7 downto 0);
        signal index_temp_8_in        : index_array(7 downto 0);
        signal index_temp_9_in        : index_array(7 downto 0);
        signal index_temp_10_in       : index_array(7 downto 0);
        signal index_temp_11_in       : index_array(7 downto 0);
        signal index_temp_12_in       : index_array(7 downto 0);
        signal index_temp_13_in       : index_array(7 downto 0);
        signal index_temp_14_in       : index_array(7 downto 0);
        signal index_temp_15_in       : index_array(7 downto 0);
        signal index_temp_16_in       : index_array(7 downto 0);
        signal index_temp_17_in       : index_array(7 downto 0);
        signal index_temp_18_in       : index_array(7 downto 0);
        signal index_temp_19_in       : index_array(7 downto 0);
        signal index_temp_20_in       : index_array(7 downto 0);
        signal index_temp_21_in       : index_array(7 downto 0);
        signal index_temp_22_in       : index_array(7 downto 0);
        signal index_temp_23_in       : index_array(7 downto 0);
        signal index_temp_24_in       : index_array(7 downto 0);
        signal index_temp_25_in       : index_array(7 downto 0);
        signal index_temp_26_in       : index_array(7 downto 0);
        signal index_temp_27_in       : index_array(7 downto 0);
        signal index_temp_28_in       : index_array(7 downto 0);
        signal index_temp_29_in       : index_array(7 downto 0);
        signal index_temp_30_in       : index_array(7 downto 0);
        signal index_temp_31_in       : index_array(7 downto 0);
        signal index_temp_32_in       : index_array(7 downto 0);
        signal index_out_1            : index_array(7 downto 0);
        signal index_out_2            : index_array(7 downto 0);
        signal index_out_3            : index_array(7 downto 0);
        signal index_out_4            : index_array(7 downto 0);
        signal index_out_5            : index_array(7 downto 0);
        signal index_out_6            : index_array(7 downto 0);
        signal index_out_7            : index_array(7 downto 0);
        signal index_out_8            : index_array(7 downto 0);
        signal index_out_9            : index_array(7 downto 0);
        signal index_out_10           : index_array(7 downto 0);
        signal index_out_11           : index_array(7 downto 0);
        signal index_out_12           : index_array(7 downto 0);
        signal index_out_13           : index_array(7 downto 0);
        signal index_out_14           : index_array(7 downto 0);
        signal index_out_15           : index_array(7 downto 0);
        signal index_out_16           : index_array(7 downto 0);
        signal soft_output_out_1      : input_data_array(7 downto 0);
        signal soft_output_out_2      : input_data_array(7 downto 0);
        signal soft_output_out_3      : input_data_array(7 downto 0);
        signal soft_output_out_4      : input_data_array(7 downto 0);
        signal soft_output_out_5      : input_data_array(7 downto 0);
        signal soft_output_out_6      : input_data_array(7 downto 0);
        signal soft_output_out_7      : input_data_array(7 downto 0);
        signal soft_output_out_8      : input_data_array(7 downto 0);
        signal soft_output_out_9      : input_data_array(7 downto 0);
        signal soft_output_out_10     : input_data_array(7 downto 0);
        signal soft_output_out_11     : input_data_array(7 downto 0);
        signal soft_output_out_12     : input_data_array(7 downto 0);
        signal soft_output_out_13     : input_data_array(7 downto 0);
        signal soft_output_out_14     : input_data_array(7 downto 0);
        signal soft_output_out_15     : input_data_array(7 downto 0);
        signal soft_output_out_16     : input_data_array(7 downto 0);
        ------------------------------------------------------------------------------------------------------------
        signal soft_output_temp_1_1_in  : input_data_array(7 downto 0);
        signal soft_output_temp_1_2_in  : input_data_array(7 downto 0);
        signal soft_output_temp_1_3_in  : input_data_array(7 downto 0);
        signal soft_output_temp_1_4_in  : input_data_array(7 downto 0);
        signal soft_output_temp_1_5_in  : input_data_array(7 downto 0);
        signal soft_output_temp_1_6_in  : input_data_array(7 downto 0);
        signal soft_output_temp_1_7_in  : input_data_array(7 downto 0);
        signal soft_output_temp_1_8_in  : input_data_array(7 downto 0);
        signal soft_output_temp_1_9_in  : input_data_array(7 downto 0);
        signal soft_output_temp_1_10_in : input_data_array(7 downto 0);
        signal soft_output_temp_1_11_in : input_data_array(7 downto 0);
        signal soft_output_temp_1_12_in : input_data_array(7 downto 0);
        signal soft_output_temp_1_13_in : input_data_array(7 downto 0);
        signal soft_output_temp_1_14_in : input_data_array(7 downto 0);
        signal soft_output_temp_1_15_in : input_data_array(7 downto 0);
        signal soft_output_temp_1_16_in : input_data_array(7 downto 0);
        signal index_temp_1_1_in        : index_array(7 downto 0);
        signal index_temp_1_2_in        : index_array(7 downto 0);
        signal index_temp_1_3_in        : index_array(7 downto 0);
        signal index_temp_1_4_in        : index_array(7 downto 0);
        signal index_temp_1_5_in        : index_array(7 downto 0);
        signal index_temp_1_6_in        : index_array(7 downto 0);
        signal index_temp_1_7_in        : index_array(7 downto 0);
        signal index_temp_1_8_in        : index_array(7 downto 0);
        signal index_temp_1_9_in        : index_array(7 downto 0);
        signal index_temp_1_10_in       : index_array(7 downto 0);
        signal index_temp_1_11_in       : index_array(7 downto 0);
        signal index_temp_1_12_in       : index_array(7 downto 0);
        signal index_temp_1_13_in       : index_array(7 downto 0);
        signal index_temp_1_14_in       : index_array(7 downto 0);
        signal index_temp_1_15_in       : index_array(7 downto 0);
        signal index_temp_1_16_in       : index_array(7 downto 0);
        signal index_out_1_1            : index_array(7 downto 0);
        signal index_out_1_2            : index_array(7 downto 0);
        signal index_out_1_3            : index_array(7 downto 0);
        signal index_out_1_4            : index_array(7 downto 0);
        signal index_out_1_5            : index_array(7 downto 0);
        signal index_out_1_6            : index_array(7 downto 0);
        signal index_out_1_7            : index_array(7 downto 0);
        signal index_out_1_8            : index_array(7 downto 0);
        signal soft_output_out_1_1      : input_data_array(7 downto 0);
        signal soft_output_out_1_2      : input_data_array(7 downto 0);
        signal soft_output_out_1_3      : input_data_array(7 downto 0);
        signal soft_output_out_1_4      : input_data_array(7 downto 0);
        signal soft_output_out_1_5      : input_data_array(7 downto 0);
        signal soft_output_out_1_6      : input_data_array(7 downto 0);
        signal soft_output_out_1_7      : input_data_array(7 downto 0);
        signal soft_output_out_1_8      : input_data_array(7 downto 0);
        ------------------------------------------------------------------------------------------------------------
        signal soft_output_temp_2_1_in : input_data_array(7 downto 0);
        signal soft_output_temp_2_2_in : input_data_array(7 downto 0);
        signal soft_output_temp_2_3_in : input_data_array(7 downto 0);
        signal soft_output_temp_2_4_in : input_data_array(7 downto 0);
        signal soft_output_temp_2_5_in : input_data_array(7 downto 0);
        signal soft_output_temp_2_6_in : input_data_array(7 downto 0);
        signal soft_output_temp_2_7_in : input_data_array(7 downto 0);
        signal soft_output_temp_2_8_in : input_data_array(7 downto 0);
        signal index_temp_2_1_in       : index_array(7 downto 0);
        signal index_temp_2_2_in       : index_array(7 downto 0);
        signal index_temp_2_3_in       : index_array(7 downto 0);
        signal index_temp_2_4_in       : index_array(7 downto 0);
        signal index_temp_2_5_in       : index_array(7 downto 0);
        signal index_temp_2_6_in       : index_array(7 downto 0);
        signal index_temp_2_7_in       : index_array(7 downto 0);
        signal index_temp_2_8_in       : index_array(7 downto 0);
        signal index_out_2_1           : index_array(7 downto 0);
        signal index_out_2_2           : index_array(7 downto 0);
        signal index_out_2_3           : index_array(7 downto 0);
        signal index_out_2_4           : index_array(7 downto 0);
        signal soft_output_out_2_1     : input_data_array(7 downto 0);
        signal soft_output_out_2_2     : input_data_array(7 downto 0);
        signal soft_output_out_2_3     : input_data_array(7 downto 0);
        signal soft_output_out_2_4     : input_data_array(7 downto 0);
        ------------------------------------------------------------------------------------------------------------
        signal soft_output_temp_3_1_in : input_data_array(7 downto 0);
        signal soft_output_temp_3_2_in : input_data_array(7 downto 0);
        signal soft_output_temp_3_3_in : input_data_array(7 downto 0);
        signal soft_output_temp_3_4_in : input_data_array(7 downto 0);
        signal index_temp_3_1_in       : index_array(7 downto 0);
        signal index_temp_3_2_in       : index_array(7 downto 0);
        signal index_temp_3_3_in       : index_array(7 downto 0);
        signal index_temp_3_4_in       : index_array(7 downto 0);
        signal index_out_3_1           : index_array(7 downto 0);
        signal index_out_3_2           : index_array(7 downto 0);
        signal soft_output_out_3_1     : input_data_array(7 downto 0);
        signal soft_output_out_3_2     : input_data_array(7 downto 0);
        ------------------------------------------------------------------------------------------------------------
        signal soft_output_temp_4_1_in : input_data_array(7 downto 0);
        signal soft_output_temp_4_2_in : input_data_array(7 downto 0);
        signal index_temp_4_1_in       : index_array(7 downto 0);
        signal index_temp_4_2_in       : index_array(7 downto 0);
        signal index_out_4_1           : index_array(7 downto 0);
        signal soft_output_out_4_1     : input_data_array(7 downto 0);
        ------------------------------------------------------------------------------------------------------------
        signal index_power_0      : index_array(7 downto 0);
        signal index_power_1      : index_array(7 downto 0);
        signal index_power_2      : index_array(7 downto 0);
        signal index_power_3      : index_array(7 downto 0);
        signal soft_power_0       : input_data_array(255 downto 0);
        signal soft_power_1       : input_data_array(255 downto 0);
        signal soft_power_2       : input_data_array(255 downto 0);
        signal soft_power_3       : input_data_array(255 downto 0);
        signal index_power_pass_0 : index_array(7 downto 0);
        signal soft_power_pass_0  : input_data_array(255 downto 0);
        signal index_power_pass_1 : index_array(7 downto 0);
        signal soft_power_pass_1  : input_data_array(255 downto 0);
        component sorting_compo is
                port (
                        clk         : in std_logic;
                        reset       : in std_logic;
                        soft_input  : in input_data_array(7 downto 0);
                        index       : out index_array(7 downto 0);
                        soft_output : out input_data_array(7 downto 0)
                );
        end component;

        component sorting_compo_1 is
                port (
                        clk         : in std_logic;
                        reset       : in std_logic;
                        soft_input  : in input_data_array(7 downto 0);
                        index       : out index_array(7 downto 0);
                        soft_output : out input_data_array(7 downto 0)
                );
        end component;

        component sorting_compo_2 is
                port (
                        clk         : in std_logic;
                        reset       : in std_logic;
                        soft_input  : in input_data_array(7 downto 0);
                        index       : out index_array(7 downto 0);
                        soft_output : out input_data_array(7 downto 0)
                );
        end component;

        component sorting_compo_3 is
                port (
                        clk         : in std_logic;
                        reset       : in std_logic;
                        soft_input  : in input_data_array(7 downto 0);
                        index       : out index_array(7 downto 0);
                        soft_output : out input_data_array(7 downto 0)
                );
        end component;

        component sorting_compo_4 is
                port (
                        clk         : in std_logic;
                        reset       : in std_logic;
                        soft_input  : in input_data_array(7 downto 0);
                        index       : out index_array(7 downto 0);
                        soft_output : out input_data_array(7 downto 0)
                );
        end component;

        component sorting_compo_5 is
                port (
                        clk         : in std_logic;
                        reset       : in std_logic;
                        soft_input  : in input_data_array(7 downto 0);
                        index       : out index_array(7 downto 0);
                        soft_output : out input_data_array(7 downto 0)
                );
        end component;

        component sorting_compo_6 is
                port (
                        clk         : in std_logic;
                        reset       : in std_logic;
                        soft_input  : in input_data_array(7 downto 0);
                        index       : out index_array(7 downto 0);
                        soft_output : out input_data_array(7 downto 0)
                );
        end component;

        component sorting_compo_7 is
                port (
                        clk         : in std_logic;
                        reset       : in std_logic;
                        soft_input  : in input_data_array(7 downto 0);
                        index       : out index_array(7 downto 0);
                        soft_output : out input_data_array(7 downto 0)
                );
        end component;

        component sorting_compo_8 is
                port (
                        clk         : in std_logic;
                        reset       : in std_logic;
                        soft_input  : in input_data_array(7 downto 0);
                        index       : out index_array(7 downto 0);
                        soft_output : out input_data_array(7 downto 0)
                );
        end component;

        component sorting_compo_9 is
                port (
                        clk         : in std_logic;
                        reset       : in std_logic;
                        soft_input  : in input_data_array(7 downto 0);
                        index       : out index_array(7 downto 0);
                        soft_output : out input_data_array(7 downto 0)
                );
        end component;

        component sorting_compo_10 is
                port (
                        clk         : in std_logic;
                        reset       : in std_logic;
                        soft_input  : in input_data_array(7 downto 0);
                        index       : out index_array(7 downto 0);
                        soft_output : out input_data_array(7 downto 0)
                );
        end component;

        component sorting_compo_11 is
                port (
                        clk         : in std_logic;
                        reset       : in std_logic;
                        soft_input  : in input_data_array(7 downto 0);
                        index       : out index_array(7 downto 0);
                        soft_output : out input_data_array(7 downto 0)
                );
        end component;

        component sorting_compo_12 is
                port (
                        clk         : in std_logic;
                        reset       : in std_logic;
                        soft_input  : in input_data_array(7 downto 0);
                        index       : out index_array(7 downto 0);
                        soft_output : out input_data_array(7 downto 0)
                );
        end component;

        component sorting_compo_13 is
                port (
                        clk         : in std_logic;
                        reset       : in std_logic;
                        soft_input  : in input_data_array(7 downto 0);
                        index       : out index_array(7 downto 0);
                        soft_output : out input_data_array(7 downto 0)
                );
        end component;

        component sorting_compo_14 is
                port (
                        clk         : in std_logic;
                        reset       : in std_logic;
                        soft_input  : in input_data_array(7 downto 0);
                        index       : out index_array(7 downto 0);
                        soft_output : out input_data_array(7 downto 0)
                );
        end component;

        component sorting_compo_15 is
                port (
                        clk         : in std_logic;
                        reset       : in std_logic;
                        soft_input  : in input_data_array(7 downto 0);
                        index       : out index_array(7 downto 0);
                        soft_output : out input_data_array(7 downto 0)
                );
        end component;

        component sorting_compo_16 is
                port (
                        clk         : in std_logic;
                        reset       : in std_logic;
                        soft_input  : in input_data_array(7 downto 0);
                        index       : out index_array(7 downto 0);
                        soft_output : out input_data_array(7 downto 0)
                );
        end component;

        component sorting_compo_17 is
                port (
                        clk         : in std_logic;
                        reset       : in std_logic;
                        soft_input  : in input_data_array(7 downto 0);
                        index       : out index_array(7 downto 0);
                        soft_output : out input_data_array(7 downto 0)
                );
        end component;

        component sorting_compo_18 is
                port (
                        clk         : in std_logic;
                        reset       : in std_logic;
                        soft_input  : in input_data_array(7 downto 0);
                        index       : out index_array(7 downto 0);
                        soft_output : out input_data_array(7 downto 0)
                );
        end component;

        component sorting_compo_19 is
                port (
                        clk         : in std_logic;
                        reset       : in std_logic;
                        soft_input  : in input_data_array(7 downto 0);
                        index       : out index_array(7 downto 0);
                        soft_output : out input_data_array(7 downto 0)
                );
        end component;

        component sorting_compo_20 is
                port (
                        clk         : in std_logic;
                        reset       : in std_logic;
                        soft_input  : in input_data_array(7 downto 0);
                        index       : out index_array(7 downto 0);
                        soft_output : out input_data_array(7 downto 0)
                );
        end component;

        component sorting_compo_21 is
                port (
                        clk         : in std_logic;
                        reset       : in std_logic;
                        soft_input  : in input_data_array(7 downto 0);
                        index       : out index_array(7 downto 0);
                        soft_output : out input_data_array(7 downto 0)
                );
        end component;

        component sorting_compo_22 is
                port (
                        clk         : in std_logic;
                        reset       : in std_logic;
                        soft_input  : in input_data_array(7 downto 0);
                        index       : out index_array(7 downto 0);
                        soft_output : out input_data_array(7 downto 0)
                );
        end component;

        component sorting_compo_23 is
                port (
                        clk         : in std_logic;
                        reset       : in std_logic;
                        soft_input  : in input_data_array(7 downto 0);
                        index       : out index_array(7 downto 0);
                        soft_output : out input_data_array(7 downto 0)
                );
        end component;

        component sorting_compo_24 is
                port (
                        clk         : in std_logic;
                        reset       : in std_logic;
                        soft_input  : in input_data_array(7 downto 0);
                        index       : out index_array(7 downto 0);
                        soft_output : out input_data_array(7 downto 0)
                );
        end component;

        component sorting_compo_25 is
                port (
                        clk         : in std_logic;
                        reset       : in std_logic;
                        soft_input  : in input_data_array(7 downto 0);
                        index       : out index_array(7 downto 0);
                        soft_output : out input_data_array(7 downto 0)
                );
        end component;

        component sorting_compo_26 is
                port (
                        clk         : in std_logic;
                        reset       : in std_logic;
                        soft_input  : in input_data_array(7 downto 0);
                        index       : out index_array(7 downto 0);
                        soft_output : out input_data_array(7 downto 0)
                );
        end component;

        component sorting_compo_27 is
                port (
                        clk         : in std_logic;
                        reset       : in std_logic;
                        soft_input  : in input_data_array(7 downto 0);
                        index       : out index_array(7 downto 0);
                        soft_output : out input_data_array(7 downto 0)
                );
        end component;

        component sorting_compo_28 is
                port (
                        clk         : in std_logic;
                        reset       : in std_logic;
                        soft_input  : in input_data_array(7 downto 0);
                        index       : out index_array(7 downto 0);
                        soft_output : out input_data_array(7 downto 0)
                );
        end component;

        component sorting_compo_29 is
                port (
                        clk         : in std_logic;
                        reset       : in std_logic;
                        soft_input  : in input_data_array(7 downto 0);
                        index       : out index_array(7 downto 0);
                        soft_output : out input_data_array(7 downto 0)
                );
        end component;

        component sorting_compo_30 is
                port (
                        clk         : in std_logic;
                        reset       : in std_logic;
                        soft_input  : in input_data_array(7 downto 0);
                        index       : out index_array(7 downto 0);
                        soft_output : out input_data_array(7 downto 0)
                );
        end component;

        component sorting_compo_31 is
                port (
                        clk         : in std_logic;
                        reset       : in std_logic;
                        soft_input  : in input_data_array(7 downto 0);
                        index       : out index_array(7 downto 0);
                        soft_output : out input_data_array(7 downto 0)
                );
        end component;

        component sorting_merge is
                port (
                        clk         : in std_logic;
                        reset       : in std_logic;
                        A           : in input_data_array(7 downto 0);
                        B           : in input_data_array(7 downto 0);
                        index_A     : in index_array(7 downto 0);
                        index_B     : in index_array(7 downto 0);
                        index       : out index_array(7 downto 0);
                        soft_output : out input_data_array(7 downto 0)
                );
        end component;

        component sorting_pass_1 is
                port (
                        clk         : in std_logic;
                        reset       : in std_logic;
                        soft_input  : in input_data_array(255 downto 0);
                        soft_output : out input_data_array(255 downto 0)
                );
        end component;

        component sorting_pass_2 is
                port (
                        clk         : in std_logic;
                        reset       : in std_logic;
                        soft_input  : in input_data_array(255 downto 0);
                        soft_output : out input_data_array(255 downto 0)
                );
        end component;

begin
        sorting_pass_1_block : sorting_pass_1 -- data passing for the sorting_compo
        port map(clk, reset, soft_input_pass_1, soft_output_pass_1);
        sorting_compo_1_block : sorting_compo -- port mapping for the sorting_compo
        port map(clk, reset, soft_input_temp_1, index_temp_1, soft_output_temp_1);
        sorting_compo_2_block : sorting_compo_1 -- port mapping for the sorting_compo
        port map(clk, reset, soft_input_temp_2, index_temp_2, soft_output_temp_2);
        sorting_compo_3_block : sorting_compo_2 -- port mapping for the sorting_compo
        port map(clk, reset, soft_input_temp_3, index_temp_3, soft_output_temp_3);
        sorting_compo_4_block : sorting_compo_3 -- port mapping for the sorting_compo
        port map(clk, reset, soft_input_temp_4, index_temp_4, soft_output_temp_4);
        sorting_compo_5_block : sorting_compo_4 -- port mapping for the sorting_compo
        port map(clk, reset, soft_input_temp_5, index_temp_5, soft_output_temp_5);
        sorting_compo_6_block : sorting_compo_5 -- port mapping for the sorting_compo
        port map(clk, reset, soft_input_temp_6, index_temp_6, soft_output_temp_6);
        sorting_compo_7_block : sorting_compo_6 -- port mapping for the sorting_compo
        port map(clk, reset, soft_input_temp_7, index_temp_7, soft_output_temp_7);
        sorting_compo_8_block : sorting_compo_7 -- port mapping for the sorting_compo
        port map(clk, reset, soft_input_temp_8, index_temp_8, soft_output_temp_8);
        sorting_compo_9_block : sorting_compo_8 -- port mapping for the sorting_compo
        port map(clk, reset, soft_input_temp_9, index_temp_9, soft_output_temp_9);
        sorting_compo_10_block : sorting_compo_9 -- port mapping for the sorting_compo
        port map(clk, reset, soft_input_temp_10, index_temp_10, soft_output_temp_10);
        sorting_compo_11_block : sorting_compo_10 -- port mapping for the sorting_compo
        port map(clk, reset, soft_input_temp_11, index_temp_11, soft_output_temp_11);
        sorting_compo_12_block : sorting_compo_11 -- port mapping for the sorting_compo
        port map(clk, reset, soft_input_temp_12, index_temp_12, soft_output_temp_12);
        sorting_compo_13_block : sorting_compo_12 -- port mapping for the sorting_compo
        port map(clk, reset, soft_input_temp_13, index_temp_13, soft_output_temp_13);
        sorting_compo_14_block : sorting_compo_13 -- port mapping for the sorting_compo
        port map(clk, reset, soft_input_temp_14, index_temp_14, soft_output_temp_14);
        sorting_compo_15_block : sorting_compo_14 -- port mapping for the sorting_compo
        port map(clk, reset, soft_input_temp_15, index_temp_15, soft_output_temp_15);
        sorting_compo_16_block : sorting_compo_15 -- port mapping for the sorting_compo
        port map(clk, reset, soft_input_temp_16, index_temp_16, soft_output_temp_16);
        sorting_compo_17_block : sorting_compo_16 -- port mapping for the sorting_compo
        port map(clk, reset, soft_input_temp_17, index_temp_17, soft_output_temp_17);
        sorting_compo_18_block : sorting_compo_17 -- port mapping for the sorting_compo
        port map(clk, reset, soft_input_temp_18, index_temp_18, soft_output_temp_18);
        sorting_compo_19_block : sorting_compo_18 -- port mapping for the sorting_compo
        port map(clk, reset, soft_input_temp_19, index_temp_19, soft_output_temp_19);
        sorting_compo_20_block : sorting_compo_19 -- port mapping for the sorting_compo
        port map(clk, reset, soft_input_temp_20, index_temp_20, soft_output_temp_20);
        sorting_compo_21_block : sorting_compo_20 -- port mapping for the sorting_compo
        port map(clk, reset, soft_input_temp_21, index_temp_21, soft_output_temp_21);
        sorting_compo_22_block : sorting_compo_21 -- port mapping for the sorting_compo
        port map(clk, reset, soft_input_temp_22, index_temp_22, soft_output_temp_22);
        sorting_compo_23_block : sorting_compo_22 -- port mapping for the sorting_compo
        port map(clk, reset, soft_input_temp_23, index_temp_23, soft_output_temp_23);
        sorting_compo_24_block : sorting_compo_23 -- port mapping for the sorting_compo
        port map(clk, reset, soft_input_temp_24, index_temp_24, soft_output_temp_24);
        sorting_compo_25_block : sorting_compo_24 -- port mapping for the sorting_compo
        port map(clk, reset, soft_input_temp_25, index_temp_25, soft_output_temp_25);
        sorting_compo_26_block : sorting_compo_25 -- port mapping for the sorting_compo
        port map(clk, reset, soft_input_temp_26, index_temp_26, soft_output_temp_26);
        sorting_compo_27_block : sorting_compo_26 -- port mapping for the sorting_compo
        port map(clk, reset, soft_input_temp_27, index_temp_27, soft_output_temp_27);
        sorting_compo_28_block : sorting_compo_27 -- port mapping for the sorting_compo
        port map(clk, reset, soft_input_temp_28, index_temp_28, soft_output_temp_28);
        sorting_compo_29_block : sorting_compo_28 -- port mapping for the sorting_compo
        port map(clk, reset, soft_input_temp_29, index_temp_29, soft_output_temp_29);
        sorting_compo_30_block : sorting_compo_29 -- port mapping for the sorting_compo
        port map(clk, reset, soft_input_temp_30, index_temp_30, soft_output_temp_30);
        sorting_compo_31_block : sorting_compo_30 -- port mapping for the sorting_compo
        port map(clk, reset, soft_input_temp_31, index_temp_31, soft_output_temp_31);
        sorting_compo_32_block : sorting_compo_31 -- port mapping for the sorting_compo
        port map(clk, reset, soft_input_temp_32, index_temp_32, soft_output_temp_32);

        sorting_pass_2_block : sorting_pass_2 -- data passing for the sorting_merge
        port map(clk, reset, soft_input_pass_2, soft_output_pass_2);
        sorting_merge_1_block : sorting_merge -- port mapping for the sorting_merge
        port map(clk, reset, soft_output_temp_1_in, soft_output_temp_2_in, index_temp_1_in, index_temp_2_in, index_out_1, soft_output_out_1);
        sorting_merge_2_block : sorting_merge -- port mapping for the sorting_merge
        port map(clk, reset, soft_output_temp_3_in, soft_output_temp_4_in, index_temp_3_in, index_temp_4_in, index_out_2, soft_output_out_2);
        sorting_merge_3_block : sorting_merge -- port mapping for the sorting_merge
        port map(clk, reset, soft_output_temp_5_in, soft_output_temp_6_in, index_temp_5_in, index_temp_6_in, index_out_3, soft_output_out_3);
        sorting_merge_4_block : sorting_merge -- port mapping for the sorting_merge
        port map(clk, reset, soft_output_temp_7_in, soft_output_temp_8_in, index_temp_7_in, index_temp_8_in, index_out_4, soft_output_out_4);
        sorting_merge_5_block : sorting_merge -- port mapping for the sorting_merge
        port map(clk, reset, soft_output_temp_9_in, soft_output_temp_10_in, index_temp_9_in, index_temp_10_in, index_out_5, soft_output_out_5);
        sorting_merge_6_block : sorting_merge -- port mapping for the sorting_merge
        port map(clk, reset, soft_output_temp_11_in, soft_output_temp_12_in, index_temp_11_in, index_temp_12_in, index_out_6, soft_output_out_6);
        sorting_merge_7_block : sorting_merge -- port mapping for the sorting_merge
        port map(clk, reset, soft_output_temp_13_in, soft_output_temp_14_in, index_temp_13_in, index_temp_14_in, index_out_7, soft_output_out_7);
        sorting_merge_8_block : sorting_merge -- port mapping for the sorting_merge
        port map(clk, reset, soft_output_temp_15_in, soft_output_temp_16_in, index_temp_15_in, index_temp_16_in, index_out_8, soft_output_out_8);
        sorting_merge_9_block : sorting_merge -- port mapping for the sorting_merge
        port map(clk, reset, soft_output_temp_17_in, soft_output_temp_18_in, index_temp_17_in, index_temp_18_in, index_out_9, soft_output_out_9);
        sorting_merge_10_block : sorting_merge -- port mapping for the sorting_merge
        port map(clk, reset, soft_output_temp_19_in, soft_output_temp_20_in, index_temp_19_in, index_temp_20_in, index_out_10, soft_output_out_10);
        sorting_merge_11_block : sorting_merge -- port mapping for the sorting_merge
        port map(clk, reset, soft_output_temp_21_in, soft_output_temp_22_in, index_temp_21_in, index_temp_22_in, index_out_11, soft_output_out_11);
        sorting_merge_12_block : sorting_merge -- port mapping for the sorting_merge
        port map(clk, reset, soft_output_temp_23_in, soft_output_temp_24_in, index_temp_23_in, index_temp_24_in, index_out_12, soft_output_out_12);
        sorting_merge_13_block : sorting_merge -- port mapping for the sorting_merge
        port map(clk, reset, soft_output_temp_25_in, soft_output_temp_26_in, index_temp_25_in, index_temp_26_in, index_out_13, soft_output_out_13);
        sorting_merge_14_block : sorting_merge -- port mapping for the sorting_merge
        port map(clk, reset, soft_output_temp_27_in, soft_output_temp_28_in, index_temp_27_in, index_temp_28_in, index_out_14, soft_output_out_14);
        sorting_merge_15_block : sorting_merge -- port mapping for the sorting_merge
        port map(clk, reset, soft_output_temp_29_in, soft_output_temp_30_in, index_temp_29_in, index_temp_30_in, index_out_15, soft_output_out_15);
        sorting_merge_16_block : sorting_merge -- port mapping for the sorting_merge
        port map(clk, reset, soft_output_temp_31_in, soft_output_temp_32_in, index_temp_31_in, index_temp_32_in, index_out_16, soft_output_out_16);

        sorting_pass_2_block_1 : sorting_pass_2 -- data passing for the sorting_merge
        port map(clk, reset, soft_input_pass_3, soft_output_pass_3);
        sorting_merge_1_1_block : sorting_merge -- port mapping for the sorting_merge
        port map(clk, reset, soft_output_temp_1_1_in, soft_output_temp_1_2_in, index_temp_1_1_in, index_temp_1_2_in, index_out_1_1, soft_output_out_1_1);
        sorting_merge_2_1_block : sorting_merge -- port mapping for the sorting_merge
        port map(clk, reset, soft_output_temp_1_3_in, soft_output_temp_1_4_in, index_temp_1_3_in, index_temp_1_4_in, index_out_1_2, soft_output_out_1_2);
        sorting_merge_3_1_block : sorting_merge -- port mapping for the sorting_merge
        port map(clk, reset, soft_output_temp_1_5_in, soft_output_temp_1_6_in, index_temp_1_5_in, index_temp_1_6_in, index_out_1_3, soft_output_out_1_3);
        sorting_merge_4_1_block : sorting_merge -- port mapping for the sorting_merge
        port map(clk, reset, soft_output_temp_1_7_in, soft_output_temp_1_8_in, index_temp_1_7_in, index_temp_1_8_in, index_out_1_4, soft_output_out_1_4);
        sorting_merge_5_1_block : sorting_merge -- port mapping for the sorting_merge
        port map(clk, reset, soft_output_temp_1_9_in, soft_output_temp_1_10_in, index_temp_1_9_in, index_temp_1_10_in, index_out_1_5, soft_output_out_1_5);
        sorting_merge_6_1_block : sorting_merge -- port mapping for the sorting_merge
        port map(clk, reset, soft_output_temp_1_11_in, soft_output_temp_1_12_in, index_temp_1_11_in, index_temp_1_12_in, index_out_1_6, soft_output_out_1_6);
        sorting_merge_7_1_block : sorting_merge -- port mapping for the sorting_merge
        port map(clk, reset, soft_output_temp_1_13_in, soft_output_temp_1_14_in, index_temp_1_13_in, index_temp_1_14_in, index_out_1_7, soft_output_out_1_7);
        sorting_merge_8_1_block : sorting_merge -- port mapping for the sorting_merge
        port map(clk, reset, soft_output_temp_1_15_in, soft_output_temp_1_16_in, index_temp_1_15_in, index_temp_1_16_in, index_out_1_8, soft_output_out_1_8);

        sorting_pass_2_block_2 : sorting_pass_2 -- data passing for the sorting_merge
        port map(clk, reset, soft_input_pass_4, soft_output_pass_4);
        sorting_merge_1_2_block : sorting_merge -- port mapping for the sorting_merge
        port map(clk, reset, soft_output_temp_2_1_in, soft_output_temp_2_2_in, index_temp_2_1_in, index_temp_2_2_in, index_out_2_1, soft_output_out_2_1);
        sorting_merge_2_2_block : sorting_merge -- port mapping for the sorting_merge
        port map(clk, reset, soft_output_temp_2_3_in, soft_output_temp_2_4_in, index_temp_2_3_in, index_temp_2_4_in, index_out_2_2, soft_output_out_2_2);
        sorting_merge_3_2_block : sorting_merge -- port mapping for the sorting_merge
        port map(clk, reset, soft_output_temp_2_5_in, soft_output_temp_2_6_in, index_temp_2_5_in, index_temp_2_6_in, index_out_2_3, soft_output_out_2_3);
        sorting_merge_4_2_block : sorting_merge -- port mapping for the sorting_merge
        port map(clk, reset, soft_output_temp_2_7_in, soft_output_temp_2_8_in, index_temp_2_7_in, index_temp_2_8_in, index_out_2_4, soft_output_out_2_4);

        sorting_pass_2_block_3 : sorting_pass_2 -- data passing for the sorting_merge
        port map(clk, reset, soft_input_pass_5, soft_output_pass_5);
        sorting_merge_1_3_block : sorting_merge -- port mapping for the sorting_merge
        port map(clk, reset, soft_output_temp_3_1_in, soft_output_temp_3_2_in, index_temp_3_1_in, index_temp_3_2_in, index_out_3_1, soft_output_out_3_1);
        sorting_merge_2_3_block : sorting_merge -- port mapping for the sorting_merge
        port map(clk, reset, soft_output_temp_3_3_in, soft_output_temp_3_4_in, index_temp_3_3_in, index_temp_3_4_in, index_out_3_2, soft_output_out_3_2);

        sorting_pass_2_block_4 : sorting_pass_2 -- data passing for the sorting_merge
        port map(clk, reset, soft_input_pass_6, soft_output_pass_6);
        sorting_merge_1_4_block : sorting_merge -- port mapping for the sorting_merge
        port map(clk, reset, soft_output_temp_4_1_in, soft_output_temp_4_2_in, index_temp_4_1_in, index_temp_4_2_in, index_out_4_1, soft_output_out_4_1);
        ------------------------------------------------------------------------------------------------------------
        -- Define processes : (CLK 1)
        ------------------------------------------------------------------------------------------------------------
        process (clk, reset)
        begin
                if (reset = '1') then
                        soft_input_temp_1  <= (others => (others => '0'));
                        soft_input_temp_2  <= (others => (others => '0'));
                        soft_input_temp_3  <= (others => (others => '0'));
                        soft_input_temp_4  <= (others => (others => '0'));
                        soft_input_temp_5  <= (others => (others => '0'));
                        soft_input_temp_6  <= (others => (others => '0'));
                        soft_input_temp_7  <= (others => (others => '0'));
                        soft_input_temp_8  <= (others => (others => '0'));
                        soft_input_temp_9  <= (others => (others => '0'));
                        soft_input_temp_10 <= (others => (others => '0'));
                        soft_input_temp_11 <= (others => (others => '0'));
                        soft_input_temp_12 <= (others => (others => '0'));
                        soft_input_temp_13 <= (others => (others => '0'));
                        soft_input_temp_14 <= (others => (others => '0'));
                        soft_input_temp_15 <= (others => (others => '0'));
                        soft_input_temp_16 <= (others => (others => '0'));
                        soft_input_temp_17 <= (others => (others => '0'));
                        soft_input_temp_18 <= (others => (others => '0'));
                        soft_input_temp_19 <= (others => (others => '0'));
                        soft_input_temp_20 <= (others => (others => '0'));
                        soft_input_temp_21 <= (others => (others => '0'));
                        soft_input_temp_22 <= (others => (others => '0'));
                        soft_input_temp_23 <= (others => (others => '0'));
                        soft_input_temp_24 <= (others => (others => '0'));
                        soft_input_temp_25 <= (others => (others => '0'));
                        soft_input_temp_26 <= (others => (others => '0'));
                        soft_input_temp_27 <= (others => (others => '0'));
                        soft_input_temp_28 <= (others => (others => '0'));
                        soft_input_temp_29 <= (others => (others => '0'));
                        soft_input_temp_30 <= (others => (others => '0'));
                        soft_input_temp_31 <= (others => (others => '0'));
                        soft_input_temp_32 <= (others => (others => '0'));
                        soft_input_pass_1  <= (others => (others => '0'));
                elsif (rising_edge(clk)) then
                        soft_input_pass_1  <= soft_input;
                        soft_input_temp_1  <= soft_input(7 downto 0);
                        soft_input_temp_2  <= soft_input(15 downto 8);
                        soft_input_temp_3  <= soft_input(23 downto 16);
                        soft_input_temp_4  <= soft_input(31 downto 24);
                        soft_input_temp_5  <= soft_input(39 downto 32);
                        soft_input_temp_6  <= soft_input(47 downto 40);
                        soft_input_temp_7  <= soft_input(55 downto 48);
                        soft_input_temp_8  <= soft_input(63 downto 56);
                        soft_input_temp_9  <= soft_input(71 downto 64);
                        soft_input_temp_10 <= soft_input(79 downto 72);
                        soft_input_temp_11 <= soft_input(87 downto 80);
                        soft_input_temp_12 <= soft_input(95 downto 88);
                        soft_input_temp_13 <= soft_input(103 downto 96);
                        soft_input_temp_14 <= soft_input(111 downto 104);
                        soft_input_temp_15 <= soft_input(119 downto 112);
                        soft_input_temp_16 <= soft_input(127 downto 120);
                        soft_input_temp_17 <= soft_input(135 downto 128);
                        soft_input_temp_18 <= soft_input(143 downto 136);
                        soft_input_temp_19 <= soft_input(151 downto 144);
                        soft_input_temp_20 <= soft_input(159 downto 152);
                        soft_input_temp_21 <= soft_input(167 downto 160);
                        soft_input_temp_22 <= soft_input(175 downto 168);
                        soft_input_temp_23 <= soft_input(183 downto 176);
                        soft_input_temp_24 <= soft_input(191 downto 184);
                        soft_input_temp_25 <= soft_input(199 downto 192);
                        soft_input_temp_26 <= soft_input(207 downto 200);
                        soft_input_temp_27 <= soft_input(215 downto 208);
                        soft_input_temp_28 <= soft_input(223 downto 216);
                        soft_input_temp_29 <= soft_input(231 downto 224);
                        soft_input_temp_30 <= soft_input(239 downto 232);
                        soft_input_temp_31 <= soft_input(247 downto 240);
                        soft_input_temp_32 <= soft_input(255 downto 248);
                end if;
        end process;
        ------------------------------------------------------------------------------------------------------------
        -- Define processes : (CLK 3)
        ------------------------------------------------------------------------------------------------------------
        process (clk, reset)
        begin
                if (reset = '1') then
                        index_temp_1_in        <= (others => (others => '0'));
                        soft_output_temp_1_in  <= (others => (others => '0'));
                        index_temp_2_in        <= (others => (others => '0'));
                        soft_output_temp_2_in  <= (others => (others => '0'));
                        index_temp_3_in        <= (others => (others => '0'));
                        soft_output_temp_3_in  <= (others => (others => '0'));
                        index_temp_4_in        <= (others => (others => '0'));
                        soft_output_temp_4_in  <= (others => (others => '0'));
                        index_temp_5_in        <= (others => (others => '0'));
                        soft_output_temp_5_in  <= (others => (others => '0'));
                        index_temp_6_in        <= (others => (others => '0'));
                        soft_output_temp_6_in  <= (others => (others => '0'));
                        index_temp_7_in        <= (others => (others => '0'));
                        soft_output_temp_7_in  <= (others => (others => '0'));
                        index_temp_8_in        <= (others => (others => '0'));
                        soft_output_temp_8_in  <= (others => (others => '0'));
                        index_temp_9_in        <= (others => (others => '0'));
                        soft_output_temp_9_in  <= (others => (others => '0'));
                        index_temp_10_in       <= (others => (others => '0'));
                        soft_output_temp_10_in <= (others => (others => '0'));
                        index_temp_11_in       <= (others => (others => '0'));
                        soft_output_temp_11_in <= (others => (others => '0'));
                        index_temp_12_in       <= (others => (others => '0'));
                        soft_output_temp_12_in <= (others => (others => '0'));
                        index_temp_13_in       <= (others => (others => '0'));
                        soft_output_temp_13_in <= (others => (others => '0'));
                        index_temp_14_in       <= (others => (others => '0'));
                        soft_output_temp_14_in <= (others => (others => '0'));
                        index_temp_15_in       <= (others => (others => '0'));
                        soft_output_temp_15_in <= (others => (others => '0'));
                        index_temp_16_in       <= (others => (others => '0'));
                        soft_output_temp_16_in <= (others => (others => '0'));
                        index_temp_17_in       <= (others => (others => '0'));
                        soft_output_temp_17_in <= (others => (others => '0'));
                        index_temp_18_in       <= (others => (others => '0'));
                        soft_output_temp_18_in <= (others => (others => '0'));
                        index_temp_19_in       <= (others => (others => '0'));
                        soft_output_temp_19_in <= (others => (others => '0'));
                        index_temp_20_in       <= (others => (others => '0'));
                        soft_output_temp_20_in <= (others => (others => '0'));
                        index_temp_21_in       <= (others => (others => '0'));
                        soft_output_temp_21_in <= (others => (others => '0'));
                        index_temp_22_in       <= (others => (others => '0'));
                        soft_output_temp_22_in <= (others => (others => '0'));
                        index_temp_23_in       <= (others => (others => '0'));
                        soft_output_temp_23_in <= (others => (others => '0'));
                        index_temp_24_in       <= (others => (others => '0'));
                        soft_output_temp_24_in <= (others => (others => '0'));
                        index_temp_25_in       <= (others => (others => '0'));
                        soft_output_temp_25_in <= (others => (others => '0'));
                        index_temp_26_in       <= (others => (others => '0'));
                        soft_output_temp_26_in <= (others => (others => '0'));
                        index_temp_27_in       <= (others => (others => '0'));
                        soft_output_temp_27_in <= (others => (others => '0'));
                        index_temp_28_in       <= (others => (others => '0'));
                        soft_output_temp_28_in <= (others => (others => '0'));
                        index_temp_29_in       <= (others => (others => '0'));
                        soft_output_temp_29_in <= (others => (others => '0'));
                        index_temp_30_in       <= (others => (others => '0'));
                        soft_output_temp_30_in <= (others => (others => '0'));
                        index_temp_31_in       <= (others => (others => '0'));
                        soft_output_temp_31_in <= (others => (others => '0'));
                        index_temp_32_in       <= (others => (others => '0'));
                        soft_output_temp_32_in <= (others => (others => '0'));
                        soft_input_pass_2      <= (others => (others => '0'));
                elsif (rising_edge(clk)) then
                        soft_input_pass_2 <= soft_output_pass_1;
                        -- 1
                        index_temp_1_in       <= index_temp_1;
                        soft_output_temp_1_in <= soft_output_temp_1;
                        index_temp_2_in       <= index_temp_2;
                        soft_output_temp_2_in <= soft_output_temp_2;
                        -- 2
                        index_temp_3_in       <= index_temp_3;
                        soft_output_temp_3_in <= soft_output_temp_3;
                        index_temp_4_in       <= index_temp_4;
                        soft_output_temp_4_in <= soft_output_temp_4;
                        -- 3
                        index_temp_5_in       <= index_temp_5;
                        soft_output_temp_5_in <= soft_output_temp_5;
                        index_temp_6_in       <= index_temp_6;
                        soft_output_temp_6_in <= soft_output_temp_6;
                        -- 4
                        index_temp_7_in       <= index_temp_7;
                        soft_output_temp_7_in <= soft_output_temp_7;
                        index_temp_8_in       <= index_temp_8;
                        soft_output_temp_8_in <= soft_output_temp_8;
                        -- 5
                        index_temp_9_in        <= index_temp_9;
                        soft_output_temp_9_in  <= soft_output_temp_9;
                        index_temp_10_in       <= index_temp_10;
                        soft_output_temp_10_in <= soft_output_temp_10;
                        -- 6
                        index_temp_11_in       <= index_temp_11;
                        soft_output_temp_11_in <= soft_output_temp_11;
                        index_temp_12_in       <= index_temp_12;
                        soft_output_temp_12_in <= soft_output_temp_12;
                        -- 7
                        index_temp_13_in       <= index_temp_13;
                        soft_output_temp_13_in <= soft_output_temp_13;
                        index_temp_14_in       <= index_temp_14;
                        soft_output_temp_14_in <= soft_output_temp_14;
                        -- 8
                        index_temp_15_in       <= index_temp_15;
                        soft_output_temp_15_in <= soft_output_temp_15;
                        index_temp_16_in       <= index_temp_16;
                        soft_output_temp_16_in <= soft_output_temp_16;
                        -- 9
                        index_temp_17_in       <= index_temp_17;
                        soft_output_temp_17_in <= soft_output_temp_17;
                        index_temp_18_in       <= index_temp_18;
                        soft_output_temp_18_in <= soft_output_temp_18;
                        -- 10
                        index_temp_19_in       <= index_temp_19;
                        soft_output_temp_19_in <= soft_output_temp_19;
                        index_temp_20_in       <= index_temp_20;
                        soft_output_temp_20_in <= soft_output_temp_20;
                        -- 11
                        index_temp_21_in       <= index_temp_21;
                        soft_output_temp_21_in <= soft_output_temp_21;
                        index_temp_22_in       <= index_temp_22;
                        soft_output_temp_22_in <= soft_output_temp_22;
                        -- 12
                        index_temp_23_in       <= index_temp_23;
                        soft_output_temp_23_in <= soft_output_temp_23;
                        index_temp_24_in       <= index_temp_24;
                        soft_output_temp_24_in <= soft_output_temp_24;
                        -- 13
                        index_temp_25_in       <= index_temp_25;
                        soft_output_temp_25_in <= soft_output_temp_25;
                        index_temp_26_in       <= index_temp_26;
                        soft_output_temp_26_in <= soft_output_temp_26;
                        -- 14
                        index_temp_27_in       <= index_temp_27;
                        soft_output_temp_27_in <= soft_output_temp_27;
                        index_temp_28_in       <= index_temp_28;
                        soft_output_temp_28_in <= soft_output_temp_28;
                        -- 15
                        index_temp_29_in       <= index_temp_29;
                        soft_output_temp_29_in <= soft_output_temp_29;
                        index_temp_30_in       <= index_temp_30;
                        soft_output_temp_30_in <= soft_output_temp_30;
                        -- 16
                        index_temp_31_in       <= index_temp_31;
                        soft_output_temp_31_in <= soft_output_temp_31;
                        index_temp_32_in       <= index_temp_32;
                        soft_output_temp_32_in <= soft_output_temp_32;
                end if;
        end process;
        ------------------------------------------------------------------------------------------------------------
        -- Define processes : (CLK 4)
        ------------------------------------------------------------------------------------------------------------	  
        process (clk, reset)
        begin
                if (reset = '1') then
                        soft_output_temp_1_1_in  <= (others => (others => '0'));
                        soft_output_temp_1_2_in  <= (others => (others => '0'));
                        index_temp_1_1_in        <= (others => (others => '0'));
                        index_temp_1_2_in        <= (others => (others => '0'));
                        soft_output_temp_1_3_in  <= (others => (others => '0'));
                        soft_output_temp_1_4_in  <= (others => (others => '0'));
                        index_temp_1_3_in        <= (others => (others => '0'));
                        index_temp_1_4_in        <= (others => (others => '0'));
                        soft_output_temp_1_5_in  <= (others => (others => '0'));
                        soft_output_temp_1_6_in  <= (others => (others => '0'));
                        index_temp_1_5_in        <= (others => (others => '0'));
                        index_temp_1_6_in        <= (others => (others => '0'));
                        soft_output_temp_1_7_in  <= (others => (others => '0'));
                        soft_output_temp_1_8_in  <= (others => (others => '0'));
                        index_temp_1_7_in        <= (others => (others => '0'));
                        index_temp_1_8_in        <= (others => (others => '0'));
                        soft_output_temp_1_9_in  <= (others => (others => '0'));
                        soft_output_temp_1_10_in <= (others => (others => '0'));
                        index_temp_1_9_in        <= (others => (others => '0'));
                        index_temp_1_10_in       <= (others => (others => '0'));
                        soft_output_temp_1_11_in <= (others => (others => '0'));
                        soft_output_temp_1_12_in <= (others => (others => '0'));
                        index_temp_1_11_in       <= (others => (others => '0'));
                        index_temp_1_12_in       <= (others => (others => '0'));
                        soft_output_temp_1_13_in <= (others => (others => '0'));
                        soft_output_temp_1_14_in <= (others => (others => '0'));
                        index_temp_1_13_in       <= (others => (others => '0'));
                        index_temp_1_14_in       <= (others => (others => '0'));
                        soft_output_temp_1_15_in <= (others => (others => '0'));
                        soft_output_temp_1_16_in <= (others => (others => '0'));
                        index_temp_1_15_in       <= (others => (others => '0'));
                        index_temp_1_16_in       <= (others => (others => '0'));
                        soft_input_pass_3        <= (others => (others => '0'));
                elsif (rising_edge(clk)) then
                        soft_input_pass_3 <= soft_output_pass_2;
                        -- 1 
                        soft_output_temp_1_1_in <= soft_output_out_1;
                        soft_output_temp_1_2_in <= soft_output_out_2;
                        index_temp_1_1_in       <= index_out_1;
                        index_temp_1_2_in       <= index_out_2;
                        -- 2 
                        soft_output_temp_1_3_in <= soft_output_out_3;
                        soft_output_temp_1_4_in <= soft_output_out_4;
                        index_temp_1_3_in       <= index_out_3;
                        index_temp_1_4_in       <= index_out_4;
                        -- 3 
                        soft_output_temp_1_5_in <= soft_output_out_5;
                        soft_output_temp_1_6_in <= soft_output_out_6;
                        index_temp_1_5_in       <= index_out_5;
                        index_temp_1_6_in       <= index_out_6;
                        -- 4
                        soft_output_temp_1_7_in <= soft_output_out_7;
                        soft_output_temp_1_8_in <= soft_output_out_8;
                        index_temp_1_7_in       <= index_out_7;
                        index_temp_1_8_in       <= index_out_8;
                        -- 5
                        soft_output_temp_1_9_in  <= soft_output_out_9;
                        soft_output_temp_1_10_in <= soft_output_out_10;
                        index_temp_1_9_in        <= index_out_9;
                        index_temp_1_10_in       <= index_out_10;
                        -- 6 
                        soft_output_temp_1_11_in <= soft_output_out_11;
                        soft_output_temp_1_12_in <= soft_output_out_12;
                        index_temp_1_11_in       <= index_out_11;
                        index_temp_1_12_in       <= index_out_12;
                        -- 7
                        soft_output_temp_1_13_in <= soft_output_out_13;
                        soft_output_temp_1_14_in <= soft_output_out_14;
                        index_temp_1_13_in       <= index_out_13;
                        index_temp_1_14_in       <= index_out_14;
                        -- 8
                        soft_output_temp_1_15_in <= soft_output_out_15;
                        soft_output_temp_1_16_in <= soft_output_out_16;
                        index_temp_1_15_in       <= index_out_15;
                        index_temp_1_16_in       <= index_out_16;
                end if;
        end process;
        ------------------------------------------------------------------------------------------------------------
        -- Define processes : (CLK 5)
        ------------------------------------------------------------------------------------------------------------	  
        process (clk, reset)
        begin
                if (reset = '1') then
                        soft_output_temp_2_1_in <= (others => (others => '0'));
                        soft_output_temp_2_2_in <= (others => (others => '0'));
                        index_temp_2_1_in       <= (others => (others => '0'));
                        index_temp_2_2_in       <= (others => (others => '0'));
                        soft_output_temp_2_3_in <= (others => (others => '0'));
                        soft_output_temp_2_4_in <= (others => (others => '0'));
                        index_temp_2_3_in       <= (others => (others => '0'));
                        index_temp_2_4_in       <= (others => (others => '0'));
                        soft_output_temp_2_5_in <= (others => (others => '0'));
                        soft_output_temp_2_6_in <= (others => (others => '0'));
                        index_temp_2_5_in       <= (others => (others => '0'));
                        index_temp_2_6_in       <= (others => (others => '0'));
                        soft_output_temp_2_7_in <= (others => (others => '0'));
                        soft_output_temp_2_8_in <= (others => (others => '0'));
                        index_temp_2_7_in       <= (others => (others => '0'));
                        index_temp_2_8_in       <= (others => (others => '0'));
                        soft_input_pass_4       <= (others => (others => '0'));
                elsif (rising_edge(clk)) then
                        soft_input_pass_4 <= soft_output_pass_3;
                        -- 1 
                        soft_output_temp_2_1_in <= soft_output_out_1_1;
                        soft_output_temp_2_2_in <= soft_output_out_1_2;
                        index_temp_2_1_in       <= index_out_1_1;
                        index_temp_2_2_in       <= index_out_1_2;
                        -- 2 
                        soft_output_temp_2_3_in <= soft_output_out_1_3;
                        soft_output_temp_2_4_in <= soft_output_out_1_4;
                        index_temp_2_3_in       <= index_out_1_3;
                        index_temp_2_4_in       <= index_out_1_4;
                        -- 3 
                        soft_output_temp_2_5_in <= soft_output_out_1_5;
                        soft_output_temp_2_6_in <= soft_output_out_1_6;
                        index_temp_2_5_in       <= index_out_1_5;
                        index_temp_2_6_in       <= index_out_1_6;
                        -- 4
                        soft_output_temp_2_7_in <= soft_output_out_1_7;
                        soft_output_temp_2_8_in <= soft_output_out_1_8;
                        index_temp_2_7_in       <= index_out_1_7;
                        index_temp_2_8_in       <= index_out_1_8;
                end if;
        end process;
        ------------------------------------------------------------------------------------------------------------
        -- Define processes : (CLK 6)
        ------------------------------------------------------------------------------------------------------------	  
        process (clk, reset)
        begin
                if (reset = '1') then
                        soft_output_temp_3_1_in <= (others => (others => '0'));
                        soft_output_temp_3_2_in <= (others => (others => '0'));
                        index_temp_3_1_in       <= (others => (others => '0'));
                        index_temp_3_2_in       <= (others => (others => '0'));
                        soft_output_temp_3_3_in <= (others => (others => '0'));
                        soft_output_temp_3_4_in <= (others => (others => '0'));
                        index_temp_3_3_in       <= (others => (others => '0'));
                        index_temp_3_4_in       <= (others => (others => '0'));
                        soft_input_pass_5       <= (others => (others => '0'));
                elsif (rising_edge(clk)) then
                        soft_input_pass_5 <= soft_output_pass_4;
                        -- 1 
                        soft_output_temp_3_1_in <= soft_output_out_2_1;
                        soft_output_temp_3_2_in <= soft_output_out_2_2;
                        index_temp_3_1_in       <= index_out_2_1;
                        index_temp_3_2_in       <= index_out_2_2;
                        -- 2 
                        soft_output_temp_3_3_in <= soft_output_out_2_3;
                        soft_output_temp_3_4_in <= soft_output_out_2_4;
                        index_temp_3_3_in       <= index_out_2_3;
                        index_temp_3_4_in       <= index_out_2_4;
                end if;
        end process;
        ------------------------------------------------------------------------------------------------------------
        -- Define processes : (CLK 7)
        ------------------------------------------------------------------------------------------------------------	  
        process (clk, reset)
        begin
                if (reset = '1') then
                        soft_output_temp_4_1_in <= (others => (others => '0'));
                        soft_output_temp_4_2_in <= (others => (others => '0'));
                        index_temp_4_1_in       <= (others => (others => '0'));
                        index_temp_4_2_in       <= (others => (others => '0'));
                        soft_input_pass_6       <= (others => (others => '0'));
                elsif (rising_edge(clk)) then
                        soft_input_pass_6 <= soft_output_pass_5;
                        -- 1 
                        soft_output_temp_4_1_in <= soft_output_out_3_1;
                        soft_output_temp_4_2_in <= soft_output_out_3_2;
                        index_temp_4_1_in       <= index_out_3_1;
                        index_temp_4_2_in       <= index_out_3_2;
                end if;
        end process;
        ------------------------------------------------------------------------------------------------------------
        -- Define processes : (CLK 7.5)
        ------------------------------------------------------------------------------------------------------------
        process (clk, reset)
        begin
                if (reset = '1') then
                        index_power_pass_0 <= (others => (others => '0'));
                        soft_power_pass_0  <= (others => (others => '0'));
                        index_power_pass_1 <= (others => (others => '0'));
                        soft_power_pass_1  <= (others => (others => '0'));
                elsif (rising_edge(clk)) then
                        index_power_pass_0 <= index_out_4_1;
                        soft_power_pass_0  <= soft_output_pass_6;
                        index_power_pass_0 <= index_out_4_1;
                        soft_power_pass_0  <= soft_output_pass_6;
                        index_power_pass_0 <= index_out_4_1;
                        soft_power_pass_0  <= soft_output_pass_6;
                        index_power_pass_0 <= index_out_4_1;
                        soft_power_pass_0  <= soft_output_pass_6;
                        index_power_pass_1 <= index_out_4_1;
                        soft_power_pass_1  <= soft_output_pass_6;
                        index_power_pass_1 <= index_out_4_1;
                        soft_power_pass_1  <= soft_output_pass_6;
                        index_power_pass_1 <= index_out_4_1;
                        soft_power_pass_1  <= soft_output_pass_6;
                        index_power_pass_1 <= index_out_4_1;
                        soft_power_pass_1  <= soft_output_pass_6;
                end if;
        end process;
        ------------------------------------------------------------------------------------------------------------
        -- Define processes : (CLK 8)
        ------------------------------------------------------------------------------------------------------------
        process (clk, reset)
        begin
                if (reset = '1') then
                        index_power_0 <= (others => (others => '0'));
                        soft_power_0  <= (others => (others => '0'));
                        index_power_0 <= (others => (others => '0'));
                        soft_power_0  <= (others => (others => '0'));
                        index_power_1 <= (others => (others => '0'));
                        soft_power_1  <= (others => (others => '0'));
                        index_power_1 <= (others => (others => '0'));
                        soft_power_1  <= (others => (others => '0'));
                        index_power_2 <= (others => (others => '0'));
                        soft_power_2  <= (others => (others => '0'));
                        index_power_2 <= (others => (others => '0'));
                        soft_power_2  <= (others => (others => '0'));
                        index_power_3 <= (others => (others => '0'));
                        soft_power_3  <= (others => (others => '0'));
                        index_power_3 <= (others => (others => '0'));
                        soft_power_3  <= (others => (others => '0'));
                elsif (rising_edge(clk)) then
                        index_power_0 <= index_power_pass_0;
                        soft_power_0  <= soft_power_pass_0;
                        index_power_0 <= index_power_pass_0;
                        soft_power_0  <= soft_power_pass_0;
                        index_power_1 <= index_power_pass_0;
                        soft_power_1  <= soft_power_pass_0;
                        index_power_1 <= index_power_pass_0;
                        soft_power_1  <= soft_power_pass_0;
                        index_power_2 <= index_power_pass_1;
                        soft_power_2  <= soft_power_pass_1;
                        index_power_2 <= index_power_pass_1;
                        soft_power_2  <= soft_power_pass_1;
                        index_power_3 <= index_power_pass_1;
                        soft_power_3  <= soft_power_pass_1;
                        index_power_3 <= index_power_pass_1;
                        soft_power_3  <= soft_power_pass_1;
                end if;
        end process;
        ------------------------------------------------------------------------------------------------------------
        -- Define processes : (CLK 9)
        ------------------------------------------------------------------------------------------------------------
        process (clk, reset)
        begin
                if (reset = '1') then
                        index_0       <= (others => (others => '0'));
                        soft_output_0 <= (others => (others => '0'));
                        index_1       <= (others => (others => '0'));
                        soft_output_1 <= (others => (others => '0'));
                        index_2       <= (others => (others => '0'));
                        soft_output_2 <= (others => (others => '0'));
                        index_3       <= (others => (others => '0'));
                        soft_output_3 <= (others => (others => '0'));
                        index_4       <= (others => (others => '0'));
                        soft_output_4 <= (others => (others => '0'));
                        index_5       <= (others => (others => '0'));
                        soft_output_5 <= (others => (others => '0'));
                        index_6       <= (others => (others => '0'));
                        soft_output_6 <= (others => (others => '0'));
                        index_7       <= (others => (others => '0'));
                        soft_output_7 <= (others => (others => '0'));
                elsif (rising_edge(clk)) then
                        index_0       <= index_power_0;
                        soft_output_0 <= soft_power_0;
                        index_1       <= index_power_0;
                        soft_output_1 <= soft_power_0;
                        index_2       <= index_power_1;
                        soft_output_2 <= soft_power_1;
                        index_3       <= index_power_1;
                        soft_output_3 <= soft_power_1;
                        index_4       <= index_power_2;
                        soft_output_4 <= soft_power_2;
                        index_5       <= index_power_2;
                        soft_output_5 <= soft_power_2;
                        index_6       <= index_power_3;
                        soft_output_6 <= soft_power_3;
                        index_7       <= index_power_3;
                        soft_output_7 <= soft_power_3;
                end if;
        end process;
end architecture;
