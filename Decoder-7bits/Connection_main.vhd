-- Sorting, connections and soft_out
library ieee;
use ieee.std_logic_1164.all;

package arr_pkg_1 is
    type output_error_location_array is array (natural range <>) of integer;
end;

library ieee;
use ieee.std_logic_1164.all;

package arr_pkg_2 is
    type input_data_array is array (natural range <>) of std_logic_vector(7 downto 0); -- 8 bits, should be soft input this time!
end;

library ieee;
use ieee.std_logic_1164.all;

package arr_pkg_3 is
    type index_array is array (natural range <>) of std_logic_vector(7 downto 0); -- 8 bits, index can go from 0 to 255, 8 bits should be enough
end;

library ieee;
use ieee.std_logic_1164.all;

package arr_pkg_4 is
    type indi_array is array (natural range <>) of std_logic_vector(1 downto 0);
end;

library ieee;
use ieee.std_logic_1164.all;

package arr_pkg_5 is
    type output_data_array is array (natural range <>) of std_logic_vector(10 downto 0);
end;

library ieee;
use ieee.std_logic_1164.all;

package arr_pkg_6 is
    type extrinsic_array is array (natural range <>) of std_logic_vector(11 downto 0);
end;

library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.std_logic_unsigned.all;
use ieee.math_real.all;
use work.arr_pkg_1.all;
use work.arr_pkg_2.all;
use work.arr_pkg_3.all;
use work.arr_pkg_4.all;
use work.arr_pkg_5.all;
use work.arr_pkg_6.all;
entity connection_main is
    generic (
        data_in_length  : positive := 255;
        data_length     : positive := 255;
        index_length    : positive := 2;
        data_out_length : positive := 7
    );
    port (
        clk        : in std_logic;                                 -- system clock
        reset      : in std_logic;                                 -- reset
        soft_input : in input_data_array(data_in_length downto 0); -- 256 * 6 bits
        ---------------------------------------------------------------------------------------------
        extrinsic_info_half1 : out input_data_array(127 downto 0);
        extrinsic_info_half2 : out input_data_array(255 downto 128)
    );
end connection_main;

