-- This connects to bch decoder, based on the received error location, and the data from weight_1 together
-- Calulcated the weight of the correction
--library ieee;
--use ieee.std_logic_1164.all;
--
--package arr_pkg_9 is
--    type input_data_array is array (natural range <>) of std_logic_vector(7 downto 0); -- 8 bits...okay, let's stick to the beta version
--end;
--
--library ieee;
--use ieee.std_logic_1164.all;
--
--package arr_pkg_10 is
--    type output_error_location_array is array (natural range <>) of integer;
--end;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
--use work.arr_pkg_9.all;
--use work.arr_pkg_10.all;
use work.arr_pkg_1.all;
use work.arr_pkg_2.all;
use work.arr_pkg_3.all;
use work.arr_pkg_4.all;
use work.arr_pkg_5.all;

entity weight_2 is
    generic (
        data_length  : positive := 255;
        index_length : positive := 2 -- take in 3 integers as error positions                                
    );
    port (
        clk                  : in std_logic;
        reset                : in std_logic;
        soft_input           : in input_data_array(data_length downto 0); -- From BCH decoder
        hard_input           : in std_logic_vector(data_length downto 0);
        error_position       : in output_error_location_array(index_length downto 0); -- From weight_1 block
        corrections_in       : in std_logic_vector(index_length downto 0);            -- No idea if I need this...
        weight_in            : in std_logic_vector(9 downto 0);                       -- From weight_1 block
        soft_input_unflipped : in input_data_array(data_length downto 0);             -- From weight_1 block
        index_in_w1          : in index_array(7 downto 0);                            -- From weight_1 block

        soft_output           : out input_data_array(data_length downto 0);             -- Same value as soft_input
        hard_output           : out std_logic_vector(data_length downto 0);             -- Same value as hard_input
        corrections_out       : out std_logic_vector(index_length downto 0);            -- Same value as corrections_in
        error_position_out    : out output_error_location_array(index_length downto 0); -- Same value as error_position
        soft_output_unflipped : out input_data_array(data_length downto 0);
        final_weight_value    : out std_logic_vector(10 downto 0)
    );
