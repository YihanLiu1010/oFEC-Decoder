-- 3 bits will be flipped in this block
-- 8 index will be received from sorting block, and in this block we will flip the first 3 of them
-- Also because we will flip 3 bits, the weight_info will also be 3 soft info
-- flipping pattern 134

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use ieee.math_real.all;
use work.arr_pkg_1.all;
use work.arr_pkg_2.all;
use work.arr_pkg_3.all;

entity flipping_2 is
    generic (
        data_length : positive := 255
    );
    port (
        clk                   : in std_logic;
        reset                 : in std_logic;
        soft_input            : in input_data_array(data_length downto 0); -- From Sorting block
        index                 : in index_array(7 downto 0);                -- From Sorting block
        soft_output_unflipped : out input_data_array(data_length downto 0);
        soft_output_flipped   : out input_data_array(data_length downto 0);
        index_out             : out index_array(7 downto 0);  
        weight_info           : out input_data_array(2 downto 0) -- These 3 values will be send out to weight_1 block for adding up
    );
end flipping_2;
architecture rtl of flipping_2 is
    --------------------------------------------------------------------------------------------
    -- CLK 0
    signal soft_input_temp : input_data_array(255 downto 0);
    signal index_temp      : index_array(7 downto 0);
    --------------------------------------------------------------------------------------------
    -- CLK 1
    signal soft_input_1            : input_data_array(63 downto 0);
    signal soft_input_2            : input_data_array(63 downto 0);
    signal soft_input_3            : input_data_array(63 downto 0);
    signal soft_input_4            : input_data_array(63 downto 0);
    signal index_1                 : index_array(7 downto 0);
    signal indi_1                  : std_logic_vector(2 downto 0); -- indicate the region of index
    signal indi_2                  : std_logic_vector(2 downto 0);
    signal indi_3                  : std_logic_vector(2 downto 0);
    signal soft_output_unflipped_1 : input_data_array(255 downto 0);
    signal index_1_original        : index_array(7 downto 0);
    --------------------------------------------------------------------------------------------
    -- CLK 2
    signal soft_input_1_1          : input_data_array(15 downto 0);
    signal soft_input_1_2          : input_data_array(15 downto 0);
    signal soft_input_1_3          : input_data_array(15 downto 0);
    signal soft_input_1_4          : input_data_array(15 downto 0);
    signal soft_input_2_1          : input_data_array(15 downto 0);
    signal soft_input_2_2          : input_data_array(15 downto 0);
    signal soft_input_2_3          : input_data_array(15 downto 0);
    signal soft_input_2_4          : input_data_array(15 downto 0);
    signal soft_input_3_1          : input_data_array(15 downto 0);
    signal soft_input_3_2          : input_data_array(15 downto 0);
    signal soft_input_3_3          : input_data_array(15 downto 0);
    signal soft_input_3_4          : input_data_array(15 downto 0);
    signal soft_input_4_1          : input_data_array(15 downto 0);
    signal soft_input_4_2          : input_data_array(15 downto 0);
    signal soft_input_4_3          : input_data_array(15 downto 0);
    signal soft_input_4_4          : input_data_array(15 downto 0);
    signal index_2                 : index_array(7 downto 0);
    signal indi_1_1                : std_logic_vector(2 downto 0); -- indicate the region of index
    signal indi_1_2                : std_logic_vector(2 downto 0);
    signal indi_1_3                : std_logic_vector(2 downto 0);
    signal indi_1_4                : std_logic_vector(2 downto 0);
    signal indi_2_1                : std_logic_vector(2 downto 0);
    signal indi_2_2                : std_logic_vector(2 downto 0);
    signal indi_2_3                : std_logic_vector(2 downto 0);
    signal indi_2_4                : std_logic_vector(2 downto 0);
    signal indi_3_1                : std_logic_vector(2 downto 0);
    signal indi_3_2                : std_logic_vector(2 downto 0);
    signal indi_3_3                : std_logic_vector(2 downto 0);
    signal indi_3_4                : std_logic_vector(2 downto 0);
    signal soft_output_unflipped_2 : input_data_array(255 downto 0);
    signal index_2_original        : index_array(7 downto 0);
    --------------------------------------------------------------------------------------------
    -- CLK 3
    signal weight_info_1           : input_data_array(16 downto 1);
    signal soft_input_1_1_1        : input_data_array(3 downto 0);
    signal soft_input_1_1_2        : input_data_array(3 downto 0);
    signal soft_input_1_1_3        : input_data_array(3 downto 0);
    signal soft_input_1_1_4        : input_data_array(3 downto 0);
    signal soft_input_1_2_1        : input_data_array(3 downto 0);
    signal soft_input_1_2_2        : input_data_array(3 downto 0);
    signal soft_input_1_2_3        : input_data_array(3 downto 0);
    signal soft_input_1_2_4        : input_data_array(3 downto 0);
    signal soft_input_1_3_1        : input_data_array(3 downto 0);
    signal soft_input_1_3_2        : input_data_array(3 downto 0);
    signal soft_input_1_3_3        : input_data_array(3 downto 0);
    signal soft_input_1_3_4        : input_data_array(3 downto 0);
    signal soft_input_1_4_1        : input_data_array(3 downto 0);
    signal soft_input_1_4_2        : input_data_array(3 downto 0);
    signal soft_input_1_4_3        : input_data_array(3 downto 0);
    signal soft_input_1_4_4        : input_data_array(3 downto 0);
    signal soft_input_2_1_1        : input_data_array(3 downto 0);
    signal soft_input_2_1_2        : input_data_array(3 downto 0);
    signal soft_input_2_1_3        : input_data_array(3 downto 0);
    signal soft_input_2_1_4        : input_data_array(3 downto 0);
    signal soft_input_2_2_1        : input_data_array(3 downto 0);
    signal soft_input_2_2_2        : input_data_array(3 downto 0);
    signal soft_input_2_2_3        : input_data_array(3 downto 0);
    signal soft_input_2_2_4        : input_data_array(3 downto 0);
    signal soft_input_2_3_1        : input_data_array(3 downto 0);
    signal soft_input_2_3_2        : input_data_array(3 downto 0);
    signal soft_input_2_3_3        : input_data_array(3 downto 0);
    signal soft_input_2_3_4        : input_data_array(3 downto 0);
    signal soft_input_2_4_1        : input_data_array(3 downto 0);
    signal soft_input_2_4_2        : input_data_array(3 downto 0);
    signal soft_input_2_4_3        : input_data_array(3 downto 0);
    signal soft_input_2_4_4        : input_data_array(3 downto 0);
    signal soft_input_3_1_1        : input_data_array(3 downto 0);
    signal soft_input_3_1_2        : input_data_array(3 downto 0);
    signal soft_input_3_1_3        : input_data_array(3 downto 0);
    signal soft_input_3_1_4        : input_data_array(3 downto 0);
    signal soft_input_3_2_1        : input_data_array(3 downto 0);
    signal soft_input_3_2_2        : input_data_array(3 downto 0);
    signal soft_input_3_2_3        : input_data_array(3 downto 0);
    signal soft_input_3_2_4        : input_data_array(3 downto 0);
    signal soft_input_3_3_1        : input_data_array(3 downto 0);
    signal soft_input_3_3_2        : input_data_array(3 downto 0);
    signal soft_input_3_3_3        : input_data_array(3 downto 0);
    signal soft_input_3_3_4        : input_data_array(3 downto 0);
    signal soft_input_3_4_1        : input_data_array(3 downto 0);
    signal soft_input_3_4_2        : input_data_array(3 downto 0);
    signal soft_input_3_4_3        : input_data_array(3 downto 0);
    signal soft_input_3_4_4        : input_data_array(3 downto 0);
    signal soft_input_4_1_1        : input_data_array(3 downto 0);
    signal soft_input_4_1_2        : input_data_array(3 downto 0);
    signal soft_input_4_1_3        : input_data_array(3 downto 0);
    signal soft_input_4_1_4        : input_data_array(3 downto 0);
    signal soft_input_4_2_1        : input_data_array(3 downto 0);
    signal soft_input_4_2_2        : input_data_array(3 downto 0);
    signal soft_input_4_2_3        : input_data_array(3 downto 0);
    signal soft_input_4_2_4        : input_data_array(3 downto 0);
    signal soft_input_4_3_1        : input_data_array(3 downto 0);
    signal soft_input_4_3_2        : input_data_array(3 downto 0);
    signal soft_input_4_3_3        : input_data_array(3 downto 0);
    signal soft_input_4_3_4        : input_data_array(3 downto 0);
    signal soft_input_4_4_1        : input_data_array(3 downto 0);
    signal soft_input_4_4_2        : input_data_array(3 downto 0);
    signal soft_input_4_4_3        : input_data_array(3 downto 0);
    signal soft_input_4_4_4        : input_data_array(3 downto 0);
    signal index_3                 : index_array(7 downto 0);
    signal indi_1_1_1              : std_logic_vector(2 downto 0);
    signal indi_1_1_2              : std_logic_vector(2 downto 0);
    signal indi_1_1_3              : std_logic_vector(2 downto 0);
    signal indi_1_1_4              : std_logic_vector(2 downto 0);
    signal indi_1_2_1              : std_logic_vector(2 downto 0);
    signal indi_1_2_2              : std_logic_vector(2 downto 0);
    signal indi_1_2_3              : std_logic_vector(2 downto 0);
    signal indi_1_2_4              : std_logic_vector(2 downto 0);
    signal indi_1_3_1              : std_logic_vector(2 downto 0);
    signal indi_1_3_2              : std_logic_vector(2 downto 0);
    signal indi_1_3_3              : std_logic_vector(2 downto 0);
    signal indi_1_3_4              : std_logic_vector(2 downto 0);
    signal indi_1_4_1              : std_logic_vector(2 downto 0);
    signal indi_1_4_2              : std_logic_vector(2 downto 0);
    signal indi_1_4_3              : std_logic_vector(2 downto 0);
    signal indi_1_4_4              : std_logic_vector(2 downto 0);
    signal indi_2_1_1              : std_logic_vector(2 downto 0);
    signal indi_2_1_2              : std_logic_vector(2 downto 0);
    signal indi_2_1_3              : std_logic_vector(2 downto 0);
    signal indi_2_1_4              : std_logic_vector(2 downto 0);
    signal indi_2_2_1              : std_logic_vector(2 downto 0);
    signal indi_2_2_2              : std_logic_vector(2 downto 0);
    signal indi_2_2_3              : std_logic_vector(2 downto 0);
    signal indi_2_2_4              : std_logic_vector(2 downto 0);
    signal indi_2_3_1              : std_logic_vector(2 downto 0);
    signal indi_2_3_2              : std_logic_vector(2 downto 0);
    signal indi_2_3_3              : std_logic_vector(2 downto 0);
    signal indi_2_3_4              : std_logic_vector(2 downto 0);
    signal indi_2_4_1              : std_logic_vector(2 downto 0);
    signal indi_2_4_2              : std_logic_vector(2 downto 0);
    signal indi_2_4_3              : std_logic_vector(2 downto 0);
    signal indi_2_4_4              : std_logic_vector(2 downto 0);
    signal indi_3_1_1              : std_logic_vector(2 downto 0);
    signal indi_3_1_2              : std_logic_vector(2 downto 0);
    signal indi_3_1_3              : std_logic_vector(2 downto 0);
    signal indi_3_1_4              : std_logic_vector(2 downto 0);
    signal indi_3_2_1              : std_logic_vector(2 downto 0);
    signal indi_3_2_2              : std_logic_vector(2 downto 0);
    signal indi_3_2_3              : std_logic_vector(2 downto 0);
    signal indi_3_2_4              : std_logic_vector(2 downto 0);
    signal indi_3_3_1              : std_logic_vector(2 downto 0);
    signal indi_3_3_2              : std_logic_vector(2 downto 0);
    signal indi_3_3_3              : std_logic_vector(2 downto 0);
    signal indi_3_3_4              : std_logic_vector(2 downto 0);
    signal indi_3_4_1              : std_logic_vector(2 downto 0);
    signal indi_3_4_2              : std_logic_vector(2 downto 0);
    signal indi_3_4_3              : std_logic_vector(2 downto 0);
    signal indi_3_4_4              : std_logic_vector(2 downto 0);
    signal soft_output_unflipped_3 : input_data_array(255 downto 0);
    signal index_3_original        : index_array(7 downto 0);
    --------------------------------------------------------------------------------------------
    -- CLK 4
    signal weight_info_2           : input_data_array(16 downto 1);
    signal indi_2_1_1_pass_1       : std_logic_vector(2 downto 0);
    signal indi_2_1_2_pass_1       : std_logic_vector(2 downto 0);
    signal indi_2_1_3_pass_1       : std_logic_vector(2 downto 0);
    signal indi_2_1_4_pass_1       : std_logic_vector(2 downto 0);
    signal indi_2_2_1_pass_1       : std_logic_vector(2 downto 0);
    signal indi_2_2_2_pass_1       : std_logic_vector(2 downto 0);
    signal indi_2_2_3_pass_1       : std_logic_vector(2 downto 0);
    signal indi_2_2_4_pass_1       : std_logic_vector(2 downto 0);
    signal indi_2_3_1_pass_1       : std_logic_vector(2 downto 0);
    signal indi_2_3_2_pass_1       : std_logic_vector(2 downto 0);
    signal indi_2_3_3_pass_1       : std_logic_vector(2 downto 0);
    signal indi_2_3_4_pass_1       : std_logic_vector(2 downto 0);
    signal indi_2_4_1_pass_1       : std_logic_vector(2 downto 0);
    signal indi_2_4_2_pass_1       : std_logic_vector(2 downto 0);
    signal indi_2_4_3_pass_1       : std_logic_vector(2 downto 0);
    signal indi_2_4_4_pass_1       : std_logic_vector(2 downto 0);
    signal indi_3_1_1_pass_1       : std_logic_vector(2 downto 0);
    signal indi_3_1_2_pass_1       : std_logic_vector(2 downto 0);
    signal indi_3_1_3_pass_1       : std_logic_vector(2 downto 0);
    signal indi_3_1_4_pass_1       : std_logic_vector(2 downto 0);
    signal indi_3_2_1_pass_1       : std_logic_vector(2 downto 0);
    signal indi_3_2_2_pass_1       : std_logic_vector(2 downto 0);
    signal indi_3_2_3_pass_1       : std_logic_vector(2 downto 0);
    signal indi_3_2_4_pass_1       : std_logic_vector(2 downto 0);
    signal indi_3_3_1_pass_1       : std_logic_vector(2 downto 0);
    signal indi_3_3_2_pass_1       : std_logic_vector(2 downto 0);
    signal indi_3_3_3_pass_1       : std_logic_vector(2 downto 0);
    signal indi_3_3_4_pass_1       : std_logic_vector(2 downto 0);
    signal indi_3_4_1_pass_1       : std_logic_vector(2 downto 0);
    signal indi_3_4_2_pass_1       : std_logic_vector(2 downto 0);
    signal indi_3_4_3_pass_1       : std_logic_vector(2 downto 0);
    signal indi_3_4_4_pass_1       : std_logic_vector(2 downto 0);
    signal index_4                 : index_array(7 downto 0);
    signal soft_input_1_1_1_flip_1 : input_data_array(3 downto 0);
    signal soft_input_1_1_2_flip_1 : input_data_array(3 downto 0);
    signal soft_input_1_1_3_flip_1 : input_data_array(3 downto 0);
    signal soft_input_1_1_4_flip_1 : input_data_array(3 downto 0);
    signal soft_input_1_2_1_flip_1 : input_data_array(3 downto 0);
    signal soft_input_1_2_2_flip_1 : input_data_array(3 downto 0);
    signal soft_input_1_2_3_flip_1 : input_data_array(3 downto 0);
    signal soft_input_1_2_4_flip_1 : input_data_array(3 downto 0);
    signal soft_input_1_3_1_flip_1 : input_data_array(3 downto 0);
    signal soft_input_1_3_2_flip_1 : input_data_array(3 downto 0);
    signal soft_input_1_3_3_flip_1 : input_data_array(3 downto 0);
    signal soft_input_1_3_4_flip_1 : input_data_array(3 downto 0);
    signal soft_input_1_4_1_flip_1 : input_data_array(3 downto 0);
    signal soft_input_1_4_2_flip_1 : input_data_array(3 downto 0);
    signal soft_input_1_4_3_flip_1 : input_data_array(3 downto 0);
    signal soft_input_1_4_4_flip_1 : input_data_array(3 downto 0);
    signal soft_input_2_1_1_flip_1 : input_data_array(3 downto 0);
    signal soft_input_2_1_2_flip_1 : input_data_array(3 downto 0);
    signal soft_input_2_1_3_flip_1 : input_data_array(3 downto 0);
    signal soft_input_2_1_4_flip_1 : input_data_array(3 downto 0);
    signal soft_input_2_2_1_flip_1 : input_data_array(3 downto 0);
    signal soft_input_2_2_2_flip_1 : input_data_array(3 downto 0);
    signal soft_input_2_2_3_flip_1 : input_data_array(3 downto 0);
    signal soft_input_2_2_4_flip_1 : input_data_array(3 downto 0);
    signal soft_input_2_3_1_flip_1 : input_data_array(3 downto 0);
    signal soft_input_2_3_2_flip_1 : input_data_array(3 downto 0);
    signal soft_input_2_3_3_flip_1 : input_data_array(3 downto 0);
    signal soft_input_2_3_4_flip_1 : input_data_array(3 downto 0);
    signal soft_input_2_4_1_flip_1 : input_data_array(3 downto 0);
    signal soft_input_2_4_2_flip_1 : input_data_array(3 downto 0);
    signal soft_input_2_4_3_flip_1 : input_data_array(3 downto 0);
    signal soft_input_2_4_4_flip_1 : input_data_array(3 downto 0);
    signal soft_input_3_1_1_flip_1 : input_data_array(3 downto 0);
    signal soft_input_3_1_2_flip_1 : input_data_array(3 downto 0);
    signal soft_input_3_1_3_flip_1 : input_data_array(3 downto 0);
    signal soft_input_3_1_4_flip_1 : input_data_array(3 downto 0);
    signal soft_input_3_2_1_flip_1 : input_data_array(3 downto 0);
    signal soft_input_3_2_2_flip_1 : input_data_array(3 downto 0);
    signal soft_input_3_2_3_flip_1 : input_data_array(3 downto 0);
    signal soft_input_3_2_4_flip_1 : input_data_array(3 downto 0);
    signal soft_input_3_3_1_flip_1 : input_data_array(3 downto 0);
    signal soft_input_3_3_2_flip_1 : input_data_array(3 downto 0);
    signal soft_input_3_3_3_flip_1 : input_data_array(3 downto 0);
    signal soft_input_3_3_4_flip_1 : input_data_array(3 downto 0);
    signal soft_input_3_4_1_flip_1 : input_data_array(3 downto 0);
    signal soft_input_3_4_2_flip_1 : input_data_array(3 downto 0);
    signal soft_input_3_4_3_flip_1 : input_data_array(3 downto 0);
    signal soft_input_3_4_4_flip_1 : input_data_array(3 downto 0);
    signal soft_input_4_1_1_flip_1 : input_data_array(3 downto 0);
    signal soft_input_4_1_2_flip_1 : input_data_array(3 downto 0);
    signal soft_input_4_1_3_flip_1 : input_data_array(3 downto 0);
    signal soft_input_4_1_4_flip_1 : input_data_array(3 downto 0);
    signal soft_input_4_2_1_flip_1 : input_data_array(3 downto 0);
    signal soft_input_4_2_2_flip_1 : input_data_array(3 downto 0);
    signal soft_input_4_2_3_flip_1 : input_data_array(3 downto 0);
    signal soft_input_4_2_4_flip_1 : input_data_array(3 downto 0);
    signal soft_input_4_3_1_flip_1 : input_data_array(3 downto 0);
    signal soft_input_4_3_2_flip_1 : input_data_array(3 downto 0);
    signal soft_input_4_3_3_flip_1 : input_data_array(3 downto 0);
    signal soft_input_4_3_4_flip_1 : input_data_array(3 downto 0);
    signal soft_input_4_4_1_flip_1 : input_data_array(3 downto 0);
    signal soft_input_4_4_2_flip_1 : input_data_array(3 downto 0);
    signal soft_input_4_4_3_flip_1 : input_data_array(3 downto 0);
    signal soft_input_4_4_4_flip_1 : input_data_array(3 downto 0);
    signal weight_info_1_temp      : std_logic_vector(7 downto 0);
    signal soft_output_unflipped_4 : input_data_array(255 downto 0);
    signal index_4_original        : index_array(7 downto 0);
    --------------------------------------------------------------------------------------------
    -- CLK 5
    signal weight_info_3           : input_data_array(16 downto 1);
    signal indi_3_1_1_pass_2       : std_logic_vector(2 downto 0);
    signal indi_3_1_2_pass_2       : std_logic_vector(2 downto 0);
    signal indi_3_1_3_pass_2       : std_logic_vector(2 downto 0);
    signal indi_3_1_4_pass_2       : std_logic_vector(2 downto 0);
    signal indi_3_2_1_pass_2       : std_logic_vector(2 downto 0);
    signal indi_3_2_2_pass_2       : std_logic_vector(2 downto 0);
    signal indi_3_2_3_pass_2       : std_logic_vector(2 downto 0);
    signal indi_3_2_4_pass_2       : std_logic_vector(2 downto 0);
    signal indi_3_3_1_pass_2       : std_logic_vector(2 downto 0);
    signal indi_3_3_2_pass_2       : std_logic_vector(2 downto 0);
    signal indi_3_3_3_pass_2       : std_logic_vector(2 downto 0);
    signal indi_3_3_4_pass_2       : std_logic_vector(2 downto 0);
    signal indi_3_4_1_pass_2       : std_logic_vector(2 downto 0);
    signal indi_3_4_2_pass_2       : std_logic_vector(2 downto 0);
    signal indi_3_4_3_pass_2       : std_logic_vector(2 downto 0);
    signal indi_3_4_4_pass_2       : std_logic_vector(2 downto 0);
    signal index_5                 : index_array(7 downto 0);
    signal soft_input_1_1_1_flip_2 : input_data_array(3 downto 0);
    signal soft_input_1_1_2_flip_2 : input_data_array(3 downto 0);
    signal soft_input_1_1_3_flip_2 : input_data_array(3 downto 0);
    signal soft_input_1_1_4_flip_2 : input_data_array(3 downto 0);
    signal soft_input_1_2_1_flip_2 : input_data_array(3 downto 0);
    signal soft_input_1_2_2_flip_2 : input_data_array(3 downto 0);
    signal soft_input_1_2_3_flip_2 : input_data_array(3 downto 0);
    signal soft_input_1_2_4_flip_2 : input_data_array(3 downto 0);
    signal soft_input_1_3_1_flip_2 : input_data_array(3 downto 0);
    signal soft_input_1_3_2_flip_2 : input_data_array(3 downto 0);
    signal soft_input_1_3_3_flip_2 : input_data_array(3 downto 0);
    signal soft_input_1_3_4_flip_2 : input_data_array(3 downto 0);
    signal soft_input_1_4_1_flip_2 : input_data_array(3 downto 0);
    signal soft_input_1_4_2_flip_2 : input_data_array(3 downto 0);
    signal soft_input_1_4_3_flip_2 : input_data_array(3 downto 0);
    signal soft_input_1_4_4_flip_2 : input_data_array(3 downto 0);
    signal soft_input_2_1_1_flip_2 : input_data_array(3 downto 0);
    signal soft_input_2_1_2_flip_2 : input_data_array(3 downto 0);
    signal soft_input_2_1_3_flip_2 : input_data_array(3 downto 0);
    signal soft_input_2_1_4_flip_2 : input_data_array(3 downto 0);
    signal soft_input_2_2_1_flip_2 : input_data_array(3 downto 0);
    signal soft_input_2_2_2_flip_2 : input_data_array(3 downto 0);
    signal soft_input_2_2_3_flip_2 : input_data_array(3 downto 0);
    signal soft_input_2_2_4_flip_2 : input_data_array(3 downto 0);
    signal soft_input_2_3_1_flip_2 : input_data_array(3 downto 0);
    signal soft_input_2_3_2_flip_2 : input_data_array(3 downto 0);
    signal soft_input_2_3_3_flip_2 : input_data_array(3 downto 0);
    signal soft_input_2_3_4_flip_2 : input_data_array(3 downto 0);
    signal soft_input_2_4_1_flip_2 : input_data_array(3 downto 0);
    signal soft_input_2_4_2_flip_2 : input_data_array(3 downto 0);
    signal soft_input_2_4_3_flip_2 : input_data_array(3 downto 0);
    signal soft_input_2_4_4_flip_2 : input_data_array(3 downto 0);
    signal soft_input_3_1_1_flip_2 : input_data_array(3 downto 0);
    signal soft_input_3_1_2_flip_2 : input_data_array(3 downto 0);
    signal soft_input_3_1_3_flip_2 : input_data_array(3 downto 0);
    signal soft_input_3_1_4_flip_2 : input_data_array(3 downto 0);
    signal soft_input_3_2_1_flip_2 : input_data_array(3 downto 0);
    signal soft_input_3_2_2_flip_2 : input_data_array(3 downto 0);
    signal soft_input_3_2_3_flip_2 : input_data_array(3 downto 0);
    signal soft_input_3_2_4_flip_2 : input_data_array(3 downto 0);
    signal soft_input_3_3_1_flip_2 : input_data_array(3 downto 0);
    signal soft_input_3_3_2_flip_2 : input_data_array(3 downto 0);
    signal soft_input_3_3_3_flip_2 : input_data_array(3 downto 0);
    signal soft_input_3_3_4_flip_2 : input_data_array(3 downto 0);
    signal soft_input_3_4_1_flip_2 : input_data_array(3 downto 0);
    signal soft_input_3_4_2_flip_2 : input_data_array(3 downto 0);
    signal soft_input_3_4_3_flip_2 : input_data_array(3 downto 0);
    signal soft_input_3_4_4_flip_2 : input_data_array(3 downto 0);
    signal soft_input_4_1_1_flip_2 : input_data_array(3 downto 0);
    signal soft_input_4_1_2_flip_2 : input_data_array(3 downto 0);
    signal soft_input_4_1_3_flip_2 : input_data_array(3 downto 0);
    signal soft_input_4_1_4_flip_2 : input_data_array(3 downto 0);
    signal soft_input_4_2_1_flip_2 : input_data_array(3 downto 0);
    signal soft_input_4_2_2_flip_2 : input_data_array(3 downto 0);
    signal soft_input_4_2_3_flip_2 : input_data_array(3 downto 0);
    signal soft_input_4_2_4_flip_2 : input_data_array(3 downto 0);
    signal soft_input_4_3_1_flip_2 : input_data_array(3 downto 0);
    signal soft_input_4_3_2_flip_2 : input_data_array(3 downto 0);
    signal soft_input_4_3_3_flip_2 : input_data_array(3 downto 0);
    signal soft_input_4_3_4_flip_2 : input_data_array(3 downto 0);
    signal soft_input_4_4_1_flip_2 : input_data_array(3 downto 0);
    signal soft_input_4_4_2_flip_2 : input_data_array(3 downto 0);
    signal soft_input_4_4_3_flip_2 : input_data_array(3 downto 0);
    signal soft_input_4_4_4_flip_2 : input_data_array(3 downto 0);
    signal weight_info_2_temp      : std_logic_vector(7 downto 0);
    signal weight_info_1_temp1     : std_logic_vector(7 downto 0);
    signal weight_info_1_temp_p1   : std_logic_vector(7 downto 0);
    signal weight_info_1_temp_p2   : std_logic_vector(7 downto 0);
    signal weight_info_1_temp_p3   : std_logic_vector(7 downto 0);
    signal weight_info_1_temp_p4   : std_logic_vector(7 downto 0);
    signal soft_output_unflipped_5 : input_data_array(255 downto 0);
    signal index_5_original        : index_array(7 downto 0);
    --------------------------------------------------------------------------------------------
    -- CLK 5
    signal weight_info_2_temp_p1   : std_logic_vector(7 downto 0);
    signal weight_info_2_temp_p2   : std_logic_vector(7 downto 0);
    signal weight_info_2_temp_p3   : std_logic_vector(7 downto 0);
    signal weight_info_2_temp_p4   : std_logic_vector(7 downto 0);
    signal soft_input_1_1_1_flip_3 : input_data_array(3 downto 0);
    signal soft_input_1_1_2_flip_3 : input_data_array(3 downto 0);
    signal soft_input_1_1_3_flip_3 : input_data_array(3 downto 0);
    signal soft_input_1_1_4_flip_3 : input_data_array(3 downto 0);
    signal soft_input_1_2_1_flip_3 : input_data_array(3 downto 0);
    signal soft_input_1_2_2_flip_3 : input_data_array(3 downto 0);
    signal soft_input_1_2_3_flip_3 : input_data_array(3 downto 0);
    signal soft_input_1_2_4_flip_3 : input_data_array(3 downto 0);
    signal soft_input_1_3_1_flip_3 : input_data_array(3 downto 0);
    signal soft_input_1_3_2_flip_3 : input_data_array(3 downto 0);
    signal soft_input_1_3_3_flip_3 : input_data_array(3 downto 0);
    signal soft_input_1_3_4_flip_3 : input_data_array(3 downto 0);
    signal soft_input_1_4_1_flip_3 : input_data_array(3 downto 0);
    signal soft_input_1_4_2_flip_3 : input_data_array(3 downto 0);
    signal soft_input_1_4_3_flip_3 : input_data_array(3 downto 0);
    signal soft_input_1_4_4_flip_3 : input_data_array(3 downto 0);
    signal soft_input_2_1_1_flip_3 : input_data_array(3 downto 0);
    signal soft_input_2_1_2_flip_3 : input_data_array(3 downto 0);
    signal soft_input_2_1_3_flip_3 : input_data_array(3 downto 0);
    signal soft_input_2_1_4_flip_3 : input_data_array(3 downto 0);
    signal soft_input_2_2_1_flip_3 : input_data_array(3 downto 0);
    signal soft_input_2_2_2_flip_3 : input_data_array(3 downto 0);
    signal soft_input_2_2_3_flip_3 : input_data_array(3 downto 0);
    signal soft_input_2_2_4_flip_3 : input_data_array(3 downto 0);
    signal soft_input_2_3_1_flip_3 : input_data_array(3 downto 0);
    signal soft_input_2_3_2_flip_3 : input_data_array(3 downto 0);
    signal soft_input_2_3_3_flip_3 : input_data_array(3 downto 0);
    signal soft_input_2_3_4_flip_3 : input_data_array(3 downto 0);
    signal soft_input_2_4_1_flip_3 : input_data_array(3 downto 0);
    signal soft_input_2_4_2_flip_3 : input_data_array(3 downto 0);
    signal soft_input_2_4_3_flip_3 : input_data_array(3 downto 0);
    signal soft_input_2_4_4_flip_3 : input_data_array(3 downto 0);
    signal soft_input_3_1_1_flip_3 : input_data_array(3 downto 0);
    signal soft_input_3_1_2_flip_3 : input_data_array(3 downto 0);
    signal soft_input_3_1_3_flip_3 : input_data_array(3 downto 0);
    signal soft_input_3_1_4_flip_3 : input_data_array(3 downto 0);
    signal soft_input_3_2_1_flip_3 : input_data_array(3 downto 0);
    signal soft_input_3_2_2_flip_3 : input_data_array(3 downto 0);
    signal soft_input_3_2_3_flip_3 : input_data_array(3 downto 0);
    signal soft_input_3_2_4_flip_3 : input_data_array(3 downto 0);
    signal soft_input_3_3_1_flip_3 : input_data_array(3 downto 0);
    signal soft_input_3_3_2_flip_3 : input_data_array(3 downto 0);
    signal soft_input_3_3_3_flip_3 : input_data_array(3 downto 0);
    signal soft_input_3_3_4_flip_3 : input_data_array(3 downto 0);
    signal soft_input_3_4_1_flip_3 : input_data_array(3 downto 0);
    signal soft_input_3_4_2_flip_3 : input_data_array(3 downto 0);
    signal soft_input_3_4_3_flip_3 : input_data_array(3 downto 0);
    signal soft_input_3_4_4_flip_3 : input_data_array(3 downto 0);
    signal soft_input_4_1_1_flip_3 : input_data_array(3 downto 0);
    signal soft_input_4_1_2_flip_3 : input_data_array(3 downto 0);
    signal soft_input_4_1_3_flip_3 : input_data_array(3 downto 0);
    signal soft_input_4_1_4_flip_3 : input_data_array(3 downto 0);
    signal soft_input_4_2_1_flip_3 : input_data_array(3 downto 0);
    signal soft_input_4_2_2_flip_3 : input_data_array(3 downto 0);
    signal soft_input_4_2_3_flip_3 : input_data_array(3 downto 0);
    signal soft_input_4_2_4_flip_3 : input_data_array(3 downto 0);
    signal soft_input_4_3_1_flip_3 : input_data_array(3 downto 0);
    signal soft_input_4_3_2_flip_3 : input_data_array(3 downto 0);
    signal soft_input_4_3_3_flip_3 : input_data_array(3 downto 0);
    signal soft_input_4_3_4_flip_3 : input_data_array(3 downto 0);
    signal soft_input_4_4_1_flip_3 : input_data_array(3 downto 0);
    signal soft_input_4_4_2_flip_3 : input_data_array(3 downto 0);
    signal soft_input_4_4_3_flip_3 : input_data_array(3 downto 0);
    signal soft_input_4_4_4_flip_3 : input_data_array(3 downto 0);
    signal weight_info_1_pass      : std_logic_vector(7 downto 0);
    signal weight_info_2_pass      : std_logic_vector(7 downto 0);
    signal weight_info_3_pass      : std_logic_vector(7 downto 0);
    signal soft_output_unflipped_6 : input_data_array(255 downto 0);
    signal index_6                 : index_array(7 downto 0);
    signal index_6_original        : index_array(7 downto 0);
    --------------------------------------------------------------------------------------------
    -- CLK 6
    signal weight_info_3_temp_p1   : std_logic_vector(7 downto 0);
    signal weight_info_3_temp_p2   : std_logic_vector(7 downto 0);
    signal weight_info_3_temp_p3   : std_logic_vector(7 downto 0);
    signal weight_info_3_temp_p4   : std_logic_vector(7 downto 0);
    signal attach_1_1              : input_data_array(15 downto 0);
    signal attach_1_2              : input_data_array(15 downto 0);
    signal attach_1_3              : input_data_array(15 downto 0);
    signal attach_1_4              : input_data_array(15 downto 0);
    signal attach_2_1              : input_data_array(15 downto 0);
    signal attach_2_2              : input_data_array(15 downto 0);
    signal attach_2_3              : input_data_array(15 downto 0);
    signal attach_2_4              : input_data_array(15 downto 0);
    signal attach_3_1              : input_data_array(15 downto 0);
    signal attach_3_2              : input_data_array(15 downto 0);
    signal attach_3_3              : input_data_array(15 downto 0);
    signal attach_3_4              : input_data_array(15 downto 0);
    signal attach_4_1              : input_data_array(15 downto 0);
    signal attach_4_2              : input_data_array(15 downto 0);
    signal attach_4_3              : input_data_array(15 downto 0);
    signal attach_4_4              : input_data_array(15 downto 0);
    signal weight_info_1_pass1     : std_logic_vector(7 downto 0);
    signal weight_info_2_pass1     : std_logic_vector(7 downto 0);
    signal weight_info_3_pass1     : std_logic_vector(7 downto 0);
    signal soft_output_unflipped_7 : input_data_array(255 downto 0);
    signal index_7                 : index_array(7 downto 0);
    signal index_7_original        : index_array(7 downto 0);
    --------------------------------------------------------------------------------------------
    -- CLK 7
    signal attach_1                : input_data_array(63 downto 0);
    signal attach_2                : input_data_array(63 downto 0);
    signal attach_3                : input_data_array(63 downto 0);
    signal attach_4                : input_data_array(63 downto 0);
    signal soft_output_unflipped_8 : input_data_array(255 downto 0);
    signal index_8                 : index_array(7 downto 0);
    signal index_8_original        : index_array(7 downto 0);
    --------------------------------------------------------------------------------------------
    -- CLK 8
    signal index_9                 : index_array(7 downto 0);
    signal index_9_original        : index_array(7 downto 0);
    signal soft_output_unflipped_9 : input_data_array(255 downto 0);
    signal weight_info_1_pass2     : std_logic_vector(7 downto 0);
    signal weight_info_2_pass2     : std_logic_vector(7 downto 0);
    signal weight_info_3_pass2     : std_logic_vector(7 downto 0);
    signal soft_output_flipped_1   : input_data_array(255 downto 0);