architecture rtl of connection_main is
    -------------------------------------------------------------------------------------------------------------
    -- Signals for connection_main
    -------------------------------------------------------------------------------------------------------------
    signal index_temp_p0_1       : index_array(data_out_length downto 0);
    signal soft_output_temp_p0_1 : input_data_array(data_in_length downto 0);
    signal index_temp_p1_1       : index_array(data_out_length downto 0);
    signal soft_output_temp_p1_1 : input_data_array(data_in_length downto 0);
    signal index_temp_p2_1       : index_array(data_out_length downto 0);
    signal soft_output_temp_p2_1 : input_data_array(data_in_length downto 0);
    signal index_temp_p3_1       : index_array(data_out_length downto 0);
    signal soft_output_temp_p3_1 : input_data_array(data_in_length downto 0);
    signal index_temp_p4_1       : index_array(data_out_length downto 0);
    signal soft_output_temp_p4_1 : input_data_array(data_in_length downto 0);
    signal index_temp_p5_1       : index_array(data_out_length downto 0);
    signal soft_output_temp_p5_1 : input_data_array(data_in_length downto 0);
    signal index_temp_p6_1       : index_array(data_out_length downto 0);
    signal soft_output_temp_p6_1 : input_data_array(data_in_length downto 0);
    signal index_temp_p7_1       : index_array(data_out_length downto 0);
    signal soft_output_temp_p7_1 : input_data_array(data_in_length downto 0);
    signal index_temp_p0_2       : index_array(data_out_length downto 0);
    signal soft_output_temp_p0_2 : input_data_array(data_in_length downto 0);
    signal index_temp_p1_2       : index_array(data_out_length downto 0);
    signal soft_output_temp_p1_2 : input_data_array(data_in_length downto 0);
    signal index_temp_p2_2       : index_array(data_out_length downto 0);
    signal soft_output_temp_p2_2 : input_data_array(data_in_length downto 0);
    signal index_temp_p3_2       : index_array(data_out_length downto 0);
    signal soft_output_temp_p3_2 : input_data_array(data_in_length downto 0);
    signal index_temp_p4_2       : index_array(data_out_length downto 0);
    signal soft_output_temp_p4_2 : input_data_array(data_in_length downto 0);
    signal index_temp_p5_2       : index_array(data_out_length downto 0);
    signal soft_output_temp_p5_2 : input_data_array(data_in_length downto 0);
    signal index_temp_p6_2       : index_array(data_out_length downto 0);
    signal soft_output_temp_p6_2 : input_data_array(data_in_length downto 0);
    signal index_temp_p7_2       : index_array(data_out_length downto 0);
    signal soft_output_temp_p7_2 : input_data_array(data_in_length downto 0);
    signal index_temp_p0_3       : index_array(data_out_length downto 0);
    signal soft_output_temp_p0_3 : input_data_array(data_in_length downto 0);
    signal index_temp_p1_3       : index_array(data_out_length downto 0);
    signal soft_output_temp_p1_3 : input_data_array(data_in_length downto 0);
    signal index_temp_p2_3       : index_array(data_out_length downto 0);
    signal soft_output_temp_p2_3 : input_data_array(data_in_length downto 0);
    signal index_temp_p3_3       : index_array(data_out_length downto 0);
    signal soft_output_temp_p3_3 : input_data_array(data_in_length downto 0);
    signal index_temp_p4_3       : index_array(data_out_length downto 0);
    signal soft_output_temp_p4_3 : input_data_array(data_in_length downto 0);
    signal index_temp_p5_3       : index_array(data_out_length downto 0);
    signal soft_output_temp_p5_3 : input_data_array(data_in_length downto 0);
    signal index_temp_p6_3       : index_array(data_out_length downto 0);
    signal soft_output_temp_p6_3 : input_data_array(data_in_length downto 0);
    signal index_temp_p7_3       : index_array(data_out_length downto 0);
    signal soft_output_temp_p7_3 : input_data_array(data_in_length downto 0);

    signal soft_output_temp_1_1           : input_data_array(data_length downto 0);
    signal hard_output_temp_1_1           : std_logic_vector(data_length downto 0);
    signal corrections_out_temp_1_1       : std_logic_vector(index_length downto 0);
    signal error_position_out_temp_1_1    : output_error_location_array(index_length downto 0);
    signal soft_output_unflipped_temp_1_1 : input_data_array(data_length downto 0);
    signal final_weight_value_temp_1_1    : std_logic_vector(10 downto 0);
    signal soft_output_temp_2_1           : input_data_array(data_length downto 0);
    signal hard_output_temp_2_1           : std_logic_vector(data_length downto 0);
    signal corrections_out_temp_2_1       : std_logic_vector(index_length downto 0);
    signal error_position_out_temp_2_1    : output_error_location_array(index_length downto 0);
    signal soft_output_unflipped_temp_2_1 : input_data_array(data_length downto 0);
    signal final_weight_value_temp_2_1    : std_logic_vector(10 downto 0);
    signal soft_output_temp_3_1           : input_data_array(data_length downto 0);
    signal hard_output_temp_3_1           : std_logic_vector(data_length downto 0);
    signal corrections_out_temp_3_1       : std_logic_vector(index_length downto 0);
    signal error_position_out_temp_3_1    : output_error_location_array(index_length downto 0);
    signal soft_output_unflipped_temp_3_1 : input_data_array(data_length downto 0);
    signal final_weight_value_temp_3_1    : std_logic_vector(10 downto 0);
    signal soft_output_temp_4_1           : input_data_array(data_length downto 0);
    signal hard_output_temp_4_1           : std_logic_vector(data_length downto 0);
    signal corrections_out_temp_4_1       : std_logic_vector(index_length downto 0);
    signal error_position_out_temp_4_1    : output_error_location_array(index_length downto 0);
    signal soft_output_unflipped_temp_4_1 : input_data_array(data_length downto 0);
    signal final_weight_value_temp_4_1    : std_logic_vector(10 downto 0);
    signal soft_output_temp_5_1           : input_data_array(data_length downto 0);
    signal hard_output_temp_5_1           : std_logic_vector(data_length downto 0);
    signal corrections_out_temp_5_1       : std_logic_vector(index_length downto 0);
    signal error_position_out_temp_5_1    : output_error_location_array(index_length downto 0);
    signal soft_output_unflipped_temp_5_1 : input_data_array(data_length downto 0);
    signal final_weight_value_temp_5_1    : std_logic_vector(10 downto 0);
    signal soft_output_temp_6_1           : input_data_array(data_length downto 0);
    signal hard_output_temp_6_1           : std_logic_vector(data_length downto 0);
    signal corrections_out_temp_6_1       : std_logic_vector(index_length downto 0);
    signal error_position_out_temp_6_1    : output_error_location_array(index_length downto 0);
    signal soft_output_unflipped_temp_6_1 : input_data_array(data_length downto 0);
    signal final_weight_value_temp_6_1    : std_logic_vector(10 downto 0);
    signal soft_output_temp_7_1           : input_data_array(data_length downto 0);
    signal hard_output_temp_7_1           : std_logic_vector(data_length downto 0);
    signal corrections_out_temp_7_1       : std_logic_vector(index_length downto 0);
    signal error_position_out_temp_7_1    : output_error_location_array(index_length downto 0);
    signal soft_output_unflipped_temp_7_1 : input_data_array(data_length downto 0);
    signal final_weight_value_temp_7_1    : std_logic_vector(10 downto 0);
    signal soft_output_temp_8_1           : input_data_array(data_length downto 0);
    signal hard_output_temp_8_1           : std_logic_vector(data_length downto 0);
    signal corrections_out_temp_8_1       : std_logic_vector(index_length downto 0);
    signal error_position_out_temp_8_1    : output_error_location_array(index_length downto 0);
    signal soft_output_unflipped_temp_8_1 : input_data_array(data_length downto 0);
    signal final_weight_value_temp_8_1    : std_logic_vector(10 downto 0);
    signal soft_output_temp_1_2           : input_data_array(data_length downto 0);
    signal hard_output_temp_1_2           : std_logic_vector(data_length downto 0);
    signal corrections_out_temp_1_2       : std_logic_vector(index_length downto 0);
    signal error_position_out_temp_1_2    : output_error_location_array(index_length downto 0);
    signal soft_output_unflipped_temp_1_2 : input_data_array(data_length downto 0);
    signal final_weight_value_temp_1_2    : std_logic_vector(10 downto 0);
    signal soft_output_temp_2_2           : input_data_array(data_length downto 0);
    signal hard_output_temp_2_2           : std_logic_vector(data_length downto 0);
    signal corrections_out_temp_2_2       : std_logic_vector(index_length downto 0);
    signal error_position_out_temp_2_2    : output_error_location_array(index_length downto 0);
    signal soft_output_unflipped_temp_2_2 : input_data_array(data_length downto 0);
    signal final_weight_value_temp_2_2    : std_logic_vector(10 downto 0);
    signal soft_output_temp_3_2           : input_data_array(data_length downto 0);
    signal hard_output_temp_3_2           : std_logic_vector(data_length downto 0);
    signal corrections_out_temp_3_2       : std_logic_vector(index_length downto 0);
    signal error_position_out_temp_3_2    : output_error_location_array(index_length downto 0);
    signal soft_output_unflipped_temp_3_2 : input_data_array(data_length downto 0);
    signal final_weight_value_temp_3_2    : std_logic_vector(10 downto 0);
    signal soft_output_temp_4_2           : input_data_array(data_length downto 0);
    signal hard_output_temp_4_2           : std_logic_vector(data_length downto 0);
    signal corrections_out_temp_4_2       : std_logic_vector(index_length downto 0);
    signal error_position_out_temp_4_2    : output_error_location_array(index_length downto 0);
    signal soft_output_unflipped_temp_4_2 : input_data_array(data_length downto 0);
    signal final_weight_value_temp_4_2    : std_logic_vector(10 downto 0);
    signal soft_output_temp_5_2           : input_data_array(data_length downto 0);
    signal hard_output_temp_5_2           : std_logic_vector(data_length downto 0);
    signal corrections_out_temp_5_2       : std_logic_vector(index_length downto 0);
    signal error_position_out_temp_5_2    : output_error_location_array(index_length downto 0);
    signal soft_output_unflipped_temp_5_2 : input_data_array(data_length downto 0);
    signal final_weight_value_temp_5_2    : std_logic_vector(10 downto 0);
    signal soft_output_temp_6_2           : input_data_array(data_length downto 0);
    signal hard_output_temp_6_2           : std_logic_vector(data_length downto 0);
    signal corrections_out_temp_6_2       : std_logic_vector(index_length downto 0);
    signal error_position_out_temp_6_2    : output_error_location_array(index_length downto 0);
    signal soft_output_unflipped_temp_6_2 : input_data_array(data_length downto 0);
    signal final_weight_value_temp_6_2    : std_logic_vector(10 downto 0);
    signal soft_output_temp_7_2           : input_data_array(data_length downto 0);
    signal hard_output_temp_7_2           : std_logic_vector(data_length downto 0);
    signal corrections_out_temp_7_2       : std_logic_vector(index_length downto 0);
    signal error_position_out_temp_7_2    : output_error_location_array(index_length downto 0);
    signal soft_output_unflipped_temp_7_2 : input_data_array(data_length downto 0);
    signal final_weight_value_temp_7_2    : std_logic_vector(10 downto 0);
    signal soft_output_temp_8_2           : input_data_array(data_length downto 0);
    signal hard_output_temp_8_2           : std_logic_vector(data_length downto 0);
    signal corrections_out_temp_8_2       : std_logic_vector(index_length downto 0);
    signal error_position_out_temp_8_2    : output_error_location_array(index_length downto 0);
    signal soft_output_unflipped_temp_8_2 : input_data_array(data_length downto 0);
    signal final_weight_value_temp_8_2    : std_logic_vector(10 downto 0);
    ------------------------------------------------Sorting Block------------------------------------------------
    signal index_temp_p0       : index_array(data_out_length downto 0);
    signal soft_output_temp_p0 : input_data_array(data_in_length downto 0);
    signal index_temp_p1       : index_array(data_out_length downto 0);
    signal soft_output_temp_p1 : input_data_array(data_in_length downto 0);
    signal index_temp_p2       : index_array(data_out_length downto 0);
    signal soft_output_temp_p2 : input_data_array(data_in_length downto 0);
    signal index_temp_p3       : index_array(data_out_length downto 0);
    signal soft_output_temp_p3 : input_data_array(data_in_length downto 0);
    signal index_temp_p4       : index_array(data_out_length downto 0);
    signal soft_output_temp_p4 : input_data_array(data_in_length downto 0);
    signal index_temp_p5       : index_array(data_out_length downto 0);
    signal soft_output_temp_p5 : input_data_array(data_in_length downto 0);
    signal index_temp_p6       : index_array(data_out_length downto 0);
    signal soft_output_temp_p6 : input_data_array(data_in_length downto 0);
    signal index_temp_p7       : index_array(data_out_length downto 0);
    signal soft_output_temp_p7 : input_data_array(data_in_length downto 0);
    -----------------------------------------------Connection Block----------------------------------------------
    signal soft_output_temp_1           : input_data_array(data_length downto 0);
    signal hard_output_temp_1           : std_logic_vector(data_length downto 0);
    signal corrections_out_temp_1       : std_logic_vector(index_length downto 0);
    signal error_position_out_temp_1    : output_error_location_array(index_length downto 0);
    signal soft_output_unflipped_temp_1 : input_data_array(data_length downto 0);
    signal final_weight_value_temp_1    : std_logic_vector(10 downto 0);
    ---------------------------------------------Connection_1 Block----------------------------------------------
    signal soft_output_temp_2           : input_data_array(data_length downto 0);
    signal hard_output_temp_2           : std_logic_vector(data_length downto 0);
    signal corrections_out_temp_2       : std_logic_vector(index_length downto 0);
    signal error_position_out_temp_2    : output_error_location_array(index_length downto 0);
    signal soft_output_unflipped_temp_2 : input_data_array(data_length downto 0);
    signal final_weight_value_temp_2    : std_logic_vector(10 downto 0);
    ---------------------------------------------Connection_2 Block----------------------------------------------
    signal soft_output_temp_3           : input_data_array(data_length downto 0);
    signal hard_output_temp_3           : std_logic_vector(data_length downto 0);
    signal corrections_out_temp_3       : std_logic_vector(index_length downto 0);
    signal error_position_out_temp_3    : output_error_location_array(index_length downto 0);
    signal soft_output_unflipped_temp_3 : input_data_array(data_length downto 0);
    signal final_weight_value_temp_3    : std_logic_vector(10 downto 0);
    ---------------------------------------------Connection_3 Block----------------------------------------------
    signal soft_output_temp_4           : input_data_array(data_length downto 0);
    signal hard_output_temp_4           : std_logic_vector(data_length downto 0);
    signal corrections_out_temp_4       : std_logic_vector(index_length downto 0);
    signal error_position_out_temp_4    : output_error_location_array(index_length downto 0);
    signal soft_output_unflipped_temp_4 : input_data_array(data_length downto 0);
    signal final_weight_value_temp_4    : std_logic_vector(10 downto 0);
    ---------------------------------------------Connection_4 Block----------------------------------------------
    signal soft_output_temp_5           : input_data_array(data_length downto 0);
    signal hard_output_temp_5           : std_logic_vector(data_length downto 0);
    signal corrections_out_temp_5       : std_logic_vector(index_length downto 0);
    signal error_position_out_temp_5    : output_error_location_array(index_length downto 0);
    signal soft_output_unflipped_temp_5 : input_data_array(data_length downto 0);
    signal final_weight_value_temp_5    : std_logic_vector(10 downto 0);
    ---------------------------------------------Connection_5 Block----------------------------------------------
    signal soft_output_temp_6           : input_data_array(data_length downto 0);
    signal hard_output_temp_6           : std_logic_vector(data_length downto 0);
    signal corrections_out_temp_6       : std_logic_vector(index_length downto 0);
    signal error_position_out_temp_6    : output_error_location_array(index_length downto 0);
    signal soft_output_unflipped_temp_6 : input_data_array(data_length downto 0);
    signal final_weight_value_temp_6    : std_logic_vector(10 downto 0);
    ---------------------------------------------Connection_6 Block----------------------------------------------
    signal soft_output_temp_7           : input_data_array(data_length downto 0);
    signal hard_output_temp_7           : std_logic_vector(data_length downto 0);
    signal corrections_out_temp_7       : std_logic_vector(index_length downto 0);
    signal error_position_out_temp_7    : output_error_location_array(index_length downto 0);
    signal soft_output_unflipped_temp_7 : input_data_array(data_length downto 0);
    signal final_weight_value_temp_7    : std_logic_vector(10 downto 0);
    ---------------------------------------------Connection_7 Block----------------------------------------------
    signal soft_output_temp_8           : input_data_array(data_length downto 0);
    signal hard_output_temp_8           : std_logic_vector(data_length downto 0);
    signal corrections_out_temp_8       : std_logic_vector(index_length downto 0);
    signal error_position_out_temp_8    : output_error_location_array(index_length downto 0);
    signal soft_output_unflipped_temp_8 : input_data_array(data_length downto 0);
    signal final_weight_value_temp_8    : std_logic_vector(10 downto 0);
    ---------------------------------------------soft_out Block----------------------------------------------
    signal soft_output_f_temp           : output_data_array(data_length downto 0);
    signal soft_output_unflipped_f_temp : input_data_array(data_length downto 0);
    -------------------------------------------------------------------------------------------------------------
    -- Declare Components
    -------------------------------------------------------------------------------------------------------------
    component sorting is
        generic (
            data_in_length  : positive := 255;
            data_out_length : positive := 7
        );
        port (
            clk           : in std_logic;
            reset         : in std_logic;
            soft_input    : in input_data_array(data_in_length downto 0);
            index_0       : out index_array(data_out_length downto 0);
            soft_output_0 : out input_data_array(data_in_length downto 0);
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
    end component;

    component connection is
        generic (
            data_length  : positive := 255;
            index_length : positive := 2
        );
        port (
            clk        : in std_logic;
            reset      : in std_logic;
            soft_input : in input_data_array(data_length downto 0);
            index      : in index_array(7 downto 0);
            ---------------------------------------------------------------------------------------------
            soft_output           : out input_data_array(data_length downto 0);
            hard_output           : out std_logic_vector(data_length downto 0);
            corrections_out       : out std_logic_vector(index_length downto 0);
            error_position_out    : out output_error_location_array(index_length downto 0);
            soft_output_unflipped : out input_data_array(data_length downto 0);
            final_weight_value    : out std_logic_vector(10 downto 0)
        );
    end component;

    component connection_1 is
        generic (
            data_length  : positive := 255;
            index_length : positive := 2
        );
        port (
            clk        : in std_logic;
            reset      : in std_logic;
            soft_input : in input_data_array(data_length downto 0);
            index      : in index_array(7 downto 0);
            ---------------------------------------------------------------------------------------------
            soft_output           : out input_data_array(data_length downto 0);
            hard_output           : out std_logic_vector(data_length downto 0);
            corrections_out       : out std_logic_vector(index_length downto 0);
            error_position_out    : out output_error_location_array(index_length downto 0);
            soft_output_unflipped : out input_data_array(data_length downto 0);
            final_weight_value    : out std_logic_vector(10 downto 0)
        );
    end component;

    component connection_2 is
        generic (
            data_length  : positive := 255;
            index_length : positive := 2
        );
        port (
            clk        : in std_logic;
            reset      : in std_logic;
            soft_input : in input_data_array(data_length downto 0);
            index      : in index_array(7 downto 0);
            ---------------------------------------------------------------------------------------------
            soft_output           : out input_data_array(data_length downto 0);
            hard_output           : out std_logic_vector(data_length downto 0);
            corrections_out       : out std_logic_vector(index_length downto 0);
            error_position_out    : out output_error_location_array(index_length downto 0);
            soft_output_unflipped : out input_data_array(data_length downto 0);
            final_weight_value    : out std_logic_vector(10 downto 0)
        );
    end component;

    component connection_3 is
        generic (
            data_length  : positive := 255;
            index_length : positive := 2
        );
        port (
            clk        : in std_logic;
            reset      : in std_logic;
            soft_input : in input_data_array(data_length downto 0);
            index      : in index_array(7 downto 0);
            ---------------------------------------------------------------------------------------------
            soft_output           : out input_data_array(data_length downto 0);
            hard_output           : out std_logic_vector(data_length downto 0);
            corrections_out       : out std_logic_vector(index_length downto 0);
            error_position_out    : out output_error_location_array(index_length downto 0);
            soft_output_unflipped : out input_data_array(data_length downto 0);
            final_weight_value    : out std_logic_vector(10 downto 0)
        );
    end component;

    component connection_4 is
        generic (
            data_length  : positive := 255;
            index_length : positive := 2
        );
        port (
            clk        : in std_logic;
            reset      : in std_logic;
            soft_input : in input_data_array(data_length downto 0);
            index      : in index_array(7 downto 0);
            ---------------------------------------------------------------------------------------------
            soft_output           : out input_data_array(data_length downto 0);
            hard_output           : out std_logic_vector(data_length downto 0);
            corrections_out       : out std_logic_vector(index_length downto 0);
            error_position_out    : out output_error_location_array(index_length downto 0);
            soft_output_unflipped : out input_data_array(data_length downto 0);
            final_weight_value    : out std_logic_vector(10 downto 0)
        );
    end component;

    component connection_5 is
        generic (
            data_length  : positive := 255;
            index_length : positive := 2
        );
        port (
            clk        : in std_logic;
            reset      : in std_logic;
            soft_input : in input_data_array(data_length downto 0);
            index      : in index_array(7 downto 0);
            ---------------------------------------------------------------------------------------------
            soft_output           : out input_data_array(data_length downto 0);
            hard_output           : out std_logic_vector(data_length downto 0);
            corrections_out       : out std_logic_vector(index_length downto 0);
            error_position_out    : out output_error_location_array(index_length downto 0);
            soft_output_unflipped : out input_data_array(data_length downto 0);
            final_weight_value    : out std_logic_vector(10 downto 0)
        );
    end component;

    component connection_6 is
        generic (
            data_length  : positive := 255;
            index_length : positive := 2
        );
        port (
            clk        : in std_logic;
            reset      : in std_logic;
            soft_input : in input_data_array(data_length downto 0);
            index      : in index_array(7 downto 0);
            ---------------------------------------------------------------------------------------------
            soft_output           : out input_data_array(data_length downto 0);
            hard_output           : out std_logic_vector(data_length downto 0);
            corrections_out       : out std_logic_vector(index_length downto 0);
            error_position_out    : out output_error_location_array(index_length downto 0);
            soft_output_unflipped : out input_data_array(data_length downto 0);
            final_weight_value    : out std_logic_vector(10 downto 0)
        );
    end component;

    component connection_7 is
        generic (
            data_length  : positive := 255;
            index_length : positive := 2
        );
        port (
            clk        : in std_logic;
            reset      : in std_logic;
            soft_input : in input_data_array(data_length downto 0);
            index      : in index_array(7 downto 0);
            ---------------------------------------------------------------------------------------------
            soft_output           : out input_data_array(data_length downto 0);
            hard_output           : out std_logic_vector(data_length downto 0);
            corrections_out       : out std_logic_vector(index_length downto 0);
            error_position_out    : out output_error_location_array(index_length downto 0);
            soft_output_unflipped : out input_data_array(data_length downto 0);
            final_weight_value    : out std_logic_vector(10 downto 0)
        );
    end component;

    component soft_out is
        generic (
            data_in_length : positive := 255;
            index_length   : positive := 2
        );
        port (
            clk   : in std_logic;
            reset : in std_logic;
    
            --const_llr_1         : in std_logic_vector(7 downto 0);
            --const_llr_2         : in std_logic_vector(7 downto 0);
            soft_input_original   : in input_data_array(data_in_length downto 0);
            hard_input_1          : in std_logic_vector(data_in_length downto 0);
            weight_1              : in std_logic_vector(10 downto 0);
            corrections_in_1      : in std_logic_vector(index_length downto 0);
            hard_input_2          : in std_logic_vector(data_in_length downto 0);
            weight_2              : in std_logic_vector(10 downto 0);
            corrections_in_2      : in std_logic_vector(index_length downto 0);
            hard_input_3          : in std_logic_vector(data_in_length downto 0);
            weight_3              : in std_logic_vector(10 downto 0);
            corrections_in_3      : in std_logic_vector(index_length downto 0);
            hard_input_4          : in std_logic_vector(data_in_length downto 0);
            weight_4              : in std_logic_vector(10 downto 0);
            corrections_in_4      : in std_logic_vector(index_length downto 0);
            hard_input_5          : in std_logic_vector(data_in_length downto 0);
            weight_5              : in std_logic_vector(10 downto 0);
            corrections_in_5      : in std_logic_vector(index_length downto 0);
            hard_input_6          : in std_logic_vector(data_in_length downto 0);
            weight_6              : in std_logic_vector(10 downto 0);
            corrections_in_6      : in std_logic_vector(index_length downto 0);
            hard_input_7          : in std_logic_vector(data_in_length downto 0);
            weight_7              : in std_logic_vector(10 downto 0);
            corrections_in_7      : in std_logic_vector(index_length downto 0);
            hard_input_8          : in std_logic_vector(data_in_length downto 0);
            weight_8              : in std_logic_vector(10 downto 0);
            corrections_in_8      : in std_logic_vector(index_length downto 0);
            soft_output           : out output_data_array(data_in_length downto 0);
            soft_output_unflipped : out input_data_array(data_in_length downto 0)
        );
    end component;

    component extrinsic is
        generic (
            data_length : positive := 255
        );
        port (
            clk                  : in std_logic;
            reset                : in std_logic;
            soft_input           : in output_data_array(data_length downto 0); -- From Soft_out block, the corrected data
            soft_input_original  : in input_data_array(data_length downto 0);  -- From Soft_out block, raw input data
    
            extrinsic_info_half1 : out input_data_array(127 downto 0);         -- send to RAM block after combining with address
            extrinsic_info_half2 : out input_data_array(255 downto 128)
        );
    end component;

begin
    -- sorting
    sorting_block : sorting
    port map(clk, reset, soft_input, index_temp_p0, soft_output_temp_p0, index_temp_p1, soft_output_temp_p1, index_temp_p2, soft_output_temp_p2, index_temp_p3, soft_output_temp_p3, index_temp_p4, soft_output_temp_p4, index_temp_p5, soft_output_temp_p5, index_temp_p6, soft_output_temp_p6, index_temp_p7, soft_output_temp_p7);

    -- connection
    connection_block : connection
    port map(clk, reset, soft_output_temp_p0_3, index_temp_p0_3, soft_output_temp_1, hard_output_temp_1, corrections_out_temp_1, error_position_out_temp_1, soft_output_unflipped_temp_1, final_weight_value_temp_1);

    -- connection_1
    connection_1_block : connection_1
    port map(clk, reset, soft_output_temp_p1_3, index_temp_p1_3, soft_output_temp_2, hard_output_temp_2, corrections_out_temp_2, error_position_out_temp_2, soft_output_unflipped_temp_2, final_weight_value_temp_2);

    -- connection_2
    connection_2_block : connection_2
    port map(clk, reset, soft_output_temp_p2_3, index_temp_p2_3, soft_output_temp_3, hard_output_temp_3, corrections_out_temp_3, error_position_out_temp_3, soft_output_unflipped_temp_3, final_weight_value_temp_3);

    -- connection_3
    connection_3_block : connection_3
    port map(clk, reset, soft_output_temp_p3_3, index_temp_p3_3, soft_output_temp_4, hard_output_temp_4, corrections_out_temp_4, error_position_out_temp_4, soft_output_unflipped_temp_4, final_weight_value_temp_4);

    -- connection_4
    connection_4_block : connection_4
    port map(clk, reset, soft_output_temp_p4_3, index_temp_p4_3, soft_output_temp_5, hard_output_temp_5, corrections_out_temp_5, error_position_out_temp_5, soft_output_unflipped_temp_5, final_weight_value_temp_5);

    -- connection_5
    connection_5_block : connection_5
    port map(clk, reset, soft_output_temp_p5_3, index_temp_p5_3, soft_output_temp_6, hard_output_temp_6, corrections_out_temp_6, error_position_out_temp_6, soft_output_unflipped_temp_6, final_weight_value_temp_6);

    -- connection_6
    connection_6_block : connection_6
    port map(clk, reset, soft_output_temp_p6_3, index_temp_p6_3, soft_output_temp_7, hard_output_temp_7, corrections_out_temp_7, error_position_out_temp_7, soft_output_unflipped_temp_7, final_weight_value_temp_7);

    -- connection_7
    connection_7_block : connection_7
    port map(clk, reset, soft_output_temp_p7_3, index_temp_p7_3, soft_output_temp_8, hard_output_temp_8, corrections_out_temp_8, error_position_out_temp_8, soft_output_unflipped_temp_8, final_weight_value_temp_8);

    -- soft_out
    soft_out_block : soft_out
    port map(clk, reset, soft_output_unflipped_temp_1_2, hard_output_temp_1_2, final_weight_value_temp_1_2, corrections_out_temp_1_2, hard_output_temp_2_2, final_weight_value_temp_2_2, corrections_out_temp_2_2, hard_output_temp_3_2, final_weight_value_temp_3_2, corrections_out_temp_3_2, hard_output_temp_4_2, final_weight_value_temp_4_2, corrections_out_temp_4_2, hard_output_temp_5_2, final_weight_value_temp_5_2, corrections_out_temp_5_2, hard_output_temp_6_2, final_weight_value_temp_6_2, corrections_out_temp_6_2, hard_output_temp_7_2, final_weight_value_temp_7_2, corrections_out_temp_7_2, hard_output_temp_8_2, final_weight_value_temp_8_2, corrections_out_temp_8_2, soft_output_f_temp, soft_output_unflipped_f_temp);

    -- extrinsic
    extrinsic_block : extrinsic
    port map(clk, reset, soft_output_f_temp, soft_output_unflipped_f_temp, extrinsic_info_half1, extrinsic_info_half2);

    -- data pass between sorting and connection
    process (clk, reset)
    begin
        if (reset = '1') then
            index_temp_p0_1       <= (others => (others => '0'));
            soft_output_temp_p0_1 <= (others => (others => '0'));
            index_temp_p1_1       <= (others => (others => '0'));
            soft_output_temp_p1_1 <= (others => (others => '0'));
            index_temp_p2_1       <= (others => (others => '0'));
            soft_output_temp_p2_1 <= (others => (others => '0'));
            index_temp_p3_1       <= (others => (others => '0'));
            soft_output_temp_p3_1 <= (others => (others => '0'));
            index_temp_p4_1       <= (others => (others => '0'));
            soft_output_temp_p4_1 <= (others => (others => '0'));
            index_temp_p5_1       <= (others => (others => '0'));
            soft_output_temp_p5_1 <= (others => (others => '0'));
            index_temp_p6_1       <= (others => (others => '0'));
            soft_output_temp_p6_1 <= (others => (others => '0'));
            index_temp_p7_1       <= (others => (others => '0'));
            soft_output_temp_p7_1 <= (others => (others => '0'));
        elsif (rising_edge(clk)) then
            index_temp_p0_1       <= index_temp_p0;
            soft_output_temp_p0_1 <= soft_output_temp_p0;
            index_temp_p1_1       <= index_temp_p1;
            soft_output_temp_p1_1 <= soft_output_temp_p1;
            index_temp_p2_1       <= index_temp_p2;
            soft_output_temp_p2_1 <= soft_output_temp_p2;
            index_temp_p3_1       <= index_temp_p3;
            soft_output_temp_p3_1 <= soft_output_temp_p3;
            index_temp_p4_1       <= index_temp_p4;
            soft_output_temp_p4_1 <= soft_output_temp_p4;
            index_temp_p5_1       <= index_temp_p5;
            soft_output_temp_p5_1 <= soft_output_temp_p5;
            index_temp_p6_1       <= index_temp_p6;
            soft_output_temp_p6_1 <= soft_output_temp_p6;
            index_temp_p7_1       <= index_temp_p7;
            soft_output_temp_p7_1 <= soft_output_temp_p7;
        end if;
    end process;

    process (clk, reset)
    begin
        if (reset = '1') then
            index_temp_p0_2       <= (others => (others => '0'));
            soft_output_temp_p0_2 <= (others => (others => '0'));
            index_temp_p1_2       <= (others => (others => '0'));
            soft_output_temp_p1_2 <= (others => (others => '0'));
            index_temp_p2_2       <= (others => (others => '0'));
            soft_output_temp_p2_2 <= (others => (others => '0'));
            index_temp_p3_2       <= (others => (others => '0'));
            soft_output_temp_p3_2 <= (others => (others => '0'));
            index_temp_p4_2       <= (others => (others => '0'));
            soft_output_temp_p4_2 <= (others => (others => '0'));
            index_temp_p5_2       <= (others => (others => '0'));
            soft_output_temp_p5_2 <= (others => (others => '0'));
            index_temp_p6_2       <= (others => (others => '0'));
            soft_output_temp_p6_2 <= (others => (others => '0'));
            index_temp_p7_2       <= (others => (others => '0'));
            soft_output_temp_p7_2 <= (others => (others => '0'));
        elsif (rising_edge(clk)) then
            index_temp_p0_2       <= index_temp_p0_1;
            soft_output_temp_p0_2 <= soft_output_temp_p0_1;
            index_temp_p1_2       <= index_temp_p1_1;
            soft_output_temp_p1_2 <= soft_output_temp_p1_1;
            index_temp_p2_2       <= index_temp_p2_1;
            soft_output_temp_p2_2 <= soft_output_temp_p2_1;
            index_temp_p3_2       <= index_temp_p3_1;
            soft_output_temp_p3_2 <= soft_output_temp_p3_1;
            index_temp_p4_2       <= index_temp_p4_1;
            soft_output_temp_p4_2 <= soft_output_temp_p4_1;
            index_temp_p5_2       <= index_temp_p5_1;
            soft_output_temp_p5_2 <= soft_output_temp_p5_1;
            index_temp_p6_2       <= index_temp_p6_1;
            soft_output_temp_p6_2 <= soft_output_temp_p6_1;
            index_temp_p7_2       <= index_temp_p7_1;
            soft_output_temp_p7_2 <= soft_output_temp_p7_1;
        end if;
    end process;

    process (clk, reset)
    begin
        if (reset = '1') then
            index_temp_p0_3       <= (others => (others => '0'));
            soft_output_temp_p0_3 <= (others => (others => '0'));
            index_temp_p1_3       <= (others => (others => '0'));
            soft_output_temp_p1_3 <= (others => (others => '0'));
            index_temp_p2_3       <= (others => (others => '0'));
            soft_output_temp_p2_3 <= (others => (others => '0'));
            index_temp_p3_3       <= (others => (others => '0'));
            soft_output_temp_p3_3 <= (others => (others => '0'));
            index_temp_p4_3       <= (others => (others => '0'));
            soft_output_temp_p4_3 <= (others => (others => '0'));
            index_temp_p5_3       <= (others => (others => '0'));
            soft_output_temp_p5_3 <= (others => (others => '0'));
            index_temp_p6_3       <= (others => (others => '0'));
            soft_output_temp_p6_3 <= (others => (others => '0'));
            index_temp_p7_3       <= (others => (others => '0'));
            soft_output_temp_p7_3 <= (others => (others => '0'));
        elsif (rising_edge(clk)) then
            index_temp_p0_3       <= index_temp_p0_2;
            soft_output_temp_p0_3 <= soft_output_temp_p0_2;
            index_temp_p1_3       <= index_temp_p1_2;
            soft_output_temp_p1_3 <= soft_output_temp_p1_2;
            index_temp_p2_3       <= index_temp_p2_2;
            soft_output_temp_p2_3 <= soft_output_temp_p2_2;
            index_temp_p3_3       <= index_temp_p3_2;
            soft_output_temp_p3_3 <= soft_output_temp_p3_2;
            index_temp_p4_3       <= index_temp_p4_2;
            soft_output_temp_p4_3 <= soft_output_temp_p4_2;
            index_temp_p5_3       <= index_temp_p5_2;
            soft_output_temp_p5_3 <= soft_output_temp_p5_2;
            index_temp_p6_3       <= index_temp_p6_2;
            soft_output_temp_p6_3 <= soft_output_temp_p6_2;
            index_temp_p7_3       <= index_temp_p7_2;
            soft_output_temp_p7_3 <= soft_output_temp_p7_2;
        end if;
    end process;

    -- data pass between connection and soft_out

    process (clk, reset)
    begin
        if (reset = '1') then
            soft_output_temp_1_1           <= (others => (others => '0'));
            hard_output_temp_1_1           <= (others => '0');
            corrections_out_temp_1_1       <= (others => '0');
            error_position_out_temp_1_1    <= (others => 0);
            soft_output_unflipped_temp_1_1 <= (others => (others => '0'));
            final_weight_value_temp_1_1    <= (others => '0');
            soft_output_temp_2_1           <= (others => (others => '0'));
            hard_output_temp_2_1           <= (others => '0');
            corrections_out_temp_2_1       <= (others => '0');
            error_position_out_temp_2_1    <= (others => 0);
            soft_output_unflipped_temp_2_1 <= (others => (others => '0'));
            final_weight_value_temp_2_1    <= (others => '0');
            soft_output_temp_3_1           <= (others => (others => '0'));
            hard_output_temp_3_1           <= (others => '0');
            corrections_out_temp_3_1       <= (others => '0');
            error_position_out_temp_3_1    <= (others => 0);
            soft_output_unflipped_temp_3_1 <= (others => (others => '0'));
            final_weight_value_temp_3_1    <= (others => '0');
            soft_output_temp_4_1           <= (others => (others => '0'));
            hard_output_temp_4_1           <= (others => '0');
            corrections_out_temp_4_1       <= (others => '0');
            error_position_out_temp_4_1    <= (others => 0);
            soft_output_unflipped_temp_4_1 <= (others => (others => '0'));
            final_weight_value_temp_4_1    <= (others => '0');
            soft_output_temp_5_1           <= (others => (others => '0'));
            hard_output_temp_5_1           <= (others => '0');
            corrections_out_temp_5_1       <= (others => '0');
            error_position_out_temp_5_1    <= (others => 0);
            soft_output_unflipped_temp_5_1 <= (others => (others => '0'));
            final_weight_value_temp_5_1    <= (others => '0');
            soft_output_temp_6_1           <= (others => (others => '0'));
            hard_output_temp_6_1           <= (others => '0');
            corrections_out_temp_6_1       <= (others => '0');
            error_position_out_temp_6_1    <= (others => 0);
            soft_output_unflipped_temp_6_1 <= (others => (others => '0'));
            final_weight_value_temp_6_1    <= (others => '0');
            soft_output_temp_7_1           <= (others => (others => '0'));
            hard_output_temp_7_1           <= (others => '0');
            corrections_out_temp_7_1       <= (others => '0');
            error_position_out_temp_7_1    <= (others => 0);
            soft_output_unflipped_temp_7_1 <= (others => (others => '0'));
            final_weight_value_temp_7_1    <= (others => '0');
            soft_output_temp_8_1           <= (others => (others => '0'));
            hard_output_temp_8_1           <= (others => '0');
            corrections_out_temp_8_1       <= (others => '0');
            error_position_out_temp_8_1    <= (others => 0);
            soft_output_unflipped_temp_8_1 <= (others => (others => '0'));
            final_weight_value_temp_8_1    <= (others => '0');
        elsif (rising_edge(clk)) then
            soft_output_temp_1_1           <= soft_output_temp_1;
            hard_output_temp_1_1           <= hard_output_temp_1;
            corrections_out_temp_1_1       <= corrections_out_temp_1;
            error_position_out_temp_1_1    <= error_position_out_temp_1;
            soft_output_unflipped_temp_1_1 <= soft_output_unflipped_temp_1;
            final_weight_value_temp_1_1    <= final_weight_value_temp_1;
            soft_output_temp_2_1           <= soft_output_temp_2;
            hard_output_temp_2_1           <= hard_output_temp_2;
            corrections_out_temp_2_1       <= corrections_out_temp_2;
            error_position_out_temp_2_1    <= error_position_out_temp_2;
            soft_output_unflipped_temp_2_1 <= soft_output_unflipped_temp_2;
            final_weight_value_temp_2_1    <= final_weight_value_temp_2;
            soft_output_temp_3_1           <= soft_output_temp_3;
            hard_output_temp_3_1           <= hard_output_temp_3;
            corrections_out_temp_3_1       <= corrections_out_temp_3;
            error_position_out_temp_3_1    <= error_position_out_temp_3;
            soft_output_unflipped_temp_3_1 <= soft_output_unflipped_temp_3;
            final_weight_value_temp_3_1    <= final_weight_value_temp_3;
            soft_output_temp_4_1           <= soft_output_temp_4;
            hard_output_temp_4_1           <= hard_output_temp_4;
            corrections_out_temp_4_1       <= corrections_out_temp_4;
            error_position_out_temp_4_1    <= error_position_out_temp_4;
            soft_output_unflipped_temp_4_1 <= soft_output_unflipped_temp_4;
            final_weight_value_temp_4_1    <= final_weight_value_temp_4;
            soft_output_temp_5_1           <= soft_output_temp_5;
            hard_output_temp_5_1           <= hard_output_temp_5;
            corrections_out_temp_5_1       <= corrections_out_temp_5;
            error_position_out_temp_5_1    <= error_position_out_temp_5;
            soft_output_unflipped_temp_5_1 <= soft_output_unflipped_temp_5;
            final_weight_value_temp_5_1    <= final_weight_value_temp_5;
            soft_output_temp_6_1           <= soft_output_temp_6;
            hard_output_temp_6_1           <= hard_output_temp_6;
            corrections_out_temp_6_1       <= corrections_out_temp_6;
            error_position_out_temp_6_1    <= error_position_out_temp_6;
            soft_output_unflipped_temp_6_1 <= soft_output_unflipped_temp_6;
            final_weight_value_temp_6_1    <= final_weight_value_temp_6;
            soft_output_temp_7_1           <= soft_output_temp_7;
            hard_output_temp_7_1           <= hard_output_temp_7;
            corrections_out_temp_7_1       <= corrections_out_temp_7;
            error_position_out_temp_7_1    <= error_position_out_temp_7;
            soft_output_unflipped_temp_7_1 <= soft_output_unflipped_temp_7;
            final_weight_value_temp_7_1    <= final_weight_value_temp_7;
            soft_output_temp_8_1           <= soft_output_temp_8;
            hard_output_temp_8_1           <= hard_output_temp_8;
            corrections_out_temp_8_1       <= corrections_out_temp_8;
            error_position_out_temp_8_1    <= error_position_out_temp_8;
            soft_output_unflipped_temp_8_1 <= soft_output_unflipped_temp_8;
            final_weight_value_temp_8_1    <= final_weight_value_temp_8;
        end if;
    end process;

    process (clk, reset)
    begin
        if (reset = '1') then
            soft_output_temp_1_2           <= (others => (others => '0'));
            hard_output_temp_1_2           <= (others => '0');
            corrections_out_temp_1_2       <= (others => '0');
            error_position_out_temp_1_2    <= (others => 0);
            soft_output_unflipped_temp_1_2 <= (others => (others => '0'));
            final_weight_value_temp_1_2    <= (others => '0');
            soft_output_temp_2_2           <= (others => (others => '0'));
            hard_output_temp_2_2           <= (others => '0');
            corrections_out_temp_2_2       <= (others => '0');
            error_position_out_temp_2_2    <= (others => 0);
            soft_output_unflipped_temp_2_2 <= (others => (others => '0'));
            final_weight_value_temp_2_2    <= (others => '0');
            soft_output_temp_3_2           <= (others => (others => '0'));
            hard_output_temp_3_2           <= (others => '0');
            corrections_out_temp_3_2       <= (others => '0');
            error_position_out_temp_3_2    <= (others => 0);
            soft_output_unflipped_temp_3_2 <= (others => (others => '0'));
            final_weight_value_temp_3_2    <= (others => '0');
            soft_output_temp_4_2           <= (others => (others => '0'));
            hard_output_temp_4_2           <= (others => '0');
            corrections_out_temp_4_2       <= (others => '0');
            error_position_out_temp_4_2    <= (others => 0);
            soft_output_unflipped_temp_4_2 <= (others => (others => '0'));
            final_weight_value_temp_4_2    <= (others => '0');
            soft_output_temp_5_2           <= (others => (others => '0'));
            hard_output_temp_5_2           <= (others => '0');
            corrections_out_temp_5_2       <= (others => '0');
            error_position_out_temp_5_2    <= (others => 0);
            soft_output_unflipped_temp_5_2 <= (others => (others => '0'));
            final_weight_value_temp_5_2    <= (others => '0');
            soft_output_temp_6_2           <= (others => (others => '0'));
            hard_output_temp_6_2           <= (others => '0');
            corrections_out_temp_6_2       <= (others => '0');
            error_position_out_temp_6_2    <= (others => 0);
            soft_output_unflipped_temp_6_2 <= (others => (others => '0'));
            final_weight_value_temp_6_2    <= (others => '0');
            soft_output_temp_7_2           <= (others => (others => '0'));
            hard_output_temp_7_2           <= (others => '0');
            corrections_out_temp_7_2       <= (others => '0');
            error_position_out_temp_7_2    <= (others => 0);
            soft_output_unflipped_temp_7_2 <= (others => (others => '0'));
            final_weight_value_temp_7_2    <= (others => '0');
            soft_output_temp_8_2           <= (others => (others => '0'));
            hard_output_temp_8_2           <= (others => '0');
            corrections_out_temp_8_2       <= (others => '0');
            error_position_out_temp_8_2    <= (others => 0);
            soft_output_unflipped_temp_8_2 <= (others => (others => '0'));
            final_weight_value_temp_8_2    <= (others => '0');
        elsif (rising_edge(clk)) then
            soft_output_temp_1_2           <= soft_output_temp_1_1;
            hard_output_temp_1_2           <= hard_output_temp_1_1;
            corrections_out_temp_1_2       <= corrections_out_temp_1_1;
            error_position_out_temp_1_2    <= error_position_out_temp_1_1;
            soft_output_unflipped_temp_1_2 <= soft_output_unflipped_temp_1_1;
            final_weight_value_temp_1_2    <= final_weight_value_temp_1_1;
            soft_output_temp_2_2           <= soft_output_temp_2_1;
            hard_output_temp_2_2           <= hard_output_temp_2_1;
            corrections_out_temp_2_2       <= corrections_out_temp_2_1;
            error_position_out_temp_2_2    <= error_position_out_temp_2_1;
            soft_output_unflipped_temp_2_2 <= soft_output_unflipped_temp_2_1;
            final_weight_value_temp_2_2    <= final_weight_value_temp_2_1;
            soft_output_temp_3_2           <= soft_output_temp_3_1;
            hard_output_temp_3_2           <= hard_output_temp_3_1;
            corrections_out_temp_3_2       <= corrections_out_temp_3_1;
            error_position_out_temp_3_2    <= error_position_out_temp_3_1;
            soft_output_unflipped_temp_3_2 <= soft_output_unflipped_temp_3_1;
            final_weight_value_temp_3_2    <= final_weight_value_temp_3_1;
            soft_output_temp_4_2           <= soft_output_temp_4_1;
            hard_output_temp_4_2           <= hard_output_temp_4_1;
            corrections_out_temp_4_2       <= corrections_out_temp_4_1;
            error_position_out_temp_4_2    <= error_position_out_temp_4_1;
            soft_output_unflipped_temp_4_2 <= soft_output_unflipped_temp_4_1;
            final_weight_value_temp_4_2    <= final_weight_value_temp_4_1;
            soft_output_temp_5_2           <= soft_output_temp_5_1;
            hard_output_temp_5_2           <= hard_output_temp_5_1;
            corrections_out_temp_5_2       <= corrections_out_temp_5_1;
            error_position_out_temp_5_2    <= error_position_out_temp_5_1;
            soft_output_unflipped_temp_5_2 <= soft_output_unflipped_temp_5_1;
            final_weight_value_temp_5_2    <= final_weight_value_temp_5_1;
            soft_output_temp_6_2           <= soft_output_temp_6_1;
            hard_output_temp_6_2           <= hard_output_temp_6_1;
            corrections_out_temp_6_2       <= corrections_out_temp_6_1;
            error_position_out_temp_6_2    <= error_position_out_temp_6_1;
            soft_output_unflipped_temp_6_2 <= soft_output_unflipped_temp_6_1;
            final_weight_value_temp_6_2    <= final_weight_value_temp_6_1;
            soft_output_temp_7_2           <= soft_output_temp_7_1;
            hard_output_temp_7_2           <= hard_output_temp_7_1;
            corrections_out_temp_7_2       <= corrections_out_temp_7_1;
            error_position_out_temp_7_2    <= error_position_out_temp_7_1;
            soft_output_unflipped_temp_7_2 <= soft_output_unflipped_temp_7_1;
            final_weight_value_temp_7_2    <= final_weight_value_temp_7_1;
            soft_output_temp_8_2           <= soft_output_temp_8_1;
            hard_output_temp_8_2           <= hard_output_temp_8_1;
            corrections_out_temp_8_2       <= corrections_out_temp_8_1;
            error_position_out_temp_8_2    <= error_position_out_temp_8_1;
            soft_output_unflipped_temp_8_2 <= soft_output_unflipped_temp_8_1;
            final_weight_value_temp_8_2    <= final_weight_value_temp_8_1;
        end if;
    end process;
end architecture;