end weight_2;
architecture rtl of weight_2 is
    --------------------------------------------------------------------------------------------
    -- CLK 0
    signal soft_input_in           : input_data_array(data_length downto 0);
    signal hard_input_in           : std_logic_vector(data_length downto 0);
    signal error_position_in       : output_error_location_array(index_length downto 0);
    signal corrections_in_in       : std_logic_vector(index_length downto 0);
    signal weight_in_in            : std_logic_vector(9 downto 0);
    signal soft_input_unflipped_in : input_data_array(data_length downto 0);
    signal index_in_w1_1           : index_array(7 downto 0);
    --------------------------------------------------------------------------------------------
    -- CLK 1
    signal soft_input_pass_1      : input_data_array(data_length downto 0);
    signal hard_input_1           : std_logic_vector(data_length downto 0);
    signal corrections_in_1       : std_logic_vector(index_length downto 0);
    signal error_position_1       : output_error_location_array(index_length downto 0);
    signal weight_in_1            : std_logic_vector(9 downto 0);
    signal soft_input_1           : input_data_array(63 downto 0);
    signal soft_input_2           : input_data_array(63 downto 0);
    signal soft_input_3           : input_data_array(63 downto 0);
    signal soft_input_4           : input_data_array(63 downto 0);
    signal soft_input_unflipped_1 : input_data_array(255 downto 0);
    signal index_in_w1_2_1        : integer;
    signal index_in_w1_2_2        : integer;
    signal index_in_w1_2_3        : integer;
    --------------------------------------------------------------------------------------------
    -- CLK 1.1
    signal soft_input_pass_1_temp      : input_data_array(data_length downto 0);
    signal hard_input_1_temp           : std_logic_vector(data_length downto 0);
    signal weight_in_1_temp            : std_logic_vector(9 downto 0);
    signal corrections_in_1_temp       : std_logic_vector(index_length downto 0);
    signal error_position_1_temp       : output_error_location_array(index_length downto 0);
    signal soft_input_4_temp           : input_data_array(63 downto 0);
    signal soft_input_3_temp           : input_data_array(63 downto 0);
    signal soft_input_2_temp           : input_data_array(63 downto 0);
    signal soft_input_1_temp           : input_data_array(63 downto 0);
    signal soft_input_unflipped_1_temp : input_data_array(255 downto 0);
    signal index_in_w1_2_1_1           : integer;
    signal index_in_w1_2_2_1           : integer;
    signal index_in_w1_2_3_1           : integer;
    --------------------------------------------------------------------------------------------
    -- CLK 1.5
    signal soft_input_pass_15     : input_data_array(data_length downto 0);
    signal hard_input_pass_15     : std_logic_vector(data_length downto 0);
    signal weight_in_pass_15      : std_logic_vector(9 downto 0);
    signal corrections_in_pass_15 : std_logic_vector(index_length downto 0);
    signal error_position_pass_15 : output_error_location_array(index_length downto 0);
    signal soft_input_4_pass_15   : input_data_array(63 downto 0);
    signal soft_input_3_pass_15   : input_data_array(63 downto 0);
    signal soft_input_2_pass_15   : input_data_array(63 downto 0);
    signal soft_input_1_pass_15   : input_data_array(63 downto 0);
    signal flag_1_1               : boolean;
    signal flag_1_2               : boolean;
    signal flag_1_3               : boolean;
    signal flag_1_4               : boolean;
    signal flag_2_1               : boolean;
    signal flag_2_2               : boolean;
    signal flag_2_3               : boolean;
    signal flag_2_4               : boolean;
    signal flag_3_1               : boolean;
    signal flag_3_2               : boolean;
    signal flag_3_3               : boolean;
    signal flag_3_4               : boolean;
    signal soft_input_unflipped_2 : input_data_array(255 downto 0);
    signal index_in_w1_2_1_2      : integer;
    signal index_in_w1_2_2_2      : integer;
    signal index_in_w1_2_3_2      : integer;
    --------------------------------------------------------------------------------------------
    -- CLK 2
    signal soft_input_pass_2      : input_data_array(data_length downto 0);
    signal hard_input_2           : std_logic_vector(data_length downto 0);
    signal corrections_in_2       : std_logic_vector(index_length downto 0);
    signal error_position_2       : output_error_location_array(index_length downto 0);
    signal weight_in_2            : std_logic_vector(9 downto 0);
    signal indi_1                 : std_logic_vector(2 downto 0); -- indicate the region of index
    signal indi_2                 : std_logic_vector(2 downto 0);
    signal indi_3                 : std_logic_vector(2 downto 0);
    signal soft_input_1_1         : input_data_array(15 downto 0);
    signal soft_input_1_2         : input_data_array(15 downto 0);
    signal soft_input_1_3         : input_data_array(15 downto 0);
    signal soft_input_1_4         : input_data_array(15 downto 0);
    signal soft_input_2_1         : input_data_array(15 downto 0);
    signal soft_input_2_2         : input_data_array(15 downto 0);
    signal soft_input_2_3         : input_data_array(15 downto 0);
    signal soft_input_2_4         : input_data_array(15 downto 0);
    signal soft_input_3_1         : input_data_array(15 downto 0);
    signal soft_input_3_2         : input_data_array(15 downto 0);
    signal soft_input_3_3         : input_data_array(15 downto 0);
    signal soft_input_3_4         : input_data_array(15 downto 0);
    signal soft_input_4_1         : input_data_array(15 downto 0);
    signal soft_input_4_2         : input_data_array(15 downto 0);
    signal soft_input_4_3         : input_data_array(15 downto 0);
    signal soft_input_4_4         : input_data_array(15 downto 0);
    signal soft_input_unflipped_3 : input_data_array(255 downto 0);
    --------------------------------------------------------------------------------------------
    -- CLK 3
    signal soft_input_pass_3      : input_data_array(data_length downto 0);
    signal hard_input_3           : std_logic_vector(data_length downto 0);
    signal corrections_in_3       : std_logic_vector(index_length downto 0);
    signal error_position_3       : output_error_location_array(index_length downto 0);
    signal weight_in_3            : std_logic_vector(9 downto 0);
    signal indi_1_1               : std_logic_vector(2 downto 0); -- indicate the region of index
    signal indi_1_2               : std_logic_vector(2 downto 0);
    signal indi_1_3               : std_logic_vector(2 downto 0);
    signal indi_1_4               : std_logic_vector(2 downto 0);
    signal indi_2_1               : std_logic_vector(2 downto 0);
    signal indi_2_2               : std_logic_vector(2 downto 0);
    signal indi_2_3               : std_logic_vector(2 downto 0);
    signal indi_2_4               : std_logic_vector(2 downto 0);
    signal indi_3_1               : std_logic_vector(2 downto 0);
    signal indi_3_2               : std_logic_vector(2 downto 0);
    signal indi_3_3               : std_logic_vector(2 downto 0);
    signal indi_3_4               : std_logic_vector(2 downto 0);
    signal soft_input_1_1_1       : input_data_array(3 downto 0);
    signal soft_input_1_1_2       : input_data_array(3 downto 0);
    signal soft_input_1_1_3       : input_data_array(3 downto 0);
    signal soft_input_1_1_4       : input_data_array(3 downto 0);
    signal soft_input_1_2_1       : input_data_array(3 downto 0);
    signal soft_input_1_2_2       : input_data_array(3 downto 0);
    signal soft_input_1_2_3       : input_data_array(3 downto 0);
    signal soft_input_1_2_4       : input_data_array(3 downto 0);
    signal soft_input_1_3_1       : input_data_array(3 downto 0);
    signal soft_input_1_3_2       : input_data_array(3 downto 0);
    signal soft_input_1_3_3       : input_data_array(3 downto 0);
    signal soft_input_1_3_4       : input_data_array(3 downto 0);
    signal soft_input_1_4_1       : input_data_array(3 downto 0);
    signal soft_input_1_4_2       : input_data_array(3 downto 0);
    signal soft_input_1_4_3       : input_data_array(3 downto 0);
    signal soft_input_1_4_4       : input_data_array(3 downto 0);
    signal soft_input_2_1_1       : input_data_array(3 downto 0);
    signal soft_input_2_1_2       : input_data_array(3 downto 0);
    signal soft_input_2_1_3       : input_data_array(3 downto 0);
    signal soft_input_2_1_4       : input_data_array(3 downto 0);
    signal soft_input_2_2_1       : input_data_array(3 downto 0);
    signal soft_input_2_2_2       : input_data_array(3 downto 0);
    signal soft_input_2_2_3       : input_data_array(3 downto 0);
    signal soft_input_2_2_4       : input_data_array(3 downto 0);
    signal soft_input_2_3_1       : input_data_array(3 downto 0);
    signal soft_input_2_3_2       : input_data_array(3 downto 0);
    signal soft_input_2_3_3       : input_data_array(3 downto 0);
    signal soft_input_2_3_4       : input_data_array(3 downto 0);
    signal soft_input_2_4_1       : input_data_array(3 downto 0);
    signal soft_input_2_4_2       : input_data_array(3 downto 0);
    signal soft_input_2_4_3       : input_data_array(3 downto 0);
    signal soft_input_2_4_4       : input_data_array(3 downto 0);
    signal soft_input_3_1_1       : input_data_array(3 downto 0);
    signal soft_input_3_1_2       : input_data_array(3 downto 0);
    signal soft_input_3_1_3       : input_data_array(3 downto 0);
    signal soft_input_3_1_4       : input_data_array(3 downto 0);
    signal soft_input_3_2_1       : input_data_array(3 downto 0);
    signal soft_input_3_2_2       : input_data_array(3 downto 0);
    signal soft_input_3_2_3       : input_data_array(3 downto 0);
    signal soft_input_3_2_4       : input_data_array(3 downto 0);
    signal soft_input_3_3_1       : input_data_array(3 downto 0);
    signal soft_input_3_3_2       : input_data_array(3 downto 0);
    signal soft_input_3_3_3       : input_data_array(3 downto 0);
    signal soft_input_3_3_4       : input_data_array(3 downto 0);
    signal soft_input_3_4_1       : input_data_array(3 downto 0);
    signal soft_input_3_4_2       : input_data_array(3 downto 0);
    signal soft_input_3_4_3       : input_data_array(3 downto 0);
    signal soft_input_3_4_4       : input_data_array(3 downto 0);
    signal soft_input_4_1_1       : input_data_array(3 downto 0);
    signal soft_input_4_1_2       : input_data_array(3 downto 0);
    signal soft_input_4_1_3       : input_data_array(3 downto 0);
    signal soft_input_4_1_4       : input_data_array(3 downto 0);
    signal soft_input_4_2_1       : input_data_array(3 downto 0);
    signal soft_input_4_2_2       : input_data_array(3 downto 0);
    signal soft_input_4_2_3       : input_data_array(3 downto 0);
    signal soft_input_4_2_4       : input_data_array(3 downto 0);
    signal soft_input_4_3_1       : input_data_array(3 downto 0);
    signal soft_input_4_3_2       : input_data_array(3 downto 0);
    signal soft_input_4_3_3       : input_data_array(3 downto 0);
    signal soft_input_4_3_4       : input_data_array(3 downto 0);
    signal soft_input_4_4_1       : input_data_array(3 downto 0);
    signal soft_input_4_4_2       : input_data_array(3 downto 0);
    signal soft_input_4_4_3       : input_data_array(3 downto 0);
    signal soft_input_4_4_4       : input_data_array(3 downto 0);
    signal soft_input_unflipped_4 : input_data_array(255 downto 0);
    --------------------------------------------------------------------------------------------
    -- CLK 4
    signal soft_input_pass_ext    : input_data_array(data_length downto 0);
    signal hard_input_ext         : std_logic_vector(data_length downto 0);
    signal weight_in_ext          : std_logic_vector(9 downto 0);
    signal corrections_in_ext     : std_logic_vector(index_length downto 0);
    signal error_position_ext     : output_error_location_array(index_length downto 0);
    signal indi_1_1_ext           : std_logic_vector(2 downto 0);
    signal indi_1_2_ext           : std_logic_vector(2 downto 0);
    signal indi_1_3_ext           : std_logic_vector(2 downto 0);
    signal indi_1_4_ext           : std_logic_vector(2 downto 0);
    signal indi_2_1_ext           : std_logic_vector(2 downto 0);
    signal indi_2_2_ext           : std_logic_vector(2 downto 0);
    signal indi_2_3_ext           : std_logic_vector(2 downto 0);
    signal indi_2_4_ext           : std_logic_vector(2 downto 0);
    signal indi_3_1_ext           : std_logic_vector(2 downto 0);
    signal indi_3_2_ext           : std_logic_vector(2 downto 0);
    signal indi_3_3_ext           : std_logic_vector(2 downto 0);
    signal indi_3_4_ext           : std_logic_vector(2 downto 0);
    signal soft_input_1_1_1_ext   : input_data_array(3 downto 0);
    signal soft_input_1_1_2_ext   : input_data_array(3 downto 0);
    signal soft_input_1_1_3_ext   : input_data_array(3 downto 0);
    signal soft_input_1_1_4_ext   : input_data_array(3 downto 0);
    signal soft_input_1_2_1_ext   : input_data_array(3 downto 0);
    signal soft_input_1_2_2_ext   : input_data_array(3 downto 0);
    signal soft_input_1_2_3_ext   : input_data_array(3 downto 0);
    signal soft_input_1_2_4_ext   : input_data_array(3 downto 0);
    signal soft_input_1_3_1_ext   : input_data_array(3 downto 0);
    signal soft_input_1_3_2_ext   : input_data_array(3 downto 0);
    signal soft_input_1_3_3_ext   : input_data_array(3 downto 0);
    signal soft_input_1_3_4_ext   : input_data_array(3 downto 0);
    signal soft_input_1_4_1_ext   : input_data_array(3 downto 0);
    signal soft_input_1_4_2_ext   : input_data_array(3 downto 0);
    signal soft_input_1_4_3_ext   : input_data_array(3 downto 0);
    signal soft_input_1_4_4_ext   : input_data_array(3 downto 0);
    signal soft_input_2_1_1_ext   : input_data_array(3 downto 0);
    signal soft_input_2_1_2_ext   : input_data_array(3 downto 0);
    signal soft_input_2_1_3_ext   : input_data_array(3 downto 0);
    signal soft_input_2_1_4_ext   : input_data_array(3 downto 0);
    signal soft_input_2_2_1_ext   : input_data_array(3 downto 0);
    signal soft_input_2_2_2_ext   : input_data_array(3 downto 0);
    signal soft_input_2_2_3_ext   : input_data_array(3 downto 0);
    signal soft_input_2_2_4_ext   : input_data_array(3 downto 0);
    signal soft_input_2_3_1_ext   : input_data_array(3 downto 0);
    signal soft_input_2_3_2_ext   : input_data_array(3 downto 0);
    signal soft_input_2_3_3_ext   : input_data_array(3 downto 0);
    signal soft_input_2_3_4_ext   : input_data_array(3 downto 0);
    signal soft_input_2_4_1_ext   : input_data_array(3 downto 0);
    signal soft_input_2_4_2_ext   : input_data_array(3 downto 0);
    signal soft_input_2_4_3_ext   : input_data_array(3 downto 0);
    signal soft_input_2_4_4_ext   : input_data_array(3 downto 0);
    signal soft_input_3_1_1_ext   : input_data_array(3 downto 0);
    signal soft_input_3_1_2_ext   : input_data_array(3 downto 0);
    signal soft_input_3_1_3_ext   : input_data_array(3 downto 0);
    signal soft_input_3_1_4_ext   : input_data_array(3 downto 0);
    signal soft_input_3_2_1_ext   : input_data_array(3 downto 0);
    signal soft_input_3_2_2_ext   : input_data_array(3 downto 0);
    signal soft_input_3_2_3_ext   : input_data_array(3 downto 0);
    signal soft_input_3_2_4_ext   : input_data_array(3 downto 0);
    signal soft_input_3_3_1_ext   : input_data_array(3 downto 0);
    signal soft_input_3_3_2_ext   : input_data_array(3 downto 0);
    signal soft_input_3_3_3_ext   : input_data_array(3 downto 0);
    signal soft_input_3_3_4_ext   : input_data_array(3 downto 0);
    signal soft_input_3_4_1_ext   : input_data_array(3 downto 0);
    signal soft_input_3_4_2_ext   : input_data_array(3 downto 0);
    signal soft_input_3_4_3_ext   : input_data_array(3 downto 0);
    signal soft_input_3_4_4_ext   : input_data_array(3 downto 0);
    signal soft_input_4_1_1_ext   : input_data_array(3 downto 0);
    signal soft_input_4_1_2_ext   : input_data_array(3 downto 0);
    signal soft_input_4_1_3_ext   : input_data_array(3 downto 0);
    signal soft_input_4_1_4_ext   : input_data_array(3 downto 0);
    signal soft_input_4_2_1_ext   : input_data_array(3 downto 0);
    signal soft_input_4_2_2_ext   : input_data_array(3 downto 0);
    signal soft_input_4_2_3_ext   : input_data_array(3 downto 0);
    signal soft_input_4_2_4_ext   : input_data_array(3 downto 0);
    signal soft_input_4_3_1_ext   : input_data_array(3 downto 0);
    signal soft_input_4_3_2_ext   : input_data_array(3 downto 0);
    signal soft_input_4_3_3_ext   : input_data_array(3 downto 0);
    signal soft_input_4_3_4_ext   : input_data_array(3 downto 0);
    signal soft_input_4_4_1_ext   : input_data_array(3 downto 0);
    signal soft_input_4_4_2_ext   : input_data_array(3 downto 0);
    signal soft_input_4_4_3_ext   : input_data_array(3 downto 0);
    signal soft_input_4_4_4_ext   : input_data_array(3 downto 0);
    signal statement_0_1          : boolean;
    signal statement_0_2          : boolean;
    signal statement_0_3          : boolean;
    signal statement_1_1          : boolean;
    signal statement_1_2          : boolean;
    signal statement_1_3          : boolean;
    signal statement_2_1          : boolean;
    signal statement_2_2          : boolean;
    signal statement_2_3          : boolean;
    signal soft_input_unflipped_5 : input_data_array(255 downto 0);
    --------------------------------------------------------------------------------------------
    -- CLK 5
    signal soft_input_pass_4       : input_data_array(data_length downto 0);
    signal hard_input_4            : std_logic_vector(data_length downto 0);
    signal corrections_in_4        : std_logic_vector(index_length downto 0);
    signal error_position_4        : output_error_location_array(index_length downto 0);
    signal weight_in_4             : std_logic_vector(9 downto 0);
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
    signal soft_input_1_1_1_pass_1 : input_data_array(3 downto 0);
    signal soft_input_1_1_2_pass_1 : input_data_array(3 downto 0);
    signal soft_input_1_1_3_pass_1 : input_data_array(3 downto 0);
    signal soft_input_1_1_4_pass_1 : input_data_array(3 downto 0);
    signal soft_input_1_2_1_pass_1 : input_data_array(3 downto 0);
    signal soft_input_1_2_2_pass_1 : input_data_array(3 downto 0);
    signal soft_input_1_2_3_pass_1 : input_data_array(3 downto 0);
    signal soft_input_1_2_4_pass_1 : input_data_array(3 downto 0);
    signal soft_input_1_3_1_pass_1 : input_data_array(3 downto 0);
    signal soft_input_1_3_2_pass_1 : input_data_array(3 downto 0);
    signal soft_input_1_3_3_pass_1 : input_data_array(3 downto 0);
    signal soft_input_1_3_4_pass_1 : input_data_array(3 downto 0);
    signal soft_input_1_4_1_pass_1 : input_data_array(3 downto 0);
    signal soft_input_1_4_2_pass_1 : input_data_array(3 downto 0);
    signal soft_input_1_4_3_pass_1 : input_data_array(3 downto 0);
    signal soft_input_1_4_4_pass_1 : input_data_array(3 downto 0);
    signal soft_input_2_1_1_pass_1 : input_data_array(3 downto 0);
    signal soft_input_2_1_2_pass_1 : input_data_array(3 downto 0);
    signal soft_input_2_1_3_pass_1 : input_data_array(3 downto 0);
    signal soft_input_2_1_4_pass_1 : input_data_array(3 downto 0);
    signal soft_input_2_2_1_pass_1 : input_data_array(3 downto 0);
    signal soft_input_2_2_2_pass_1 : input_data_array(3 downto 0);
    signal soft_input_2_2_3_pass_1 : input_data_array(3 downto 0);
    signal soft_input_2_2_4_pass_1 : input_data_array(3 downto 0);
    signal soft_input_2_3_1_pass_1 : input_data_array(3 downto 0);
    signal soft_input_2_3_2_pass_1 : input_data_array(3 downto 0);
    signal soft_input_2_3_3_pass_1 : input_data_array(3 downto 0);
    signal soft_input_2_3_4_pass_1 : input_data_array(3 downto 0);
    signal soft_input_2_4_1_pass_1 : input_data_array(3 downto 0);
    signal soft_input_2_4_2_pass_1 : input_data_array(3 downto 0);
    signal soft_input_2_4_3_pass_1 : input_data_array(3 downto 0);
    signal soft_input_2_4_4_pass_1 : input_data_array(3 downto 0);
    signal soft_input_3_1_1_pass_1 : input_data_array(3 downto 0);
    signal soft_input_3_1_2_pass_1 : input_data_array(3 downto 0);
    signal soft_input_3_1_3_pass_1 : input_data_array(3 downto 0);
    signal soft_input_3_1_4_pass_1 : input_data_array(3 downto 0);
    signal soft_input_3_2_1_pass_1 : input_data_array(3 downto 0);
    signal soft_input_3_2_2_pass_1 : input_data_array(3 downto 0);
    signal soft_input_3_2_3_pass_1 : input_data_array(3 downto 0);
    signal soft_input_3_2_4_pass_1 : input_data_array(3 downto 0);
    signal soft_input_3_3_1_pass_1 : input_data_array(3 downto 0);
    signal soft_input_3_3_2_pass_1 : input_data_array(3 downto 0);
    signal soft_input_3_3_3_pass_1 : input_data_array(3 downto 0);
    signal soft_input_3_3_4_pass_1 : input_data_array(3 downto 0);
    signal soft_input_3_4_1_pass_1 : input_data_array(3 downto 0);
    signal soft_input_3_4_2_pass_1 : input_data_array(3 downto 0);
    signal soft_input_3_4_3_pass_1 : input_data_array(3 downto 0);
    signal soft_input_3_4_4_pass_1 : input_data_array(3 downto 0);
    signal soft_input_4_1_1_pass_1 : input_data_array(3 downto 0);
    signal soft_input_4_1_2_pass_1 : input_data_array(3 downto 0);
    signal soft_input_4_1_3_pass_1 : input_data_array(3 downto 0);
    signal soft_input_4_1_4_pass_1 : input_data_array(3 downto 0);
    signal soft_input_4_2_1_pass_1 : input_data_array(3 downto 0);
    signal soft_input_4_2_2_pass_1 : input_data_array(3 downto 0);
    signal soft_input_4_2_3_pass_1 : input_data_array(3 downto 0);
    signal soft_input_4_2_4_pass_1 : input_data_array(3 downto 0);
    signal soft_input_4_3_1_pass_1 : input_data_array(3 downto 0);
    signal soft_input_4_3_2_pass_1 : input_data_array(3 downto 0);
    signal soft_input_4_3_3_pass_1 : input_data_array(3 downto 0);
    signal soft_input_4_3_4_pass_1 : input_data_array(3 downto 0);
    signal soft_input_4_4_1_pass_1 : input_data_array(3 downto 0);
    signal soft_input_4_4_2_pass_1 : input_data_array(3 downto 0);
    signal soft_input_4_4_3_pass_1 : input_data_array(3 downto 0);
    signal soft_input_4_4_4_pass_1 : input_data_array(3 downto 0);
    signal soft_input_unflipped_6  : input_data_array(255 downto 0);
    --------------------------------------------------------------------------------------------
    -- CLK 6
    signal soft_input_pass_5_ext       : input_data_array(data_length downto 0);
    signal hard_input_5_ext            : std_logic_vector(data_length downto 0);
    signal weight_in_5_ext             : std_logic_vector(9 downto 0);
    signal corrections_in_5_ext        : std_logic_vector(index_length downto 0);
    signal error_position_5_ext        : output_error_location_array(index_length downto 0);
    signal indi_1_1_1_pass_1_ext       : std_logic_vector(2 downto 0);
    signal indi_1_1_2_pass_1_ext       : std_logic_vector(2 downto 0);
    signal indi_1_1_3_pass_1_ext       : std_logic_vector(2 downto 0);
    signal indi_1_1_4_pass_1_ext       : std_logic_vector(2 downto 0);
    signal indi_1_2_1_pass_1_ext       : std_logic_vector(2 downto 0);
    signal indi_1_2_2_pass_1_ext       : std_logic_vector(2 downto 0);
    signal indi_1_2_3_pass_1_ext       : std_logic_vector(2 downto 0);
    signal indi_1_2_4_pass_1_ext       : std_logic_vector(2 downto 0);
    signal indi_1_3_1_pass_1_ext       : std_logic_vector(2 downto 0);
    signal indi_1_3_2_pass_1_ext       : std_logic_vector(2 downto 0);
    signal indi_1_3_3_pass_1_ext       : std_logic_vector(2 downto 0);
    signal indi_1_3_4_pass_1_ext       : std_logic_vector(2 downto 0);
    signal indi_1_4_1_pass_1_ext       : std_logic_vector(2 downto 0);
    signal indi_1_4_2_pass_1_ext       : std_logic_vector(2 downto 0);
    signal indi_1_4_3_pass_1_ext       : std_logic_vector(2 downto 0);
    signal indi_1_4_4_pass_1_ext       : std_logic_vector(2 downto 0);
    signal indi_2_1_1_pass_1_ext       : std_logic_vector(2 downto 0);
    signal indi_2_1_2_pass_1_ext       : std_logic_vector(2 downto 0);
    signal indi_2_1_3_pass_1_ext       : std_logic_vector(2 downto 0);
    signal indi_2_1_4_pass_1_ext       : std_logic_vector(2 downto 0);
    signal indi_2_2_1_pass_1_ext       : std_logic_vector(2 downto 0);
    signal indi_2_2_2_pass_1_ext       : std_logic_vector(2 downto 0);
    signal indi_2_2_3_pass_1_ext       : std_logic_vector(2 downto 0);
    signal indi_2_2_4_pass_1_ext       : std_logic_vector(2 downto 0);
    signal indi_2_3_1_pass_1_ext       : std_logic_vector(2 downto 0);
    signal indi_2_3_2_pass_1_ext       : std_logic_vector(2 downto 0);
    signal indi_2_3_3_pass_1_ext       : std_logic_vector(2 downto 0);
    signal indi_2_3_4_pass_1_ext       : std_logic_vector(2 downto 0);
    signal indi_2_4_1_pass_1_ext       : std_logic_vector(2 downto 0);
    signal indi_2_4_2_pass_1_ext       : std_logic_vector(2 downto 0);
    signal indi_2_4_3_pass_1_ext       : std_logic_vector(2 downto 0);
    signal indi_2_4_4_pass_1_ext       : std_logic_vector(2 downto 0);
    signal indi_3_1_1_pass_1_ext       : std_logic_vector(2 downto 0);
    signal indi_3_1_2_pass_1_ext       : std_logic_vector(2 downto 0);
    signal indi_3_1_3_pass_1_ext       : std_logic_vector(2 downto 0);
    signal indi_3_1_4_pass_1_ext       : std_logic_vector(2 downto 0);
    signal indi_3_2_1_pass_1_ext       : std_logic_vector(2 downto 0);
    signal indi_3_2_2_pass_1_ext       : std_logic_vector(2 downto 0);
    signal indi_3_2_3_pass_1_ext       : std_logic_vector(2 downto 0);
    signal indi_3_2_4_pass_1_ext       : std_logic_vector(2 downto 0);
    signal indi_3_3_1_pass_1_ext       : std_logic_vector(2 downto 0);
    signal indi_3_3_2_pass_1_ext       : std_logic_vector(2 downto 0);
    signal indi_3_3_3_pass_1_ext       : std_logic_vector(2 downto 0);
    signal indi_3_3_4_pass_1_ext       : std_logic_vector(2 downto 0);
    signal indi_3_4_1_pass_1_ext       : std_logic_vector(2 downto 0);
    signal indi_3_4_2_pass_1_ext       : std_logic_vector(2 downto 0);
    signal indi_3_4_3_pass_1_ext       : std_logic_vector(2 downto 0);
    signal indi_3_4_4_pass_1_ext       : std_logic_vector(2 downto 0);
    signal soft_input_1_1_1_pass_2_ext : input_data_array(3 downto 0);
    signal soft_input_1_1_2_pass_2_ext : input_data_array(3 downto 0);
    signal soft_input_1_1_3_pass_2_ext : input_data_array(3 downto 0);
    signal soft_input_1_1_4_pass_2_ext : input_data_array(3 downto 0);
    signal soft_input_1_2_1_pass_2_ext : input_data_array(3 downto 0);
    signal soft_input_1_2_2_pass_2_ext : input_data_array(3 downto 0);
    signal soft_input_1_2_3_pass_2_ext : input_data_array(3 downto 0);
    signal soft_input_1_2_4_pass_2_ext : input_data_array(3 downto 0);
    signal soft_input_1_3_1_pass_2_ext : input_data_array(3 downto 0);
    signal soft_input_1_3_2_pass_2_ext : input_data_array(3 downto 0);
    signal soft_input_1_3_3_pass_2_ext : input_data_array(3 downto 0);
    signal soft_input_1_3_4_pass_2_ext : input_data_array(3 downto 0);
    signal soft_input_1_4_1_pass_2_ext : input_data_array(3 downto 0);
    signal soft_input_1_4_2_pass_2_ext : input_data_array(3 downto 0);
    signal soft_input_1_4_3_pass_2_ext : input_data_array(3 downto 0);
    signal soft_input_1_4_4_pass_2_ext : input_data_array(3 downto 0);
    signal soft_input_2_1_1_pass_2_ext : input_data_array(3 downto 0);
    signal soft_input_2_1_2_pass_2_ext : input_data_array(3 downto 0);
    signal soft_input_2_1_3_pass_2_ext : input_data_array(3 downto 0);
    signal soft_input_2_1_4_pass_2_ext : input_data_array(3 downto 0);
    signal soft_input_2_2_1_pass_2_ext : input_data_array(3 downto 0);
    signal soft_input_2_2_2_pass_2_ext : input_data_array(3 downto 0);
    signal soft_input_2_2_3_pass_2_ext : input_data_array(3 downto 0);
    signal soft_input_2_2_4_pass_2_ext : input_data_array(3 downto 0);
    signal soft_input_2_3_1_pass_2_ext : input_data_array(3 downto 0);
    signal soft_input_2_3_2_pass_2_ext : input_data_array(3 downto 0);
    signal soft_input_2_3_3_pass_2_ext : input_data_array(3 downto 0);
    signal soft_input_2_3_4_pass_2_ext : input_data_array(3 downto 0);
    signal soft_input_2_4_1_pass_2_ext : input_data_array(3 downto 0);
    signal soft_input_2_4_2_pass_2_ext : input_data_array(3 downto 0);
    signal soft_input_2_4_3_pass_2_ext : input_data_array(3 downto 0);
    signal soft_input_2_4_4_pass_2_ext : input_data_array(3 downto 0);
    signal soft_input_3_1_1_pass_2_ext : input_data_array(3 downto 0);
    signal soft_input_3_1_2_pass_2_ext : input_data_array(3 downto 0);
    signal soft_input_3_1_3_pass_2_ext : input_data_array(3 downto 0);
    signal soft_input_3_1_4_pass_2_ext : input_data_array(3 downto 0);
    signal soft_input_3_2_1_pass_2_ext : input_data_array(3 downto 0);
    signal soft_input_3_2_2_pass_2_ext : input_data_array(3 downto 0);
    signal soft_input_3_2_3_pass_2_ext : input_data_array(3 downto 0);
    signal soft_input_3_2_4_pass_2_ext : input_data_array(3 downto 0);
    signal soft_input_3_3_1_pass_2_ext : input_data_array(3 downto 0);
    signal soft_input_3_3_2_pass_2_ext : input_data_array(3 downto 0);
    signal soft_input_3_3_3_pass_2_ext : input_data_array(3 downto 0);
    signal soft_input_3_3_4_pass_2_ext : input_data_array(3 downto 0);
    signal soft_input_3_4_1_pass_2_ext : input_data_array(3 downto 0);
    signal soft_input_3_4_2_pass_2_ext : input_data_array(3 downto 0);
    signal soft_input_3_4_3_pass_2_ext : input_data_array(3 downto 0);
    signal soft_input_3_4_4_pass_2_ext : input_data_array(3 downto 0);
    signal soft_input_4_1_1_pass_2_ext : input_data_array(3 downto 0);
    signal soft_input_4_1_2_pass_2_ext : input_data_array(3 downto 0);
    signal soft_input_4_1_3_pass_2_ext : input_data_array(3 downto 0);
    signal soft_input_4_1_4_pass_2_ext : input_data_array(3 downto 0);
    signal soft_input_4_2_1_pass_2_ext : input_data_array(3 downto 0);
    signal soft_input_4_2_2_pass_2_ext : input_data_array(3 downto 0);
    signal soft_input_4_2_3_pass_2_ext : input_data_array(3 downto 0);
    signal soft_input_4_2_4_pass_2_ext : input_data_array(3 downto 0);
    signal soft_input_4_3_1_pass_2_ext : input_data_array(3 downto 0);
    signal soft_input_4_3_2_pass_2_ext : input_data_array(3 downto 0);
    signal soft_input_4_3_3_pass_2_ext : input_data_array(3 downto 0);
    signal soft_input_4_3_4_pass_2_ext : input_data_array(3 downto 0);
    signal soft_input_4_4_1_pass_2_ext : input_data_array(3 downto 0);
    signal soft_input_4_4_2_pass_2_ext : input_data_array(3 downto 0);
    signal soft_input_4_4_3_pass_2_ext : input_data_array(3 downto 0);
    signal soft_input_4_4_4_pass_2_ext : input_data_array(3 downto 0);
    signal digit_1                     : integer;
    signal digit_2                     : integer;
    signal digit_3                     : integer;
    signal soft_input_unflipped_7      : input_data_array(255 downto 0);
    --------------------------------------------------------------------------------------------
    -- CLK 7
    signal digit_2_pass            : integer;
    signal digit_3_pass            : integer;
    signal soft_input_pass_5       : input_data_array(data_length downto 0);
    signal hard_input_5            : std_logic_vector(data_length downto 0);
    signal corrections_in_5        : std_logic_vector(index_length downto 0);
    signal error_position_5        : output_error_location_array(index_length downto 0);
    signal weight_in_5             : std_logic_vector(9 downto 0);
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
    signal soft_input_1_1_1_pass_2 : input_data_array(3 downto 0);
    signal soft_input_1_1_2_pass_2 : input_data_array(3 downto 0);
    signal soft_input_1_1_3_pass_2 : input_data_array(3 downto 0);
    signal soft_input_1_1_4_pass_2 : input_data_array(3 downto 0);
    signal soft_input_1_2_1_pass_2 : input_data_array(3 downto 0);
    signal soft_input_1_2_2_pass_2 : input_data_array(3 downto 0);
    signal soft_input_1_2_3_pass_2 : input_data_array(3 downto 0);
    signal soft_input_1_2_4_pass_2 : input_data_array(3 downto 0);
    signal soft_input_1_3_1_pass_2 : input_data_array(3 downto 0);
    signal soft_input_1_3_2_pass_2 : input_data_array(3 downto 0);
    signal soft_input_1_3_3_pass_2 : input_data_array(3 downto 0);
    signal soft_input_1_3_4_pass_2 : input_data_array(3 downto 0);
    signal soft_input_1_4_1_pass_2 : input_data_array(3 downto 0);
    signal soft_input_1_4_2_pass_2 : input_data_array(3 downto 0);
    signal soft_input_1_4_3_pass_2 : input_data_array(3 downto 0);
    signal soft_input_1_4_4_pass_2 : input_data_array(3 downto 0);
    signal soft_input_2_1_1_pass_2 : input_data_array(3 downto 0);
    signal soft_input_2_1_2_pass_2 : input_data_array(3 downto 0);
    signal soft_input_2_1_3_pass_2 : input_data_array(3 downto 0);
    signal soft_input_2_1_4_pass_2 : input_data_array(3 downto 0);
    signal soft_input_2_2_1_pass_2 : input_data_array(3 downto 0);
    signal soft_input_2_2_2_pass_2 : input_data_array(3 downto 0);
    signal soft_input_2_2_3_pass_2 : input_data_array(3 downto 0);
    signal soft_input_2_2_4_pass_2 : input_data_array(3 downto 0);
    signal soft_input_2_3_1_pass_2 : input_data_array(3 downto 0);
    signal soft_input_2_3_2_pass_2 : input_data_array(3 downto 0);
    signal soft_input_2_3_3_pass_2 : input_data_array(3 downto 0);
    signal soft_input_2_3_4_pass_2 : input_data_array(3 downto 0);
    signal soft_input_2_4_1_pass_2 : input_data_array(3 downto 0);
    signal soft_input_2_4_2_pass_2 : input_data_array(3 downto 0);
    signal soft_input_2_4_3_pass_2 : input_data_array(3 downto 0);
    signal soft_input_2_4_4_pass_2 : input_data_array(3 downto 0);
    signal soft_input_3_1_1_pass_2 : input_data_array(3 downto 0);
    signal soft_input_3_1_2_pass_2 : input_data_array(3 downto 0);
    signal soft_input_3_1_3_pass_2 : input_data_array(3 downto 0);
    signal soft_input_3_1_4_pass_2 : input_data_array(3 downto 0);
    signal soft_input_3_2_1_pass_2 : input_data_array(3 downto 0);
    signal soft_input_3_2_2_pass_2 : input_data_array(3 downto 0);
    signal soft_input_3_2_3_pass_2 : input_data_array(3 downto 0);
    signal soft_input_3_2_4_pass_2 : input_data_array(3 downto 0);
    signal soft_input_3_3_1_pass_2 : input_data_array(3 downto 0);
    signal soft_input_3_3_2_pass_2 : input_data_array(3 downto 0);
    signal soft_input_3_3_3_pass_2 : input_data_array(3 downto 0);
    signal soft_input_3_3_4_pass_2 : input_data_array(3 downto 0);
    signal soft_input_3_4_1_pass_2 : input_data_array(3 downto 0);
    signal soft_input_3_4_2_pass_2 : input_data_array(3 downto 0);
    signal soft_input_3_4_3_pass_2 : input_data_array(3 downto 0);
    signal soft_input_3_4_4_pass_2 : input_data_array(3 downto 0);
    signal soft_input_4_1_1_pass_2 : input_data_array(3 downto 0);
    signal soft_input_4_1_2_pass_2 : input_data_array(3 downto 0);
    signal soft_input_4_1_3_pass_2 : input_data_array(3 downto 0);
    signal soft_input_4_1_4_pass_2 : input_data_array(3 downto 0);
    signal soft_input_4_2_1_pass_2 : input_data_array(3 downto 0);
    signal soft_input_4_2_2_pass_2 : input_data_array(3 downto 0);
    signal soft_input_4_2_3_pass_2 : input_data_array(3 downto 0);
    signal soft_input_4_2_4_pass_2 : input_data_array(3 downto 0);
    signal soft_input_4_3_1_pass_2 : input_data_array(3 downto 0);
    signal soft_input_4_3_2_pass_2 : input_data_array(3 downto 0);
    signal soft_input_4_3_3_pass_2 : input_data_array(3 downto 0);
    signal soft_input_4_3_4_pass_2 : input_data_array(3 downto 0);
    signal soft_input_4_4_1_pass_2 : input_data_array(3 downto 0);
    signal soft_input_4_4_2_pass_2 : input_data_array(3 downto 0);
    signal soft_input_4_4_3_pass_2 : input_data_array(3 downto 0);
    signal soft_input_4_4_4_pass_2 : input_data_array(3 downto 0);
    signal weight_info_1_r1        : std_logic_vector(7 downto 0);
    signal weight_info_1_r2        : std_logic_vector(7 downto 0);
    signal weight_info_1_r3        : std_logic_vector(7 downto 0);
    signal weight_info_1_r4        : std_logic_vector(7 downto 0);
    signal weight_info_1_r5        : std_logic_vector(7 downto 0);
    signal weight_info_1_r6        : std_logic_vector(7 downto 0);
    signal weight_info_1_r7        : std_logic_vector(7 downto 0);
    signal weight_info_1_r8        : std_logic_vector(7 downto 0);
    signal weight_info_1_r9        : std_logic_vector(7 downto 0);
    signal weight_info_1_r10       : std_logic_vector(7 downto 0);
    signal weight_info_1_r11       : std_logic_vector(7 downto 0);
    signal weight_info_1_r12       : std_logic_vector(7 downto 0);
    signal weight_info_1_r13       : std_logic_vector(7 downto 0);
    signal weight_info_1_r14       : std_logic_vector(7 downto 0);
    signal weight_info_1_r15       : std_logic_vector(7 downto 0);
    signal weight_info_1_r16       : std_logic_vector(7 downto 0);
    signal soft_input_unflipped_8  : input_data_array(255 downto 0);
    --------------------------------------------------------------------------------------------
    -- CLK 8
    signal weight_info_1_p1        : std_logic_vector(7 downto 0);
    signal weight_info_1_p2        : std_logic_vector(7 downto 0);
    signal weight_info_1_p3        : std_logic_vector(7 downto 0);
    signal weight_info_1_p4        : std_logic_vector(7 downto 0);
    signal digit_3_pass_1          : integer;
    signal weight_in_6             : std_logic_vector(9 downto 0);
    signal soft_input_pass_6       : input_data_array(data_length downto 0);
    signal hard_input_6            : std_logic_vector(data_length downto 0);
    signal corrections_in_6        : std_logic_vector(index_length downto 0);
    signal error_position_6        : output_error_location_array(index_length downto 0);
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
    signal soft_input_1_1_1_pass_3 : input_data_array(3 downto 0);
    signal soft_input_1_1_2_pass_3 : input_data_array(3 downto 0);
    signal soft_input_1_1_3_pass_3 : input_data_array(3 downto 0);
    signal soft_input_1_1_4_pass_3 : input_data_array(3 downto 0);
    signal soft_input_1_2_1_pass_3 : input_data_array(3 downto 0);
    signal soft_input_1_2_2_pass_3 : input_data_array(3 downto 0);
    signal soft_input_1_2_3_pass_3 : input_data_array(3 downto 0);
    signal soft_input_1_2_4_pass_3 : input_data_array(3 downto 0);
    signal soft_input_1_3_1_pass_3 : input_data_array(3 downto 0);
    signal soft_input_1_3_2_pass_3 : input_data_array(3 downto 0);
    signal soft_input_1_3_3_pass_3 : input_data_array(3 downto 0);
    signal soft_input_1_3_4_pass_3 : input_data_array(3 downto 0);
    signal soft_input_1_4_1_pass_3 : input_data_array(3 downto 0);
    signal soft_input_1_4_2_pass_3 : input_data_array(3 downto 0);
    signal soft_input_1_4_3_pass_3 : input_data_array(3 downto 0);
    signal soft_input_1_4_4_pass_3 : input_data_array(3 downto 0);
    signal soft_input_2_1_1_pass_3 : input_data_array(3 downto 0);
    signal soft_input_2_1_2_pass_3 : input_data_array(3 downto 0);
    signal soft_input_2_1_3_pass_3 : input_data_array(3 downto 0);
    signal soft_input_2_1_4_pass_3 : input_data_array(3 downto 0);
    signal soft_input_2_2_1_pass_3 : input_data_array(3 downto 0);
    signal soft_input_2_2_2_pass_3 : input_data_array(3 downto 0);
    signal soft_input_2_2_3_pass_3 : input_data_array(3 downto 0);
    signal soft_input_2_2_4_pass_3 : input_data_array(3 downto 0);
    signal soft_input_2_3_1_pass_3 : input_data_array(3 downto 0);
    signal soft_input_2_3_2_pass_3 : input_data_array(3 downto 0);
    signal soft_input_2_3_3_pass_3 : input_data_array(3 downto 0);
    signal soft_input_2_3_4_pass_3 : input_data_array(3 downto 0);
    signal soft_input_2_4_1_pass_3 : input_data_array(3 downto 0);
    signal soft_input_2_4_2_pass_3 : input_data_array(3 downto 0);
    signal soft_input_2_4_3_pass_3 : input_data_array(3 downto 0);
    signal soft_input_2_4_4_pass_3 : input_data_array(3 downto 0);
    signal soft_input_3_1_1_pass_3 : input_data_array(3 downto 0);
    signal soft_input_3_1_2_pass_3 : input_data_array(3 downto 0);
    signal soft_input_3_1_3_pass_3 : input_data_array(3 downto 0);
    signal soft_input_3_1_4_pass_3 : input_data_array(3 downto 0);
    signal soft_input_3_2_1_pass_3 : input_data_array(3 downto 0);
    signal soft_input_3_2_2_pass_3 : input_data_array(3 downto 0);
    signal soft_input_3_2_3_pass_3 : input_data_array(3 downto 0);
    signal soft_input_3_2_4_pass_3 : input_data_array(3 downto 0);
    signal soft_input_3_3_1_pass_3 : input_data_array(3 downto 0);
    signal soft_input_3_3_2_pass_3 : input_data_array(3 downto 0);
    signal soft_input_3_3_3_pass_3 : input_data_array(3 downto 0);
    signal soft_input_3_3_4_pass_3 : input_data_array(3 downto 0);
    signal soft_input_3_4_1_pass_3 : input_data_array(3 downto 0);
    signal soft_input_3_4_2_pass_3 : input_data_array(3 downto 0);
    signal soft_input_3_4_3_pass_3 : input_data_array(3 downto 0);
    signal soft_input_3_4_4_pass_3 : input_data_array(3 downto 0);
    signal soft_input_4_1_1_pass_3 : input_data_array(3 downto 0);
    signal soft_input_4_1_2_pass_3 : input_data_array(3 downto 0);
    signal soft_input_4_1_3_pass_3 : input_data_array(3 downto 0);
    signal soft_input_4_1_4_pass_3 : input_data_array(3 downto 0);
    signal soft_input_4_2_1_pass_3 : input_data_array(3 downto 0);
    signal soft_input_4_2_2_pass_3 : input_data_array(3 downto 0);
    signal soft_input_4_2_3_pass_3 : input_data_array(3 downto 0);
    signal soft_input_4_2_4_pass_3 : input_data_array(3 downto 0);
    signal soft_input_4_3_1_pass_3 : input_data_array(3 downto 0);
    signal soft_input_4_3_2_pass_3 : input_data_array(3 downto 0);
    signal soft_input_4_3_3_pass_3 : input_data_array(3 downto 0);
    signal soft_input_4_3_4_pass_3 : input_data_array(3 downto 0);
    signal soft_input_4_4_1_pass_3 : input_data_array(3 downto 0);
    signal soft_input_4_4_2_pass_3 : input_data_array(3 downto 0);
    signal soft_input_4_4_3_pass_3 : input_data_array(3 downto 0);
    signal soft_input_4_4_4_pass_3 : input_data_array(3 downto 0);
    signal weight_info_2           : std_logic_vector(7 downto 0);
    signal weight_info_1_pass      : std_logic_vector(7 downto 0);
    signal weight_info_2_r1        : std_logic_vector(7 downto 0);
    signal weight_info_2_r2        : std_logic_vector(7 downto 0);
    signal weight_info_2_r3        : std_logic_vector(7 downto 0);
    signal weight_info_2_r4        : std_logic_vector(7 downto 0);
    signal weight_info_2_r5        : std_logic_vector(7 downto 0);
    signal weight_info_2_r6        : std_logic_vector(7 downto 0);
    signal weight_info_2_r7        : std_logic_vector(7 downto 0);
    signal weight_info_2_r8        : std_logic_vector(7 downto 0);
    signal weight_info_2_r9        : std_logic_vector(7 downto 0);
    signal weight_info_2_r10       : std_logic_vector(7 downto 0);
    signal weight_info_2_r11       : std_logic_vector(7 downto 0);
    signal weight_info_2_r12       : std_logic_vector(7 downto 0);
    signal weight_info_2_r13       : std_logic_vector(7 downto 0);
    signal weight_info_2_r14       : std_logic_vector(7 downto 0);
    signal weight_info_2_r15       : std_logic_vector(7 downto 0);
    signal weight_info_2_r16       : std_logic_vector(7 downto 0);
    signal soft_input_unflipped_9  : input_data_array(255 downto 0);
    --------------------------------------------------------------------------------------------
    -- CLK 9
    signal weight_info_2_p1        : std_logic_vector(7 downto 0);
    signal weight_info_2_p2        : std_logic_vector(7 downto 0);
    signal weight_info_2_p3        : std_logic_vector(7 downto 0);
    signal weight_info_2_p4        : std_logic_vector(7 downto 0);
    signal weight_info_1           : std_logic_vector(7 downto 0);
    signal soft_input_pass_7       : input_data_array(data_length downto 0);
    signal hard_input_7            : std_logic_vector(data_length downto 0);
    signal corrections_in_7        : std_logic_vector(index_length downto 0);
    signal error_position_7        : output_error_location_array(index_length downto 0);
    signal weight_info_3           : std_logic_vector(7 downto 0);
    signal weight_info_2_pass      : std_logic_vector(7 downto 0);
    signal weight_info_1_pass_1    : std_logic_vector(7 downto 0);
    signal weight_in_7             : std_logic_vector(9 downto 0);
    signal weight_info_3abs        : std_logic_vector(7 downto 0);
    signal weight_info_1_pass_1abs : std_logic_vector(7 downto 0);
    signal weight_info_2_passabs   : std_logic_vector(7 downto 0);
    signal weight_info_3_r1        : std_logic_vector(7 downto 0);
    signal weight_info_3_r2        : std_logic_vector(7 downto 0);
    signal weight_info_3_r3        : std_logic_vector(7 downto 0);
    signal weight_info_3_r4        : std_logic_vector(7 downto 0);
    signal weight_info_3_r5        : std_logic_vector(7 downto 0);
    signal weight_info_3_r6        : std_logic_vector(7 downto 0);
    signal weight_info_3_r7        : std_logic_vector(7 downto 0);
    signal weight_info_3_r8        : std_logic_vector(7 downto 0);
    signal weight_info_3_r9        : std_logic_vector(7 downto 0);
    signal weight_info_3_r10       : std_logic_vector(7 downto 0);
    signal weight_info_3_r11       : std_logic_vector(7 downto 0);
    signal weight_info_3_r12       : std_logic_vector(7 downto 0);
    signal weight_info_3_r13       : std_logic_vector(7 downto 0);
    signal weight_info_3_r14       : std_logic_vector(7 downto 0);
    signal weight_info_3_r15       : std_logic_vector(7 downto 0);
    signal weight_info_3_r16       : std_logic_vector(7 downto 0);
    signal soft_input_unflipped_10 : input_data_array(255 downto 0);
    signal soft_input_1_1_1_pass_4 : input_data_array(3 downto 0);
    signal soft_input_1_1_2_pass_4 : input_data_array(3 downto 0);
    signal soft_input_1_1_3_pass_4 : input_data_array(3 downto 0);
    signal soft_input_1_1_4_pass_4 : input_data_array(3 downto 0);
    signal soft_input_1_2_1_pass_4 : input_data_array(3 downto 0);
    signal soft_input_1_2_2_pass_4 : input_data_array(3 downto 0);
    signal soft_input_1_2_3_pass_4 : input_data_array(3 downto 0);
    signal soft_input_1_2_4_pass_4 : input_data_array(3 downto 0);
    signal soft_input_1_3_1_pass_4 : input_data_array(3 downto 0);
    signal soft_input_1_3_2_pass_4 : input_data_array(3 downto 0);
    signal soft_input_1_3_3_pass_4 : input_data_array(3 downto 0);
    signal soft_input_1_3_4_pass_4 : input_data_array(3 downto 0);
    signal soft_input_1_4_1_pass_4 : input_data_array(3 downto 0);
    signal soft_input_1_4_2_pass_4 : input_data_array(3 downto 0);
    signal soft_input_1_4_3_pass_4 : input_data_array(3 downto 0);
    signal soft_input_1_4_4_pass_4 : input_data_array(3 downto 0);
    signal soft_input_2_1_1_pass_4 : input_data_array(3 downto 0);
    signal soft_input_2_1_2_pass_4 : input_data_array(3 downto 0);
    signal soft_input_2_1_3_pass_4 : input_data_array(3 downto 0);
    signal soft_input_2_1_4_pass_4 : input_data_array(3 downto 0);
    signal soft_input_2_2_1_pass_4 : input_data_array(3 downto 0);
    signal soft_input_2_2_2_pass_4 : input_data_array(3 downto 0);
    signal soft_input_2_2_3_pass_4 : input_data_array(3 downto 0);
    signal soft_input_2_2_4_pass_4 : input_data_array(3 downto 0);
    signal soft_input_2_3_1_pass_4 : input_data_array(3 downto 0);
    signal soft_input_2_3_2_pass_4 : input_data_array(3 downto 0);
    signal soft_input_2_3_3_pass_4 : input_data_array(3 downto 0);
    signal soft_input_2_3_4_pass_4 : input_data_array(3 downto 0);
    signal soft_input_2_4_1_pass_4 : input_data_array(3 downto 0);
    signal soft_input_2_4_2_pass_4 : input_data_array(3 downto 0);
    signal soft_input_2_4_3_pass_4 : input_data_array(3 downto 0);
    signal soft_input_2_4_4_pass_4 : input_data_array(3 downto 0);
    signal soft_input_3_1_1_pass_4 : input_data_array(3 downto 0);
    signal soft_input_3_1_2_pass_4 : input_data_array(3 downto 0);
    signal soft_input_3_1_3_pass_4 : input_data_array(3 downto 0);
    signal soft_input_3_1_4_pass_4 : input_data_array(3 downto 0);
    signal soft_input_3_2_1_pass_4 : input_data_array(3 downto 0);
    signal soft_input_3_2_2_pass_4 : input_data_array(3 downto 0);
    signal soft_input_3_2_3_pass_4 : input_data_array(3 downto 0);
    signal soft_input_3_2_4_pass_4 : input_data_array(3 downto 0);
    signal soft_input_3_3_1_pass_4 : input_data_array(3 downto 0);
    signal soft_input_3_3_2_pass_4 : input_data_array(3 downto 0);
    signal soft_input_3_3_3_pass_4 : input_data_array(3 downto 0);
    signal soft_input_3_3_4_pass_4 : input_data_array(3 downto 0);
    signal soft_input_3_4_1_pass_4 : input_data_array(3 downto 0);
    signal soft_input_3_4_2_pass_4 : input_data_array(3 downto 0);
    signal soft_input_3_4_3_pass_4 : input_data_array(3 downto 0);
    signal soft_input_3_4_4_pass_4 : input_data_array(3 downto 0);
    signal soft_input_4_1_1_pass_4 : input_data_array(3 downto 0);
    signal soft_input_4_1_2_pass_4 : input_data_array(3 downto 0);
    signal soft_input_4_1_3_pass_4 : input_data_array(3 downto 0);
    signal soft_input_4_1_4_pass_4 : input_data_array(3 downto 0);
    signal soft_input_4_2_1_pass_4 : input_data_array(3 downto 0);
    signal soft_input_4_2_2_pass_4 : input_data_array(3 downto 0);
    signal soft_input_4_2_3_pass_4 : input_data_array(3 downto 0);
    signal soft_input_4_2_4_pass_4 : input_data_array(3 downto 0);
    signal soft_input_4_3_1_pass_4 : input_data_array(3 downto 0);
    signal soft_input_4_3_2_pass_4 : input_data_array(3 downto 0);
    signal soft_input_4_3_3_pass_4 : input_data_array(3 downto 0);
    signal soft_input_4_3_4_pass_4 : input_data_array(3 downto 0);
    signal soft_input_4_4_1_pass_4 : input_data_array(3 downto 0);
    signal soft_input_4_4_2_pass_4 : input_data_array(3 downto 0);
    signal soft_input_4_4_3_pass_4 : input_data_array(3 downto 0);
    signal soft_input_4_4_4_pass_4 : input_data_array(3 downto 0);
    --------------------------------------------------------------------------------------------
    -- CLK 10
    signal soft_input_pass_100     : input_data_array(data_length downto 0);
    signal hard_input_100          : std_logic_vector(data_length downto 0);
    signal weight_in_100           : std_logic_vector(9 downto 0);
    signal corrections_in_100      : std_logic_vector(index_length downto 0);
    signal error_position_100      : output_error_location_array(index_length downto 0);
    signal weight_info_3_p1        : std_logic_vector(7 downto 0);
    signal weight_info_3_p2        : std_logic_vector(7 downto 0);
    signal weight_info_3_p3        : std_logic_vector(7 downto 0);
    signal weight_info_3_p4        : std_logic_vector(7 downto 0);
    signal soft_input_unflipped_11 : input_data_array(255 downto 0);
    --------------------------------------------------------------------------------------------
    -- CLK 11
    signal soft_input_pass_110     : input_data_array(data_length downto 0);
    signal hard_input_110          : std_logic_vector(data_length downto 0);
    signal weight_in_110           : std_logic_vector(9 downto 0);
    signal corrections_in_110      : std_logic_vector(index_length downto 0);
    signal error_position_110      : output_error_location_array(index_length downto 0);
    signal soft_input_unflipped_12 : input_data_array(255 downto 0);
    --------------------------------------------------------------------------------------------
    -- CLK 10
    signal soft_input_pass_8       : input_data_array(data_length downto 0);
    signal hard_input_8            : std_logic_vector(data_length downto 0);
    signal corrections_in_8        : std_logic_vector(index_length downto 0);
    signal error_position_8        : output_error_location_array(index_length downto 0);
    signal weight_info_3abs_1      : std_logic_vector(7 downto 0);
    signal weight_in_8             : std_logic_vector(9 downto 0);
    signal sum_1                   : std_logic_vector(8 downto 0);
    signal weight_in_9             : std_logic_vector(9 downto 0);
    signal soft_input_unflipped_13 : input_data_array(255 downto 0);
    --------------------------------------------------------------------------------------------
    -- CLK 11
    signal soft_input_pass_9       : input_data_array(data_length downto 0);
    signal hard_input_9            : std_logic_vector(data_length downto 0);
    signal corrections_in_9        : std_logic_vector(index_length downto 0);
    signal error_position_9        : output_error_location_array(index_length downto 0);
    signal sum_2                   : std_logic_vector(9 downto 0);
    signal weight_in_10            : std_logic_vector(9 downto 0);
    signal soft_input_unflipped_14 : input_data_array(255 downto 0);
    --------------------------------------------------------------------------------------------
    -- CLK 12
    signal soft_input_pass_10      : input_data_array(data_length downto 0);
    signal hard_input_10           : std_logic_vector(data_length downto 0);
    signal corrections_in_10       : std_logic_vector(index_length downto 0);
    signal error_position_10       : output_error_location_array(index_length downto 0);
    signal sum_3                   : std_logic_vector(10 downto 0);
    signal soft_input_unflipped_15 : input_data_array(255 downto 0);
    --------------------------------------------------------------------------------------------
    -- CLK 13
    signal soft_input_pass_11      : input_data_array(data_length downto 0);
    signal hard_input_11           : std_logic_vector(data_length downto 0);
    signal corrections_in_11       : std_logic_vector(index_length downto 0);
    signal error_position_11       : output_error_location_array(index_length downto 0);
    signal soft_input_unflipped_16 : input_data_array(255 downto 0);