begin
    ------------------------------------------------------------------------------------------------------------
    -- Define processes : (CLK 0)
    ------------------------------------------------------------------------------------------------------------
    process (clk, reset)
    begin
        if (reset = '1') then
            soft_input_temp <= (others => (others => '0'));
            index_temp      <= (others => (others => '0'));
        elsif (rising_edge(clk)) then
            soft_input_temp <= soft_input;
            index_temp(0)   <= index(0);
            index_temp(1)   <= index(2);
            index_temp(2)   <= index(3);
            index_temp(3)   <= index(1);
            index_temp(4)   <= index(4);
            index_temp(5)   <= index(5);
            index_temp(6)   <= index(6);
            index_temp(7)   <= index(7);
        end if;
    end process;
    ------------------------------------------------------------------------------------------------------------
    -- Define processes : (CLK 1)
    ------------------------------------------------------------------------------------------------------------
    process (clk, reset)
    begin
        if (reset = '1') then
            soft_input_1            <= (others => (others => '0'));
            soft_input_2            <= (others => (others => '0'));
            soft_input_3            <= (others => (others => '0'));
            soft_input_4            <= (others => (others => '0'));
            index_1                 <= (others => (others => '0'));
            index_1_original        <= (others => (others => '0'));
            indi_1                  <= (others => '0');
            indi_2                  <= (others => '0');
            indi_3                  <= (others => '0');
            soft_output_unflipped_1 <= (others => (others => '0'));
        elsif (rising_edge(clk)) then
            soft_output_unflipped_1 <= soft_input_temp;
            soft_input_4            <= soft_input_temp(255 downto 192);
            soft_input_3            <= soft_input_temp(191 downto 128);
            soft_input_2            <= soft_input_temp(127 downto 64);
            soft_input_1            <= soft_input_temp(63 downto 0); -- 0 should be the start of the array
            index_1                 <= index_temp;
            index_1_original        <= index_temp; -- The values inside are the flipping locations
            --------------------index category------------------------
            if index_temp(0) < 64 then
                indi_1     <= "001";
                index_1(0) <= index_temp(0);
            elsif (63 < index_temp(0)) and (index_temp(0)) < 128 then
                indi_1     <= "010";
                index_1(0) <= index_temp(0) - 64;
            elsif (127 < index_temp(0)) and (index_temp(0)) < 192 then
                indi_1     <= "011";
                index_1(0) <= index_temp(0) - 128;
            else
                indi_1     <= "100";
                index_1(0) <= index_temp(0) - 192;
            end if;
            ---------------------------------------------------------
            if index_temp(1) < 64 then
                indi_2     <= "001";
                index_1(1) <= index_temp(1);
            elsif (63 < index_temp(1)) and (index_temp(1)) < 128 then
                indi_2     <= "010";
                index_1(1) <= index_temp(1) - 64;
            elsif (127 < index_temp(1)) and (index_temp(1)) < 192 then
                indi_2     <= "011";
                index_1(1) <= index_temp(1) - 128;
            else
                indi_2     <= "100";
                index_1(1) <= index_temp(1) - 192;
            end if;
            ---------------------------------------------------------
            if index_temp(2) < 64 then
                indi_3     <= "001";
                index_1(2) <= index_temp(2);
            elsif (63 < index_temp(2)) and (index_temp(2)) < 128 then
                indi_3     <= "010";
                index_1(2) <= index_temp(2) - 64;
            elsif (127 < index_temp(2)) and (index_temp(2)) < 192 then
                indi_3     <= "011";
                index_1(2) <= index_temp(2) - 128;
            else
                indi_3     <= "100";
                index_1(2) <= index_temp(2) - 192;
            end if;
            ---------------------------------------------------------
        end if;
    end process;
    ------------------------------------------------------------------------------------------------------------
    -- Define processes : (CLK 2)
    ------------------------------------------------------------------------------------------------------------
    process (clk, reset)
    begin
        if (reset = '1') then
            soft_input_1_1          <= (others => (others => '0'));
            soft_input_1_2          <= (others => (others => '0'));
            soft_input_1_3          <= (others => (others => '0'));
            soft_input_1_4          <= (others => (others => '0'));
            soft_input_2_1          <= (others => (others => '0'));
            soft_input_2_2          <= (others => (others => '0'));
            soft_input_2_3          <= (others => (others => '0'));
            soft_input_2_4          <= (others => (others => '0'));
            soft_input_3_1          <= (others => (others => '0'));
            soft_input_3_2          <= (others => (others => '0'));
            soft_input_3_3          <= (others => (others => '0'));
            soft_input_3_4          <= (others => (others => '0'));
            soft_input_4_1          <= (others => (others => '0'));
            soft_input_4_2          <= (others => (others => '0'));
            soft_input_4_3          <= (others => (others => '0'));
            soft_input_4_4          <= (others => (others => '0'));
            index_2                 <= (others => (others => '0'));
            index_2_original        <= (others => (others => '0'));
            indi_1_1                <= (others => '0');
            indi_1_2                <= (others => '0');
            indi_1_3                <= (others => '0');
            indi_1_4                <= (others => '0');
            indi_2_1                <= (others => '0');
            indi_2_2                <= (others => '0');
            indi_2_3                <= (others => '0');
            indi_2_4                <= (others => '0');
            indi_3_1                <= (others => '0');
            indi_3_2                <= (others => '0');
            indi_3_3                <= (others => '0');
            indi_3_4                <= (others => '0');
            soft_output_unflipped_2 <= (others => (others => '0'));
        elsif (rising_edge(clk)) then
            soft_output_unflipped_2 <= soft_output_unflipped_1;
            soft_input_1_4          <= soft_input_1(63 downto 48);
            soft_input_1_3          <= soft_input_1(47 downto 32);
            soft_input_1_2          <= soft_input_1(31 downto 16);
            soft_input_1_1          <= soft_input_1(15 downto 0);
            soft_input_2_4          <= soft_input_2(63 downto 48);
            soft_input_2_3          <= soft_input_2(47 downto 32);
            soft_input_2_2          <= soft_input_2(31 downto 16);
            soft_input_2_1          <= soft_input_2(15 downto 0);
            soft_input_3_4          <= soft_input_3(63 downto 48);
            soft_input_3_3          <= soft_input_3(47 downto 32);
            soft_input_3_2          <= soft_input_3(31 downto 16);
            soft_input_3_1          <= soft_input_3(15 downto 0);
            soft_input_4_4          <= soft_input_4(63 downto 48);
            soft_input_4_3          <= soft_input_4(47 downto 32);
            soft_input_4_2          <= soft_input_4(31 downto 16);
            soft_input_4_1          <= soft_input_4(15 downto 0);
            index_2                 <= index_1;
            index_2_original        <= index_1_original;
            indi_1_1                <= "000";
            indi_1_2                <= "000";
            indi_1_3                <= "000";
            indi_1_4                <= "000";
            indi_2_1                <= "000";
            indi_2_2                <= "000";
            indi_2_3                <= "000";
            indi_2_4                <= "000";
            indi_3_1                <= "000";
            indi_3_2                <= "000";
            indi_3_3                <= "000";
            indi_3_4                <= "000";
            --------------------index category------------------------
            --indi_1 is for index(0)
            if indi_1 = "001" then
                if index_1(0) < 16 then
                    indi_1_1   <= "001";
                    index_2(0) <= index_1(0);
                elsif (15 < index_1(0)) and (index_1(0) < 32) then
                    indi_1_1   <= "010";
                    index_2(0) <= index_1(0) - 16;
                elsif (31 < index_1(0)) and (index_1(0) < 48) then
                    indi_1_1   <= "011";
                    index_2(0) <= index_1(0) - 32;
                else
                    indi_1_1   <= "100";
                    index_2(0) <= index_1(0) - 48;
                end if;
            elsif indi_1 = "010" then
                if index_1(0) < 16 then
                    indi_1_2   <= "001";
                    index_2(0) <= index_1(0);
                elsif (15 < index_1(0)) and (index_1(0) < 32) then
                    indi_1_2   <= "010";
                    index_2(0) <= index_1(0) - 16;
                elsif (31 < index_1(0)) and (index_1(0) < 48) then
                    indi_1_2   <= "011";
                    index_2(0) <= index_1(0) - 32;
                else
                    indi_1_2   <= "100";
                    index_2(0) <= index_1(0) - 48;
                end if;
            elsif indi_1 = "011" then
                if index_1(0) < 16 then
                    indi_1_3   <= "001";
                    index_2(0) <= index_1(0);
                elsif (15 < index_1(0)) and (index_1(0) < 32) then
                    indi_1_3   <= "010";
                    index_2(0) <= index_1(0) - 16;
                elsif (31 < index_1(0)) and (index_1(0) < 48) then
                    indi_1_3   <= "011";
                    index_2(0) <= index_1(0) - 32;
                else
                    indi_1_3   <= "100";
                    index_2(0) <= index_1(0) - 48;
                end if;
            elsif indi_1 = "100" then
                if index_1(0) < 16 then
                    indi_1_4   <= "001";
                    index_2(0) <= index_1(0);
                elsif (15 < index_1(0)) and (index_1(0) < 32) then
                    indi_1_4   <= "010";
                    index_2(0) <= index_1(0) - 16;
                elsif (31 < index_1(0)) and (index_1(0) < 48) then
                    indi_1_4   <= "011";
                    index_2(0) <= index_1(0) - 32;
                else
                    indi_1_4   <= "100";
                    index_2(0) <= index_1(0) - 48;
                end if;
            else
                indi_1_1   <= "000";
                indi_1_2   <= "000";
                indi_1_3   <= "000";
                indi_1_4   <= "000";
                index_2(0) <= (others => '0');
            end if;
            --------------------index category------------------------
            --indi_2 is for index(1)
            if indi_2 = "001" then
                if index_1(1) < 16 then
                    indi_2_1   <= "001";
                    index_2(1) <= index_1(1);
                elsif (15 < index_1(1)) and (index_1(1) < 32) then
                    indi_2_1   <= "010";
                    index_2(1) <= index_1(1) - 16;
                elsif (31 < index_1(1)) and (index_1(1) < 48) then
                    indi_2_1   <= "011";
                    index_2(1) <= index_1(1) - 32;
                else
                    indi_2_1   <= "100";
                    index_2(1) <= index_1(1) - 48;
                end if;
            elsif indi_2 = "010" then
                if index_1(1) < 16 then
                    indi_2_2   <= "001";
                    index_2(1) <= index_1(1);
                elsif (15 < index_1(1)) and (index_1(1) < 32) then
                    indi_2_2   <= "010";
                    index_2(1) <= index_1(1) - 16;
                elsif (31 < index_1(1)) and (index_1(1) < 48) then
                    indi_2_2   <= "011";
                    index_2(1) <= index_1(1) - 32;
                else
                    indi_2_2   <= "100";
                    index_2(1) <= index_1(1) - 48;
                end if;
            elsif indi_2 = "011" then
                if index_1(1) < 16 then
                    indi_2_3   <= "001";
                    index_2(1) <= index_1(1);
                elsif (15 < index_1(1)) and (index_1(1) < 32) then
                    indi_2_3   <= "010";
                    index_2(1) <= index_1(1) - 16;
                elsif (31 < index_1(1)) and (index_1(1) < 48) then
                    indi_2_3   <= "011";
                    index_2(1) <= index_1(1) - 32;
                else
                    indi_2_3   <= "100";
                    index_2(1) <= index_1(1) - 48;
                end if;
            elsif indi_2 = "100" then
                if index_1(1) < 16 then
                    indi_2_4   <= "001";
                    index_2(1) <= index_1(1);
                elsif (15 < index_1(1)) and (index_1(1) < 32) then
                    indi_2_4   <= "010";
                    index_2(1) <= index_1(1) - 16;
                elsif (31 < index_1(1)) and (index_1(1) < 48) then
                    indi_2_4   <= "011";
                    index_2(1) <= index_1(1) - 32;
                else
                    indi_2_4   <= "100";
                    index_2(1) <= index_1(1) - 48;
                end if;
            else
                indi_2_1   <= "000";
                indi_2_2   <= "000";
                indi_2_3   <= "000";
                indi_2_4   <= "000";
                index_2(1) <= (others => '0');
            end if;
            --------------------index category------------------------
            --indi_3 is for index(2)
            if indi_3 = "001" then
                if index_1(2) < 16 then
                    indi_3_1   <= "001";
                    index_2(2) <= index_1(2);
                elsif (15 < index_1(2)) and (index_1(2) < 32) then
                    indi_3_1   <= "010";
                    index_2(2) <= index_1(2) - 16;
                elsif (31 < index_1(2)) and (index_1(2) < 48) then
                    indi_3_1   <= "011";
                    index_2(2) <= index_1(2) - 32;
                else
                    indi_3_1   <= "100";
                    index_2(2) <= index_1(2) - 48;
                end if;
            elsif indi_3 = "010" then
                if index_1(2) < 16 then
                    indi_3_2   <= "001";
                    index_2(2) <= index_1(2);
                elsif (15 < index_1(2)) and (index_1(2) < 32) then
                    indi_3_2   <= "010";
                    index_2(2) <= index_1(2) - 16;
                elsif (31 < index_1(2)) and (index_1(2) < 48) then
                    indi_3_2   <= "011";
                    index_2(2) <= index_1(2) - 32;
                else
                    indi_3_2   <= "100";
                    index_2(2) <= index_1(2) - 48;
                end if;
            elsif indi_3 = "011" then
                if index_1(2) < 16 then
                    indi_3_3   <= "001";
                    index_2(2) <= index_1(2);
                elsif (15 < index_1(2)) and (index_1(2) < 32) then
                    indi_3_3   <= "010";
                    index_2(2) <= index_1(2) - 16;
                elsif (31 < index_1(2)) and (index_1(2) < 48) then
                    indi_3_3   <= "011";
                    index_2(2) <= index_1(2) - 32;
                else
                    indi_3_3   <= "100";
                    index_2(2) <= index_1(2) - 48;
                end if;
            elsif indi_3 = "100" then
                if index_1(2) < 16 then
                    indi_3_4   <= "001";
                    index_2(2) <= index_1(2);
                elsif (15 < index_1(2)) and (index_1(2) < 32) then
                    indi_3_4   <= "010";
                    index_2(2) <= index_1(2) - 16;
                elsif (31 < index_1(2)) and (index_1(2) < 48) then
                    indi_3_4   <= "011";
                    index_2(2) <= index_1(2) - 32;
                else
                    indi_3_4   <= "100";
                    index_2(2) <= index_1(2) - 48;
                end if;
            else
                indi_3_1   <= "000";
                indi_3_2   <= "000";
                indi_3_3   <= "000";
                indi_3_4   <= "000";
                index_2(2) <= (others => '0');
            end if;
        end if;
    end process;
    ------------------------------------------------------------------------------------------------------------
    -- Define processes : (CLK 3)
    ------------------------------------------------------------------------------------------------------------
    process (clk, reset)
    begin
        if (reset = '1') then
            index_3                 <= (others => (others => '0'));
            index_3_original        <= (others => (others => '0'));
            soft_input_1_1_4        <= (others => (others => '0'));
            soft_input_1_1_3        <= (others => (others => '0'));
            soft_input_1_1_2        <= (others => (others => '0'));
            soft_input_1_1_1        <= (others => (others => '0'));
            soft_input_1_2_4        <= (others => (others => '0'));
            soft_input_1_2_3        <= (others => (others => '0'));
            soft_input_1_2_2        <= (others => (others => '0'));
            soft_input_1_2_1        <= (others => (others => '0'));
            soft_input_1_3_4        <= (others => (others => '0'));
            soft_input_1_3_3        <= (others => (others => '0'));
            soft_input_1_3_2        <= (others => (others => '0'));
            soft_input_1_3_1        <= (others => (others => '0'));
            soft_input_1_4_4        <= (others => (others => '0'));
            soft_input_1_4_3        <= (others => (others => '0'));
            soft_input_1_4_2        <= (others => (others => '0'));
            soft_input_1_4_1        <= (others => (others => '0'));
            soft_input_2_1_4        <= (others => (others => '0'));
            soft_input_2_1_3        <= (others => (others => '0'));
            soft_input_2_1_2        <= (others => (others => '0'));
            soft_input_2_1_1        <= (others => (others => '0'));
            soft_input_2_2_4        <= (others => (others => '0'));
            soft_input_2_2_3        <= (others => (others => '0'));
            soft_input_2_2_2        <= (others => (others => '0'));
            soft_input_2_2_1        <= (others => (others => '0'));
            soft_input_2_3_4        <= (others => (others => '0'));
            soft_input_2_3_3        <= (others => (others => '0'));
            soft_input_2_3_2        <= (others => (others => '0'));
            soft_input_2_3_1        <= (others => (others => '0'));
            soft_input_2_4_4        <= (others => (others => '0'));
            soft_input_2_4_3        <= (others => (others => '0'));
            soft_input_2_4_2        <= (others => (others => '0'));
            soft_input_2_4_1        <= (others => (others => '0'));
            soft_input_3_1_4        <= (others => (others => '0'));
            soft_input_3_1_3        <= (others => (others => '0'));
            soft_input_3_1_2        <= (others => (others => '0'));
            soft_input_3_1_1        <= (others => (others => '0'));
            soft_input_3_2_4        <= (others => (others => '0'));
            soft_input_3_2_3        <= (others => (others => '0'));
            soft_input_3_2_2        <= (others => (others => '0'));
            soft_input_3_2_1        <= (others => (others => '0'));
            soft_input_3_3_4        <= (others => (others => '0'));
            soft_input_3_3_3        <= (others => (others => '0'));
            soft_input_3_3_2        <= (others => (others => '0'));
            soft_input_3_3_1        <= (others => (others => '0'));
            soft_input_3_4_4        <= (others => (others => '0'));
            soft_input_3_4_3        <= (others => (others => '0'));
            soft_input_3_4_2        <= (others => (others => '0'));
            soft_input_3_4_1        <= (others => (others => '0'));
            soft_input_4_1_4        <= (others => (others => '0'));
            soft_input_4_1_3        <= (others => (others => '0'));
            soft_input_4_1_2        <= (others => (others => '0'));
            soft_input_4_1_1        <= (others => (others => '0'));
            soft_input_4_2_4        <= (others => (others => '0'));
            soft_input_4_2_3        <= (others => (others => '0'));
            soft_input_4_2_2        <= (others => (others => '0'));
            soft_input_4_2_1        <= (others => (others => '0'));
            soft_input_4_3_4        <= (others => (others => '0'));
            soft_input_4_3_3        <= (others => (others => '0'));
            soft_input_4_3_2        <= (others => (others => '0'));
            soft_input_4_3_1        <= (others => (others => '0'));
            soft_input_4_4_4        <= (others => (others => '0'));
            soft_input_4_4_3        <= (others => (others => '0'));
            soft_input_4_4_2        <= (others => (others => '0'));
            soft_input_4_4_1        <= (others => (others => '0'));
            indi_1_1_1              <= (others => '0');
            indi_1_1_2              <= (others => '0');
            indi_1_1_3              <= (others => '0');
            indi_1_1_4              <= (others => '0');
            indi_1_2_1              <= (others => '0');
            indi_1_2_2              <= (others => '0');
            indi_1_2_3              <= (others => '0');
            indi_1_2_4              <= (others => '0');
            indi_1_3_1              <= (others => '0');
            indi_1_3_2              <= (others => '0');
            indi_1_3_3              <= (others => '0');
            indi_1_3_4              <= (others => '0');
            indi_1_4_1              <= (others => '0');
            indi_1_4_2              <= (others => '0');
            indi_1_4_3              <= (others => '0');
            indi_1_4_4              <= (others => '0');
            indi_2_1_1              <= (others => '0');
            indi_2_1_2              <= (others => '0');
            indi_2_1_3              <= (others => '0');
            indi_2_1_4              <= (others => '0');
            indi_2_2_1              <= (others => '0');
            indi_2_2_2              <= (others => '0');
            indi_2_2_3              <= (others => '0');
            indi_2_2_4              <= (others => '0');
            indi_2_3_1              <= (others => '0');
            indi_2_3_2              <= (others => '0');
            indi_2_3_3              <= (others => '0');
            indi_2_3_4              <= (others => '0');
            indi_2_4_1              <= (others => '0');
            indi_2_4_2              <= (others => '0');
            indi_2_4_3              <= (others => '0');
            indi_2_4_4              <= (others => '0');
            indi_3_1_1              <= (others => '0');
            indi_3_1_2              <= (others => '0');
            indi_3_1_3              <= (others => '0');
            indi_3_1_4              <= (others => '0');
            indi_3_2_1              <= (others => '0');
            indi_3_2_2              <= (others => '0');
            indi_3_2_3              <= (others => '0');
            indi_3_2_4              <= (others => '0');
            indi_3_3_1              <= (others => '0');
            indi_3_3_2              <= (others => '0');
            indi_3_3_3              <= (others => '0');
            indi_3_3_4              <= (others => '0');
            indi_3_4_1              <= (others => '0');
            indi_3_4_2              <= (others => '0');
            indi_3_4_3              <= (others => '0');
            indi_3_4_4              <= (others => '0');
            soft_output_unflipped_3 <= (others => (others => '0'));
        elsif (rising_edge(clk)) then
            soft_output_unflipped_3 <= soft_output_unflipped_2;
            soft_input_1_1_4        <= soft_input_1_1(15 downto 12);
            soft_input_1_1_3        <= soft_input_1_1(11 downto 8);
            soft_input_1_1_2        <= soft_input_1_1(7 downto 4);
            soft_input_1_1_1        <= soft_input_1_1(3 downto 0);
            soft_input_1_2_4        <= soft_input_1_2(15 downto 12);
            soft_input_1_2_3        <= soft_input_1_2(11 downto 8);
            soft_input_1_2_2        <= soft_input_1_2(7 downto 4);
            soft_input_1_2_1        <= soft_input_1_2(3 downto 0);
            soft_input_1_3_4        <= soft_input_1_3(15 downto 12);
            soft_input_1_3_3        <= soft_input_1_3(11 downto 8);
            soft_input_1_3_2        <= soft_input_1_3(7 downto 4);
            soft_input_1_3_1        <= soft_input_1_3(3 downto 0);
            soft_input_1_4_4        <= soft_input_1_4(15 downto 12);
            soft_input_1_4_3        <= soft_input_1_4(11 downto 8);
            soft_input_1_4_2        <= soft_input_1_4(7 downto 4);
            soft_input_1_4_1        <= soft_input_1_4(3 downto 0);
            soft_input_2_1_4        <= soft_input_2_1(15 downto 12);
            soft_input_2_1_3        <= soft_input_2_1(11 downto 8);
            soft_input_2_1_2        <= soft_input_2_1(7 downto 4);
            soft_input_2_1_1        <= soft_input_2_1(3 downto 0);
            soft_input_2_2_4        <= soft_input_2_2(15 downto 12);
            soft_input_2_2_3        <= soft_input_2_2(11 downto 8);
            soft_input_2_2_2        <= soft_input_2_2(7 downto 4);
            soft_input_2_2_1        <= soft_input_2_2(3 downto 0);
            soft_input_2_3_4        <= soft_input_2_3(15 downto 12);
            soft_input_2_3_3        <= soft_input_2_3(11 downto 8);
            soft_input_2_3_2        <= soft_input_2_3(7 downto 4);
            soft_input_2_3_1        <= soft_input_2_3(3 downto 0);
            soft_input_2_4_4        <= soft_input_2_4(15 downto 12);
            soft_input_2_4_3        <= soft_input_2_4(11 downto 8);
            soft_input_2_4_2        <= soft_input_2_4(7 downto 4);
            soft_input_2_4_1        <= soft_input_2_4(3 downto 0);
            soft_input_3_1_4        <= soft_input_3_1(15 downto 12);
            soft_input_3_1_3        <= soft_input_3_1(11 downto 8);
            soft_input_3_1_2        <= soft_input_3_1(7 downto 4);
            soft_input_3_1_1        <= soft_input_3_1(3 downto 0);
            soft_input_3_2_4        <= soft_input_3_2(15 downto 12);
            soft_input_3_2_3        <= soft_input_3_2(11 downto 8);
            soft_input_3_2_2        <= soft_input_3_2(7 downto 4);
            soft_input_3_2_1        <= soft_input_3_2(3 downto 0);
            soft_input_3_3_4        <= soft_input_3_3(15 downto 12);
            soft_input_3_3_3        <= soft_input_3_3(11 downto 8);
            soft_input_3_3_2        <= soft_input_3_3(7 downto 4);
            soft_input_3_3_1        <= soft_input_3_3(3 downto 0);
            soft_input_3_4_4        <= soft_input_3_4(15 downto 12);
            soft_input_3_4_3        <= soft_input_3_4(11 downto 8);
            soft_input_3_4_2        <= soft_input_3_4(7 downto 4);
            soft_input_3_4_1        <= soft_input_3_4(3 downto 0);
            soft_input_4_1_4        <= soft_input_4_1(15 downto 12);
            soft_input_4_1_3        <= soft_input_4_1(11 downto 8);
            soft_input_4_1_2        <= soft_input_4_1(7 downto 4);
            soft_input_4_1_1        <= soft_input_4_1(3 downto 0);
            soft_input_4_2_4        <= soft_input_4_2(15 downto 12);
            soft_input_4_2_3        <= soft_input_4_2(11 downto 8);
            soft_input_4_2_2        <= soft_input_4_2(7 downto 4);
            soft_input_4_2_1        <= soft_input_4_2(3 downto 0);
            soft_input_4_3_4        <= soft_input_4_3(15 downto 12);
            soft_input_4_3_3        <= soft_input_4_3(11 downto 8);
            soft_input_4_3_2        <= soft_input_4_3(7 downto 4);
            soft_input_4_3_1        <= soft_input_4_3(3 downto 0);
            soft_input_4_4_4        <= soft_input_4_4(15 downto 12);
            soft_input_4_4_3        <= soft_input_4_4(11 downto 8);
            soft_input_4_4_2        <= soft_input_4_4(7 downto 4);
            soft_input_4_4_1        <= soft_input_4_4(3 downto 0);
            index_3                 <= index_2;
            index_3_original        <= index_2_original;
            indi_1_1_1              <= (others => '0');
            indi_1_1_2              <= (others => '0');
            indi_1_1_3              <= (others => '0');
            indi_1_1_4              <= (others => '0');
            indi_1_2_1              <= (others => '0');
            indi_1_2_2              <= (others => '0');
            indi_1_2_3              <= (others => '0');
            indi_1_2_4              <= (others => '0');
            indi_1_3_1              <= (others => '0');
            indi_1_3_2              <= (others => '0');
            indi_1_3_3              <= (others => '0');
            indi_1_3_4              <= (others => '0');
            indi_1_4_1              <= (others => '0');
            indi_1_4_2              <= (others => '0');
            indi_1_4_3              <= (others => '0');
            indi_1_4_4              <= (others => '0');
            indi_2_1_1              <= (others => '0');
            indi_2_1_2              <= (others => '0');
            indi_2_1_3              <= (others => '0');
            indi_2_1_4              <= (others => '0');
            indi_2_2_1              <= (others => '0');
            indi_2_2_2              <= (others => '0');
            indi_2_2_3              <= (others => '0');
            indi_2_2_4              <= (others => '0');
            indi_2_3_1              <= (others => '0');
            indi_2_3_2              <= (others => '0');
            indi_2_3_3              <= (others => '0');
            indi_2_3_4              <= (others => '0');
            indi_2_4_1              <= (others => '0');
            indi_2_4_2              <= (others => '0');
            indi_2_4_3              <= (others => '0');
            indi_2_4_4              <= (others => '0');
            indi_3_1_1              <= (others => '0');
            indi_3_1_2              <= (others => '0');
            indi_3_1_3              <= (others => '0');
            indi_3_1_4              <= (others => '0');
            indi_3_2_1              <= (others => '0');
            indi_3_2_2              <= (others => '0');
            indi_3_2_3              <= (others => '0');
            indi_3_2_4              <= (others => '0');
            indi_3_3_1              <= (others => '0');
            indi_3_3_2              <= (others => '0');
            indi_3_3_3              <= (others => '0');
            indi_3_3_4              <= (others => '0');
            indi_3_4_1              <= (others => '0');
            indi_3_4_2              <= (others => '0');
            indi_3_4_3              <= (others => '0');
            indi_3_4_4              <= (others => '0');
            --------------------index category------------------------
            --indi_1_1, indi_1_2, indi_1_3, indi_1_4 are for index(0)
            if indi_1_1 = "001" then
                if index_2(0) < 4 then
                    indi_1_1_1 <= "001";
                    index_3(0) <= index_2(0);
                elsif (3 < index_2(0)) and (index_2(0) < 8) then
                    indi_1_1_1 <= "010";
                    index_3(0) <= index_2(0) - 4;
                elsif (7 < index_2(0)) and (index_2(0) < 12) then
                    indi_1_1_1 <= "011";
                    index_3(0) <= index_2(0) - 8;
                else
                    indi_1_1_1 <= "100";
                    index_3(0) <= index_2(0) - 12;
                end if;
            elsif indi_1_1 = "010" then
                if index_2(0) < 4 then
                    indi_1_1_2 <= "001";
                    index_3(0) <= index_2(0);
                elsif (3 < index_2(0)) and (index_2(0) < 8) then
                    indi_1_1_2 <= "010";
                    index_3(0) <= index_2(0) - 4;
                elsif (7 < index_2(0)) and (index_2(0) < 12) then
                    indi_1_1_2 <= "011";
                    index_3(0) <= index_2(0) - 8;
                else
                    indi_1_1_2 <= "100";
                    index_3(0) <= index_2(0) - 12;
                end if;
            elsif indi_1_1 = "011" then
                if index_2(0) < 4 then
                    indi_1_1_3 <= "001";
                    index_3(0) <= index_2(0);
                elsif (3 < index_2(0)) and (index_2(0) < 8) then
                    indi_1_1_3 <= "010";
                    index_3(0) <= index_2(0) - 4;
                elsif (7 < index_2(0)) and (index_2(0) < 12) then
                    indi_1_1_3 <= "011";
                    index_3(0) <= index_2(0) - 8;
                else
                    indi_1_1_3 <= "100";
                    index_3(0) <= index_2(0) - 12;
                end if;
            elsif indi_1_1 = "100" then
                if index_2(0) < 4 then
                    indi_1_1_4 <= "001";
                    index_3(0) <= index_2(0);
                elsif (3 < index_2(0)) and (index_2(0) < 8) then
                    indi_1_1_4 <= "010";
                    index_3(0) <= index_2(0) - 4;
                elsif (7 < index_2(0)) and (index_2(0) < 12) then
                    indi_1_1_4 <= "011";
                    index_3(0) <= index_2(0) - 8;
                else
                    indi_1_1_4 <= "100";
                    index_3(0) <= index_2(0) - 12;
                end if;
            else
                indi_1_1_1 <= "000";
                indi_1_1_2 <= "000";
                indi_1_1_3 <= "000";
                indi_1_1_4 <= "000";
            end if;
            ----------------------------------------------------------
            if indi_1_2 = "001" then
                if index_2(0) < 4 then
                    indi_1_2_1 <= "001";
                    index_3(0) <= index_2(0);
                elsif (3 < index_2(0)) and (index_2(0) < 8) then
                    indi_1_2_1 <= "010";
                    index_3(0) <= index_2(0) - 4;
                elsif (7 < index_2(0)) and (index_2(0) < 12) then
                    indi_1_2_1 <= "011";
                    index_3(0) <= index_2(0) - 8;
                else
                    indi_1_2_1 <= "100";
                    index_3(0) <= index_2(0) - 12;
                end if;
            elsif indi_1_2 = "010" then
                if index_2(0) < 4 then
                    indi_1_2_2 <= "001";
                    index_3(0) <= index_2(0);
                elsif (3 < index_2(0)) and (index_2(0) < 8) then
                    indi_1_2_2 <= "010";
                    index_3(0) <= index_2(0) - 4;
                elsif (7 < index_2(0)) and (index_2(0) < 12) then
                    indi_1_2_2 <= "011";
                    index_3(0) <= index_2(0) - 8;
                else
                    indi_1_2_2 <= "100";
                    index_3(0) <= index_2(0) - 12;
                end if;
            elsif indi_1_2 = "011" then
                if index_2(0) < 4 then
                    indi_1_2_3 <= "001";
                    index_3(0) <= index_2(0);
                elsif (3 < index_2(0)) and (index_2(0) < 8) then
                    indi_1_2_3 <= "010";
                    index_3(0) <= index_2(0) - 4;
                elsif (7 < index_2(0)) and (index_2(0) < 12) then
                    indi_1_2_3 <= "011";
                    index_3(0) <= index_2(0) - 8;
                else
                    indi_1_2_3 <= "100";
                    index_3(0) <= index_2(0) - 12;
                end if;
            elsif indi_1_2 = "100" then
                if index_2(0) < 4 then
                    indi_1_2_4 <= "001";
                    index_3(0) <= index_2(0);
                elsif (3 < index_2(0)) and (index_2(0) < 8) then
                    indi_1_2_4 <= "010";
                    index_3(0) <= index_2(0) - 4;
                elsif (7 < index_2(0)) and (index_2(0) < 12) then
                    indi_1_2_4 <= "011";
                    index_3(0) <= index_2(0) - 8;
                else
                    indi_1_2_4 <= "100";
                    index_3(0) <= index_2(0) - 12;
                end if;
            else
                indi_1_2_1 <= "000";
                indi_1_2_2 <= "000";
                indi_1_2_3 <= "000";
                indi_1_2_4 <= "000";
            end if;
            ----------------------------------------------------------
            if indi_1_3 = "001" then
                if index_2(0) < 4 then
                    indi_1_3_1 <= "001";
                    index_3(0) <= index_2(0);
                elsif (3 < index_2(0)) and (index_2(0) < 8) then
                    indi_1_3_1 <= "010";
                    index_3(0) <= index_2(0) - 4;
                elsif (7 < index_2(0)) and (index_2(0) < 12) then
                    indi_1_3_1 <= "011";
                    index_3(0) <= index_2(0) - 8;
                else
                    indi_1_3_1 <= "100";
                    index_3(0) <= index_2(0) - 12;
                end if;
            elsif indi_1_3 = "010" then
                if index_2(0) < 4 then
                    indi_1_3_2 <= "001";
                    index_3(0) <= index_2(0);
                elsif (3 < index_2(0)) and (index_2(0) < 8) then
                    indi_1_3_2 <= "010";
                    index_3(0) <= index_2(0) - 4;
                elsif (7 < index_2(0)) and (index_2(0) < 12) then
                    indi_1_3_2 <= "011";
                    index_3(0) <= index_2(0) - 8;
                else
                    indi_1_3_2 <= "100";
                    index_3(0) <= index_2(0) - 12;
                end if;
            elsif indi_1_3 = "011" then
                if index_2(0) < 4 then
                    indi_1_3_3 <= "001";
                    index_3(0) <= index_2(0);
                elsif (3 < index_2(0)) and (index_2(0) < 8) then
                    indi_1_3_3 <= "010";
                    index_3(0) <= index_2(0) - 4;
                elsif (7 < index_2(0)) and (index_2(0) < 12) then
                    indi_1_3_3 <= "011";
                    index_3(0) <= index_2(0) - 8;
                else
                    indi_1_3_3 <= "100";
                    index_3(0) <= index_2(0) - 12;
                end if;
            elsif indi_1_3 = "100" then
                if index_2(0) < 4 then
                    indi_1_3_4 <= "001";
                    index_3(0) <= index_2(0);
                elsif (3 < index_2(0)) and (index_2(0) < 8) then
                    indi_1_3_4 <= "010";
                    index_3(0) <= index_2(0) - 4;
                elsif (7 < index_2(0)) and (index_2(0) < 12) then
                    indi_1_3_4 <= "011";
                    index_3(0) <= index_2(0) - 8;
                else
                    indi_1_3_4 <= "100";
                    index_3(0) <= index_2(0) - 12;
                end if;
            else
                indi_1_3_1 <= "000";
                indi_1_3_2 <= "000";
                indi_1_3_3 <= "000";
                indi_1_3_4 <= "000";
            end if;
            ----------------------------------------------------------
            if indi_1_4 = "001" then
                if index_2(0) < 4 then
                    indi_1_4_1 <= "001";
                    index_3(0) <= index_2(0);
                elsif (3 < index_2(0)) and (index_2(0) < 8) then
                    indi_1_4_1 <= "010";
                    index_3(0) <= index_2(0) - 4;
                elsif (7 < index_2(0)) and (index_2(0) < 12) then
                    indi_1_4_1 <= "011";
                    index_3(0) <= index_2(0) - 8;
                else
                    indi_1_4_1 <= "100";
                    index_3(0) <= index_2(0) - 12;
                end if;
            elsif indi_1_4 = "010" then
                if index_2(0) < 4 then
                    indi_1_4_2 <= "001";
                    index_3(0) <= index_2(0);
                elsif (3 < index_2(0)) and (index_2(0) < 8) then
                    indi_1_4_2 <= "010";
                    index_3(0) <= index_2(0) - 4;
                elsif (7 < index_2(0)) and (index_2(0) < 12) then
                    indi_1_4_2 <= "011";
                    index_3(0) <= index_2(0) - 8;
                else
                    indi_1_4_2 <= "100";
                    index_3(0) <= index_2(0) - 12;
                end if;
            elsif indi_1_4 = "011" then
                if index_2(0) < 4 then
                    indi_1_4_3 <= "001";
                    index_3(0) <= index_2(0);
                elsif (3 < index_2(0)) and (index_2(0) < 8) then
                    indi_1_4_3 <= "010";
                    index_3(0) <= index_2(0) - 4;
                elsif (7 < index_2(0)) and (index_2(0) < 12) then
                    indi_1_4_3 <= "011";
                    index_3(0) <= index_2(0) - 8;
                else
                    indi_1_4_3 <= "100";
                    index_3(0) <= index_2(0) - 12;
                end if;
            elsif indi_1_4 = "100" then
                if index_2(0) < 4 then
                    indi_1_4_4 <= "001";
                    index_3(0) <= index_2(0);
                elsif (3 < index_2(0)) and (index_2(0) < 8) then
                    indi_1_4_4 <= "010";
                    index_3(0) <= index_2(0) - 4;
                elsif (7 < index_2(0)) and (index_2(0) < 12) then
                    indi_1_4_4 <= "011";
                    index_3(0) <= index_2(0) - 8;
                else
                    indi_1_4_4 <= "100";
                    index_3(0) <= index_2(0) - 12;
                end if;
            else
                indi_1_4_1 <= "000";
                indi_1_4_2 <= "000";
                indi_1_4_3 <= "000";
                indi_1_4_4 <= "000";
            end if;
            --------------------index category------------------------
            --indi_2_1, indi_2_2, indi_2_3, indi_2_4 are for index(1)
            if indi_2_1 = "001" then
                if index_2(1) < 4 then
                    indi_2_1_1 <= "001";
                    index_3(1) <= index_2(1);
                elsif (3 < index_2(1)) and (index_2(1) < 8) then
                    indi_2_1_1 <= "010";
                    index_3(1) <= index_2(1) - 4;
                elsif (7 < index_2(1)) and (index_2(1) < 12) then
                    indi_2_1_1 <= "011";
                    index_3(1) <= index_2(1) - 8;
                else
                    indi_2_1_1 <= "100";
                    index_3(1) <= index_2(1) - 12;
                end if;
            elsif indi_2_1 = "010" then
                if index_2(1) < 4 then
                    indi_2_1_2 <= "001";
                    index_3(1) <= index_2(1);
                elsif (3 < index_2(1)) and (index_2(1) < 8) then
                    indi_2_1_2 <= "010";
                    index_3(1) <= index_2(1) - 4;
                elsif (7 < index_2(1)) and (index_2(1) < 12) then
                    indi_2_1_2 <= "011";
                    index_3(1) <= index_2(1) - 8;
                else
                    indi_2_1_2 <= "100";
                    index_3(1) <= index_2(1) - 12;
                end if;
            elsif indi_2_1 = "011" then
                if index_2(1) < 4 then
                    indi_2_1_3 <= "001";
                    index_3(1) <= index_2(1);
                elsif (3 < index_2(1)) and (index_2(1) < 8) then
                    indi_2_1_3 <= "010";
                    index_3(1) <= index_2(1) - 4;
                elsif (7 < index_2(1)) and (index_2(1) < 12) then
                    indi_2_1_3 <= "011";
                    index_3(1) <= index_2(1) - 8;
                else
                    indi_2_1_3 <= "100";
                    index_3(1) <= index_2(1) - 12;
                end if;
            elsif indi_2_1 = "100" then
                if index_2(1) < 4 then
                    indi_2_1_4 <= "001";
                    index_3(1) <= index_2(1);
                elsif (3 < index_2(1)) and (index_2(1) < 8) then
                    indi_2_1_4 <= "010";
                    index_3(1) <= index_2(1) - 4;
                elsif (7 < index_2(1)) and (index_2(1) < 12) then
                    indi_2_1_4 <= "011";
                    index_3(1) <= index_2(1) - 8;
                else
                    indi_2_1_4 <= "100";
                    index_3(1) <= index_2(1) - 12;
                end if;
            else
                indi_2_1_1 <= "000";
                indi_2_1_2 <= "000";
                indi_2_1_3 <= "000";
                indi_2_1_4 <= "000";
            end if;
            ----------------------------------------------------------
            if indi_2_2 = "001" then
                if index_2(1) < 4 then
                    indi_2_2_1 <= "001";
                    index_3(1) <= index_2(1);
                elsif (3 < index_2(1)) and (index_2(1) < 8) then
                    indi_2_2_1 <= "010";
                    index_3(1) <= index_2(1) - 4;
                elsif (7 < index_2(1)) and (index_2(1) < 12) then
                    indi_2_2_1 <= "011";
                    index_3(1) <= index_2(1) - 8;
                else
                    indi_2_2_1 <= "100";
                    index_3(1) <= index_2(1) - 12;
                end if;
            elsif indi_2_2 = "010" then
                if index_2(1) < 4 then
                    indi_2_2_2 <= "001";
                    index_3(1) <= index_2(1);
                elsif (3 < index_2(1)) and (index_2(1) < 8) then
                    indi_2_2_2 <= "010";
                    index_3(1) <= index_2(1) - 4;
                elsif (7 < index_2(1)) and (index_2(1) < 12) then
                    indi_2_2_2 <= "011";
                    index_3(1) <= index_2(1) - 8;
                else
                    indi_2_2_2 <= "100";
                    index_3(1) <= index_2(1) - 12;
                end if;
            elsif indi_2_2 = "011" then
                if index_2(1) < 4 then
                    indi_2_2_3 <= "001";
                    index_3(1) <= index_2(1);
                elsif (3 < index_2(1)) and (index_2(1) < 8) then
                    indi_2_2_3 <= "010";
                    index_3(1) <= index_2(1) - 4;
                elsif (7 < index_2(1)) and (index_2(1) < 12) then
                    indi_2_2_3 <= "011";
                    index_3(1) <= index_2(1) - 8;
                else
                    indi_2_2_3 <= "100";
                    index_3(1) <= index_2(1) - 12;
                end if;
            elsif indi_2_2 = "100" then
                if index_2(1) < 4 then
                    indi_2_2_4 <= "001";
                    index_3(1) <= index_2(1);
                elsif (3 < index_2(1)) and (index_2(1) < 8) then
                    indi_2_2_4 <= "010";
                    index_3(1) <= index_2(1) - 4;
                elsif (7 < index_2(1)) and (index_2(1) < 12) then
                    indi_2_2_4 <= "011";
                    index_3(1) <= index_2(1) - 8;
                else
                    indi_2_2_4 <= "100";
                    index_3(1) <= index_2(1) - 12;
                end if;
            else
                indi_2_2_1 <= "000";
                indi_2_2_2 <= "000";
                indi_2_2_3 <= "000";
                indi_2_2_4 <= "000";
            end if;
            ----------------------------------------------------------
            if indi_2_3 = "001" then
                if index_2(1) < 4 then
                    indi_2_3_1 <= "001";
                    index_3(1) <= index_2(1);
                elsif (3 < index_2(1)) and (index_2(1) < 8) then
                    indi_2_3_1 <= "010";
                    index_3(1) <= index_2(1) - 4;
                elsif (7 < index_2(1)) and (index_2(1) < 12) then
                    indi_2_3_1 <= "011";
                    index_3(1) <= index_2(1) - 8;
                else
                    indi_2_3_1 <= "100";
                    index_3(1) <= index_2(1) - 12;
                end if;
            elsif indi_2_3 = "010" then
                if index_2(1) < 4 then
                    indi_2_3_2 <= "001";
                    index_3(1) <= index_2(1);
                elsif (3 < index_2(1)) and (index_2(1) < 8) then
                    indi_2_3_2 <= "010";
                    index_3(1) <= index_2(1) - 4;
                elsif (7 < index_2(1)) and (index_2(1) < 12) then
                    indi_2_3_2 <= "011";
                    index_3(1) <= index_2(1) - 8;
                else
                    indi_2_3_2 <= "100";
                    index_3(1) <= index_2(1) - 12;
                end if;
            elsif indi_2_3 = "011" then
                if index_2(1) < 4 then
                    indi_2_3_3 <= "001";
                    index_3(1) <= index_2(1);
                elsif (3 < index_2(1)) and (index_2(1) < 8) then
                    indi_2_3_3 <= "010";
                    index_3(1) <= index_2(1) - 4;
                elsif (7 < index_2(1)) and (index_2(1) < 12) then
                    indi_2_3_3 <= "011";
                    index_3(1) <= index_2(1) - 8;
                else
                    indi_2_3_3 <= "100";
                    index_3(1) <= index_2(1) - 12;
                end if;
            elsif indi_2_3 = "100" then
                if index_2(1) < 4 then
                    indi_2_3_4 <= "001";
                    index_3(1) <= index_2(1);
                elsif (3 < index_2(1)) and (index_2(1) < 8) then
                    indi_2_3_4 <= "010";
                    index_3(1) <= index_2(1) - 4;
                elsif (7 < index_2(1)) and (index_2(1) < 12) then
                    indi_2_3_4 <= "011";
                    index_3(1) <= index_2(1) - 8;
                else
                    indi_2_3_4 <= "100";
                    index_3(1) <= index_2(1) - 12;
                end if;
            else
                indi_2_3_1 <= "000";
                indi_2_3_2 <= "000";
                indi_2_3_3 <= "000";
                indi_2_3_4 <= "000";
            end if;
            ----------------------------------------------------------
            if indi_2_4 = "001" then
                if index_2(1) < 4 then
                    indi_2_4_1 <= "001";
                    index_3(1) <= index_2(1);
                elsif (3 < index_2(1)) and (index_2(1) < 8) then
                    indi_2_4_1 <= "010";
                    index_3(1) <= index_2(1) - 4;
                elsif (7 < index_2(1)) and (index_2(1) < 12) then
                    indi_2_4_1 <= "011";
                    index_3(1) <= index_2(1) - 8;
                else
                    indi_2_4_1 <= "100";
                    index_3(1) <= index_2(1) - 12;
                end if;
            elsif indi_2_4 = "010" then
                if index_2(1) < 4 then
                    indi_2_4_2 <= "001";
                    index_3(1) <= index_2(1);
                elsif (3 < index_2(1)) and (index_2(1) < 8) then
                    indi_2_4_2 <= "010";
                    index_3(1) <= index_2(1) - 4;
                elsif (7 < index_2(1)) and (index_2(1) < 12) then
                    indi_2_4_2 <= "011";
                    index_3(1) <= index_2(1) - 8;
                else
                    indi_2_4_2 <= "100";
                    index_3(1) <= index_2(1) - 12;
                end if;
            elsif indi_2_4 = "011" then
                if index_2(1) < 4 then
                    indi_2_4_3 <= "001";
                    index_3(1) <= index_2(1);
                elsif (3 < index_2(1)) and (index_2(1) < 8) then
                    indi_2_4_3 <= "010";
                    index_3(1) <= index_2(1) - 4;
                elsif (7 < index_2(1)) and (index_2(1) < 12) then
                    indi_2_4_3 <= "011";
                    index_3(1) <= index_2(1) - 8;
                else
                    indi_2_4_3 <= "100";
                    index_3(1) <= index_2(1) - 12;
                end if;
            elsif indi_2_4 = "100" then
                if index_2(1) < 4 then
                    indi_2_4_4 <= "001";
                    index_3(1) <= index_2(1);
                elsif (3 < index_2(1)) and (index_2(1) < 8) then
                    indi_2_4_4 <= "010";
                    index_3(1) <= index_2(1) - 4;
                elsif (7 < index_2(1)) and (index_2(1) < 12) then
                    indi_2_4_4 <= "011";
                    index_3(1) <= index_2(1) - 8;
                else
                    indi_2_4_4 <= "100";
                    index_3(1) <= index_2(1) - 12;
                end if;
            else
                indi_2_4_1 <= "000";
                indi_2_4_2 <= "000";
                indi_2_4_3 <= "000";
                indi_2_4_4 <= "000";
            end if;
            --------------------index category------------------------
            --indi_3_1, indi_3_2, indi_3_3, indi_3_4 are for index(2)
            if indi_3_1 = "001" then
                if index_2(2) < 4 then
                    indi_3_1_1 <= "001";
                    index_3(2) <= index_2(2);
                elsif (3 < index_2(2)) and (index_2(2) < 8) then
                    indi_3_1_1 <= "010";
                    index_3(2) <= index_2(2) - 4;
                elsif (7 < index_2(2)) and (index_2(2) < 12) then
                    indi_3_1_1 <= "011";
                    index_3(2) <= index_2(2) - 8;
                else
                    indi_3_1_1 <= "100";
                    index_3(2) <= index_2(2) - 12;
                end if;
            elsif indi_3_1 = "010" then
                if index_2(2) < 4 then
                    indi_3_1_2 <= "001";
                    index_3(2) <= index_2(2);
                elsif (3 < index_2(2)) and (index_2(2) < 8) then
                    indi_3_1_2 <= "010";
                    index_3(2) <= index_2(2) - 4;
                elsif (7 < index_2(2)) and (index_2(2) < 12) then
                    indi_3_1_2 <= "011";
                    index_3(2) <= index_2(2) - 8;
                else
                    indi_3_1_2 <= "100";
                    index_3(2) <= index_2(2) - 12;
                end if;
            elsif indi_3_1 = "011" then
                if index_2(2) < 4 then
                    indi_3_1_3 <= "001";
                    index_3(2) <= index_2(2);
                elsif (3 < index_2(2)) and (index_2(2) < 8) then
                    indi_3_1_3 <= "010";
                    index_3(2) <= index_2(2) - 4;
                elsif (7 < index_2(2)) and (index_2(2) < 12) then
                    indi_3_1_3 <= "011";
                    index_3(2) <= index_2(2) - 8;
                else
                    indi_3_1_3 <= "100";
                    index_3(2) <= index_2(2) - 12;
                end if;
            elsif indi_2_1 = "100" then
                if index_2(2) < 4 then
                    indi_3_1_4 <= "001";
                    index_3(2) <= index_2(2);
                elsif (3 < index_2(2)) and (index_2(2) < 8) then
                    indi_3_1_4 <= "010";
                    index_3(2) <= index_2(2) - 4;
                elsif (7 < index_2(2)) and (index_2(2) < 12) then
                    indi_3_1_4 <= "011";
                    index_3(2) <= index_2(2) - 8;
                else
                    indi_3_1_4 <= "100";
                    index_3(2) <= index_2(2) - 12;
                end if;
            else
                indi_3_1_1 <= "000";
                indi_3_1_2 <= "000";
                indi_3_1_3 <= "000";
                indi_3_1_4 <= "000";
            end if;
            ----------------------------------------------------------
            if indi_3_2 = "001" then
                if index_2(2) < 4 then
                    indi_3_2_1 <= "001";
                    index_3(2) <= index_2(2);
                elsif (3 < index_2(2)) and (index_2(2) < 8) then
                    indi_3_2_1 <= "010";
                    index_3(2) <= index_2(2) - 4;
                elsif (7 < index_2(2)) and (index_2(2) < 12) then
                    indi_3_2_1 <= "011";
                    index_3(2) <= index_2(2) - 8;
                else
                    indi_3_2_1 <= "100";
                    index_3(2) <= index_2(2) - 12;
                end if;
            elsif indi_3_2 = "010" then
                if index_2(2) < 4 then
                    indi_3_2_2 <= "001";
                    index_3(2) <= index_2(2);
                elsif (3 < index_2(2)) and (index_2(2) < 8) then
                    indi_3_2_2 <= "010";
                    index_3(2) <= index_2(2) - 4;
                elsif (7 < index_2(2)) and (index_2(2) < 12) then
                    indi_3_2_2 <= "011";
                    index_3(2) <= index_2(2) - 8;
                else
                    indi_3_2_2 <= "100";
                    index_3(2) <= index_2(2) - 12;
                end if;
            elsif indi_3_2 = "011" then
                if index_2(2) < 4 then
                    indi_3_2_3 <= "001";
                    index_3(2) <= index_2(2);
                elsif (3 < index_2(2)) and (index_2(2) < 8) then
                    indi_3_2_3 <= "010";
                    index_3(2) <= index_2(2) - 4;
                elsif (7 < index_2(2)) and (index_2(2) < 12) then
                    indi_3_2_3 <= "011";
                    index_3(2) <= index_2(2) - 8;
                else
                    indi_3_2_3 <= "100";
                    index_3(2) <= index_2(2) - 12;
                end if;
            elsif indi_3_2 = "100" then
                if index_2(2) < 4 then
                    indi_3_2_4 <= "001";
                    index_3(2) <= index_2(2);
                elsif (3 < index_2(2)) and (index_2(2) < 8) then
                    indi_3_2_4 <= "010";
                    index_3(2) <= index_2(2) - 4;
                elsif (7 < index_2(2)) and (index_2(2) < 12) then
                    indi_3_2_4 <= "011";
                    index_3(2) <= index_2(2) - 8;
                else
                    indi_3_2_4 <= "100";
                    index_3(2) <= index_2(2) - 12;
                end if;
            else
                indi_3_2_1 <= "000";
                indi_3_2_2 <= "000";
                indi_3_2_3 <= "000";
                indi_3_2_4 <= "000";
            end if;
            ----------------------------------------------------------
            if indi_3_3 = "001" then
                if index_2(2) < 4 then
                    indi_3_3_1 <= "001";
                    index_3(2) <= index_2(2);
                elsif (3 < index_2(2)) and (index_2(2) < 8) then
                    indi_3_3_1 <= "010";
                    index_3(2) <= index_2(2) - 4;
                elsif (7 < index_2(2)) and (index_2(2) < 12) then
                    indi_3_3_1 <= "011";
                    index_3(2) <= index_2(2) - 8;
                else
                    indi_3_3_1 <= "100";
                    index_3(2) <= index_2(2) - 12;
                end if;
            elsif indi_3_3 = "010" then
                if index_2(2) < 4 then
                    indi_3_3_2 <= "001";
                    index_3(2) <= index_2(2);
                elsif (3 < index_2(2)) and (index_2(2) < 8) then
                    indi_3_3_2 <= "010";
                    index_3(2) <= index_2(2) - 4;
                elsif (7 < index_2(2)) and (index_2(2) < 12) then
                    indi_3_3_2 <= "011";
                    index_3(2) <= index_2(2) - 8;
                else
                    indi_3_3_2 <= "100";
                    index_3(2) <= index_2(2) - 12;
                end if;
            elsif indi_3_3 = "011" then
                if index_2(2) < 4 then
                    indi_3_3_3 <= "001";
                    index_3(2) <= index_2(2);
                elsif (3 < index_2(2)) and (index_2(2) < 8) then
                    indi_3_3_3 <= "010";
                    index_3(2) <= index_2(2) - 4;
                elsif (7 < index_2(2)) and (index_2(2) < 12) then
                    indi_3_3_3 <= "011";
                    index_3(2) <= index_2(2) - 8;
                else
                    indi_3_3_3 <= "100";
                    index_3(2) <= index_2(2) - 12;
                end if;
            elsif indi_3_3 = "100" then
                if index_2(2) < 4 then
                    indi_3_3_4 <= "001";
                    index_3(2) <= index_2(2);
                elsif (3 < index_2(2)) and (index_2(2) < 8) then
                    indi_3_3_4 <= "010";
                    index_3(2) <= index_2(2) - 4;
                elsif (7 < index_2(2)) and (index_2(2) < 12) then
                    indi_3_3_4 <= "011";
                    index_3(2) <= index_2(2) - 8;
                else
                    indi_3_3_4 <= "100";
                    index_3(2) <= index_2(2) - 12;
                end if;
            else
                indi_3_3_1 <= "000";
                indi_3_3_2 <= "000";
                indi_3_3_3 <= "000";
                indi_3_3_4 <= "000";
            end if;
            ----------------------------------------------------------
            if indi_3_4 = "001" then
                if index_2(2) < 4 then
                    indi_3_4_1 <= "001";
                    index_3(2) <= index_2(2);
                elsif (3 < index_2(2)) and (index_2(2) < 8) then
                    indi_3_4_1 <= "010";
                    index_3(2) <= index_2(2) - 4;
                elsif (7 < index_2(2)) and (index_2(2) < 12) then
                    indi_3_4_1 <= "011";
                    index_3(2) <= index_2(2) - 8;
                else
                    indi_3_4_1 <= "100";
                    index_3(2) <= index_2(2) - 12;
                end if;
            elsif indi_3_4 = "010" then
                if index_2(2) < 4 then
                    indi_3_4_2 <= "001";
                    index_3(2) <= index_2(2);
                elsif (3 < index_2(2)) and (index_2(2) < 8) then
                    indi_3_4_2 <= "010";
                    index_3(2) <= index_2(2) - 4;
                elsif (7 < index_2(2)) and (index_2(2) < 12) then
                    indi_3_4_2 <= "011";
                    index_3(2) <= index_2(2) - 8;
                else
                    indi_3_4_2 <= "100";
                    index_3(2) <= index_2(2) - 12;
                end if;
            elsif indi_3_4 = "011" then
                if index_2(2) < 4 then
                    indi_3_4_3 <= "001";
                    index_3(2) <= index_2(2);
                elsif (3 < index_2(2)) and (index_2(2) < 8) then
                    indi_3_4_3 <= "010";
                    index_3(2) <= index_2(2) - 4;
                elsif (7 < index_2(2)) and (index_2(2) < 12) then
                    indi_3_4_3 <= "011";
                    index_3(2) <= index_2(2) - 8;
                else
                    indi_3_4_3 <= "100";
                    index_3(2) <= index_2(2) - 12;
                end if;
            elsif indi_3_4 = "100" then
                if index_2(2) < 4 then
                    indi_3_4_4 <= "001";
                    index_3(2) <= index_2(2);
                elsif (3 < index_2(2)) and (index_2(2) < 8) then
                    indi_3_4_4 <= "010";
                    index_3(2) <= index_2(2) - 4;
                elsif (7 < index_2(2)) and (index_2(2) < 12) then
                    indi_3_4_4 <= "011";
                    index_3(2) <= index_2(2) - 8;
                else
                    indi_3_4_4 <= "100";
                    index_3(2) <= index_2(2) - 12;
                end if;
            else
                indi_3_4_1 <= "000";
                indi_3_4_2 <= "000";
                indi_3_4_3 <= "000";
                indi_3_4_4 <= "000";
            end if;
        end if;
    end process;
    ------------------------------------------------------------------------------------------------------------
    -- Define processes : (CLK 4)
    ------------------------------------------------------------------------------------------------------------
    process (clk, reset)
    begin
        if (reset = '1') then
            weight_info_1           <= (others => (others => '0'));
            soft_input_1_1_1_flip_1 <= (others => (others => '0'));
            soft_input_1_1_2_flip_1 <= (others => (others => '0'));
            soft_input_1_1_3_flip_1 <= (others => (others => '0'));
            soft_input_1_1_4_flip_1 <= (others => (others => '0'));
            soft_input_1_2_1_flip_1 <= (others => (others => '0'));
            soft_input_1_2_2_flip_1 <= (others => (others => '0'));
            soft_input_1_2_3_flip_1 <= (others => (others => '0'));
            soft_input_1_2_4_flip_1 <= (others => (others => '0'));
            soft_input_1_3_1_flip_1 <= (others => (others => '0'));
            soft_input_1_3_2_flip_1 <= (others => (others => '0'));
            soft_input_1_3_3_flip_1 <= (others => (others => '0'));
            soft_input_1_3_4_flip_1 <= (others => (others => '0'));
            soft_input_1_4_1_flip_1 <= (others => (others => '0'));
            soft_input_1_4_2_flip_1 <= (others => (others => '0'));
            soft_input_1_4_3_flip_1 <= (others => (others => '0'));
            soft_input_1_4_4_flip_1 <= (others => (others => '0'));
            soft_input_2_1_1_flip_1 <= (others => (others => '0'));
            soft_input_2_1_2_flip_1 <= (others => (others => '0'));
            soft_input_2_1_3_flip_1 <= (others => (others => '0'));
            soft_input_2_1_4_flip_1 <= (others => (others => '0'));
            soft_input_2_2_1_flip_1 <= (others => (others => '0'));
            soft_input_2_2_2_flip_1 <= (others => (others => '0'));
            soft_input_2_2_3_flip_1 <= (others => (others => '0'));
            soft_input_2_2_4_flip_1 <= (others => (others => '0'));
            soft_input_2_3_1_flip_1 <= (others => (others => '0'));
            soft_input_2_3_2_flip_1 <= (others => (others => '0'));
            soft_input_2_3_3_flip_1 <= (others => (others => '0'));
            soft_input_2_3_4_flip_1 <= (others => (others => '0'));
            soft_input_2_4_1_flip_1 <= (others => (others => '0'));
            soft_input_2_4_2_flip_1 <= (others => (others => '0'));
            soft_input_2_4_3_flip_1 <= (others => (others => '0'));
            soft_input_2_4_4_flip_1 <= (others => (others => '0'));
            soft_input_3_1_1_flip_1 <= (others => (others => '0'));
            soft_input_3_1_2_flip_1 <= (others => (others => '0'));
            soft_input_3_1_3_flip_1 <= (others => (others => '0'));
            soft_input_3_1_4_flip_1 <= (others => (others => '0'));
            soft_input_3_2_1_flip_1 <= (others => (others => '0'));
            soft_input_3_2_2_flip_1 <= (others => (others => '0'));
            soft_input_3_2_3_flip_1 <= (others => (others => '0'));
            soft_input_3_2_4_flip_1 <= (others => (others => '0'));
            soft_input_3_3_1_flip_1 <= (others => (others => '0'));
            soft_input_3_3_2_flip_1 <= (others => (others => '0'));
            soft_input_3_3_3_flip_1 <= (others => (others => '0'));
            soft_input_3_3_4_flip_1 <= (others => (others => '0'));
            soft_input_3_4_1_flip_1 <= (others => (others => '0'));
            soft_input_3_4_2_flip_1 <= (others => (others => '0'));
            soft_input_3_4_3_flip_1 <= (others => (others => '0'));
            soft_input_3_4_4_flip_1 <= (others => (others => '0'));
            soft_input_4_1_1_flip_1 <= (others => (others => '0'));
            soft_input_4_1_2_flip_1 <= (others => (others => '0'));
            soft_input_4_1_3_flip_1 <= (others => (others => '0'));
            soft_input_4_1_4_flip_1 <= (others => (others => '0'));
            soft_input_4_2_1_flip_1 <= (others => (others => '0'));
            soft_input_4_2_2_flip_1 <= (others => (others => '0'));
            soft_input_4_2_3_flip_1 <= (others => (others => '0'));
            soft_input_4_2_4_flip_1 <= (others => (others => '0'));
            soft_input_4_3_1_flip_1 <= (others => (others => '0'));
            soft_input_4_3_2_flip_1 <= (others => (others => '0'));
            soft_input_4_3_3_flip_1 <= (others => (others => '0'));
            soft_input_4_3_4_flip_1 <= (others => (others => '0'));
            soft_input_4_4_1_flip_1 <= (others => (others => '0'));
            soft_input_4_4_2_flip_1 <= (others => (others => '0'));
            soft_input_4_4_3_flip_1 <= (others => (others => '0'));
            soft_input_4_4_4_flip_1 <= (others => (others => '0'));
            indi_2_1_1_pass_1       <= (others => '0');
            indi_2_1_2_pass_1       <= (others => '0');
            indi_2_1_3_pass_1       <= (others => '0');
            indi_2_1_4_pass_1       <= (others => '0');
            indi_2_2_1_pass_1       <= (others => '0');
            indi_2_2_2_pass_1       <= (others => '0');
            indi_2_2_3_pass_1       <= (others => '0');
            indi_2_2_4_pass_1       <= (others => '0');
            indi_2_3_1_pass_1       <= (others => '0');
            indi_2_3_2_pass_1       <= (others => '0');
            indi_2_3_3_pass_1       <= (others => '0');
            indi_2_3_4_pass_1       <= (others => '0');
            indi_2_4_1_pass_1       <= (others => '0');
            indi_2_4_2_pass_1       <= (others => '0');
            indi_2_4_3_pass_1       <= (others => '0');
            indi_2_4_4_pass_1       <= (others => '0');
            indi_3_1_1_pass_1       <= (others => '0');
            indi_3_1_2_pass_1       <= (others => '0');
            indi_3_1_3_pass_1       <= (others => '0');
            indi_3_1_4_pass_1       <= (others => '0');
            indi_3_2_1_pass_1       <= (others => '0');
            indi_3_2_2_pass_1       <= (others => '0');
            indi_3_2_3_pass_1       <= (others => '0');
            indi_3_2_4_pass_1       <= (others => '0');
            indi_3_3_1_pass_1       <= (others => '0');
            indi_3_3_2_pass_1       <= (others => '0');
            indi_3_3_3_pass_1       <= (others => '0');
            indi_3_3_4_pass_1       <= (others => '0');
            indi_3_4_1_pass_1       <= (others => '0');
            indi_3_4_2_pass_1       <= (others => '0');
            indi_3_4_3_pass_1       <= (others => '0');
            indi_3_4_4_pass_1       <= (others => '0');
            soft_output_unflipped_4 <= (others => (others => '0'));
            index_4                 <= (others => (others => '0'));
            index_4_original        <= (others => (others => '0'));
        elsif (rising_edge(clk)) then
            soft_output_unflipped_4 <= soft_output_unflipped_3;
            indi_2_1_1_pass_1       <= indi_2_1_1;
            indi_2_1_2_pass_1       <= indi_2_1_2;
            indi_2_1_3_pass_1       <= indi_2_1_3;
            indi_2_1_4_pass_1       <= indi_2_1_4;
            indi_2_2_1_pass_1       <= indi_2_2_1;
            indi_2_2_2_pass_1       <= indi_2_2_2;
            indi_2_2_3_pass_1       <= indi_2_2_3;
            indi_2_2_4_pass_1       <= indi_2_2_4;
            indi_2_3_1_pass_1       <= indi_2_3_1;
            indi_2_3_2_pass_1       <= indi_2_3_2;
            indi_2_3_3_pass_1       <= indi_2_3_3;
            indi_2_3_4_pass_1       <= indi_2_3_4;
            indi_2_4_1_pass_1       <= indi_2_4_1;
            indi_2_4_2_pass_1       <= indi_2_4_2;
            indi_2_4_3_pass_1       <= indi_2_4_3;
            indi_2_4_4_pass_1       <= indi_2_4_4;
            indi_3_1_1_pass_1       <= indi_3_1_1;
            indi_3_1_2_pass_1       <= indi_3_1_2;
            indi_3_1_3_pass_1       <= indi_3_1_3;
            indi_3_1_4_pass_1       <= indi_3_1_4;
            indi_3_2_1_pass_1       <= indi_3_2_1;
            indi_3_2_2_pass_1       <= indi_3_2_2;
            indi_3_2_3_pass_1       <= indi_3_2_3;
            indi_3_2_4_pass_1       <= indi_3_2_4;
            indi_3_3_1_pass_1       <= indi_3_3_1;
            indi_3_3_2_pass_1       <= indi_3_3_2;
            indi_3_3_3_pass_1       <= indi_3_3_3;
            indi_3_3_4_pass_1       <= indi_3_3_4;
            indi_3_4_1_pass_1       <= indi_3_4_1;
            indi_3_4_2_pass_1       <= indi_3_4_2;
            indi_3_4_3_pass_1       <= indi_3_4_3;
            indi_3_4_4_pass_1       <= indi_3_4_4;
            index_4                 <= index_3;
            index_4_original        <= index_3_original;
            weight_info_1           <= (others => (others => '0'));
            if indi_1_1_1 = "001" then
                soft_input_1_1_1_flip_1                                   <= soft_input_1_1_1;
                soft_input_1_1_2_flip_1                                   <= soft_input_1_1_2;
                soft_input_1_1_3_flip_1                                   <= soft_input_1_1_3;
                soft_input_1_1_4_flip_1                                   <= soft_input_1_1_4;
                soft_input_1_1_1_flip_1(to_integer(unsigned(index_3(0)))) <= not soft_input_1_1_1(to_integer(unsigned(index_3(0)))) + '1';
                weight_info_1(1)                                          <= soft_input_1_1_1(to_integer(unsigned(index_3(0))));
            elsif indi_1_1_1 = "010" then
                soft_input_1_1_1_flip_1                                   <= soft_input_1_1_1;
                soft_input_1_1_2_flip_1                                   <= soft_input_1_1_2;
                soft_input_1_1_3_flip_1                                   <= soft_input_1_1_3;
                soft_input_1_1_4_flip_1                                   <= soft_input_1_1_4;
                soft_input_1_1_2_flip_1(to_integer(unsigned(index_3(0)))) <= not soft_input_1_1_2(to_integer(unsigned(index_3(0)))) + '1';
                weight_info_1(1)                                          <= soft_input_1_1_2(to_integer(unsigned(index_3(0))));
            elsif indi_1_1_1 = "011" then
                soft_input_1_1_1_flip_1                                   <= soft_input_1_1_1;
                soft_input_1_1_2_flip_1                                   <= soft_input_1_1_2;
                soft_input_1_1_3_flip_1                                   <= soft_input_1_1_3;
                soft_input_1_1_4_flip_1                                   <= soft_input_1_1_4;
                soft_input_1_1_3_flip_1(to_integer(unsigned(index_3(0)))) <= not soft_input_1_1_3(to_integer(unsigned(index_3(0)))) + '1';
                weight_info_1(1)                                          <= soft_input_1_1_3(to_integer(unsigned(index_3(0))));
            elsif indi_1_1_1 = "100" then
                soft_input_1_1_1_flip_1                                   <= soft_input_1_1_1;
                soft_input_1_1_2_flip_1                                   <= soft_input_1_1_2;
                soft_input_1_1_3_flip_1                                   <= soft_input_1_1_3;
                soft_input_1_1_4_flip_1                                   <= soft_input_1_1_4;
                soft_input_1_1_4_flip_1(to_integer(unsigned(index_3(0)))) <= not soft_input_1_1_4(to_integer(unsigned(index_3(0)))) + '1';
                weight_info_1(1)                                          <= soft_input_1_1_4(to_integer(unsigned(index_3(0))));
            else
                soft_input_1_1_1_flip_1 <= soft_input_1_1_1;
                soft_input_1_1_2_flip_1 <= soft_input_1_1_2;
                soft_input_1_1_3_flip_1 <= soft_input_1_1_3;
                soft_input_1_1_4_flip_1 <= soft_input_1_1_4;
            end if;
            ------------------------------------------------------------------------------------------------------------------------------------
            if indi_1_1_2 = "001" then
                soft_input_1_2_1_flip_1                                   <= soft_input_1_2_1;
                soft_input_1_2_2_flip_1                                   <= soft_input_1_2_2;
                soft_input_1_2_3_flip_1                                   <= soft_input_1_2_3;
                soft_input_1_2_4_flip_1                                   <= soft_input_1_2_4;
                soft_input_1_2_1_flip_1(to_integer(unsigned(index_3(0)))) <= not soft_input_1_2_1(to_integer(unsigned(index_3(0)))) + '1';
                weight_info_1(2)                                          <= soft_input_1_2_1(to_integer(unsigned(index_3(0))));
            elsif indi_1_1_2 = "010" then
                soft_input_1_2_1_flip_1                                   <= soft_input_1_2_1;
                soft_input_1_2_2_flip_1                                   <= soft_input_1_2_2;
                soft_input_1_2_3_flip_1                                   <= soft_input_1_2_3;
                soft_input_1_2_4_flip_1                                   <= soft_input_1_2_4;
                soft_input_1_2_2_flip_1(to_integer(unsigned(index_3(0)))) <= not soft_input_1_2_2(to_integer(unsigned(index_3(0)))) + '1';
                weight_info_1(2)                                          <= soft_input_1_2_2(to_integer(unsigned(index_3(0))));
            elsif indi_1_1_2 = "011" then
                soft_input_1_2_1_flip_1                                   <= soft_input_1_2_1;
                soft_input_1_2_2_flip_1                                   <= soft_input_1_2_2;
                soft_input_1_2_3_flip_1                                   <= soft_input_1_2_3;
                soft_input_1_2_4_flip_1                                   <= soft_input_1_2_4;
                soft_input_1_2_3_flip_1(to_integer(unsigned(index_3(0)))) <= not soft_input_1_2_3(to_integer(unsigned(index_3(0)))) + '1';
                weight_info_1(2)                                          <= soft_input_1_2_3(to_integer(unsigned(index_3(0))));
            elsif indi_1_1_2 = "100" then
                soft_input_1_2_1_flip_1                                   <= soft_input_1_2_1;
                soft_input_1_2_2_flip_1                                   <= soft_input_1_2_2;
                soft_input_1_2_3_flip_1                                   <= soft_input_1_2_3;
                soft_input_1_2_4_flip_1                                   <= soft_input_1_2_4;
                soft_input_1_2_4_flip_1(to_integer(unsigned(index_3(0)))) <= not soft_input_1_2_4(to_integer(unsigned(index_3(0)))) + '1';
                weight_info_1(2)                                          <= soft_input_1_2_4(to_integer(unsigned(index_3(0))));
            else
                soft_input_1_2_1_flip_1 <= soft_input_1_2_1;
                soft_input_1_2_2_flip_1 <= soft_input_1_2_2;
                soft_input_1_2_3_flip_1 <= soft_input_1_2_3;
                soft_input_1_2_4_flip_1 <= soft_input_1_2_4;
            end if;
            ------------------------------------------------------------------------------------------------------------------------------------
            if indi_1_1_3 = "001" then
                soft_input_1_3_1_flip_1                                   <= soft_input_1_3_1;
                soft_input_1_3_2_flip_1                                   <= soft_input_1_3_2;
                soft_input_1_3_3_flip_1                                   <= soft_input_1_3_3;
                soft_input_1_3_4_flip_1                                   <= soft_input_1_3_4;
                soft_input_1_3_1_flip_1(to_integer(unsigned(index_3(0)))) <= not soft_input_1_3_1(to_integer(unsigned(index_3(0)))) + '1';
                weight_info_1(3)                                          <= soft_input_1_3_1(to_integer(unsigned(index_3(0))));
            elsif indi_1_1_3 = "010" then
                soft_input_1_3_1_flip_1                                   <= soft_input_1_3_1;
                soft_input_1_3_2_flip_1                                   <= soft_input_1_3_2;
                soft_input_1_3_3_flip_1                                   <= soft_input_1_3_3;
                soft_input_1_3_4_flip_1                                   <= soft_input_1_3_4;
                soft_input_1_3_2_flip_1(to_integer(unsigned(index_3(0)))) <= not soft_input_1_3_2(to_integer(unsigned(index_3(0)))) + '1';
                weight_info_1(3)                                          <= soft_input_1_3_2(to_integer(unsigned(index_3(0))));
            elsif indi_1_1_3 = "011" then
                soft_input_1_3_1_flip_1                                   <= soft_input_1_3_1;
                soft_input_1_3_2_flip_1                                   <= soft_input_1_3_2;
                soft_input_1_3_3_flip_1                                   <= soft_input_1_3_3;
                soft_input_1_3_4_flip_1                                   <= soft_input_1_3_4;
                soft_input_1_3_3_flip_1(to_integer(unsigned(index_3(0)))) <= not soft_input_1_3_3(to_integer(unsigned(index_3(0)))) + '1';
                weight_info_1(3)                                          <= soft_input_1_3_3(to_integer(unsigned(index_3(0))));
            elsif indi_1_1_3 = "100" then
                soft_input_1_3_1_flip_1                                   <= soft_input_1_3_1;
                soft_input_1_3_2_flip_1                                   <= soft_input_1_3_2;
                soft_input_1_3_3_flip_1                                   <= soft_input_1_3_3;
                soft_input_1_3_4_flip_1                                   <= soft_input_1_3_4;
                soft_input_1_3_4_flip_1(to_integer(unsigned(index_3(0)))) <= not soft_input_1_3_4(to_integer(unsigned(index_3(0)))) + '1';
                weight_info_1(3)                                          <= soft_input_1_3_4(to_integer(unsigned(index_3(0))));
            else
                soft_input_1_3_1_flip_1 <= soft_input_1_3_1;
                soft_input_1_3_2_flip_1 <= soft_input_1_3_2;
                soft_input_1_3_3_flip_1 <= soft_input_1_3_3;
                soft_input_1_3_4_flip_1 <= soft_input_1_3_4;
            end if;
            ------------------------------------------------------------------------------------------------------------------------------------
            if indi_1_1_4 = "001" then
                soft_input_1_4_1_flip_1                                   <= soft_input_1_4_1;
                soft_input_1_4_2_flip_1                                   <= soft_input_1_4_2;
                soft_input_1_4_3_flip_1                                   <= soft_input_1_4_3;
                soft_input_1_4_4_flip_1                                   <= soft_input_1_4_4;
                soft_input_1_4_1_flip_1(to_integer(unsigned(index_3(0)))) <= not soft_input_1_4_1(to_integer(unsigned(index_3(0)))) + '1';
                weight_info_1(4)                                          <= soft_input_1_4_1(to_integer(unsigned(index_3(0))));
            elsif indi_1_1_4 = "010" then
                soft_input_1_4_1_flip_1                                   <= soft_input_1_4_1;
                soft_input_1_4_2_flip_1                                   <= soft_input_1_4_2;
                soft_input_1_4_3_flip_1                                   <= soft_input_1_4_3;
                soft_input_1_4_4_flip_1                                   <= soft_input_1_4_4;
                soft_input_1_4_2_flip_1(to_integer(unsigned(index_3(0)))) <= not soft_input_1_4_2(to_integer(unsigned(index_3(0)))) + '1';
                weight_info_1(4)                                          <= soft_input_1_4_2(to_integer(unsigned(index_3(0))));
            elsif indi_1_1_4 = "011" then
                soft_input_1_4_1_flip_1                                   <= soft_input_1_4_1;
                soft_input_1_4_2_flip_1                                   <= soft_input_1_4_2;
                soft_input_1_4_3_flip_1                                   <= soft_input_1_4_3;
                soft_input_1_4_4_flip_1                                   <= soft_input_1_4_4;
                soft_input_1_4_3_flip_1(to_integer(unsigned(index_3(0)))) <= not soft_input_1_4_3(to_integer(unsigned(index_3(0)))) + '1';
                weight_info_1(4)                                          <= soft_input_1_4_3(to_integer(unsigned(index_3(0))));
            elsif indi_1_1_4 = "100" then
                soft_input_1_4_1_flip_1                                   <= soft_input_1_4_1;
                soft_input_1_4_2_flip_1                                   <= soft_input_1_4_2;
                soft_input_1_4_3_flip_1                                   <= soft_input_1_4_3;
                soft_input_1_4_4_flip_1                                   <= soft_input_1_4_4;
                soft_input_1_4_4_flip_1(to_integer(unsigned(index_3(0)))) <= not soft_input_1_4_4(to_integer(unsigned(index_3(0)))) + '1';
                weight_info_1(4)                                          <= soft_input_1_4_4(to_integer(unsigned(index_3(0))));
            else
                soft_input_1_4_1_flip_1 <= soft_input_1_4_1;
                soft_input_1_4_2_flip_1 <= soft_input_1_4_2;
                soft_input_1_4_3_flip_1 <= soft_input_1_4_3;
                soft_input_1_4_4_flip_1 <= soft_input_1_4_4;
            end if;
            ------------------------------------------------------------------------------------------------------------------------------------
            if indi_1_2_1 = "001" then
                soft_input_2_1_1_flip_1                                   <= soft_input_2_1_1;
                soft_input_2_1_2_flip_1                                   <= soft_input_2_1_2;
                soft_input_2_1_3_flip_1                                   <= soft_input_2_1_3;
                soft_input_2_1_4_flip_1                                   <= soft_input_2_1_4;
                soft_input_2_1_1_flip_1(to_integer(unsigned(index_3(0)))) <= not soft_input_2_1_1(to_integer(unsigned(index_3(0)))) + '1';
                weight_info_1(5)                                          <= soft_input_2_1_1(to_integer(unsigned(index_3(0))));
            elsif indi_1_2_1 = "010" then
                soft_input_2_1_1_flip_1                                   <= soft_input_2_1_1;
                soft_input_2_1_2_flip_1                                   <= soft_input_2_1_2;
                soft_input_2_1_3_flip_1                                   <= soft_input_2_1_3;
                soft_input_2_1_4_flip_1                                   <= soft_input_2_1_4;
                soft_input_2_1_2_flip_1(to_integer(unsigned(index_3(0)))) <= not soft_input_2_1_2(to_integer(unsigned(index_3(0)))) + '1';
                weight_info_1(5)                                          <= soft_input_2_1_2(to_integer(unsigned(index_3(0))));
            elsif indi_1_2_1 = "011" then
                soft_input_2_1_1_flip_1                                   <= soft_input_2_1_1;
                soft_input_2_1_2_flip_1                                   <= soft_input_2_1_2;
                soft_input_2_1_3_flip_1                                   <= soft_input_2_1_3;
                soft_input_2_1_4_flip_1                                   <= soft_input_2_1_4;
                soft_input_2_1_3_flip_1(to_integer(unsigned(index_3(0)))) <= not soft_input_2_1_3(to_integer(unsigned(index_3(0)))) + '1';
                weight_info_1(5)                                          <= soft_input_2_1_3(to_integer(unsigned(index_3(0))));
            elsif indi_1_2_1 = "100" then
                soft_input_2_1_1_flip_1                                   <= soft_input_2_1_1;
                soft_input_2_1_2_flip_1                                   <= soft_input_2_1_2;
                soft_input_2_1_3_flip_1                                   <= soft_input_2_1_3;
                soft_input_2_1_4_flip_1                                   <= soft_input_2_1_4;
                soft_input_2_1_4_flip_1(to_integer(unsigned(index_3(0)))) <= not soft_input_2_1_4(to_integer(unsigned(index_3(0)))) + '1';
                weight_info_1(5)                                          <= soft_input_2_1_4(to_integer(unsigned(index_3(0))));
            else
                soft_input_2_1_1_flip_1 <= soft_input_2_1_1;
                soft_input_2_1_2_flip_1 <= soft_input_2_1_2;
                soft_input_2_1_3_flip_1 <= soft_input_2_1_3;
                soft_input_2_1_4_flip_1 <= soft_input_2_1_4;
            end if;
            ------------------------------------------------------------------------------------------------------------------------------------
            if indi_1_2_2 = "001" then
                soft_input_2_2_1_flip_1                                   <= soft_input_2_2_1;
                soft_input_2_2_2_flip_1                                   <= soft_input_2_2_2;
                soft_input_2_2_3_flip_1                                   <= soft_input_2_2_3;
                soft_input_2_2_4_flip_1                                   <= soft_input_2_2_4;
                soft_input_2_2_1_flip_1(to_integer(unsigned(index_3(0)))) <= not soft_input_2_2_1(to_integer(unsigned(index_3(0)))) + '1';
                weight_info_1(6)                                          <= soft_input_2_2_1(to_integer(unsigned(index_3(0))));
            elsif indi_1_2_2 = "010" then
                soft_input_2_2_1_flip_1                                   <= soft_input_2_2_1;
                soft_input_2_2_2_flip_1                                   <= soft_input_2_2_2;
                soft_input_2_2_3_flip_1                                   <= soft_input_2_2_3;
                soft_input_2_2_4_flip_1                                   <= soft_input_2_2_4;
                soft_input_2_2_2_flip_1(to_integer(unsigned(index_3(0)))) <= not soft_input_2_2_2(to_integer(unsigned(index_3(0)))) + '1';
                weight_info_1(6)                                          <= soft_input_2_2_2(to_integer(unsigned(index_3(0))));
            elsif indi_1_2_2 = "011" then
                soft_input_2_2_1_flip_1                                   <= soft_input_2_2_1;
                soft_input_2_2_2_flip_1                                   <= soft_input_2_2_2;
                soft_input_2_2_3_flip_1                                   <= soft_input_2_2_3;
                soft_input_2_2_4_flip_1                                   <= soft_input_2_2_4;
                soft_input_2_2_3_flip_1(to_integer(unsigned(index_3(0)))) <= not soft_input_2_2_3(to_integer(unsigned(index_3(0)))) + '1';
                weight_info_1(6)                                          <= soft_input_2_2_3(to_integer(unsigned(index_3(0))));
            elsif indi_1_2_2 = "100" then
                soft_input_2_2_1_flip_1                                   <= soft_input_2_2_1;
                soft_input_2_2_2_flip_1                                   <= soft_input_2_2_2;
                soft_input_2_2_3_flip_1                                   <= soft_input_2_2_3;
                soft_input_2_2_4_flip_1                                   <= soft_input_2_2_4;
                soft_input_2_2_4_flip_1(to_integer(unsigned(index_3(0)))) <= not soft_input_2_2_4(to_integer(unsigned(index_3(0)))) + '1';
                weight_info_1(6)                                          <= soft_input_2_2_4(to_integer(unsigned(index_3(0))));
            else
                soft_input_2_2_1_flip_1 <= soft_input_2_2_1;
                soft_input_2_2_2_flip_1 <= soft_input_2_2_2;
                soft_input_2_2_3_flip_1 <= soft_input_2_2_3;
                soft_input_2_2_4_flip_1 <= soft_input_2_2_4;
            end if;
            ------------------------------------------------------------------------------------------------------------------------------------
            if indi_1_2_3 = "001" then
                soft_input_2_3_1_flip_1                                   <= soft_input_2_3_1;
                soft_input_2_3_2_flip_1                                   <= soft_input_2_3_2;
                soft_input_2_3_3_flip_1                                   <= soft_input_2_3_3;
                soft_input_2_3_4_flip_1                                   <= soft_input_2_3_4;
                soft_input_2_3_1_flip_1(to_integer(unsigned(index_3(0)))) <= not soft_input_2_3_1(to_integer(unsigned(index_3(0)))) + '1';
                weight_info_1(7)                                          <= soft_input_2_3_1(to_integer(unsigned(index_3(0))));
            elsif indi_1_2_3 = "010" then
                soft_input_2_3_1_flip_1                                   <= soft_input_2_3_1;
                soft_input_2_3_2_flip_1                                   <= soft_input_2_3_2;
                soft_input_2_3_3_flip_1                                   <= soft_input_2_3_3;
                soft_input_2_3_4_flip_1                                   <= soft_input_2_3_4;
                soft_input_2_3_2_flip_1(to_integer(unsigned(index_3(0)))) <= not soft_input_2_3_2(to_integer(unsigned(index_3(0)))) + '1';
                weight_info_1(7)                                          <= soft_input_2_3_2(to_integer(unsigned(index_3(0))));
            elsif indi_1_2_3 = "011" then
                soft_input_2_3_1_flip_1                                   <= soft_input_2_3_1;
                soft_input_2_3_2_flip_1                                   <= soft_input_2_3_2;
                soft_input_2_3_3_flip_1                                   <= soft_input_2_3_3;
                soft_input_2_3_4_flip_1                                   <= soft_input_2_3_4;
                soft_input_2_3_3_flip_1(to_integer(unsigned(index_3(0)))) <= not soft_input_2_3_3(to_integer(unsigned(index_3(0)))) + '1';
                weight_info_1(7)                                          <= soft_input_2_3_3(to_integer(unsigned(index_3(0))));
            elsif indi_1_2_3 = "100" then
                soft_input_2_3_1_flip_1                                   <= soft_input_2_3_1;
                soft_input_2_3_2_flip_1                                   <= soft_input_2_3_2;
                soft_input_2_3_3_flip_1                                   <= soft_input_2_3_3;
                soft_input_2_3_4_flip_1                                   <= soft_input_2_3_4;
                soft_input_2_3_4_flip_1(to_integer(unsigned(index_3(0)))) <= not soft_input_2_3_4(to_integer(unsigned(index_3(0)))) + '1';
                weight_info_1(7)                                          <= soft_input_2_3_4(to_integer(unsigned(index_3(0))));
            else
                soft_input_2_3_1_flip_1 <= soft_input_2_3_1;
                soft_input_2_3_2_flip_1 <= soft_input_2_3_2;
                soft_input_2_3_3_flip_1 <= soft_input_2_3_3;
                soft_input_2_3_4_flip_1 <= soft_input_2_3_4;
            end if;
            ------------------------------------------------------------------------------------------------------------------------------------
            if indi_1_2_4 = "001" then
                soft_input_2_4_1_flip_1                                   <= soft_input_2_4_1;
                soft_input_2_4_2_flip_1                                   <= soft_input_2_4_2;
                soft_input_2_4_3_flip_1                                   <= soft_input_2_4_3;
                soft_input_2_4_4_flip_1                                   <= soft_input_2_4_4;
                soft_input_2_4_1_flip_1(to_integer(unsigned(index_3(0)))) <= not soft_input_2_4_1(to_integer(unsigned(index_3(0)))) + '1';
                weight_info_1(8)                                          <= soft_input_2_4_1(to_integer(unsigned(index_3(0))));
            elsif indi_1_2_4 = "010" then
                soft_input_2_4_1_flip_1                                   <= soft_input_2_4_1;
                soft_input_2_4_2_flip_1                                   <= soft_input_2_4_2;
                soft_input_2_4_3_flip_1                                   <= soft_input_2_4_3;
                soft_input_2_4_4_flip_1                                   <= soft_input_2_4_4;
                soft_input_2_4_2_flip_1(to_integer(unsigned(index_3(0)))) <= not soft_input_2_4_2(to_integer(unsigned(index_3(0)))) + '1';
                weight_info_1(8)                                          <= soft_input_2_4_2(to_integer(unsigned(index_3(0))));
            elsif indi_1_2_4 = "011" then
                soft_input_2_4_1_flip_1                                   <= soft_input_2_4_1;
                soft_input_2_4_2_flip_1                                   <= soft_input_2_4_2;
                soft_input_2_4_3_flip_1                                   <= soft_input_2_4_3;
                soft_input_2_4_4_flip_1                                   <= soft_input_2_4_4;
                soft_input_2_4_3_flip_1(to_integer(unsigned(index_3(0)))) <= not soft_input_2_4_3(to_integer(unsigned(index_3(0)))) + '1';
                weight_info_1(8)                                          <= soft_input_2_4_3(to_integer(unsigned(index_3(0))));
            elsif indi_1_2_4 = "100" then
                soft_input_2_4_1_flip_1                                   <= soft_input_2_4_1;
                soft_input_2_4_2_flip_1                                   <= soft_input_2_4_2;
                soft_input_2_4_3_flip_1                                   <= soft_input_2_4_3;
                soft_input_2_4_4_flip_1                                   <= soft_input_2_4_4;
                soft_input_2_4_4_flip_1(to_integer(unsigned(index_3(0)))) <= not soft_input_2_4_4(to_integer(unsigned(index_3(0)))) + '1';
                weight_info_1(8)                                          <= soft_input_2_4_4(to_integer(unsigned(index_3(0))));
            else
                soft_input_2_4_1_flip_1 <= soft_input_2_4_1;
                soft_input_2_4_2_flip_1 <= soft_input_2_4_2;
                soft_input_2_4_3_flip_1 <= soft_input_2_4_3;
                soft_input_2_4_4_flip_1 <= soft_input_2_4_4;
            end if;
            ------------------------------------------------------------------------------------------------------------------------------------
            if indi_1_3_1 = "001" then
                soft_input_3_1_1_flip_1                                   <= soft_input_3_1_1;
                soft_input_3_1_2_flip_1                                   <= soft_input_3_1_2;
                soft_input_3_1_3_flip_1                                   <= soft_input_3_1_3;
                soft_input_3_1_4_flip_1                                   <= soft_input_3_1_4;
                soft_input_3_1_1_flip_1(to_integer(unsigned(index_3(0)))) <= not soft_input_3_1_1(to_integer(unsigned(index_3(0)))) + '1';
                weight_info_1(9)                                          <= soft_input_3_1_1(to_integer(unsigned(index_3(0))));
            elsif indi_1_3_1 = "010" then
                soft_input_3_1_1_flip_1                                   <= soft_input_3_1_1;
                soft_input_3_1_2_flip_1                                   <= soft_input_3_1_2;
                soft_input_3_1_3_flip_1                                   <= soft_input_3_1_3;
                soft_input_3_1_4_flip_1                                   <= soft_input_3_1_4;
                soft_input_3_1_2_flip_1(to_integer(unsigned(index_3(0)))) <= not soft_input_3_1_2(to_integer(unsigned(index_3(0)))) + '1';
                weight_info_1(9)                                          <= soft_input_3_1_2(to_integer(unsigned(index_3(0))));
            elsif indi_1_3_1 = "011" then
                soft_input_3_1_1_flip_1                                   <= soft_input_3_1_1;
                soft_input_3_1_2_flip_1                                   <= soft_input_3_1_2;
                soft_input_3_1_3_flip_1                                   <= soft_input_3_1_3;
                soft_input_3_1_4_flip_1                                   <= soft_input_3_1_4;
                soft_input_3_1_3_flip_1(to_integer(unsigned(index_3(0)))) <= not soft_input_3_1_3(to_integer(unsigned(index_3(0)))) + '1';
                weight_info_1(9)                                          <= soft_input_3_1_3(to_integer(unsigned(index_3(0))));
            elsif indi_1_3_1 = "100" then
                soft_input_3_1_1_flip_1                                   <= soft_input_3_1_1;
                soft_input_3_1_2_flip_1                                   <= soft_input_3_1_2;
                soft_input_3_1_3_flip_1                                   <= soft_input_3_1_3;
                soft_input_3_1_4_flip_1                                   <= soft_input_3_1_4;
                soft_input_3_1_4_flip_1(to_integer(unsigned(index_3(0)))) <= not soft_input_3_1_4(to_integer(unsigned(index_3(0)))) + '1';
                weight_info_1(9)                                          <= soft_input_3_1_4(to_integer(unsigned(index_3(0))));
            else
                soft_input_3_1_1_flip_1 <= soft_input_3_1_1;
                soft_input_3_1_2_flip_1 <= soft_input_3_1_2;
                soft_input_3_1_3_flip_1 <= soft_input_3_1_3;
                soft_input_3_1_4_flip_1 <= soft_input_3_1_4;
            end if;
            ------------------------------------------------------------------------------------------------------------------------------------
            if indi_1_3_2 = "001" then
                soft_input_3_2_1_flip_1                                   <= soft_input_3_2_1;
                soft_input_3_2_2_flip_1                                   <= soft_input_3_2_2;
                soft_input_3_2_3_flip_1                                   <= soft_input_3_2_3;
                soft_input_3_2_4_flip_1                                   <= soft_input_3_2_4;
                soft_input_3_2_1_flip_1(to_integer(unsigned(index_3(0)))) <= not soft_input_3_2_1(to_integer(unsigned(index_3(0)))) + '1';
                weight_info_1(10)                                         <= soft_input_3_2_1(to_integer(unsigned(index_3(0))));
            elsif indi_1_3_2 = "010" then
                soft_input_3_2_1_flip_1                                   <= soft_input_3_2_1;
                soft_input_3_2_2_flip_1                                   <= soft_input_3_2_2;
                soft_input_3_2_3_flip_1                                   <= soft_input_3_2_3;
                soft_input_3_2_4_flip_1                                   <= soft_input_3_2_4;
                soft_input_3_2_2_flip_1(to_integer(unsigned(index_3(0)))) <= not soft_input_3_2_2(to_integer(unsigned(index_3(0)))) + '1';
                weight_info_1(10)                                         <= soft_input_3_2_2(to_integer(unsigned(index_3(0))));
            elsif indi_1_3_2 = "011" then
                soft_input_3_2_1_flip_1                                   <= soft_input_3_2_1;
                soft_input_3_2_2_flip_1                                   <= soft_input_3_2_2;
                soft_input_3_2_3_flip_1                                   <= soft_input_3_2_3;
                soft_input_3_2_4_flip_1                                   <= soft_input_3_2_4;
                soft_input_3_2_3_flip_1(to_integer(unsigned(index_3(0)))) <= not soft_input_3_2_3(to_integer(unsigned(index_3(0)))) + '1';
                weight_info_1(10)                                         <= soft_input_3_2_3(to_integer(unsigned(index_3(0))));
            elsif indi_1_3_2 = "100" then
                soft_input_3_2_1_flip_1                                   <= soft_input_3_2_1;
                soft_input_3_2_2_flip_1                                   <= soft_input_3_2_2;
                soft_input_3_2_3_flip_1                                   <= soft_input_3_2_3;
                soft_input_3_2_4_flip_1                                   <= soft_input_3_2_4;
                soft_input_3_2_4_flip_1(to_integer(unsigned(index_3(0)))) <= not soft_input_3_2_4(to_integer(unsigned(index_3(0)))) + '1';
                weight_info_1(10)                                         <= soft_input_3_2_4(to_integer(unsigned(index_3(0))));
            else
                soft_input_3_2_1_flip_1 <= soft_input_3_2_1;
                soft_input_3_2_2_flip_1 <= soft_input_3_2_2;
                soft_input_3_2_3_flip_1 <= soft_input_3_2_3;
                soft_input_3_2_4_flip_1 <= soft_input_3_2_4;
            end if;
            ------------------------------------------------------------------------------------------------------------------------------------
            if indi_1_3_3 = "001" then
                soft_input_3_3_1_flip_1                                   <= soft_input_3_3_1;
                soft_input_3_3_2_flip_1                                   <= soft_input_3_3_2;
                soft_input_3_3_3_flip_1                                   <= soft_input_3_3_3;
                soft_input_3_3_4_flip_1                                   <= soft_input_3_3_4;
                soft_input_3_3_1_flip_1(to_integer(unsigned(index_3(0)))) <= not soft_input_3_3_1(to_integer(unsigned(index_3(0)))) + '1';
                weight_info_1(11)                                         <= soft_input_3_3_1(to_integer(unsigned(index_3(0))));
            elsif indi_1_3_3 = "010" then
                soft_input_3_3_1_flip_1                                   <= soft_input_3_3_1;
                soft_input_3_3_2_flip_1                                   <= soft_input_3_3_2;
                soft_input_3_3_3_flip_1                                   <= soft_input_3_3_3;
                soft_input_3_3_4_flip_1                                   <= soft_input_3_3_4;
                soft_input_3_3_2_flip_1(to_integer(unsigned(index_3(0)))) <= not soft_input_3_3_2(to_integer(unsigned(index_3(0)))) + '1';
                weight_info_1(11)                                         <= soft_input_3_3_2(to_integer(unsigned(index_3(0))));
            elsif indi_1_3_3 = "011" then
                soft_input_3_3_1_flip_1                                   <= soft_input_3_3_1;
                soft_input_3_3_2_flip_1                                   <= soft_input_3_3_2;
                soft_input_3_3_3_flip_1                                   <= soft_input_3_3_3;
                soft_input_3_3_4_flip_1                                   <= soft_input_3_3_4;
                soft_input_3_3_3_flip_1(to_integer(unsigned(index_3(0)))) <= not soft_input_3_3_3(to_integer(unsigned(index_3(0)))) + '1';
                weight_info_1(11)                                         <= soft_input_3_3_3(to_integer(unsigned(index_3(0))));
            elsif indi_1_3_3 = "100" then
                soft_input_3_3_1_flip_1                                   <= soft_input_3_3_1;
                soft_input_3_3_2_flip_1                                   <= soft_input_3_3_2;
                soft_input_3_3_3_flip_1                                   <= soft_input_3_3_3;
                soft_input_3_3_4_flip_1                                   <= soft_input_3_3_4;
                soft_input_3_3_4_flip_1(to_integer(unsigned(index_3(0)))) <= not soft_input_3_3_4(to_integer(unsigned(index_3(0)))) + '1';
                weight_info_1(11)                                         <= soft_input_3_3_4(to_integer(unsigned(index_3(0))));
            else
                soft_input_3_3_1_flip_1 <= soft_input_3_3_1;
                soft_input_3_3_2_flip_1 <= soft_input_3_3_2;
                soft_input_3_3_3_flip_1 <= soft_input_3_3_3;
                soft_input_3_3_4_flip_1 <= soft_input_3_3_4;
            end if;
            ------------------------------------------------------------------------------------------------------------------------------------
            if indi_1_3_4 = "001" then
                soft_input_3_4_1_flip_1                                   <= soft_input_3_4_1;
                soft_input_3_4_2_flip_1                                   <= soft_input_3_4_2;
                soft_input_3_4_3_flip_1                                   <= soft_input_3_4_3;
                soft_input_3_4_4_flip_1                                   <= soft_input_3_4_4;
                soft_input_3_4_1_flip_1(to_integer(unsigned(index_3(0)))) <= not soft_input_3_4_1(to_integer(unsigned(index_3(0)))) + '1';
                weight_info_1(12)                                         <= soft_input_3_4_1(to_integer(unsigned(index_3(0))));
            elsif indi_1_3_4 = "010" then
                soft_input_3_4_1_flip_1                                   <= soft_input_3_4_1;
                soft_input_3_4_2_flip_1                                   <= soft_input_3_4_2;
                soft_input_3_4_3_flip_1                                   <= soft_input_3_4_3;
                soft_input_3_4_4_flip_1                                   <= soft_input_3_4_4;
                soft_input_3_4_2_flip_1(to_integer(unsigned(index_3(0)))) <= not soft_input_3_4_2(to_integer(unsigned(index_3(0)))) + '1';
                weight_info_1(12)                                         <= soft_input_3_4_2(to_integer(unsigned(index_3(0))));
            elsif indi_1_3_4 = "011" then
                soft_input_3_4_1_flip_1                                   <= soft_input_3_4_1;
                soft_input_3_4_2_flip_1                                   <= soft_input_3_4_2;
                soft_input_3_4_3_flip_1                                   <= soft_input_3_4_3;
                soft_input_3_4_4_flip_1                                   <= soft_input_3_4_4;
                soft_input_3_4_3_flip_1(to_integer(unsigned(index_3(0)))) <= not soft_input_3_4_3(to_integer(unsigned(index_3(0)))) + '1';
                weight_info_1(12)                                         <= soft_input_3_4_3(to_integer(unsigned(index_3(0))));
            elsif indi_1_3_4 = "100" then
                soft_input_3_4_1_flip_1                                   <= soft_input_3_4_1;
                soft_input_3_4_2_flip_1                                   <= soft_input_3_4_2;
                soft_input_3_4_3_flip_1                                   <= soft_input_3_4_3;
                soft_input_3_4_4_flip_1                                   <= soft_input_3_4_4;
                soft_input_3_4_4_flip_1(to_integer(unsigned(index_3(0)))) <= not soft_input_3_4_4(to_integer(unsigned(index_3(0)))) + '1';
                weight_info_1(12)                                         <= soft_input_3_4_4(to_integer(unsigned(index_3(0))));
            else
                soft_input_3_4_1_flip_1 <= soft_input_3_4_1;
                soft_input_3_4_2_flip_1 <= soft_input_3_4_2;
                soft_input_3_4_3_flip_1 <= soft_input_3_4_3;
                soft_input_3_4_4_flip_1 <= soft_input_3_4_4;
            end if;
            ------------------------------------------------------------------------------------------------------------------------------------
            if indi_1_4_1 = "001" then
                soft_input_4_1_1_flip_1                                   <= soft_input_4_1_1;
                soft_input_4_1_2_flip_1                                   <= soft_input_4_1_2;
                soft_input_4_1_3_flip_1                                   <= soft_input_4_1_3;
                soft_input_4_1_4_flip_1                                   <= soft_input_4_1_4;
                soft_input_4_1_1_flip_1(to_integer(unsigned(index_3(0)))) <= not soft_input_4_1_1(to_integer(unsigned(index_3(0)))) + '1';
                weight_info_1(13)                                         <= soft_input_4_1_1(to_integer(unsigned(index_3(0))));
            elsif indi_1_4_1 = "010" then
                soft_input_4_1_1_flip_1                                   <= soft_input_4_1_1;
                soft_input_4_1_2_flip_1                                   <= soft_input_4_1_2;
                soft_input_4_1_3_flip_1                                   <= soft_input_4_1_3;
                soft_input_4_1_4_flip_1                                   <= soft_input_4_1_4;
                soft_input_4_1_2_flip_1(to_integer(unsigned(index_3(0)))) <= not soft_input_4_1_2(to_integer(unsigned(index_3(0)))) + '1';
                weight_info_1(13)                                         <= soft_input_4_1_2(to_integer(unsigned(index_3(0))));
            elsif indi_1_4_1 = "011" then
                soft_input_4_1_1_flip_1                                   <= soft_input_4_1_1;
                soft_input_4_1_2_flip_1                                   <= soft_input_4_1_2;
                soft_input_4_1_3_flip_1                                   <= soft_input_4_1_3;
                soft_input_4_1_4_flip_1                                   <= soft_input_4_1_4;
                soft_input_4_1_3_flip_1(to_integer(unsigned(index_3(0)))) <= not soft_input_4_1_3(to_integer(unsigned(index_3(0)))) + '1';
                weight_info_1(13)                                         <= soft_input_4_1_3(to_integer(unsigned(index_3(0))));
            elsif indi_1_4_1 = "100" then
                soft_input_4_1_1_flip_1                                   <= soft_input_4_1_1;
                soft_input_4_1_2_flip_1                                   <= soft_input_4_1_2;
                soft_input_4_1_3_flip_1                                   <= soft_input_4_1_3;
                soft_input_4_1_4_flip_1                                   <= soft_input_4_1_4;
                soft_input_4_1_4_flip_1(to_integer(unsigned(index_3(0)))) <= not soft_input_4_1_4(to_integer(unsigned(index_3(0)))) + '1';
                weight_info_1(13)                                         <= soft_input_4_1_4(to_integer(unsigned(index_3(0))));
            else
                soft_input_4_1_1_flip_1 <= soft_input_4_1_1;
                soft_input_4_1_2_flip_1 <= soft_input_4_1_2;
                soft_input_4_1_3_flip_1 <= soft_input_4_1_3;
                soft_input_4_1_4_flip_1 <= soft_input_4_1_4;
            end if;
            ------------------------------------------------------------------------------------------------------------------------------------
            if indi_1_4_2 = "001" then
                soft_input_4_2_1_flip_1                                   <= soft_input_4_2_1;
                soft_input_4_2_2_flip_1                                   <= soft_input_4_2_2;
                soft_input_4_2_3_flip_1                                   <= soft_input_4_2_3;
                soft_input_4_2_4_flip_1                                   <= soft_input_4_2_4;
                soft_input_4_2_1_flip_1(to_integer(unsigned(index_3(0)))) <= not soft_input_4_2_1(to_integer(unsigned(index_3(0)))) + '1';
                weight_info_1(14)                                         <= soft_input_4_2_1(to_integer(unsigned(index_3(0))));
            elsif indi_1_4_2 = "010" then
                soft_input_4_2_1_flip_1                                   <= soft_input_4_2_1;
                soft_input_4_2_2_flip_1                                   <= soft_input_4_2_2;
                soft_input_4_2_3_flip_1                                   <= soft_input_4_2_3;
                soft_input_4_2_4_flip_1                                   <= soft_input_4_2_4;
                soft_input_4_2_2_flip_1(to_integer(unsigned(index_3(0)))) <= not soft_input_4_2_2(to_integer(unsigned(index_3(0)))) + '1';
                weight_info_1(14)                                         <= soft_input_4_2_2(to_integer(unsigned(index_3(0))));
            elsif indi_1_4_2 = "011" then
                soft_input_4_2_1_flip_1                                   <= soft_input_4_2_1;
                soft_input_4_2_2_flip_1                                   <= soft_input_4_2_2;
                soft_input_4_2_3_flip_1                                   <= soft_input_4_2_3;
                soft_input_4_2_4_flip_1                                   <= soft_input_4_2_4;
                soft_input_4_2_3_flip_1(to_integer(unsigned(index_3(0)))) <= not soft_input_4_2_3(to_integer(unsigned(index_3(0)))) + '1';
                weight_info_1(14)                                         <= soft_input_4_2_3(to_integer(unsigned(index_3(0))));
            elsif indi_1_4_2 = "100" then
                soft_input_4_2_1_flip_1                                   <= soft_input_4_2_1;
                soft_input_4_2_2_flip_1                                   <= soft_input_4_2_2;
                soft_input_4_2_3_flip_1                                   <= soft_input_4_2_3;
                soft_input_4_2_4_flip_1                                   <= soft_input_4_2_4;
                soft_input_4_2_4_flip_1(to_integer(unsigned(index_3(0)))) <= not soft_input_4_2_4(to_integer(unsigned(index_3(0)))) + '1';
                weight_info_1(14)                                         <= soft_input_4_2_4(to_integer(unsigned(index_3(0))));
            else
                soft_input_4_2_1_flip_1 <= soft_input_4_2_1;
                soft_input_4_2_2_flip_1 <= soft_input_4_2_2;
                soft_input_4_2_3_flip_1 <= soft_input_4_2_3;
                soft_input_4_2_4_flip_1 <= soft_input_4_2_4;
            end if;
            ------------------------------------------------------------------------------------------------------------------------------------
            if indi_1_4_3 = "001" then
                soft_input_4_3_1_flip_1                                   <= soft_input_4_3_1;
                soft_input_4_3_2_flip_1                                   <= soft_input_4_3_2;
                soft_input_4_3_3_flip_1                                   <= soft_input_4_3_3;
                soft_input_4_3_4_flip_1                                   <= soft_input_4_3_4;
                soft_input_4_3_1_flip_1(to_integer(unsigned(index_3(0)))) <= not soft_input_4_3_1(to_integer(unsigned(index_3(0)))) + '1';
                weight_info_1(15)                                         <= soft_input_4_3_1(to_integer(unsigned(index_3(0))));
            elsif indi_1_4_3 = "010" then
                soft_input_4_3_1_flip_1                                   <= soft_input_4_3_1;
                soft_input_4_3_2_flip_1                                   <= soft_input_4_3_2;
                soft_input_4_3_3_flip_1                                   <= soft_input_4_3_3;
                soft_input_4_3_4_flip_1                                   <= soft_input_4_3_4;
                soft_input_4_3_2_flip_1(to_integer(unsigned(index_3(0)))) <= not soft_input_4_3_2(to_integer(unsigned(index_3(0)))) + '1';
                weight_info_1(15)                                         <= soft_input_4_3_2(to_integer(unsigned(index_3(0))));
            elsif indi_1_4_3 = "011" then
                soft_input_4_3_1_flip_1                                   <= soft_input_4_3_1;
                soft_input_4_3_2_flip_1                                   <= soft_input_4_3_2;
                soft_input_4_3_3_flip_1                                   <= soft_input_4_3_3;
                soft_input_4_3_4_flip_1                                   <= soft_input_4_3_4;
                soft_input_4_3_3_flip_1(to_integer(unsigned(index_3(0)))) <= not soft_input_4_3_3(to_integer(unsigned(index_3(0)))) + '1';
                weight_info_1(15)                                         <= soft_input_4_3_3(to_integer(unsigned(index_3(0))));
            elsif indi_1_4_3 = "100" then
                soft_input_4_3_1_flip_1                                   <= soft_input_4_3_1;
                soft_input_4_3_2_flip_1                                   <= soft_input_4_3_2;
                soft_input_4_3_3_flip_1                                   <= soft_input_4_3_3;
                soft_input_4_3_4_flip_1                                   <= soft_input_4_3_4;
                soft_input_4_3_4_flip_1(to_integer(unsigned(index_3(0)))) <= not soft_input_4_3_4(to_integer(unsigned(index_3(0)))) + '1';
                weight_info_1(15)                                         <= soft_input_4_3_4(to_integer(unsigned(index_3(0))));
            else
                soft_input_4_3_1_flip_1 <= soft_input_4_3_1;
                soft_input_4_3_2_flip_1 <= soft_input_4_3_2;
                soft_input_4_3_3_flip_1 <= soft_input_4_3_3;
                soft_input_4_3_4_flip_1 <= soft_input_4_3_4;
            end if;
            ------------------------------------------------------------------------------------------------------------------------------------
            if indi_1_4_4 = "001" then
                soft_input_4_4_1_flip_1                                   <= soft_input_4_4_1;
                soft_input_4_4_2_flip_1                                   <= soft_input_4_4_2;
                soft_input_4_4_3_flip_1                                   <= soft_input_4_4_3;
                soft_input_4_4_4_flip_1                                   <= soft_input_4_4_4;
                soft_input_4_4_1_flip_1(to_integer(unsigned(index_3(0)))) <= not soft_input_4_4_1(to_integer(unsigned(index_3(0)))) + '1';
                weight_info_1(16)                                         <= soft_input_4_4_1(to_integer(unsigned(index_3(0))));
            elsif indi_1_4_4 = "010" then
                soft_input_4_4_1_flip_1                                   <= soft_input_4_4_1;
                soft_input_4_4_2_flip_1                                   <= soft_input_4_4_2;
                soft_input_4_4_3_flip_1                                   <= soft_input_4_4_3;
                soft_input_4_4_4_flip_1                                   <= soft_input_4_4_4;
                soft_input_4_4_2_flip_1(to_integer(unsigned(index_3(0)))) <= not soft_input_4_4_2(to_integer(unsigned(index_3(0)))) + '1';
                weight_info_1(16)                                         <= soft_input_4_4_2(to_integer(unsigned(index_3(0))));
            elsif indi_1_4_4 = "011" then
                soft_input_4_4_1_flip_1                                   <= soft_input_4_4_1;
                soft_input_4_4_2_flip_1                                   <= soft_input_4_4_2;
                soft_input_4_4_3_flip_1                                   <= soft_input_4_4_3;
                soft_input_4_4_4_flip_1                                   <= soft_input_4_4_4;
                soft_input_4_4_3_flip_1(to_integer(unsigned(index_3(0)))) <= not soft_input_4_4_3(to_integer(unsigned(index_3(0)))) + '1';
                weight_info_1(16)                                         <= soft_input_4_4_3(to_integer(unsigned(index_3(0))));
            elsif indi_1_4_4 = "100" then
                soft_input_4_4_1_flip_1                                   <= soft_input_4_4_1;
                soft_input_4_4_2_flip_1                                   <= soft_input_4_4_2;
                soft_input_4_4_3_flip_1                                   <= soft_input_4_4_3;
                soft_input_4_4_4_flip_1                                   <= soft_input_4_4_4;
                soft_input_4_4_4_flip_1(to_integer(unsigned(index_3(0)))) <= not soft_input_4_4_4(to_integer(unsigned(index_3(0)))) + '1';
                weight_info_1(16)                                         <= soft_input_4_4_4(to_integer(unsigned(index_3(0))));
            else
                soft_input_4_4_1_flip_1 <= soft_input_4_4_1;
                soft_input_4_4_2_flip_1 <= soft_input_4_4_2;
                soft_input_4_4_3_flip_1 <= soft_input_4_4_3;
                soft_input_4_4_4_flip_1 <= soft_input_4_4_4;
            end if;
        end if;
    end process;
    ------------------------------------------------------------------------------------------------------------
    -- Define processes : (CLK 5)
    ------------------------------------------------------------------------------------------------------------
    process (clk, reset)
    begin
        if (reset = '1') then
            soft_output_unflipped_5 <= (others => (others => '0'));
            weight_info_2           <= (others => (others => '0'));
            soft_input_1_1_1_flip_2 <= (others => (others => '0'));
            soft_input_1_1_2_flip_2 <= (others => (others => '0'));
            soft_input_1_1_3_flip_2 <= (others => (others => '0'));
            soft_input_1_1_4_flip_2 <= (others => (others => '0'));
            soft_input_1_2_1_flip_2 <= (others => (others => '0'));
            soft_input_1_2_2_flip_2 <= (others => (others => '0'));
            soft_input_1_2_3_flip_2 <= (others => (others => '0'));
            soft_input_1_2_4_flip_2 <= (others => (others => '0'));
            soft_input_1_3_1_flip_2 <= (others => (others => '0'));
            soft_input_1_3_2_flip_2 <= (others => (others => '0'));
            soft_input_1_3_3_flip_2 <= (others => (others => '0'));
            soft_input_1_3_4_flip_2 <= (others => (others => '0'));
            soft_input_1_4_1_flip_2 <= (others => (others => '0'));
            soft_input_1_4_2_flip_2 <= (others => (others => '0'));
            soft_input_1_4_3_flip_2 <= (others => (others => '0'));
            soft_input_1_4_4_flip_2 <= (others => (others => '0'));
            soft_input_2_1_1_flip_2 <= (others => (others => '0'));
            soft_input_2_1_2_flip_2 <= (others => (others => '0'));
            soft_input_2_1_3_flip_2 <= (others => (others => '0'));
            soft_input_2_1_4_flip_2 <= (others => (others => '0'));
            soft_input_2_2_1_flip_2 <= (others => (others => '0'));
            soft_input_2_2_2_flip_2 <= (others => (others => '0'));
            soft_input_2_2_3_flip_2 <= (others => (others => '0'));
            soft_input_2_2_4_flip_2 <= (others => (others => '0'));
            soft_input_2_3_1_flip_2 <= (others => (others => '0'));
            soft_input_2_3_2_flip_2 <= (others => (others => '0'));
            soft_input_2_3_3_flip_2 <= (others => (others => '0'));
            soft_input_2_3_4_flip_2 <= (others => (others => '0'));
            soft_input_2_4_1_flip_2 <= (others => (others => '0'));
            soft_input_2_4_2_flip_2 <= (others => (others => '0'));
            soft_input_2_4_3_flip_2 <= (others => (others => '0'));
            soft_input_2_4_4_flip_2 <= (others => (others => '0'));
            soft_input_3_1_1_flip_2 <= (others => (others => '0'));
            soft_input_3_1_2_flip_2 <= (others => (others => '0'));
            soft_input_3_1_3_flip_2 <= (others => (others => '0'));
            soft_input_3_1_4_flip_2 <= (others => (others => '0'));
            soft_input_3_2_1_flip_2 <= (others => (others => '0'));
            soft_input_3_2_2_flip_2 <= (others => (others => '0'));
            soft_input_3_2_3_flip_2 <= (others => (others => '0'));
            soft_input_3_2_4_flip_2 <= (others => (others => '0'));
            soft_input_3_3_1_flip_2 <= (others => (others => '0'));
            soft_input_3_3_2_flip_2 <= (others => (others => '0'));
            soft_input_3_3_3_flip_2 <= (others => (others => '0'));
            soft_input_3_3_4_flip_2 <= (others => (others => '0'));
            soft_input_3_4_1_flip_2 <= (others => (others => '0'));
            soft_input_3_4_2_flip_2 <= (others => (others => '0'));
            soft_input_3_4_3_flip_2 <= (others => (others => '0'));
            soft_input_3_4_4_flip_2 <= (others => (others => '0'));
            soft_input_4_1_1_flip_2 <= (others => (others => '0'));
            soft_input_4_1_2_flip_2 <= (others => (others => '0'));
            soft_input_4_1_3_flip_2 <= (others => (others => '0'));
            soft_input_4_1_4_flip_2 <= (others => (others => '0'));
            soft_input_4_2_1_flip_2 <= (others => (others => '0'));
            soft_input_4_2_2_flip_2 <= (others => (others => '0'));
            soft_input_4_2_3_flip_2 <= (others => (others => '0'));
            soft_input_4_2_4_flip_2 <= (others => (others => '0'));
            soft_input_4_3_1_flip_2 <= (others => (others => '0'));
            soft_input_4_3_2_flip_2 <= (others => (others => '0'));
            soft_input_4_3_3_flip_2 <= (others => (others => '0'));
            soft_input_4_3_4_flip_2 <= (others => (others => '0'));
            soft_input_4_4_1_flip_2 <= (others => (others => '0'));
            soft_input_4_4_2_flip_2 <= (others => (others => '0'));
            soft_input_4_4_3_flip_2 <= (others => (others => '0'));
            soft_input_4_4_4_flip_2 <= (others => (others => '0'));
            weight_info_1_temp_p1   <= (others => '0');
            weight_info_1_temp_p2   <= (others => '0');
            weight_info_1_temp_p3   <= (others => '0');
            weight_info_1_temp_p4   <= (others => '0');
            indi_3_1_1_pass_2       <= (others => '0');
            indi_3_1_2_pass_2       <= (others => '0');
            indi_3_1_3_pass_2       <= (others => '0');
            indi_3_1_4_pass_2       <= (others => '0');
            indi_3_2_1_pass_2       <= (others => '0');
            indi_3_2_2_pass_2       <= (others => '0');
            indi_3_2_3_pass_2       <= (others => '0');
            indi_3_2_4_pass_2       <= (others => '0');
            indi_3_3_1_pass_2       <= (others => '0');
            indi_3_3_2_pass_2       <= (others => '0');
            indi_3_3_3_pass_2       <= (others => '0');
            indi_3_3_4_pass_2       <= (others => '0');
            indi_3_4_1_pass_2       <= (others => '0');
            indi_3_4_2_pass_2       <= (others => '0');
            indi_3_4_3_pass_2       <= (others => '0');
            indi_3_4_4_pass_2       <= (others => '0');
            index_5                 <= (others => (others => '0'));
            index_5_original        <= (others => (others => '0'));
        elsif (rising_edge(clk)) then
            weight_info_2           <= (others => (others => '0'));
            soft_output_unflipped_5 <= soft_output_unflipped_4;
            indi_3_1_1_pass_2       <= indi_3_1_1_pass_1;
            indi_3_1_2_pass_2       <= indi_3_1_2_pass_1;
            indi_3_1_3_pass_2       <= indi_3_1_3_pass_1;
            indi_3_1_4_pass_2       <= indi_3_1_4_pass_1;
            indi_3_2_1_pass_2       <= indi_3_2_1_pass_1;
            indi_3_2_2_pass_2       <= indi_3_2_2_pass_1;
            indi_3_2_3_pass_2       <= indi_3_2_3_pass_1;
            indi_3_2_4_pass_2       <= indi_3_2_4_pass_1;
            indi_3_3_1_pass_2       <= indi_3_3_1_pass_1;
            indi_3_3_2_pass_2       <= indi_3_3_2_pass_1;
            indi_3_3_3_pass_2       <= indi_3_3_3_pass_1;
            indi_3_3_4_pass_2       <= indi_3_3_4_pass_1;
            indi_3_4_1_pass_2       <= indi_3_4_1_pass_1;
            indi_3_4_2_pass_2       <= indi_3_4_2_pass_1;
            indi_3_4_3_pass_2       <= indi_3_4_3_pass_1;
            indi_3_4_4_pass_2       <= indi_3_4_4_pass_1;
            index_5                 <= index_4;
            index_5_original        <= index_4_original;
            weight_info_1_temp_p1   <= weight_info_1(1) xor weight_info_1(2) xor weight_info_1(3) xor weight_info_1(4);
            weight_info_1_temp_p2   <= weight_info_1(5) xor weight_info_1(6) xor weight_info_1(7) xor weight_info_1(8);
            weight_info_1_temp_p3   <= weight_info_1(9) xor weight_info_1(10) xor weight_info_1(11) xor weight_info_1(12);
            weight_info_1_temp_p4   <= weight_info_1(13) xor weight_info_1(14) xor weight_info_1(15) xor weight_info_1(16);
            --------------------------------------------------------------------------------------------------------------------------------------
            if indi_2_1_1_pass_1 = "001" then
                soft_input_1_1_1_flip_2                                   <= soft_input_1_1_1_flip_1;
                soft_input_1_1_2_flip_2                                   <= soft_input_1_1_2_flip_1;
                soft_input_1_1_3_flip_2                                   <= soft_input_1_1_3_flip_1;
                soft_input_1_1_4_flip_2                                   <= soft_input_1_1_4_flip_1;
                soft_input_1_1_1_flip_2(to_integer(unsigned(index_4(1)))) <= not soft_input_1_1_1_flip_1(to_integer(unsigned(index_4(1)))) + '1';
                weight_info_2(1)                                          <= soft_input_1_1_1_flip_1(to_integer(unsigned(index_4(1))));
            elsif indi_2_1_1_pass_1 = "010" then
                soft_input_1_1_1_flip_2                                   <= soft_input_1_1_1_flip_1;
                soft_input_1_1_2_flip_2                                   <= soft_input_1_1_2_flip_1;
                soft_input_1_1_3_flip_2                                   <= soft_input_1_1_3_flip_1;
                soft_input_1_1_4_flip_2                                   <= soft_input_1_1_4_flip_1;
                soft_input_1_1_2_flip_2(to_integer(unsigned(index_4(1)))) <= not soft_input_1_1_2_flip_1(to_integer(unsigned(index_4(1)))) + '1';
                weight_info_2(1)                                          <= soft_input_1_1_2_flip_1(to_integer(unsigned(index_4(1))));
            elsif indi_2_1_1_pass_1 = "011" then
                soft_input_1_1_1_flip_2                                   <= soft_input_1_1_1_flip_1;
                soft_input_1_1_2_flip_2                                   <= soft_input_1_1_2_flip_1;
                soft_input_1_1_3_flip_2                                   <= soft_input_1_1_3_flip_1;
                soft_input_1_1_4_flip_2                                   <= soft_input_1_1_4_flip_1;
                soft_input_1_1_3_flip_2(to_integer(unsigned(index_4(1)))) <= not soft_input_1_1_3_flip_1(to_integer(unsigned(index_4(1)))) + '1';
                weight_info_2(1)                                          <= soft_input_1_1_3_flip_1(to_integer(unsigned(index_4(1))));
            elsif indi_2_1_1_pass_1 = "100" then
                soft_input_1_1_1_flip_2                                   <= soft_input_1_1_1_flip_1;
                soft_input_1_1_2_flip_2                                   <= soft_input_1_1_2_flip_1;
                soft_input_1_1_3_flip_2                                   <= soft_input_1_1_3_flip_1;
                soft_input_1_1_4_flip_2                                   <= soft_input_1_1_4_flip_1;
                soft_input_1_1_4_flip_2(to_integer(unsigned(index_4(1)))) <= not soft_input_1_1_4_flip_1(to_integer(unsigned(index_4(1)))) + '1';
                weight_info_2(1)                                          <= soft_input_1_1_4_flip_1(to_integer(unsigned(index_4(1))));
            else
                soft_input_1_1_1_flip_2 <= soft_input_1_1_1_flip_1;
                soft_input_1_1_2_flip_2 <= soft_input_1_1_2_flip_1;
                soft_input_1_1_3_flip_2 <= soft_input_1_1_3_flip_1;
                soft_input_1_1_4_flip_2 <= soft_input_1_1_4_flip_1;
            end if;
            ------------------------------------------------------------------------------------------------------------------------------------
            if indi_2_1_2_pass_1 = "001" then
                soft_input_1_2_1_flip_2                                   <= soft_input_1_2_1_flip_1;
                soft_input_1_2_2_flip_2                                   <= soft_input_1_2_2_flip_1;
                soft_input_1_2_3_flip_2                                   <= soft_input_1_2_3_flip_1;
                soft_input_1_2_4_flip_2                                   <= soft_input_1_2_4_flip_1;
                soft_input_1_2_1_flip_2(to_integer(unsigned(index_4(1)))) <= not soft_input_1_2_1_flip_1(to_integer(unsigned(index_4(1)))) + '1';
                weight_info_2(2)                                          <= soft_input_1_2_1_flip_1(to_integer(unsigned(index_4(1))));
            elsif indi_2_1_2_pass_1 = "010" then
                soft_input_1_2_1_flip_2                                   <= soft_input_1_2_1_flip_1;
                soft_input_1_2_2_flip_2                                   <= soft_input_1_2_2_flip_1;
                soft_input_1_2_3_flip_2                                   <= soft_input_1_2_3_flip_1;
                soft_input_1_2_4_flip_2                                   <= soft_input_1_2_4_flip_1;
                soft_input_1_2_2_flip_2(to_integer(unsigned(index_4(1)))) <= not soft_input_1_2_2_flip_1(to_integer(unsigned(index_4(1)))) + '1';
                weight_info_2(2)                                          <= soft_input_1_2_2_flip_1(to_integer(unsigned(index_4(1))));
            elsif indi_2_1_2_pass_1 = "011" then
                soft_input_1_2_1_flip_2                                   <= soft_input_1_2_1_flip_1;
                soft_input_1_2_2_flip_2                                   <= soft_input_1_2_2_flip_1;
                soft_input_1_2_3_flip_2                                   <= soft_input_1_2_3_flip_1;
                soft_input_1_2_4_flip_2                                   <= soft_input_1_2_4_flip_1;
                soft_input_1_2_3_flip_2(to_integer(unsigned(index_4(1)))) <= not soft_input_1_2_3_flip_1(to_integer(unsigned(index_4(1)))) + '1';
                weight_info_2(2)                                          <= soft_input_1_2_3_flip_1(to_integer(unsigned(index_4(1))));
            elsif indi_2_1_2_pass_1 = "100" then
                soft_input_1_2_1_flip_2                                   <= soft_input_1_2_1_flip_1;
                soft_input_1_2_2_flip_2                                   <= soft_input_1_2_2_flip_1;
                soft_input_1_2_3_flip_2                                   <= soft_input_1_2_3_flip_1;
                soft_input_1_2_4_flip_2                                   <= soft_input_1_2_4_flip_1;
                soft_input_1_2_4_flip_2(to_integer(unsigned(index_4(1)))) <= not soft_input_1_2_4_flip_1(to_integer(unsigned(index_4(1)))) + '1';
                weight_info_2(2)                                          <= soft_input_1_2_4_flip_1(to_integer(unsigned(index_4(1))));
            else
                soft_input_1_2_1_flip_2 <= soft_input_1_2_1_flip_1;
                soft_input_1_2_2_flip_2 <= soft_input_1_2_2_flip_1;
                soft_input_1_2_3_flip_2 <= soft_input_1_2_3_flip_1;
                soft_input_1_2_4_flip_2 <= soft_input_1_2_4_flip_1;
            end if;
            ------------------------------------------------------------------------------------------------------------------------------------
            if indi_2_1_3_pass_1 = "001" then
                soft_input_1_3_1_flip_2                                   <= soft_input_1_3_1_flip_1;
                soft_input_1_3_2_flip_2                                   <= soft_input_1_3_2_flip_1;
                soft_input_1_3_3_flip_2                                   <= soft_input_1_3_3_flip_1;
                soft_input_1_3_4_flip_2                                   <= soft_input_1_3_4_flip_1;
                soft_input_1_3_1_flip_2(to_integer(unsigned(index_4(1)))) <= not soft_input_1_3_1_flip_1(to_integer(unsigned(index_4(1)))) + '1';
                weight_info_2(3)                                          <= soft_input_1_3_1_flip_1(to_integer(unsigned(index_4(1))));
            elsif indi_2_1_3_pass_1 = "010" then
                soft_input_1_3_1_flip_2                                   <= soft_input_1_3_1_flip_1;
                soft_input_1_3_2_flip_2                                   <= soft_input_1_3_2_flip_1;
                soft_input_1_3_3_flip_2                                   <= soft_input_1_3_3_flip_1;
                soft_input_1_3_4_flip_2                                   <= soft_input_1_3_4_flip_1;
                soft_input_1_3_2_flip_2(to_integer(unsigned(index_4(1)))) <= not soft_input_1_3_2_flip_1(to_integer(unsigned(index_4(1)))) + '1';
                weight_info_2(3)                                          <= soft_input_1_3_2_flip_1(to_integer(unsigned(index_4(1))));
            elsif indi_2_1_3_pass_1 = "011" then
                soft_input_1_3_1_flip_2                                   <= soft_input_1_3_1_flip_1;
                soft_input_1_3_2_flip_2                                   <= soft_input_1_3_2_flip_1;
                soft_input_1_3_3_flip_2                                   <= soft_input_1_3_3_flip_1;
                soft_input_1_3_4_flip_2                                   <= soft_input_1_3_4_flip_1;
                soft_input_1_3_3_flip_2(to_integer(unsigned(index_4(1)))) <= not soft_input_1_3_3_flip_1(to_integer(unsigned(index_4(1)))) + '1';
                weight_info_2(3)                                          <= soft_input_1_3_3_flip_1(to_integer(unsigned(index_4(1))));
            elsif indi_2_1_3_pass_1 = "100" then
                soft_input_1_3_1_flip_2                                   <= soft_input_1_3_1_flip_1;
                soft_input_1_3_2_flip_2                                   <= soft_input_1_3_2_flip_1;
                soft_input_1_3_3_flip_2                                   <= soft_input_1_3_3_flip_1;
                soft_input_1_3_4_flip_2                                   <= soft_input_1_3_4_flip_1;
                soft_input_1_3_4_flip_2(to_integer(unsigned(index_4(1)))) <= not soft_input_1_3_4_flip_1(to_integer(unsigned(index_4(1)))) + '1';
                weight_info_2(3)                                          <= soft_input_1_3_4_flip_1(to_integer(unsigned(index_4(1))));
            else
                soft_input_1_3_1_flip_2 <= soft_input_1_3_1_flip_1;
                soft_input_1_3_2_flip_2 <= soft_input_1_3_2_flip_1;
                soft_input_1_3_3_flip_2 <= soft_input_1_3_3_flip_1;
                soft_input_1_3_4_flip_2 <= soft_input_1_3_4_flip_1;
            end if;
            ------------------------------------------------------------------------------------------------------------------------------------
            if indi_2_1_4_pass_1 = "001" then
                soft_input_1_4_1_flip_2                                   <= soft_input_1_4_1_flip_1;
                soft_input_1_4_2_flip_2                                   <= soft_input_1_4_2_flip_1;
                soft_input_1_4_3_flip_2                                   <= soft_input_1_4_3_flip_1;
                soft_input_1_4_4_flip_2                                   <= soft_input_1_4_4_flip_1;
                soft_input_1_4_1_flip_2(to_integer(unsigned(index_4(1)))) <= not soft_input_1_4_1_flip_1(to_integer(unsigned(index_4(1)))) + '1';
                weight_info_2(4)                                          <= soft_input_1_4_1_flip_1(to_integer(unsigned(index_4(1))));
            elsif indi_2_1_4_pass_1 = "010" then
                soft_input_1_4_1_flip_2                                   <= soft_input_1_4_1_flip_1;
                soft_input_1_4_2_flip_2                                   <= soft_input_1_4_2_flip_1;
                soft_input_1_4_3_flip_2                                   <= soft_input_1_4_3_flip_1;
                soft_input_1_4_4_flip_2                                   <= soft_input_1_4_4_flip_1;
                soft_input_1_4_2_flip_2(to_integer(unsigned(index_4(1)))) <= not soft_input_1_4_2_flip_1(to_integer(unsigned(index_4(1)))) + '1';
                weight_info_2(4)                                          <= soft_input_1_4_2_flip_1(to_integer(unsigned(index_4(1))));
            elsif indi_2_1_4_pass_1 = "011" then
                soft_input_1_4_1_flip_2                                   <= soft_input_1_4_1_flip_1;
                soft_input_1_4_2_flip_2                                   <= soft_input_1_4_2_flip_1;
                soft_input_1_4_3_flip_2                                   <= soft_input_1_4_3_flip_1;
                soft_input_1_4_4_flip_2                                   <= soft_input_1_4_4_flip_1;
                soft_input_1_4_3_flip_2(to_integer(unsigned(index_4(1)))) <= not soft_input_1_4_3_flip_1(to_integer(unsigned(index_4(1)))) + '1';
                weight_info_2(4)                                          <= soft_input_1_4_3_flip_1(to_integer(unsigned(index_4(1))));
            elsif indi_2_1_4_pass_1 = "100" then
                soft_input_1_4_1_flip_2                                   <= soft_input_1_4_1_flip_1;
                soft_input_1_4_2_flip_2                                   <= soft_input_1_4_2_flip_1;
                soft_input_1_4_3_flip_2                                   <= soft_input_1_4_3_flip_1;
                soft_input_1_4_4_flip_2                                   <= soft_input_1_4_4_flip_1;
                soft_input_1_4_4_flip_2(to_integer(unsigned(index_4(1)))) <= not soft_input_1_4_4_flip_1(to_integer(unsigned(index_4(1)))) + '1';
                weight_info_2(4)                                          <= soft_input_1_4_4_flip_1(to_integer(unsigned(index_4(1))));
            else
                soft_input_1_4_1_flip_2 <= soft_input_1_4_1_flip_1;
                soft_input_1_4_2_flip_2 <= soft_input_1_4_2_flip_1;
                soft_input_1_4_3_flip_2 <= soft_input_1_4_3_flip_1;
                soft_input_1_4_4_flip_2 <= soft_input_1_4_4_flip_1;
            end if;
            ------------------------------------------------------------------------------------------------------------------------------------
            if indi_2_2_1_pass_1 = "001" then
                soft_input_2_1_1_flip_2                                   <= soft_input_2_1_1_flip_1;
                soft_input_2_1_2_flip_2                                   <= soft_input_2_1_2_flip_1;
                soft_input_2_1_3_flip_2                                   <= soft_input_2_1_3_flip_1;
                soft_input_2_1_4_flip_2                                   <= soft_input_2_1_4_flip_1;
                soft_input_2_1_1_flip_2(to_integer(unsigned(index_4(1)))) <= not soft_input_2_1_1_flip_1(to_integer(unsigned(index_4(1)))) + '1';
                weight_info_2(5)                                          <= soft_input_2_1_1_flip_1(to_integer(unsigned(index_4(1))));
            elsif indi_2_2_1_pass_1 = "010" then
                soft_input_2_1_1_flip_2                                   <= soft_input_2_1_1_flip_1;
                soft_input_2_1_2_flip_2                                   <= soft_input_2_1_2_flip_1;
                soft_input_2_1_3_flip_2                                   <= soft_input_2_1_3_flip_1;
                soft_input_2_1_4_flip_2                                   <= soft_input_2_1_4_flip_1;
                soft_input_2_1_2_flip_2(to_integer(unsigned(index_4(1)))) <= not soft_input_2_1_2_flip_1(to_integer(unsigned(index_4(1)))) + '1';
                weight_info_2(5)                                          <= soft_input_2_1_2_flip_1(to_integer(unsigned(index_4(1))));
            elsif indi_2_2_1_pass_1 = "011" then
                soft_input_2_1_1_flip_2                                   <= soft_input_2_1_1_flip_1;
                soft_input_2_1_2_flip_2                                   <= soft_input_2_1_2_flip_1;
                soft_input_2_1_3_flip_2                                   <= soft_input_2_1_3_flip_1;
                soft_input_2_1_4_flip_2                                   <= soft_input_2_1_4_flip_1;
                soft_input_2_1_3_flip_2(to_integer(unsigned(index_4(1)))) <= not soft_input_2_1_3_flip_1(to_integer(unsigned(index_4(1)))) + '1';
                weight_info_2(5)                                          <= soft_input_2_1_3_flip_1(to_integer(unsigned(index_4(1))));
            elsif indi_2_2_1_pass_1 = "100" then
                soft_input_2_1_1_flip_2                                   <= soft_input_2_1_1_flip_1;
                soft_input_2_1_2_flip_2                                   <= soft_input_2_1_2_flip_1;
                soft_input_2_1_3_flip_2                                   <= soft_input_2_1_3_flip_1;
                soft_input_2_1_4_flip_2                                   <= soft_input_2_1_4_flip_1;
                soft_input_2_1_4_flip_2(to_integer(unsigned(index_4(1)))) <= not soft_input_2_1_4_flip_1(to_integer(unsigned(index_4(1)))) + '1';
                weight_info_2(5)                                          <= soft_input_2_1_4_flip_1(to_integer(unsigned(index_4(1))));
            else
                soft_input_2_1_1_flip_2 <= soft_input_2_1_1_flip_1;
                soft_input_2_1_2_flip_2 <= soft_input_2_1_2_flip_1;
                soft_input_2_1_3_flip_2 <= soft_input_2_1_3_flip_1;
                soft_input_2_1_4_flip_2 <= soft_input_2_1_4_flip_1;
            end if;
            ------------------------------------------------------------------------------------------------------------------------------------
            if indi_2_2_2_pass_1 = "001" then
                soft_input_2_2_1_flip_2                                   <= soft_input_2_2_1_flip_1;
                soft_input_2_2_2_flip_2                                   <= soft_input_2_2_2_flip_1;
                soft_input_2_2_3_flip_2                                   <= soft_input_2_2_3_flip_1;
                soft_input_2_2_4_flip_2                                   <= soft_input_2_2_4_flip_1;
                soft_input_2_2_1_flip_2(to_integer(unsigned(index_4(1)))) <= not soft_input_2_2_1_flip_1(to_integer(unsigned(index_4(1)))) + '1';
                weight_info_2(6)                                          <= soft_input_2_2_1_flip_1(to_integer(unsigned(index_4(1))));
            elsif indi_2_2_2_pass_1 = "010" then
                soft_input_2_2_1_flip_2                                   <= soft_input_2_2_1_flip_1;
                soft_input_2_2_2_flip_2                                   <= soft_input_2_2_2_flip_1;
                soft_input_2_2_3_flip_2                                   <= soft_input_2_2_3_flip_1;
                soft_input_2_2_4_flip_2                                   <= soft_input_2_2_4_flip_1;
                soft_input_2_2_2_flip_2(to_integer(unsigned(index_4(1)))) <= not soft_input_2_2_2_flip_1(to_integer(unsigned(index_4(1)))) + '1';
                weight_info_2(6)                                          <= soft_input_2_2_2_flip_1(to_integer(unsigned(index_4(1))));
            elsif indi_2_2_2_pass_1 = "011" then
                soft_input_2_2_1_flip_2                                   <= soft_input_2_2_1_flip_1;
                soft_input_2_2_2_flip_2                                   <= soft_input_2_2_2_flip_1;
                soft_input_2_2_3_flip_2                                   <= soft_input_2_2_3_flip_1;
                soft_input_2_2_4_flip_2                                   <= soft_input_2_2_4_flip_1;
                soft_input_2_2_3_flip_2(to_integer(unsigned(index_4(1)))) <= not soft_input_2_2_3_flip_1(to_integer(unsigned(index_4(1)))) + '1';
                weight_info_2(6)                                          <= soft_input_2_2_3_flip_1(to_integer(unsigned(index_4(1))));
            elsif indi_2_2_2_pass_1 = "100" then
                soft_input_2_2_1_flip_2                                   <= soft_input_2_2_1_flip_1;
                soft_input_2_2_2_flip_2                                   <= soft_input_2_2_2_flip_1;
                soft_input_2_2_3_flip_2                                   <= soft_input_2_2_3_flip_1;
                soft_input_2_2_4_flip_2                                   <= soft_input_2_2_4_flip_1;
                soft_input_2_2_4_flip_2(to_integer(unsigned(index_4(1)))) <= not soft_input_2_2_4_flip_1(to_integer(unsigned(index_4(1)))) + '1';
                weight_info_2(6)                                          <= soft_input_2_2_4_flip_1(to_integer(unsigned(index_4(1))));
            else
                soft_input_2_2_1_flip_2 <= soft_input_2_2_1_flip_1;
                soft_input_2_2_2_flip_2 <= soft_input_2_2_2_flip_1;
                soft_input_2_2_3_flip_2 <= soft_input_2_2_3_flip_1;
                soft_input_2_2_4_flip_2 <= soft_input_2_2_4_flip_1;
            end if;
            ------------------------------------------------------------------------------------------------------------------------------------
            if indi_2_2_3_pass_1 = "001" then
                soft_input_2_3_1_flip_2                                   <= soft_input_2_3_1_flip_1;
                soft_input_2_3_2_flip_2                                   <= soft_input_2_3_2_flip_1;
                soft_input_2_3_3_flip_2                                   <= soft_input_2_3_3_flip_1;
                soft_input_2_3_4_flip_2                                   <= soft_input_2_3_4_flip_1;
                soft_input_2_3_1_flip_2(to_integer(unsigned(index_4(1)))) <= not soft_input_2_3_1_flip_1(to_integer(unsigned(index_4(1)))) + '1';
                weight_info_2(7)                                          <= soft_input_2_3_1_flip_1(to_integer(unsigned(index_4(1))));
            elsif indi_2_2_3_pass_1 = "010" then
                soft_input_2_3_1_flip_2                                   <= soft_input_2_3_1_flip_1;
                soft_input_2_3_2_flip_2                                   <= soft_input_2_3_2_flip_1;
                soft_input_2_3_3_flip_2                                   <= soft_input_2_3_3_flip_1;
                soft_input_2_3_4_flip_2                                   <= soft_input_2_3_4_flip_1;
                soft_input_2_3_2_flip_2(to_integer(unsigned(index_4(1)))) <= not soft_input_2_3_2_flip_1(to_integer(unsigned(index_4(1)))) + '1';
                weight_info_2(7)                                          <= soft_input_2_3_2_flip_1(to_integer(unsigned(index_4(1))));
            elsif indi_2_2_3_pass_1 = "011" then
                soft_input_2_3_1_flip_2                                   <= soft_input_2_3_1_flip_1;
                soft_input_2_3_2_flip_2                                   <= soft_input_2_3_2_flip_1;
                soft_input_2_3_3_flip_2                                   <= soft_input_2_3_3_flip_1;
                soft_input_2_3_4_flip_2                                   <= soft_input_2_3_4_flip_1;
                soft_input_2_3_3_flip_2(to_integer(unsigned(index_4(1)))) <= not soft_input_2_3_3_flip_1(to_integer(unsigned(index_4(1)))) + '1';
                weight_info_2(7)                                          <= soft_input_2_3_3_flip_1(to_integer(unsigned(index_4(1))));
            elsif indi_2_2_3_pass_1 = "100" then
                soft_input_2_3_1_flip_2                                   <= soft_input_2_3_1_flip_1;
                soft_input_2_3_2_flip_2                                   <= soft_input_2_3_2_flip_1;
                soft_input_2_3_3_flip_2                                   <= soft_input_2_3_3_flip_1;
                soft_input_2_3_4_flip_2                                   <= soft_input_2_3_4_flip_1;
                soft_input_2_3_4_flip_2(to_integer(unsigned(index_4(1)))) <= not soft_input_2_3_4_flip_1(to_integer(unsigned(index_4(1)))) + '1';
                weight_info_2(7)                                          <= soft_input_2_3_4_flip_1(to_integer(unsigned(index_4(1))));
            else
                soft_input_2_3_1_flip_2 <= soft_input_2_3_1_flip_1;
                soft_input_2_3_2_flip_2 <= soft_input_2_3_2_flip_1;
                soft_input_2_3_3_flip_2 <= soft_input_2_3_3_flip_1;
                soft_input_2_3_4_flip_2 <= soft_input_2_3_4_flip_1;
            end if;
            ------------------------------------------------------------------------------------------------------------------------------------
            if indi_2_2_4_pass_1 = "001" then
                soft_input_2_4_1_flip_2                                   <= soft_input_2_4_1_flip_1;
                soft_input_2_4_2_flip_2                                   <= soft_input_2_4_2_flip_1;
                soft_input_2_4_3_flip_2                                   <= soft_input_2_4_3_flip_1;
                soft_input_2_4_4_flip_2                                   <= soft_input_2_4_4_flip_1;
                soft_input_2_4_1_flip_2(to_integer(unsigned(index_4(1)))) <= not soft_input_2_4_1_flip_1(to_integer(unsigned(index_4(1)))) + '1';
                weight_info_2(8)                                          <= soft_input_2_4_1_flip_1(to_integer(unsigned(index_4(1))));
            elsif indi_2_2_4_pass_1 = "010" then
                soft_input_2_4_1_flip_2                                   <= soft_input_2_4_1_flip_1;
                soft_input_2_4_2_flip_2                                   <= soft_input_2_4_2_flip_1;
                soft_input_2_4_3_flip_2                                   <= soft_input_2_4_3_flip_1;
                soft_input_2_4_4_flip_2                                   <= soft_input_2_4_4_flip_1;
                soft_input_2_4_2_flip_2(to_integer(unsigned(index_4(1)))) <= not soft_input_2_4_2_flip_1(to_integer(unsigned(index_4(1)))) + '1';
                weight_info_2(8)                                          <= soft_input_2_4_2_flip_1(to_integer(unsigned(index_4(1))));
            elsif indi_2_2_4_pass_1 = "011" then
                soft_input_2_4_1_flip_2                                   <= soft_input_2_4_1_flip_1;
                soft_input_2_4_2_flip_2                                   <= soft_input_2_4_2_flip_1;
                soft_input_2_4_3_flip_2                                   <= soft_input_2_4_3_flip_1;
                soft_input_2_4_4_flip_2                                   <= soft_input_2_4_4_flip_1;
                soft_input_2_4_3_flip_2(to_integer(unsigned(index_4(1)))) <= not soft_input_2_4_3_flip_1(to_integer(unsigned(index_4(1)))) + '1';
                weight_info_2(8)                                          <= soft_input_2_4_3_flip_1(to_integer(unsigned(index_4(1))));
            elsif indi_2_2_4_pass_1 = "100" then
                soft_input_2_4_1_flip_2                                   <= soft_input_2_4_1_flip_1;
                soft_input_2_4_2_flip_2                                   <= soft_input_2_4_2_flip_1;
                soft_input_2_4_3_flip_2                                   <= soft_input_2_4_3_flip_1;
                soft_input_2_4_4_flip_2                                   <= soft_input_2_4_4_flip_1;
                soft_input_2_4_4_flip_2(to_integer(unsigned(index_4(1)))) <= not soft_input_2_4_4_flip_1(to_integer(unsigned(index_4(1)))) + '1';
                weight_info_2(8)                                          <= soft_input_2_4_4_flip_1(to_integer(unsigned(index_4(1))));
            else
                soft_input_2_4_1_flip_2 <= soft_input_2_4_1_flip_1;
                soft_input_2_4_2_flip_2 <= soft_input_2_4_2_flip_1;
                soft_input_2_4_3_flip_2 <= soft_input_2_4_3_flip_1;
                soft_input_2_4_4_flip_2 <= soft_input_2_4_4_flip_1;
            end if;
            ------------------------------------------------------------------------------------------------------------------------------------
            if indi_2_3_1_pass_1 = "001" then
                soft_input_3_1_1_flip_2                                   <= soft_input_3_1_1_flip_1;
                soft_input_3_1_2_flip_2                                   <= soft_input_3_1_2_flip_1;
                soft_input_3_1_3_flip_2                                   <= soft_input_3_1_3_flip_1;
                soft_input_3_1_4_flip_2                                   <= soft_input_3_1_4_flip_1;
                soft_input_3_1_1_flip_2(to_integer(unsigned(index_4(1)))) <= not soft_input_3_1_1_flip_1(to_integer(unsigned(index_4(1)))) + '1';
                weight_info_2(9)                                          <= soft_input_3_1_1_flip_1(to_integer(unsigned(index_4(1))));
            elsif indi_2_3_1_pass_1 = "010" then
                soft_input_3_1_1_flip_2                                   <= soft_input_3_1_1_flip_1;
                soft_input_3_1_2_flip_2                                   <= soft_input_3_1_2_flip_1;
                soft_input_3_1_3_flip_2                                   <= soft_input_3_1_3_flip_1;
                soft_input_3_1_4_flip_2                                   <= soft_input_3_1_4_flip_1;
                soft_input_3_1_2_flip_2(to_integer(unsigned(index_4(1)))) <= not soft_input_3_1_2_flip_1(to_integer(unsigned(index_4(1)))) + '1';
                weight_info_2(9)                                          <= soft_input_3_1_2_flip_1(to_integer(unsigned(index_4(1))));
            elsif indi_2_3_1_pass_1 = "011" then
                soft_input_3_1_1_flip_2                                   <= soft_input_3_1_1_flip_1;
                soft_input_3_1_2_flip_2                                   <= soft_input_3_1_2_flip_1;
                soft_input_3_1_3_flip_2                                   <= soft_input_3_1_3_flip_1;
                soft_input_3_1_4_flip_2                                   <= soft_input_3_1_4_flip_1;
                soft_input_3_1_3_flip_2(to_integer(unsigned(index_4(1)))) <= not soft_input_3_1_3_flip_1(to_integer(unsigned(index_4(1)))) + '1';
                weight_info_2(9)                                          <= soft_input_3_1_3_flip_1(to_integer(unsigned(index_4(1))));
            elsif indi_2_3_1_pass_1 = "100" then
                soft_input_3_1_1_flip_2                                   <= soft_input_3_1_1_flip_1;
                soft_input_3_1_2_flip_2                                   <= soft_input_3_1_2_flip_1;
                soft_input_3_1_3_flip_2                                   <= soft_input_3_1_3_flip_1;
                soft_input_3_1_4_flip_2                                   <= soft_input_3_1_4_flip_1;
                soft_input_3_1_4_flip_2(to_integer(unsigned(index_4(1)))) <= not soft_input_3_1_4_flip_1(to_integer(unsigned(index_4(1)))) + '1';
                weight_info_2(9)                                          <= soft_input_3_1_4_flip_1(to_integer(unsigned(index_4(1))));
            else
                soft_input_3_1_1_flip_2 <= soft_input_3_1_1_flip_1;
                soft_input_3_1_2_flip_2 <= soft_input_3_1_2_flip_1;
                soft_input_3_1_3_flip_2 <= soft_input_3_1_3_flip_1;
                soft_input_3_1_4_flip_2 <= soft_input_3_1_4_flip_1;
            end if;
            ------------------------------------------------------------------------------------------------------------------------------------
            if indi_2_3_2_pass_1 = "001" then
                soft_input_3_2_1_flip_2                                   <= soft_input_3_2_1_flip_1;
                soft_input_3_2_2_flip_2                                   <= soft_input_3_2_2_flip_1;
                soft_input_3_2_3_flip_2                                   <= soft_input_3_2_3_flip_1;
                soft_input_3_2_4_flip_2                                   <= soft_input_3_2_4_flip_1;
                soft_input_3_2_1_flip_2(to_integer(unsigned(index_4(1)))) <= not soft_input_3_2_1_flip_1(to_integer(unsigned(index_4(1)))) + '1';
                weight_info_2(10)                                         <= soft_input_3_2_1_flip_1(to_integer(unsigned(index_4(1))));
            elsif indi_2_3_2_pass_1 = "010" then
                soft_input_3_2_1_flip_2                                   <= soft_input_3_2_1_flip_1;
                soft_input_3_2_2_flip_2                                   <= soft_input_3_2_2_flip_1;
                soft_input_3_2_3_flip_2                                   <= soft_input_3_2_3_flip_1;
                soft_input_3_2_4_flip_2                                   <= soft_input_3_2_4_flip_1;
                soft_input_3_2_2_flip_2(to_integer(unsigned(index_4(1)))) <= not soft_input_3_2_2_flip_1(to_integer(unsigned(index_4(1)))) + '1';
                weight_info_2(10)                                         <= soft_input_3_2_2_flip_1(to_integer(unsigned(index_4(1))));
            elsif indi_2_3_2_pass_1 = "011" then
                soft_input_3_2_1_flip_2                                   <= soft_input_3_2_1_flip_1;
                soft_input_3_2_2_flip_2                                   <= soft_input_3_2_2_flip_1;
                soft_input_3_2_3_flip_2                                   <= soft_input_3_2_3_flip_1;
                soft_input_3_2_4_flip_2                                   <= soft_input_3_2_4_flip_1;
                soft_input_3_2_3_flip_2(to_integer(unsigned(index_4(1)))) <= not soft_input_3_2_3_flip_1(to_integer(unsigned(index_4(1)))) + '1';
                weight_info_2(10)                                         <= soft_input_3_2_3_flip_1(to_integer(unsigned(index_4(1))));
            elsif indi_2_3_2_pass_1 = "100" then
                soft_input_3_2_1_flip_2                                   <= soft_input_3_2_1_flip_1;
                soft_input_3_2_2_flip_2                                   <= soft_input_3_2_2_flip_1;
                soft_input_3_2_3_flip_2                                   <= soft_input_3_2_3_flip_1;
                soft_input_3_2_4_flip_2                                   <= soft_input_3_2_4_flip_1;
                soft_input_3_2_4_flip_2(to_integer(unsigned(index_4(1)))) <= not soft_input_3_2_4_flip_1(to_integer(unsigned(index_4(1)))) + '1';
                weight_info_2(10)                                         <= soft_input_3_2_4_flip_1(to_integer(unsigned(index_4(1))));
            else
                soft_input_3_2_1_flip_2 <= soft_input_3_2_1_flip_1;
                soft_input_3_2_2_flip_2 <= soft_input_3_2_2_flip_1;
                soft_input_3_2_3_flip_2 <= soft_input_3_2_3_flip_1;
                soft_input_3_2_4_flip_2 <= soft_input_3_2_4_flip_1;
            end if;
            ------------------------------------------------------------------------------------------------------------------------------------
            if indi_2_3_3_pass_1 = "001" then
                soft_input_3_3_1_flip_2                                   <= soft_input_3_3_1_flip_1;
                soft_input_3_3_2_flip_2                                   <= soft_input_3_3_2_flip_1;
                soft_input_3_3_3_flip_2                                   <= soft_input_3_3_3_flip_1;
                soft_input_3_3_4_flip_2                                   <= soft_input_3_3_4_flip_1;
                soft_input_3_3_1_flip_2(to_integer(unsigned(index_4(1)))) <= not soft_input_3_3_1_flip_1(to_integer(unsigned(index_4(1)))) + '1';
                weight_info_2(11)                                         <= soft_input_3_3_1_flip_1(to_integer(unsigned(index_4(1))));
            elsif indi_2_3_3_pass_1 = "010" then
                soft_input_3_3_1_flip_2                                   <= soft_input_3_3_1_flip_1;
                soft_input_3_3_2_flip_2                                   <= soft_input_3_3_2_flip_1;
                soft_input_3_3_3_flip_2                                   <= soft_input_3_3_3_flip_1;
                soft_input_3_3_4_flip_2                                   <= soft_input_3_3_4_flip_1;
                soft_input_3_3_2_flip_2(to_integer(unsigned(index_4(1)))) <= not soft_input_3_3_2_flip_1(to_integer(unsigned(index_4(1)))) + '1';
                weight_info_2(11)                                         <= soft_input_3_3_2_flip_1(to_integer(unsigned(index_4(1))));
            elsif indi_2_3_3_pass_1 = "011" then
                soft_input_3_3_1_flip_2                                   <= soft_input_3_3_1_flip_1;
                soft_input_3_3_2_flip_2                                   <= soft_input_3_3_2_flip_1;
                soft_input_3_3_3_flip_2                                   <= soft_input_3_3_3_flip_1;
                soft_input_3_3_4_flip_2                                   <= soft_input_3_3_4_flip_1;
                soft_input_3_3_3_flip_2(to_integer(unsigned(index_4(1)))) <= not soft_input_3_3_3_flip_1(to_integer(unsigned(index_4(1)))) + '1';
                weight_info_2(11)                                         <= soft_input_3_3_3_flip_1(to_integer(unsigned(index_4(1))));
            elsif indi_2_3_3_pass_1 = "100" then
                soft_input_3_3_1_flip_2                                   <= soft_input_3_3_1_flip_1;
                soft_input_3_3_2_flip_2                                   <= soft_input_3_3_2_flip_1;
                soft_input_3_3_3_flip_2                                   <= soft_input_3_3_3_flip_1;
                soft_input_3_3_4_flip_2                                   <= soft_input_3_3_4_flip_1;
                soft_input_3_3_4_flip_2(to_integer(unsigned(index_4(1)))) <= not soft_input_3_3_4_flip_1(to_integer(unsigned(index_4(1)))) + '1';
                weight_info_2(11)                                         <= soft_input_3_3_4_flip_1(to_integer(unsigned(index_4(1))));
            else
                soft_input_3_3_1_flip_2 <= soft_input_3_3_1_flip_1;
                soft_input_3_3_2_flip_2 <= soft_input_3_3_2_flip_1;
                soft_input_3_3_3_flip_2 <= soft_input_3_3_3_flip_1;
                soft_input_3_3_4_flip_2 <= soft_input_3_3_4_flip_1;
            end if;
            ------------------------------------------------------------------------------------------------------------------------------------
            if indi_2_3_4_pass_1 = "001" then
                soft_input_3_4_1_flip_2                                   <= soft_input_3_4_1_flip_1;
                soft_input_3_4_2_flip_2                                   <= soft_input_3_4_2_flip_1;
                soft_input_3_4_3_flip_2                                   <= soft_input_3_4_3_flip_1;
                soft_input_3_4_4_flip_2                                   <= soft_input_3_4_4_flip_1;
                soft_input_3_4_1_flip_2(to_integer(unsigned(index_4(1)))) <= not soft_input_3_4_1_flip_1(to_integer(unsigned(index_4(1)))) + '1';
                weight_info_2(12)                                         <= soft_input_3_4_1_flip_1(to_integer(unsigned(index_4(1))));
            elsif indi_2_3_4_pass_1 = "010" then
                soft_input_3_4_1_flip_2                                   <= soft_input_3_4_1_flip_1;
                soft_input_3_4_2_flip_2                                   <= soft_input_3_4_2_flip_1;
                soft_input_3_4_3_flip_2                                   <= soft_input_3_4_3_flip_1;
                soft_input_3_4_4_flip_2                                   <= soft_input_3_4_4_flip_1;
                soft_input_3_4_2_flip_2(to_integer(unsigned(index_4(1)))) <= not soft_input_3_4_2_flip_1(to_integer(unsigned(index_4(1)))) + '1';
                weight_info_2(12)                                         <= soft_input_3_4_2_flip_1(to_integer(unsigned(index_4(1))));
            elsif indi_2_3_4_pass_1 = "011" then
                soft_input_3_4_1_flip_2                                   <= soft_input_3_4_1_flip_1;
                soft_input_3_4_2_flip_2                                   <= soft_input_3_4_2_flip_1;
                soft_input_3_4_3_flip_2                                   <= soft_input_3_4_3_flip_1;
                soft_input_3_4_4_flip_2                                   <= soft_input_3_4_4_flip_1;
                soft_input_3_4_3_flip_2(to_integer(unsigned(index_4(1)))) <= not soft_input_3_4_3_flip_1(to_integer(unsigned(index_4(1)))) + '1';
                weight_info_2(12)                                         <= soft_input_3_4_3_flip_1(to_integer(unsigned(index_4(1))));
            elsif indi_2_3_4_pass_1 = "100" then
                soft_input_3_4_1_flip_2                                   <= soft_input_3_4_1_flip_1;
                soft_input_3_4_2_flip_2                                   <= soft_input_3_4_2_flip_1;
                soft_input_3_4_3_flip_2                                   <= soft_input_3_4_3_flip_1;
                soft_input_3_4_4_flip_2                                   <= soft_input_3_4_4_flip_1;
                soft_input_3_4_4_flip_2(to_integer(unsigned(index_4(1)))) <= not soft_input_3_4_4_flip_1(to_integer(unsigned(index_4(1)))) + '1';
                weight_info_2(12)                                         <= soft_input_3_4_4_flip_1(to_integer(unsigned(index_4(1))));
            else
                soft_input_3_4_1_flip_2 <= soft_input_3_4_1_flip_1;
                soft_input_3_4_2_flip_2 <= soft_input_3_4_2_flip_1;
                soft_input_3_4_3_flip_2 <= soft_input_3_4_3_flip_1;
                soft_input_3_4_4_flip_2 <= soft_input_3_4_4_flip_1;
            end if;
            ------------------------------------------------------------------------------------------------------------------------------------
            if indi_2_4_1_pass_1 = "001" then
                soft_input_4_1_1_flip_2                                   <= soft_input_4_1_1_flip_1;
                soft_input_4_1_2_flip_2                                   <= soft_input_4_1_2_flip_1;
                soft_input_4_1_3_flip_2                                   <= soft_input_4_1_3_flip_1;
                soft_input_4_1_4_flip_2                                   <= soft_input_4_1_4_flip_1;
                soft_input_4_1_1_flip_2(to_integer(unsigned(index_4(1)))) <= not soft_input_4_1_1_flip_1(to_integer(unsigned(index_4(1)))) + '1';
                weight_info_2(13)                                         <= soft_input_4_1_1_flip_1(to_integer(unsigned(index_4(1))));
            elsif indi_2_4_1_pass_1 = "010" then
                soft_input_4_1_1_flip_2                                   <= soft_input_4_1_1_flip_1;
                soft_input_4_1_2_flip_2                                   <= soft_input_4_1_2_flip_1;
                soft_input_4_1_3_flip_2                                   <= soft_input_4_1_3_flip_1;
                soft_input_4_1_4_flip_2                                   <= soft_input_4_1_4_flip_1;
                soft_input_4_1_2_flip_2(to_integer(unsigned(index_4(1)))) <= not soft_input_4_1_2_flip_1(to_integer(unsigned(index_4(1)))) + '1';
                weight_info_2(13)                                         <= soft_input_4_1_2_flip_1(to_integer(unsigned(index_4(1))));
            elsif indi_2_4_1_pass_1 = "011" then
                soft_input_4_1_1_flip_2                                   <= soft_input_4_1_1_flip_1;
                soft_input_4_1_2_flip_2                                   <= soft_input_4_1_2_flip_1;
                soft_input_4_1_3_flip_2                                   <= soft_input_4_1_3_flip_1;
                soft_input_4_1_4_flip_2                                   <= soft_input_4_1_4_flip_1;
                soft_input_4_1_3_flip_2(to_integer(unsigned(index_4(1)))) <= not soft_input_4_1_3_flip_1(to_integer(unsigned(index_4(1)))) + '1';
                weight_info_2(13)                                         <= soft_input_4_1_3_flip_1(to_integer(unsigned(index_4(1))));
            elsif indi_2_4_1_pass_1 = "100" then
                soft_input_4_1_1_flip_2                                   <= soft_input_4_1_1_flip_1;
                soft_input_4_1_2_flip_2                                   <= soft_input_4_1_2_flip_1;
                soft_input_4_1_3_flip_2                                   <= soft_input_4_1_3_flip_1;
                soft_input_4_1_4_flip_2                                   <= soft_input_4_1_4_flip_1;
                soft_input_4_1_4_flip_2(to_integer(unsigned(index_4(1)))) <= not soft_input_4_1_4_flip_1(to_integer(unsigned(index_4(1)))) + '1';
                weight_info_2(13)                                         <= soft_input_4_1_4_flip_1(to_integer(unsigned(index_4(1))));
            else
                soft_input_4_1_1_flip_2 <= soft_input_4_1_1_flip_1;
                soft_input_4_1_2_flip_2 <= soft_input_4_1_2_flip_1;
                soft_input_4_1_3_flip_2 <= soft_input_4_1_3_flip_1;
                soft_input_4_1_4_flip_2 <= soft_input_4_1_4_flip_1;
            end if;
            ------------------------------------------------------------------------------------------------------------------------------------
            if indi_2_4_2_pass_1 = "001" then
                soft_input_4_2_1_flip_2                                   <= soft_input_4_2_1_flip_1;
                soft_input_4_2_2_flip_2                                   <= soft_input_4_2_2_flip_1;
                soft_input_4_2_3_flip_2                                   <= soft_input_4_2_3_flip_1;
                soft_input_4_2_4_flip_2                                   <= soft_input_4_2_4_flip_1;
                soft_input_4_2_1_flip_2(to_integer(unsigned(index_4(1)))) <= not soft_input_4_2_1_flip_1(to_integer(unsigned(index_4(1)))) + '1';
                weight_info_2(14)                                         <= soft_input_4_2_1_flip_1(to_integer(unsigned(index_4(1))));
            elsif indi_2_4_2_pass_1 = "010" then
                soft_input_4_2_1_flip_2                                   <= soft_input_4_2_1_flip_1;
                soft_input_4_2_2_flip_2                                   <= soft_input_4_2_2_flip_1;
                soft_input_4_2_3_flip_2                                   <= soft_input_4_2_3_flip_1;
                soft_input_4_2_4_flip_2                                   <= soft_input_4_2_4_flip_1;
                soft_input_4_2_2_flip_2(to_integer(unsigned(index_4(1)))) <= not soft_input_4_2_2_flip_1(to_integer(unsigned(index_4(1)))) + '1';
                weight_info_2(14)                                         <= soft_input_4_2_2_flip_1(to_integer(unsigned(index_4(1))));
            elsif indi_2_4_2_pass_1 = "011" then
                soft_input_4_2_1_flip_2                                   <= soft_input_4_2_1_flip_1;
                soft_input_4_2_2_flip_2                                   <= soft_input_4_2_2_flip_1;
                soft_input_4_2_3_flip_2                                   <= soft_input_4_2_3_flip_1;
                soft_input_4_2_4_flip_2                                   <= soft_input_4_2_4_flip_1;
                soft_input_4_2_3_flip_2(to_integer(unsigned(index_4(1)))) <= not soft_input_4_2_3_flip_1(to_integer(unsigned(index_4(1)))) + '1';
                weight_info_2(14)                                         <= soft_input_4_2_3_flip_1(to_integer(unsigned(index_4(1))));
            elsif indi_2_4_2_pass_1 = "100" then
                soft_input_4_2_1_flip_2                                   <= soft_input_4_2_1_flip_1;
                soft_input_4_2_2_flip_2                                   <= soft_input_4_2_2_flip_1;
                soft_input_4_2_3_flip_2                                   <= soft_input_4_2_3_flip_1;
                soft_input_4_2_4_flip_2                                   <= soft_input_4_2_4_flip_1;
                soft_input_4_2_4_flip_2(to_integer(unsigned(index_4(1)))) <= not soft_input_4_2_4_flip_1(to_integer(unsigned(index_4(1)))) + '1';
                weight_info_2(14)                                         <= soft_input_4_2_4_flip_1(to_integer(unsigned(index_4(1))));
            else
                soft_input_4_2_1_flip_2 <= soft_input_4_2_1_flip_1;
                soft_input_4_2_2_flip_2 <= soft_input_4_2_2_flip_1;
                soft_input_4_2_3_flip_2 <= soft_input_4_2_3_flip_1;
                soft_input_4_2_4_flip_2 <= soft_input_4_2_4_flip_1;
            end if;
            ------------------------------------------------------------------------------------------------------------------------------------
            if indi_2_4_3_pass_1 = "001" then
                soft_input_4_3_1_flip_2                                   <= soft_input_4_3_1_flip_1;
                soft_input_4_3_2_flip_2                                   <= soft_input_4_3_2_flip_1;
                soft_input_4_3_3_flip_2                                   <= soft_input_4_3_3_flip_1;
                soft_input_4_3_4_flip_2                                   <= soft_input_4_3_4_flip_1;
                soft_input_4_3_1_flip_2(to_integer(unsigned(index_4(1)))) <= not soft_input_4_3_1_flip_1(to_integer(unsigned(index_4(1)))) + '1';
                weight_info_2(15)                                         <= soft_input_4_3_1_flip_1(to_integer(unsigned(index_4(1))));
            elsif indi_2_4_3_pass_1 = "010" then
                soft_input_4_3_1_flip_2                                   <= soft_input_4_3_1_flip_1;
                soft_input_4_3_2_flip_2                                   <= soft_input_4_3_2_flip_1;
                soft_input_4_3_3_flip_2                                   <= soft_input_4_3_3_flip_1;
                soft_input_4_3_4_flip_2                                   <= soft_input_4_3_4_flip_1;
                soft_input_4_3_2_flip_2(to_integer(unsigned(index_4(1)))) <= not soft_input_4_3_2_flip_1(to_integer(unsigned(index_4(1)))) + '1';
                weight_info_2(15)                                         <= soft_input_4_3_2_flip_1(to_integer(unsigned(index_4(1))));
            elsif indi_2_4_3_pass_1 = "011" then
                soft_input_4_3_1_flip_2                                   <= soft_input_4_3_1_flip_1;
                soft_input_4_3_2_flip_2                                   <= soft_input_4_3_2_flip_1;
                soft_input_4_3_3_flip_2                                   <= soft_input_4_3_3_flip_1;
                soft_input_4_3_4_flip_2                                   <= soft_input_4_3_4_flip_1;
                soft_input_4_3_3_flip_2(to_integer(unsigned(index_4(1)))) <= not soft_input_4_3_3_flip_1(to_integer(unsigned(index_4(1)))) + '1';
                weight_info_2(15)                                         <= soft_input_4_3_3_flip_1(to_integer(unsigned(index_4(1))));
            elsif indi_2_4_3_pass_1 = "100" then
                soft_input_4_3_1_flip_2                                   <= soft_input_4_3_1_flip_1;
                soft_input_4_3_2_flip_2                                   <= soft_input_4_3_2_flip_1;
                soft_input_4_3_3_flip_2                                   <= soft_input_4_3_3_flip_1;
                soft_input_4_3_4_flip_2                                   <= soft_input_4_3_4_flip_1;
                soft_input_4_3_4_flip_2(to_integer(unsigned(index_4(1)))) <= not soft_input_4_3_4_flip_1(to_integer(unsigned(index_4(1)))) + '1';
                weight_info_2(15)                                         <= soft_input_4_3_4_flip_1(to_integer(unsigned(index_4(1))));
            else
                soft_input_4_3_1_flip_2 <= soft_input_4_3_1_flip_1;
                soft_input_4_3_2_flip_2 <= soft_input_4_3_2_flip_1;
                soft_input_4_3_3_flip_2 <= soft_input_4_3_3_flip_1;
                soft_input_4_3_4_flip_2 <= soft_input_4_3_4_flip_1;
            end if;
            ------------------------------------------------------------------------------------------------------------------------------------
            if indi_2_4_4_pass_1 = "001" then
                soft_input_4_4_1_flip_2                                   <= soft_input_4_4_1_flip_1;
                soft_input_4_4_2_flip_2                                   <= soft_input_4_4_2_flip_1;
                soft_input_4_4_3_flip_2                                   <= soft_input_4_4_3_flip_1;
                soft_input_4_4_4_flip_2                                   <= soft_input_4_4_4_flip_1;
                soft_input_4_4_1_flip_2(to_integer(unsigned(index_4(1)))) <= not soft_input_4_4_1_flip_1(to_integer(unsigned(index_4(1)))) + '1';
                weight_info_2(16)                                         <= soft_input_4_4_1_flip_1(to_integer(unsigned(index_4(1))));
            elsif indi_2_4_4_pass_1 = "010" then
                soft_input_4_4_1_flip_2                                   <= soft_input_4_4_1_flip_1;
                soft_input_4_4_2_flip_2                                   <= soft_input_4_4_2_flip_1;
                soft_input_4_4_3_flip_2                                   <= soft_input_4_4_3_flip_1;
                soft_input_4_4_4_flip_2                                   <= soft_input_4_4_4_flip_1;
                soft_input_4_4_2_flip_2(to_integer(unsigned(index_4(1)))) <= not soft_input_4_4_2_flip_1(to_integer(unsigned(index_4(1)))) + '1';
                weight_info_2(16)                                         <= soft_input_4_4_2_flip_1(to_integer(unsigned(index_4(1))));
            elsif indi_2_4_4_pass_1 = "011" then
                soft_input_4_4_1_flip_2                                   <= soft_input_4_4_1_flip_1;
                soft_input_4_4_2_flip_2                                   <= soft_input_4_4_2_flip_1;
                soft_input_4_4_3_flip_2                                   <= soft_input_4_4_3_flip_1;
                soft_input_4_4_4_flip_2                                   <= soft_input_4_4_4_flip_1;
                soft_input_4_4_3_flip_2(to_integer(unsigned(index_4(1)))) <= not soft_input_4_4_3_flip_1(to_integer(unsigned(index_4(1)))) + '1';
                weight_info_2(16)                                         <= soft_input_4_4_3_flip_1(to_integer(unsigned(index_4(1))));
            elsif indi_2_4_4_pass_1 = "100" then
                soft_input_4_4_1_flip_2                                   <= soft_input_4_4_1_flip_1;
                soft_input_4_4_2_flip_2                                   <= soft_input_4_4_2_flip_1;
                soft_input_4_4_3_flip_2                                   <= soft_input_4_4_3_flip_1;
                soft_input_4_4_4_flip_2                                   <= soft_input_4_4_4_flip_1;
                soft_input_4_4_4_flip_2(to_integer(unsigned(index_4(1)))) <= not soft_input_4_4_4_flip_1(to_integer(unsigned(index_4(1)))) + '1';
                weight_info_2(16)                                         <= soft_input_4_4_4_flip_1(to_integer(unsigned(index_4(1))));
            else
                soft_input_4_4_1_flip_2 <= soft_input_4_4_1_flip_1;
                soft_input_4_4_2_flip_2 <= soft_input_4_4_2_flip_1;
                soft_input_4_4_3_flip_2 <= soft_input_4_4_3_flip_1;
                soft_input_4_4_4_flip_2 <= soft_input_4_4_4_flip_1;
            end if;
        end if;
    end process;
    ------------------------------------------------------------------------------------------------------------
    -- Define processes : (CLK 5)
    ------------------------------------------------------------------------------------------------------------
    process (clk, reset)
    begin
        if (reset = '1') then
            soft_output_unflipped_6 <= (others => (others => '0'));
            weight_info_3           <= (others => (others => '0'));
            soft_input_1_1_1_flip_3 <= (others => (others => '0'));
            soft_input_1_1_2_flip_3 <= (others => (others => '0'));
            soft_input_1_1_3_flip_3 <= (others => (others => '0'));
            soft_input_1_1_4_flip_3 <= (others => (others => '0'));
            soft_input_1_2_1_flip_3 <= (others => (others => '0'));
            soft_input_1_2_2_flip_3 <= (others => (others => '0'));
            soft_input_1_2_3_flip_3 <= (others => (others => '0'));
            soft_input_1_2_4_flip_3 <= (others => (others => '0'));
            soft_input_1_3_1_flip_3 <= (others => (others => '0'));
            soft_input_1_3_2_flip_3 <= (others => (others => '0'));
            soft_input_1_3_3_flip_3 <= (others => (others => '0'));
            soft_input_1_3_4_flip_3 <= (others => (others => '0'));
            soft_input_1_4_1_flip_3 <= (others => (others => '0'));
            soft_input_1_4_2_flip_3 <= (others => (others => '0'));
            soft_input_1_4_3_flip_3 <= (others => (others => '0'));
            soft_input_1_4_4_flip_3 <= (others => (others => '0'));
            soft_input_2_1_1_flip_3 <= (others => (others => '0'));
            soft_input_2_1_2_flip_3 <= (others => (others => '0'));
            soft_input_2_1_3_flip_3 <= (others => (others => '0'));
            soft_input_2_1_4_flip_3 <= (others => (others => '0'));
            soft_input_2_2_1_flip_3 <= (others => (others => '0'));
            soft_input_2_2_2_flip_3 <= (others => (others => '0'));
            soft_input_2_2_3_flip_3 <= (others => (others => '0'));
            soft_input_2_2_4_flip_3 <= (others => (others => '0'));
            soft_input_2_3_1_flip_3 <= (others => (others => '0'));
            soft_input_2_3_2_flip_3 <= (others => (others => '0'));
            soft_input_2_3_3_flip_3 <= (others => (others => '0'));
            soft_input_2_3_4_flip_3 <= (others => (others => '0'));
            soft_input_2_4_1_flip_3 <= (others => (others => '0'));
            soft_input_2_4_2_flip_3 <= (others => (others => '0'));
            soft_input_2_4_3_flip_3 <= (others => (others => '0'));
            soft_input_2_4_4_flip_3 <= (others => (others => '0'));
            soft_input_3_1_1_flip_3 <= (others => (others => '0'));
            soft_input_3_1_2_flip_3 <= (others => (others => '0'));
            soft_input_3_1_3_flip_3 <= (others => (others => '0'));
            soft_input_3_1_4_flip_3 <= (others => (others => '0'));
            soft_input_3_2_1_flip_3 <= (others => (others => '0'));
            soft_input_3_2_2_flip_3 <= (others => (others => '0'));
            soft_input_3_2_3_flip_3 <= (others => (others => '0'));
            soft_input_3_2_4_flip_3 <= (others => (others => '0'));
            soft_input_3_3_1_flip_3 <= (others => (others => '0'));
            soft_input_3_3_2_flip_3 <= (others => (others => '0'));
            soft_input_3_3_3_flip_3 <= (others => (others => '0'));
            soft_input_3_3_4_flip_3 <= (others => (others => '0'));
            soft_input_3_4_1_flip_3 <= (others => (others => '0'));
            soft_input_3_4_2_flip_3 <= (others => (others => '0'));
            soft_input_3_4_3_flip_3 <= (others => (others => '0'));
            soft_input_3_4_4_flip_3 <= (others => (others => '0'));
            soft_input_4_1_1_flip_3 <= (others => (others => '0'));
            soft_input_4_1_2_flip_3 <= (others => (others => '0'));
            soft_input_4_1_3_flip_3 <= (others => (others => '0'));
            soft_input_4_1_4_flip_3 <= (others => (others => '0'));
            soft_input_4_2_1_flip_3 <= (others => (others => '0'));
            soft_input_4_2_2_flip_3 <= (others => (others => '0'));
            soft_input_4_2_3_flip_3 <= (others => (others => '0'));
            soft_input_4_2_4_flip_3 <= (others => (others => '0'));
            soft_input_4_3_1_flip_3 <= (others => (others => '0'));
            soft_input_4_3_2_flip_3 <= (others => (others => '0'));
            soft_input_4_3_3_flip_3 <= (others => (others => '0'));
            soft_input_4_3_4_flip_3 <= (others => (others => '0'));
            soft_input_4_4_1_flip_3 <= (others => (others => '0'));
            soft_input_4_4_2_flip_3 <= (others => (others => '0'));
            soft_input_4_4_3_flip_3 <= (others => (others => '0'));
            soft_input_4_4_4_flip_3 <= (others => (others => '0'));
            weight_info_1_temp1     <= (others => '0');
            weight_info_2_temp_p1   <= (others => '0');
            weight_info_2_temp_p2   <= (others => '0');
            weight_info_2_temp_p3   <= (others => '0');
            weight_info_2_temp_p4   <= (others => '0');
            index_6                 <= (others => (others => '0'));
            index_6_original        <= (others => (others => '0'));
        elsif (rising_edge(clk)) then
            index_6                 <= index_5;
            index_6_original        <= index_5_original;
            weight_info_3           <= (others => (others => '0'));
            soft_output_unflipped_6 <= soft_output_unflipped_5;
            weight_info_1_temp1     <= weight_info_1_temp_p1 xor weight_info_1_temp_p2 xor weight_info_1_temp_p3 xor weight_info_1_temp_p4;
            weight_info_2_temp_p1   <= weight_info_2(1) xor weight_info_2(2) xor weight_info_2(3) xor weight_info_2(4);
            weight_info_2_temp_p2   <= weight_info_2(5) xor weight_info_2(6) xor weight_info_2(7) xor weight_info_2(8);
            weight_info_2_temp_p3   <= weight_info_2(9) xor weight_info_2(10) xor weight_info_2(11) xor weight_info_2(12);
            weight_info_2_temp_p4   <= weight_info_2(13) xor weight_info_2(14) xor weight_info_2(15) xor weight_info_2(16);
            ------------------------------------------------------------------------------------------------------------------------------------
            if indi_3_1_1_pass_2 = "001" then
                soft_input_1_1_1_flip_3                                   <= soft_input_1_1_1_flip_2;
                soft_input_1_1_2_flip_3                                   <= soft_input_1_1_2_flip_2;
                soft_input_1_1_3_flip_3                                   <= soft_input_1_1_3_flip_2;
                soft_input_1_1_4_flip_3                                   <= soft_input_1_1_4_flip_2;
                soft_input_1_1_1_flip_3(to_integer(unsigned(index_5(2)))) <= not soft_input_1_1_1_flip_2(to_integer(unsigned(index_5(2)))) + '1';
                weight_info_3(1)                                          <= soft_input_1_1_1_flip_2(to_integer(unsigned(index_5(2))));
            elsif indi_3_1_1_pass_2 = "010" then
                soft_input_1_1_1_flip_3                                   <= soft_input_1_1_1_flip_2;
                soft_input_1_1_2_flip_3                                   <= soft_input_1_1_2_flip_2;
                soft_input_1_1_3_flip_3                                   <= soft_input_1_1_3_flip_2;
                soft_input_1_1_4_flip_3                                   <= soft_input_1_1_4_flip_2;
                soft_input_1_1_2_flip_3(to_integer(unsigned(index_5(2)))) <= not soft_input_1_1_2_flip_2(to_integer(unsigned(index_5(2)))) + '1';
                weight_info_3(1)                                          <= soft_input_1_1_2_flip_2(to_integer(unsigned(index_5(2))));
            elsif indi_3_1_1_pass_2 = "011" then
                soft_input_1_1_1_flip_3                                   <= soft_input_1_1_1_flip_2;
                soft_input_1_1_2_flip_3                                   <= soft_input_1_1_2_flip_2;
                soft_input_1_1_3_flip_3                                   <= soft_input_1_1_3_flip_2;
                soft_input_1_1_4_flip_3                                   <= soft_input_1_1_4_flip_2;
                soft_input_1_1_3_flip_3(to_integer(unsigned(index_5(2)))) <= not soft_input_1_1_3_flip_2(to_integer(unsigned(index_5(2)))) + '1';
                weight_info_3(1)                                          <= soft_input_1_1_3_flip_2(to_integer(unsigned(index_5(2))));
            elsif indi_3_1_1_pass_2 = "100" then
                soft_input_1_1_1_flip_3                                   <= soft_input_1_1_1_flip_2;
                soft_input_1_1_2_flip_3                                   <= soft_input_1_1_2_flip_2;
                soft_input_1_1_3_flip_3                                   <= soft_input_1_1_3_flip_2;
                soft_input_1_1_4_flip_3                                   <= soft_input_1_1_4_flip_2;
                soft_input_1_1_4_flip_3(to_integer(unsigned(index_5(2)))) <= not soft_input_1_1_4_flip_2(to_integer(unsigned(index_5(2)))) + '1';
                weight_info_3(1)                                          <= soft_input_1_1_4_flip_2(to_integer(unsigned(index_5(2))));
            else
                soft_input_1_1_1_flip_3 <= soft_input_1_1_1_flip_2;
                soft_input_1_1_2_flip_3 <= soft_input_1_1_2_flip_2;
                soft_input_1_1_3_flip_3 <= soft_input_1_1_3_flip_2;
                soft_input_1_1_4_flip_3 <= soft_input_1_1_4_flip_2;
            end if;
            ------------------------------------------------------------------------------------------------------------------------------------
            if indi_3_1_2_pass_2 = "001" then
                soft_input_1_2_1_flip_3                                   <= soft_input_1_2_1_flip_2;
                soft_input_1_2_2_flip_3                                   <= soft_input_1_2_2_flip_2;
                soft_input_1_2_3_flip_3                                   <= soft_input_1_2_3_flip_2;
                soft_input_1_2_4_flip_3                                   <= soft_input_1_2_4_flip_2;
                soft_input_1_2_1_flip_3(to_integer(unsigned(index_5(2)))) <= not soft_input_1_2_1_flip_2(to_integer(unsigned(index_5(2)))) + '1';
                weight_info_3(2)                                          <= soft_input_1_2_1_flip_2(to_integer(unsigned(index_5(2))));
            elsif indi_3_1_2_pass_2 = "010" then
                soft_input_1_2_1_flip_3                                   <= soft_input_1_2_1_flip_2;
                soft_input_1_2_2_flip_3                                   <= soft_input_1_2_2_flip_2;
                soft_input_1_2_3_flip_3                                   <= soft_input_1_2_3_flip_2;
                soft_input_1_2_4_flip_3                                   <= soft_input_1_2_4_flip_2;
                soft_input_1_2_2_flip_3(to_integer(unsigned(index_5(2)))) <= not soft_input_1_2_2_flip_2(to_integer(unsigned(index_5(2)))) + '1';
                weight_info_3(2)                                          <= soft_input_1_2_2_flip_2(to_integer(unsigned(index_5(2))));
            elsif indi_3_1_2_pass_2 = "011" then
                soft_input_1_2_1_flip_3                                   <= soft_input_1_2_1_flip_2;
                soft_input_1_2_2_flip_3                                   <= soft_input_1_2_2_flip_2;
                soft_input_1_2_3_flip_3                                   <= soft_input_1_2_3_flip_2;
                soft_input_1_2_4_flip_3                                   <= soft_input_1_2_4_flip_2;
                soft_input_1_2_3_flip_3(to_integer(unsigned(index_5(2)))) <= not soft_input_1_2_3_flip_2(to_integer(unsigned(index_5(2)))) + '1';
                weight_info_3(2)                                          <= soft_input_1_2_3_flip_2(to_integer(unsigned(index_5(2))));
            elsif indi_3_1_2_pass_2 = "100" then
                soft_input_1_2_1_flip_3                                   <= soft_input_1_2_1_flip_2;
                soft_input_1_2_2_flip_3                                   <= soft_input_1_2_2_flip_2;
                soft_input_1_2_3_flip_3                                   <= soft_input_1_2_3_flip_2;
                soft_input_1_2_4_flip_3                                   <= soft_input_1_2_4_flip_2;
                soft_input_1_2_4_flip_3(to_integer(unsigned(index_5(2)))) <= not soft_input_1_2_4_flip_2(to_integer(unsigned(index_5(2)))) + '1';
                weight_info_3(2)                                          <= soft_input_1_2_4_flip_2(to_integer(unsigned(index_5(2))));
            else
                soft_input_1_2_1_flip_3 <= soft_input_1_2_1_flip_2;
                soft_input_1_2_2_flip_3 <= soft_input_1_2_2_flip_2;
                soft_input_1_2_3_flip_3 <= soft_input_1_2_3_flip_2;
                soft_input_1_2_4_flip_3 <= soft_input_1_2_4_flip_2;
            end if;
            ------------------------------------------------------------------------------------------------------------------------------------
            if indi_3_1_3_pass_2 = "001" then
                soft_input_1_3_1_flip_3                                   <= soft_input_1_3_1_flip_2;
                soft_input_1_3_2_flip_3                                   <= soft_input_1_3_2_flip_2;
                soft_input_1_3_3_flip_3                                   <= soft_input_1_3_3_flip_2;
                soft_input_1_3_4_flip_3                                   <= soft_input_1_3_4_flip_2;
                soft_input_1_3_1_flip_3(to_integer(unsigned(index_5(2)))) <= not soft_input_1_3_1_flip_2(to_integer(unsigned(index_5(2)))) + '1';
                weight_info_3(3)                                          <= soft_input_1_3_1_flip_2(to_integer(unsigned(index_5(2))));
            elsif indi_3_1_3_pass_2 = "010" then
                soft_input_1_3_1_flip_3                                   <= soft_input_1_3_1_flip_2;
                soft_input_1_3_2_flip_3                                   <= soft_input_1_3_2_flip_2;
                soft_input_1_3_3_flip_3                                   <= soft_input_1_3_3_flip_2;
                soft_input_1_3_4_flip_3                                   <= soft_input_1_3_4_flip_2;
                soft_input_1_3_2_flip_3(to_integer(unsigned(index_5(2)))) <= not soft_input_1_3_2_flip_2(to_integer(unsigned(index_5(2)))) + '1';
                weight_info_3(3)                                          <= soft_input_1_3_2_flip_2(to_integer(unsigned(index_5(2))));
            elsif indi_3_1_3_pass_2 = "011" then
                soft_input_1_3_1_flip_3                                   <= soft_input_1_3_1_flip_2;
                soft_input_1_3_2_flip_3                                   <= soft_input_1_3_2_flip_2;
                soft_input_1_3_3_flip_3                                   <= soft_input_1_3_3_flip_2;
                soft_input_1_3_4_flip_3                                   <= soft_input_1_3_4_flip_2;
                soft_input_1_3_3_flip_3(to_integer(unsigned(index_5(2)))) <= not soft_input_1_3_3_flip_2(to_integer(unsigned(index_5(2)))) + '1';
                weight_info_3(3)                                          <= soft_input_1_3_3_flip_2(to_integer(unsigned(index_5(2))));
            elsif indi_3_1_3_pass_2 = "100" then
                soft_input_1_3_1_flip_3                                   <= soft_input_1_3_1_flip_2;
                soft_input_1_3_2_flip_3                                   <= soft_input_1_3_2_flip_2;
                soft_input_1_3_3_flip_3                                   <= soft_input_1_3_3_flip_2;
                soft_input_1_3_4_flip_3                                   <= soft_input_1_3_4_flip_2;
                soft_input_1_3_4_flip_3(to_integer(unsigned(index_5(2)))) <= not soft_input_1_3_4_flip_2(to_integer(unsigned(index_5(2)))) + '1';
                weight_info_3(3)                                          <= soft_input_1_3_4_flip_2(to_integer(unsigned(index_5(2))));
            else
                soft_input_1_3_1_flip_3 <= soft_input_1_3_1_flip_2;
                soft_input_1_3_2_flip_3 <= soft_input_1_3_2_flip_2;
                soft_input_1_3_3_flip_3 <= soft_input_1_3_3_flip_2;
                soft_input_1_3_4_flip_3 <= soft_input_1_3_4_flip_2;
            end if;
            ------------------------------------------------------------------------------------------------------------------------------------
            if indi_3_1_4_pass_2 = "001" then
                soft_input_1_4_1_flip_3                                   <= soft_input_1_4_1_flip_2;
                soft_input_1_4_2_flip_3                                   <= soft_input_1_4_2_flip_2;
                soft_input_1_4_3_flip_3                                   <= soft_input_1_4_3_flip_2;
                soft_input_1_4_4_flip_3                                   <= soft_input_1_4_4_flip_2;
                soft_input_1_4_1_flip_3(to_integer(unsigned(index_5(2)))) <= not soft_input_1_4_1_flip_2(to_integer(unsigned(index_5(2)))) + '1';
                weight_info_3(4)                                          <= soft_input_1_4_1_flip_2(to_integer(unsigned(index_5(2))));
            elsif indi_3_1_4_pass_2 = "010" then
                soft_input_1_4_1_flip_3                                   <= soft_input_1_4_1_flip_2;
                soft_input_1_4_2_flip_3                                   <= soft_input_1_4_2_flip_2;
                soft_input_1_4_3_flip_3                                   <= soft_input_1_4_3_flip_2;
                soft_input_1_4_4_flip_3                                   <= soft_input_1_4_4_flip_2;
                soft_input_1_4_2_flip_3(to_integer(unsigned(index_5(2)))) <= not soft_input_1_4_2_flip_2(to_integer(unsigned(index_5(2)))) + '1';
                weight_info_3(4)                                          <= soft_input_1_4_2_flip_2(to_integer(unsigned(index_5(2))));
            elsif indi_3_1_4_pass_2 = "011" then
                soft_input_1_4_1_flip_3                                   <= soft_input_1_4_1_flip_2;
                soft_input_1_4_2_flip_3                                   <= soft_input_1_4_2_flip_2;
                soft_input_1_4_3_flip_3                                   <= soft_input_1_4_3_flip_2;
                soft_input_1_4_4_flip_3                                   <= soft_input_1_4_4_flip_2;
                soft_input_1_4_3_flip_3(to_integer(unsigned(index_5(2)))) <= not soft_input_1_4_3_flip_2(to_integer(unsigned(index_5(2)))) + '1';
                weight_info_3(4)                                          <= soft_input_1_4_3_flip_2(to_integer(unsigned(index_5(2))));
            elsif indi_3_1_4_pass_2 = "100" then
                soft_input_1_4_1_flip_3                                   <= soft_input_1_4_1_flip_2;
                soft_input_1_4_2_flip_3                                   <= soft_input_1_4_2_flip_2;
                soft_input_1_4_3_flip_3                                   <= soft_input_1_4_3_flip_2;
                soft_input_1_4_4_flip_3                                   <= soft_input_1_4_4_flip_2;
                soft_input_1_4_4_flip_3(to_integer(unsigned(index_5(2)))) <= not soft_input_1_4_4_flip_2(to_integer(unsigned(index_5(2)))) + '1';
                weight_info_3(4)                                          <= soft_input_1_4_4_flip_2(to_integer(unsigned(index_5(2))));
            else
                soft_input_1_4_1_flip_3 <= soft_input_1_4_1_flip_2;
                soft_input_1_4_2_flip_3 <= soft_input_1_4_2_flip_2;
                soft_input_1_4_3_flip_3 <= soft_input_1_4_3_flip_2;
                soft_input_1_4_4_flip_3 <= soft_input_1_4_4_flip_2;
            end if;
            ------------------------------------------------------------------------------------------------------------------------------------
            if indi_3_2_1_pass_2 = "001" then
                soft_input_2_1_1_flip_3                                   <= soft_input_2_1_1_flip_2;
                soft_input_2_1_2_flip_3                                   <= soft_input_2_1_2_flip_2;
                soft_input_2_1_3_flip_3                                   <= soft_input_2_1_3_flip_2;
                soft_input_2_1_4_flip_3                                   <= soft_input_2_1_4_flip_2;
                soft_input_2_1_1_flip_3(to_integer(unsigned(index_5(2)))) <= not soft_input_2_1_1_flip_2(to_integer(unsigned(index_5(2)))) + '1';
                weight_info_3(5)                                          <= soft_input_2_1_1_flip_2(to_integer(unsigned(index_5(2))));
            elsif indi_3_2_1_pass_2 = "010" then
                soft_input_2_1_1_flip_3                                   <= soft_input_2_1_1_flip_2;
                soft_input_2_1_2_flip_3                                   <= soft_input_2_1_2_flip_2;
                soft_input_2_1_3_flip_3                                   <= soft_input_2_1_3_flip_2;
                soft_input_2_1_4_flip_3                                   <= soft_input_2_1_4_flip_2;
                soft_input_2_1_2_flip_3(to_integer(unsigned(index_5(2)))) <= not soft_input_2_1_2_flip_2(to_integer(unsigned(index_5(2)))) + '1';
                weight_info_3(5)                                          <= soft_input_2_1_2_flip_2(to_integer(unsigned(index_5(2))));
            elsif indi_3_2_1_pass_2 = "011" then
                soft_input_2_1_1_flip_3                                   <= soft_input_2_1_1_flip_2;
                soft_input_2_1_2_flip_3                                   <= soft_input_2_1_2_flip_2;
                soft_input_2_1_3_flip_3                                   <= soft_input_2_1_3_flip_2;
                soft_input_2_1_4_flip_3                                   <= soft_input_2_1_4_flip_2;
                soft_input_2_1_3_flip_3(to_integer(unsigned(index_5(2)))) <= not soft_input_2_1_3_flip_2(to_integer(unsigned(index_5(2)))) + '1';
                weight_info_3(5)                                          <= soft_input_2_1_3_flip_2(to_integer(unsigned(index_5(2))));
            elsif indi_3_2_1_pass_2 = "100" then
                soft_input_2_1_1_flip_3                                   <= soft_input_2_1_1_flip_2;
                soft_input_2_1_2_flip_3                                   <= soft_input_2_1_2_flip_2;
                soft_input_2_1_3_flip_3                                   <= soft_input_2_1_3_flip_2;
                soft_input_2_1_4_flip_3                                   <= soft_input_2_1_4_flip_2;
                soft_input_2_1_4_flip_3(to_integer(unsigned(index_5(2)))) <= not soft_input_2_1_4_flip_2(to_integer(unsigned(index_5(2)))) + '1';
                weight_info_3(5)                                          <= soft_input_2_1_4_flip_2(to_integer(unsigned(index_5(2))));
            else
                soft_input_2_1_1_flip_3 <= soft_input_2_1_1_flip_2;
                soft_input_2_1_2_flip_3 <= soft_input_2_1_2_flip_2;
                soft_input_2_1_3_flip_3 <= soft_input_2_1_3_flip_2;
                soft_input_2_1_4_flip_3 <= soft_input_2_1_4_flip_2;
            end if;
            ------------------------------------------------------------------------------------------------------------------------------------
            if indi_3_2_2_pass_2 = "001" then
                soft_input_2_2_1_flip_3                                   <= soft_input_2_2_1_flip_2;
                soft_input_2_2_2_flip_3                                   <= soft_input_2_2_2_flip_2;
                soft_input_2_2_3_flip_3                                   <= soft_input_2_2_3_flip_2;
                soft_input_2_2_4_flip_3                                   <= soft_input_2_2_4_flip_2;
                soft_input_2_2_1_flip_3(to_integer(unsigned(index_5(2)))) <= not soft_input_2_2_1_flip_2(to_integer(unsigned(index_5(2)))) + '1';
                weight_info_3(6)                                          <= soft_input_2_2_1_flip_2(to_integer(unsigned(index_5(2))));
            elsif indi_3_2_2_pass_2 = "010" then
                soft_input_2_2_1_flip_3                                   <= soft_input_2_2_1_flip_2;
                soft_input_2_2_2_flip_3                                   <= soft_input_2_2_2_flip_2;
                soft_input_2_2_3_flip_3                                   <= soft_input_2_2_3_flip_2;
                soft_input_2_2_4_flip_3                                   <= soft_input_2_2_4_flip_2;
                soft_input_2_2_2_flip_3(to_integer(unsigned(index_5(2)))) <= not soft_input_2_2_2_flip_2(to_integer(unsigned(index_5(2)))) + '1';
                weight_info_3(6)                                          <= soft_input_2_2_2_flip_2(to_integer(unsigned(index_5(2))));
            elsif indi_3_2_2_pass_2 = "011" then
                soft_input_2_2_1_flip_3                                   <= soft_input_2_2_1_flip_2;
                soft_input_2_2_2_flip_3                                   <= soft_input_2_2_2_flip_2;
                soft_input_2_2_3_flip_3                                   <= soft_input_2_2_3_flip_2;
                soft_input_2_2_4_flip_3                                   <= soft_input_2_2_4_flip_2;
                soft_input_2_2_3_flip_3(to_integer(unsigned(index_5(2)))) <= not soft_input_2_2_3_flip_2(to_integer(unsigned(index_5(2)))) + '1';
                weight_info_3(6)                                          <= soft_input_2_2_3_flip_2(to_integer(unsigned(index_5(2))));
            elsif indi_3_2_2_pass_2 = "100" then
                soft_input_2_2_1_flip_3                                   <= soft_input_2_2_1_flip_2;
                soft_input_2_2_2_flip_3                                   <= soft_input_2_2_2_flip_2;
                soft_input_2_2_3_flip_3                                   <= soft_input_2_2_3_flip_2;
                soft_input_2_2_4_flip_3                                   <= soft_input_2_2_4_flip_2;
                soft_input_2_2_4_flip_3(to_integer(unsigned(index_5(2)))) <= not soft_input_2_2_4_flip_2(to_integer(unsigned(index_5(2)))) + '1';
                weight_info_3(6)                                          <= soft_input_2_2_4_flip_2(to_integer(unsigned(index_5(2))));
            else
                soft_input_2_2_1_flip_3 <= soft_input_2_2_1_flip_2;
                soft_input_2_2_2_flip_3 <= soft_input_2_2_2_flip_2;
                soft_input_2_2_3_flip_3 <= soft_input_2_2_3_flip_2;
                soft_input_2_2_4_flip_3 <= soft_input_2_2_4_flip_2;
            end if;
            ------------------------------------------------------------------------------------------------------------------------------------
            if indi_3_2_3_pass_2 = "001" then
                soft_input_2_3_1_flip_3                                   <= soft_input_2_3_1_flip_2;
                soft_input_2_3_2_flip_3                                   <= soft_input_2_3_2_flip_2;
                soft_input_2_3_3_flip_3                                   <= soft_input_2_3_3_flip_2;
                soft_input_2_3_4_flip_3                                   <= soft_input_2_3_4_flip_2;
                soft_input_2_3_1_flip_3(to_integer(unsigned(index_5(2)))) <= not soft_input_2_3_1_flip_2(to_integer(unsigned(index_5(2)))) + '1';
                weight_info_3(7)                                          <= soft_input_2_3_1_flip_2(to_integer(unsigned(index_5(2))));
            elsif indi_3_2_3_pass_2 = "010" then
                soft_input_2_3_1_flip_3                                   <= soft_input_2_3_1_flip_2;
                soft_input_2_3_2_flip_3                                   <= soft_input_2_3_2_flip_2;
                soft_input_2_3_3_flip_3                                   <= soft_input_2_3_3_flip_2;
                soft_input_2_3_4_flip_3                                   <= soft_input_2_3_4_flip_2;
                soft_input_2_3_2_flip_3(to_integer(unsigned(index_5(2)))) <= not soft_input_2_3_2_flip_2(to_integer(unsigned(index_5(2)))) + '1';
                weight_info_3(7)                                          <= soft_input_2_3_2_flip_2(to_integer(unsigned(index_5(2))));
            elsif indi_3_2_3_pass_2 = "011" then
                soft_input_2_3_1_flip_3                                   <= soft_input_2_3_1_flip_2;
                soft_input_2_3_2_flip_3                                   <= soft_input_2_3_2_flip_2;
                soft_input_2_3_3_flip_3                                   <= soft_input_2_3_3_flip_2;
                soft_input_2_3_4_flip_3                                   <= soft_input_2_3_4_flip_2;
                soft_input_2_3_3_flip_3(to_integer(unsigned(index_5(2)))) <= not soft_input_2_3_3_flip_2(to_integer(unsigned(index_5(2)))) + '1';
                weight_info_3(7)                                          <= soft_input_2_3_3_flip_2(to_integer(unsigned(index_5(2))));
            elsif indi_3_2_3_pass_2 = "100" then
                soft_input_2_3_1_flip_3                                   <= soft_input_2_3_1_flip_2;
                soft_input_2_3_2_flip_3                                   <= soft_input_2_3_2_flip_2;
                soft_input_2_3_3_flip_3                                   <= soft_input_2_3_3_flip_2;
                soft_input_2_3_4_flip_3                                   <= soft_input_2_3_4_flip_2;
                soft_input_2_3_4_flip_3(to_integer(unsigned(index_5(2)))) <= not soft_input_2_3_4_flip_2(to_integer(unsigned(index_5(2)))) + '1';
                weight_info_3(7)                                          <= soft_input_2_3_4_flip_2(to_integer(unsigned(index_5(2))));
            else
                soft_input_2_3_1_flip_3 <= soft_input_2_3_1_flip_2;
                soft_input_2_3_2_flip_3 <= soft_input_2_3_2_flip_2;
                soft_input_2_3_3_flip_3 <= soft_input_2_3_3_flip_2;
                soft_input_2_3_4_flip_3 <= soft_input_2_3_4_flip_2;
            end if;
            ------------------------------------------------------------------------------------------------------------------------------------
            if indi_3_2_4_pass_2 = "001" then
                soft_input_2_4_1_flip_3                                   <= soft_input_2_4_1_flip_2;
                soft_input_2_4_2_flip_3                                   <= soft_input_2_4_2_flip_2;
                soft_input_2_4_3_flip_3                                   <= soft_input_2_4_3_flip_2;
                soft_input_2_4_4_flip_3                                   <= soft_input_2_4_4_flip_2;
                soft_input_2_4_1_flip_3(to_integer(unsigned(index_5(2)))) <= not soft_input_2_4_1_flip_2(to_integer(unsigned(index_5(2)))) + '1';
                weight_info_3(8)                                          <= soft_input_2_4_1_flip_2(to_integer(unsigned(index_5(2))));
            elsif indi_3_2_4_pass_2 = "010" then
                soft_input_2_4_1_flip_3                                   <= soft_input_2_4_1_flip_2;
                soft_input_2_4_2_flip_3                                   <= soft_input_2_4_2_flip_2;
                soft_input_2_4_3_flip_3                                   <= soft_input_2_4_3_flip_2;
                soft_input_2_4_4_flip_3                                   <= soft_input_2_4_4_flip_2;
                soft_input_2_4_2_flip_3(to_integer(unsigned(index_5(2)))) <= not soft_input_2_4_2_flip_2(to_integer(unsigned(index_5(2)))) + '1';
                weight_info_3(8)                                          <= soft_input_2_4_2_flip_2(to_integer(unsigned(index_5(2))));
            elsif indi_3_2_4_pass_2 = "011" then
                soft_input_2_4_1_flip_3                                   <= soft_input_2_4_1_flip_2;
                soft_input_2_4_2_flip_3                                   <= soft_input_2_4_2_flip_2;
                soft_input_2_4_3_flip_3                                   <= soft_input_2_4_3_flip_2;
                soft_input_2_4_4_flip_3                                   <= soft_input_2_4_4_flip_2;
                soft_input_2_4_3_flip_3(to_integer(unsigned(index_5(2)))) <= not soft_input_2_4_3_flip_2(to_integer(unsigned(index_5(2)))) + '1';
                weight_info_3(8)                                          <= soft_input_2_4_3_flip_2(to_integer(unsigned(index_5(2))));
            elsif indi_3_2_4_pass_2 = "100" then
                soft_input_2_4_1_flip_3                                   <= soft_input_2_4_1_flip_2;
                soft_input_2_4_2_flip_3                                   <= soft_input_2_4_2_flip_2;
                soft_input_2_4_3_flip_3                                   <= soft_input_2_4_3_flip_2;
                soft_input_2_4_4_flip_3                                   <= soft_input_2_4_4_flip_2;
                soft_input_2_4_4_flip_3(to_integer(unsigned(index_5(2)))) <= not soft_input_2_4_4_flip_2(to_integer(unsigned(index_5(2)))) + '1';
                weight_info_3(8)                                          <= soft_input_2_4_4_flip_2(to_integer(unsigned(index_5(2))));
            else
                soft_input_2_4_1_flip_3 <= soft_input_2_4_1_flip_2;
                soft_input_2_4_2_flip_3 <= soft_input_2_4_2_flip_2;
                soft_input_2_4_3_flip_3 <= soft_input_2_4_3_flip_2;
                soft_input_2_4_4_flip_3 <= soft_input_2_4_4_flip_2;
            end if;
            ------------------------------------------------------------------------------------------------------------------------------------
            if indi_3_3_1_pass_2 = "001" then
                soft_input_3_1_1_flip_3                                   <= soft_input_3_1_1_flip_2;
                soft_input_3_1_2_flip_3                                   <= soft_input_3_1_2_flip_2;
                soft_input_3_1_3_flip_3                                   <= soft_input_3_1_3_flip_2;
                soft_input_3_1_4_flip_3                                   <= soft_input_3_1_4_flip_2;
                soft_input_3_1_1_flip_3(to_integer(unsigned(index_5(2)))) <= not soft_input_3_1_1_flip_2(to_integer(unsigned(index_5(2)))) + '1';
                weight_info_3(9)                                          <= soft_input_3_1_1_flip_2(to_integer(unsigned(index_5(2))));
            elsif indi_3_3_1_pass_2 = "010" then
                soft_input_3_1_1_flip_3                                   <= soft_input_3_1_1_flip_2;
                soft_input_3_1_2_flip_3                                   <= soft_input_3_1_2_flip_2;
                soft_input_3_1_3_flip_3                                   <= soft_input_3_1_3_flip_2;
                soft_input_3_1_4_flip_3                                   <= soft_input_3_1_4_flip_2;
                soft_input_3_1_2_flip_3(to_integer(unsigned(index_5(2)))) <= not soft_input_3_1_2_flip_2(to_integer(unsigned(index_5(2)))) + '1';
                weight_info_3(9)                                          <= soft_input_3_1_2_flip_2(to_integer(unsigned(index_5(2))));
            elsif indi_3_3_1_pass_2 = "011" then
                soft_input_3_1_1_flip_3                                   <= soft_input_3_1_1_flip_2;
                soft_input_3_1_2_flip_3                                   <= soft_input_3_1_2_flip_2;
                soft_input_3_1_3_flip_3                                   <= soft_input_3_1_3_flip_2;
                soft_input_3_1_4_flip_3                                   <= soft_input_3_1_4_flip_2;
                soft_input_3_1_3_flip_3(to_integer(unsigned(index_5(2)))) <= not soft_input_3_1_3_flip_2(to_integer(unsigned(index_5(2)))) + '1';
                weight_info_3(9)                                          <= soft_input_3_1_3_flip_2(to_integer(unsigned(index_5(2))));
            elsif indi_3_3_1_pass_2 = "100" then
                soft_input_3_1_1_flip_3                                   <= soft_input_3_1_1_flip_2;
                soft_input_3_1_2_flip_3                                   <= soft_input_3_1_2_flip_2;
                soft_input_3_1_3_flip_3                                   <= soft_input_3_1_3_flip_2;
                soft_input_3_1_4_flip_3                                   <= soft_input_3_1_4_flip_2;
                soft_input_3_1_4_flip_3(to_integer(unsigned(index_5(2)))) <= not soft_input_3_1_4_flip_2(to_integer(unsigned(index_5(2)))) + '1';
                weight_info_3(9)                                          <= soft_input_3_1_4_flip_2(to_integer(unsigned(index_5(2))));
            else
                soft_input_3_1_1_flip_3 <= soft_input_3_1_1_flip_2;
                soft_input_3_1_2_flip_3 <= soft_input_3_1_2_flip_2;
                soft_input_3_1_3_flip_3 <= soft_input_3_1_3_flip_2;
                soft_input_3_1_4_flip_3 <= soft_input_3_1_4_flip_2;
            end if;
            ------------------------------------------------------------------------------------------------------------------------------------
            if indi_3_3_2_pass_2 = "001" then
                soft_input_3_2_1_flip_3                                   <= soft_input_3_2_1_flip_2;
                soft_input_3_2_2_flip_3                                   <= soft_input_3_2_2_flip_2;
                soft_input_3_2_3_flip_3                                   <= soft_input_3_2_3_flip_2;
                soft_input_3_2_4_flip_3                                   <= soft_input_3_2_4_flip_2;
                soft_input_3_2_1_flip_3(to_integer(unsigned(index_5(2)))) <= not soft_input_3_2_1_flip_2(to_integer(unsigned(index_5(2)))) + '1';
                weight_info_3(10)                                         <= soft_input_3_2_1_flip_2(to_integer(unsigned(index_5(2))));
            elsif indi_3_3_2_pass_2 = "010" then
                soft_input_3_2_1_flip_3                                   <= soft_input_3_2_1_flip_2;
                soft_input_3_2_2_flip_3                                   <= soft_input_3_2_2_flip_2;
                soft_input_3_2_3_flip_3                                   <= soft_input_3_2_3_flip_2;
                soft_input_3_2_4_flip_3                                   <= soft_input_3_2_4_flip_2;
                soft_input_3_2_2_flip_3(to_integer(unsigned(index_5(2)))) <= not soft_input_3_2_2_flip_2(to_integer(unsigned(index_5(2)))) + '1';
                weight_info_3(10)                                         <= soft_input_3_2_2_flip_2(to_integer(unsigned(index_5(2))));
            elsif indi_3_3_2_pass_2 = "011" then
                soft_input_3_2_1_flip_3                                   <= soft_input_3_2_1_flip_2;
                soft_input_3_2_2_flip_3                                   <= soft_input_3_2_2_flip_2;
                soft_input_3_2_3_flip_3                                   <= soft_input_3_2_3_flip_2;
                soft_input_3_2_4_flip_3                                   <= soft_input_3_2_4_flip_2;
                soft_input_3_2_3_flip_3(to_integer(unsigned(index_5(2)))) <= not soft_input_3_2_3_flip_2(to_integer(unsigned(index_5(2)))) + '1';
                weight_info_3(10)                                         <= soft_input_3_2_3_flip_2(to_integer(unsigned(index_5(2))));
            elsif indi_3_3_2_pass_2 = "100" then
                soft_input_3_2_1_flip_3                                   <= soft_input_3_2_1_flip_2;
                soft_input_3_2_2_flip_3                                   <= soft_input_3_2_2_flip_2;
                soft_input_3_2_3_flip_3                                   <= soft_input_3_2_3_flip_2;
                soft_input_3_2_4_flip_3                                   <= soft_input_3_2_4_flip_2;
                soft_input_3_2_4_flip_3(to_integer(unsigned(index_5(2)))) <= not soft_input_3_2_4_flip_2(to_integer(unsigned(index_5(2)))) + '1';
                weight_info_3(10)                                         <= soft_input_3_2_4_flip_2(to_integer(unsigned(index_5(2))));
            else
                soft_input_3_2_1_flip_3 <= soft_input_3_2_1_flip_2;
                soft_input_3_2_2_flip_3 <= soft_input_3_2_2_flip_2;
                soft_input_3_2_3_flip_3 <= soft_input_3_2_3_flip_2;
                soft_input_3_2_4_flip_3 <= soft_input_3_2_4_flip_2;
            end if;
            ------------------------------------------------------------------------------------------------------------------------------------
            if indi_3_3_3_pass_2 = "001" then
                soft_input_3_3_1_flip_3                                   <= soft_input_3_3_1_flip_2;
                soft_input_3_3_2_flip_3                                   <= soft_input_3_3_2_flip_2;
                soft_input_3_3_3_flip_3                                   <= soft_input_3_3_3_flip_2;
                soft_input_3_3_4_flip_3                                   <= soft_input_3_3_4_flip_2;
                soft_input_3_3_1_flip_3(to_integer(unsigned(index_5(2)))) <= not soft_input_3_3_1_flip_2(to_integer(unsigned(index_5(2)))) + '1';
                weight_info_3(11)                                         <= soft_input_3_3_1_flip_2(to_integer(unsigned(index_5(2))));
            elsif indi_3_3_3_pass_2 = "010" then
                soft_input_3_3_1_flip_3                                   <= soft_input_3_3_1_flip_2;
                soft_input_3_3_2_flip_3                                   <= soft_input_3_3_2_flip_2;
                soft_input_3_3_3_flip_3                                   <= soft_input_3_3_3_flip_2;
                soft_input_3_3_4_flip_3                                   <= soft_input_3_3_4_flip_2;
                soft_input_3_3_2_flip_3(to_integer(unsigned(index_5(2)))) <= not soft_input_3_3_2_flip_2(to_integer(unsigned(index_5(2)))) + '1';
                weight_info_3(11)                                         <= soft_input_3_3_2_flip_2(to_integer(unsigned(index_5(2))));
            elsif indi_3_3_3_pass_2 = "011" then
                soft_input_3_3_1_flip_3                                   <= soft_input_3_3_1_flip_2;
                soft_input_3_3_2_flip_3                                   <= soft_input_3_3_2_flip_2;
                soft_input_3_3_3_flip_3                                   <= soft_input_3_3_3_flip_2;
                soft_input_3_3_4_flip_3                                   <= soft_input_3_3_4_flip_2;
                soft_input_3_3_3_flip_3(to_integer(unsigned(index_5(2)))) <= not soft_input_3_3_3_flip_2(to_integer(unsigned(index_5(2)))) + '1';
                weight_info_3(11)                                         <= soft_input_3_3_3_flip_2(to_integer(unsigned(index_5(2))));
            elsif indi_3_3_3_pass_2 = "100" then
                soft_input_3_3_1_flip_3                                   <= soft_input_3_3_1_flip_2;
                soft_input_3_3_2_flip_3                                   <= soft_input_3_3_2_flip_2;
                soft_input_3_3_3_flip_3                                   <= soft_input_3_3_3_flip_2;
                soft_input_3_3_4_flip_3                                   <= soft_input_3_3_4_flip_2;
                soft_input_3_3_4_flip_3(to_integer(unsigned(index_5(2)))) <= not soft_input_3_3_4_flip_2(to_integer(unsigned(index_5(2)))) + '1';
                weight_info_3(11)                                         <= soft_input_3_3_4_flip_2(to_integer(unsigned(index_5(2))));
            else
                soft_input_3_3_1_flip_3 <= soft_input_3_3_1_flip_2;
                soft_input_3_3_2_flip_3 <= soft_input_3_3_2_flip_2;
                soft_input_3_3_3_flip_3 <= soft_input_3_3_3_flip_2;
                soft_input_3_3_4_flip_3 <= soft_input_3_3_4_flip_2;
            end if;
            ------------------------------------------------------------------------------------------------------------------------------------
            if indi_3_3_4_pass_2 = "001" then
                soft_input_3_4_1_flip_3                                   <= soft_input_3_4_1_flip_2;
                soft_input_3_4_2_flip_3                                   <= soft_input_3_4_2_flip_2;
                soft_input_3_4_3_flip_3                                   <= soft_input_3_4_3_flip_2;
                soft_input_3_4_4_flip_3                                   <= soft_input_3_4_4_flip_2;
                soft_input_3_4_1_flip_3(to_integer(unsigned(index_5(2)))) <= not soft_input_3_4_1_flip_2(to_integer(unsigned(index_5(2)))) + '1';
                weight_info_3(12)                                         <= soft_input_3_4_1_flip_2(to_integer(unsigned(index_5(2))));
            elsif indi_3_3_4_pass_2 = "010" then
                soft_input_3_4_1_flip_3                                   <= soft_input_3_4_1_flip_2;
                soft_input_3_4_2_flip_3                                   <= soft_input_3_4_2_flip_2;
                soft_input_3_4_3_flip_3                                   <= soft_input_3_4_3_flip_2;
                soft_input_3_4_4_flip_3                                   <= soft_input_3_4_4_flip_2;
                soft_input_3_4_2_flip_3(to_integer(unsigned(index_5(2)))) <= not soft_input_3_4_2_flip_2(to_integer(unsigned(index_5(2)))) + '1';
                weight_info_3(12)                                         <= soft_input_3_4_2_flip_2(to_integer(unsigned(index_5(2))));
            elsif indi_3_3_4_pass_2 = "011" then
                soft_input_3_4_1_flip_3                                   <= soft_input_3_4_1_flip_2;
                soft_input_3_4_2_flip_3                                   <= soft_input_3_4_2_flip_2;
                soft_input_3_4_3_flip_3                                   <= soft_input_3_4_3_flip_2;
                soft_input_3_4_4_flip_3                                   <= soft_input_3_4_4_flip_2;
                soft_input_3_4_3_flip_3(to_integer(unsigned(index_5(2)))) <= not soft_input_3_4_3_flip_2(to_integer(unsigned(index_5(2)))) + '1';
                weight_info_3(12)                                         <= soft_input_3_4_3_flip_2(to_integer(unsigned(index_5(2))));
            elsif indi_3_3_4_pass_2 = "100" then
                soft_input_3_4_1_flip_3                                   <= soft_input_3_4_1_flip_2;
                soft_input_3_4_2_flip_3                                   <= soft_input_3_4_2_flip_2;
                soft_input_3_4_3_flip_3                                   <= soft_input_3_4_3_flip_2;
                soft_input_3_4_4_flip_3                                   <= soft_input_3_4_4_flip_2;
                soft_input_3_4_4_flip_3(to_integer(unsigned(index_5(2)))) <= not soft_input_3_4_4_flip_2(to_integer(unsigned(index_5(2)))) + '1';
                weight_info_3(12)                                         <= soft_input_3_4_4_flip_2(to_integer(unsigned(index_5(2))));
            else
                soft_input_3_4_1_flip_3 <= soft_input_3_4_1_flip_2;
                soft_input_3_4_2_flip_3 <= soft_input_3_4_2_flip_2;
                soft_input_3_4_3_flip_3 <= soft_input_3_4_3_flip_2;
                soft_input_3_4_4_flip_3 <= soft_input_3_4_4_flip_2;
            end if;
            ------------------------------------------------------------------------------------------------------------------------------------
            if indi_3_4_1_pass_2 = "001" then
                soft_input_4_1_1_flip_3                                   <= soft_input_4_1_1_flip_2;
                soft_input_4_1_2_flip_3                                   <= soft_input_4_1_2_flip_2;
                soft_input_4_1_3_flip_3                                   <= soft_input_4_1_3_flip_2;
                soft_input_4_1_4_flip_3                                   <= soft_input_4_1_4_flip_2;
                soft_input_4_1_1_flip_3(to_integer(unsigned(index_5(2)))) <= not soft_input_4_1_1_flip_2(to_integer(unsigned(index_5(2)))) + '1';
                weight_info_3(13)                                         <= soft_input_4_1_1_flip_2(to_integer(unsigned(index_5(2))));
            elsif indi_3_4_1_pass_2 = "010" then
                soft_input_4_1_1_flip_3                                   <= soft_input_4_1_1_flip_2;
                soft_input_4_1_2_flip_3                                   <= soft_input_4_1_2_flip_2;
                soft_input_4_1_3_flip_3                                   <= soft_input_4_1_3_flip_2;
                soft_input_4_1_4_flip_3                                   <= soft_input_4_1_4_flip_2;
                soft_input_4_1_2_flip_3(to_integer(unsigned(index_5(2)))) <= not soft_input_4_1_2_flip_2(to_integer(unsigned(index_5(2)))) + '1';
                weight_info_3(13)                                         <= soft_input_4_1_2_flip_2(to_integer(unsigned(index_5(2))));
            elsif indi_3_4_1_pass_2 = "011" then
                soft_input_4_1_1_flip_3                                   <= soft_input_4_1_1_flip_2;
                soft_input_4_1_2_flip_3                                   <= soft_input_4_1_2_flip_2;
                soft_input_4_1_3_flip_3                                   <= soft_input_4_1_3_flip_2;
                soft_input_4_1_4_flip_3                                   <= soft_input_4_1_4_flip_2;
                soft_input_4_1_3_flip_3(to_integer(unsigned(index_5(2)))) <= not soft_input_4_1_3_flip_2(to_integer(unsigned(index_5(2)))) + '1';
                weight_info_3(13)                                         <= soft_input_4_1_3_flip_2(to_integer(unsigned(index_5(2))));
            elsif indi_3_4_1_pass_2 = "100" then
                soft_input_4_1_1_flip_3                                   <= soft_input_4_1_1_flip_2;
                soft_input_4_1_2_flip_3                                   <= soft_input_4_1_2_flip_2;
                soft_input_4_1_3_flip_3                                   <= soft_input_4_1_3_flip_2;
                soft_input_4_1_4_flip_3                                   <= soft_input_4_1_4_flip_2;
                soft_input_4_1_4_flip_3(to_integer(unsigned(index_5(2)))) <= not soft_input_4_1_4_flip_2(to_integer(unsigned(index_5(2)))) + '1';
                weight_info_3(13)                                         <= soft_input_4_1_4_flip_2(to_integer(unsigned(index_5(2))));
            else
                soft_input_4_1_1_flip_3 <= soft_input_4_1_1_flip_2;
                soft_input_4_1_2_flip_3 <= soft_input_4_1_2_flip_2;
                soft_input_4_1_3_flip_3 <= soft_input_4_1_3_flip_2;
                soft_input_4_1_4_flip_3 <= soft_input_4_1_4_flip_2;
            end if;
            ------------------------------------------------------------------------------------------------------------------------------------
            if indi_3_4_2_pass_2 = "001" then
                soft_input_4_2_1_flip_3                                   <= soft_input_4_2_1_flip_2;
                soft_input_4_2_2_flip_3                                   <= soft_input_4_2_2_flip_2;
                soft_input_4_2_3_flip_3                                   <= soft_input_4_2_3_flip_2;
                soft_input_4_2_4_flip_3                                   <= soft_input_4_2_4_flip_2;
                soft_input_4_2_1_flip_3(to_integer(unsigned(index_5(2)))) <= not soft_input_4_2_1_flip_2(to_integer(unsigned(index_5(2)))) + '1';
                weight_info_3(14)                                         <= soft_input_4_2_1_flip_2(to_integer(unsigned(index_5(2))));
            elsif indi_3_4_2_pass_2 = "010" then
                soft_input_4_2_1_flip_3                                   <= soft_input_4_2_1_flip_2;
                soft_input_4_2_2_flip_3                                   <= soft_input_4_2_2_flip_2;
                soft_input_4_2_3_flip_3                                   <= soft_input_4_2_3_flip_2;
                soft_input_4_2_4_flip_3                                   <= soft_input_4_2_4_flip_2;
                soft_input_4_2_2_flip_3(to_integer(unsigned(index_5(2)))) <= not soft_input_4_2_2_flip_2(to_integer(unsigned(index_5(2)))) + '1';
                weight_info_3(14)                                         <= soft_input_4_2_2_flip_2(to_integer(unsigned(index_5(2))));
            elsif indi_3_4_2_pass_2 = "011" then
                soft_input_4_2_1_flip_3                                   <= soft_input_4_2_1_flip_2;
                soft_input_4_2_2_flip_3                                   <= soft_input_4_2_2_flip_2;
                soft_input_4_2_3_flip_3                                   <= soft_input_4_2_3_flip_2;
                soft_input_4_2_4_flip_3                                   <= soft_input_4_2_4_flip_2;
                soft_input_4_2_3_flip_3(to_integer(unsigned(index_5(2)))) <= not soft_input_4_2_3_flip_2(to_integer(unsigned(index_5(2)))) + '1';
                weight_info_3(14)                                         <= soft_input_4_2_3_flip_2(to_integer(unsigned(index_5(2))));
            elsif indi_3_4_2_pass_2 = "100" then
                soft_input_4_2_1_flip_3                                   <= soft_input_4_2_1_flip_2;
                soft_input_4_2_2_flip_3                                   <= soft_input_4_2_2_flip_2;
                soft_input_4_2_3_flip_3                                   <= soft_input_4_2_3_flip_2;
                soft_input_4_2_4_flip_3                                   <= soft_input_4_2_4_flip_2;
                soft_input_4_2_4_flip_3(to_integer(unsigned(index_5(2)))) <= not soft_input_4_2_4_flip_2(to_integer(unsigned(index_5(2)))) + '1';
                weight_info_3(14)                                         <= soft_input_4_2_4_flip_2(to_integer(unsigned(index_5(2))));
            else
                soft_input_4_2_1_flip_3 <= soft_input_4_2_1_flip_2;
                soft_input_4_2_2_flip_3 <= soft_input_4_2_2_flip_2;
                soft_input_4_2_3_flip_3 <= soft_input_4_2_3_flip_2;
                soft_input_4_2_4_flip_3 <= soft_input_4_2_4_flip_2;
            end if;
            ------------------------------------------------------------------------------------------------------------------------------------
            if indi_3_4_3_pass_2 = "001" then
                soft_input_4_3_1_flip_3                                   <= soft_input_4_3_1_flip_2;
                soft_input_4_3_2_flip_3                                   <= soft_input_4_3_2_flip_2;
                soft_input_4_3_3_flip_3                                   <= soft_input_4_3_3_flip_2;
                soft_input_4_3_4_flip_3                                   <= soft_input_4_3_4_flip_2;
                soft_input_4_3_1_flip_3(to_integer(unsigned(index_5(2)))) <= not soft_input_4_3_1_flip_2(to_integer(unsigned(index_5(2)))) + '1';
                weight_info_3(15)                                         <= soft_input_4_3_1_flip_2(to_integer(unsigned(index_5(2))));
            elsif indi_3_4_3_pass_2 = "010" then
                soft_input_4_3_1_flip_3                                   <= soft_input_4_3_1_flip_2;
                soft_input_4_3_2_flip_3                                   <= soft_input_4_3_2_flip_2;
                soft_input_4_3_3_flip_3                                   <= soft_input_4_3_3_flip_2;
                soft_input_4_3_4_flip_3                                   <= soft_input_4_3_4_flip_2;
                soft_input_4_3_2_flip_3(to_integer(unsigned(index_5(2)))) <= not soft_input_4_3_2_flip_2(to_integer(unsigned(index_5(2)))) + '1';
                weight_info_3(15)                                         <= soft_input_4_3_2_flip_2(to_integer(unsigned(index_5(2))));
            elsif indi_3_4_3_pass_2 = "011" then
                soft_input_4_3_1_flip_3                                   <= soft_input_4_3_1_flip_2;
                soft_input_4_3_2_flip_3                                   <= soft_input_4_3_2_flip_2;
                soft_input_4_3_3_flip_3                                   <= soft_input_4_3_3_flip_2;
                soft_input_4_3_4_flip_3                                   <= soft_input_4_3_4_flip_2;
                soft_input_4_3_3_flip_3(to_integer(unsigned(index_5(2)))) <= not soft_input_4_3_3_flip_2(to_integer(unsigned(index_5(2)))) + '1';
                weight_info_3(15)                                         <= soft_input_4_3_3_flip_2(to_integer(unsigned(index_5(2))));
            elsif indi_3_4_3_pass_2 = "100" then
                soft_input_4_3_1_flip_3                                   <= soft_input_4_3_1_flip_2;
                soft_input_4_3_2_flip_3                                   <= soft_input_4_3_2_flip_2;
                soft_input_4_3_3_flip_3                                   <= soft_input_4_3_3_flip_2;
                soft_input_4_3_4_flip_3                                   <= soft_input_4_3_4_flip_2;
                soft_input_4_3_4_flip_3(to_integer(unsigned(index_5(2)))) <= not soft_input_4_3_4_flip_2(to_integer(unsigned(index_5(2)))) + '1';
                weight_info_3(15)                                         <= soft_input_4_3_4_flip_2(to_integer(unsigned(index_5(2))));
            else
                soft_input_4_3_1_flip_3 <= soft_input_4_3_1_flip_2;
                soft_input_4_3_2_flip_3 <= soft_input_4_3_2_flip_2;
                soft_input_4_3_3_flip_3 <= soft_input_4_3_3_flip_2;
                soft_input_4_3_4_flip_3 <= soft_input_4_3_4_flip_2;
            end if;
            ------------------------------------------------------------------------------------------------------------------------------------
            if indi_3_4_4_pass_2 = "001" then
                soft_input_4_4_1_flip_3                                   <= soft_input_4_4_1_flip_2;
                soft_input_4_4_2_flip_3                                   <= soft_input_4_4_2_flip_2;
                soft_input_4_4_3_flip_3                                   <= soft_input_4_4_3_flip_2;
                soft_input_4_4_4_flip_3                                   <= soft_input_4_4_4_flip_2;
                soft_input_4_4_1_flip_3(to_integer(unsigned(index_5(2)))) <= not soft_input_4_4_1_flip_2(to_integer(unsigned(index_5(2)))) + '1';
                weight_info_3(16)                                         <= soft_input_4_4_1_flip_2(to_integer(unsigned(index_5(2))));
            elsif indi_3_4_4_pass_2 = "010" then
                soft_input_4_4_1_flip_3                                   <= soft_input_4_4_1_flip_2;
                soft_input_4_4_2_flip_3                                   <= soft_input_4_4_2_flip_2;
                soft_input_4_4_3_flip_3                                   <= soft_input_4_4_3_flip_2;
                soft_input_4_4_4_flip_3                                   <= soft_input_4_4_4_flip_2;
                soft_input_4_4_2_flip_3(to_integer(unsigned(index_5(2)))) <= not soft_input_4_4_2_flip_2(to_integer(unsigned(index_5(2)))) + '1';
                weight_info_3(16)                                         <= soft_input_4_4_2_flip_2(to_integer(unsigned(index_5(2))));
            elsif indi_3_4_4_pass_2 = "011" then
                soft_input_4_4_1_flip_3                                   <= soft_input_4_4_1_flip_2;
                soft_input_4_4_2_flip_3                                   <= soft_input_4_4_2_flip_2;
                soft_input_4_4_3_flip_3                                   <= soft_input_4_4_3_flip_2;
                soft_input_4_4_4_flip_3                                   <= soft_input_4_4_4_flip_2;
                soft_input_4_4_3_flip_3(to_integer(unsigned(index_5(2)))) <= not soft_input_4_4_3_flip_2(to_integer(unsigned(index_5(2)))) + '1';
                weight_info_3(16)                                         <= soft_input_4_4_3_flip_2(to_integer(unsigned(index_5(2))));
            elsif indi_3_4_4_pass_2 = "100" then
                soft_input_4_4_1_flip_3                                   <= soft_input_4_4_1_flip_2;
                soft_input_4_4_2_flip_3                                   <= soft_input_4_4_2_flip_2;
                soft_input_4_4_3_flip_3                                   <= soft_input_4_4_3_flip_2;
                soft_input_4_4_4_flip_3                                   <= soft_input_4_4_4_flip_2;
                soft_input_4_4_4_flip_3(to_integer(unsigned(index_5(2)))) <= not soft_input_4_4_4_flip_2(to_integer(unsigned(index_5(2)))) + '1';
                weight_info_3(16)                                         <= soft_input_4_4_4_flip_2(to_integer(unsigned(index_5(2))));
            else
                soft_input_4_4_1_flip_3 <= soft_input_4_4_1_flip_2;
                soft_input_4_4_2_flip_3 <= soft_input_4_4_2_flip_2;
                soft_input_4_4_3_flip_3 <= soft_input_4_4_3_flip_2;
                soft_input_4_4_4_flip_3 <= soft_input_4_4_4_flip_2;
            end if;
            ----------------------------------------------------------------------------------------------------------------------------------
        end if;
    end process;
    ------------------------------------------------------------------------------------------------------------
    -- Define processes : (CLK 5)
    ------------------------------------------------------------------------------------------------------------
    process (clk, reset)
    begin
        if (reset = '1') then
            soft_output_unflipped_7 <= (others => (others => '0'));
            attach_1_1              <= (others => (others => '0'));
            attach_1_2              <= (others => (others => '0'));
            attach_1_3              <= (others => (others => '0'));
            attach_1_4              <= (others => (others => '0'));
            attach_2_1              <= (others => (others => '0'));
            attach_2_2              <= (others => (others => '0'));
            attach_2_3              <= (others => (others => '0'));
            attach_2_4              <= (others => (others => '0'));
            attach_3_1              <= (others => (others => '0'));
            attach_3_2              <= (others => (others => '0'));
            attach_3_3              <= (others => (others => '0'));
            attach_3_4              <= (others => (others => '0'));
            attach_4_1              <= (others => (others => '0'));
            attach_4_2              <= (others => (others => '0'));
            attach_4_3              <= (others => (others => '0'));
            attach_4_4              <= (others => (others => '0'));
            weight_info_1_pass      <= (others => '0');
            weight_info_2_pass      <= (others => '0');
            weight_info_3_temp_p1   <= (others => '0');
            weight_info_3_temp_p2   <= (others => '0');
            weight_info_3_temp_p3   <= (others => '0');
            weight_info_3_temp_p4   <= (others => '0');
            index_7                 <= (others => (others => '0'));
            index_7_original        <= (others => (others => '0'));
        elsif (rising_edge(clk)) then
            index_7                 <= index_6;
            index_7_original        <= index_6_original;
            soft_output_unflipped_7 <= soft_output_unflipped_6;
            weight_info_1_pass      <= weight_info_1_temp1;
            weight_info_2_pass      <= weight_info_2_temp_p1 xor weight_info_2_temp_p2 xor weight_info_2_temp_p3 xor weight_info_2_temp_p4;
            weight_info_3_temp_p1   <= weight_info_3(1) xor weight_info_3(2) xor weight_info_3(3) xor weight_info_3(4);
            weight_info_3_temp_p2   <= weight_info_3(5) xor weight_info_3(6) xor weight_info_3(7) xor weight_info_3(8);
            weight_info_3_temp_p3   <= weight_info_3(9) xor weight_info_3(10) xor weight_info_3(11) xor weight_info_3(12);
            weight_info_3_temp_p4   <= weight_info_3(13) xor weight_info_3(14) xor weight_info_3(15) xor weight_info_3(16);
            attach_1_1              <= soft_input_1_1_4_flip_3 & soft_input_1_1_3_flip_3 & soft_input_1_1_2_flip_3 & soft_input_1_1_1_flip_3;
            attach_1_2              <= soft_input_1_2_4_flip_3 & soft_input_1_2_3_flip_3 & soft_input_1_2_2_flip_3 & soft_input_1_2_1_flip_3;
            attach_1_3              <= soft_input_1_3_4_flip_3 & soft_input_1_3_3_flip_3 & soft_input_1_3_2_flip_3 & soft_input_1_3_1_flip_3;
            attach_1_4              <= soft_input_1_4_4_flip_3 & soft_input_1_4_3_flip_3 & soft_input_1_4_2_flip_3 & soft_input_1_4_1_flip_3;
            attach_2_1              <= soft_input_2_1_4_flip_3 & soft_input_2_1_3_flip_3 & soft_input_2_1_2_flip_3 & soft_input_2_1_1_flip_3;
            attach_2_2              <= soft_input_2_2_4_flip_3 & soft_input_2_2_3_flip_3 & soft_input_2_2_2_flip_3 & soft_input_2_2_1_flip_3;
            attach_2_3              <= soft_input_2_3_4_flip_3 & soft_input_2_3_3_flip_3 & soft_input_2_3_2_flip_3 & soft_input_2_3_1_flip_3;
            attach_2_4              <= soft_input_2_4_4_flip_3 & soft_input_2_4_3_flip_3 & soft_input_2_4_2_flip_3 & soft_input_2_4_1_flip_3;
            attach_3_1              <= soft_input_3_1_4_flip_3 & soft_input_3_1_3_flip_3 & soft_input_3_1_2_flip_3 & soft_input_3_1_1_flip_3;
            attach_3_2              <= soft_input_3_2_4_flip_3 & soft_input_3_2_3_flip_3 & soft_input_3_2_2_flip_3 & soft_input_3_2_1_flip_3;
            attach_3_3              <= soft_input_3_3_4_flip_3 & soft_input_3_3_3_flip_3 & soft_input_3_3_2_flip_3 & soft_input_3_3_1_flip_3;
            attach_3_4              <= soft_input_3_4_4_flip_3 & soft_input_3_4_3_flip_3 & soft_input_3_4_2_flip_3 & soft_input_3_4_1_flip_3;
            attach_4_1              <= soft_input_4_1_4_flip_3 & soft_input_4_1_3_flip_3 & soft_input_4_1_2_flip_3 & soft_input_4_1_1_flip_3;
            attach_4_2              <= soft_input_4_2_4_flip_3 & soft_input_4_2_3_flip_3 & soft_input_4_2_2_flip_3 & soft_input_4_2_1_flip_3;
            attach_4_3              <= soft_input_4_3_4_flip_3 & soft_input_4_3_3_flip_3 & soft_input_4_3_2_flip_3 & soft_input_4_3_1_flip_3;
            attach_4_4              <= soft_input_4_4_4_flip_3 & soft_input_4_4_3_flip_3 & soft_input_4_4_2_flip_3 & soft_input_4_4_1_flip_3;
        end if;
    end process;
    ------------------------------------------------------------------------------------------------------------
    -- Define processes : (CLK 6)
    ------------------------------------------------------------------------------------------------------------
    process (clk, reset)
    begin
        if (reset = '1') then
            soft_output_unflipped_8 <= (others => (others => '0'));
            attach_1                <= (others => (others => '0'));
            attach_2                <= (others => (others => '0'));
            attach_3                <= (others => (others => '0'));
            attach_4                <= (others => (others => '0'));
            weight_info_1_pass1     <= (others => '0');
            weight_info_2_pass1     <= (others => '0');
            weight_info_3_pass1     <= (others => '0');
            index_8                 <= (others => (others => '0'));
            index_8_original        <= (others => (others => '0'));
        elsif (rising_edge(clk)) then
            index_8                 <= index_7;
            index_8_original        <= index_7_original;
            soft_output_unflipped_8 <= soft_output_unflipped_7;
            weight_info_1_pass1     <= weight_info_1_pass;
            weight_info_2_pass1     <= weight_info_2_pass;
            weight_info_3_pass1     <= weight_info_3_temp_p1 xor weight_info_3_temp_p2 xor weight_info_3_temp_p3 xor weight_info_3_temp_p4;
            attach_1                <= attach_1_4 & attach_1_3 & attach_1_2 & attach_1_1;
            attach_2                <= attach_2_4 & attach_2_3 & attach_2_2 & attach_2_1;
            attach_3                <= attach_3_4 & attach_3_3 & attach_3_2 & attach_3_1;
            attach_4                <= attach_4_4 & attach_4_3 & attach_4_2 & attach_4_1;
        end if;
    end process;
    ------------------------------------------------------------------------------------------------------------
    -- Define processes : (CLK 7)
    ------------------------------------------------------------------------------------------------------------
    process (clk, reset)
    begin
        if (reset = '1') then
            index_9                 <= (others => (others => '0'));
            index_9_original        <= (others => (others => '0'));
            soft_output_unflipped_9 <= (others => (others => '0'));
            weight_info_1_pass2     <= (others => '0');
            weight_info_2_pass2     <= (others => '0');
            weight_info_3_pass2     <= (others => '0');
            soft_output_flipped_1   <= (others => (others => '0'));
        elsif (rising_edge(clk)) then
            index_9                 <= index_8;
            index_9_original        <= index_8_original;
            soft_output_unflipped_9 <= soft_output_unflipped_8;
            weight_info_1_pass2     <= weight_info_1_pass1;
            weight_info_2_pass2     <= weight_info_2_pass1;
            weight_info_3_pass2     <= weight_info_3_pass1;
            soft_output_flipped_1   <= attach_4 & attach_3 & attach_2 & attach_1;
        end if;
    end process;
    ------------------------------------------------------------------------------------------------------------
    -- Define processes : (CLK 8)
    ------------------------------------------------------------------------------------------------------------
    process (clk, reset)
    begin
        if (reset = '1') then
            index_out             <= (others => (others => '0'));
            soft_output_flipped   <= (others => (others => '0'));
            weight_info           <= (others => (others => '0'));
            soft_output_unflipped <= (others => (others => '0'));
        elsif (rising_edge(clk)) then
            index_out             <= index_9_original;
            soft_output_unflipped <= soft_output_unflipped_9;
            weight_info(0)        <= weight_info_1_pass2;
            weight_info(1)        <= weight_info_2_pass2;
            weight_info(2)        <= weight_info_3_pass2;
            soft_output_flipped   <= soft_output_flipped_1;
        end if;
    end process;
end architecture;