begin
    ------------------------------------------------------------------------------------------------------------
    -- Define processes : (CLK 0)
    ------------------------------------------------------------------------------------------------------------
    process (clk, reset)
    begin
        if (reset = '1') then
            soft_input_in           <= (others => (others => '0'));
            hard_input_in           <= (others => '0');
            error_position_in       <= (others => 0);
            corrections_in_in       <= (others => '0');
            weight_in_in            <= (others => '0');
            soft_input_unflipped_in <= (others => (others => '0'));
            index_in_w1_1           <= (others => (others => '0'));
        elsif (rising_edge(clk)) then
            soft_input_in           <= soft_input;
            hard_input_in           <= hard_input;
            error_position_in       <= error_position;
            corrections_in_in       <= corrections_in;
            weight_in_in            <= weight_in;
            soft_input_unflipped_in <= soft_input_unflipped;
            index_in_w1_1           <= index_in_w1;
        end if;
    end process;
    ------------------------------------------------------------------------------------------------------------
    -- Define processes : (CLK 1)
    ------------------------------------------------------------------------------------------------------------
    process (clk, reset)
    begin
        if (reset = '1') then
            soft_input_pass_1      <= (others => (others => '0'));
            hard_input_1           <= (others => '0');
            weight_in_1            <= (others => '0');
            corrections_in_1       <= (others => '0');
            error_position_1       <= (others => 0);
            soft_input_4           <= (others => (others => '0'));
            soft_input_3           <= (others => (others => '0'));
            soft_input_2           <= (others => (others => '0'));
            soft_input_1           <= (others => (others => '0'));
            soft_input_unflipped_1 <= (others => (others => '0'));
            index_in_w1_2_1        <= 0;
            index_in_w1_2_2        <= 0;
            index_in_w1_2_3        <= 0;
        elsif (rising_edge(clk)) then
            soft_input_unflipped_1 <= soft_input_unflipped_in;
            soft_input_4           <= soft_input_in(255 downto 192);
            soft_input_3           <= soft_input_in(191 downto 128);
            soft_input_2           <= soft_input_in(127 downto 64);
            soft_input_1           <= soft_input_in(63 downto 0); -- 0 should be the start of the array
            soft_input_pass_1      <= soft_input_in;
            hard_input_1           <= hard_input_in;
            weight_in_1            <= weight_in_in;
            corrections_in_1       <= corrections_in_in;
            index_in_w1_2_1        <= to_integer(unsigned(index_in_w1_1(0)));
            index_in_w1_2_2        <= to_integer(unsigned(index_in_w1_1(1)));
            index_in_w1_2_3        <= to_integer(unsigned(index_in_w1_1(2)));
            -- This is so stupid...but let's keep it for now, maybe in the future I will change the BCH block to simply this part...
            error_position_1(0) <= error_position_in(0) - 1;
            error_position_1(1) <= error_position_in(1) - 1;
            error_position_1(2) <= error_position_in(2) - 1;
        end if;
    end process;
    ------------------------------------------------------------------------------------------------------------
    -- Define processes : (CLK 1.1)
    ------------------------------------------------------------------------------------------------------------
    process (clk, reset)
    begin
        if (reset = '1') then
            soft_input_pass_1_temp      <= (others => (others => '0'));
            hard_input_1_temp           <= (others => '0');
            weight_in_1_temp            <= (others => '0');
            corrections_in_1_temp       <= (others => '0');
            error_position_1_temp       <= (others => 0);
            soft_input_4_temp           <= (others => (others => '0'));
            soft_input_3_temp           <= (others => (others => '0'));
            soft_input_2_temp           <= (others => (others => '0'));
            soft_input_1_temp           <= (others => (others => '0'));
            soft_input_unflipped_1_temp <= (others => (others => '0'));
        elsif (rising_edge(clk)) then
            soft_input_unflipped_1_temp <= soft_input_unflipped_1;
            soft_input_4_temp           <= soft_input_4;
            soft_input_3_temp           <= soft_input_3;
            soft_input_2_temp           <= soft_input_2;
            soft_input_1_temp           <= soft_input_1;
            soft_input_pass_1_temp      <= soft_input_pass_1;
            hard_input_1_temp           <= hard_input_1;
            weight_in_1_temp            <= weight_in_1;
            corrections_in_1_temp       <= corrections_in_1;
            error_position_1_temp       <= error_position_1;
            index_in_w1_2_1_1           <= index_in_w1_2_1;
            index_in_w1_2_2_1           <= index_in_w1_2_2;
            index_in_w1_2_3_1           <= index_in_w1_2_3;
            if error_position_1(0) = index_in_w1_2_1 then -- flipping location = error location
                corrections_in_1_temp <= "100";
            elsif error_position_1(0) = index_in_w1_2_2 then
                corrections_in_1_temp <= "100";
            elsif error_position_1(0) = index_in_w1_2_3 then
                corrections_in_1_temp <= "100";
            else
                corrections_in_1_temp <= corrections_in_1;
            end if;
        end if;
    end process;
    ------------------------------------------------------------------------------------------------------------
    -- Define processes : (CLK 1.5)
    ------------------------------------------------------------------------------------------------------------
    process (clk, reset)
    begin
        if (reset = '1') then
            soft_input_unflipped_2 <= (others => (others => '0'));
            soft_input_pass_15     <= (others => (others => '0'));
            hard_input_pass_15     <= (others => '0');
            weight_in_pass_15      <= (others => '0');
            corrections_in_pass_15 <= (others => '0');
            error_position_pass_15 <= (others => 0);
            soft_input_4_pass_15   <= (others => (others => '0'));
            soft_input_3_pass_15   <= (others => (others => '0'));
            soft_input_2_pass_15   <= (others => (others => '0'));
            soft_input_1_pass_15   <= (others => (others => '0'));
            flag_1_1               <= false;
            flag_1_2               <= false;
            flag_1_3               <= false;
            flag_1_4               <= false;
            flag_2_1               <= false;
            flag_2_2               <= false;
            flag_2_3               <= false;
            flag_2_4               <= false;
            flag_3_1               <= false;
            flag_3_2               <= false;
            flag_3_3               <= false;
            flag_3_4               <= false;
            index_in_w1_2_1_2      <= 0;
            index_in_w1_2_2_2      <= 0;
            index_in_w1_2_3_2      <= 0;
        elsif (rising_edge(clk)) then
            soft_input_unflipped_2 <= soft_input_unflipped_1_temp;
            soft_input_pass_15     <= soft_input_pass_1_temp;
            hard_input_pass_15     <= hard_input_1_temp;
            weight_in_pass_15      <= weight_in_1_temp;
            corrections_in_pass_15 <= corrections_in_1_temp;
            error_position_pass_15 <= error_position_1_temp;
            soft_input_4_pass_15   <= soft_input_4_temp;
            soft_input_3_pass_15   <= soft_input_3_temp;
            soft_input_2_pass_15   <= soft_input_2_temp;
            soft_input_1_pass_15   <= soft_input_1_temp;
            flag_1_1               <= (-1 < error_position_1_temp(0)) and (error_position_1_temp(0)) < 64;
            flag_1_2               <= (63 < error_position_1_temp(0)) and (error_position_1_temp(0)) < 128;
            flag_1_3               <= (127 < error_position_1_temp(0)) and (error_position_1_temp(0)) < 192;
            flag_1_4               <= (191 < error_position_1_temp(0)) and (error_position_1_temp(0)) < 256;
            flag_2_1               <= (-1 < error_position_1_temp(1)) and (error_position_1_temp(1)) < 64;
            flag_2_2               <= (63 < error_position_1_temp(1)) and (error_position_1_temp(1)) < 128;
            flag_2_3               <= (127 < error_position_1_temp(1)) and (error_position_1_temp(1)) < 192;
            flag_2_4               <= (191 < error_position_1_temp(1)) and (error_position_1_temp(1)) < 256;
            flag_3_1               <= (-1 < error_position_1_temp(2)) and (error_position_1_temp(2)) < 64;
            flag_3_2               <= (63 < error_position_1_temp(2)) and (error_position_1_temp(2)) < 128;
            flag_3_3               <= (127 < error_position_1_temp(2)) and (error_position_1_temp(2)) < 192;
            flag_3_4               <= (191 < error_position_1_temp(2)) and (error_position_1_temp(2)) < 256;
            index_in_w1_2_1_2      <= index_in_w1_2_1_1;
            index_in_w1_2_2_2      <= index_in_w1_2_2_1;
            index_in_w1_2_3_2      <= index_in_w1_2_3_1;
            if error_position_1_temp(1) = index_in_w1_2_1_1 then -- flipping location = error location
                corrections_in_pass_15 <= "100";
            elsif error_position_1_temp(1) = index_in_w1_2_2_1 then
                corrections_in_pass_15 <= "100";
            elsif error_position_1_temp(1) = index_in_w1_2_3_1 then
                corrections_in_pass_15 <= "100";
            else
                corrections_in_pass_15 <= corrections_in_1_temp;
            end if;
        end if;
    end process;
    ------------------------------------------------------------------------------------------------------------
    -- Define processes : (CLK 2)
    ------------------------------------------------------------------------------------------------------------
    process (clk, reset)
    begin
        if (reset = '1') then
            soft_input_unflipped_3 <= (others => (others => '0'));
            soft_input_pass_2      <= (others => (others => '0'));
            hard_input_2           <= (others => '0');
            weight_in_2            <= (others => '0');
            corrections_in_2       <= (others => '0');
            error_position_2       <= (others => 0);
            indi_1                 <= (others => '0');
            indi_2                 <= (others => '0');
            indi_3                 <= (others => '0');
            soft_input_1_4         <= (others => (others => '0'));
            soft_input_1_3         <= (others => (others => '0'));
            soft_input_1_2         <= (others => (others => '0'));
            soft_input_1_1         <= (others => (others => '0'));
            soft_input_2_4         <= (others => (others => '0'));
            soft_input_2_3         <= (others => (others => '0'));
            soft_input_2_2         <= (others => (others => '0'));
            soft_input_2_1         <= (others => (others => '0'));
            soft_input_3_4         <= (others => (others => '0'));
            soft_input_3_3         <= (others => (others => '0'));
            soft_input_3_2         <= (others => (others => '0'));
            soft_input_3_1         <= (others => (others => '0'));
            soft_input_4_4         <= (others => (others => '0'));
            soft_input_4_3         <= (others => (others => '0'));
            soft_input_4_2         <= (others => (others => '0'));
            soft_input_4_1         <= (others => (others => '0'));
        elsif (rising_edge(clk)) then
            soft_input_unflipped_3 <= soft_input_unflipped_2;
            soft_input_pass_2      <= soft_input_pass_15;
            hard_input_2           <= hard_input_pass_15;
            weight_in_2            <= weight_in_pass_15;
            corrections_in_2       <= corrections_in_pass_15;
            error_position_2       <= error_position_pass_15;
            soft_input_1_4         <= soft_input_1_pass_15(63 downto 48);
            soft_input_1_3         <= soft_input_1_pass_15(47 downto 32);
            soft_input_1_2         <= soft_input_1_pass_15(31 downto 16);
            soft_input_1_1         <= soft_input_1_pass_15(15 downto 0);
            soft_input_2_4         <= soft_input_2_pass_15(63 downto 48);
            soft_input_2_3         <= soft_input_2_pass_15(47 downto 32);
            soft_input_2_2         <= soft_input_2_pass_15(31 downto 16);
            soft_input_2_1         <= soft_input_2_pass_15(15 downto 0);
            soft_input_3_4         <= soft_input_3_pass_15(63 downto 48);
            soft_input_3_3         <= soft_input_3_pass_15(47 downto 32);
            soft_input_3_2         <= soft_input_3_pass_15(31 downto 16);
            soft_input_3_1         <= soft_input_3_pass_15(15 downto 0);
            soft_input_4_4         <= soft_input_4_pass_15(63 downto 48);
            soft_input_4_3         <= soft_input_4_pass_15(47 downto 32);
            soft_input_4_2         <= soft_input_4_pass_15(31 downto 16);
            soft_input_4_1         <= soft_input_4_pass_15(15 downto 0);
            if error_position_pass_15(2) = index_in_w1_2_1_2 then -- flipping location = error location
                corrections_in_2 <= "100";
            elsif error_position_pass_15(2) = index_in_w1_2_2_2 then
                corrections_in_2 <= "100";
            elsif error_position_pass_15(2) = index_in_w1_2_3_2 then
                corrections_in_2 <= "100";
            else
                corrections_in_2 <= corrections_in_pass_15;
            end if;
            --------------------error_position_1 category------------------------
            if flag_1_1 then
                indi_1              <= "001";
                error_position_2(0) <= error_position_pass_15(0);
            elsif flag_1_2 then
                indi_1              <= "010";
                error_position_2(0) <= error_position_pass_15(0) - 64;
            elsif flag_1_3 then
                indi_1              <= "011";
                error_position_2(0) <= error_position_pass_15(0) - 128;
            elsif flag_1_4 then
                indi_1              <= "100";
                error_position_2(0) <= error_position_pass_15(0) - 192;
            else
                indi_1              <= "000";
                error_position_2(0) <= error_position_pass_15(0);
            end if;
            ---------------------------------------------------------
            if flag_2_1 then
                indi_2              <= "001";
                error_position_2(1) <= error_position_pass_15(1);
            elsif flag_2_2 then
                indi_2              <= "010";
                error_position_2(1) <= error_position_pass_15(1) - 64;
            elsif flag_2_3 then
                indi_2              <= "011";
                error_position_2(1) <= error_position_pass_15(1) - 128;
            elsif flag_2_4 then
                indi_2              <= "100";
                error_position_2(1) <= error_position_pass_15(1) - 192;
            else
                indi_2              <= "000";
                error_position_2(1) <= error_position_pass_15(1);
            end if;
            ---------------------------------------------------------
            if flag_3_1 then
                indi_3              <= "001";
                error_position_2(2) <= error_position_pass_15(2);
            elsif flag_3_2 then
                indi_3              <= "010";
                error_position_2(2) <= error_position_pass_15(2) - 64;
            elsif flag_3_3 then
                indi_3              <= "011";
                error_position_2(2) <= error_position_pass_15(2) - 128;
            elsif flag_3_4 then
                indi_3              <= "100";
                error_position_2(2) <= error_position_pass_15(2) - 192;
            else
                indi_3              <= "000";
                error_position_2(2) <= error_position_pass_15(2);
            end if;
            ---------------------------------------------------------
        end if;
    end process;
    ------------------------------------------------------------------------------------------------------------
    -- Define processes : (CLK 3)
    ------------------------------------------------------------------------------------------------------------
    process (clk, reset)
    begin
        if (reset = '1') then
            soft_input_unflipped_4 <= (others => (others => '0'));
            soft_input_pass_3      <= (others => (others => '0'));
            hard_input_3           <= (others => '0');
            weight_in_3            <= (others => '0');
            corrections_in_3       <= (others => '0');
            error_position_3       <= (others => 0);
            indi_1_1               <= (others => '0');
            indi_1_2               <= (others => '0');
            indi_1_3               <= (others => '0');
            indi_1_4               <= (others => '0');
            indi_2_1               <= (others => '0');
            indi_2_2               <= (others => '0');
            indi_2_3               <= (others => '0');
            indi_2_4               <= (others => '0');
            indi_3_1               <= (others => '0');
            indi_3_2               <= (others => '0');
            indi_3_3               <= (others => '0');
            indi_3_4               <= (others => '0');
            soft_input_1_1_4       <= (others => (others => '0'));
            soft_input_1_1_3       <= (others => (others => '0'));
            soft_input_1_1_2       <= (others => (others => '0'));
            soft_input_1_1_1       <= (others => (others => '0'));
            soft_input_1_2_4       <= (others => (others => '0'));
            soft_input_1_2_3       <= (others => (others => '0'));
            soft_input_1_2_2       <= (others => (others => '0'));
            soft_input_1_2_1       <= (others => (others => '0'));
            soft_input_1_3_4       <= (others => (others => '0'));
            soft_input_1_3_3       <= (others => (others => '0'));
            soft_input_1_3_2       <= (others => (others => '0'));
            soft_input_1_3_1       <= (others => (others => '0'));
            soft_input_1_4_4       <= (others => (others => '0'));
            soft_input_1_4_3       <= (others => (others => '0'));
            soft_input_1_4_2       <= (others => (others => '0'));
            soft_input_1_4_1       <= (others => (others => '0'));
            soft_input_2_1_4       <= (others => (others => '0'));
            soft_input_2_1_3       <= (others => (others => '0'));
            soft_input_2_1_2       <= (others => (others => '0'));
            soft_input_2_1_1       <= (others => (others => '0'));
            soft_input_2_2_4       <= (others => (others => '0'));
            soft_input_2_2_3       <= (others => (others => '0'));
            soft_input_2_2_2       <= (others => (others => '0'));
            soft_input_2_2_1       <= (others => (others => '0'));
            soft_input_2_3_4       <= (others => (others => '0'));
            soft_input_2_3_3       <= (others => (others => '0'));
            soft_input_2_3_2       <= (others => (others => '0'));
            soft_input_2_3_1       <= (others => (others => '0'));
            soft_input_2_4_4       <= (others => (others => '0'));
            soft_input_2_4_3       <= (others => (others => '0'));
            soft_input_2_4_2       <= (others => (others => '0'));
            soft_input_2_4_1       <= (others => (others => '0'));
            soft_input_3_1_4       <= (others => (others => '0'));
            soft_input_3_1_3       <= (others => (others => '0'));
            soft_input_3_1_2       <= (others => (others => '0'));
            soft_input_3_1_1       <= (others => (others => '0'));
            soft_input_3_2_4       <= (others => (others => '0'));
            soft_input_3_2_3       <= (others => (others => '0'));
            soft_input_3_2_2       <= (others => (others => '0'));
            soft_input_3_2_1       <= (others => (others => '0'));
            soft_input_3_3_4       <= (others => (others => '0'));
            soft_input_3_3_3       <= (others => (others => '0'));
            soft_input_3_3_2       <= (others => (others => '0'));
            soft_input_3_3_1       <= (others => (others => '0'));
            soft_input_3_4_4       <= (others => (others => '0'));
            soft_input_3_4_3       <= (others => (others => '0'));
            soft_input_3_4_2       <= (others => (others => '0'));
            soft_input_3_4_1       <= (others => (others => '0'));
            soft_input_4_1_4       <= (others => (others => '0'));
            soft_input_4_1_3       <= (others => (others => '0'));
            soft_input_4_1_2       <= (others => (others => '0'));
            soft_input_4_1_1       <= (others => (others => '0'));
            soft_input_4_2_4       <= (others => (others => '0'));
            soft_input_4_2_3       <= (others => (others => '0'));
            soft_input_4_2_2       <= (others => (others => '0'));
            soft_input_4_2_1       <= (others => (others => '0'));
            soft_input_4_3_4       <= (others => (others => '0'));
            soft_input_4_3_3       <= (others => (others => '0'));
            soft_input_4_3_2       <= (others => (others => '0'));
            soft_input_4_3_1       <= (others => (others => '0'));
            soft_input_4_4_4       <= (others => (others => '0'));
            soft_input_4_4_3       <= (others => (others => '0'));
            soft_input_4_4_2       <= (others => (others => '0'));
            soft_input_4_4_1       <= (others => (others => '0'));
        elsif (rising_edge(clk)) then
            soft_input_unflipped_4 <= soft_input_unflipped_3;
            soft_input_pass_3      <= soft_input_pass_2;
            hard_input_3           <= hard_input_2;
            weight_in_3            <= weight_in_2;
            corrections_in_3       <= corrections_in_2;
            error_position_3       <= error_position_2;
            soft_input_1_1_4       <= soft_input_1_1(15 downto 12);
            soft_input_1_1_3       <= soft_input_1_1(11 downto 8);
            soft_input_1_1_2       <= soft_input_1_1(7 downto 4);
            soft_input_1_1_1       <= soft_input_1_1(3 downto 0);
            soft_input_1_2_4       <= soft_input_1_2(15 downto 12);
            soft_input_1_2_3       <= soft_input_1_2(11 downto 8);
            soft_input_1_2_2       <= soft_input_1_2(7 downto 4);
            soft_input_1_2_1       <= soft_input_1_2(3 downto 0);
            soft_input_1_3_4       <= soft_input_1_3(15 downto 12);
            soft_input_1_3_3       <= soft_input_1_3(11 downto 8);
            soft_input_1_3_2       <= soft_input_1_3(7 downto 4);
            soft_input_1_3_1       <= soft_input_1_3(3 downto 0);
            soft_input_1_4_4       <= soft_input_1_4(15 downto 12);
            soft_input_1_4_3       <= soft_input_1_4(11 downto 8);
            soft_input_1_4_2       <= soft_input_1_4(7 downto 4);
            soft_input_1_4_1       <= soft_input_1_4(3 downto 0);
            soft_input_2_1_4       <= soft_input_2_1(15 downto 12);
            soft_input_2_1_3       <= soft_input_2_1(11 downto 8);
            soft_input_2_1_2       <= soft_input_2_1(7 downto 4);
            soft_input_2_1_1       <= soft_input_2_1(3 downto 0);
            soft_input_2_2_4       <= soft_input_2_2(15 downto 12);
            soft_input_2_2_3       <= soft_input_2_2(11 downto 8);
            soft_input_2_2_2       <= soft_input_2_2(7 downto 4);
            soft_input_2_2_1       <= soft_input_2_2(3 downto 0);
            soft_input_2_3_4       <= soft_input_2_3(15 downto 12);
            soft_input_2_3_3       <= soft_input_2_3(11 downto 8);
            soft_input_2_3_2       <= soft_input_2_3(7 downto 4);
            soft_input_2_3_1       <= soft_input_2_3(3 downto 0);
            soft_input_2_4_4       <= soft_input_2_4(15 downto 12);
            soft_input_2_4_3       <= soft_input_2_4(11 downto 8);
            soft_input_2_4_2       <= soft_input_2_4(7 downto 4);
            soft_input_2_4_1       <= soft_input_2_4(3 downto 0);
            soft_input_3_1_4       <= soft_input_3_1(15 downto 12);
            soft_input_3_1_3       <= soft_input_3_1(11 downto 8);
            soft_input_3_1_2       <= soft_input_3_1(7 downto 4);
            soft_input_3_1_1       <= soft_input_3_1(3 downto 0);
            soft_input_3_2_4       <= soft_input_3_2(15 downto 12);
            soft_input_3_2_3       <= soft_input_3_2(11 downto 8);
            soft_input_3_2_2       <= soft_input_3_2(7 downto 4);
            soft_input_3_2_1       <= soft_input_3_2(3 downto 0);
            soft_input_3_3_4       <= soft_input_3_3(15 downto 12);
            soft_input_3_3_3       <= soft_input_3_3(11 downto 8);
            soft_input_3_3_2       <= soft_input_3_3(7 downto 4);
            soft_input_3_3_1       <= soft_input_3_3(3 downto 0);
            soft_input_3_4_4       <= soft_input_3_4(15 downto 12);
            soft_input_3_4_3       <= soft_input_3_4(11 downto 8);
            soft_input_3_4_2       <= soft_input_3_4(7 downto 4);
            soft_input_3_4_1       <= soft_input_3_4(3 downto 0);
            soft_input_4_1_4       <= soft_input_4_1(15 downto 12);
            soft_input_4_1_3       <= soft_input_4_1(11 downto 8);
            soft_input_4_1_2       <= soft_input_4_1(7 downto 4);
            soft_input_4_1_1       <= soft_input_4_1(3 downto 0);
            soft_input_4_2_4       <= soft_input_4_2(15 downto 12);
            soft_input_4_2_3       <= soft_input_4_2(11 downto 8);
            soft_input_4_2_2       <= soft_input_4_2(7 downto 4);
            soft_input_4_2_1       <= soft_input_4_2(3 downto 0);
            soft_input_4_3_4       <= soft_input_4_3(15 downto 12);
            soft_input_4_3_3       <= soft_input_4_3(11 downto 8);
            soft_input_4_3_2       <= soft_input_4_3(7 downto 4);
            soft_input_4_3_1       <= soft_input_4_3(3 downto 0);
            soft_input_4_4_4       <= soft_input_4_4(15 downto 12);
            soft_input_4_4_3       <= soft_input_4_4(11 downto 8);
            soft_input_4_4_2       <= soft_input_4_4(7 downto 4);
            soft_input_4_4_1       <= soft_input_4_4(3 downto 0);
            indi_1_1               <= (others => '0');
            indi_1_2               <= (others => '0');
            indi_1_3               <= (others => '0');
            indi_1_4               <= (others => '0');
            indi_2_1               <= (others => '0');
            indi_2_2               <= (others => '0');
            indi_2_3               <= (others => '0');
            indi_2_4               <= (others => '0');
            indi_3_1               <= (others => '0');
            indi_3_2               <= (others => '0');
            indi_3_3               <= (others => '0');
            indi_3_4               <= (others => '0');
            --------------------index category------------------------
            --indi_1 is for index(0)
            if indi_1 = "001" then
                if error_position_2(0) < 16 then
                    indi_1_1            <= "001";
                    error_position_3(0) <= error_position_2(0);
                elsif (15 < error_position_2(0)) and (error_position_2(0) < 32) then
                    indi_1_1            <= "010";
                    error_position_3(0) <= error_position_2(0) - 16;
                elsif (31 < error_position_2(0)) and (error_position_2(0) < 48) then
                    indi_1_1            <= "011";
                    error_position_3(0) <= error_position_2(0) - 32;
                else
                    indi_1_1            <= "100";
                    error_position_3(0) <= error_position_2(0) - 48;
                end if;
            elsif indi_1 = "010" then
                if error_position_2(0) < 16 then
                    indi_1_2            <= "001";
                    error_position_3(0) <= error_position_2(0);
                elsif (15 < error_position_2(0)) and (error_position_2(0) < 32) then
                    indi_1_2            <= "010";
                    error_position_3(0) <= error_position_2(0) - 16;
                elsif (31 < error_position_2(0)) and (error_position_2(0) < 48) then
                    indi_1_2            <= "011";
                    error_position_3(0) <= error_position_2(0) - 32;
                else
                    indi_1_2            <= "100";
                    error_position_3(0) <= error_position_2(0) - 48;
                end if;
            elsif indi_1 = "011" then
                if error_position_2(0) < 16 then
                    indi_1_3            <= "001";
                    error_position_3(0) <= error_position_2(0);
                elsif (15 < error_position_2(0)) and (error_position_2(0) < 32) then
                    indi_1_3            <= "010";
                    error_position_3(0) <= error_position_2(0) - 16;
                elsif (31 < error_position_2(0)) and (error_position_2(0) < 48) then
                    indi_1_3            <= "011";
                    error_position_3(0) <= error_position_2(0) - 32;
                else
                    indi_1_3            <= "100";
                    error_position_3(0) <= error_position_2(0) - 48;
                end if;
            elsif indi_1 = "100" then
                if error_position_2(0) < 16 then
                    indi_1_4            <= "001";
                    error_position_3(0) <= error_position_2(0);
                elsif (15 < error_position_2(0)) and (error_position_2(0) < 32) then
                    indi_1_4            <= "010";
                    error_position_3(0) <= error_position_2(0) - 16;
                elsif (31 < error_position_2(0)) and (error_position_2(0) < 48) then
                    indi_1_4            <= "011";
                    error_position_3(0) <= error_position_2(0) - 32;
                else
                    indi_1_4            <= "100";
                    error_position_3(0) <= error_position_2(0) - 48;
                end if;
            else
                indi_1_1 <= "000";
                indi_1_2 <= "000";
                indi_1_3 <= "000";
                indi_1_4 <= "000";
            end if;
            --------------------index category------------------------
            --indi_2 is for index(1)
            if indi_2 = "001" then
                if error_position_2(1) < 16 then
                    indi_2_1            <= "001";
                    error_position_3(1) <= error_position_2(1);
                elsif (15 < error_position_2(1)) and (error_position_2(1) < 32) then
                    indi_2_1            <= "010";
                    error_position_3(1) <= error_position_2(1) - 16;
                elsif (31 < error_position_2(1)) and (error_position_2(1) < 48) then
                    indi_2_1            <= "011";
                    error_position_3(1) <= error_position_2(1) - 32;
                else
                    indi_2_1            <= "100";
                    error_position_3(1) <= error_position_2(1) - 48;
                end if;
            elsif indi_2 = "010" then
                if error_position_2(1) < 16 then
                    indi_2_2            <= "001";
                    error_position_3(1) <= error_position_2(1);
                elsif (15 < error_position_2(1)) and (error_position_2(1) < 32) then
                    indi_2_2            <= "010";
                    error_position_3(1) <= error_position_2(1) - 16;
                elsif (31 < error_position_2(1)) and (error_position_2(1) < 48) then
                    indi_2_2            <= "011";
                    error_position_3(1) <= error_position_2(1) - 32;
                else
                    indi_2_2            <= "100";
                    error_position_3(1) <= error_position_2(1) - 48;
                end if;
            elsif indi_2 = "011" then
                if error_position_2(1) < 16 then
                    indi_2_3            <= "001";
                    error_position_3(1) <= error_position_2(1);
                elsif (15 < error_position_2(1)) and (error_position_2(1) < 32) then
                    indi_2_3            <= "010";
                    error_position_3(1) <= error_position_2(1) - 16;
                elsif (31 < error_position_2(1)) and (error_position_2(1) < 48) then
                    indi_2_3            <= "011";
                    error_position_3(1) <= error_position_2(1) - 32;
                else
                    indi_2_3            <= "100";
                    error_position_3(1) <= error_position_2(1) - 48;
                end if;
            elsif indi_2 = "100" then
                if error_position_2(1) < 16 then
                    indi_2_4            <= "001";
                    error_position_3(1) <= error_position_2(1);
                elsif (15 < error_position_2(1)) and (error_position_2(1) < 32) then
                    indi_2_4            <= "010";
                    error_position_3(1) <= error_position_2(1) - 16;
                elsif (31 < error_position_2(1)) and (error_position_2(1) < 48) then
                    indi_2_4            <= "011";
                    error_position_3(1) <= error_position_2(1) - 32;
                else
                    indi_2_4            <= "100";
                    error_position_3(1) <= error_position_2(1) - 48;
                end if;
            else
                indi_2_1 <= "000";
                indi_2_2 <= "000";
                indi_2_3 <= "000";
                indi_2_4 <= "000";
            end if;
            --------------------index category------------------------
            --indi_3 is for index(2)
            if indi_3 = "001" then
                if error_position_2(2) < 16 then
                    indi_3_1            <= "001";
                    error_position_3(2) <= error_position_2(2);
                elsif (15 < error_position_2(2)) and (error_position_2(2) < 32) then
                    indi_3_1            <= "010";
                    error_position_3(2) <= error_position_2(2) - 16;
                elsif (31 < error_position_2(2)) and (error_position_2(2) < 48) then
                    indi_3_1            <= "011";
                    error_position_3(2) <= error_position_2(2) - 32;
                else
                    indi_3_1            <= "100";
                    error_position_3(2) <= error_position_2(2) - 48;
                end if;
            elsif indi_3 = "010" then
                if error_position_2(2) < 16 then
                    indi_3_2            <= "001";
                    error_position_3(2) <= error_position_2(2);
                elsif (15 < error_position_2(2)) and (error_position_2(2) < 32) then
                    indi_3_2            <= "010";
                    error_position_3(2) <= error_position_2(2) - 16;
                elsif (31 < error_position_2(2)) and (error_position_2(2) < 48) then
                    indi_3_2            <= "011";
                    error_position_3(2) <= error_position_2(2) - 32;
                else
                    indi_3_2            <= "100";
                    error_position_3(2) <= error_position_2(2) - 48;
                end if;
            elsif indi_3 = "011" then
                if error_position_2(2) < 16 then
                    indi_3_3            <= "001";
                    error_position_3(2) <= error_position_2(2);
                elsif (15 < error_position_2(2)) and (error_position_2(2) < 32) then
                    indi_3_3            <= "010";
                    error_position_3(2) <= error_position_2(2) - 16;
                elsif (31 < error_position_2(2)) and (error_position_2(2) < 48) then
                    indi_3_3            <= "011";
                    error_position_3(2) <= error_position_2(2) - 32;
                else
                    indi_3_3            <= "100";
                    error_position_3(2) <= error_position_2(2) - 48;
                end if;
            elsif indi_3 = "100" then
                if error_position_2(2) < 16 then
                    indi_3_4            <= "001";
                    error_position_3(2) <= error_position_2(2);
                elsif (15 < error_position_2(2)) and (error_position_2(2) < 32) then
                    indi_3_4            <= "010";
                    error_position_3(2) <= error_position_2(2) - 16;
                elsif (31 < error_position_2(2)) and (error_position_2(2) < 48) then
                    indi_3_4            <= "011";
                    error_position_3(2) <= error_position_2(2) - 32;
                else
                    indi_3_4            <= "100";
                    error_position_3(2) <= error_position_2(2) - 48;
                end if;
            else
                indi_3_1 <= "000";
                indi_3_2 <= "000";
                indi_3_3 <= "000";
                indi_3_4 <= "000";
            end if;
        end if;
    end process;
    ------------------------------------------------------------------------------------------------------------
    -- Define processes : (CLK 4)
    ------------------------------------------------------------------------------------------------------------
    process (clk, reset)
    begin
        if (reset = '1') then
            soft_input_unflipped_5 <= (others => (others => '0'));
            soft_input_pass_ext    <= (others => (others => '0'));
            hard_input_ext         <= (others => '0');
            weight_in_ext          <= (others => '0');
            corrections_in_ext     <= (others => '0');
            error_position_ext     <= (others => 0);
            indi_1_1_ext           <= (others => '0');
            indi_1_2_ext           <= (others => '0');
            indi_1_3_ext           <= (others => '0');
            indi_1_4_ext           <= (others => '0');
            indi_2_1_ext           <= (others => '0');
            indi_2_2_ext           <= (others => '0');
            indi_2_3_ext           <= (others => '0');
            indi_2_4_ext           <= (others => '0');
            indi_3_1_ext           <= (others => '0');
            indi_3_2_ext           <= (others => '0');
            indi_3_3_ext           <= (others => '0');
            indi_3_4_ext           <= (others => '0');
            soft_input_1_1_1_ext   <= (others => (others => '0'));
            soft_input_1_1_2_ext   <= (others => (others => '0'));
            soft_input_1_1_3_ext   <= (others => (others => '0'));
            soft_input_1_1_4_ext   <= (others => (others => '0'));
            soft_input_1_2_1_ext   <= (others => (others => '0'));
            soft_input_1_2_2_ext   <= (others => (others => '0'));
            soft_input_1_2_3_ext   <= (others => (others => '0'));
            soft_input_1_2_4_ext   <= (others => (others => '0'));
            soft_input_1_3_1_ext   <= (others => (others => '0'));
            soft_input_1_3_2_ext   <= (others => (others => '0'));
            soft_input_1_3_3_ext   <= (others => (others => '0'));
            soft_input_1_3_4_ext   <= (others => (others => '0'));
            soft_input_1_4_1_ext   <= (others => (others => '0'));
            soft_input_1_4_2_ext   <= (others => (others => '0'));
            soft_input_1_4_3_ext   <= (others => (others => '0'));
            soft_input_1_4_4_ext   <= (others => (others => '0'));
            soft_input_2_1_1_ext   <= (others => (others => '0'));
            soft_input_2_1_2_ext   <= (others => (others => '0'));
            soft_input_2_1_3_ext   <= (others => (others => '0'));
            soft_input_2_1_4_ext   <= (others => (others => '0'));
            soft_input_2_2_1_ext   <= (others => (others => '0'));
            soft_input_2_2_2_ext   <= (others => (others => '0'));
            soft_input_2_2_3_ext   <= (others => (others => '0'));
            soft_input_2_2_4_ext   <= (others => (others => '0'));
            soft_input_2_3_1_ext   <= (others => (others => '0'));
            soft_input_2_3_2_ext   <= (others => (others => '0'));
            soft_input_2_3_3_ext   <= (others => (others => '0'));
            soft_input_2_3_4_ext   <= (others => (others => '0'));
            soft_input_2_4_1_ext   <= (others => (others => '0'));
            soft_input_2_4_2_ext   <= (others => (others => '0'));
            soft_input_2_4_3_ext   <= (others => (others => '0'));
            soft_input_2_4_4_ext   <= (others => (others => '0'));
            soft_input_3_1_1_ext   <= (others => (others => '0'));
            soft_input_3_1_2_ext   <= (others => (others => '0'));
            soft_input_3_1_3_ext   <= (others => (others => '0'));
            soft_input_3_1_4_ext   <= (others => (others => '0'));
            soft_input_3_2_1_ext   <= (others => (others => '0'));
            soft_input_3_2_2_ext   <= (others => (others => '0'));
            soft_input_3_2_3_ext   <= (others => (others => '0'));
            soft_input_3_2_4_ext   <= (others => (others => '0'));
            soft_input_3_3_1_ext   <= (others => (others => '0'));
            soft_input_3_3_2_ext   <= (others => (others => '0'));
            soft_input_3_3_3_ext   <= (others => (others => '0'));
            soft_input_3_3_4_ext   <= (others => (others => '0'));
            soft_input_3_4_1_ext   <= (others => (others => '0'));
            soft_input_3_4_2_ext   <= (others => (others => '0'));
            soft_input_3_4_3_ext   <= (others => (others => '0'));
            soft_input_3_4_4_ext   <= (others => (others => '0'));
            soft_input_4_1_1_ext   <= (others => (others => '0'));
            soft_input_4_1_2_ext   <= (others => (others => '0'));
            soft_input_4_1_3_ext   <= (others => (others => '0'));
            soft_input_4_1_4_ext   <= (others => (others => '0'));
            soft_input_4_2_1_ext   <= (others => (others => '0'));
            soft_input_4_2_2_ext   <= (others => (others => '0'));
            soft_input_4_2_3_ext   <= (others => (others => '0'));
            soft_input_4_2_4_ext   <= (others => (others => '0'));
            soft_input_4_3_1_ext   <= (others => (others => '0'));
            soft_input_4_3_2_ext   <= (others => (others => '0'));
            soft_input_4_3_3_ext   <= (others => (others => '0'));
            soft_input_4_3_4_ext   <= (others => (others => '0'));
            soft_input_4_4_1_ext   <= (others => (others => '0'));
            soft_input_4_4_2_ext   <= (others => (others => '0'));
            soft_input_4_4_3_ext   <= (others => (others => '0'));
            soft_input_4_4_4_ext   <= (others => (others => '0'));
            statement_0_1          <= false;
            statement_0_2          <= false;
            statement_0_3          <= false;
            statement_1_1          <= false;
            statement_1_2          <= false;
            statement_1_3          <= false;
            statement_2_1          <= false;
            statement_2_2          <= false;
            statement_2_3          <= false;
        elsif (rising_edge(clk)) then
            soft_input_unflipped_5 <= soft_input_unflipped_4;
            soft_input_1_1_1_ext   <= soft_input_1_1_1;
            soft_input_1_1_2_ext   <= soft_input_1_1_2;
            soft_input_1_1_3_ext   <= soft_input_1_1_3;
            soft_input_1_1_4_ext   <= soft_input_1_1_4;
            soft_input_1_2_1_ext   <= soft_input_1_2_1;
            soft_input_1_2_2_ext   <= soft_input_1_2_2;
            soft_input_1_2_3_ext   <= soft_input_1_2_3;
            soft_input_1_2_4_ext   <= soft_input_1_2_4;
            soft_input_1_3_1_ext   <= soft_input_1_3_1;
            soft_input_1_3_2_ext   <= soft_input_1_3_2;
            soft_input_1_3_3_ext   <= soft_input_1_3_3;
            soft_input_1_3_4_ext   <= soft_input_1_3_4;
            soft_input_1_4_1_ext   <= soft_input_1_4_1;
            soft_input_1_4_2_ext   <= soft_input_1_4_2;
            soft_input_1_4_3_ext   <= soft_input_1_4_3;
            soft_input_1_4_4_ext   <= soft_input_1_4_4;
            soft_input_2_1_1_ext   <= soft_input_2_1_1;
            soft_input_2_1_2_ext   <= soft_input_2_1_2;
            soft_input_2_1_3_ext   <= soft_input_2_1_3;
            soft_input_2_1_4_ext   <= soft_input_2_1_4;
            soft_input_2_2_1_ext   <= soft_input_2_2_1;
            soft_input_2_2_2_ext   <= soft_input_2_2_2;
            soft_input_2_2_3_ext   <= soft_input_2_2_3;
            soft_input_2_2_4_ext   <= soft_input_2_2_4;
            soft_input_2_3_1_ext   <= soft_input_2_3_1;
            soft_input_2_3_2_ext   <= soft_input_2_3_2;
            soft_input_2_3_3_ext   <= soft_input_2_3_3;
            soft_input_2_3_4_ext   <= soft_input_2_3_4;
            soft_input_2_4_1_ext   <= soft_input_2_4_1;
            soft_input_2_4_2_ext   <= soft_input_2_4_2;
            soft_input_2_4_3_ext   <= soft_input_2_4_3;
            soft_input_2_4_4_ext   <= soft_input_2_4_4;
            soft_input_3_1_1_ext   <= soft_input_3_1_1;
            soft_input_3_1_2_ext   <= soft_input_3_1_2;
            soft_input_3_1_3_ext   <= soft_input_3_1_3;
            soft_input_3_1_4_ext   <= soft_input_3_1_4;
            soft_input_3_2_1_ext   <= soft_input_3_2_1;
            soft_input_3_2_2_ext   <= soft_input_3_2_2;
            soft_input_3_2_3_ext   <= soft_input_3_2_3;
            soft_input_3_2_4_ext   <= soft_input_3_2_4;
            soft_input_3_3_1_ext   <= soft_input_3_3_1;
            soft_input_3_3_2_ext   <= soft_input_3_3_2;
            soft_input_3_3_3_ext   <= soft_input_3_3_3;
            soft_input_3_3_4_ext   <= soft_input_3_3_4;
            soft_input_3_4_1_ext   <= soft_input_3_4_1;
            soft_input_3_4_2_ext   <= soft_input_3_4_2;
            soft_input_3_4_3_ext   <= soft_input_3_4_3;
            soft_input_3_4_4_ext   <= soft_input_3_4_4;
            soft_input_4_1_1_ext   <= soft_input_4_1_1;
            soft_input_4_1_2_ext   <= soft_input_4_1_2;
            soft_input_4_1_3_ext   <= soft_input_4_1_3;
            soft_input_4_1_4_ext   <= soft_input_4_1_4;
            soft_input_4_2_1_ext   <= soft_input_4_2_1;
            soft_input_4_2_2_ext   <= soft_input_4_2_2;
            soft_input_4_2_3_ext   <= soft_input_4_2_3;
            soft_input_4_2_4_ext   <= soft_input_4_2_4;
            soft_input_4_3_1_ext   <= soft_input_4_3_1;
            soft_input_4_3_2_ext   <= soft_input_4_3_2;
            soft_input_4_3_3_ext   <= soft_input_4_3_3;
            soft_input_4_3_4_ext   <= soft_input_4_3_4;
            soft_input_4_4_1_ext   <= soft_input_4_4_1;
            soft_input_4_4_2_ext   <= soft_input_4_4_2;
            soft_input_4_4_3_ext   <= soft_input_4_4_3;
            soft_input_4_4_4_ext   <= soft_input_4_4_4;
            soft_input_pass_ext    <= soft_input_pass_3;
            hard_input_ext         <= hard_input_3;
            weight_in_ext          <= weight_in_3;
            corrections_in_ext     <= corrections_in_3;
            error_position_ext     <= error_position_3;
            statement_0_1          <= error_position_3(0) < 4;
            statement_0_2          <= (3 < error_position_3(0)) and (error_position_3(0) < 8);
            statement_0_3          <= (7 < error_position_3(0)) and (error_position_3(0) < 12);
            statement_1_1          <= error_position_3(1) < 4;
            statement_1_2          <= (3 < error_position_3(1)) and (error_position_3(1) < 8);
            statement_1_3          <= (7 < error_position_3(1)) and (error_position_3(1) < 12);
            statement_2_1          <= error_position_3(2) < 4;
            statement_2_2          <= (3 < error_position_3(2)) and (error_position_3(2) < 8);
            statement_2_3          <= (7 < error_position_3(2)) and (error_position_3(2) < 12);
            indi_1_1_ext           <= indi_1_1;
            indi_1_2_ext           <= indi_1_2;
            indi_1_3_ext           <= indi_1_3;
            indi_1_4_ext           <= indi_1_4;
            indi_2_1_ext           <= indi_2_1;
            indi_2_2_ext           <= indi_2_2;
            indi_2_3_ext           <= indi_2_3;
            indi_2_4_ext           <= indi_2_4;
            indi_3_1_ext           <= indi_3_1;
            indi_3_2_ext           <= indi_3_2;
            indi_3_3_ext           <= indi_3_3;
            indi_3_4_ext           <= indi_3_4;
        end if;
    end process;
    ------------------------------------------------------------------------------------------------------------
    -- Define processes : (CLK 5)
    ------------------------------------------------------------------------------------------------------------
    process (clk, reset)
    begin
        if (reset = '1') then
            soft_input_pass_4       <= (others => (others => '0'));
            hard_input_4            <= (others => '0');
            weight_in_4             <= (others => '0');
            corrections_in_4        <= (others => '0');
            error_position_4        <= (others => 0);
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
            soft_input_1_1_1_pass_1 <= (others => (others => '0'));
            soft_input_1_1_2_pass_1 <= (others => (others => '0'));
            soft_input_1_1_3_pass_1 <= (others => (others => '0'));
            soft_input_1_1_4_pass_1 <= (others => (others => '0'));
            soft_input_1_2_1_pass_1 <= (others => (others => '0'));
            soft_input_1_2_2_pass_1 <= (others => (others => '0'));
            soft_input_1_2_3_pass_1 <= (others => (others => '0'));
            soft_input_1_2_4_pass_1 <= (others => (others => '0'));
            soft_input_1_3_1_pass_1 <= (others => (others => '0'));
            soft_input_1_3_2_pass_1 <= (others => (others => '0'));
            soft_input_1_3_3_pass_1 <= (others => (others => '0'));
            soft_input_1_3_4_pass_1 <= (others => (others => '0'));
            soft_input_1_4_1_pass_1 <= (others => (others => '0'));
            soft_input_1_4_2_pass_1 <= (others => (others => '0'));
            soft_input_1_4_3_pass_1 <= (others => (others => '0'));
            soft_input_1_4_4_pass_1 <= (others => (others => '0'));
            soft_input_2_1_1_pass_1 <= (others => (others => '0'));
            soft_input_2_1_2_pass_1 <= (others => (others => '0'));
            soft_input_2_1_3_pass_1 <= (others => (others => '0'));
            soft_input_2_1_4_pass_1 <= (others => (others => '0'));
            soft_input_2_2_1_pass_1 <= (others => (others => '0'));
            soft_input_2_2_2_pass_1 <= (others => (others => '0'));
            soft_input_2_2_3_pass_1 <= (others => (others => '0'));
            soft_input_2_2_4_pass_1 <= (others => (others => '0'));
            soft_input_2_3_1_pass_1 <= (others => (others => '0'));
            soft_input_2_3_2_pass_1 <= (others => (others => '0'));
            soft_input_2_3_3_pass_1 <= (others => (others => '0'));
            soft_input_2_3_4_pass_1 <= (others => (others => '0'));
            soft_input_2_4_1_pass_1 <= (others => (others => '0'));
            soft_input_2_4_2_pass_1 <= (others => (others => '0'));
            soft_input_2_4_3_pass_1 <= (others => (others => '0'));
            soft_input_2_4_4_pass_1 <= (others => (others => '0'));
            soft_input_3_1_1_pass_1 <= (others => (others => '0'));
            soft_input_3_1_2_pass_1 <= (others => (others => '0'));
            soft_input_3_1_3_pass_1 <= (others => (others => '0'));
            soft_input_3_1_4_pass_1 <= (others => (others => '0'));
            soft_input_3_2_1_pass_1 <= (others => (others => '0'));
            soft_input_3_2_2_pass_1 <= (others => (others => '0'));
            soft_input_3_2_3_pass_1 <= (others => (others => '0'));
            soft_input_3_2_4_pass_1 <= (others => (others => '0'));
            soft_input_3_3_1_pass_1 <= (others => (others => '0'));
            soft_input_3_3_2_pass_1 <= (others => (others => '0'));
            soft_input_3_3_3_pass_1 <= (others => (others => '0'));
            soft_input_3_3_4_pass_1 <= (others => (others => '0'));
            soft_input_3_4_1_pass_1 <= (others => (others => '0'));
            soft_input_3_4_2_pass_1 <= (others => (others => '0'));
            soft_input_3_4_3_pass_1 <= (others => (others => '0'));
            soft_input_3_4_4_pass_1 <= (others => (others => '0'));
            soft_input_4_1_1_pass_1 <= (others => (others => '0'));
            soft_input_4_1_2_pass_1 <= (others => (others => '0'));
            soft_input_4_1_3_pass_1 <= (others => (others => '0'));
            soft_input_4_1_4_pass_1 <= (others => (others => '0'));
            soft_input_4_2_1_pass_1 <= (others => (others => '0'));
            soft_input_4_2_2_pass_1 <= (others => (others => '0'));
            soft_input_4_2_3_pass_1 <= (others => (others => '0'));
            soft_input_4_2_4_pass_1 <= (others => (others => '0'));
            soft_input_4_3_1_pass_1 <= (others => (others => '0'));
            soft_input_4_3_2_pass_1 <= (others => (others => '0'));
            soft_input_4_3_3_pass_1 <= (others => (others => '0'));
            soft_input_4_3_4_pass_1 <= (others => (others => '0'));
            soft_input_4_4_1_pass_1 <= (others => (others => '0'));
            soft_input_4_4_2_pass_1 <= (others => (others => '0'));
            soft_input_4_4_3_pass_1 <= (others => (others => '0'));
            soft_input_4_4_4_pass_1 <= (others => (others => '0'));
        elsif (rising_edge(clk)) then
            soft_input_unflipped_6  <= soft_input_unflipped_5;
            soft_input_pass_4       <= soft_input_pass_ext;
            hard_input_4            <= hard_input_ext;
            weight_in_4             <= weight_in_ext;
            corrections_in_4        <= corrections_in_ext;
            error_position_4        <= error_position_ext;
            soft_input_1_1_1_pass_1 <= soft_input_1_1_1_ext;
            soft_input_1_1_2_pass_1 <= soft_input_1_1_2_ext;
            soft_input_1_1_3_pass_1 <= soft_input_1_1_3_ext;
            soft_input_1_1_4_pass_1 <= soft_input_1_1_4_ext;
            soft_input_1_2_1_pass_1 <= soft_input_1_2_1_ext;
            soft_input_1_2_2_pass_1 <= soft_input_1_2_2_ext;
            soft_input_1_2_3_pass_1 <= soft_input_1_2_3_ext;
            soft_input_1_2_4_pass_1 <= soft_input_1_2_4_ext;
            soft_input_1_3_1_pass_1 <= soft_input_1_3_1_ext;
            soft_input_1_3_2_pass_1 <= soft_input_1_3_2_ext;
            soft_input_1_3_3_pass_1 <= soft_input_1_3_3_ext;
            soft_input_1_3_4_pass_1 <= soft_input_1_3_4_ext;
            soft_input_1_4_1_pass_1 <= soft_input_1_4_1_ext;
            soft_input_1_4_2_pass_1 <= soft_input_1_4_2_ext;
            soft_input_1_4_3_pass_1 <= soft_input_1_4_3_ext;
            soft_input_1_4_4_pass_1 <= soft_input_1_4_4_ext;
            soft_input_2_1_1_pass_1 <= soft_input_2_1_1_ext;
            soft_input_2_1_2_pass_1 <= soft_input_2_1_2_ext;
            soft_input_2_1_3_pass_1 <= soft_input_2_1_3_ext;
            soft_input_2_1_4_pass_1 <= soft_input_2_1_4_ext;
            soft_input_2_2_1_pass_1 <= soft_input_2_2_1_ext;
            soft_input_2_2_2_pass_1 <= soft_input_2_2_2_ext;
            soft_input_2_2_3_pass_1 <= soft_input_2_2_3_ext;
            soft_input_2_2_4_pass_1 <= soft_input_2_2_4_ext;
            soft_input_2_3_1_pass_1 <= soft_input_2_3_1_ext;
            soft_input_2_3_2_pass_1 <= soft_input_2_3_2_ext;
            soft_input_2_3_3_pass_1 <= soft_input_2_3_3_ext;
            soft_input_2_3_4_pass_1 <= soft_input_2_3_4_ext;
            soft_input_2_4_1_pass_1 <= soft_input_2_4_1_ext;
            soft_input_2_4_2_pass_1 <= soft_input_2_4_2_ext;
            soft_input_2_4_3_pass_1 <= soft_input_2_4_3_ext;
            soft_input_2_4_4_pass_1 <= soft_input_2_4_4_ext;
            soft_input_3_1_1_pass_1 <= soft_input_3_1_1_ext;
            soft_input_3_1_2_pass_1 <= soft_input_3_1_2_ext;
            soft_input_3_1_3_pass_1 <= soft_input_3_1_3_ext;
            soft_input_3_1_4_pass_1 <= soft_input_3_1_4_ext;
            soft_input_3_2_1_pass_1 <= soft_input_3_2_1_ext;
            soft_input_3_2_2_pass_1 <= soft_input_3_2_2_ext;
            soft_input_3_2_3_pass_1 <= soft_input_3_2_3_ext;
            soft_input_3_2_4_pass_1 <= soft_input_3_2_4_ext;
            soft_input_3_3_1_pass_1 <= soft_input_3_3_1_ext;
            soft_input_3_3_2_pass_1 <= soft_input_3_3_2_ext;
            soft_input_3_3_3_pass_1 <= soft_input_3_3_3_ext;
            soft_input_3_3_4_pass_1 <= soft_input_3_3_4_ext;
            soft_input_3_4_1_pass_1 <= soft_input_3_4_1_ext;
            soft_input_3_4_2_pass_1 <= soft_input_3_4_2_ext;
            soft_input_3_4_3_pass_1 <= soft_input_3_4_3_ext;
            soft_input_3_4_4_pass_1 <= soft_input_3_4_4_ext;
            soft_input_4_1_1_pass_1 <= soft_input_4_1_1_ext;
            soft_input_4_1_2_pass_1 <= soft_input_4_1_2_ext;
            soft_input_4_1_3_pass_1 <= soft_input_4_1_3_ext;
            soft_input_4_1_4_pass_1 <= soft_input_4_1_4_ext;
            soft_input_4_2_1_pass_1 <= soft_input_4_2_1_ext;
            soft_input_4_2_2_pass_1 <= soft_input_4_2_2_ext;
            soft_input_4_2_3_pass_1 <= soft_input_4_2_3_ext;
            soft_input_4_2_4_pass_1 <= soft_input_4_2_4_ext;
            soft_input_4_3_1_pass_1 <= soft_input_4_3_1_ext;
            soft_input_4_3_2_pass_1 <= soft_input_4_3_2_ext;
            soft_input_4_3_3_pass_1 <= soft_input_4_3_3_ext;
            soft_input_4_3_4_pass_1 <= soft_input_4_3_4_ext;
            soft_input_4_4_1_pass_1 <= soft_input_4_4_1_ext;
            soft_input_4_4_2_pass_1 <= soft_input_4_4_2_ext;
            soft_input_4_4_3_pass_1 <= soft_input_4_4_3_ext;
            soft_input_4_4_4_pass_1 <= soft_input_4_4_4_ext;
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
            if indi_1_1_ext = "001" then
                if statement_0_1 then
                    indi_1_1_1          <= "001";
                    error_position_4(0) <= error_position_ext(0);
                elsif statement_0_2 then
                    indi_1_1_1          <= "010";
                    error_position_4(0) <= error_position_ext(0) - 4;
                elsif statement_0_3 then
                    indi_1_1_1          <= "011";
                    error_position_4(0) <= error_position_ext(0) - 8;
                else
                    indi_1_1_1          <= "100";
                    error_position_4(0) <= error_position_ext(0) - 12;
                end if;
            elsif indi_1_1_ext = "010" then
                if statement_0_1 then
                    indi_1_1_2          <= "001";
                    error_position_4(0) <= error_position_ext(0);
                elsif statement_0_2 then
                    indi_1_1_2          <= "010";
                    error_position_4(0) <= error_position_ext(0) - 4;
                elsif statement_0_3 then
                    indi_1_1_2          <= "011";
                    error_position_4(0) <= error_position_ext(0) - 8;
                else
                    indi_1_1_2          <= "100";
                    error_position_4(0) <= error_position_ext(0) - 12;
                end if;
            elsif indi_1_1_ext = "011" then
                if statement_0_1 then
                    indi_1_1_3          <= "001";
                    error_position_4(0) <= error_position_ext(0);
                elsif statement_0_2 then
                    indi_1_1_3          <= "010";
                    error_position_4(0) <= error_position_ext(0) - 4;
                elsif statement_0_3 then
                    indi_1_1_3          <= "011";
                    error_position_4(0) <= error_position_ext(0) - 8;
                else
                    indi_1_1_3          <= "100";
                    error_position_4(0) <= error_position_ext(0) - 12;
                end if;
            elsif indi_1_1_ext = "100" then
                if statement_0_1 then
                    indi_1_1_4          <= "001";
                    error_position_4(0) <= error_position_ext(0);
                elsif statement_0_2 then
                    indi_1_1_4          <= "010";
                    error_position_4(0) <= error_position_ext(0) - 4;
                elsif statement_0_3 then
                    indi_1_1_4          <= "011";
                    error_position_4(0) <= error_position_ext(0) - 8;
                else
                    indi_1_1_4          <= "100";
                    error_position_4(0) <= error_position_ext(0) - 12;
                end if;
            else
                indi_1_1_1 <= "000";
                indi_1_1_2 <= "000";
                indi_1_1_3 <= "000";
                indi_1_1_4 <= "000";
            end if;
            --------------------------------------------------------
            if indi_1_2_ext = "001" then
                if statement_0_1 then
                    indi_1_2_1          <= "001";
                    error_position_4(0) <= error_position_ext(0);
                elsif statement_0_2 then
                    indi_1_2_1          <= "010";
                    error_position_4(0) <= error_position_ext(0) - 4;
                elsif statement_0_3 then
                    indi_1_2_1          <= "011";
                    error_position_4(0) <= error_position_ext(0) - 8;
                else
                    indi_1_2_1          <= "100";
                    error_position_4(0) <= error_position_ext(0) - 12;
                end if;
            elsif indi_1_2_ext = "010" then
                if statement_0_1 then
                    indi_1_2_2          <= "001";
                    error_position_4(0) <= error_position_ext(0);
                elsif statement_0_2 then
                    indi_1_2_2          <= "010";
                    error_position_4(0) <= error_position_ext(0) - 4;
                elsif statement_0_3 then
                    indi_1_2_2          <= "011";
                    error_position_4(0) <= error_position_ext(0) - 8;
                else
                    indi_1_2_2          <= "100";
                    error_position_4(0) <= error_position_ext(0) - 12;
                end if;
            elsif indi_1_2_ext = "011" then
                if statement_0_1 then
                    indi_1_2_3          <= "001";
                    error_position_4(0) <= error_position_ext(0);
                elsif statement_0_2 then
                    indi_1_2_3          <= "010";
                    error_position_4(0) <= error_position_ext(0) - 4;
                elsif statement_0_3 then
                    indi_1_2_3          <= "011";
                    error_position_4(0) <= error_position_ext(0) - 8;
                else
                    indi_1_2_3          <= "100";
                    error_position_4(0) <= error_position_ext(0) - 12;
                end if;
            elsif indi_1_2_ext = "100" then
                if statement_0_1 then
                    indi_1_2_4          <= "001";
                    error_position_4(0) <= error_position_ext(0);
                elsif statement_0_2 then
                    indi_1_2_4          <= "010";
                    error_position_4(0) <= error_position_ext(0) - 4;
                elsif statement_0_3 then
                    indi_1_2_4          <= "011";
                    error_position_4(0) <= error_position_ext(0) - 8;
                else
                    indi_1_2_4          <= "100";
                    error_position_4(0) <= error_position_ext(0) - 12;
                end if;
            else
                indi_1_2_1 <= "000";
                indi_1_2_2 <= "000";
                indi_1_2_3 <= "000";
                indi_1_2_4 <= "000";
            end if;
            ----------------------------------------------------------
            if indi_1_3_ext = "001" then
                if statement_0_1 then
                    indi_1_3_1          <= "001";
                    error_position_4(0) <= error_position_ext(0);
                elsif statement_0_2 then
                    indi_1_3_1          <= "010";
                    error_position_4(0) <= error_position_ext(0) - 4;
                elsif statement_0_3 then
                    indi_1_3_1          <= "011";
                    error_position_4(0) <= error_position_ext(0) - 8;
                else
                    indi_1_3_1          <= "100";
                    error_position_4(0) <= error_position_ext(0) - 12;
                end if;
            elsif indi_1_3_ext = "010" then
                if statement_0_1 then
                    indi_1_3_2          <= "001";
                    error_position_4(0) <= error_position_ext(0);
                elsif statement_0_2 then
                    indi_1_3_2          <= "010";
                    error_position_4(0) <= error_position_ext(0) - 4;
                elsif statement_0_3 then
                    indi_1_3_2          <= "011";
                    error_position_4(0) <= error_position_ext(0) - 8;
                else
                    indi_1_3_2          <= "100";
                    error_position_4(0) <= error_position_ext(0) - 12;
                end if;
            elsif indi_1_3_ext = "011" then
                if statement_0_1 then
                    indi_1_3_3          <= "001";
                    error_position_4(0) <= error_position_ext(0);
                elsif statement_0_2 then
                    indi_1_3_3          <= "010";
                    error_position_4(0) <= error_position_ext(0) - 4;
                elsif statement_0_3 then
                    indi_1_3_3          <= "011";
                    error_position_4(0) <= error_position_ext(0) - 8;
                else
                    indi_1_3_3          <= "100";
                    error_position_4(0) <= error_position_ext(0) - 12;
                end if;
            elsif indi_1_3_ext = "100" then
                if statement_0_1 then
                    indi_1_3_4          <= "001";
                    error_position_4(0) <= error_position_ext(0);
                elsif statement_0_2 then
                    indi_1_3_4          <= "010";
                    error_position_4(0) <= error_position_ext(0) - 4;
                elsif statement_0_3 then
                    indi_1_3_4          <= "011";
                    error_position_4(0) <= error_position_ext(0) - 8;
                else
                    indi_1_3_4          <= "100";
                    error_position_4(0) <= error_position_ext(0) - 12;
                end if;
            else
                indi_1_3_1 <= "000";
                indi_1_3_2 <= "000";
                indi_1_3_3 <= "000";
                indi_1_3_4 <= "000";
            end if;
            ------------------------------------------------------------
            if indi_1_4_ext = "001" then
                if statement_0_1 then
                    indi_1_4_1          <= "001";
                    error_position_4(0) <= error_position_ext(0);
                elsif statement_0_2 then
                    indi_1_4_1          <= "010";
                    error_position_4(0) <= error_position_ext(0) - 4;
                elsif statement_0_3 then
                    indi_1_4_1          <= "011";
                    error_position_4(0) <= error_position_ext(0) - 8;
                else
                    indi_1_4_1          <= "100";
                    error_position_4(0) <= error_position_ext(0) - 12;
                end if;
            elsif indi_1_4_ext = "010" then
                if statement_0_1 then
                    indi_1_4_2          <= "001";
                    error_position_4(0) <= error_position_ext(0);
                elsif statement_0_2 then
                    indi_1_4_2          <= "010";
                    error_position_4(0) <= error_position_ext(0) - 4;
                elsif statement_0_3 then
                    indi_1_4_2          <= "011";
                    error_position_4(0) <= error_position_ext(0) - 8;
                else
                    indi_1_4_2          <= "100";
                    error_position_4(0) <= error_position_ext(0) - 12;
                end if;
            elsif indi_1_4_ext = "011" then
                if statement_0_1 then
                    indi_1_4_3          <= "001";
                    error_position_4(0) <= error_position_ext(0);
                elsif statement_0_2 then
                    indi_1_4_3          <= "010";
                    error_position_4(0) <= error_position_ext(0) - 4;
                elsif statement_0_3 then
                    indi_1_4_3          <= "011";
                    error_position_4(0) <= error_position_ext(0) - 8;
                else
                    indi_1_4_3          <= "100";
                    error_position_4(0) <= error_position_ext(0) - 12;
                end if;
            elsif indi_1_4_ext = "100" then
                if statement_0_1 then
                    indi_1_4_4          <= "001";
                    error_position_4(0) <= error_position_ext(0);
                elsif statement_0_2 then
                    indi_1_4_4          <= "010";
                    error_position_4(0) <= error_position_ext(0) - 4;
                elsif statement_0_3 then
                    indi_1_4_4          <= "011";
                    error_position_4(0) <= error_position_ext(0) - 8;
                else
                    indi_1_4_4          <= "100";
                    error_position_4(0) <= error_position_ext(0) - 12;
                end if;
            else
                indi_1_4_1 <= "000";
                indi_1_4_2 <= "000";
                indi_1_4_3 <= "000";
                indi_1_4_4 <= "000";
            end if;
            --------------------index category------------------------
            --indi_2_1, indi_2_2, indi_2_3, indi_2_4 are for index(1)
            if indi_2_1_ext = "001" then
                if statement_1_1 then
                    indi_2_1_1          <= "001";
                    error_position_4(1) <= error_position_ext(1);
                elsif statement_1_2 then
                    indi_2_1_1          <= "010";
                    error_position_4(1) <= error_position_ext(1) - 4;
                elsif statement_1_3 then
                    indi_2_1_1          <= "011";
                    error_position_4(1) <= error_position_ext(1) - 8;
                else
                    indi_2_1_1          <= "100";
                    error_position_4(1) <= error_position_ext(1) - 12;
                end if;
            elsif indi_2_1_ext = "010" then
                if statement_1_1 then
                    indi_2_1_2          <= "001";
                    error_position_4(1) <= error_position_ext(1);
                elsif statement_1_2 then
                    indi_2_1_2          <= "010";
                    error_position_4(1) <= error_position_ext(1) - 4;
                elsif statement_1_3 then
                    indi_2_1_2          <= "011";
                    error_position_4(1) <= error_position_ext(1) - 8;
                else
                    indi_2_1_2          <= "100";
                    error_position_4(1) <= error_position_ext(1) - 12;
                end if;
            elsif indi_2_1_ext = "011" then
                if statement_1_1 then
                    indi_2_1_3          <= "001";
                    error_position_4(1) <= error_position_ext(1);
                elsif statement_1_2 then
                    indi_2_1_3          <= "010";
                    error_position_4(1) <= error_position_ext(1) - 4;
                elsif statement_1_3 then
                    indi_2_1_3          <= "011";
                    error_position_4(1) <= error_position_ext(1) - 8;
                else
                    indi_2_1_3          <= "100";
                    error_position_4(1) <= error_position_ext(1) - 12;
                end if;
            elsif indi_2_1_ext = "100" then
                if statement_1_1 then
                    indi_2_1_4          <= "001";
                    error_position_4(1) <= error_position_ext(1);
                elsif statement_1_2 then
                    indi_2_1_4          <= "010";
                    error_position_4(1) <= error_position_ext(1) - 4;
                elsif statement_1_3 then
                    indi_2_1_4          <= "011";
                    error_position_4(1) <= error_position_ext(1) - 8;
                else
                    indi_2_1_4          <= "100";
                    error_position_4(1) <= error_position_ext(1) - 12;
                end if;
            else
                indi_2_1_1 <= "000";
                indi_2_1_2 <= "000";
                indi_2_1_3 <= "000";
                indi_2_1_4 <= "000";
            end if;
            ----------------------------------------------------------
            if indi_2_2_ext = "001" then
                if statement_1_1 then
                    indi_2_2_1          <= "001";
                    error_position_4(1) <= error_position_ext(1);
                elsif statement_1_2 then
                    indi_2_2_1          <= "010";
                    error_position_4(1) <= error_position_ext(1) - 4;
                elsif statement_1_3 then
                    indi_2_2_1          <= "011";
                    error_position_4(1) <= error_position_ext(1) - 8;
                else
                    indi_2_2_1          <= "100";
                    error_position_4(1) <= error_position_ext(1) - 12;
                end if;
            elsif indi_2_2_ext = "010" then
                if statement_1_1 then
                    indi_2_2_2          <= "001";
                    error_position_4(1) <= error_position_ext(1);
                elsif statement_1_2 then
                    indi_2_2_2          <= "010";
                    error_position_4(1) <= error_position_ext(1) - 4;
                elsif statement_1_3 then
                    indi_2_2_2          <= "011";
                    error_position_4(1) <= error_position_ext(1) - 8;
                else
                    indi_2_2_2          <= "100";
                    error_position_4(1) <= error_position_ext(1) - 12;
                end if;
            elsif indi_2_2_ext = "011" then
                if statement_1_1 then
                    indi_2_2_3          <= "001";
                    error_position_4(1) <= error_position_ext(1);
                elsif statement_1_2 then
                    indi_2_2_3          <= "010";
                    error_position_4(1) <= error_position_ext(1) - 4;
                elsif statement_1_3 then
                    indi_2_2_3          <= "011";
                    error_position_4(1) <= error_position_ext(1) - 8;
                else
                    indi_2_2_3          <= "100";
                    error_position_4(1) <= error_position_ext(1) - 12;
                end if;
            elsif indi_2_2_ext = "100" then
                if statement_1_1 then
                    indi_2_2_4          <= "001";
                    error_position_4(1) <= error_position_ext(1);
                elsif statement_1_2 then
                    indi_2_2_4          <= "010";
                    error_position_4(1) <= error_position_ext(1) - 4;
                elsif statement_1_3 then
                    indi_2_2_4          <= "011";
                    error_position_4(1) <= error_position_ext(1) - 8;
                else
                    indi_2_2_4          <= "100";
                    error_position_4(1) <= error_position_ext(1) - 12;
                end if;
            else
                indi_2_2_1 <= "000";
                indi_2_2_2 <= "000";
                indi_2_2_3 <= "000";
                indi_2_2_4 <= "000";
            end if;
            ----------------------------------------------------------
            if indi_2_3_ext = "001" then
                if statement_1_1 then
                    indi_2_3_1          <= "001";
                    error_position_4(1) <= error_position_ext(1);
                elsif statement_1_2 then
                    indi_2_3_1          <= "010";
                    error_position_4(1) <= error_position_ext(1) - 4;
                elsif statement_1_3 then
                    indi_2_3_1          <= "011";
                    error_position_4(1) <= error_position_ext(1) - 8;
                else
                    indi_2_3_1          <= "100";
                    error_position_4(1) <= error_position_ext(1) - 12;
                end if;
            elsif indi_2_3_ext = "010" then
                if statement_1_1 then
                    indi_2_3_2          <= "001";
                    error_position_4(1) <= error_position_ext(1);
                elsif statement_1_2 then
                    indi_2_3_2          <= "010";
                    error_position_4(1) <= error_position_ext(1) - 4;
                elsif statement_1_3 then
                    indi_2_3_2          <= "011";
                    error_position_4(1) <= error_position_ext(1) - 8;
                else
                    indi_2_3_2          <= "100";
                    error_position_4(1) <= error_position_ext(1) - 12;
                end if;
            elsif indi_2_3_ext = "011" then
                if statement_1_1 then
                    indi_2_3_3          <= "001";
                    error_position_4(1) <= error_position_ext(1);
                elsif statement_1_2 then
                    indi_2_3_3          <= "010";
                    error_position_4(1) <= error_position_ext(1) - 4;
                elsif statement_1_3 then
                    indi_2_3_3          <= "011";
                    error_position_4(1) <= error_position_ext(1) - 8;
                else
                    indi_2_3_3          <= "100";
                    error_position_4(1) <= error_position_ext(1) - 12;
                end if;
            elsif indi_2_3_ext = "100" then
                if statement_1_1 then
                    indi_2_3_4          <= "001";
                    error_position_4(1) <= error_position_ext(1);
                elsif statement_1_2 then
                    indi_2_3_4          <= "010";
                    error_position_4(1) <= error_position_ext(1) - 4;
                elsif statement_1_3 then
                    indi_2_3_4          <= "011";
                    error_position_4(1) <= error_position_ext(1) - 8;
                else
                    indi_2_3_4          <= "100";
                    error_position_4(1) <= error_position_ext(1) - 12;
                end if;
            else
                indi_2_3_1 <= "000";
                indi_2_3_2 <= "000";
                indi_2_3_3 <= "000";
                indi_2_3_4 <= "000";
            end if;
            ----------------------------------------------------------
            if indi_2_4_ext = "001" then
                if statement_1_1 then
                    indi_2_4_1          <= "001";
                    error_position_4(1) <= error_position_ext(1);
                elsif statement_1_2 then
                    indi_2_4_1          <= "010";
                    error_position_4(1) <= error_position_ext(1) - 4;
                elsif statement_1_3 then
                    indi_2_4_1          <= "011";
                    error_position_4(1) <= error_position_ext(1) - 8;
                else
                    indi_2_4_1          <= "100";
                    error_position_4(1) <= error_position_ext(1) - 12;
                end if;
            elsif indi_2_4_ext = "010" then
                if statement_1_1 then
                    indi_2_4_2          <= "001";
                    error_position_4(1) <= error_position_ext(1);
                elsif statement_1_2 then
                    indi_2_4_2          <= "010";
                    error_position_4(1) <= error_position_ext(1) - 4;
                elsif statement_1_3 then
                    indi_2_4_2          <= "011";
                    error_position_4(1) <= error_position_ext(1) - 8;
                else
                    indi_2_4_2          <= "100";
                    error_position_4(1) <= error_position_ext(1) - 12;
                end if;
            elsif indi_2_4_ext = "011" then
                if statement_1_1 then
                    indi_2_4_3          <= "001";
                    error_position_4(1) <= error_position_ext(1);
                elsif statement_1_2 then
                    indi_2_4_3          <= "010";
                    error_position_4(1) <= error_position_ext(1) - 4;
                elsif statement_1_3 then
                    indi_2_4_3          <= "011";
                    error_position_4(1) <= error_position_ext(1) - 8;
                else
                    indi_2_4_3          <= "100";
                    error_position_4(1) <= error_position_ext(1) - 12;
                end if;
            elsif indi_2_4_ext = "100" then
                if statement_1_1 then
                    indi_2_4_4          <= "001";
                    error_position_4(1) <= error_position_ext(1);
                elsif statement_1_2 then
                    indi_2_4_4          <= "010";
                    error_position_4(1) <= error_position_ext(1) - 4;
                elsif statement_1_3 then
                    indi_2_4_4          <= "011";
                    error_position_4(1) <= error_position_ext(1) - 8;
                else
                    indi_2_4_4          <= "100";
                    error_position_4(1) <= error_position_ext(1) - 12;
                end if;
            else
                indi_2_4_1 <= "000";
                indi_2_4_2 <= "000";
                indi_2_4_3 <= "000";
                indi_2_4_4 <= "000";
            end if;
            --------------------index category------------------------
            --indi_3_1, indi_3_2, indi_3_3, indi_3_4 are for index(2)
            if indi_3_1_ext = "001" then
                if statement_2_1 then
                    indi_3_1_1          <= "001";
                    error_position_4(2) <= error_position_ext(2);
                elsif statement_2_2 then
                    indi_3_1_1          <= "010";
                    error_position_4(2) <= error_position_ext(2) - 4;
                elsif statement_2_3 then
                    indi_3_1_1          <= "011";
                    error_position_4(2) <= error_position_ext(2) - 8;
                else
                    indi_3_1_1          <= "100";
                    error_position_4(2) <= error_position_ext(2) - 12;
                end if;
            elsif indi_3_1_ext = "010" then
                if statement_2_1 then
                    indi_3_1_2          <= "001";
                    error_position_4(2) <= error_position_ext(2);
                elsif statement_2_2 then
                    indi_3_1_2          <= "010";
                    error_position_4(2) <= error_position_ext(2) - 4;
                elsif statement_2_3 then
                    indi_3_1_2          <= "011";
                    error_position_4(2) <= error_position_ext(2) - 8;
                else
                    indi_3_1_2          <= "100";
                    error_position_4(2) <= error_position_ext(2) - 12;
                end if;
            elsif indi_3_1_ext = "011" then
                if statement_2_1 then
                    indi_3_1_3          <= "001";
                    error_position_4(2) <= error_position_ext(2);
                elsif statement_2_2 then
                    indi_3_1_3          <= "010";
                    error_position_4(2) <= error_position_ext(2) - 4;
                elsif statement_2_3 then
                    indi_3_1_3          <= "011";
                    error_position_4(2) <= error_position_ext(2) - 8;
                else
                    indi_3_1_3          <= "100";
                    error_position_4(2) <= error_position_ext(2) - 12;
                end if;
            elsif indi_3_1_ext = "100" then
                if statement_2_1 then
                    indi_3_1_4          <= "001";
                    error_position_4(2) <= error_position_ext(2);
                elsif statement_2_2 then
                    indi_3_1_4          <= "010";
                    error_position_4(2) <= error_position_ext(2) - 4;
                elsif statement_2_3 then
                    indi_3_1_4          <= "011";
                    error_position_4(2) <= error_position_ext(2) - 8;
                else
                    indi_3_1_4          <= "100";
                    error_position_4(2) <= error_position_ext(2) - 12;
                end if;
            else
                indi_3_1_1 <= "000";
                indi_3_1_2 <= "000";
                indi_3_1_3 <= "000";
                indi_3_1_4 <= "000";
            end if;
            ----------------------------------------------------------
            if indi_3_2_ext = "001" then
                if statement_2_1 then
                    indi_3_2_1          <= "001";
                    error_position_4(2) <= error_position_ext(2);
                elsif statement_2_2 then
                    indi_3_2_1          <= "010";
                    error_position_4(2) <= error_position_ext(2) - 4;
                elsif statement_2_3 then
                    indi_3_2_1          <= "011";
                    error_position_4(2) <= error_position_ext(2) - 8;
                else
                    indi_3_2_1          <= "100";
                    error_position_4(2) <= error_position_ext(2) - 12;
                end if;
            elsif indi_3_2_ext = "010" then
                if statement_2_1 then
                    indi_3_2_2          <= "001";
                    error_position_4(2) <= error_position_ext(2);
                elsif statement_2_2 then
                    indi_3_2_2          <= "010";
                    error_position_4(2) <= error_position_ext(2) - 4;
                elsif statement_2_3 then
                    indi_3_2_2          <= "011";
                    error_position_4(2) <= error_position_ext(2) - 8;
                else
                    indi_3_2_2          <= "100";
                    error_position_4(2) <= error_position_ext(2) - 12;
                end if;
            elsif indi_3_2_ext = "011" then
                if statement_2_1 then
                    indi_3_2_3          <= "001";
                    error_position_4(2) <= error_position_ext(2);
                elsif statement_2_2 then
                    indi_3_2_3          <= "010";
                    error_position_4(2) <= error_position_ext(2) - 4;
                elsif statement_2_3 then
                    indi_3_2_3          <= "011";
                    error_position_4(2) <= error_position_ext(2) - 8;
                else
                    indi_3_2_3          <= "100";
                    error_position_4(2) <= error_position_ext(2) - 12;
                end if;
            elsif indi_3_2_ext = "100" then
                if statement_2_1 then
                    indi_3_2_4          <= "001";
                    error_position_4(2) <= error_position_ext(2);
                elsif statement_2_2 then
                    indi_3_2_4          <= "010";
                    error_position_4(2) <= error_position_ext(2) - 4;
                elsif statement_2_3 then
                    indi_3_2_4          <= "011";
                    error_position_4(2) <= error_position_ext(2) - 8;
                else
                    indi_3_2_4          <= "100";
                    error_position_4(2) <= error_position_ext(2) - 12;
                end if;
            else
                indi_3_2_1 <= "000";
                indi_3_2_2 <= "000";
                indi_3_2_3 <= "000";
                indi_3_2_4 <= "000";
            end if;
            ----------------------------------------------------------
            if indi_3_3_ext = "001" then
                if statement_2_1 then
                    indi_3_3_1          <= "001";
                    error_position_4(2) <= error_position_ext(2);
                elsif statement_2_2 then
                    indi_3_3_1          <= "010";
                    error_position_4(2) <= error_position_ext(2) - 4;
                elsif statement_2_3 then
                    indi_3_3_1          <= "011";
                    error_position_4(2) <= error_position_ext(2) - 8;
                else
                    indi_3_3_1          <= "100";
                    error_position_4(2) <= error_position_ext(2) - 12;
                end if;
            elsif indi_3_3_ext = "010" then
                if statement_2_1 then
                    indi_3_3_2          <= "001";
                    error_position_4(2) <= error_position_ext(2);
                elsif statement_2_2 then
                    indi_3_3_2          <= "010";
                    error_position_4(2) <= error_position_ext(2) - 4;
                elsif statement_2_3 then
                    indi_3_3_2          <= "011";
                    error_position_4(2) <= error_position_ext(2) - 8;
                else
                    indi_3_3_2          <= "100";
                    error_position_4(2) <= error_position_ext(2) - 12;
                end if;
            elsif indi_3_3_ext = "011" then
                if statement_2_1 then
                    indi_3_3_3          <= "001";
                    error_position_4(2) <= error_position_ext(2);
                elsif statement_2_2 then
                    indi_3_3_3          <= "010";
                    error_position_4(2) <= error_position_ext(2) - 4;
                elsif statement_2_3 then
                    indi_3_3_3          <= "011";
                    error_position_4(2) <= error_position_ext(2) - 8;
                else
                    indi_3_3_3          <= "100";
                    error_position_4(2) <= error_position_ext(2) - 12;
                end if;
            elsif indi_3_3_ext = "100" then
                if statement_2_1 then
                    indi_3_3_4          <= "001";
                    error_position_4(2) <= error_position_ext(2);
                elsif statement_2_2 then
                    indi_3_3_4          <= "010";
                    error_position_4(2) <= error_position_ext(2) - 4;
                elsif statement_2_3 then
                    indi_3_3_4          <= "011";
                    error_position_4(2) <= error_position_ext(2) - 8;
                else
                    indi_3_3_4          <= "100";
                    error_position_4(2) <= error_position_ext(2) - 12;
                end if;
            else
                indi_3_3_1 <= "000";
                indi_3_3_2 <= "000";
                indi_3_3_3 <= "000";
                indi_3_3_4 <= "000";
            end if;
            ----------------------------------------------------------
            if indi_3_4_ext = "001" then
                if statement_2_1 then
                    indi_3_4_1          <= "001";
                    error_position_4(2) <= error_position_ext(2);
                elsif statement_2_2 then
                    indi_3_4_1          <= "010";
                    error_position_4(2) <= error_position_ext(2) - 4;
                elsif statement_2_3 then
                    indi_3_4_1          <= "011";
                    error_position_4(2) <= error_position_ext(2) - 8;
                else
                    indi_3_4_1          <= "100";
                    error_position_4(2) <= error_position_ext(2) - 12;
                end if;
            elsif indi_3_4_ext = "010" then
                if statement_2_1 then
                    indi_3_4_2          <= "001";
                    error_position_4(2) <= error_position_ext(2);
                elsif statement_2_2 then
                    indi_3_4_2          <= "010";
                    error_position_4(2) <= error_position_ext(2) - 4;
                elsif statement_2_3 then
                    indi_3_4_2          <= "011";
                    error_position_4(2) <= error_position_ext(2) - 8;
                else
                    indi_3_4_2          <= "100";
                    error_position_4(2) <= error_position_ext(2) - 12;
                end if;
            elsif indi_3_4_ext = "011" then
                if statement_2_1 then
                    indi_3_4_3          <= "001";
                    error_position_4(2) <= error_position_ext(2);
                elsif statement_2_2 then
                    indi_3_4_3          <= "010";
                    error_position_4(2) <= error_position_ext(2) - 4;
                elsif statement_2_3 then
                    indi_3_4_3          <= "011";
                    error_position_4(2) <= error_position_ext(2) - 8;
                else
                    indi_3_4_3          <= "100";
                    error_position_4(2) <= error_position_ext(2) - 12;
                end if;
            elsif indi_3_4_ext = "100" then
                if statement_2_1 then
                    indi_3_4_4          <= "001";
                    error_position_4(2) <= error_position_ext(2);
                elsif statement_2_2 then
                    indi_3_4_4          <= "010";
                    error_position_4(2) <= error_position_ext(2) - 4;
                elsif statement_2_3 then
                    indi_3_4_4          <= "011";
                    error_position_4(2) <= error_position_ext(2) - 8;
                else
                    indi_3_4_4          <= "100";
                    error_position_4(2) <= error_position_ext(2) - 12;
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
    -- Define processes : (CLK 6)
    ------------------------------------------------------------------------------------------------------------
    process (clk, reset)
    begin
        if (reset = '1') then
            soft_input_unflipped_7      <= (others => (others => '0'));
            soft_input_pass_5_ext       <= (others => (others => '0'));
            hard_input_5_ext            <= (others => '0');
            weight_in_5_ext             <= (others => '0');
            corrections_in_5_ext        <= (others => '0');
            error_position_5_ext        <= (others => 0);
            indi_1_1_1_pass_1_ext       <= (others => '0');
            indi_1_1_2_pass_1_ext       <= (others => '0');
            indi_1_1_3_pass_1_ext       <= (others => '0');
            indi_1_1_4_pass_1_ext       <= (others => '0');
            indi_1_2_1_pass_1_ext       <= (others => '0');
            indi_1_2_2_pass_1_ext       <= (others => '0');
            indi_1_2_3_pass_1_ext       <= (others => '0');
            indi_1_2_4_pass_1_ext       <= (others => '0');
            indi_1_3_1_pass_1_ext       <= (others => '0');
            indi_1_3_2_pass_1_ext       <= (others => '0');
            indi_1_3_3_pass_1_ext       <= (others => '0');
            indi_1_3_4_pass_1_ext       <= (others => '0');
            indi_1_4_1_pass_1_ext       <= (others => '0');
            indi_1_4_2_pass_1_ext       <= (others => '0');
            indi_1_4_3_pass_1_ext       <= (others => '0');
            indi_1_4_4_pass_1_ext       <= (others => '0');
            indi_2_1_1_pass_1_ext       <= (others => '0');
            indi_2_1_2_pass_1_ext       <= (others => '0');
            indi_2_1_3_pass_1_ext       <= (others => '0');
            indi_2_1_4_pass_1_ext       <= (others => '0');
            indi_2_2_1_pass_1_ext       <= (others => '0');
            indi_2_2_2_pass_1_ext       <= (others => '0');
            indi_2_2_3_pass_1_ext       <= (others => '0');
            indi_2_2_4_pass_1_ext       <= (others => '0');
            indi_2_3_1_pass_1_ext       <= (others => '0');
            indi_2_3_2_pass_1_ext       <= (others => '0');
            indi_2_3_3_pass_1_ext       <= (others => '0');
            indi_2_3_4_pass_1_ext       <= (others => '0');
            indi_2_4_1_pass_1_ext       <= (others => '0');
            indi_2_4_2_pass_1_ext       <= (others => '0');
            indi_2_4_3_pass_1_ext       <= (others => '0');
            indi_2_4_4_pass_1_ext       <= (others => '0');
            indi_3_1_1_pass_1_ext       <= (others => '0');
            indi_3_1_2_pass_1_ext       <= (others => '0');
            indi_3_1_3_pass_1_ext       <= (others => '0');
            indi_3_1_4_pass_1_ext       <= (others => '0');
            indi_3_2_1_pass_1_ext       <= (others => '0');
            indi_3_2_2_pass_1_ext       <= (others => '0');
            indi_3_2_3_pass_1_ext       <= (others => '0');
            indi_3_2_4_pass_1_ext       <= (others => '0');
            indi_3_3_1_pass_1_ext       <= (others => '0');
            indi_3_3_2_pass_1_ext       <= (others => '0');
            indi_3_3_3_pass_1_ext       <= (others => '0');
            indi_3_3_4_pass_1_ext       <= (others => '0');
            indi_3_4_1_pass_1_ext       <= (others => '0');
            indi_3_4_2_pass_1_ext       <= (others => '0');
            indi_3_4_3_pass_1_ext       <= (others => '0');
            indi_3_4_4_pass_1_ext       <= (others => '0');
            soft_input_1_1_1_pass_2_ext <= (others => (others => '0'));
            soft_input_1_1_2_pass_2_ext <= (others => (others => '0'));
            soft_input_1_1_3_pass_2_ext <= (others => (others => '0'));
            soft_input_1_1_4_pass_2_ext <= (others => (others => '0'));
            soft_input_1_2_1_pass_2_ext <= (others => (others => '0'));
            soft_input_1_2_2_pass_2_ext <= (others => (others => '0'));
            soft_input_1_2_3_pass_2_ext <= (others => (others => '0'));
            soft_input_1_2_4_pass_2_ext <= (others => (others => '0'));
            soft_input_1_3_1_pass_2_ext <= (others => (others => '0'));
            soft_input_1_3_2_pass_2_ext <= (others => (others => '0'));
            soft_input_1_3_3_pass_2_ext <= (others => (others => '0'));
            soft_input_1_3_4_pass_2_ext <= (others => (others => '0'));
            soft_input_1_4_1_pass_2_ext <= (others => (others => '0'));
            soft_input_1_4_2_pass_2_ext <= (others => (others => '0'));
            soft_input_1_4_3_pass_2_ext <= (others => (others => '0'));
            soft_input_1_4_4_pass_2_ext <= (others => (others => '0'));
            soft_input_2_1_1_pass_2_ext <= (others => (others => '0'));
            soft_input_2_1_2_pass_2_ext <= (others => (others => '0'));
            soft_input_2_1_3_pass_2_ext <= (others => (others => '0'));
            soft_input_2_1_4_pass_2_ext <= (others => (others => '0'));
            soft_input_2_2_1_pass_2_ext <= (others => (others => '0'));
            soft_input_2_2_2_pass_2_ext <= (others => (others => '0'));
            soft_input_2_2_3_pass_2_ext <= (others => (others => '0'));
            soft_input_2_2_4_pass_2_ext <= (others => (others => '0'));
            soft_input_2_3_1_pass_2_ext <= (others => (others => '0'));
            soft_input_2_3_2_pass_2_ext <= (others => (others => '0'));
            soft_input_2_3_3_pass_2_ext <= (others => (others => '0'));
            soft_input_2_3_4_pass_2_ext <= (others => (others => '0'));
            soft_input_2_4_1_pass_2_ext <= (others => (others => '0'));
            soft_input_2_4_2_pass_2_ext <= (others => (others => '0'));
            soft_input_2_4_3_pass_2_ext <= (others => (others => '0'));
            soft_input_2_4_4_pass_2_ext <= (others => (others => '0'));
            soft_input_3_1_1_pass_2_ext <= (others => (others => '0'));
            soft_input_3_1_2_pass_2_ext <= (others => (others => '0'));
            soft_input_3_1_3_pass_2_ext <= (others => (others => '0'));
            soft_input_3_1_4_pass_2_ext <= (others => (others => '0'));
            soft_input_3_2_1_pass_2_ext <= (others => (others => '0'));
            soft_input_3_2_2_pass_2_ext <= (others => (others => '0'));
            soft_input_3_2_3_pass_2_ext <= (others => (others => '0'));
            soft_input_3_2_4_pass_2_ext <= (others => (others => '0'));
            soft_input_3_3_1_pass_2_ext <= (others => (others => '0'));
            soft_input_3_3_2_pass_2_ext <= (others => (others => '0'));
            soft_input_3_3_3_pass_2_ext <= (others => (others => '0'));
            soft_input_3_3_4_pass_2_ext <= (others => (others => '0'));
            soft_input_3_4_1_pass_2_ext <= (others => (others => '0'));
            soft_input_3_4_2_pass_2_ext <= (others => (others => '0'));
            soft_input_3_4_3_pass_2_ext <= (others => (others => '0'));
            soft_input_3_4_4_pass_2_ext <= (others => (others => '0'));
            soft_input_4_1_1_pass_2_ext <= (others => (others => '0'));
            soft_input_4_1_2_pass_2_ext <= (others => (others => '0'));
            soft_input_4_1_3_pass_2_ext <= (others => (others => '0'));
            soft_input_4_1_4_pass_2_ext <= (others => (others => '0'));
            soft_input_4_2_1_pass_2_ext <= (others => (others => '0'));
            soft_input_4_2_2_pass_2_ext <= (others => (others => '0'));
            soft_input_4_2_3_pass_2_ext <= (others => (others => '0'));
            soft_input_4_2_4_pass_2_ext <= (others => (others => '0'));
            soft_input_4_3_1_pass_2_ext <= (others => (others => '0'));
            soft_input_4_3_2_pass_2_ext <= (others => (others => '0'));
            soft_input_4_3_3_pass_2_ext <= (others => (others => '0'));
            soft_input_4_3_4_pass_2_ext <= (others => (others => '0'));
            soft_input_4_4_1_pass_2_ext <= (others => (others => '0'));
            soft_input_4_4_2_pass_2_ext <= (others => (others => '0'));
            soft_input_4_4_3_pass_2_ext <= (others => (others => '0'));
            soft_input_4_4_4_pass_2_ext <= (others => (others => '0'));
            digit_1                     <= 0;
            digit_2                     <= 0;
            digit_3                     <= 0;
        elsif (rising_edge(clk)) then
            soft_input_unflipped_7      <= soft_input_unflipped_6;
            soft_input_pass_5_ext       <= soft_input_pass_4;
            hard_input_5_ext            <= hard_input_4;
            weight_in_5_ext             <= weight_in_4;
            corrections_in_5_ext        <= corrections_in_4;
            error_position_5_ext        <= error_position_4;
            digit_1                     <= error_position_4(0);
            digit_2                     <= error_position_4(1);
            digit_3                     <= error_position_4(2);
            indi_1_1_1_pass_1_ext       <= indi_1_1_1;
            indi_1_1_2_pass_1_ext       <= indi_1_1_2;
            indi_1_1_3_pass_1_ext       <= indi_1_1_3;
            indi_1_1_4_pass_1_ext       <= indi_1_1_4;
            indi_1_2_1_pass_1_ext       <= indi_1_2_1;
            indi_1_2_2_pass_1_ext       <= indi_1_2_2;
            indi_1_2_3_pass_1_ext       <= indi_1_2_3;
            indi_1_2_4_pass_1_ext       <= indi_1_2_4;
            indi_1_3_1_pass_1_ext       <= indi_1_3_1;
            indi_1_3_2_pass_1_ext       <= indi_1_3_2;
            indi_1_3_3_pass_1_ext       <= indi_1_3_3;
            indi_1_3_4_pass_1_ext       <= indi_1_3_4;
            indi_1_4_1_pass_1_ext       <= indi_1_4_1;
            indi_1_4_2_pass_1_ext       <= indi_1_4_2;
            indi_1_4_3_pass_1_ext       <= indi_1_4_3;
            indi_1_4_4_pass_1_ext       <= indi_1_4_4;
            indi_2_1_1_pass_1_ext       <= indi_2_1_1;
            indi_2_1_2_pass_1_ext       <= indi_2_1_2;
            indi_2_1_3_pass_1_ext       <= indi_2_1_3;
            indi_2_1_4_pass_1_ext       <= indi_2_1_4;
            indi_2_2_1_pass_1_ext       <= indi_2_2_1;
            indi_2_2_2_pass_1_ext       <= indi_2_2_2;
            indi_2_2_3_pass_1_ext       <= indi_2_2_3;
            indi_2_2_4_pass_1_ext       <= indi_2_2_4;
            indi_2_3_1_pass_1_ext       <= indi_2_3_1;
            indi_2_3_2_pass_1_ext       <= indi_2_3_2;
            indi_2_3_3_pass_1_ext       <= indi_2_3_3;
            indi_2_3_4_pass_1_ext       <= indi_2_3_4;
            indi_2_4_1_pass_1_ext       <= indi_2_4_1;
            indi_2_4_2_pass_1_ext       <= indi_2_4_2;
            indi_2_4_3_pass_1_ext       <= indi_2_4_3;
            indi_2_4_4_pass_1_ext       <= indi_2_4_4;
            indi_3_1_1_pass_1_ext       <= indi_3_1_1;
            indi_3_1_2_pass_1_ext       <= indi_3_1_2;
            indi_3_1_3_pass_1_ext       <= indi_3_1_3;
            indi_3_1_4_pass_1_ext       <= indi_3_1_4;
            indi_3_2_1_pass_1_ext       <= indi_3_2_1;
            indi_3_2_2_pass_1_ext       <= indi_3_2_2;
            indi_3_2_3_pass_1_ext       <= indi_3_2_3;
            indi_3_2_4_pass_1_ext       <= indi_3_2_4;
            indi_3_3_1_pass_1_ext       <= indi_3_3_1;
            indi_3_3_2_pass_1_ext       <= indi_3_3_2;
            indi_3_3_3_pass_1_ext       <= indi_3_3_3;
            indi_3_3_4_pass_1_ext       <= indi_3_3_4;
            indi_3_4_1_pass_1_ext       <= indi_3_4_1;
            indi_3_4_2_pass_1_ext       <= indi_3_4_2;
            indi_3_4_3_pass_1_ext       <= indi_3_4_3;
            indi_3_4_4_pass_1_ext       <= indi_3_4_4;
            soft_input_1_1_1_pass_2_ext <= soft_input_1_1_1_pass_1;
            soft_input_1_1_2_pass_2_ext <= soft_input_1_1_2_pass_1;
            soft_input_1_1_3_pass_2_ext <= soft_input_1_1_3_pass_1;
            soft_input_1_1_4_pass_2_ext <= soft_input_1_1_4_pass_1;
            soft_input_1_2_1_pass_2_ext <= soft_input_1_2_1_pass_1;
            soft_input_1_2_2_pass_2_ext <= soft_input_1_2_2_pass_1;
            soft_input_1_2_3_pass_2_ext <= soft_input_1_2_3_pass_1;
            soft_input_1_2_4_pass_2_ext <= soft_input_1_2_4_pass_1;
            soft_input_1_3_1_pass_2_ext <= soft_input_1_3_1_pass_1;
            soft_input_1_3_2_pass_2_ext <= soft_input_1_3_2_pass_1;
            soft_input_1_3_3_pass_2_ext <= soft_input_1_3_3_pass_1;
            soft_input_1_3_4_pass_2_ext <= soft_input_1_3_4_pass_1;
            soft_input_1_4_1_pass_2_ext <= soft_input_1_4_1_pass_1;
            soft_input_1_4_2_pass_2_ext <= soft_input_1_4_2_pass_1;
            soft_input_1_4_3_pass_2_ext <= soft_input_1_4_3_pass_1;
            soft_input_1_4_4_pass_2_ext <= soft_input_1_4_4_pass_1;
            soft_input_2_1_1_pass_2_ext <= soft_input_2_1_1_pass_1;
            soft_input_2_1_2_pass_2_ext <= soft_input_2_1_2_pass_1;
            soft_input_2_1_3_pass_2_ext <= soft_input_2_1_3_pass_1;
            soft_input_2_1_4_pass_2_ext <= soft_input_2_1_4_pass_1;
            soft_input_2_2_1_pass_2_ext <= soft_input_2_2_1_pass_1;
            soft_input_2_2_2_pass_2_ext <= soft_input_2_2_2_pass_1;
            soft_input_2_2_3_pass_2_ext <= soft_input_2_2_3_pass_1;
            soft_input_2_2_4_pass_2_ext <= soft_input_2_2_4_pass_1;
            soft_input_2_3_1_pass_2_ext <= soft_input_2_3_1_pass_1;
            soft_input_2_3_2_pass_2_ext <= soft_input_2_3_2_pass_1;
            soft_input_2_3_3_pass_2_ext <= soft_input_2_3_3_pass_1;
            soft_input_2_3_4_pass_2_ext <= soft_input_2_3_4_pass_1;
            soft_input_2_4_1_pass_2_ext <= soft_input_2_4_1_pass_1;
            soft_input_2_4_2_pass_2_ext <= soft_input_2_4_2_pass_1;
            soft_input_2_4_3_pass_2_ext <= soft_input_2_4_3_pass_1;
            soft_input_2_4_4_pass_2_ext <= soft_input_2_4_4_pass_1;
            soft_input_3_1_1_pass_2_ext <= soft_input_3_1_1_pass_1;
            soft_input_3_1_2_pass_2_ext <= soft_input_3_1_2_pass_1;
            soft_input_3_1_3_pass_2_ext <= soft_input_3_1_3_pass_1;
            soft_input_3_1_4_pass_2_ext <= soft_input_3_1_4_pass_1;
            soft_input_3_2_1_pass_2_ext <= soft_input_3_2_1_pass_1;
            soft_input_3_2_2_pass_2_ext <= soft_input_3_2_2_pass_1;
            soft_input_3_2_3_pass_2_ext <= soft_input_3_2_3_pass_1;
            soft_input_3_2_4_pass_2_ext <= soft_input_3_2_4_pass_1;
            soft_input_3_3_1_pass_2_ext <= soft_input_3_3_1_pass_1;
            soft_input_3_3_2_pass_2_ext <= soft_input_3_3_2_pass_1;
            soft_input_3_3_3_pass_2_ext <= soft_input_3_3_3_pass_1;
            soft_input_3_3_4_pass_2_ext <= soft_input_3_3_4_pass_1;
            soft_input_3_4_1_pass_2_ext <= soft_input_3_4_1_pass_1;
            soft_input_3_4_2_pass_2_ext <= soft_input_3_4_2_pass_1;
            soft_input_3_4_3_pass_2_ext <= soft_input_3_4_3_pass_1;
            soft_input_3_4_4_pass_2_ext <= soft_input_3_4_4_pass_1;
            soft_input_4_1_1_pass_2_ext <= soft_input_4_1_1_pass_1;
            soft_input_4_1_2_pass_2_ext <= soft_input_4_1_2_pass_1;
            soft_input_4_1_3_pass_2_ext <= soft_input_4_1_3_pass_1;
            soft_input_4_1_4_pass_2_ext <= soft_input_4_1_4_pass_1;
            soft_input_4_2_1_pass_2_ext <= soft_input_4_2_1_pass_1;
            soft_input_4_2_2_pass_2_ext <= soft_input_4_2_2_pass_1;
            soft_input_4_2_3_pass_2_ext <= soft_input_4_2_3_pass_1;
            soft_input_4_2_4_pass_2_ext <= soft_input_4_2_4_pass_1;
            soft_input_4_3_1_pass_2_ext <= soft_input_4_3_1_pass_1;
            soft_input_4_3_2_pass_2_ext <= soft_input_4_3_2_pass_1;
            soft_input_4_3_3_pass_2_ext <= soft_input_4_3_3_pass_1;
            soft_input_4_3_4_pass_2_ext <= soft_input_4_3_4_pass_1;
            soft_input_4_4_1_pass_2_ext <= soft_input_4_4_1_pass_1;
            soft_input_4_4_2_pass_2_ext <= soft_input_4_4_2_pass_1;
            soft_input_4_4_3_pass_2_ext <= soft_input_4_4_3_pass_1;
            soft_input_4_4_4_pass_2_ext <= soft_input_4_4_4_pass_1;
        end if;
    end process;
    ------------------------------------------------------------------------------------------------------------
    -- Define processes : (CLK 7)
    ------------------------------------------------------------------------------------------------------------
    process (clk, reset)
    begin
        if (reset = '1') then
            soft_input_unflipped_8  <= (others => (others => '0'));
            soft_input_pass_5       <= (others => (others => '0'));
            hard_input_5            <= (others => '0');
            weight_in_5             <= (others => '0');
            corrections_in_5        <= (others => '0');
            error_position_5        <= (others => 0);
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
            soft_input_1_1_1_pass_2 <= (others => (others => '0'));
            soft_input_1_1_2_pass_2 <= (others => (others => '0'));
            soft_input_1_1_3_pass_2 <= (others => (others => '0'));
            soft_input_1_1_4_pass_2 <= (others => (others => '0'));
            soft_input_1_2_1_pass_2 <= (others => (others => '0'));
            soft_input_1_2_2_pass_2 <= (others => (others => '0'));
            soft_input_1_2_3_pass_2 <= (others => (others => '0'));
            soft_input_1_2_4_pass_2 <= (others => (others => '0'));
            soft_input_1_3_1_pass_2 <= (others => (others => '0'));
            soft_input_1_3_2_pass_2 <= (others => (others => '0'));
            soft_input_1_3_3_pass_2 <= (others => (others => '0'));
            soft_input_1_3_4_pass_2 <= (others => (others => '0'));
            soft_input_1_4_1_pass_2 <= (others => (others => '0'));
            soft_input_1_4_2_pass_2 <= (others => (others => '0'));
            soft_input_1_4_3_pass_2 <= (others => (others => '0'));
            soft_input_1_4_4_pass_2 <= (others => (others => '0'));
            soft_input_2_1_1_pass_2 <= (others => (others => '0'));
            soft_input_2_1_2_pass_2 <= (others => (others => '0'));
            soft_input_2_1_3_pass_2 <= (others => (others => '0'));
            soft_input_2_1_4_pass_2 <= (others => (others => '0'));
            soft_input_2_2_1_pass_2 <= (others => (others => '0'));
            soft_input_2_2_2_pass_2 <= (others => (others => '0'));
            soft_input_2_2_3_pass_2 <= (others => (others => '0'));
            soft_input_2_2_4_pass_2 <= (others => (others => '0'));
            soft_input_2_3_1_pass_2 <= (others => (others => '0'));
            soft_input_2_3_2_pass_2 <= (others => (others => '0'));
            soft_input_2_3_3_pass_2 <= (others => (others => '0'));
            soft_input_2_3_4_pass_2 <= (others => (others => '0'));
            soft_input_2_4_1_pass_2 <= (others => (others => '0'));
            soft_input_2_4_2_pass_2 <= (others => (others => '0'));
            soft_input_2_4_3_pass_2 <= (others => (others => '0'));
            soft_input_2_4_4_pass_2 <= (others => (others => '0'));
            soft_input_3_1_1_pass_2 <= (others => (others => '0'));
            soft_input_3_1_2_pass_2 <= (others => (others => '0'));
            soft_input_3_1_3_pass_2 <= (others => (others => '0'));
            soft_input_3_1_4_pass_2 <= (others => (others => '0'));
            soft_input_3_2_1_pass_2 <= (others => (others => '0'));
            soft_input_3_2_2_pass_2 <= (others => (others => '0'));
            soft_input_3_2_3_pass_2 <= (others => (others => '0'));
            soft_input_3_2_4_pass_2 <= (others => (others => '0'));
            soft_input_3_3_1_pass_2 <= (others => (others => '0'));
            soft_input_3_3_2_pass_2 <= (others => (others => '0'));
            soft_input_3_3_3_pass_2 <= (others => (others => '0'));
            soft_input_3_3_4_pass_2 <= (others => (others => '0'));
            soft_input_3_4_1_pass_2 <= (others => (others => '0'));
            soft_input_3_4_2_pass_2 <= (others => (others => '0'));
            soft_input_3_4_3_pass_2 <= (others => (others => '0'));
            soft_input_3_4_4_pass_2 <= (others => (others => '0'));
            soft_input_4_1_1_pass_2 <= (others => (others => '0'));
            soft_input_4_1_2_pass_2 <= (others => (others => '0'));
            soft_input_4_1_3_pass_2 <= (others => (others => '0'));
            soft_input_4_1_4_pass_2 <= (others => (others => '0'));
            soft_input_4_2_1_pass_2 <= (others => (others => '0'));
            soft_input_4_2_2_pass_2 <= (others => (others => '0'));
            soft_input_4_2_3_pass_2 <= (others => (others => '0'));
            soft_input_4_2_4_pass_2 <= (others => (others => '0'));
            soft_input_4_3_1_pass_2 <= (others => (others => '0'));
            soft_input_4_3_2_pass_2 <= (others => (others => '0'));
            soft_input_4_3_3_pass_2 <= (others => (others => '0'));
            soft_input_4_3_4_pass_2 <= (others => (others => '0'));
            soft_input_4_4_1_pass_2 <= (others => (others => '0'));
            soft_input_4_4_2_pass_2 <= (others => (others => '0'));
            soft_input_4_4_3_pass_2 <= (others => (others => '0'));
            soft_input_4_4_4_pass_2 <= (others => (others => '0'));
            digit_2_pass            <= 0;
            digit_3_pass            <= 0;
            weight_info_1_r1        <= (others => '0');
            weight_info_1_r2        <= (others => '0');
            weight_info_1_r3        <= (others => '0');
            weight_info_1_r4        <= (others => '0');
            weight_info_1_r5        <= (others => '0');
            weight_info_1_r6        <= (others => '0');
            weight_info_1_r7        <= (others => '0');
            weight_info_1_r8        <= (others => '0');
            weight_info_1_r9        <= (others => '0');
            weight_info_1_r10       <= (others => '0');
            weight_info_1_r11       <= (others => '0');
            weight_info_1_r12       <= (others => '0');
            weight_info_1_r13       <= (others => '0');
            weight_info_1_r14       <= (others => '0');
            weight_info_1_r15       <= (others => '0');
            weight_info_1_r16       <= (others => '0');
        elsif (rising_edge(clk)) then
            soft_input_unflipped_8  <= soft_input_unflipped_7;
            soft_input_pass_5       <= soft_input_pass_5_ext;
            hard_input_5            <= hard_input_5_ext;
            weight_in_5             <= weight_in_5_ext;
            corrections_in_5        <= corrections_in_5_ext;
            error_position_5        <= error_position_5_ext;
            indi_2_1_1_pass_1       <= indi_2_1_1_pass_1_ext;
            indi_2_1_2_pass_1       <= indi_2_1_2_pass_1_ext;
            indi_2_1_3_pass_1       <= indi_2_1_3_pass_1_ext;
            indi_2_1_4_pass_1       <= indi_2_1_4_pass_1_ext;
            indi_2_2_1_pass_1       <= indi_2_2_1_pass_1_ext;
            indi_2_2_2_pass_1       <= indi_2_2_2_pass_1_ext;
            indi_2_2_3_pass_1       <= indi_2_2_3_pass_1_ext;
            indi_2_2_4_pass_1       <= indi_2_2_4_pass_1_ext;
            indi_2_3_1_pass_1       <= indi_2_3_1_pass_1_ext;
            indi_2_3_2_pass_1       <= indi_2_3_2_pass_1_ext;
            indi_2_3_3_pass_1       <= indi_2_3_3_pass_1_ext;
            indi_2_3_4_pass_1       <= indi_2_3_4_pass_1_ext;
            indi_2_4_1_pass_1       <= indi_2_4_1_pass_1_ext;
            indi_2_4_2_pass_1       <= indi_2_4_2_pass_1_ext;
            indi_2_4_3_pass_1       <= indi_2_4_3_pass_1_ext;
            indi_2_4_4_pass_1       <= indi_2_4_4_pass_1_ext;
            indi_3_1_1_pass_1       <= indi_3_1_1_pass_1_ext;
            indi_3_1_2_pass_1       <= indi_3_1_2_pass_1_ext;
            indi_3_1_3_pass_1       <= indi_3_1_3_pass_1_ext;
            indi_3_1_4_pass_1       <= indi_3_1_4_pass_1_ext;
            indi_3_2_1_pass_1       <= indi_3_2_1_pass_1_ext;
            indi_3_2_2_pass_1       <= indi_3_2_2_pass_1_ext;
            indi_3_2_3_pass_1       <= indi_3_2_3_pass_1_ext;
            indi_3_2_4_pass_1       <= indi_3_2_4_pass_1_ext;
            indi_3_3_1_pass_1       <= indi_3_3_1_pass_1_ext;
            indi_3_3_2_pass_1       <= indi_3_3_2_pass_1_ext;
            indi_3_3_3_pass_1       <= indi_3_3_3_pass_1_ext;
            indi_3_3_4_pass_1       <= indi_3_3_4_pass_1_ext;
            indi_3_4_1_pass_1       <= indi_3_4_1_pass_1_ext;
            indi_3_4_2_pass_1       <= indi_3_4_2_pass_1_ext;
            indi_3_4_3_pass_1       <= indi_3_4_3_pass_1_ext;
            indi_3_4_4_pass_1       <= indi_3_4_4_pass_1_ext;
            soft_input_1_1_1_pass_2 <= soft_input_1_1_1_pass_2_ext;
            soft_input_1_1_2_pass_2 <= soft_input_1_1_2_pass_2_ext;
            soft_input_1_1_3_pass_2 <= soft_input_1_1_3_pass_2_ext;
            soft_input_1_1_4_pass_2 <= soft_input_1_1_4_pass_2_ext;
            soft_input_1_2_1_pass_2 <= soft_input_1_2_1_pass_2_ext;
            soft_input_1_2_2_pass_2 <= soft_input_1_2_2_pass_2_ext;
            soft_input_1_2_3_pass_2 <= soft_input_1_2_3_pass_2_ext;
            soft_input_1_2_4_pass_2 <= soft_input_1_2_4_pass_2_ext;
            soft_input_1_3_1_pass_2 <= soft_input_1_3_1_pass_2_ext;
            soft_input_1_3_2_pass_2 <= soft_input_1_3_2_pass_2_ext;
            soft_input_1_3_3_pass_2 <= soft_input_1_3_3_pass_2_ext;
            soft_input_1_3_4_pass_2 <= soft_input_1_3_4_pass_2_ext;
            soft_input_1_4_1_pass_2 <= soft_input_1_4_1_pass_2_ext;
            soft_input_1_4_2_pass_2 <= soft_input_1_4_2_pass_2_ext;
            soft_input_1_4_3_pass_2 <= soft_input_1_4_3_pass_2_ext;
            soft_input_1_4_4_pass_2 <= soft_input_1_4_4_pass_2_ext;
            soft_input_2_1_1_pass_2 <= soft_input_2_1_1_pass_2_ext;
            soft_input_2_1_2_pass_2 <= soft_input_2_1_2_pass_2_ext;
            soft_input_2_1_3_pass_2 <= soft_input_2_1_3_pass_2_ext;
            soft_input_2_1_4_pass_2 <= soft_input_2_1_4_pass_2_ext;
            soft_input_2_2_1_pass_2 <= soft_input_2_2_1_pass_2_ext;
            soft_input_2_2_2_pass_2 <= soft_input_2_2_2_pass_2_ext;
            soft_input_2_2_3_pass_2 <= soft_input_2_2_3_pass_2_ext;
            soft_input_2_2_4_pass_2 <= soft_input_2_2_4_pass_2_ext;
            soft_input_2_3_1_pass_2 <= soft_input_2_3_1_pass_2_ext;
            soft_input_2_3_2_pass_2 <= soft_input_2_3_2_pass_2_ext;
            soft_input_2_3_3_pass_2 <= soft_input_2_3_3_pass_2_ext;
            soft_input_2_3_4_pass_2 <= soft_input_2_3_4_pass_2_ext;
            soft_input_2_4_1_pass_2 <= soft_input_2_4_1_pass_2_ext;
            soft_input_2_4_2_pass_2 <= soft_input_2_4_2_pass_2_ext;
            soft_input_2_4_3_pass_2 <= soft_input_2_4_3_pass_2_ext;
            soft_input_2_4_4_pass_2 <= soft_input_2_4_4_pass_2_ext;
            soft_input_3_1_1_pass_2 <= soft_input_3_1_1_pass_2_ext;
            soft_input_3_1_2_pass_2 <= soft_input_3_1_2_pass_2_ext;
            soft_input_3_1_3_pass_2 <= soft_input_3_1_3_pass_2_ext;
            soft_input_3_1_4_pass_2 <= soft_input_3_1_4_pass_2_ext;
            soft_input_3_2_1_pass_2 <= soft_input_3_2_1_pass_2_ext;
            soft_input_3_2_2_pass_2 <= soft_input_3_2_2_pass_2_ext;
            soft_input_3_2_3_pass_2 <= soft_input_3_2_3_pass_2_ext;
            soft_input_3_2_4_pass_2 <= soft_input_3_2_4_pass_2_ext;
            soft_input_3_3_1_pass_2 <= soft_input_3_3_1_pass_2_ext;
            soft_input_3_3_2_pass_2 <= soft_input_3_3_2_pass_2_ext;
            soft_input_3_3_3_pass_2 <= soft_input_3_3_3_pass_2_ext;
            soft_input_3_3_4_pass_2 <= soft_input_3_3_4_pass_2_ext;
            soft_input_3_4_1_pass_2 <= soft_input_3_4_1_pass_2_ext;
            soft_input_3_4_2_pass_2 <= soft_input_3_4_2_pass_2_ext;
            soft_input_3_4_3_pass_2 <= soft_input_3_4_3_pass_2_ext;
            soft_input_3_4_4_pass_2 <= soft_input_3_4_4_pass_2_ext;
            soft_input_4_1_1_pass_2 <= soft_input_4_1_1_pass_2_ext;
            soft_input_4_1_2_pass_2 <= soft_input_4_1_2_pass_2_ext;
            soft_input_4_1_3_pass_2 <= soft_input_4_1_3_pass_2_ext;
            soft_input_4_1_4_pass_2 <= soft_input_4_1_4_pass_2_ext;
            soft_input_4_2_1_pass_2 <= soft_input_4_2_1_pass_2_ext;
            soft_input_4_2_2_pass_2 <= soft_input_4_2_2_pass_2_ext;
            soft_input_4_2_3_pass_2 <= soft_input_4_2_3_pass_2_ext;
            soft_input_4_2_4_pass_2 <= soft_input_4_2_4_pass_2_ext;
            soft_input_4_3_1_pass_2 <= soft_input_4_3_1_pass_2_ext;
            soft_input_4_3_2_pass_2 <= soft_input_4_3_2_pass_2_ext;
            soft_input_4_3_3_pass_2 <= soft_input_4_3_3_pass_2_ext;
            soft_input_4_3_4_pass_2 <= soft_input_4_3_4_pass_2_ext;
            soft_input_4_4_1_pass_2 <= soft_input_4_4_1_pass_2_ext;
            soft_input_4_4_2_pass_2 <= soft_input_4_4_2_pass_2_ext;
            soft_input_4_4_3_pass_2 <= soft_input_4_4_3_pass_2_ext;
            soft_input_4_4_4_pass_2 <= soft_input_4_4_4_pass_2_ext;
            weight_info_1_r1        <= (others => '0');
            weight_info_1_r2        <= (others => '0');
            weight_info_1_r3        <= (others => '0');
            weight_info_1_r4        <= (others => '0');
            weight_info_1_r5        <= (others => '0');
            weight_info_1_r6        <= (others => '0');
            weight_info_1_r7        <= (others => '0');
            weight_info_1_r8        <= (others => '0');
            weight_info_1_r9        <= (others => '0');
            weight_info_1_r10       <= (others => '0');
            weight_info_1_r11       <= (others => '0');
            weight_info_1_r12       <= (others => '0');
            weight_info_1_r13       <= (others => '0');
            weight_info_1_r14       <= (others => '0');
            weight_info_1_r15       <= (others => '0');
            weight_info_1_r16       <= (others => '0');
            digit_2_pass            <= digit_2;
            digit_3_pass            <= digit_3;
            if indi_1_1_1_pass_1_ext = "001" then
                weight_info_1_r1 <= soft_input_1_1_1_pass_2_ext(digit_1);
            elsif indi_1_1_1_pass_1_ext = "010" then
                weight_info_1_r1 <= soft_input_1_1_2_pass_2_ext(digit_1);
            elsif indi_1_1_1_pass_1_ext = "011" then
                weight_info_1_r1 <= soft_input_1_1_3_pass_2_ext(digit_1);
            elsif indi_1_1_1_pass_1_ext = "100" then
                weight_info_1_r1 <= soft_input_1_1_4_pass_2_ext(digit_1);
            end if;
            ------------------------------------------------------------------------------------------------------------------------------------
            if indi_1_1_2_pass_1_ext = "001" then
                weight_info_1_r2 <= soft_input_1_2_1_pass_2_ext(digit_1);
            elsif indi_1_1_2_pass_1_ext = "010" then
                weight_info_1_r2 <= soft_input_1_2_2_pass_2_ext(digit_1);
            elsif indi_1_1_2_pass_1_ext = "011" then
                weight_info_1_r2 <= soft_input_1_2_3_pass_2_ext(digit_1);
            elsif indi_1_1_2_pass_1_ext = "100" then
                weight_info_1_r2 <= soft_input_1_2_4_pass_2_ext(digit_1);
            end if;
            ------------------------------------------------------------------------------------------------------------------------------------
            if indi_1_1_3_pass_1_ext = "001" then
                weight_info_1_r3 <= soft_input_1_3_1_pass_2_ext(digit_1);
            elsif indi_1_1_3_pass_1_ext = "010" then
                weight_info_1_r3 <= soft_input_1_3_2_pass_2_ext(digit_1);
            elsif indi_1_1_3_pass_1_ext = "011" then
                weight_info_1_r3 <= soft_input_1_3_3_pass_2_ext(digit_1);
            elsif indi_1_1_3_pass_1_ext = "100" then
                weight_info_1_r3 <= soft_input_1_3_4_pass_2_ext(digit_1);
            end if;
            ------------------------------------------------------------------------------------------------------------------------------------
            if indi_1_1_4_pass_1_ext = "001" then
                weight_info_1_r4 <= soft_input_1_4_1_pass_2_ext(digit_1);
            elsif indi_1_1_4_pass_1_ext = "010" then
                weight_info_1_r4 <= soft_input_1_4_2_pass_2_ext(digit_1);
            elsif indi_1_1_4_pass_1_ext = "011" then
                weight_info_1_r4 <= soft_input_1_4_3_pass_2_ext(digit_1);
            elsif indi_1_1_4_pass_1_ext = "100" then
                weight_info_1_r4 <= soft_input_1_4_4_pass_2_ext(digit_1);
            end if;
            ------------------------------------------------------------------------------------------------------------------------------------
            if indi_1_2_1_pass_1_ext = "001" then
                weight_info_1_r5 <= soft_input_2_1_1_pass_2_ext(digit_1);
            elsif indi_1_2_1_pass_1_ext = "010" then
                weight_info_1_r5 <= soft_input_2_1_2_pass_2_ext(digit_1);
            elsif indi_1_2_1_pass_1_ext = "011" then
                weight_info_1_r5 <= soft_input_2_1_3_pass_2_ext(digit_1);
            elsif indi_1_2_1_pass_1_ext = "100" then
                weight_info_1_r5 <= soft_input_2_1_4_pass_2_ext(digit_1);
            end if;
            ------------------------------------------------------------------------------------------------------------------------------------
            if indi_1_2_2_pass_1_ext = "001" then
                weight_info_1_r6 <= soft_input_2_2_1_pass_2_ext(digit_1);
            elsif indi_1_2_2_pass_1_ext = "010" then
                weight_info_1_r6 <= soft_input_2_2_2_pass_2_ext(digit_1);
            elsif indi_1_2_2_pass_1_ext = "011" then
                weight_info_1_r6 <= soft_input_2_2_3_pass_2_ext(digit_1);
            elsif indi_1_2_2_pass_1_ext = "100" then
                weight_info_1_r6 <= soft_input_2_2_4_pass_2_ext(digit_1);
            end if;
            ------------------------------------------------------------------------------------------------------------------------------------
            if indi_1_2_3_pass_1_ext = "001" then
                weight_info_1_r7 <= soft_input_2_3_1_pass_2_ext(digit_1);
            elsif indi_1_2_3_pass_1_ext = "010" then
                weight_info_1_r7 <= soft_input_2_3_2_pass_2_ext(digit_1);
            elsif indi_1_2_3_pass_1_ext = "011" then
                weight_info_1_r7 <= soft_input_2_3_3_pass_2_ext(digit_1);
            elsif indi_1_2_3_pass_1_ext = "100" then
                weight_info_1_r7 <= soft_input_2_3_4_pass_2_ext(digit_1);
            end if;
            ------------------------------------------------------------------------------------------------------------------------------------
            if indi_1_2_4_pass_1_ext = "001" then
                weight_info_1_r8 <= soft_input_2_4_1_pass_2_ext(digit_1);
            elsif indi_1_2_4_pass_1_ext = "010" then
                weight_info_1_r8 <= soft_input_2_4_2_pass_2_ext(digit_1);
            elsif indi_1_2_4_pass_1_ext = "011" then
                weight_info_1_r8 <= soft_input_2_4_3_pass_2_ext(digit_1);
            elsif indi_1_2_4_pass_1_ext = "100" then
                weight_info_1_r8 <= soft_input_2_4_4_pass_2_ext(digit_1);
            end if;
            ------------------------------------------------------------------------------------------------------------------------------------
            if indi_1_3_1_pass_1_ext = "001" then
                weight_info_1_r9 <= soft_input_3_1_1_pass_2_ext(digit_1);
            elsif indi_1_3_1_pass_1_ext = "010" then
                weight_info_1_r9 <= soft_input_3_1_2_pass_2_ext(digit_1);
            elsif indi_1_3_1_pass_1_ext = "011" then
                weight_info_1_r9 <= soft_input_3_1_3_pass_2_ext(digit_1);
            elsif indi_1_3_1_pass_1_ext = "100" then
                weight_info_1_r9 <= soft_input_3_1_4_pass_2_ext(digit_1);
            end if;
            ------------------------------------------------------------------------------------------------------------------------------------
            if indi_1_3_2_pass_1_ext = "001" then
                weight_info_1_r10 <= soft_input_3_2_1_pass_2_ext(digit_1);
            elsif indi_1_3_2_pass_1_ext = "010" then
                weight_info_1_r10 <= soft_input_3_2_2_pass_2_ext(digit_1);
            elsif indi_1_3_2_pass_1_ext = "011" then
                weight_info_1_r10 <= soft_input_3_2_3_pass_2_ext(digit_1);
            elsif indi_1_3_2_pass_1_ext = "100" then
                weight_info_1_r10 <= soft_input_3_2_4_pass_2_ext(digit_1);
            end if;
            ------------------------------------------------------------------------------------------------------------------------------------
            if indi_1_3_3_pass_1_ext = "001" then
                weight_info_1_r11 <= soft_input_3_3_1_pass_2_ext(digit_1);
            elsif indi_1_3_3_pass_1_ext = "010" then
                weight_info_1_r11 <= soft_input_3_3_2_pass_2_ext(digit_1);
            elsif indi_1_3_3_pass_1_ext = "011" then
                weight_info_1_r11 <= soft_input_3_3_3_pass_2_ext(digit_1);
            elsif indi_1_3_3_pass_1_ext = "100" then
                weight_info_1_r11 <= soft_input_3_3_4_pass_2_ext(digit_1);
            end if;
            ------------------------------------------------------------------------------------------------------------------------------------
            if indi_1_3_4_pass_1_ext = "001" then
                weight_info_1_r12 <= soft_input_3_4_1_pass_2_ext(digit_1);
            elsif indi_1_3_4_pass_1_ext = "010" then
                weight_info_1_r12 <= soft_input_3_4_2_pass_2_ext(digit_1);
            elsif indi_1_3_4_pass_1_ext = "011" then
                weight_info_1_r12 <= soft_input_3_4_3_pass_2_ext(digit_1);
            elsif indi_1_3_4_pass_1_ext = "100" then
                weight_info_1_r12 <= soft_input_3_4_4_pass_2_ext(digit_1);
            end if;
            ------------------------------------------------------------------------------------------------------------------------------------
            if indi_1_4_1_pass_1_ext = "001" then
                weight_info_1_r13 <= soft_input_4_1_1_pass_2_ext(digit_1);
            elsif indi_1_4_1_pass_1_ext = "010" then
                weight_info_1_r13 <= soft_input_4_1_2_pass_2_ext(digit_1);
            elsif indi_1_4_1_pass_1_ext = "011" then
                weight_info_1_r13 <= soft_input_4_1_3_pass_2_ext(digit_1);
            elsif indi_1_4_1_pass_1_ext = "100" then
                weight_info_1_r13 <= soft_input_4_1_4_pass_2_ext(digit_1);
            end if;
            ------------------------------------------------------------------------------------------------------------------------------------
            if indi_1_4_2_pass_1_ext = "001" then
                weight_info_1_r14 <= soft_input_4_2_1_pass_2_ext(digit_1);
            elsif indi_1_4_2_pass_1_ext = "010" then
                weight_info_1_r14 <= soft_input_4_2_2_pass_2_ext(digit_1);
            elsif indi_1_4_2_pass_1_ext = "011" then
                weight_info_1_r14 <= soft_input_4_2_3_pass_2_ext(digit_1);
            elsif indi_1_4_2_pass_1_ext = "100" then
                weight_info_1_r14 <= soft_input_4_2_4_pass_2_ext(digit_1);
            end if;
            ------------------------------------------------------------------------------------------------------------------------------------
            if indi_1_4_3_pass_1_ext = "001" then
                weight_info_1_r15 <= soft_input_4_3_1_pass_2_ext(digit_1);
            elsif indi_1_4_3_pass_1_ext = "010" then
                weight_info_1_r15 <= soft_input_4_3_2_pass_2_ext(digit_1);
            elsif indi_1_4_3_pass_1_ext = "011" then
                weight_info_1_r15 <= soft_input_4_3_3_pass_2_ext(digit_1);
            elsif indi_1_4_3_pass_1_ext = "100" then
                weight_info_1_r15 <= soft_input_4_3_4_pass_2_ext(digit_1);
            end if;
            ------------------------------------------------------------------------------------------------------------------------------------
            if indi_1_4_4_pass_1_ext = "001" then
                weight_info_1_r16 <= soft_input_4_4_1_pass_2_ext(digit_1);
            elsif indi_1_4_4_pass_1_ext = "010" then
                weight_info_1_r16 <= soft_input_4_4_2_pass_2_ext(digit_1);
            elsif indi_1_4_4_pass_1_ext = "011" then
                weight_info_1_r16 <= soft_input_4_4_3_pass_2_ext(digit_1);
            elsif indi_1_4_4_pass_1_ext = "100" then
                weight_info_1_r16 <= soft_input_4_4_4_pass_2_ext(digit_1);
            end if;
        end if;
    end process;
    ------------------------------------------------------------------------------------------------------------
    -- Define processes : (CLK 8)
    ------------------------------------------------------------------------------------------------------------
    process (clk, reset)
    begin
        if (reset = '1') then
            soft_input_unflipped_9  <= (others => (others => '0'));
            soft_input_pass_6       <= (others => (others => '0'));
            hard_input_6            <= (others => '0');
            weight_in_6             <= (others => '0');
            corrections_in_6        <= (others => '0');
            error_position_6        <= (others => 0);
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
            soft_input_1_1_1_pass_3 <= (others => (others => '0'));
            soft_input_1_1_2_pass_3 <= (others => (others => '0'));
            soft_input_1_1_3_pass_3 <= (others => (others => '0'));
            soft_input_1_1_4_pass_3 <= (others => (others => '0'));
            soft_input_1_2_1_pass_3 <= (others => (others => '0'));
            soft_input_1_2_2_pass_3 <= (others => (others => '0'));
            soft_input_1_2_3_pass_3 <= (others => (others => '0'));
            soft_input_1_2_4_pass_3 <= (others => (others => '0'));
            soft_input_1_3_1_pass_3 <= (others => (others => '0'));
            soft_input_1_3_2_pass_3 <= (others => (others => '0'));
            soft_input_1_3_3_pass_3 <= (others => (others => '0'));
            soft_input_1_3_4_pass_3 <= (others => (others => '0'));
            soft_input_1_4_1_pass_3 <= (others => (others => '0'));
            soft_input_1_4_2_pass_3 <= (others => (others => '0'));
            soft_input_1_4_3_pass_3 <= (others => (others => '0'));
            soft_input_1_4_4_pass_3 <= (others => (others => '0'));
            soft_input_2_1_1_pass_3 <= (others => (others => '0'));
            soft_input_2_1_2_pass_3 <= (others => (others => '0'));
            soft_input_2_1_3_pass_3 <= (others => (others => '0'));
            soft_input_2_1_4_pass_3 <= (others => (others => '0'));
            soft_input_2_2_1_pass_3 <= (others => (others => '0'));
            soft_input_2_2_2_pass_3 <= (others => (others => '0'));
            soft_input_2_2_3_pass_3 <= (others => (others => '0'));
            soft_input_2_2_4_pass_3 <= (others => (others => '0'));
            soft_input_2_3_1_pass_3 <= (others => (others => '0'));
            soft_input_2_3_2_pass_3 <= (others => (others => '0'));
            soft_input_2_3_3_pass_3 <= (others => (others => '0'));
            soft_input_2_3_4_pass_3 <= (others => (others => '0'));
            soft_input_2_4_1_pass_3 <= (others => (others => '0'));
            soft_input_2_4_2_pass_3 <= (others => (others => '0'));
            soft_input_2_4_3_pass_3 <= (others => (others => '0'));
            soft_input_2_4_4_pass_3 <= (others => (others => '0'));
            soft_input_3_1_1_pass_3 <= (others => (others => '0'));
            soft_input_3_1_2_pass_3 <= (others => (others => '0'));
            soft_input_3_1_3_pass_3 <= (others => (others => '0'));
            soft_input_3_1_4_pass_3 <= (others => (others => '0'));
            soft_input_3_2_1_pass_3 <= (others => (others => '0'));
            soft_input_3_2_2_pass_3 <= (others => (others => '0'));
            soft_input_3_2_3_pass_3 <= (others => (others => '0'));
            soft_input_3_2_4_pass_3 <= (others => (others => '0'));
            soft_input_3_3_1_pass_3 <= (others => (others => '0'));
            soft_input_3_3_2_pass_3 <= (others => (others => '0'));
            soft_input_3_3_3_pass_3 <= (others => (others => '0'));
            soft_input_3_3_4_pass_3 <= (others => (others => '0'));
            soft_input_3_4_1_pass_3 <= (others => (others => '0'));
            soft_input_3_4_2_pass_3 <= (others => (others => '0'));
            soft_input_3_4_3_pass_3 <= (others => (others => '0'));
            soft_input_3_4_4_pass_3 <= (others => (others => '0'));
            soft_input_4_1_1_pass_3 <= (others => (others => '0'));
            soft_input_4_1_2_pass_3 <= (others => (others => '0'));
            soft_input_4_1_3_pass_3 <= (others => (others => '0'));
            soft_input_4_1_4_pass_3 <= (others => (others => '0'));
            soft_input_4_2_1_pass_3 <= (others => (others => '0'));
            soft_input_4_2_2_pass_3 <= (others => (others => '0'));
            soft_input_4_2_3_pass_3 <= (others => (others => '0'));
            soft_input_4_2_4_pass_3 <= (others => (others => '0'));
            soft_input_4_3_1_pass_3 <= (others => (others => '0'));
            soft_input_4_3_2_pass_3 <= (others => (others => '0'));
            soft_input_4_3_3_pass_3 <= (others => (others => '0'));
            soft_input_4_3_4_pass_3 <= (others => (others => '0'));
            soft_input_4_4_1_pass_3 <= (others => (others => '0'));
            soft_input_4_4_2_pass_3 <= (others => (others => '0'));
            soft_input_4_4_3_pass_3 <= (others => (others => '0'));
            soft_input_4_4_4_pass_3 <= (others => (others => '0'));
            digit_3_pass_1          <= 0;
            weight_info_1_p1        <= (others => '0');
            weight_info_1_p2        <= (others => '0');
            weight_info_1_p3        <= (others => '0');
            weight_info_1_p4        <= (others => '0');
            weight_info_2_r1        <= (others => '0');
            weight_info_2_r2        <= (others => '0');
            weight_info_2_r3        <= (others => '0');
            weight_info_2_r4        <= (others => '0');
            weight_info_2_r5        <= (others => '0');
            weight_info_2_r6        <= (others => '0');
            weight_info_2_r7        <= (others => '0');
            weight_info_2_r8        <= (others => '0');
            weight_info_2_r9        <= (others => '0');
            weight_info_2_r10       <= (others => '0');
            weight_info_2_r11       <= (others => '0');
            weight_info_2_r12       <= (others => '0');
            weight_info_2_r13       <= (others => '0');
            weight_info_2_r14       <= (others => '0');
            weight_info_2_r15       <= (others => '0');
            weight_info_2_r16       <= (others => '0');
        elsif (rising_edge(clk)) then
            soft_input_unflipped_9  <= soft_input_unflipped_8;
            weight_info_1_p1        <= weight_info_1_r1 xor weight_info_1_r2 xor weight_info_1_r3 xor weight_info_1_r4;
            weight_info_1_p2        <= weight_info_1_r5 xor weight_info_1_r6 xor weight_info_1_r7 xor weight_info_1_r8;
            weight_info_1_p3        <= weight_info_1_r9 xor weight_info_1_r10 xor weight_info_1_r11 xor weight_info_1_r12;
            weight_info_1_p4        <= weight_info_1_r13 xor weight_info_1_r14 xor weight_info_1_r15 xor weight_info_1_r16;
            digit_3_pass_1          <= digit_3_pass;
            soft_input_pass_6       <= soft_input_pass_5;
            hard_input_6            <= hard_input_5;
            weight_in_6             <= weight_in_5;
            corrections_in_6        <= corrections_in_5;
            error_position_6        <= error_position_5;
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
            soft_input_1_1_1_pass_3 <= soft_input_1_1_1_pass_2;
            soft_input_1_1_2_pass_3 <= soft_input_1_1_2_pass_2;
            soft_input_1_1_3_pass_3 <= soft_input_1_1_3_pass_2;
            soft_input_1_1_4_pass_3 <= soft_input_1_1_4_pass_2;
            soft_input_1_2_1_pass_3 <= soft_input_1_2_1_pass_2;
            soft_input_1_2_2_pass_3 <= soft_input_1_2_2_pass_2;
            soft_input_1_2_3_pass_3 <= soft_input_1_2_3_pass_2;
            soft_input_1_2_4_pass_3 <= soft_input_1_2_4_pass_2;
            soft_input_1_3_1_pass_3 <= soft_input_1_3_1_pass_2;
            soft_input_1_3_2_pass_3 <= soft_input_1_3_2_pass_2;
            soft_input_1_3_3_pass_3 <= soft_input_1_3_3_pass_2;
            soft_input_1_3_4_pass_3 <= soft_input_1_3_4_pass_2;
            soft_input_1_4_1_pass_3 <= soft_input_1_4_1_pass_2;
            soft_input_1_4_2_pass_3 <= soft_input_1_4_2_pass_2;
            soft_input_1_4_3_pass_3 <= soft_input_1_4_3_pass_2;
            soft_input_1_4_4_pass_3 <= soft_input_1_4_4_pass_2;
            soft_input_2_1_1_pass_3 <= soft_input_2_1_1_pass_2;
            soft_input_2_1_2_pass_3 <= soft_input_2_1_2_pass_2;
            soft_input_2_1_3_pass_3 <= soft_input_2_1_3_pass_2;
            soft_input_2_1_4_pass_3 <= soft_input_2_1_4_pass_2;
            soft_input_2_2_1_pass_3 <= soft_input_2_2_1_pass_2;
            soft_input_2_2_2_pass_3 <= soft_input_2_2_2_pass_2;
            soft_input_2_2_3_pass_3 <= soft_input_2_2_3_pass_2;
            soft_input_2_2_4_pass_3 <= soft_input_2_2_4_pass_2;
            soft_input_2_3_1_pass_3 <= soft_input_2_3_1_pass_2;
            soft_input_2_3_2_pass_3 <= soft_input_2_3_2_pass_2;
            soft_input_2_3_3_pass_3 <= soft_input_2_3_3_pass_2;
            soft_input_2_3_4_pass_3 <= soft_input_2_3_4_pass_2;
            soft_input_2_4_1_pass_3 <= soft_input_2_4_1_pass_2;
            soft_input_2_4_2_pass_3 <= soft_input_2_4_2_pass_2;
            soft_input_2_4_3_pass_3 <= soft_input_2_4_3_pass_2;
            soft_input_2_4_4_pass_3 <= soft_input_2_4_4_pass_2;
            soft_input_3_1_1_pass_3 <= soft_input_3_1_1_pass_2;
            soft_input_3_1_2_pass_3 <= soft_input_3_1_2_pass_2;
            soft_input_3_1_3_pass_3 <= soft_input_3_1_3_pass_2;
            soft_input_3_1_4_pass_3 <= soft_input_3_1_4_pass_2;
            soft_input_3_2_1_pass_3 <= soft_input_3_2_1_pass_2;
            soft_input_3_2_2_pass_3 <= soft_input_3_2_2_pass_2;
            soft_input_3_2_3_pass_3 <= soft_input_3_2_3_pass_2;
            soft_input_3_2_4_pass_3 <= soft_input_3_2_4_pass_2;
            soft_input_3_3_1_pass_3 <= soft_input_3_3_1_pass_2;
            soft_input_3_3_2_pass_3 <= soft_input_3_3_2_pass_2;
            soft_input_3_3_3_pass_3 <= soft_input_3_3_3_pass_2;
            soft_input_3_3_4_pass_3 <= soft_input_3_3_4_pass_2;
            soft_input_3_4_1_pass_3 <= soft_input_3_4_1_pass_2;
            soft_input_3_4_2_pass_3 <= soft_input_3_4_2_pass_2;
            soft_input_3_4_3_pass_3 <= soft_input_3_4_3_pass_2;
            soft_input_3_4_4_pass_3 <= soft_input_3_4_4_pass_2;
            soft_input_4_1_1_pass_3 <= soft_input_4_1_1_pass_2;
            soft_input_4_1_2_pass_3 <= soft_input_4_1_2_pass_2;
            soft_input_4_1_3_pass_3 <= soft_input_4_1_3_pass_2;
            soft_input_4_1_4_pass_3 <= soft_input_4_1_4_pass_2;
            soft_input_4_2_1_pass_3 <= soft_input_4_2_1_pass_2;
            soft_input_4_2_2_pass_3 <= soft_input_4_2_2_pass_2;
            soft_input_4_2_3_pass_3 <= soft_input_4_2_3_pass_2;
            soft_input_4_2_4_pass_3 <= soft_input_4_2_4_pass_2;
            soft_input_4_3_1_pass_3 <= soft_input_4_3_1_pass_2;
            soft_input_4_3_2_pass_3 <= soft_input_4_3_2_pass_2;
            soft_input_4_3_3_pass_3 <= soft_input_4_3_3_pass_2;
            soft_input_4_3_4_pass_3 <= soft_input_4_3_4_pass_2;
            soft_input_4_4_1_pass_3 <= soft_input_4_4_1_pass_2;
            soft_input_4_4_2_pass_3 <= soft_input_4_4_2_pass_2;
            soft_input_4_4_3_pass_3 <= soft_input_4_4_3_pass_2;
            soft_input_4_4_4_pass_3 <= soft_input_4_4_4_pass_2;
            weight_info_2_r1        <= (others => '0');
            weight_info_2_r2        <= (others => '0');
            weight_info_2_r3        <= (others => '0');
            weight_info_2_r4        <= (others => '0');
            weight_info_2_r5        <= (others => '0');
            weight_info_2_r6        <= (others => '0');
            weight_info_2_r7        <= (others => '0');
            weight_info_2_r8        <= (others => '0');
            weight_info_2_r9        <= (others => '0');
            weight_info_2_r10       <= (others => '0');
            weight_info_2_r11       <= (others => '0');
            weight_info_2_r12       <= (others => '0');
            weight_info_2_r13       <= (others => '0');
            weight_info_2_r14       <= (others => '0');
            weight_info_2_r15       <= (others => '0');
            weight_info_2_r16       <= (others => '0');
            --------------------------------------------------------------------------------------------------------------------------------------
            if indi_2_1_1_pass_1 = "001" then
                weight_info_2_r1 <= soft_input_1_1_1_pass_2(digit_2_pass);
            elsif indi_2_1_1_pass_1 = "010" then
                weight_info_2_r1 <= soft_input_1_1_2_pass_2(digit_2_pass);
            elsif indi_2_1_1_pass_1 = "011" then
                weight_info_2_r1 <= soft_input_1_1_3_pass_2(digit_2_pass);
            elsif indi_2_1_1_pass_1 = "100" then
                weight_info_2_r1 <= soft_input_1_1_4_pass_2(digit_2_pass);
            end if;
            ------------------------------------------------------------------------------------------------------------------------------------
            if indi_2_1_2_pass_1 = "001" then
                weight_info_2_r2 <= soft_input_1_2_1_pass_2(digit_2_pass);
            elsif indi_2_1_2_pass_1 = "010" then
                weight_info_2_r2 <= soft_input_1_2_2_pass_2(digit_2_pass);
            elsif indi_2_1_2_pass_1 = "011" then
                weight_info_2_r2 <= soft_input_1_2_3_pass_2(digit_2_pass);
            elsif indi_2_1_2_pass_1 = "100" then
                weight_info_2_r2 <= soft_input_1_2_4_pass_2(digit_2_pass);
            end if;
            ------------------------------------------------------------------------------------------------------------------------------------
            if indi_2_1_3_pass_1 = "001" then
                weight_info_2_r3 <= soft_input_1_3_1_pass_2(digit_2_pass);
            elsif indi_2_1_3_pass_1 = "010" then
                weight_info_2_r3 <= soft_input_1_3_2_pass_2(digit_2_pass);
            elsif indi_2_1_3_pass_1 = "011" then
                weight_info_2_r3 <= soft_input_1_3_3_pass_2(digit_2_pass);
            elsif indi_2_1_3_pass_1 = "100" then
                weight_info_2_r3 <= soft_input_1_3_4_pass_2(digit_2_pass);
            end if;
            ------------------------------------------------------------------------------------------------------------------------------------
            if indi_2_1_4_pass_1 = "001" then
                weight_info_2_r4 <= soft_input_1_4_1_pass_2(digit_2_pass);
            elsif indi_2_1_4_pass_1 = "010" then
                weight_info_2_r4 <= soft_input_1_4_2_pass_2(digit_2_pass);
            elsif indi_2_1_4_pass_1 = "011" then
                weight_info_2_r4 <= soft_input_1_4_3_pass_2(digit_2_pass);
            elsif indi_2_1_4_pass_1 = "100" then
                weight_info_2_r4 <= soft_input_1_4_4_pass_2(digit_2_pass);
            end if;
            ------------------------------------------------------------------------------------------------------------------------------------
            if indi_2_2_1_pass_1 = "001" then
                weight_info_2_r5 <= soft_input_2_1_1_pass_2(digit_2_pass);
            elsif indi_2_2_1_pass_1 = "010" then
                weight_info_2_r5 <= soft_input_2_1_2_pass_2(digit_2_pass);
            elsif indi_2_2_1_pass_1 = "011" then
                weight_info_2_r5 <= soft_input_2_1_3_pass_2(digit_2_pass);
            elsif indi_2_2_1_pass_1 = "100" then
                weight_info_2_r5 <= soft_input_2_1_4_pass_2(digit_2_pass);
            end if;
            ------------------------------------------------------------------------------------------------------------------------------------
            if indi_2_2_2_pass_1 = "001" then
                weight_info_2_r6 <= soft_input_2_2_1_pass_2(digit_2_pass);
            elsif indi_2_2_2_pass_1 = "010" then
                weight_info_2_r6 <= soft_input_2_2_2_pass_2(digit_2_pass);
            elsif indi_2_2_2_pass_1 = "011" then
                weight_info_2_r6 <= soft_input_2_2_3_pass_2(digit_2_pass);
            elsif indi_2_2_2_pass_1 = "100" then
                weight_info_2_r6 <= soft_input_2_2_4_pass_2(digit_2_pass);
            end if;
            ------------------------------------------------------------------------------------------------------------------------------------
            if indi_2_2_3_pass_1 = "001" then
                weight_info_2_r7 <= soft_input_2_3_1_pass_2(digit_2_pass);
            elsif indi_2_2_3_pass_1 = "010" then
                weight_info_2_r7 <= soft_input_2_3_2_pass_2(digit_2_pass);
            elsif indi_2_2_3_pass_1 = "011" then
                weight_info_2_r7 <= soft_input_2_3_3_pass_2(digit_2_pass);
            elsif indi_2_2_3_pass_1 = "100" then
                weight_info_2_r7 <= soft_input_2_3_4_pass_2(digit_2_pass);
            end if;
            ------------------------------------------------------------------------------------------------------------------------------------
            if indi_2_2_4_pass_1 = "001" then
                weight_info_2_r8 <= soft_input_2_4_1_pass_2(digit_2_pass);
            elsif indi_2_2_4_pass_1 = "010" then
                weight_info_2_r8 <= soft_input_2_4_2_pass_2(digit_2_pass);
            elsif indi_2_2_4_pass_1 = "011" then
                weight_info_2_r8 <= soft_input_2_4_3_pass_2(digit_2_pass);
            elsif indi_2_2_4_pass_1 = "100" then
                weight_info_2_r8 <= soft_input_2_4_4_pass_2(digit_2_pass);
            end if;
            ------------------------------------------------------------------------------------------------------------------------------------
            if indi_2_3_1_pass_1 = "001" then
                weight_info_2_r9 <= soft_input_3_1_1_pass_2(digit_2_pass);
            elsif indi_2_3_1_pass_1 = "010" then
                weight_info_2_r9 <= soft_input_3_1_2_pass_2(digit_2_pass);
            elsif indi_2_3_1_pass_1 = "011" then
                weight_info_2_r9 <= soft_input_3_1_3_pass_2(digit_2_pass);
            elsif indi_2_3_1_pass_1 = "100" then
                weight_info_2_r9 <= soft_input_3_1_4_pass_2(digit_2_pass);
            end if;
            ------------------------------------------------------------------------------------------------------------------------------------
            if indi_2_3_2_pass_1 = "001" then
                weight_info_2_r10 <= soft_input_3_2_1_pass_2(digit_2_pass);
            elsif indi_2_3_2_pass_1 = "010" then
                weight_info_2_r10 <= soft_input_3_2_2_pass_2(digit_2_pass);
            elsif indi_2_3_2_pass_1 = "011" then
                weight_info_2_r10 <= soft_input_3_2_3_pass_2(digit_2_pass);
            elsif indi_2_3_2_pass_1 = "100" then
                weight_info_2_r10 <= soft_input_3_2_4_pass_2(digit_2_pass);
            end if;
            ------------------------------------------------------------------------------------------------------------------------------------
            if indi_2_3_3_pass_1 = "001" then
                weight_info_2_r11 <= soft_input_3_3_1_pass_2(digit_2_pass);
            elsif indi_2_3_3_pass_1 = "010" then
                weight_info_2_r11 <= soft_input_3_3_2_pass_2(digit_2_pass);
            elsif indi_2_3_3_pass_1 = "011" then
                weight_info_2_r11 <= soft_input_3_3_3_pass_2(digit_2_pass);
            elsif indi_2_3_3_pass_1 = "100" then
                weight_info_2_r11 <= soft_input_3_3_4_pass_2(digit_2_pass);
            end if;
            ------------------------------------------------------------------------------------------------------------------------------------
            if indi_2_3_4_pass_1 = "001" then
                weight_info_2_r12 <= soft_input_3_4_1_pass_2(digit_2_pass);
            elsif indi_2_3_4_pass_1 = "010" then
                weight_info_2_r12 <= soft_input_3_4_2_pass_2(digit_2_pass);
            elsif indi_2_3_4_pass_1 = "011" then
                weight_info_2_r12 <= soft_input_3_4_3_pass_2(digit_2_pass);
            elsif indi_2_3_4_pass_1 = "100" then
                weight_info_2_r12 <= soft_input_3_4_4_pass_2(digit_2_pass);
            end if;
            ------------------------------------------------------------------------------------------------------------------------------------
            if indi_2_4_1_pass_1 = "001" then
                weight_info_2_r13 <= soft_input_4_1_1_pass_2(digit_2_pass);
            elsif indi_2_4_1_pass_1 = "010" then
                weight_info_2_r13 <= soft_input_4_1_2_pass_2(digit_2_pass);
            elsif indi_2_4_1_pass_1 = "011" then
                weight_info_2_r13 <= soft_input_4_1_3_pass_2(digit_2_pass);
            elsif indi_2_4_1_pass_1 = "100" then
                weight_info_2_r13 <= soft_input_4_1_4_pass_2(digit_2_pass);
            end if;
            ------------------------------------------------------------------------------------------------------------------------------------
            if indi_2_4_2_pass_1 = "001" then
                weight_info_2_r14 <= soft_input_4_2_1_pass_2(digit_2_pass);
            elsif indi_2_4_2_pass_1 = "010" then
                weight_info_2_r14 <= soft_input_4_2_2_pass_2(digit_2_pass);
            elsif indi_2_4_2_pass_1 = "011" then
                weight_info_2_r14 <= soft_input_4_2_3_pass_2(digit_2_pass);
            elsif indi_2_4_2_pass_1 = "100" then
                weight_info_2_r14 <= soft_input_4_2_4_pass_2(digit_2_pass);
            end if;
            ------------------------------------------------------------------------------------------------------------------------------------
            if indi_2_4_3_pass_1 = "001" then
                weight_info_2_r15 <= soft_input_4_3_1_pass_2(digit_2_pass);
            elsif indi_2_4_3_pass_1 = "010" then
                weight_info_2_r15 <= soft_input_4_3_2_pass_2(digit_2_pass);
            elsif indi_2_4_3_pass_1 = "011" then
                weight_info_2_r15 <= soft_input_4_3_3_pass_2(digit_2_pass);
            elsif indi_2_4_3_pass_1 = "100" then
                weight_info_2_r15 <= soft_input_4_3_4_pass_2(digit_2_pass);
            end if;
            ------------------------------------------------------------------------------------------------------------------------------------
            if indi_2_4_4_pass_1 = "001" then
                weight_info_2_r16 <= soft_input_4_4_1_pass_2(digit_2_pass);
            elsif indi_2_4_4_pass_1 = "010" then
                weight_info_2_r16 <= soft_input_4_4_2_pass_2(digit_2_pass);
            elsif indi_2_4_4_pass_1 = "011" then
                weight_info_2_r16 <= soft_input_4_4_3_pass_2(digit_2_pass);
            elsif indi_2_4_4_pass_1 = "100" then
                weight_info_2_r16 <= soft_input_4_4_4_pass_2(digit_2_pass);
            end if;
        end if;
    end process;
    ------------------------------------------------------------------------------------------------------------
    -- Define processes : (CLK 9)
    ------------------------------------------------------------------------------------------------------------
    process (clk, reset)
    begin
        if (reset = '1') then
            soft_input_unflipped_10 <= (others => (others => '0'));
            soft_input_pass_7       <= (others => (others => '0'));
            hard_input_7            <= (others => '0');
            weight_in_7             <= (others => '0');
            corrections_in_7        <= (others => '0');
            error_position_7        <= (others => 0);
            weight_info_2_p1        <= (others => '0');
            weight_info_2_p2        <= (others => '0');
            weight_info_2_p3        <= (others => '0');
            weight_info_2_p4        <= (others => '0');
            weight_info_1           <= (others => '0');
            weight_info_3_r1        <= (others => '0');
            weight_info_3_r2        <= (others => '0');
            weight_info_3_r3        <= (others => '0');
            weight_info_3_r4        <= (others => '0');
            weight_info_3_r5        <= (others => '0');
            weight_info_3_r6        <= (others => '0');
            weight_info_3_r7        <= (others => '0');
            weight_info_3_r8        <= (others => '0');
            weight_info_3_r9        <= (others => '0');
            weight_info_3_r10       <= (others => '0');
            weight_info_3_r11       <= (others => '0');
            weight_info_3_r12       <= (others => '0');
            weight_info_3_r13       <= (others => '0');
            weight_info_3_r14       <= (others => '0');
            weight_info_3_r15       <= (others => '0');
            weight_info_3_r16       <= (others => '0');
            soft_input_1_1_1_pass_4 <= (others => (others => '0'));
            soft_input_1_1_2_pass_4 <= (others => (others => '0'));
            soft_input_1_1_3_pass_4 <= (others => (others => '0'));
            soft_input_1_1_4_pass_4 <= (others => (others => '0'));
            soft_input_1_2_1_pass_4 <= (others => (others => '0'));
            soft_input_1_2_2_pass_4 <= (others => (others => '0'));
            soft_input_1_2_3_pass_4 <= (others => (others => '0'));
            soft_input_1_2_4_pass_4 <= (others => (others => '0'));
            soft_input_1_3_1_pass_4 <= (others => (others => '0'));
            soft_input_1_3_2_pass_4 <= (others => (others => '0'));
            soft_input_1_3_3_pass_4 <= (others => (others => '0'));
            soft_input_1_3_4_pass_4 <= (others => (others => '0'));
            soft_input_1_4_1_pass_4 <= (others => (others => '0'));
            soft_input_1_4_2_pass_4 <= (others => (others => '0'));
            soft_input_1_4_3_pass_4 <= (others => (others => '0'));
            soft_input_1_4_4_pass_4 <= (others => (others => '0'));
            soft_input_2_1_1_pass_4 <= (others => (others => '0'));
            soft_input_2_1_2_pass_4 <= (others => (others => '0'));
            soft_input_2_1_3_pass_4 <= (others => (others => '0'));
            soft_input_2_1_4_pass_4 <= (others => (others => '0'));
            soft_input_2_2_1_pass_4 <= (others => (others => '0'));
            soft_input_2_2_2_pass_4 <= (others => (others => '0'));
            soft_input_2_2_3_pass_4 <= (others => (others => '0'));
            soft_input_2_2_4_pass_4 <= (others => (others => '0'));
            soft_input_2_3_1_pass_4 <= (others => (others => '0'));
            soft_input_2_3_2_pass_4 <= (others => (others => '0'));
            soft_input_2_3_3_pass_4 <= (others => (others => '0'));
            soft_input_2_3_4_pass_4 <= (others => (others => '0'));
            soft_input_2_4_1_pass_4 <= (others => (others => '0'));
            soft_input_2_4_2_pass_4 <= (others => (others => '0'));
            soft_input_2_4_3_pass_4 <= (others => (others => '0'));
            soft_input_2_4_4_pass_4 <= (others => (others => '0'));
            soft_input_3_1_1_pass_4 <= (others => (others => '0'));
            soft_input_3_1_2_pass_4 <= (others => (others => '0'));
            soft_input_3_1_3_pass_4 <= (others => (others => '0'));
            soft_input_3_1_4_pass_4 <= (others => (others => '0'));
            soft_input_3_2_1_pass_4 <= (others => (others => '0'));
            soft_input_3_2_2_pass_4 <= (others => (others => '0'));
            soft_input_3_2_3_pass_4 <= (others => (others => '0'));
            soft_input_3_2_4_pass_4 <= (others => (others => '0'));
            soft_input_3_3_1_pass_4 <= (others => (others => '0'));
            soft_input_3_3_2_pass_4 <= (others => (others => '0'));
            soft_input_3_3_3_pass_4 <= (others => (others => '0'));
            soft_input_3_3_4_pass_4 <= (others => (others => '0'));
            soft_input_3_4_1_pass_4 <= (others => (others => '0'));
            soft_input_3_4_2_pass_4 <= (others => (others => '0'));
            soft_input_3_4_3_pass_4 <= (others => (others => '0'));
            soft_input_3_4_4_pass_4 <= (others => (others => '0'));
            soft_input_4_1_1_pass_4 <= (others => (others => '0'));
            soft_input_4_1_2_pass_4 <= (others => (others => '0'));
            soft_input_4_1_3_pass_4 <= (others => (others => '0'));
            soft_input_4_1_4_pass_4 <= (others => (others => '0'));
            soft_input_4_2_1_pass_4 <= (others => (others => '0'));
            soft_input_4_2_2_pass_4 <= (others => (others => '0'));
            soft_input_4_2_3_pass_4 <= (others => (others => '0'));
            soft_input_4_2_4_pass_4 <= (others => (others => '0'));
            soft_input_4_3_1_pass_4 <= (others => (others => '0'));
            soft_input_4_3_2_pass_4 <= (others => (others => '0'));
            soft_input_4_3_3_pass_4 <= (others => (others => '0'));
            soft_input_4_3_4_pass_4 <= (others => (others => '0'));
            soft_input_4_4_1_pass_4 <= (others => (others => '0'));
            soft_input_4_4_2_pass_4 <= (others => (others => '0'));
            soft_input_4_4_3_pass_4 <= (others => (others => '0'));
            soft_input_4_4_4_pass_4 <= (others => (others => '0'));
        elsif (rising_edge(clk)) then
            soft_input_1_1_1_pass_4 <= soft_input_1_1_1_pass_3;
            soft_input_1_1_2_pass_4 <= soft_input_1_1_2_pass_3;
            soft_input_1_1_3_pass_4 <= soft_input_1_1_3_pass_3;
            soft_input_1_1_4_pass_4 <= soft_input_1_1_4_pass_3;
            soft_input_1_2_1_pass_4 <= soft_input_1_2_1_pass_3;
            soft_input_1_2_2_pass_4 <= soft_input_1_2_2_pass_3;
            soft_input_1_2_3_pass_4 <= soft_input_1_2_3_pass_3;
            soft_input_1_2_4_pass_4 <= soft_input_1_2_4_pass_3;
            soft_input_1_3_1_pass_4 <= soft_input_1_3_1_pass_3;
            soft_input_1_3_2_pass_4 <= soft_input_1_3_2_pass_3;
            soft_input_1_3_3_pass_4 <= soft_input_1_3_3_pass_3;
            soft_input_1_3_4_pass_4 <= soft_input_1_3_4_pass_3;
            soft_input_1_4_1_pass_4 <= soft_input_1_4_1_pass_3;
            soft_input_1_4_2_pass_4 <= soft_input_1_4_2_pass_3;
            soft_input_1_4_3_pass_4 <= soft_input_1_4_3_pass_3;
            soft_input_1_4_4_pass_4 <= soft_input_1_4_4_pass_3;
            soft_input_2_1_1_pass_4 <= soft_input_2_1_1_pass_3;
            soft_input_2_1_2_pass_4 <= soft_input_2_1_2_pass_3;
            soft_input_2_1_3_pass_4 <= soft_input_2_1_3_pass_3;
            soft_input_2_1_4_pass_4 <= soft_input_2_1_4_pass_3;
            soft_input_2_2_1_pass_4 <= soft_input_2_2_1_pass_3;
            soft_input_2_2_2_pass_4 <= soft_input_2_2_2_pass_3;
            soft_input_2_2_3_pass_4 <= soft_input_2_2_3_pass_3;
            soft_input_2_2_4_pass_4 <= soft_input_2_2_4_pass_3;
            soft_input_2_3_1_pass_4 <= soft_input_2_3_1_pass_3;
            soft_input_2_3_2_pass_4 <= soft_input_2_3_2_pass_3;
            soft_input_2_3_3_pass_4 <= soft_input_2_3_3_pass_3;
            soft_input_2_3_4_pass_4 <= soft_input_2_3_4_pass_3;
            soft_input_2_4_1_pass_4 <= soft_input_2_4_1_pass_3;
            soft_input_2_4_2_pass_4 <= soft_input_2_4_2_pass_3;
            soft_input_2_4_3_pass_4 <= soft_input_2_4_3_pass_3;
            soft_input_2_4_4_pass_4 <= soft_input_2_4_4_pass_3;
            soft_input_3_1_1_pass_4 <= soft_input_3_1_1_pass_3;
            soft_input_3_1_2_pass_4 <= soft_input_3_1_2_pass_3;
            soft_input_3_1_3_pass_4 <= soft_input_3_1_3_pass_3;
            soft_input_3_1_4_pass_4 <= soft_input_3_1_4_pass_3;
            soft_input_3_2_1_pass_4 <= soft_input_3_2_1_pass_3;
            soft_input_3_2_2_pass_4 <= soft_input_3_2_2_pass_3;
            soft_input_3_2_3_pass_4 <= soft_input_3_2_3_pass_3;
            soft_input_3_2_4_pass_4 <= soft_input_3_2_4_pass_3;
            soft_input_3_3_1_pass_4 <= soft_input_3_3_1_pass_3;
            soft_input_3_3_2_pass_4 <= soft_input_3_3_2_pass_3;
            soft_input_3_3_3_pass_4 <= soft_input_3_3_3_pass_3;
            soft_input_3_3_4_pass_4 <= soft_input_3_3_4_pass_3;
            soft_input_3_4_1_pass_4 <= soft_input_3_4_1_pass_3;
            soft_input_3_4_2_pass_4 <= soft_input_3_4_2_pass_3;
            soft_input_3_4_3_pass_4 <= soft_input_3_4_3_pass_3;
            soft_input_3_4_4_pass_4 <= soft_input_3_4_4_pass_3;
            soft_input_4_1_1_pass_4 <= soft_input_4_1_1_pass_3;
            soft_input_4_1_2_pass_4 <= soft_input_4_1_2_pass_3;
            soft_input_4_1_3_pass_4 <= soft_input_4_1_3_pass_3;
            soft_input_4_1_4_pass_4 <= soft_input_4_1_4_pass_3;
            soft_input_4_2_1_pass_4 <= soft_input_4_2_1_pass_3;
            soft_input_4_2_2_pass_4 <= soft_input_4_2_2_pass_3;
            soft_input_4_2_3_pass_4 <= soft_input_4_2_3_pass_3;
            soft_input_4_2_4_pass_4 <= soft_input_4_2_4_pass_3;
            soft_input_4_3_1_pass_4 <= soft_input_4_3_1_pass_3;
            soft_input_4_3_2_pass_4 <= soft_input_4_3_2_pass_3;
            soft_input_4_3_3_pass_4 <= soft_input_4_3_3_pass_3;
            soft_input_4_3_4_pass_4 <= soft_input_4_3_4_pass_3;
            soft_input_4_4_1_pass_4 <= soft_input_4_4_1_pass_3;
            soft_input_4_4_2_pass_4 <= soft_input_4_4_2_pass_3;
            soft_input_4_4_3_pass_4 <= soft_input_4_4_3_pass_3;
            soft_input_4_4_4_pass_4 <= soft_input_4_4_4_pass_3;
            soft_input_unflipped_10 <= soft_input_unflipped_9;
            weight_info_2_p1        <= weight_info_2_r1 xor weight_info_2_r2 xor weight_info_2_r3 xor weight_info_2_r4;
            weight_info_2_p2        <= weight_info_2_r5 xor weight_info_2_r6 xor weight_info_2_r7 xor weight_info_2_r8;
            weight_info_2_p3        <= weight_info_2_r9 xor weight_info_2_r10 xor weight_info_2_r11 xor weight_info_2_r12;
            weight_info_2_p4        <= weight_info_2_r13 xor weight_info_2_r14 xor weight_info_2_r15 xor weight_info_2_r16;
            weight_info_1           <= weight_info_1_p1 xor weight_info_1_p2 xor weight_info_1_p3 xor weight_info_1_p4;
            soft_input_pass_7       <= soft_input_pass_6;
            hard_input_7            <= hard_input_6;
            weight_in_7             <= weight_in_6;
            corrections_in_7        <= corrections_in_6;
            error_position_7        <= error_position_6;
            weight_info_3_r1        <= (others => '0');
            weight_info_3_r2        <= (others => '0');
            weight_info_3_r3        <= (others => '0');
            weight_info_3_r4        <= (others => '0');
            weight_info_3_r5        <= (others => '0');
            weight_info_3_r6        <= (others => '0');
            weight_info_3_r7        <= (others => '0');
            weight_info_3_r8        <= (others => '0');
            weight_info_3_r9        <= (others => '0');
            weight_info_3_r10       <= (others => '0');
            weight_info_3_r11       <= (others => '0');
            weight_info_3_r12       <= (others => '0');
            weight_info_3_r13       <= (others => '0');
            weight_info_3_r14       <= (others => '0');
            weight_info_3_r15       <= (others => '0');
            weight_info_3_r16       <= (others => '0');
            if indi_3_1_1_pass_2 = "001" then
                weight_info_3_r1 <= soft_input_1_1_1_pass_3(digit_3_pass_1);
            elsif indi_3_1_1_pass_2 = "010" then
                weight_info_3_r1 <= soft_input_1_1_2_pass_3(digit_3_pass_1);
            elsif indi_3_1_1_pass_2 = "011" then
                weight_info_3_r1 <= soft_input_1_1_3_pass_3(digit_3_pass_1);
            elsif indi_3_1_1_pass_2 = "100" then
                weight_info_3_r1 <= soft_input_1_1_4_pass_3(digit_3_pass_1);
            end if;
            ------------------------------------------------------------------------------------------------------------------------------------
            if indi_3_1_2_pass_2 = "001" then
                weight_info_3_r2 <= soft_input_1_2_1_pass_3(digit_3_pass_1);
            elsif indi_3_1_2_pass_2 = "010" then
                weight_info_3_r2 <= soft_input_1_2_2_pass_3(digit_3_pass_1);
            elsif indi_3_1_2_pass_2 = "011" then
                weight_info_3_r2 <= soft_input_1_2_3_pass_3(digit_3_pass_1);
            elsif indi_3_1_2_pass_2 = "100" then
                weight_info_3_r2 <= soft_input_1_2_4_pass_3(digit_3_pass_1);
            end if;
            ------------------------------------------------------------------------------------------------------------------------------------
            if indi_3_1_3_pass_2 = "001" then
                weight_info_3_r3 <= soft_input_1_3_1_pass_3(digit_3_pass_1);
            elsif indi_3_1_3_pass_2 = "010" then
                weight_info_3_r3 <= soft_input_1_3_2_pass_3(digit_3_pass_1);
            elsif indi_3_1_3_pass_2 = "011" then
                weight_info_3_r3 <= soft_input_1_3_3_pass_3(digit_3_pass_1);
            elsif indi_3_1_3_pass_2 = "100" then
                weight_info_3_r3 <= soft_input_1_3_4_pass_3(digit_3_pass_1);
            end if;
            ------------------------------------------------------------------------------------------------------------------------------------
            if indi_3_1_4_pass_2 = "001" then
                weight_info_3_r4 <= soft_input_1_4_1_pass_3(digit_3_pass_1);
            elsif indi_3_1_4_pass_2 = "010" then
                weight_info_3_r4 <= soft_input_1_4_2_pass_3(digit_3_pass_1);
            elsif indi_3_1_4_pass_2 = "011" then
                weight_info_3_r4 <= soft_input_1_4_3_pass_3(digit_3_pass_1);
            elsif indi_3_1_4_pass_2 = "100" then
                weight_info_3_r4 <= soft_input_1_4_4_pass_3(digit_3_pass_1);
            end if;
            ------------------------------------------------------------------------------------------------------------------------------------
            if indi_3_2_1_pass_2 = "001" then
                weight_info_3_r5 <= soft_input_2_1_1_pass_3(digit_3_pass_1);
            elsif indi_3_2_1_pass_2 = "010" then
                weight_info_3_r5 <= soft_input_2_1_2_pass_3(digit_3_pass_1);
            elsif indi_3_2_1_pass_2 = "011" then
                weight_info_3_r5 <= soft_input_2_1_3_pass_3(digit_3_pass_1);
            elsif indi_3_2_1_pass_2 = "100" then
                weight_info_3_r5 <= soft_input_2_1_4_pass_3(digit_3_pass_1);
            end if;
            ------------------------------------------------------------------------------------------------------------------------------------
            if indi_3_2_2_pass_2 = "001" then
                weight_info_3_r6 <= soft_input_2_2_1_pass_3(digit_3_pass_1);
            elsif indi_3_2_2_pass_2 = "010" then
                weight_info_3_r6 <= soft_input_2_2_2_pass_3(digit_3_pass_1);
            elsif indi_3_2_2_pass_2 = "011" then
                weight_info_3_r6 <= soft_input_2_2_3_pass_3(digit_3_pass_1);
            elsif indi_3_2_2_pass_2 = "100" then
                weight_info_3_r6 <= soft_input_2_2_4_pass_3(digit_3_pass_1);
            end if;
            ------------------------------------------------------------------------------------------------------------------------------------
            if indi_3_2_3_pass_2 = "001" then
                weight_info_3_r7 <= soft_input_2_3_1_pass_3(digit_3_pass_1);
            elsif indi_3_2_3_pass_2 = "010" then
                weight_info_3_r7 <= soft_input_2_3_2_pass_3(digit_3_pass_1);
            elsif indi_3_2_3_pass_2 = "011" then
                weight_info_3_r7 <= soft_input_2_3_3_pass_3(digit_3_pass_1);
            elsif indi_3_2_3_pass_2 = "100" then
                weight_info_3_r7 <= soft_input_2_3_4_pass_3(digit_3_pass_1);
            end if;
            ------------------------------------------------------------------------------------------------------------------------------------
            if indi_3_2_4_pass_2 = "001" then
                weight_info_3_r8 <= soft_input_2_4_1_pass_3(digit_3_pass_1);
            elsif indi_3_2_4_pass_2 = "010" then
                weight_info_3_r8 <= soft_input_2_4_2_pass_3(digit_3_pass_1);
            elsif indi_3_2_4_pass_2 = "011" then
                weight_info_3_r8 <= soft_input_2_4_3_pass_3(digit_3_pass_1);
            elsif indi_3_2_4_pass_2 = "100" then
                weight_info_3_r8 <= soft_input_2_4_4_pass_3(digit_3_pass_1);
            end if;
            ------------------------------------------------------------------------------------------------------------------------------------
            if indi_3_3_1_pass_2 = "001" then
                weight_info_3_r9 <= soft_input_3_1_1_pass_3(digit_3_pass_1);
            elsif indi_3_3_1_pass_2 = "010" then
                weight_info_3_r9 <= soft_input_3_1_2_pass_3(digit_3_pass_1);
            elsif indi_3_3_1_pass_2 = "011" then
                weight_info_3_r9 <= soft_input_3_1_3_pass_3(digit_3_pass_1);
            elsif indi_3_3_1_pass_2 = "100" then
                weight_info_3_r9 <= soft_input_3_1_4_pass_3(digit_3_pass_1);
            end if;
            ------------------------------------------------------------------------------------------------------------------------------------
            if indi_3_3_2_pass_2 = "001" then
                weight_info_3_r10 <= soft_input_3_2_1_pass_3(digit_3_pass_1);
            elsif indi_3_3_2_pass_2 = "010" then
                weight_info_3_r10 <= soft_input_3_2_2_pass_3(digit_3_pass_1);
            elsif indi_3_3_2_pass_2 = "011" then
                weight_info_3_r10 <= soft_input_3_2_3_pass_3(digit_3_pass_1);
            elsif indi_3_3_2_pass_2 = "100" then
                weight_info_3_r10 <= soft_input_3_2_4_pass_3(digit_3_pass_1);
            end if;
            ------------------------------------------------------------------------------------------------------------------------------------
            if indi_3_3_3_pass_2 = "001" then
                weight_info_3_r11 <= soft_input_3_3_1_pass_3(digit_3_pass_1);
            elsif indi_3_3_3_pass_2 = "010" then
                weight_info_3_r11 <= soft_input_3_3_2_pass_3(digit_3_pass_1);
            elsif indi_3_3_3_pass_2 = "011" then
                weight_info_3_r11 <= soft_input_3_3_3_pass_3(digit_3_pass_1);
            elsif indi_3_3_3_pass_2 = "100" then
                weight_info_3_r11 <= soft_input_3_3_4_pass_3(digit_3_pass_1);
            end if;
            ------------------------------------------------------------------------------------------------------------------------------------
            if indi_3_3_4_pass_2 = "001" then
                weight_info_3_r12 <= soft_input_3_4_1_pass_3(digit_3_pass_1);
            elsif indi_3_3_4_pass_2 = "010" then
                weight_info_3_r12 <= soft_input_3_4_2_pass_3(digit_3_pass_1);
            elsif indi_3_3_4_pass_2 = "011" then
                weight_info_3_r12 <= soft_input_3_4_3_pass_3(digit_3_pass_1);
            elsif indi_3_3_4_pass_2 = "100" then
                weight_info_3_r12 <= soft_input_3_4_4_pass_3(digit_3_pass_1);
            end if;
            ------------------------------------------------------------------------------------------------------------------------------------
            if indi_3_4_1_pass_2 = "001" then
                weight_info_3_r13 <= soft_input_4_1_1_pass_3(digit_3_pass_1);
            elsif indi_3_4_1_pass_2 = "010" then
                weight_info_3_r13 <= soft_input_4_1_2_pass_3(digit_3_pass_1);
            elsif indi_3_4_1_pass_2 = "011" then
                weight_info_3_r13 <= soft_input_4_1_3_pass_3(digit_3_pass_1);
            elsif indi_3_4_1_pass_2 = "100" then
                weight_info_3_r13 <= soft_input_4_1_4_pass_3(digit_3_pass_1);
            end if;
            ------------------------------------------------------------------------------------------------------------------------------------
            if indi_3_4_2_pass_2 = "001" then
                weight_info_3_r14 <= soft_input_4_2_1_pass_3(digit_3_pass_1);
            elsif indi_3_4_2_pass_2 = "010" then
                weight_info_3_r14 <= soft_input_4_2_2_pass_3(digit_3_pass_1);
            elsif indi_3_4_2_pass_2 = "011" then
                weight_info_3_r14 <= soft_input_4_2_3_pass_3(digit_3_pass_1);
            elsif indi_3_4_2_pass_2 = "100" then
                weight_info_3_r14 <= soft_input_4_2_4_pass_3(digit_3_pass_1);
            end if;
            ------------------------------------------------------------------------------------------------------------------------------------
            if indi_3_4_3_pass_2 = "001" then
                weight_info_3_r15 <= soft_input_4_3_1_pass_3(digit_3_pass_1);
            elsif indi_3_4_3_pass_2 = "010" then
                weight_info_3_r15 <= soft_input_4_3_2_pass_3(digit_3_pass_1);
            elsif indi_3_4_3_pass_2 = "011" then
                weight_info_3_r15 <= soft_input_4_3_3_pass_3(digit_3_pass_1);
            elsif indi_3_4_3_pass_2 = "100" then
                weight_info_3_r15 <= soft_input_4_3_4_pass_3(digit_3_pass_1);
            end if;
            ------------------------------------------------------------------------------------------------------------------------------------
            if indi_3_4_4_pass_2 = "001" then
                weight_info_3_r16 <= soft_input_4_4_1_pass_3(digit_3_pass_1);
            elsif indi_3_4_4_pass_2 = "010" then
                weight_info_3_r16 <= soft_input_4_4_2_pass_3(digit_3_pass_1);
            elsif indi_3_4_4_pass_2 = "011" then
                weight_info_3_r16 <= soft_input_4_4_3_pass_3(digit_3_pass_1);
            elsif indi_3_4_4_pass_2 = "100" then
                weight_info_3_r16 <= soft_input_4_4_4_pass_3(digit_3_pass_1);
            end if;
        end if;
    end process;
    ------------------------------------------------------------------------------------------------------------
    -- Define processes : (CLK 10)
    ------------------------------------------------------------------------------------------------------------
    process (clk, reset)
    begin
        if (reset = '1') then
            soft_input_unflipped_11 <= (others => (others => '0'));
            soft_input_pass_100     <= (others => (others => '0'));
            hard_input_100          <= (others => '0');
            weight_in_100           <= (others => '0');
            corrections_in_100      <= (others => '0');
            error_position_100      <= (others => 0);
            weight_info_2           <= (others => '0');
            weight_info_1_pass      <= (others => '0');
            weight_info_3_p1        <= (others => '0');
            weight_info_3_p2        <= (others => '0');
            weight_info_3_p3        <= (others => '0');
            weight_info_3_p4        <= (others => '0');
        elsif (rising_edge(clk)) then
            soft_input_unflipped_11 <= soft_input_unflipped_10;
            soft_input_pass_100     <= soft_input_pass_7;
            hard_input_100          <= hard_input_7;
            weight_in_100           <= weight_in_7;
            corrections_in_100      <= corrections_in_7;
            error_position_100      <= error_position_7;
            weight_info_2           <= weight_info_2_p1 xor weight_info_2_p2 xor weight_info_2_p3 xor weight_info_2_p4;
            weight_info_3_p1        <= weight_info_3_r1 xor weight_info_3_r2 xor weight_info_3_r3 xor weight_info_3_r4;
            weight_info_3_p2        <= weight_info_3_r5 xor weight_info_3_r6 xor weight_info_3_r7 xor weight_info_3_r8;
            weight_info_3_p3        <= weight_info_3_r9 xor weight_info_3_r10 xor weight_info_3_r11 xor weight_info_3_r12;
            weight_info_3_p4        <= weight_info_3_r13 xor weight_info_3_r14 xor weight_info_3_r15 xor weight_info_3_r16;
            weight_info_1_pass      <= weight_info_1;
        end if;
    end process;
    ------------------------------------------------------------------------------------------------------------
    -- Define processes : (CLK 11)
    ------------------------------------------------------------------------------------------------------------
    process (clk, reset)
    begin
        if (reset = '1') then
            soft_input_unflipped_12 <= (others => (others => '0'));
            soft_input_pass_110     <= (others => (others => '0'));
            hard_input_110          <= (others => '0');
            weight_in_110           <= (others => '0');
            corrections_in_110      <= (others => '0');
            error_position_110      <= (others => 0);
            weight_info_2_pass      <= (others => '0');
            weight_info_1_pass_1    <= (others => '0');
            weight_info_3           <= (others => '0');
        elsif (rising_edge(clk)) then
            soft_input_unflipped_12 <= soft_input_unflipped_11;
            soft_input_pass_110     <= soft_input_pass_100;
            hard_input_110          <= hard_input_100;
            weight_in_110           <= weight_in_100;
            corrections_in_110      <= corrections_in_100;
            error_position_110      <= error_position_100;
            weight_info_2_pass      <= weight_info_2;
            weight_info_3           <= weight_info_3_p1 xor weight_info_3_p2 xor weight_info_3_p3 xor weight_info_3_p4;
            weight_info_1_pass_1    <= weight_info_1_pass;
        end if;
    end process;
    ------------------------------------------------------------------------------------------------------------
    -- Define processes : (CLK 10)
    ------------------------------------------------------------------------------------------------------------
    process (clk, reset)
    begin
        if (reset = '1') then
            soft_input_unflipped_13 <= (others => (others => '0'));
            soft_input_pass_8       <= (others => (others => '0'));
            hard_input_8            <= (others => '0');
            weight_in_8             <= (others => '0');
            corrections_in_8        <= (others => '0');
            error_position_8        <= (others => 0);
            weight_info_3abs        <= (others => '0');
            weight_info_1_pass_1abs <= (others => '0');
            weight_info_2_passabs   <= (others => '0');
        elsif (rising_edge(clk)) then
            soft_input_unflipped_13 <= soft_input_unflipped_12;
            soft_input_pass_8       <= soft_input_pass_110;
            hard_input_8            <= hard_input_110;
            weight_in_8             <= weight_in_110;
            corrections_in_8        <= corrections_in_110;
            error_position_8        <= error_position_110;
            weight_info_1_pass_1abs <= std_logic_vector(abs(signed(weight_info_1_pass_1)));
            weight_info_2_passabs   <= std_logic_vector(abs(signed(weight_info_2_pass)));
            weight_info_3abs        <= std_logic_vector(abs(signed(weight_info_3)));
        end if;
    end process;
    ------------------------------------------------------------------------------------------------------------
    -- Define processes : (CLK 11)
    ------------------------------------------------------------------------------------------------------------
    process (clk, reset)
    begin
        if (reset = '1') then
            soft_input_unflipped_14 <= (others => (others => '0'));
            soft_input_pass_9       <= (others => (others => '0'));
            hard_input_9            <= (others => '0');
            weight_in_9             <= (others => '0');
            corrections_in_9        <= (others => '0');
            error_position_9        <= (others => 0);
            weight_info_3abs_1      <= (others => '0');
            sum_1                   <= (others => '0');
        elsif (rising_edge(clk)) then
            soft_input_unflipped_14 <= soft_input_unflipped_13;
            soft_input_pass_9       <= soft_input_pass_8;
            hard_input_9            <= hard_input_8;
            weight_in_9             <= weight_in_8;
            corrections_in_9        <= corrections_in_8;
            error_position_9        <= error_position_8;
            sum_1                   <= (weight_info_1_pass_1abs(7) & weight_info_1_pass_1abs) + (weight_info_2_passabs(7) & weight_info_2_passabs);
            weight_info_3abs_1      <= weight_info_3abs;
        end if;
    end process;
    ------------------------------------------------------------------------------------------------------------
    -- Define processes : (CLK 12)
    ------------------------------------------------------------------------------------------------------------
    process (clk, reset)
    begin
        if (reset = '1') then
            soft_input_unflipped_15 <= (others => (others => '0'));
            soft_input_pass_10      <= (others => (others => '0'));
            hard_input_10           <= (others => '0');
            weight_in_10            <= (others => '0');
            corrections_in_10       <= (others => '0');
            error_position_10       <= (others => 0);
            sum_2                   <= (others => '0');
        elsif (rising_edge(clk)) then
            soft_input_unflipped_15 <= soft_input_unflipped_14;
            soft_input_pass_10      <= soft_input_pass_9;
            hard_input_10           <= hard_input_9;
            weight_in_10            <= weight_in_9;
            corrections_in_10       <= corrections_in_9;
            error_position_10       <= error_position_9;
            sum_2                   <= (weight_info_3abs_1(7) & weight_info_3abs_1(7) & weight_info_3abs_1) + sum_1;
        end if;
    end process;
    ------------------------------------------------------------------------------------------------------------
    -- Define processes : (CLK 13)
    ------------------------------------------------------------------------------------------------------------
    process (clk, reset)
    begin
        if (reset = '1') then
            soft_input_unflipped_16 <= (others => (others => '0'));
            soft_input_pass_11      <= (others => (others => '0'));
            hard_input_11           <= (others => '0');
            corrections_in_11       <= (others => '0');
            error_position_11       <= (others => 0);
            sum_3                   <= (others => '0');
        elsif (rising_edge(clk)) then
            soft_input_unflipped_16 <= soft_input_unflipped_15;
            soft_input_pass_11      <= soft_input_pass_10;
            hard_input_11           <= hard_input_10;
            corrections_in_11       <= corrections_in_10;
            error_position_11       <= error_position_10;
            sum_3                   <= (sum_2(9) & sum_2) + (weight_in_10(9) & weight_in_10);
        end if;
    end process;
    ------------------------------------------------------------------------------------------------------------
    -- Define processes : (CLK 14)
    ------------------------------------------------------------------------------------------------------------
    process (clk, reset)
    begin
        if (reset = '1') then
            soft_output_unflipped <= (others => (others => '0'));
            soft_output           <= (others => (others => '0'));
            hard_output           <= (others => '0');
            corrections_out       <= (others => '0');
            final_weight_value    <= (others => '0');
            error_position_out    <= (others => 0);
        elsif (rising_edge(clk)) then
            soft_output_unflipped <= soft_input_unflipped_16;
            soft_output           <= soft_input_pass_11;
            hard_output           <= hard_input_11;
            corrections_out       <= corrections_in_11;
            error_position_out    <= error_position_11;
            final_weight_value    <= sum_3;
        end if;
    end process;
end architecture;
