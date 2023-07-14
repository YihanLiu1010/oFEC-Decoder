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
use work.arr_pkg_2.all;
package arr_pkg_7 is
    type output_codeword_array is array (natural range <>) of input_data_array(255 downto 0);
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
use work.arr_pkg_7.all;
-- A codeword is input_data_array(255 downto 0) 
-- Data from channel will be 16*128 = 2048 of input_data_array that's the second half of the 16 codewords, the shifting and grabbing also works for it
-- Data from RAM comes in one square(256 input_data_array 256*8) at a time, there will be 2 squares comes in each clock cycle
-- The index needs to be changed if the number of the soft bits is changed!!!
entity interleaver_control is
    port (
        clk                 : in std_logic;
        reset               : in std_logic;
        input_data_memory_1 : in std_logic_vector(2047 downto 0); -- From memory 256*8(16*16*8), a square
        input_data_memory_2 : in std_logic_vector(2047 downto 0);
        input_data_channel  : in input_data_array(255 downto 0); -- From Channel, it also comes in one square per clock cycle
        output_2_decoder    : out input_data_array(255 downto 0)
    );
end interleaver_control;

architecture rtl of interleaver_control is
    constant soft_bits       : integer := 8; -- Number of soft bits
    signal AND_array         : std_logic_vector(2048 - 1 downto 0);
    signal channel_and_array : input_data_array(256 - 1 downto 0);
    signal AND_array_1       : std_logic_vector(soft_bits - 1 downto 0)    := (others => '1');
    signal AND_array_2       : std_logic_vector(2048 - 1 downto soft_bits) := (others => '0');
    signal AND_array_3       : input_data_array(256 - 1 downto 16)         := (others => (others => '0'));
    signal AND_array_4       : input_data_array(15 downto 0)               := (others => (others => '1'));

    signal channel_shift_1  : input_data_array(15 downto 0)  := (others => (others => '0'));
    signal channel_shift_2  : input_data_array(31 downto 0)  := (others => (others => '0'));
    signal channel_shift_3  : input_data_array(47 downto 0)  := (others => (others => '0'));
    signal channel_shift_4  : input_data_array(63 downto 0)  := (others => (others => '0'));
    signal channel_shift_5  : input_data_array(79 downto 0)  := (others => (others => '0'));
    signal channel_shift_6  : input_data_array(95 downto 0)  := (others => (others => '0'));
    signal channel_shift_7  : input_data_array(111 downto 0) := (others => (others => '0'));
    signal channel_shift_8  : input_data_array(127 downto 0) := (others => (others => '0'));
    signal channel_shift_9  : input_data_array(143 downto 0) := (others => (others => '0'));
    signal channel_shift_10 : input_data_array(159 downto 0) := (others => (others => '0'));
    signal channel_shift_11 : input_data_array(175 downto 0) := (others => (others => '0'));
    signal channel_shift_12 : input_data_array(191 downto 0) := (others => (others => '0'));
    signal channel_shift_13 : input_data_array(207 downto 0) := (others => (others => '0'));
    signal channel_shift_14 : input_data_array(223 downto 0) := (others => (others => '0'));
    signal channel_shift_15 : input_data_array(239 downto 0) := (others => (others => '0'));
    -------------------------------------------------------------
    -- process 1 
    signal s_input_data_channel_r1  : input_data_array(255 downto 0); -- shifted row 1
    signal s_input_data_channel_r2  : input_data_array(255 downto 0); -- shifted row 2
    signal s_input_data_channel_r3  : input_data_array(255 downto 0); -- shifted row 3
    signal s_input_data_channel_r4  : input_data_array(255 downto 0); -- shifted row 4
    signal s_input_data_channel_r5  : input_data_array(255 downto 0); -- shifted row 5
    signal s_input_data_channel_r6  : input_data_array(255 downto 0); -- shifted row 6
    signal s_input_data_channel_r7  : input_data_array(255 downto 0); -- shifted row 7
    signal s_input_data_channel_r8  : input_data_array(255 downto 0); -- shifted row 8
    signal s_input_data_channel_r9  : input_data_array(255 downto 0); -- shifted row 9
    signal s_input_data_channel_r10 : input_data_array(255 downto 0); -- shifted row 10
    signal s_input_data_channel_r11 : input_data_array(255 downto 0); -- shifted row 11
    signal s_input_data_channel_r12 : input_data_array(255 downto 0); -- shifted row 12
    signal s_input_data_channel_r13 : input_data_array(255 downto 0); -- shifted row 13
    signal s_input_data_channel_r14 : input_data_array(255 downto 0); -- shifted row 14
    signal s_input_data_channel_r15 : input_data_array(255 downto 0); -- shifted row 15
    signal s_input_data_channel_r16 : input_data_array(255 downto 0); -- shifted row 16

    signal shift_1_1_1, shift_1_1_2, shift_1_1_3, shift_1_1_4, shift_1_1_5, shift_1_1_6, shift_1_1_7, shift_1_1_8, shift_1_1_9, shift_1_1_10, shift_1_1_11, shift_1_1_12, shift_1_1_13, shift_1_1_14, shift_1_1_15, shift_1_1_16                 : std_logic_vector(2047 downto 0); -- First Square, First Column
    signal shift_1_2_1, shift_1_2_2, shift_1_2_3, shift_1_2_4, shift_1_2_5, shift_1_2_6, shift_1_2_7, shift_1_2_8, shift_1_2_9, shift_1_2_10, shift_1_2_11, shift_1_2_12, shift_1_2_13, shift_1_2_14, shift_1_2_15, shift_1_2_16                 : std_logic_vector(2047 downto 0); -- First Square, Second Column
    signal shift_1_3_1, shift_1_3_2, shift_1_3_3, shift_1_3_4, shift_1_3_5, shift_1_3_6, shift_1_3_7, shift_1_3_8, shift_1_3_9, shift_1_3_10, shift_1_3_11, shift_1_3_12, shift_1_3_13, shift_1_3_14, shift_1_3_15, shift_1_3_16                 : std_logic_vector(2047 downto 0);
    signal shift_1_4_1, shift_1_4_2, shift_1_4_3, shift_1_4_4, shift_1_4_5, shift_1_4_6, shift_1_4_7, shift_1_4_8, shift_1_4_9, shift_1_4_10, shift_1_4_11, shift_1_4_12, shift_1_4_13, shift_1_4_14, shift_1_4_15, shift_1_4_16                 : std_logic_vector(2047 downto 0);
    signal shift_1_5_1, shift_1_5_2, shift_1_5_3, shift_1_5_4, shift_1_5_5, shift_1_5_6, shift_1_5_7, shift_1_5_8, shift_1_5_9, shift_1_5_10, shift_1_5_11, shift_1_5_12, shift_1_5_13, shift_1_5_14, shift_1_5_15, shift_1_5_16                 : std_logic_vector(2047 downto 0);
    signal shift_1_6_1, shift_1_6_2, shift_1_6_3, shift_1_6_4, shift_1_6_5, shift_1_6_6, shift_1_6_7, shift_1_6_8, shift_1_6_9, shift_1_6_10, shift_1_6_11, shift_1_6_12, shift_1_6_13, shift_1_6_14, shift_1_6_15, shift_1_6_16                 : std_logic_vector(2047 downto 0);
    signal shift_1_7_1, shift_1_7_2, shift_1_7_3, shift_1_7_4, shift_1_7_5, shift_1_7_6, shift_1_7_7, shift_1_7_8, shift_1_7_9, shift_1_7_10, shift_1_7_11, shift_1_7_12, shift_1_7_13, shift_1_7_14, shift_1_7_15, shift_1_7_16                 : std_logic_vector(2047 downto 0);
    signal shift_1_8_1, shift_1_8_2, shift_1_8_3, shift_1_8_4, shift_1_8_5, shift_1_8_6, shift_1_8_7, shift_1_8_8, shift_1_8_9, shift_1_8_10, shift_1_8_11, shift_1_8_12, shift_1_8_13, shift_1_8_14, shift_1_8_15, shift_1_8_16                 : std_logic_vector(2047 downto 0);
    signal shift_1_9_1, shift_1_9_2, shift_1_9_3, shift_1_9_4, shift_1_9_5, shift_1_9_6, shift_1_9_7, shift_1_9_8, shift_1_9_9, shift_1_9_10, shift_1_9_11, shift_1_9_12, shift_1_9_13, shift_1_9_14, shift_1_9_15, shift_1_9_16                 : std_logic_vector(2047 downto 0);
    signal shift_1_10_1, shift_1_10_2, shift_1_10_3, shift_1_10_4, shift_1_10_5, shift_1_10_6, shift_1_10_7, shift_1_10_8, shift_1_10_9, shift_1_10_10, shift_1_10_11, shift_1_10_12, shift_1_10_13, shift_1_10_14, shift_1_10_15, shift_1_10_16 : std_logic_vector(2047 downto 0);
    signal shift_1_11_1, shift_1_11_2, shift_1_11_3, shift_1_11_4, shift_1_11_5, shift_1_11_6, shift_1_11_7, shift_1_11_8, shift_1_11_9, shift_1_11_10, shift_1_11_11, shift_1_11_12, shift_1_11_13, shift_1_11_14, shift_1_11_15, shift_1_11_16 : std_logic_vector(2047 downto 0);
    signal shift_1_12_1, shift_1_12_2, shift_1_12_3, shift_1_12_4, shift_1_12_5, shift_1_12_6, shift_1_12_7, shift_1_12_8, shift_1_12_9, shift_1_12_10, shift_1_12_11, shift_1_12_12, shift_1_12_13, shift_1_12_14, shift_1_12_15, shift_1_12_16 : std_logic_vector(2047 downto 0);
    signal shift_1_13_1, shift_1_13_2, shift_1_13_3, shift_1_13_4, shift_1_13_5, shift_1_13_6, shift_1_13_7, shift_1_13_8, shift_1_13_9, shift_1_13_10, shift_1_13_11, shift_1_13_12, shift_1_13_13, shift_1_13_14, shift_1_13_15, shift_1_13_16 : std_logic_vector(2047 downto 0);
    signal shift_1_14_1, shift_1_14_2, shift_1_14_3, shift_1_14_4, shift_1_14_5, shift_1_14_6, shift_1_14_7, shift_1_14_8, shift_1_14_9, shift_1_14_10, shift_1_14_11, shift_1_14_12, shift_1_14_13, shift_1_14_14, shift_1_14_15, shift_1_14_16 : std_logic_vector(2047 downto 0);
    signal shift_1_15_1, shift_1_15_2, shift_1_15_3, shift_1_15_4, shift_1_15_5, shift_1_15_6, shift_1_15_7, shift_1_15_8, shift_1_15_9, shift_1_15_10, shift_1_15_11, shift_1_15_12, shift_1_15_13, shift_1_15_14, shift_1_15_15, shift_1_15_16 : std_logic_vector(2047 downto 0);
    signal shift_1_16_1, shift_1_16_2, shift_1_16_3, shift_1_16_4, shift_1_16_5, shift_1_16_6, shift_1_16_7, shift_1_16_8, shift_1_16_9, shift_1_16_10, shift_1_16_11, shift_1_16_12, shift_1_16_13, shift_1_16_14, shift_1_16_15, shift_1_16_16 : std_logic_vector(2047 downto 0);
    signal shift_2_1_1, shift_2_1_2, shift_2_1_3, shift_2_1_4, shift_2_1_5, shift_2_1_6, shift_2_1_7, shift_2_1_8, shift_2_1_9, shift_2_1_10, shift_2_1_11, shift_2_1_12, shift_2_1_13, shift_2_1_14, shift_2_1_15, shift_2_1_16                 : std_logic_vector(2047 downto 0);-- Second Square, First Column
    signal shift_2_2_1, shift_2_2_2, shift_2_2_3, shift_2_2_4, shift_2_2_5, shift_2_2_6, shift_2_2_7, shift_2_2_8, shift_2_2_9, shift_2_2_10, shift_2_2_11, shift_2_2_12, shift_2_2_13, shift_2_2_14, shift_2_2_15, shift_2_2_16                 : std_logic_vector(2047 downto 0);-- Second Square, Second Column
    signal shift_2_3_1, shift_2_3_2, shift_2_3_3, shift_2_3_4, shift_2_3_5, shift_2_3_6, shift_2_3_7, shift_2_3_8, shift_2_3_9, shift_2_3_10, shift_2_3_11, shift_2_3_12, shift_2_3_13, shift_2_3_14, shift_2_3_15, shift_2_3_16                 : std_logic_vector(2047 downto 0);-- Second Square, Third Column
    signal shift_2_4_1, shift_2_4_2, shift_2_4_3, shift_2_4_4, shift_2_4_5, shift_2_4_6, shift_2_4_7, shift_2_4_8, shift_2_4_9, shift_2_4_10, shift_2_4_11, shift_2_4_12, shift_2_4_13, shift_2_4_14, shift_2_4_15, shift_2_4_16                 : std_logic_vector(2047 downto 0);-- Second Square, Fourth Column
    signal shift_2_5_1, shift_2_5_2, shift_2_5_3, shift_2_5_4, shift_2_5_5, shift_2_5_6, shift_2_5_7, shift_2_5_8, shift_2_5_9, shift_2_5_10, shift_2_5_11, shift_2_5_12, shift_2_5_13, shift_2_5_14, shift_2_5_15, shift_2_5_16                 : std_logic_vector(2047 downto 0);-- Second Square, Fifth Column
    signal shift_2_6_1, shift_2_6_2, shift_2_6_3, shift_2_6_4, shift_2_6_5, shift_2_6_6, shift_2_6_7, shift_2_6_8, shift_2_6_9, shift_2_6_10, shift_2_6_11, shift_2_6_12, shift_2_6_13, shift_2_6_14, shift_2_6_15, shift_2_6_16                 : std_logic_vector(2047 downto 0);-- Second Square, Sixth Column
    signal shift_2_7_1, shift_2_7_2, shift_2_7_3, shift_2_7_4, shift_2_7_5, shift_2_7_6, shift_2_7_7, shift_2_7_8, shift_2_7_9, shift_2_7_10, shift_2_7_11, shift_2_7_12, shift_2_7_13, shift_2_7_14, shift_2_7_15, shift_2_7_16                 : std_logic_vector(2047 downto 0);-- Second Square, Seventh Column
    signal shift_2_8_1, shift_2_8_2, shift_2_8_3, shift_2_8_4, shift_2_8_5, shift_2_8_6, shift_2_8_7, shift_2_8_8, shift_2_8_9, shift_2_8_10, shift_2_8_11, shift_2_8_12, shift_2_8_13, shift_2_8_14, shift_2_8_15, shift_2_8_16                 : std_logic_vector(2047 downto 0);-- Second Square, Eighth Column
    signal shift_2_9_1, shift_2_9_2, shift_2_9_3, shift_2_9_4, shift_2_9_5, shift_2_9_6, shift_2_9_7, shift_2_9_8, shift_2_9_9, shift_2_9_10, shift_2_9_11, shift_2_9_12, shift_2_9_13, shift_2_9_14, shift_2_9_15, shift_2_9_16                 : std_logic_vector(2047 downto 0);-- Second Square, Ninth Column
    signal shift_2_10_1, shift_2_10_2, shift_2_10_3, shift_2_10_4, shift_2_10_5, shift_2_10_6, shift_2_10_7, shift_2_10_8, shift_2_10_9, shift_2_10_10, shift_2_10_11, shift_2_10_12, shift_2_10_13, shift_2_10_14, shift_2_10_15, shift_2_10_16 : std_logic_vector(2047 downto 0);-- Second Square, Tenth Column
    signal shift_2_11_1, shift_2_11_2, shift_2_11_3, shift_2_11_4, shift_2_11_5, shift_2_11_6, shift_2_11_7, shift_2_11_8, shift_2_11_9, shift_2_11_10, shift_2_11_11, shift_2_11_12, shift_2_11_13, shift_2_11_14, shift_2_11_15, shift_2_11_16 : std_logic_vector(2047 downto 0);-- Second Square, Eleventh Column
    signal shift_2_12_1, shift_2_12_2, shift_2_12_3, shift_2_12_4, shift_2_12_5, shift_2_12_6, shift_2_12_7, shift_2_12_8, shift_2_12_9, shift_2_12_10, shift_2_12_11, shift_2_12_12, shift_2_12_13, shift_2_12_14, shift_2_12_15, shift_2_12_16 : std_logic_vector(2047 downto 0);-- Second Square, Twelfth Column
    signal shift_2_13_1, shift_2_13_2, shift_2_13_3, shift_2_13_4, shift_2_13_5, shift_2_13_6, shift_2_13_7, shift_2_13_8, shift_2_13_9, shift_2_13_10, shift_2_13_11, shift_2_13_12, shift_2_13_13, shift_2_13_14, shift_2_13_15, shift_2_13_16 : std_logic_vector(2047 downto 0);-- Second Square, Thirteenth Column
    signal shift_2_14_1, shift_2_14_2, shift_2_14_3, shift_2_14_4, shift_2_14_5, shift_2_14_6, shift_2_14_7, shift_2_14_8, shift_2_14_9, shift_2_14_10, shift_2_14_11, shift_2_14_12, shift_2_14_13, shift_2_14_14, shift_2_14_15, shift_2_14_16 : std_logic_vector(2047 downto 0);-- Second Square, Fourteenth Column
    signal shift_2_15_1, shift_2_15_2, shift_2_15_3, shift_2_15_4, shift_2_15_5, shift_2_15_6, shift_2_15_7, shift_2_15_8, shift_2_15_9, shift_2_15_10, shift_2_15_11, shift_2_15_12, shift_2_15_13, shift_2_15_14, shift_2_15_15, shift_2_15_16 : std_logic_vector(2047 downto 0);-- Second Square, Fifteenth Column
    signal shift_2_16_1, shift_2_16_2, shift_2_16_3, shift_2_16_4, shift_2_16_5, shift_2_16_6, shift_2_16_7, shift_2_16_8, shift_2_16_9, shift_2_16_10, shift_2_16_11, shift_2_16_12, shift_2_16_13, shift_2_16_14, shift_2_16_15, shift_2_16_16 : std_logic_vector(2047 downto 0);-- Second Square, Sixteenth Column
    -------------------------------------------------------------
    -- process 2
    signal input_data_channel_r1  : input_data_array(255 downto 0); -- row 1
    signal input_data_channel_r2  : input_data_array(255 downto 0); -- row 2
    signal input_data_channel_r3  : input_data_array(255 downto 0); -- row 3
    signal input_data_channel_r4  : input_data_array(255 downto 0); -- row 4
    signal input_data_channel_r5  : input_data_array(255 downto 0); -- row 5
    signal input_data_channel_r6  : input_data_array(255 downto 0); -- row 6
    signal input_data_channel_r7  : input_data_array(255 downto 0); -- row 7
    signal input_data_channel_r8  : input_data_array(255 downto 0); -- row 8
    signal input_data_channel_r9  : input_data_array(255 downto 0); -- row 9
    signal input_data_channel_r10 : input_data_array(255 downto 0); -- row 10
    signal input_data_channel_r11 : input_data_array(255 downto 0); -- row 11
    signal input_data_channel_r12 : input_data_array(255 downto 0); -- row 12
    signal input_data_channel_r13 : input_data_array(255 downto 0); -- row 13
    signal input_data_channel_r14 : input_data_array(255 downto 0); -- row 14
    signal input_data_channel_r15 : input_data_array(255 downto 0); -- row 15
    signal input_data_channel_r16 : input_data_array(255 downto 0); -- row 16

    signal column_1_1_1, column_1_1_2, column_1_1_3, column_1_1_4, column_1_1_5, column_1_1_6, column_1_1_7, column_1_1_8, column_1_1_9, column_1_1_10, column_1_1_11, column_1_1_12, column_1_1_13, column_1_1_14, column_1_1_15, column_1_1_16                 : std_logic_vector(2047 downto 0); -- First Sqaure, First Column
    signal column_1_2_1, column_1_2_2, column_1_2_3, column_1_2_4, column_1_2_5, column_1_2_6, column_1_2_7, column_1_2_8, column_1_2_9, column_1_2_10, column_1_2_11, column_1_2_12, column_1_2_13, column_1_2_14, column_1_2_15, column_1_2_16                 : std_logic_vector(2047 downto 0);
    signal column_1_3_1, column_1_3_2, column_1_3_3, column_1_3_4, column_1_3_5, column_1_3_6, column_1_3_7, column_1_3_8, column_1_3_9, column_1_3_10, column_1_3_11, column_1_3_12, column_1_3_13, column_1_3_14, column_1_3_15, column_1_3_16                 : std_logic_vector(2047 downto 0);
    signal column_1_4_1, column_1_4_2, column_1_4_3, column_1_4_4, column_1_4_5, column_1_4_6, column_1_4_7, column_1_4_8, column_1_4_9, column_1_4_10, column_1_4_11, column_1_4_12, column_1_4_13, column_1_4_14, column_1_4_15, column_1_4_16                 : std_logic_vector(2047 downto 0);
    signal column_1_5_1, column_1_5_2, column_1_5_3, column_1_5_4, column_1_5_5, column_1_5_6, column_1_5_7, column_1_5_8, column_1_5_9, column_1_5_10, column_1_5_11, column_1_5_12, column_1_5_13, column_1_5_14, column_1_5_15, column_1_5_16                 : std_logic_vector(2047 downto 0);
    signal column_1_6_1, column_1_6_2, column_1_6_3, column_1_6_4, column_1_6_5, column_1_6_6, column_1_6_7, column_1_6_8, column_1_6_9, column_1_6_10, column_1_6_11, column_1_6_12, column_1_6_13, column_1_6_14, column_1_6_15, column_1_6_16                 : std_logic_vector(2047 downto 0);
    signal column_1_7_1, column_1_7_2, column_1_7_3, column_1_7_4, column_1_7_5, column_1_7_6, column_1_7_7, column_1_7_8, column_1_7_9, column_1_7_10, column_1_7_11, column_1_7_12, column_1_7_13, column_1_7_14, column_1_7_15, column_1_7_16                 : std_logic_vector(2047 downto 0);
    signal column_1_8_1, column_1_8_2, column_1_8_3, column_1_8_4, column_1_8_5, column_1_8_6, column_1_8_7, column_1_8_8, column_1_8_9, column_1_8_10, column_1_8_11, column_1_8_12, column_1_8_13, column_1_8_14, column_1_8_15, column_1_8_16                 : std_logic_vector(2047 downto 0);
    signal column_1_9_1, column_1_9_2, column_1_9_3, column_1_9_4, column_1_9_5, column_1_9_6, column_1_9_7, column_1_9_8, column_1_9_9, column_1_9_10, column_1_9_11, column_1_9_12, column_1_9_13, column_1_9_14, column_1_9_15, column_1_9_16                 : std_logic_vector(2047 downto 0);
    signal column_1_10_1, column_1_10_2, column_1_10_3, column_1_10_4, column_1_10_5, column_1_10_6, column_1_10_7, column_1_10_8, column_1_10_9, column_1_10_10, column_1_10_11, column_1_10_12, column_1_10_13, column_1_10_14, column_1_10_15, column_1_10_16 : std_logic_vector(2047 downto 0);
    signal column_1_11_1, column_1_11_2, column_1_11_3, column_1_11_4, column_1_11_5, column_1_11_6, column_1_11_7, column_1_11_8, column_1_11_9, column_1_11_10, column_1_11_11, column_1_11_12, column_1_11_13, column_1_11_14, column_1_11_15, column_1_11_16 : std_logic_vector(2047 downto 0);
    signal column_1_12_1, column_1_12_2, column_1_12_3, column_1_12_4, column_1_12_5, column_1_12_6, column_1_12_7, column_1_12_8, column_1_12_9, column_1_12_10, column_1_12_11, column_1_12_12, column_1_12_13, column_1_12_14, column_1_12_15, column_1_12_16 : std_logic_vector(2047 downto 0);
    signal column_1_13_1, column_1_13_2, column_1_13_3, column_1_13_4, column_1_13_5, column_1_13_6, column_1_13_7, column_1_13_8, column_1_13_9, column_1_13_10, column_1_13_11, column_1_13_12, column_1_13_13, column_1_13_14, column_1_13_15, column_1_13_16 : std_logic_vector(2047 downto 0);
    signal column_1_14_1, column_1_14_2, column_1_14_3, column_1_14_4, column_1_14_5, column_1_14_6, column_1_14_7, column_1_14_8, column_1_14_9, column_1_14_10, column_1_14_11, column_1_14_12, column_1_14_13, column_1_14_14, column_1_14_15, column_1_14_16 : std_logic_vector(2047 downto 0);
    signal column_1_15_1, column_1_15_2, column_1_15_3, column_1_15_4, column_1_15_5, column_1_15_6, column_1_15_7, column_1_15_8, column_1_15_9, column_1_15_10, column_1_15_11, column_1_15_12, column_1_15_13, column_1_15_14, column_1_15_15, column_1_15_16 : std_logic_vector(2047 downto 0);
    signal column_1_16_1, column_1_16_2, column_1_16_3, column_1_16_4, column_1_16_5, column_1_16_6, column_1_16_7, column_1_16_8, column_1_16_9, column_1_16_10, column_1_16_11, column_1_16_12, column_1_16_13, column_1_16_14, column_1_16_15, column_1_16_16 : std_logic_vector(2047 downto 0);
    signal column_2_1_1, column_2_1_2, column_2_1_3, column_2_1_4, column_2_1_5, column_2_1_6, column_2_1_7, column_2_1_8, column_2_1_9, column_2_1_10, column_2_1_11, column_2_1_12, column_2_1_13, column_2_1_14, column_2_1_15, column_2_1_16                 : std_logic_vector(2047 downto 0);-- Second Sqaure, First Column
    signal column_2_2_1, column_2_2_2, column_2_2_3, column_2_2_4, column_2_2_5, column_2_2_6, column_2_2_7, column_2_2_8, column_2_2_9, column_2_2_10, column_2_2_11, column_2_2_12, column_2_2_13, column_2_2_14, column_2_2_15, column_2_2_16                 : std_logic_vector(2047 downto 0);
    signal column_2_3_1, column_2_3_2, column_2_3_3, column_2_3_4, column_2_3_5, column_2_3_6, column_2_3_7, column_2_3_8, column_2_3_9, column_2_3_10, column_2_3_11, column_2_3_12, column_2_3_13, column_2_3_14, column_2_3_15, column_2_3_16                 : std_logic_vector(2047 downto 0);
    signal column_2_4_1, column_2_4_2, column_2_4_3, column_2_4_4, column_2_4_5, column_2_4_6, column_2_4_7, column_2_4_8, column_2_4_9, column_2_4_10, column_2_4_11, column_2_4_12, column_2_4_13, column_2_4_14, column_2_4_15, column_2_4_16                 : std_logic_vector(2047 downto 0);
    signal column_2_5_1, column_2_5_2, column_2_5_3, column_2_5_4, column_2_5_5, column_2_5_6, column_2_5_7, column_2_5_8, column_2_5_9, column_2_5_10, column_2_5_11, column_2_5_12, column_2_5_13, column_2_5_14, column_2_5_15, column_2_5_16                 : std_logic_vector(2047 downto 0);
    signal column_2_6_1, column_2_6_2, column_2_6_3, column_2_6_4, column_2_6_5, column_2_6_6, column_2_6_7, column_2_6_8, column_2_6_9, column_2_6_10, column_2_6_11, column_2_6_12, column_2_6_13, column_2_6_14, column_2_6_15, column_2_6_16                 : std_logic_vector(2047 downto 0);
    signal column_2_7_1, column_2_7_2, column_2_7_3, column_2_7_4, column_2_7_5, column_2_7_6, column_2_7_7, column_2_7_8, column_2_7_9, column_2_7_10, column_2_7_11, column_2_7_12, column_2_7_13, column_2_7_14, column_2_7_15, column_2_7_16                 : std_logic_vector(2047 downto 0);
    signal column_2_8_1, column_2_8_2, column_2_8_3, column_2_8_4, column_2_8_5, column_2_8_6, column_2_8_7, column_2_8_8, column_2_8_9, column_2_8_10, column_2_8_11, column_2_8_12, column_2_8_13, column_2_8_14, column_2_8_15, column_2_8_16                 : std_logic_vector(2047 downto 0);
    signal column_2_9_1, column_2_9_2, column_2_9_3, column_2_9_4, column_2_9_5, column_2_9_6, column_2_9_7, column_2_9_8, column_2_9_9, column_2_9_10, column_2_9_11, column_2_9_12, column_2_9_13, column_2_9_14, column_2_9_15, column_2_9_16                 : std_logic_vector(2047 downto 0);
    signal column_2_10_1, column_2_10_2, column_2_10_3, column_2_10_4, column_2_10_5, column_2_10_6, column_2_10_7, column_2_10_8, column_2_10_9, column_2_10_10, column_2_10_11, column_2_10_12, column_2_10_13, column_2_10_14, column_2_10_15, column_2_10_16 : std_logic_vector(2047 downto 0);
    signal column_2_11_1, column_2_11_2, column_2_11_3, column_2_11_4, column_2_11_5, column_2_11_6, column_2_11_7, column_2_11_8, column_2_11_9, column_2_11_10, column_2_11_11, column_2_11_12, column_2_11_13, column_2_11_14, column_2_11_15, column_2_11_16 : std_logic_vector(2047 downto 0);
    signal column_2_12_1, column_2_12_2, column_2_12_3, column_2_12_4, column_2_12_5, column_2_12_6, column_2_12_7, column_2_12_8, column_2_12_9, column_2_12_10, column_2_12_11, column_2_12_12, column_2_12_13, column_2_12_14, column_2_12_15, column_2_12_16 : std_logic_vector(2047 downto 0);
    signal column_2_13_1, column_2_13_2, column_2_13_3, column_2_13_4, column_2_13_5, column_2_13_6, column_2_13_7, column_2_13_8, column_2_13_9, column_2_13_10, column_2_13_11, column_2_13_12, column_2_13_13, column_2_13_14, column_2_13_15, column_2_13_16 : std_logic_vector(2047 downto 0);
    signal column_2_14_1, column_2_14_2, column_2_14_3, column_2_14_4, column_2_14_5, column_2_14_6, column_2_14_7, column_2_14_8, column_2_14_9, column_2_14_10, column_2_14_11, column_2_14_12, column_2_14_13, column_2_14_14, column_2_14_15, column_2_14_16 : std_logic_vector(2047 downto 0);
    signal column_2_15_1, column_2_15_2, column_2_15_3, column_2_15_4, column_2_15_5, column_2_15_6, column_2_15_7, column_2_15_8, column_2_15_9, column_2_15_10, column_2_15_11, column_2_15_12, column_2_15_13, column_2_15_14, column_2_15_15, column_2_15_16 : std_logic_vector(2047 downto 0);
    signal column_2_16_1, column_2_16_2, column_2_16_3, column_2_16_4, column_2_16_5, column_2_16_6, column_2_16_7, column_2_16_8, column_2_16_9, column_2_16_10, column_2_16_11, column_2_16_12, column_2_16_13, column_2_16_14, column_2_16_15, column_2_16_16 : std_logic_vector(2047 downto 0);
    -------------------------------------------------------------
    -- process 3
    signal cut_input_data_channel_r1  : input_data_array(15 downto 0);
    signal cut_input_data_channel_r2  : input_data_array(15 downto 0);
    signal cut_input_data_channel_r3  : input_data_array(15 downto 0);
    signal cut_input_data_channel_r4  : input_data_array(15 downto 0);
    signal cut_input_data_channel_r5  : input_data_array(15 downto 0);
    signal cut_input_data_channel_r6  : input_data_array(15 downto 0);
    signal cut_input_data_channel_r7  : input_data_array(15 downto 0);
    signal cut_input_data_channel_r8  : input_data_array(15 downto 0);
    signal cut_input_data_channel_r9  : input_data_array(15 downto 0);
    signal cut_input_data_channel_r10 : input_data_array(15 downto 0);
    signal cut_input_data_channel_r11 : input_data_array(15 downto 0);
    signal cut_input_data_channel_r12 : input_data_array(15 downto 0);
    signal cut_input_data_channel_r13 : input_data_array(15 downto 0);
    signal cut_input_data_channel_r14 : input_data_array(15 downto 0);
    signal cut_input_data_channel_r15 : input_data_array(15 downto 0);
    signal cut_input_data_channel_r16 : input_data_array(15 downto 0);

    signal cut_column_1_1_1, cut_column_1_1_2, cut_column_1_1_3, cut_column_1_1_4, cut_column_1_1_5, cut_column_1_1_6, cut_column_1_1_7, cut_column_1_1_8, cut_column_1_1_9, cut_column_1_1_10, cut_column_1_1_11, cut_column_1_1_12, cut_column_1_1_13, cut_column_1_1_14, cut_column_1_1_15, cut_column_1_1_16                 : std_logic_vector(7 downto 0); -- First Sqaure, First Column
    signal cut_column_1_2_1, cut_column_1_2_2, cut_column_1_2_3, cut_column_1_2_4, cut_column_1_2_5, cut_column_1_2_6, cut_column_1_2_7, cut_column_1_2_8, cut_column_1_2_9, cut_column_1_2_10, cut_column_1_2_11, cut_column_1_2_12, cut_column_1_2_13, cut_column_1_2_14, cut_column_1_2_15, cut_column_1_2_16                 : std_logic_vector(7 downto 0); -- First Sqaure, Second Column
    signal cut_column_1_3_1, cut_column_1_3_2, cut_column_1_3_3, cut_column_1_3_4, cut_column_1_3_5, cut_column_1_3_6, cut_column_1_3_7, cut_column_1_3_8, cut_column_1_3_9, cut_column_1_3_10, cut_column_1_3_11, cut_column_1_3_12, cut_column_1_3_13, cut_column_1_3_14, cut_column_1_3_15, cut_column_1_3_16                 : std_logic_vector(7 downto 0); -- First Sqaure, Third Column
    signal cut_column_1_4_1, cut_column_1_4_2, cut_column_1_4_3, cut_column_1_4_4, cut_column_1_4_5, cut_column_1_4_6, cut_column_1_4_7, cut_column_1_4_8, cut_column_1_4_9, cut_column_1_4_10, cut_column_1_4_11, cut_column_1_4_12, cut_column_1_4_13, cut_column_1_4_14, cut_column_1_4_15, cut_column_1_4_16                 : std_logic_vector(7 downto 0); -- First Sqaure, Fourth Column
    signal cut_column_1_5_1, cut_column_1_5_2, cut_column_1_5_3, cut_column_1_5_4, cut_column_1_5_5, cut_column_1_5_6, cut_column_1_5_7, cut_column_1_5_8, cut_column_1_5_9, cut_column_1_5_10, cut_column_1_5_11, cut_column_1_5_12, cut_column_1_5_13, cut_column_1_5_14, cut_column_1_5_15, cut_column_1_5_16                 : std_logic_vector(7 downto 0); -- First Sqaure, Fifth Column
    signal cut_column_1_6_1, cut_column_1_6_2, cut_column_1_6_3, cut_column_1_6_4, cut_column_1_6_5, cut_column_1_6_6, cut_column_1_6_7, cut_column_1_6_8, cut_column_1_6_9, cut_column_1_6_10, cut_column_1_6_11, cut_column_1_6_12, cut_column_1_6_13, cut_column_1_6_14, cut_column_1_6_15, cut_column_1_6_16                 : std_logic_vector(7 downto 0); -- First Sqaure, Sixth Column
    signal cut_column_1_7_1, cut_column_1_7_2, cut_column_1_7_3, cut_column_1_7_4, cut_column_1_7_5, cut_column_1_7_6, cut_column_1_7_7, cut_column_1_7_8, cut_column_1_7_9, cut_column_1_7_10, cut_column_1_7_11, cut_column_1_7_12, cut_column_1_7_13, cut_column_1_7_14, cut_column_1_7_15, cut_column_1_7_16                 : std_logic_vector(7 downto 0); -- First Sqaure, Seventh Column
    signal cut_column_1_8_1, cut_column_1_8_2, cut_column_1_8_3, cut_column_1_8_4, cut_column_1_8_5, cut_column_1_8_6, cut_column_1_8_7, cut_column_1_8_8, cut_column_1_8_9, cut_column_1_8_10, cut_column_1_8_11, cut_column_1_8_12, cut_column_1_8_13, cut_column_1_8_14, cut_column_1_8_15, cut_column_1_8_16                 : std_logic_vector(7 downto 0); -- First Sqaure, Eighth Column
    signal cut_column_1_9_1, cut_column_1_9_2, cut_column_1_9_3, cut_column_1_9_4, cut_column_1_9_5, cut_column_1_9_6, cut_column_1_9_7, cut_column_1_9_8, cut_column_1_9_9, cut_column_1_9_10, cut_column_1_9_11, cut_column_1_9_12, cut_column_1_9_13, cut_column_1_9_14, cut_column_1_9_15, cut_column_1_9_16                 : std_logic_vector(7 downto 0); -- First Sqaure, Ninth Column
    signal cut_column_1_10_1, cut_column_1_10_2, cut_column_1_10_3, cut_column_1_10_4, cut_column_1_10_5, cut_column_1_10_6, cut_column_1_10_7, cut_column_1_10_8, cut_column_1_10_9, cut_column_1_10_10, cut_column_1_10_11, cut_column_1_10_12, cut_column_1_10_13, cut_column_1_10_14, cut_column_1_10_15, cut_column_1_10_16 : std_logic_vector(7 downto 0); -- First Sqaure, Tenth Column
    signal cut_column_1_11_1, cut_column_1_11_2, cut_column_1_11_3, cut_column_1_11_4, cut_column_1_11_5, cut_column_1_11_6, cut_column_1_11_7, cut_column_1_11_8, cut_column_1_11_9, cut_column_1_11_10, cut_column_1_11_11, cut_column_1_11_12, cut_column_1_11_13, cut_column_1_11_14, cut_column_1_11_15, cut_column_1_11_16 : std_logic_vector(7 downto 0); -- First Sqaure, Eleventh Column
    signal cut_column_1_12_1, cut_column_1_12_2, cut_column_1_12_3, cut_column_1_12_4, cut_column_1_12_5, cut_column_1_12_6, cut_column_1_12_7, cut_column_1_12_8, cut_column_1_12_9, cut_column_1_12_10, cut_column_1_12_11, cut_column_1_12_12, cut_column_1_12_13, cut_column_1_12_14, cut_column_1_12_15, cut_column_1_12_16 : std_logic_vector(7 downto 0); -- First Sqaure, Twelfth Column
    signal cut_column_1_13_1, cut_column_1_13_2, cut_column_1_13_3, cut_column_1_13_4, cut_column_1_13_5, cut_column_1_13_6, cut_column_1_13_7, cut_column_1_13_8, cut_column_1_13_9, cut_column_1_13_10, cut_column_1_13_11, cut_column_1_13_12, cut_column_1_13_13, cut_column_1_13_14, cut_column_1_13_15, cut_column_1_13_16 : std_logic_vector(7 downto 0); -- First Sqaure, Thirteenth Column
    signal cut_column_1_14_1, cut_column_1_14_2, cut_column_1_14_3, cut_column_1_14_4, cut_column_1_14_5, cut_column_1_14_6, cut_column_1_14_7, cut_column_1_14_8, cut_column_1_14_9, cut_column_1_14_10, cut_column_1_14_11, cut_column_1_14_12, cut_column_1_14_13, cut_column_1_14_14, cut_column_1_14_15, cut_column_1_14_16 : std_logic_vector(7 downto 0); -- First Sqaure, Fourteenth Column
    signal cut_column_1_15_1, cut_column_1_15_2, cut_column_1_15_3, cut_column_1_15_4, cut_column_1_15_5, cut_column_1_15_6, cut_column_1_15_7, cut_column_1_15_8, cut_column_1_15_9, cut_column_1_15_10, cut_column_1_15_11, cut_column_1_15_12, cut_column_1_15_13, cut_column_1_15_14, cut_column_1_15_15, cut_column_1_15_16 : std_logic_vector(7 downto 0); -- First Sqaure, Fifteenth Column
    signal cut_column_1_16_1, cut_column_1_16_2, cut_column_1_16_3, cut_column_1_16_4, cut_column_1_16_5, cut_column_1_16_6, cut_column_1_16_7, cut_column_1_16_8, cut_column_1_16_9, cut_column_1_16_10, cut_column_1_16_11, cut_column_1_16_12, cut_column_1_16_13, cut_column_1_16_14, cut_column_1_16_15, cut_column_1_16_16 : std_logic_vector(7 downto 0); -- First Sqaure, Sixteenth Column

    signal cut_column_2_1_1, cut_column_2_1_2, cut_column_2_1_3, cut_column_2_1_4, cut_column_2_1_5, cut_column_2_1_6, cut_column_2_1_7, cut_column_2_1_8, cut_column_2_1_9, cut_column_2_1_10, cut_column_2_1_11, cut_column_2_1_12, cut_column_2_1_13, cut_column_2_1_14, cut_column_2_1_15, cut_column_2_1_16                 : std_logic_vector(7 downto 0); -- Second Sqaure, First Column
    signal cut_column_2_2_1, cut_column_2_2_2, cut_column_2_2_3, cut_column_2_2_4, cut_column_2_2_5, cut_column_2_2_6, cut_column_2_2_7, cut_column_2_2_8, cut_column_2_2_9, cut_column_2_2_10, cut_column_2_2_11, cut_column_2_2_12, cut_column_2_2_13, cut_column_2_2_14, cut_column_2_2_15, cut_column_2_2_16                 : std_logic_vector(7 downto 0); -- Second Sqaure, Second Column
    signal cut_column_2_3_1, cut_column_2_3_2, cut_column_2_3_3, cut_column_2_3_4, cut_column_2_3_5, cut_column_2_3_6, cut_column_2_3_7, cut_column_2_3_8, cut_column_2_3_9, cut_column_2_3_10, cut_column_2_3_11, cut_column_2_3_12, cut_column_2_3_13, cut_column_2_3_14, cut_column_2_3_15, cut_column_2_3_16                 : std_logic_vector(7 downto 0); -- Second Sqaure, Third Column
    signal cut_column_2_4_1, cut_column_2_4_2, cut_column_2_4_3, cut_column_2_4_4, cut_column_2_4_5, cut_column_2_4_6, cut_column_2_4_7, cut_column_2_4_8, cut_column_2_4_9, cut_column_2_4_10, cut_column_2_4_11, cut_column_2_4_12, cut_column_2_4_13, cut_column_2_4_14, cut_column_2_4_15, cut_column_2_4_16                 : std_logic_vector(7 downto 0); -- Second Sqaure, Fourth Column
    signal cut_column_2_5_1, cut_column_2_5_2, cut_column_2_5_3, cut_column_2_5_4, cut_column_2_5_5, cut_column_2_5_6, cut_column_2_5_7, cut_column_2_5_8, cut_column_2_5_9, cut_column_2_5_10, cut_column_2_5_11, cut_column_2_5_12, cut_column_2_5_13, cut_column_2_5_14, cut_column_2_5_15, cut_column_2_5_16                 : std_logic_vector(7 downto 0); -- Second Sqaure, Fifth Column
    signal cut_column_2_6_1, cut_column_2_6_2, cut_column_2_6_3, cut_column_2_6_4, cut_column_2_6_5, cut_column_2_6_6, cut_column_2_6_7, cut_column_2_6_8, cut_column_2_6_9, cut_column_2_6_10, cut_column_2_6_11, cut_column_2_6_12, cut_column_2_6_13, cut_column_2_6_14, cut_column_2_6_15, cut_column_2_6_16                 : std_logic_vector(7 downto 0); -- Second Sqaure, Sixth Column
    signal cut_column_2_7_1, cut_column_2_7_2, cut_column_2_7_3, cut_column_2_7_4, cut_column_2_7_5, cut_column_2_7_6, cut_column_2_7_7, cut_column_2_7_8, cut_column_2_7_9, cut_column_2_7_10, cut_column_2_7_11, cut_column_2_7_12, cut_column_2_7_13, cut_column_2_7_14, cut_column_2_7_15, cut_column_2_7_16                 : std_logic_vector(7 downto 0); -- Second Sqaure, Seventh Column
    signal cut_column_2_8_1, cut_column_2_8_2, cut_column_2_8_3, cut_column_2_8_4, cut_column_2_8_5, cut_column_2_8_6, cut_column_2_8_7, cut_column_2_8_8, cut_column_2_8_9, cut_column_2_8_10, cut_column_2_8_11, cut_column_2_8_12, cut_column_2_8_13, cut_column_2_8_14, cut_column_2_8_15, cut_column_2_8_16                 : std_logic_vector(7 downto 0); -- Second Sqaure, Eighth Column
    signal cut_column_2_9_1, cut_column_2_9_2, cut_column_2_9_3, cut_column_2_9_4, cut_column_2_9_5, cut_column_2_9_6, cut_column_2_9_7, cut_column_2_9_8, cut_column_2_9_9, cut_column_2_9_10, cut_column_2_9_11, cut_column_2_9_12, cut_column_2_9_13, cut_column_2_9_14, cut_column_2_9_15, cut_column_2_9_16                 : std_logic_vector(7 downto 0); -- Second Sqaure, Ninth Column
    signal cut_column_2_10_1, cut_column_2_10_2, cut_column_2_10_3, cut_column_2_10_4, cut_column_2_10_5, cut_column_2_10_6, cut_column_2_10_7, cut_column_2_10_8, cut_column_2_10_9, cut_column_2_10_10, cut_column_2_10_11, cut_column_2_10_12, cut_column_2_10_13, cut_column_2_10_14, cut_column_2_10_15, cut_column_2_10_16 : std_logic_vector(7 downto 0); -- Second Sqaure, Tenth Column
    signal cut_column_2_11_1, cut_column_2_11_2, cut_column_2_11_3, cut_column_2_11_4, cut_column_2_11_5, cut_column_2_11_6, cut_column_2_11_7, cut_column_2_11_8, cut_column_2_11_9, cut_column_2_11_10, cut_column_2_11_11, cut_column_2_11_12, cut_column_2_11_13, cut_column_2_11_14, cut_column_2_11_15, cut_column_2_11_16 : std_logic_vector(7 downto 0); -- Second Sqaure, Eleventh Column
    signal cut_column_2_12_1, cut_column_2_12_2, cut_column_2_12_3, cut_column_2_12_4, cut_column_2_12_5, cut_column_2_12_6, cut_column_2_12_7, cut_column_2_12_8, cut_column_2_12_9, cut_column_2_12_10, cut_column_2_12_11, cut_column_2_12_12, cut_column_2_12_13, cut_column_2_12_14, cut_column_2_12_15, cut_column_2_12_16 : std_logic_vector(7 downto 0); -- Second Sqaure, Twelfth Column
    signal cut_column_2_13_1, cut_column_2_13_2, cut_column_2_13_3, cut_column_2_13_4, cut_column_2_13_5, cut_column_2_13_6, cut_column_2_13_7, cut_column_2_13_8, cut_column_2_13_9, cut_column_2_13_10, cut_column_2_13_11, cut_column_2_13_12, cut_column_2_13_13, cut_column_2_13_14, cut_column_2_13_15, cut_column_2_13_16 : std_logic_vector(7 downto 0); -- Second Sqaure, Thirteenth Column
    signal cut_column_2_14_1, cut_column_2_14_2, cut_column_2_14_3, cut_column_2_14_4, cut_column_2_14_5, cut_column_2_14_6, cut_column_2_14_7, cut_column_2_14_8, cut_column_2_14_9, cut_column_2_14_10, cut_column_2_14_11, cut_column_2_14_12, cut_column_2_14_13, cut_column_2_14_14, cut_column_2_14_15, cut_column_2_14_16 : std_logic_vector(7 downto 0); -- Second Sqaure, Fourteenth Column
    signal cut_column_2_15_1, cut_column_2_15_2, cut_column_2_15_3, cut_column_2_15_4, cut_column_2_15_5, cut_column_2_15_6, cut_column_2_15_7, cut_column_2_15_8, cut_column_2_15_9, cut_column_2_15_10, cut_column_2_15_11, cut_column_2_15_12, cut_column_2_15_13, cut_column_2_15_14, cut_column_2_15_15, cut_column_2_15_16 : std_logic_vector(7 downto 0); -- Second Sqaure, Fifteenth Column
    signal cut_column_2_16_1, cut_column_2_16_2, cut_column_2_16_3, cut_column_2_16_4, cut_column_2_16_5, cut_column_2_16_6, cut_column_2_16_7, cut_column_2_16_8, cut_column_2_16_9, cut_column_2_16_10, cut_column_2_16_11, cut_column_2_16_12, cut_column_2_16_13, cut_column_2_16_14, cut_column_2_16_15, cut_column_2_16_16 : std_logic_vector(7 downto 0); -- Second Sqaure, Sixteenth Column
    -------------------------------------------------------------
    -- process 4   
    signal delay_input_data_channel_r1    : input_data_array(15 downto 0);
    signal delay_input_data_channel_r2    : input_data_array(15 downto 0);
    signal delay_input_data_channel_r3    : input_data_array(15 downto 0);
    signal delay_input_data_channel_r4    : input_data_array(15 downto 0);
    signal delay_input_data_channel_r5    : input_data_array(15 downto 0);
    signal delay_input_data_channel_r6    : input_data_array(15 downto 0);
    signal delay_input_data_channel_r7    : input_data_array(15 downto 0);
    signal delay_input_data_channel_r8    : input_data_array(15 downto 0);
    signal delay_input_data_channel_r9    : input_data_array(15 downto 0);
    signal delay_input_data_channel_r10   : input_data_array(15 downto 0);
    signal delay_input_data_channel_r11   : input_data_array(15 downto 0);
    signal delay_input_data_channel_r12   : input_data_array(15 downto 0);
    signal delay_input_data_channel_r13   : input_data_array(15 downto 0);
    signal delay_input_data_channel_r14   : input_data_array(15 downto 0);
    signal delay_input_data_channel_r15   : input_data_array(15 downto 0);
    signal delay_input_data_channel_r16   : input_data_array(15 downto 0);
    signal delay_1_input_data_channel_r1  : input_data_array(15 downto 0);
    signal delay_1_input_data_channel_r2  : input_data_array(15 downto 0);
    signal delay_1_input_data_channel_r3  : input_data_array(15 downto 0);
    signal delay_1_input_data_channel_r4  : input_data_array(15 downto 0);
    signal delay_1_input_data_channel_r5  : input_data_array(15 downto 0);
    signal delay_1_input_data_channel_r6  : input_data_array(15 downto 0);
    signal delay_1_input_data_channel_r7  : input_data_array(15 downto 0);
    signal delay_1_input_data_channel_r8  : input_data_array(15 downto 0);
    signal delay_1_input_data_channel_r9  : input_data_array(15 downto 0);
    signal delay_1_input_data_channel_r10 : input_data_array(15 downto 0);
    signal delay_1_input_data_channel_r11 : input_data_array(15 downto 0);
    signal delay_1_input_data_channel_r12 : input_data_array(15 downto 0);
    signal delay_1_input_data_channel_r13 : input_data_array(15 downto 0);
    signal delay_1_input_data_channel_r14 : input_data_array(15 downto 0);
    signal delay_1_input_data_channel_r15 : input_data_array(15 downto 0);
    signal delay_1_input_data_channel_r16 : input_data_array(15 downto 0);
    signal delay_2_input_data_channel_r1  : input_data_array(15 downto 0);
    signal delay_2_input_data_channel_r2  : input_data_array(15 downto 0);
    signal delay_2_input_data_channel_r3  : input_data_array(15 downto 0);
    signal delay_2_input_data_channel_r4  : input_data_array(15 downto 0);
    signal delay_2_input_data_channel_r5  : input_data_array(15 downto 0);
    signal delay_2_input_data_channel_r6  : input_data_array(15 downto 0);
    signal delay_2_input_data_channel_r7  : input_data_array(15 downto 0);
    signal delay_2_input_data_channel_r8  : input_data_array(15 downto 0);
    signal delay_2_input_data_channel_r9  : input_data_array(15 downto 0);
    signal delay_2_input_data_channel_r10 : input_data_array(15 downto 0);
    signal delay_2_input_data_channel_r11 : input_data_array(15 downto 0);
    signal delay_2_input_data_channel_r12 : input_data_array(15 downto 0);
    signal delay_2_input_data_channel_r13 : input_data_array(15 downto 0);
    signal delay_2_input_data_channel_r14 : input_data_array(15 downto 0);
    signal delay_2_input_data_channel_r15 : input_data_array(15 downto 0);
    signal delay_2_input_data_channel_r16 : input_data_array(15 downto 0);
    signal delay_3_input_data_channel_r1  : input_data_array(15 downto 0);
    signal delay_3_input_data_channel_r2  : input_data_array(15 downto 0);
    signal delay_3_input_data_channel_r3  : input_data_array(15 downto 0);
    signal delay_3_input_data_channel_r4  : input_data_array(15 downto 0);
    signal delay_3_input_data_channel_r5  : input_data_array(15 downto 0);
    signal delay_3_input_data_channel_r6  : input_data_array(15 downto 0);
    signal delay_3_input_data_channel_r7  : input_data_array(15 downto 0);
    signal delay_3_input_data_channel_r8  : input_data_array(15 downto 0);
    signal delay_3_input_data_channel_r9  : input_data_array(15 downto 0);
    signal delay_3_input_data_channel_r10 : input_data_array(15 downto 0);
    signal delay_3_input_data_channel_r11 : input_data_array(15 downto 0);
    signal delay_3_input_data_channel_r12 : input_data_array(15 downto 0);
    signal delay_3_input_data_channel_r13 : input_data_array(15 downto 0);
    signal delay_3_input_data_channel_r14 : input_data_array(15 downto 0);
    signal delay_3_input_data_channel_r15 : input_data_array(15 downto 0);
    signal delay_3_input_data_channel_r16 : input_data_array(15 downto 0);
    signal delay_4_input_data_channel_r1  : input_data_array(15 downto 0);
    signal delay_4_input_data_channel_r2  : input_data_array(15 downto 0);
    signal delay_4_input_data_channel_r3  : input_data_array(15 downto 0);
    signal delay_4_input_data_channel_r4  : input_data_array(15 downto 0);
    signal delay_4_input_data_channel_r5  : input_data_array(15 downto 0);
    signal delay_4_input_data_channel_r6  : input_data_array(15 downto 0);
    signal delay_4_input_data_channel_r7  : input_data_array(15 downto 0);
    signal delay_4_input_data_channel_r8  : input_data_array(15 downto 0);
    signal delay_4_input_data_channel_r9  : input_data_array(15 downto 0);
    signal delay_4_input_data_channel_r10 : input_data_array(15 downto 0);
    signal delay_4_input_data_channel_r11 : input_data_array(15 downto 0);
    signal delay_4_input_data_channel_r12 : input_data_array(15 downto 0);
    signal delay_4_input_data_channel_r13 : input_data_array(15 downto 0);
    signal delay_4_input_data_channel_r14 : input_data_array(15 downto 0);
    signal delay_4_input_data_channel_r15 : input_data_array(15 downto 0);
    signal delay_4_input_data_channel_r16 : input_data_array(15 downto 0);
    signal delay_5_input_data_channel_r1  : input_data_array(15 downto 0);
    signal delay_5_input_data_channel_r2  : input_data_array(15 downto 0);
    signal delay_5_input_data_channel_r3  : input_data_array(15 downto 0);
    signal delay_5_input_data_channel_r4  : input_data_array(15 downto 0);
    signal delay_5_input_data_channel_r5  : input_data_array(15 downto 0);
    signal delay_5_input_data_channel_r6  : input_data_array(15 downto 0);
    signal delay_5_input_data_channel_r7  : input_data_array(15 downto 0);
    signal delay_5_input_data_channel_r8  : input_data_array(15 downto 0);
    signal delay_5_input_data_channel_r9  : input_data_array(15 downto 0);
    signal delay_5_input_data_channel_r10 : input_data_array(15 downto 0);
    signal delay_5_input_data_channel_r11 : input_data_array(15 downto 0);
    signal delay_5_input_data_channel_r12 : input_data_array(15 downto 0);
    signal delay_5_input_data_channel_r13 : input_data_array(15 downto 0);
    signal delay_5_input_data_channel_r14 : input_data_array(15 downto 0);
    signal delay_5_input_data_channel_r15 : input_data_array(15 downto 0);
    signal delay_5_input_data_channel_r16 : input_data_array(15 downto 0);
    signal delay_6_input_data_channel_r1  : input_data_array(15 downto 0);
    signal delay_6_input_data_channel_r2  : input_data_array(15 downto 0);
    signal delay_6_input_data_channel_r3  : input_data_array(15 downto 0);
    signal delay_6_input_data_channel_r4  : input_data_array(15 downto 0);
    signal delay_6_input_data_channel_r5  : input_data_array(15 downto 0);
    signal delay_6_input_data_channel_r6  : input_data_array(15 downto 0);
    signal delay_6_input_data_channel_r7  : input_data_array(15 downto 0);
    signal delay_6_input_data_channel_r8  : input_data_array(15 downto 0);
    signal delay_6_input_data_channel_r9  : input_data_array(15 downto 0);
    signal delay_6_input_data_channel_r10 : input_data_array(15 downto 0);
    signal delay_6_input_data_channel_r11 : input_data_array(15 downto 0);
    signal delay_6_input_data_channel_r12 : input_data_array(15 downto 0);
    signal delay_6_input_data_channel_r13 : input_data_array(15 downto 0);
    signal delay_6_input_data_channel_r14 : input_data_array(15 downto 0);
    signal delay_6_input_data_channel_r15 : input_data_array(15 downto 0);
    signal delay_6_input_data_channel_r16 : input_data_array(15 downto 0);

    signal final_input_data_channel_r1  : input_data_array(127 downto 0) := (others => (others => '0'));
    signal final_input_data_channel_r2  : input_data_array(127 downto 0) := (others => (others => '0'));
    signal final_input_data_channel_r3  : input_data_array(127 downto 0) := (others => (others => '0'));
    signal final_input_data_channel_r4  : input_data_array(127 downto 0) := (others => (others => '0'));
    signal final_input_data_channel_r5  : input_data_array(127 downto 0) := (others => (others => '0'));
    signal final_input_data_channel_r6  : input_data_array(127 downto 0) := (others => (others => '0'));
    signal final_input_data_channel_r7  : input_data_array(127 downto 0) := (others => (others => '0'));
    signal final_input_data_channel_r8  : input_data_array(127 downto 0) := (others => (others => '0'));
    signal final_input_data_channel_r9  : input_data_array(127 downto 0) := (others => (others => '0'));
    signal final_input_data_channel_r10 : input_data_array(127 downto 0) := (others => (others => '0'));
    signal final_input_data_channel_r11 : input_data_array(127 downto 0) := (others => (others => '0'));
    signal final_input_data_channel_r12 : input_data_array(127 downto 0) := (others => (others => '0'));
    signal final_input_data_channel_r13 : input_data_array(127 downto 0) := (others => (others => '0'));
    signal final_input_data_channel_r14 : input_data_array(127 downto 0) := (others => (others => '0'));
    signal final_input_data_channel_r15 : input_data_array(127 downto 0) := (others => (others => '0'));
    signal final_input_data_channel_r16 : input_data_array(127 downto 0) := (others => (others => '0'));

    signal a_column_1_1  : input_data_array(15 downto 0); -- attached column 1, square 1
    signal a_column_1_2  : input_data_array(15 downto 0);
    signal a_column_1_3  : input_data_array(15 downto 0);
    signal a_column_1_4  : input_data_array(15 downto 0);
    signal a_column_1_5  : input_data_array(15 downto 0);
    signal a_column_1_6  : input_data_array(15 downto 0);
    signal a_column_1_7  : input_data_array(15 downto 0);
    signal a_column_1_8  : input_data_array(15 downto 0);
    signal a_column_1_9  : input_data_array(15 downto 0);
    signal a_column_1_10 : input_data_array(15 downto 0);
    signal a_column_1_11 : input_data_array(15 downto 0);
    signal a_column_1_12 : input_data_array(15 downto 0);
    signal a_column_1_13 : input_data_array(15 downto 0);
    signal a_column_1_14 : input_data_array(15 downto 0);
    signal a_column_1_15 : input_data_array(15 downto 0);
    signal a_column_1_16 : input_data_array(15 downto 0);
    signal a_column_2_1  : input_data_array(15 downto 0); -- attached column 1, square 2
    signal a_column_2_2  : input_data_array(15 downto 0);
    signal a_column_2_3  : input_data_array(15 downto 0);
    signal a_column_2_4  : input_data_array(15 downto 0);
    signal a_column_2_5  : input_data_array(15 downto 0);
    signal a_column_2_6  : input_data_array(15 downto 0);
    signal a_column_2_7  : input_data_array(15 downto 0);
    signal a_column_2_8  : input_data_array(15 downto 0);
    signal a_column_2_9  : input_data_array(15 downto 0);
    signal a_column_2_10 : input_data_array(15 downto 0);
    signal a_column_2_11 : input_data_array(15 downto 0);
    signal a_column_2_12 : input_data_array(15 downto 0);
    signal a_column_2_13 : input_data_array(15 downto 0);
    signal a_column_2_14 : input_data_array(15 downto 0);
    signal a_column_2_15 : input_data_array(15 downto 0);
    signal a_column_2_16 : input_data_array(15 downto 0);
    -------------------------------------------------------------
    -- process 5
    signal pass_final_input_data_channel_r1  : input_data_array(127 downto 0);
    signal pass_final_input_data_channel_r2  : input_data_array(127 downto 0);
    signal pass_final_input_data_channel_r3  : input_data_array(127 downto 0);
    signal pass_final_input_data_channel_r4  : input_data_array(127 downto 0);
    signal pass_final_input_data_channel_r5  : input_data_array(127 downto 0);
    signal pass_final_input_data_channel_r6  : input_data_array(127 downto 0);
    signal pass_final_input_data_channel_r7  : input_data_array(127 downto 0);
    signal pass_final_input_data_channel_r8  : input_data_array(127 downto 0);
    signal pass_final_input_data_channel_r9  : input_data_array(127 downto 0);
    signal pass_final_input_data_channel_r10 : input_data_array(127 downto 0);
    signal pass_final_input_data_channel_r11 : input_data_array(127 downto 0);
    signal pass_final_input_data_channel_r12 : input_data_array(127 downto 0);
    signal pass_final_input_data_channel_r13 : input_data_array(127 downto 0);
    signal pass_final_input_data_channel_r14 : input_data_array(127 downto 0);
    signal pass_final_input_data_channel_r15 : input_data_array(127 downto 0);
    signal pass_final_input_data_channel_r16 : input_data_array(127 downto 0);

    signal connected_column_1  : input_data_array(31 downto 0); -- connected square 1 and 2
    signal connected_column_2  : input_data_array(31 downto 0);
    signal connected_column_3  : input_data_array(31 downto 0);
    signal connected_column_4  : input_data_array(31 downto 0);
    signal connected_column_5  : input_data_array(31 downto 0);
    signal connected_column_6  : input_data_array(31 downto 0);
    signal connected_column_7  : input_data_array(31 downto 0);
    signal connected_column_8  : input_data_array(31 downto 0);
    signal connected_column_9  : input_data_array(31 downto 0);
    signal connected_column_10 : input_data_array(31 downto 0);
    signal connected_column_11 : input_data_array(31 downto 0);
    signal connected_column_12 : input_data_array(31 downto 0);
    signal connected_column_13 : input_data_array(31 downto 0);
    signal connected_column_14 : input_data_array(31 downto 0);
    signal connected_column_15 : input_data_array(31 downto 0);
    signal connected_column_16 : input_data_array(31 downto 0);
    -------------------------------------------------------------
    -- process 6
    signal c_column_1  : input_data_array(127 downto 0);
    signal c_column_2  : input_data_array(127 downto 0);
    signal c_column_3  : input_data_array(127 downto 0);
    signal c_column_4  : input_data_array(127 downto 0);
    signal c_column_5  : input_data_array(127 downto 0);
    signal c_column_6  : input_data_array(127 downto 0);
    signal c_column_7  : input_data_array(127 downto 0);
    signal c_column_8  : input_data_array(127 downto 0);
    signal c_column_9  : input_data_array(127 downto 0);
    signal c_column_10 : input_data_array(127 downto 0);
    signal c_column_11 : input_data_array(127 downto 0);
    signal c_column_12 : input_data_array(127 downto 0);
    signal c_column_13 : input_data_array(127 downto 0);
    signal c_column_14 : input_data_array(127 downto 0);
    signal c_column_15 : input_data_array(127 downto 0);
    signal c_column_16 : input_data_array(127 downto 0);

    signal temp_1_connected_column_1  : input_data_array(31 downto 0);
    signal temp_1_connected_column_2  : input_data_array(31 downto 0);
    signal temp_1_connected_column_3  : input_data_array(31 downto 0);
    signal temp_1_connected_column_4  : input_data_array(31 downto 0);
    signal temp_1_connected_column_5  : input_data_array(31 downto 0);
    signal temp_1_connected_column_6  : input_data_array(31 downto 0);
    signal temp_1_connected_column_7  : input_data_array(31 downto 0);
    signal temp_1_connected_column_8  : input_data_array(31 downto 0);
    signal temp_1_connected_column_9  : input_data_array(31 downto 0);
    signal temp_1_connected_column_10 : input_data_array(31 downto 0);
    signal temp_1_connected_column_11 : input_data_array(31 downto 0);
    signal temp_1_connected_column_12 : input_data_array(31 downto 0);
    signal temp_1_connected_column_13 : input_data_array(31 downto 0);
    signal temp_1_connected_column_14 : input_data_array(31 downto 0);
    signal temp_1_connected_column_15 : input_data_array(31 downto 0);
    signal temp_1_connected_column_16 : input_data_array(31 downto 0);
    signal temp_2_connected_column_1  : input_data_array(31 downto 0);
    signal temp_2_connected_column_2  : input_data_array(31 downto 0);
    signal temp_2_connected_column_3  : input_data_array(31 downto 0);
    signal temp_2_connected_column_4  : input_data_array(31 downto 0);
    signal temp_2_connected_column_5  : input_data_array(31 downto 0);
    signal temp_2_connected_column_6  : input_data_array(31 downto 0);
    signal temp_2_connected_column_7  : input_data_array(31 downto 0);
    signal temp_2_connected_column_8  : input_data_array(31 downto 0);
    signal temp_2_connected_column_9  : input_data_array(31 downto 0);
    signal temp_2_connected_column_10 : input_data_array(31 downto 0);
    signal temp_2_connected_column_11 : input_data_array(31 downto 0);
    signal temp_2_connected_column_12 : input_data_array(31 downto 0);
    signal temp_2_connected_column_13 : input_data_array(31 downto 0);
    signal temp_2_connected_column_14 : input_data_array(31 downto 0);
    signal temp_2_connected_column_15 : input_data_array(31 downto 0);
    signal temp_2_connected_column_16 : input_data_array(31 downto 0);
    signal temp_3_connected_column_1  : input_data_array(31 downto 0);
    signal temp_3_connected_column_2  : input_data_array(31 downto 0);
    signal temp_3_connected_column_3  : input_data_array(31 downto 0);
    signal temp_3_connected_column_4  : input_data_array(31 downto 0);
    signal temp_3_connected_column_5  : input_data_array(31 downto 0);
    signal temp_3_connected_column_6  : input_data_array(31 downto 0);
    signal temp_3_connected_column_7  : input_data_array(31 downto 0);
    signal temp_3_connected_column_8  : input_data_array(31 downto 0);
    signal temp_3_connected_column_9  : input_data_array(31 downto 0);
    signal temp_3_connected_column_10 : input_data_array(31 downto 0);
    signal temp_3_connected_column_11 : input_data_array(31 downto 0);
    signal temp_3_connected_column_12 : input_data_array(31 downto 0);
    signal temp_3_connected_column_13 : input_data_array(31 downto 0);
    signal temp_3_connected_column_14 : input_data_array(31 downto 0);
    signal temp_3_connected_column_15 : input_data_array(31 downto 0);
    signal temp_3_connected_column_16 : input_data_array(31 downto 0);
    --signal temp_4_connected_column_1  : input_data_array(31 downto 0);
    --signal temp_4_connected_column_2  : input_data_array(31 downto 0);
    --signal temp_4_connected_column_3  : input_data_array(31 downto 0);
    --signal temp_4_connected_column_4  : input_data_array(31 downto 0);
    --signal temp_4_connected_column_5  : input_data_array(31 downto 0);
    --signal temp_4_connected_column_6  : input_data_array(31 downto 0);
    --signal temp_4_connected_column_7  : input_data_array(31 downto 0);
    --signal temp_4_connected_column_8  : input_data_array(31 downto 0);
    --signal temp_4_connected_column_9  : input_data_array(31 downto 0);
    --signal temp_4_connected_column_10 : input_data_array(31 downto 0);
    --signal temp_4_connected_column_11 : input_data_array(31 downto 0);
    --signal temp_4_connected_column_12 : input_data_array(31 downto 0);
    --signal temp_4_connected_column_13 : input_data_array(31 downto 0);
    --signal temp_4_connected_column_14 : input_data_array(31 downto 0);
    --signal temp_4_connected_column_15 : input_data_array(31 downto 0);
    --signal temp_4_connected_column_16 : input_data_array(31 downto 0);
    signal column_1, column_2, column_3, column_4, column_5, column_6, column_7, column_8, column_9, column_10, column_11, column_12, column_13, column_14, column_15, column_16                                                                                                                                 : input_data_array(127 downto 0);
    signal delay_1_column_1, delay_1_column_2, delay_1_column_3, delay_1_column_4, delay_1_column_5, delay_1_column_6, delay_1_column_7, delay_1_column_8, delay_1_column_9, delay_1_column_10, delay_1_column_11, delay_1_column_12, delay_1_column_13, delay_1_column_14, delay_1_column_15, delay_1_column_16 : input_data_array(127 downto 0);
    signal delay_2_column_1, delay_2_column_2, delay_2_column_3, delay_2_column_4, delay_2_column_5, delay_2_column_6, delay_2_column_7, delay_2_column_8, delay_2_column_9, delay_2_column_10, delay_2_column_11, delay_2_column_12, delay_2_column_13, delay_2_column_14, delay_2_column_15, delay_2_column_16 : input_data_array(127 downto 0);
    --signal delay_3_column_1, delay_3_column_2, delay_3_column_3, delay_3_column_4, delay_3_column_5, delay_3_column_6, delay_3_column_7, delay_3_column_8, delay_3_column_9, delay_3_column_10, delay_3_column_11, delay_3_column_12, delay_3_column_13, delay_3_column_14, delay_3_column_15, delay_3_column_16 : input_data_array(127 downto 0);
    --signal delay_4_column_1, delay_4_column_2, delay_4_column_3, delay_4_column_4, delay_4_column_5, delay_4_column_6, delay_4_column_7, delay_4_column_8, delay_4_column_9, delay_4_column_10, delay_4_column_11, delay_4_column_12, delay_4_column_13, delay_4_column_14, delay_4_column_15, delay_4_column_16 : input_data_array(127 downto 0);
    -------------------------------------------------------------
    -- process 7
    signal j                            : integer := 15;
    signal i                            : integer := 0;
    signal output_codeword_data         : output_codeword_array(0 to 15);
    signal final_output_codeword_data   : output_codeword_array(0 to 15);
    signal delay_1_output_codeword_data : output_codeword_array(0 to 15);
    signal delay_2_output_codeword_data : output_codeword_array(0 to 15);
    signal delay_3_output_codeword_data : output_codeword_array(0 to 15);
    signal delay_4_output_codeword_data : output_codeword_array(0 to 15);
begin
    AND_array         <= AND_array_1 & AND_array_2;
    channel_and_array <= AND_array_4 & AND_array_3;
    -------------------------------------------------------------
    -- Process 1 : Shift data for extraction
    -------------------------------------------------------------
    process (clk, reset)
    begin
        if (reset = '1') then
            --input_data_channel_d1 <= (others => (others => '0'));
            shift_1_1_1  <= (others => '0');
            shift_1_1_2  <= (others => '0');
            shift_1_1_3  <= (others => '0');
            shift_1_1_4  <= (others => '0');
            shift_1_1_5  <= (others => '0');
            shift_1_1_6  <= (others => '0');
            shift_1_1_7  <= (others => '0');
            shift_1_1_8  <= (others => '0');
            shift_1_1_9  <= (others => '0');
            shift_1_1_10 <= (others => '0');
            shift_1_1_11 <= (others => '0');
            shift_1_1_12 <= (others => '0');
            shift_1_1_13 <= (others => '0');
            shift_1_1_14 <= (others => '0');
            shift_1_1_15 <= (others => '0');
            shift_1_1_16 <= (others => '0');
        elsif (rising_edge(clk)) then
            -- split the channel data
            s_input_data_channel_r1  <= input_data_channel;                                 -- First row
            s_input_data_channel_r2  <= input_data_channel(239 downto 0) & channel_shift_1; -- Second row
            s_input_data_channel_r3  <= input_data_channel(223 downto 0) & channel_shift_2;
            s_input_data_channel_r4  <= input_data_channel(207 downto 0) & channel_shift_3;
            s_input_data_channel_r5  <= input_data_channel(191 downto 0) & channel_shift_4;
            s_input_data_channel_r6  <= input_data_channel(175 downto 0) & channel_shift_5;
            s_input_data_channel_r7  <= input_data_channel(159 downto 0) & channel_shift_6;
            s_input_data_channel_r8  <= input_data_channel(143 downto 0) & channel_shift_7;
            s_input_data_channel_r9  <= input_data_channel(127 downto 0) & channel_shift_8;
            s_input_data_channel_r10 <= input_data_channel(111 downto 0) & channel_shift_9;
            s_input_data_channel_r11 <= input_data_channel(95 downto 0) & channel_shift_10;
            s_input_data_channel_r12 <= input_data_channel(79 downto 0) & channel_shift_11;
            s_input_data_channel_r13 <= input_data_channel(63 downto 0) & channel_shift_12;
            s_input_data_channel_r14 <= input_data_channel(47 downto 0) & channel_shift_13;
            s_input_data_channel_r15 <= input_data_channel(31 downto 0) & channel_shift_14;
            s_input_data_channel_r16 <= input_data_channel(15 downto 0) & channel_shift_15;
            -- First square, First Column
            shift_1_1_1  <= input_data_memory_1;
            shift_1_1_2  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 128));
            shift_1_1_3  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 256));
            shift_1_1_4  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 384));
            shift_1_1_5  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 512));
            shift_1_1_6  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 640));
            shift_1_1_7  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 768));
            shift_1_1_8  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 896));
            shift_1_1_9  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1024));
            shift_1_1_10 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1152));
            shift_1_1_11 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1280));
            shift_1_1_12 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1408));
            shift_1_1_13 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1536));
            shift_1_1_14 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1664));
            shift_1_1_15 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1792));
            shift_1_1_16 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1920));
            -- Second square, First Column
            shift_2_1_1  <= input_data_memory_2;
            shift_2_1_2  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 128));
            shift_2_1_3  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 256));
            shift_2_1_4  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 384));
            shift_2_1_5  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 512));
            shift_2_1_6  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 640));
            shift_2_1_7  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 768));
            shift_2_1_8  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 896));
            shift_2_1_9  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1024));
            shift_2_1_10 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1152));
            shift_2_1_11 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1280));
            shift_2_1_12 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1408));
            shift_2_1_13 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1536));
            shift_2_1_14 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1664));
            shift_2_1_15 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1792));
            shift_2_1_16 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1920));
            -- First square, Second Column
            shift_1_2_1  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 8));
            shift_1_2_2  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 136));
            shift_1_2_3  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 264));
            shift_1_2_4  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 392));
            shift_1_2_5  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 520));
            shift_1_2_6  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 648));
            shift_1_2_7  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 776));
            shift_1_2_8  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 904));
            shift_1_2_9  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1032));
            shift_1_2_10 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1160));
            shift_1_2_11 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1288));
            shift_1_2_12 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1416));
            shift_1_2_13 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1544));
            shift_1_2_14 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1672));
            shift_1_2_15 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1800));
            shift_1_2_16 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1928));
            -- Second square, Second Column
            shift_2_2_1  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 8));
            shift_2_2_2  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 136));
            shift_2_2_3  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 264));
            shift_2_2_4  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 392));
            shift_2_2_5  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 520));
            shift_2_2_6  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 648));
            shift_2_2_7  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 776));
            shift_2_2_8  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 904));
            shift_2_2_9  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1032));
            shift_2_2_10 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1160));
            shift_2_2_11 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1288));
            shift_2_2_12 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1416));
            shift_2_2_13 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1544));
            shift_2_2_14 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1672));
            shift_2_2_15 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1800));
            shift_2_2_16 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1928));
            -- First square, Third Column
            shift_1_3_1  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 16));
            shift_1_3_2  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 144));
            shift_1_3_3  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 272));
            shift_1_3_4  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 400));
            shift_1_3_5  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 528));
            shift_1_3_6  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 656));
            shift_1_3_7  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 784));
            shift_1_3_8  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 912));
            shift_1_3_9  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1040));
            shift_1_3_10 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1168));
            shift_1_3_11 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1296));
            shift_1_3_12 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1424));
            shift_1_3_13 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1552));
            shift_1_3_14 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1680));
            shift_1_3_15 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1808));
            shift_1_3_16 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1936));
            -- Second square, Third Column
            shift_2_3_1  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 16));
            shift_2_3_2  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 144));
            shift_2_3_3  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 272));
            shift_2_3_4  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 400));
            shift_2_3_5  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 528));
            shift_2_3_6  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 656));
            shift_2_3_7  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 784));
            shift_2_3_8  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 912));
            shift_2_3_9  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1040));
            shift_2_3_10 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1168));
            shift_2_3_11 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1296));
            shift_2_3_12 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1424));
            shift_2_3_13 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1552));
            shift_2_3_14 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1680));
            shift_2_3_15 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1808));
            shift_2_3_16 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1936));
            -- First square, Fourth Column
            shift_1_4_1  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 24));
            shift_1_4_2  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 152));
            shift_1_4_3  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 280));
            shift_1_4_4  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 408));
            shift_1_4_5  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 536));
            shift_1_4_6  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 664));
            shift_1_4_7  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 792));
            shift_1_4_8  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 920));
            shift_1_4_9  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1048));
            shift_1_4_10 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1176));
            shift_1_4_11 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1304));
            shift_1_4_12 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1432));
            shift_1_4_13 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1560));
            shift_1_4_14 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1688));
            shift_1_4_15 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1816));
            shift_1_4_16 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1944));
            -- Second square, Fourth Column
            shift_2_4_1  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 24));
            shift_2_4_2  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 152));
            shift_2_4_3  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 280));
            shift_2_4_4  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 408));
            shift_2_4_5  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 536));
            shift_2_4_6  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 664));
            shift_2_4_7  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 792));
            shift_2_4_8  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 920));
            shift_2_4_9  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1048));
            shift_2_4_10 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1176));
            shift_2_4_11 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1304));
            shift_2_4_12 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1432));
            shift_2_4_13 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1560));
            shift_2_4_14 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1688));
            shift_2_4_15 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1816));
            shift_2_4_16 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1944));
            -- First square, Fifth Column
            shift_1_5_1  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 32));
            shift_1_5_2  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 160));
            shift_1_5_3  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 288));
            shift_1_5_4  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 416));
            shift_1_5_5  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 544));
            shift_1_5_6  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 672));
            shift_1_5_7  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 800));
            shift_1_5_8  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 928));
            shift_1_5_9  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1056));
            shift_1_5_10 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1184));
            shift_1_5_11 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1312));
            shift_1_5_12 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1440));
            shift_1_5_13 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1568));
            shift_1_5_14 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1696));
            shift_1_5_15 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1824));
            shift_1_5_16 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1952));
            -- Second square, Fifth Column
            shift_2_5_1  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 32));
            shift_2_5_2  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 160));
            shift_2_5_3  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 288));
            shift_2_5_4  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 416));
            shift_2_5_5  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 544));
            shift_2_5_6  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 672));
            shift_2_5_7  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 800));
            shift_2_5_8  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 928));
            shift_2_5_9  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1056));
            shift_2_5_10 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1184));
            shift_2_5_11 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1312));
            shift_2_5_12 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1440));
            shift_2_5_13 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1568));
            shift_2_5_14 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1696));
            shift_2_5_15 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1824));
            shift_2_5_16 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1952));
            -- First square, Sixth Column
            shift_1_6_1  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 40));
            shift_1_6_2  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 168));
            shift_1_6_3  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 296));
            shift_1_6_4  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 424));
            shift_1_6_5  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 552));
            shift_1_6_6  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 680));
            shift_1_6_7  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 808));
            shift_1_6_8  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 936));
            shift_1_6_9  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1064));
            shift_1_6_10 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1192));
            shift_1_6_11 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1320));
            shift_1_6_12 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1448));
            shift_1_6_13 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1576));
            shift_1_6_14 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1704));
            shift_1_6_15 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1832));
            shift_1_6_16 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1960));
            -- Second square, Sixth Column
            shift_2_6_1  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 40));
            shift_2_6_2  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 168));
            shift_2_6_3  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 296));
            shift_2_6_4  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 424));
            shift_2_6_5  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 552));
            shift_2_6_6  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 680));
            shift_2_6_7  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 808));
            shift_2_6_8  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 936));
            shift_2_6_9  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1064));
            shift_2_6_10 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1192));
            shift_2_6_11 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1320));
            shift_2_6_12 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1448));
            shift_2_6_13 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1576));
            shift_2_6_14 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1704));
            shift_2_6_15 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1832));
            shift_2_6_16 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1960));
            -- First square, Seventh Column
            shift_1_7_1  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 48));
            shift_1_7_2  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 176));
            shift_1_7_3  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 304));
            shift_1_7_4  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 432));
            shift_1_7_5  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 560));
            shift_1_7_6  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 688));
            shift_1_7_7  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 816));
            shift_1_7_8  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 944));
            shift_1_7_9  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1072));
            shift_1_7_10 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1200));
            shift_1_7_11 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1328));
            shift_1_7_12 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1456));
            shift_1_7_13 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1584));
            shift_1_7_14 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1712));
            shift_1_7_15 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1840));
            shift_1_7_16 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1968));
            -- Second square, Seventh Column
            shift_2_7_1  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 48));
            shift_2_7_2  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 176));
            shift_2_7_3  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 304));
            shift_2_7_4  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 432));
            shift_2_7_5  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 560));
            shift_2_7_6  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 688));
            shift_2_7_7  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 816));
            shift_2_7_8  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 944));
            shift_2_7_9  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1072));
            shift_2_7_10 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1200));
            shift_2_7_11 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1328));
            shift_2_7_12 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1456));
            shift_2_7_13 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1584));
            shift_2_7_14 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1712));
            shift_2_7_15 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1840));
            shift_2_7_16 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1968));
            -- First square, Eighth Column
            shift_1_8_1  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 56));
            shift_1_8_2  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 184));
            shift_1_8_3  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 312));
            shift_1_8_4  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 440));
            shift_1_8_5  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 568));
            shift_1_8_6  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 696));
            shift_1_8_7  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 824));
            shift_1_8_8  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 952));
            shift_1_8_9  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1080));
            shift_1_8_10 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1208));
            shift_1_8_11 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1336));
            shift_1_8_12 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1464));
            shift_1_8_13 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1592));
            shift_1_8_14 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1720));
            shift_1_8_15 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1848));
            shift_1_8_16 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1976));
            -- Second square, Eighth Column
            shift_2_8_1  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 56));
            shift_2_8_2  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 184));
            shift_2_8_3  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 312));
            shift_2_8_4  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 440));
            shift_2_8_5  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 568));
            shift_2_8_6  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 696));
            shift_2_8_7  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 824));
            shift_2_8_8  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 952));
            shift_2_8_9  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1080));
            shift_2_8_10 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1208));
            shift_2_8_11 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1336));
            shift_2_8_12 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1464));
            shift_2_8_13 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1592));
            shift_2_8_14 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1720));
            shift_2_8_15 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1848));
            shift_2_8_16 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1976));
            -- First square, Ninth Column
            shift_1_9_1  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 64));
            shift_1_9_2  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 192));
            shift_1_9_3  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 320));
            shift_1_9_4  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 448));
            shift_1_9_5  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 576));
            shift_1_9_6  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 704));
            shift_1_9_7  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 832));
            shift_1_9_8  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 960));
            shift_1_9_9  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1088));
            shift_1_9_10 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1216));
            shift_1_9_11 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1344));
            shift_1_9_12 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1472));
            shift_1_9_13 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1600));
            shift_1_9_14 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1728));
            shift_1_9_15 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1856));
            shift_1_9_16 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1984));
            -- Second square, Ninth Column
            shift_2_9_1  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 64));
            shift_2_9_2  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 192));
            shift_2_9_3  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 320));
            shift_2_9_4  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 448));
            shift_2_9_5  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 576));
            shift_2_9_6  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 704));
            shift_2_9_7  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 832));
            shift_2_9_8  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 960));
            shift_2_9_9  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1088));
            shift_2_9_10 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1216));
            shift_2_9_11 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1344));
            shift_2_9_12 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1472));
            shift_2_9_13 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1600));
            shift_2_9_14 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1728));
            shift_2_9_15 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1856));
            shift_2_9_16 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1984));
            -- First square, Tenth Column
            shift_1_10_1  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 72));
            shift_1_10_2  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 200));
            shift_1_10_3  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 328));
            shift_1_10_4  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 456));
            shift_1_10_5  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 584));
            shift_1_10_6  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 712));
            shift_1_10_7  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 840));
            shift_1_10_8  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 968));
            shift_1_10_9  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1096));
            shift_1_10_10 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1224));
            shift_1_10_11 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1352));
            shift_1_10_12 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1480));
            shift_1_10_13 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1608));
            shift_1_10_14 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1736));
            shift_1_10_15 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1864));
            shift_1_10_16 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1992));
            -- Second square, Tenth Column
            shift_2_10_1  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 72));
            shift_2_10_2  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 200));
            shift_2_10_3  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 328));
            shift_2_10_4  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 456));
            shift_2_10_5  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 584));
            shift_2_10_6  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 712));
            shift_2_10_7  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 840));
            shift_2_10_8  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 968));
            shift_2_10_9  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1096));
            shift_2_10_10 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1224));
            shift_2_10_11 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1352));
            shift_2_10_12 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1480));
            shift_2_10_13 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1608));
            shift_2_10_14 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1736));
            shift_2_10_15 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1864));
            shift_2_10_16 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1992));
            -- First square, Eleventh Column
            shift_1_11_1  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 80));
            shift_1_11_2  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 208));
            shift_1_11_3  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 336));
            shift_1_11_4  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 464));
            shift_1_11_5  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 592));
            shift_1_11_6  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 720));
            shift_1_11_7  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 848));
            shift_1_11_8  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 976));
            shift_1_11_9  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1104));
            shift_1_11_10 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1232));
            shift_1_11_11 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1360));
            shift_1_11_12 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1488));
            shift_1_11_13 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1616));
            shift_1_11_14 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1744));
            shift_1_11_15 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1872));
            shift_1_11_16 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 2000));
            -- Second square, Eleventh Column
            shift_2_11_1  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 80));
            shift_2_11_2  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 208));
            shift_2_11_3  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 336));
            shift_2_11_4  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 464));
            shift_2_11_5  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 592));
            shift_2_11_6  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 720));
            shift_2_11_7  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 848));
            shift_2_11_8  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 976));
            shift_2_11_9  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1104));
            shift_2_11_10 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1232));
            shift_2_11_11 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1360));
            shift_2_11_12 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1488));
            shift_2_11_13 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1616));
            shift_2_11_14 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1744));
            shift_2_11_15 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1872));
            shift_2_11_16 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 2000));
            -- First square, Twelfth Column
            shift_1_12_1  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 88));
            shift_1_12_2  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 216));
            shift_1_12_3  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 344));
            shift_1_12_4  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 472));
            shift_1_12_5  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 600));
            shift_1_12_6  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 728));
            shift_1_12_7  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 856));
            shift_1_12_8  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 984));
            shift_1_12_9  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1112));
            shift_1_12_10 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1240));
            shift_1_12_11 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1368));
            shift_1_12_12 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1496));
            shift_1_12_13 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1624));
            shift_1_12_14 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1752));
            shift_1_12_15 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1880));
            shift_1_12_16 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 2008));
            -- Second square, Twelfth Column
            shift_2_12_1  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 88));
            shift_2_12_2  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 216));
            shift_2_12_3  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 344));
            shift_2_12_4  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 472));
            shift_2_12_5  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 600));
            shift_2_12_6  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 728));
            shift_2_12_7  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 856));
            shift_2_12_8  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 984));
            shift_2_12_9  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1112));
            shift_2_12_10 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1240));
            shift_2_12_11 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1368));
            shift_2_12_12 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1496));
            shift_2_12_13 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1624));
            shift_2_12_14 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1752));
            shift_2_12_15 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1880));
            shift_2_12_16 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 2008));
            -- First square, Thirteenth Column
            shift_1_13_1  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 96));
            shift_1_13_2  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 224));
            shift_1_13_3  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 352));
            shift_1_13_4  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 480));
            shift_1_13_5  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 608));
            shift_1_13_6  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 736));
            shift_1_13_7  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 864));
            shift_1_13_8  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 992));
            shift_1_13_9  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1120));
            shift_1_13_10 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1248));
            shift_1_13_11 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1376));
            shift_1_13_12 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1504));
            shift_1_13_13 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1632));
            shift_1_13_14 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1760));
            shift_1_13_15 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1888));
            shift_1_13_16 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 2016));
            -- Second square, Thirteenth Column
            shift_2_13_1  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 96));
            shift_2_13_2  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 224));
            shift_2_13_3  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 352));
            shift_2_13_4  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 480));
            shift_2_13_5  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 608));
            shift_2_13_6  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 736));
            shift_2_13_7  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 864));
            shift_2_13_8  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 992));
            shift_2_13_9  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1120));
            shift_2_13_10 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1248));
            shift_2_13_11 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1376));
            shift_2_13_12 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1504));
            shift_2_13_13 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1632));
            shift_2_13_14 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1760));
            shift_2_13_15 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1888));
            shift_2_13_16 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 2016));
            -- First square, Fourteenth Column
            shift_1_14_1  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 104));
            shift_1_14_2  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 232));
            shift_1_14_3  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 360));
            shift_1_14_4  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 488));
            shift_1_14_5  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 616));
            shift_1_14_6  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 744));
            shift_1_14_7  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 872));
            shift_1_14_8  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1000));
            shift_1_14_9  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1128));
            shift_1_14_10 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1256));
            shift_1_14_11 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1384));
            shift_1_14_12 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1512));
            shift_1_14_13 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1640));
            shift_1_14_14 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1768));
            shift_1_14_15 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1896));
            shift_1_14_16 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 2024));
            -- Second square, Fourteenth Column
            shift_2_14_1  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 104));
            shift_2_14_2  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 232));
            shift_2_14_3  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 360));
            shift_2_14_4  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 488));
            shift_2_14_5  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 616));
            shift_2_14_6  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 744));
            shift_2_14_7  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 872));
            shift_2_14_8  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1000));
            shift_2_14_9  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1128));
            shift_2_14_10 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1256));
            shift_2_14_11 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1384));
            shift_2_14_12 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1512));
            shift_2_14_13 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1640));
            shift_2_14_14 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1768));
            shift_2_14_15 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1896));
            shift_2_14_16 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 2024));
            -- First square, Fifteenth Column
            shift_1_15_1  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 112));
            shift_1_15_2  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 240));
            shift_1_15_3  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 368));
            shift_1_15_4  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 496));
            shift_1_15_5  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 624));
            shift_1_15_6  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 752));
            shift_1_15_7  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 880));
            shift_1_15_8  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1008));
            shift_1_15_9  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1136));
            shift_1_15_10 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1264));
            shift_1_15_11 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1392));
            shift_1_15_12 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1520));
            shift_1_15_13 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1648));
            shift_1_15_14 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1776));
            shift_1_15_15 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1904));
            shift_1_15_16 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 2032));
            -- Second square, Fifteenth Column
            shift_2_15_1  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 112));
            shift_2_15_2  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 240));
            shift_2_15_3  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 368));
            shift_2_15_4  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 496));
            shift_2_15_5  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 624));
            shift_2_15_6  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 752));
            shift_2_15_7  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 880));
            shift_2_15_8  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1008));
            shift_2_15_9  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1136));
            shift_2_15_10 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1264));
            shift_2_15_11 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1392));
            shift_2_15_12 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1520));
            shift_2_15_13 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1648));
            shift_2_15_14 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1776));
            shift_2_15_15 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1904));
            shift_2_15_16 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 2032));
            -- First square, Sixteenth Column
            shift_1_16_1  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 120));
            shift_1_16_2  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 248));
            shift_1_16_3  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 376));
            shift_1_16_4  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 504));
            shift_1_16_5  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 632));
            shift_1_16_6  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 760));
            shift_1_16_7  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 888));
            shift_1_16_8  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1016));
            shift_1_16_9  <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1144));
            shift_1_16_10 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1272));
            shift_1_16_11 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1400));
            shift_1_16_12 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1528));
            shift_1_16_13 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1656));
            shift_1_16_14 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1784));
            shift_1_16_15 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 1912));
            shift_1_16_16 <= std_logic_vector(shift_left(unsigned(input_data_memory_1), 2040));
            -- Second square, Sixteenth Column
            shift_2_16_1  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 120));
            shift_2_16_2  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 248));
            shift_2_16_3  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 376));
            shift_2_16_4  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 504));
            shift_2_16_5  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 632));
            shift_2_16_6  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 760));
            shift_2_16_7  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 888));
            shift_2_16_8  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1016));
            shift_2_16_9  <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1144));
            shift_2_16_10 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1272));
            shift_2_16_11 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1400));
            shift_2_16_12 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1528));
            shift_2_16_13 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1656));
            shift_2_16_14 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1784));
            shift_2_16_15 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 1912));
            shift_2_16_16 <= std_logic_vector(shift_left(unsigned(input_data_memory_2), 2040));
        end if;
    end process;
    -------------------------------------------------------------
    -- Process 2 : Fetch data by AND operation
    -------------------------------------------------------------
    process (clk, reset)
    begin
        if (reset = '1') then
            --input_data_channel_d2 <= (others => (others => '0'));
            column_1_1_1  <= (others => '0');
            column_1_1_2  <= (others => '0');
            column_1_1_3  <= (others => '0');
            column_1_1_4  <= (others => '0');
            column_1_1_5  <= (others => '0');
            column_1_1_6  <= (others => '0');
            column_1_1_7  <= (others => '0');
            column_1_1_8  <= (others => '0');
            column_1_1_9  <= (others => '0');
            column_1_1_10 <= (others => '0');
            column_1_1_11 <= (others => '0');
            column_1_1_12 <= (others => '0');
            column_1_1_13 <= (others => '0');
            column_1_1_14 <= (others => '0');
            column_1_1_15 <= (others => '0');
            column_1_1_16 <= (others => '0');
        elsif (rising_edge(clk)) then
            -- Channel data
            for i in 0 to 255 loop
                input_data_channel_r1(i)  <= s_input_data_channel_r1(i) and channel_and_array(i);
                input_data_channel_r2(i)  <= s_input_data_channel_r2(i) and channel_and_array(i);
                input_data_channel_r3(i)  <= s_input_data_channel_r3(i) and channel_and_array(i);
                input_data_channel_r4(i)  <= s_input_data_channel_r4(i) and channel_and_array(i);
                input_data_channel_r5(i)  <= s_input_data_channel_r5(i) and channel_and_array(i);
                input_data_channel_r6(i)  <= s_input_data_channel_r6(i) and channel_and_array(i);
                input_data_channel_r7(i)  <= s_input_data_channel_r7(i) and channel_and_array(i);
                input_data_channel_r8(i)  <= s_input_data_channel_r8(i) and channel_and_array(i);
                input_data_channel_r9(i)  <= s_input_data_channel_r9(i) and channel_and_array(i);
                input_data_channel_r10(i) <= s_input_data_channel_r10(i) and channel_and_array(i);
                input_data_channel_r11(i) <= s_input_data_channel_r11(i) and channel_and_array(i);
                input_data_channel_r12(i) <= s_input_data_channel_r12(i) and channel_and_array(i);
                input_data_channel_r13(i) <= s_input_data_channel_r13(i) and channel_and_array(i);
                input_data_channel_r14(i) <= s_input_data_channel_r14(i) and channel_and_array(i);
                input_data_channel_r15(i) <= s_input_data_channel_r15(i) and channel_and_array(i);
                input_data_channel_r16(i) <= s_input_data_channel_r16(i) and channel_and_array(i);
            end loop;
            -- First square, First column
            column_1_1_1  <= shift_1_1_1 and AND_array;  -- Taking the first 8 bits out as square(1,1)
            column_1_1_2  <= shift_1_1_2 and AND_array;  -- Taking the first 8 bits out as square(1,2)
            column_1_1_3  <= shift_1_1_3 and AND_array;  -- Taking the first 8 bits out as square(1,3)
            column_1_1_4  <= shift_1_1_4 and AND_array;  -- Taking the first 8 bits out as square(1,4)
            column_1_1_5  <= shift_1_1_5 and AND_array;  -- Taking the first 8 bits out as square(1,5)
            column_1_1_6  <= shift_1_1_6 and AND_array;  -- Taking the first 8 bits out as square(1,6)
            column_1_1_7  <= shift_1_1_7 and AND_array;  -- Taking the first 8 bits out as square(1,7)
            column_1_1_8  <= shift_1_1_8 and AND_array;  -- Taking the first 8 bits out as square(1,8)
            column_1_1_9  <= shift_1_1_9 and AND_array;  -- Taking the first 8 bits out as square(1,9)
            column_1_1_10 <= shift_1_1_10 and AND_array; -- Taking the first 8 bits out as square(1,10)
            column_1_1_11 <= shift_1_1_11 and AND_array; -- Taking the first 8 bits out as square(1,11)
            column_1_1_12 <= shift_1_1_12 and AND_array; -- Taking the first 8 bits out as square(1,12)
            column_1_1_13 <= shift_1_1_13 and AND_array; -- Taking the first 8 bits out as square(1,13)
            column_1_1_14 <= shift_1_1_14 and AND_array; -- Taking the first 8 bits out as square(1,14)
            column_1_1_15 <= shift_1_1_15 and AND_array; -- Taking the first 8 bits out as square(1,15)
            column_1_1_16 <= shift_1_1_16 and AND_array; -- Taking the first 8 bits out as square(1,16)
            -- First square, Second column
            column_1_2_1  <= shift_1_2_1 and AND_array;  -- Taking the first 8 bits out as square(2,1)
            column_1_2_2  <= shift_1_2_2 and AND_array;  -- Taking the first 8 bits out as square(2,2)
            column_1_2_3  <= shift_1_2_3 and AND_array;  -- Taking the first 8 bits out as square(2,3)
            column_1_2_4  <= shift_1_2_4 and AND_array;  -- Taking the first 8 bits out as square(2,4)
            column_1_2_5  <= shift_1_2_5 and AND_array;  -- Taking the first 8 bits out as square(2,5)
            column_1_2_6  <= shift_1_2_6 and AND_array;  -- Taking the first 8 bits out as square(2,6)
            column_1_2_7  <= shift_1_2_7 and AND_array;  -- Taking the first 8 bits out as square(2,7)
            column_1_2_8  <= shift_1_2_8 and AND_array;  -- Taking the first 8 bits out as square(2,8)
            column_1_2_9  <= shift_1_2_9 and AND_array;  -- Taking the first 8 bits out as square(2,9)
            column_1_2_10 <= shift_1_2_10 and AND_array; -- Taking the first 8 bits out as square(2,10)
            column_1_2_11 <= shift_1_2_11 and AND_array; -- Taking the first 8 bits out as square(2,11)
            column_1_2_12 <= shift_1_2_12 and AND_array; -- Taking the first 8 bits out as square(2,12)
            column_1_2_13 <= shift_1_2_13 and AND_array; -- Taking the first 8 bits out as square(2,13)
            column_1_2_14 <= shift_1_2_14 and AND_array; -- Taking the first 8 bits out as square(2,14)
            column_1_2_15 <= shift_1_2_15 and AND_array; -- Taking the first 8 bits out as square(2,15)
            column_1_2_16 <= shift_1_2_16 and AND_array; -- Taking the first 8 bits out as square(2,16)
            -- First square, Third column
            column_1_3_1  <= shift_1_3_1 and AND_array;
            column_1_3_2  <= shift_1_3_2 and AND_array;
            column_1_3_3  <= shift_1_3_3 and AND_array;
            column_1_3_4  <= shift_1_3_4 and AND_array;
            column_1_3_5  <= shift_1_3_5 and AND_array;
            column_1_3_6  <= shift_1_3_6 and AND_array;
            column_1_3_7  <= shift_1_3_7 and AND_array;
            column_1_3_8  <= shift_1_3_8 and AND_array;
            column_1_3_9  <= shift_1_3_9 and AND_array;
            column_1_3_10 <= shift_1_3_10 and AND_array;
            column_1_3_11 <= shift_1_3_11 and AND_array;
            column_1_3_12 <= shift_1_3_12 and AND_array;
            column_1_3_13 <= shift_1_3_13 and AND_array;
            column_1_3_14 <= shift_1_3_14 and AND_array;
            column_1_3_15 <= shift_1_3_15 and AND_array;
            column_1_3_16 <= shift_1_3_16 and AND_array;
            -- First square, Fourth column
            column_1_4_1  <= shift_1_4_1 and AND_array;
            column_1_4_2  <= shift_1_4_2 and AND_array;
            column_1_4_3  <= shift_1_4_3 and AND_array;
            column_1_4_4  <= shift_1_4_4 and AND_array;
            column_1_4_5  <= shift_1_4_5 and AND_array;
            column_1_4_6  <= shift_1_4_6 and AND_array;
            column_1_4_7  <= shift_1_4_7 and AND_array;
            column_1_4_8  <= shift_1_4_8 and AND_array;
            column_1_4_9  <= shift_1_4_9 and AND_array;
            column_1_4_10 <= shift_1_4_10 and AND_array;
            column_1_4_11 <= shift_1_4_11 and AND_array;
            column_1_4_12 <= shift_1_4_12 and AND_array;
            column_1_4_13 <= shift_1_4_13 and AND_array;
            column_1_4_14 <= shift_1_4_14 and AND_array;
            column_1_4_15 <= shift_1_4_15 and AND_array;
            column_1_4_16 <= shift_1_4_16 and AND_array;
            -- First square, Fifth column
            column_1_5_1  <= shift_1_5_1 and AND_array;
            column_1_5_2  <= shift_1_5_2 and AND_array;
            column_1_5_3  <= shift_1_5_3 and AND_array;
            column_1_5_4  <= shift_1_5_4 and AND_array;
            column_1_5_5  <= shift_1_5_5 and AND_array;
            column_1_5_6  <= shift_1_5_6 and AND_array;
            column_1_5_7  <= shift_1_5_7 and AND_array;
            column_1_5_8  <= shift_1_5_8 and AND_array;
            column_1_5_9  <= shift_1_5_9 and AND_array;
            column_1_5_10 <= shift_1_5_10 and AND_array;
            column_1_5_11 <= shift_1_5_11 and AND_array;
            column_1_5_12 <= shift_1_5_12 and AND_array;
            column_1_5_13 <= shift_1_5_13 and AND_array;
            column_1_5_14 <= shift_1_5_14 and AND_array;
            column_1_5_15 <= shift_1_5_15 and AND_array;
            column_1_5_16 <= shift_1_5_16 and AND_array;
            -- First square, Sixth column
            column_1_6_1  <= shift_1_6_1 and AND_array;
            column_1_6_2  <= shift_1_6_2 and AND_array;
            column_1_6_3  <= shift_1_6_3 and AND_array;
            column_1_6_4  <= shift_1_6_4 and AND_array;
            column_1_6_5  <= shift_1_6_5 and AND_array;
            column_1_6_6  <= shift_1_6_6 and AND_array;
            column_1_6_7  <= shift_1_6_7 and AND_array;
            column_1_6_8  <= shift_1_6_8 and AND_array;
            column_1_6_9  <= shift_1_6_9 and AND_array;
            column_1_6_10 <= shift_1_6_10 and AND_array;
            column_1_6_11 <= shift_1_6_11 and AND_array;
            column_1_6_12 <= shift_1_6_12 and AND_array;
            column_1_6_13 <= shift_1_6_13 and AND_array;
            column_1_6_14 <= shift_1_6_14 and AND_array;
            column_1_6_15 <= shift_1_6_15 and AND_array;
            column_1_6_16 <= shift_1_6_16 and AND_array;
            -- First square, Seventh column
            column_1_7_1  <= shift_1_7_1 and AND_array;
            column_1_7_2  <= shift_1_7_2 and AND_array;
            column_1_7_3  <= shift_1_7_3 and AND_array;
            column_1_7_4  <= shift_1_7_4 and AND_array;
            column_1_7_5  <= shift_1_7_5 and AND_array;
            column_1_7_6  <= shift_1_7_6 and AND_array;
            column_1_7_7  <= shift_1_7_7 and AND_array;
            column_1_7_8  <= shift_1_7_8 and AND_array;
            column_1_7_9  <= shift_1_7_9 and AND_array;
            column_1_7_10 <= shift_1_7_10 and AND_array;
            column_1_7_11 <= shift_1_7_11 and AND_array;
            column_1_7_12 <= shift_1_7_12 and AND_array;
            column_1_7_13 <= shift_1_7_13 and AND_array;
            column_1_7_14 <= shift_1_7_14 and AND_array;
            column_1_7_15 <= shift_1_7_15 and AND_array;
            column_1_7_16 <= shift_1_7_16 and AND_array;
            -- First square, Eighth column
            column_1_8_1  <= shift_1_8_1 and AND_array;
            column_1_8_2  <= shift_1_8_2 and AND_array;
            column_1_8_3  <= shift_1_8_3 and AND_array;
            column_1_8_4  <= shift_1_8_4 and AND_array;
            column_1_8_5  <= shift_1_8_5 and AND_array;
            column_1_8_6  <= shift_1_8_6 and AND_array;
            column_1_8_7  <= shift_1_8_7 and AND_array;
            column_1_8_8  <= shift_1_8_8 and AND_array;
            column_1_8_9  <= shift_1_8_9 and AND_array;
            column_1_8_10 <= shift_1_8_10 and AND_array;
            column_1_8_11 <= shift_1_8_11 and AND_array;
            column_1_8_12 <= shift_1_8_12 and AND_array;
            column_1_8_13 <= shift_1_8_13 and AND_array;
            column_1_8_14 <= shift_1_8_14 and AND_array;
            column_1_8_15 <= shift_1_8_15 and AND_array;
            column_1_8_16 <= shift_1_8_16 and AND_array;
            -- First square, Ninth column
            column_1_9_1  <= shift_1_9_1 and AND_array;
            column_1_9_2  <= shift_1_9_2 and AND_array;
            column_1_9_3  <= shift_1_9_3 and AND_array;
            column_1_9_4  <= shift_1_9_4 and AND_array;
            column_1_9_5  <= shift_1_9_5 and AND_array;
            column_1_9_6  <= shift_1_9_6 and AND_array;
            column_1_9_7  <= shift_1_9_7 and AND_array;
            column_1_9_8  <= shift_1_9_8 and AND_array;
            column_1_9_9  <= shift_1_9_9 and AND_array;
            column_1_9_10 <= shift_1_9_10 and AND_array;
            column_1_9_11 <= shift_1_9_11 and AND_array;
            column_1_9_12 <= shift_1_9_12 and AND_array;
            column_1_9_13 <= shift_1_9_13 and AND_array;
            column_1_9_14 <= shift_1_9_14 and AND_array;
            column_1_9_15 <= shift_1_9_15 and AND_array;
            column_1_9_16 <= shift_1_9_16 and AND_array;
            -- First square, Tenth column
            column_1_10_1  <= shift_1_10_1 and AND_array;
            column_1_10_2  <= shift_1_10_2 and AND_array;
            column_1_10_3  <= shift_1_10_3 and AND_array;
            column_1_10_4  <= shift_1_10_4 and AND_array;
            column_1_10_5  <= shift_1_10_5 and AND_array;
            column_1_10_6  <= shift_1_10_6 and AND_array;
            column_1_10_7  <= shift_1_10_7 and AND_array;
            column_1_10_8  <= shift_1_10_8 and AND_array;
            column_1_10_9  <= shift_1_10_9 and AND_array;
            column_1_10_10 <= shift_1_10_10 and AND_array;
            column_1_10_11 <= shift_1_10_11 and AND_array;
            column_1_10_12 <= shift_1_10_12 and AND_array;
            column_1_10_13 <= shift_1_10_13 and AND_array;
            column_1_10_14 <= shift_1_10_14 and AND_array;
            column_1_10_15 <= shift_1_10_15 and AND_array;
            column_1_10_16 <= shift_1_10_16 and AND_array;
            -- First square, Eleventh column
            column_1_11_1  <= shift_1_11_1 and AND_array;
            column_1_11_2  <= shift_1_11_2 and AND_array;
            column_1_11_3  <= shift_1_11_3 and AND_array;
            column_1_11_4  <= shift_1_11_4 and AND_array;
            column_1_11_5  <= shift_1_11_5 and AND_array;
            column_1_11_6  <= shift_1_11_6 and AND_array;
            column_1_11_7  <= shift_1_11_7 and AND_array;
            column_1_11_8  <= shift_1_11_8 and AND_array;
            column_1_11_9  <= shift_1_11_9 and AND_array;
            column_1_11_10 <= shift_1_11_10 and AND_array;
            column_1_11_11 <= shift_1_11_11 and AND_array;
            column_1_11_12 <= shift_1_11_12 and AND_array;
            column_1_11_13 <= shift_1_11_13 and AND_array;
            column_1_11_14 <= shift_1_11_14 and AND_array;
            column_1_11_15 <= shift_1_11_15 and AND_array;
            column_1_11_16 <= shift_1_11_16 and AND_array;
            -- First square, Twelfth column
            column_1_12_1  <= shift_1_12_1 and AND_array;
            column_1_12_2  <= shift_1_12_2 and AND_array;
            column_1_12_3  <= shift_1_12_3 and AND_array;
            column_1_12_4  <= shift_1_12_4 and AND_array;
            column_1_12_5  <= shift_1_12_5 and AND_array;
            column_1_12_6  <= shift_1_12_6 and AND_array;
            column_1_12_7  <= shift_1_12_7 and AND_array;
            column_1_12_8  <= shift_1_12_8 and AND_array;
            column_1_12_9  <= shift_1_12_9 and AND_array;
            column_1_12_10 <= shift_1_12_10 and AND_array;
            column_1_12_11 <= shift_1_12_11 and AND_array;
            column_1_12_12 <= shift_1_12_12 and AND_array;
            column_1_12_13 <= shift_1_12_13 and AND_array;
            column_1_12_14 <= shift_1_12_14 and AND_array;
            column_1_12_15 <= shift_1_12_15 and AND_array;
            column_1_12_16 <= shift_1_12_16 and AND_array;
            -- First square, Thirteenth column
            column_1_13_1  <= shift_1_13_1 and AND_array;
            column_1_13_2  <= shift_1_13_2 and AND_array;
            column_1_13_3  <= shift_1_13_3 and AND_array;
            column_1_13_4  <= shift_1_13_4 and AND_array;
            column_1_13_5  <= shift_1_13_5 and AND_array;
            column_1_13_6  <= shift_1_13_6 and AND_array;
            column_1_13_7  <= shift_1_13_7 and AND_array;
            column_1_13_8  <= shift_1_13_8 and AND_array;
            column_1_13_9  <= shift_1_13_9 and AND_array;
            column_1_13_10 <= shift_1_13_10 and AND_array;
            column_1_13_11 <= shift_1_13_11 and AND_array;
            column_1_13_12 <= shift_1_13_12 and AND_array;
            column_1_13_13 <= shift_1_13_13 and AND_array;
            column_1_13_14 <= shift_1_13_14 and AND_array;
            column_1_13_15 <= shift_1_13_15 and AND_array;
            column_1_13_16 <= shift_1_13_16 and AND_array;
            -- First square, Fourteenth column
            column_1_14_1  <= shift_1_14_1 and AND_array;
            column_1_14_2  <= shift_1_14_2 and AND_array;
            column_1_14_3  <= shift_1_14_3 and AND_array;
            column_1_14_4  <= shift_1_14_4 and AND_array;
            column_1_14_5  <= shift_1_14_5 and AND_array;
            column_1_14_6  <= shift_1_14_6 and AND_array;
            column_1_14_7  <= shift_1_14_7 and AND_array;
            column_1_14_8  <= shift_1_14_8 and AND_array;
            column_1_14_9  <= shift_1_14_9 and AND_array;
            column_1_14_10 <= shift_1_14_10 and AND_array;
            column_1_14_11 <= shift_1_14_11 and AND_array;
            column_1_14_12 <= shift_1_14_12 and AND_array;
            column_1_14_13 <= shift_1_14_13 and AND_array;
            column_1_14_14 <= shift_1_14_14 and AND_array;
            column_1_14_15 <= shift_1_14_15 and AND_array;
            column_1_14_16 <= shift_1_14_16 and AND_array;
            -- First square, Fifteenth column
            column_1_15_1  <= shift_1_15_1 and AND_array;
            column_1_15_2  <= shift_1_15_2 and AND_array;
            column_1_15_3  <= shift_1_15_3 and AND_array;
            column_1_15_4  <= shift_1_15_4 and AND_array;
            column_1_15_5  <= shift_1_15_5 and AND_array;
            column_1_15_6  <= shift_1_15_6 and AND_array;
            column_1_15_7  <= shift_1_15_7 and AND_array;
            column_1_15_8  <= shift_1_15_8 and AND_array;
            column_1_15_9  <= shift_1_15_9 and AND_array;
            column_1_15_10 <= shift_1_15_10 and AND_array;
            column_1_15_11 <= shift_1_15_11 and AND_array;
            column_1_15_12 <= shift_1_15_12 and AND_array;
            column_1_15_13 <= shift_1_15_13 and AND_array;
            column_1_15_14 <= shift_1_15_14 and AND_array;
            column_1_15_15 <= shift_1_15_15 and AND_array;
            column_1_15_16 <= shift_1_15_16 and AND_array;
            -- First square, Sixteen column
            column_1_16_1  <= shift_1_16_1 and AND_array;
            column_1_16_2  <= shift_1_16_2 and AND_array;
            column_1_16_3  <= shift_1_16_3 and AND_array;
            column_1_16_4  <= shift_1_16_4 and AND_array;
            column_1_16_5  <= shift_1_16_5 and AND_array;
            column_1_16_6  <= shift_1_16_6 and AND_array;
            column_1_16_7  <= shift_1_16_7 and AND_array;
            column_1_16_8  <= shift_1_16_8 and AND_array;
            column_1_16_9  <= shift_1_16_9 and AND_array;
            column_1_16_10 <= shift_1_16_10 and AND_array;
            column_1_16_11 <= shift_1_16_11 and AND_array;
            column_1_16_12 <= shift_1_16_12 and AND_array;
            column_1_16_13 <= shift_1_16_13 and AND_array;
            column_1_16_14 <= shift_1_16_14 and AND_array;
            column_1_16_15 <= shift_1_16_15 and AND_array;
            column_1_16_16 <= shift_1_16_16 and AND_array;
            -- Second square
            column_2_1_1   <= shift_2_1_1 and AND_array;  -- Taking the first 8 bits out as square(1,1)
            column_2_1_2   <= shift_2_1_2 and AND_array;  -- Taking the first 8 bits out as square(1,2)
            column_2_1_3   <= shift_2_1_3 and AND_array;  -- Taking the first 8 bits out as square(1,3)
            column_2_1_4   <= shift_2_1_4 and AND_array;  -- Taking the first 8 bits out as square(1,4)
            column_2_1_5   <= shift_2_1_5 and AND_array;  -- Taking the first 8 bits out as square(1,5)
            column_2_1_6   <= shift_2_1_6 and AND_array;  -- Taking the first 8 bits out as square(1,6)
            column_2_1_7   <= shift_2_1_7 and AND_array;  -- Taking the first 8 bits out as square(1,7)
            column_2_1_8   <= shift_2_1_8 and AND_array;  -- Taking the first 8 bits out as square(1,8)
            column_2_1_9   <= shift_2_1_9 and AND_array;  -- Taking the first 8 bits out as square(1,9)
            column_2_1_10  <= shift_2_1_10 and AND_array; -- Taking the first 8 bits out as square(1,10)
            column_2_1_11  <= shift_2_1_11 and AND_array; -- Taking the first 8 bits out as square(1,11)
            column_2_1_12  <= shift_2_1_12 and AND_array; -- Taking the first 8 bits out as square(1,12)
            column_2_1_13  <= shift_2_1_13 and AND_array; -- Taking the first 8 bits out as square(1,13)
            column_2_1_14  <= shift_2_1_14 and AND_array; -- Taking the first 8 bits out as square(1,14)
            column_2_1_15  <= shift_2_1_15 and AND_array; -- Taking the first 8 bits out as square(1,15)
            column_2_1_16  <= shift_2_1_16 and AND_array; -- Taking the first 8 bits out as square(1,16)
            column_2_2_1   <= shift_2_2_1 and AND_array;
            column_2_2_2   <= shift_2_2_2 and AND_array;
            column_2_2_3   <= shift_2_2_3 and AND_array;
            column_2_2_4   <= shift_2_2_4 and AND_array;
            column_2_2_5   <= shift_2_2_5 and AND_array;
            column_2_2_6   <= shift_2_2_6 and AND_array;
            column_2_2_7   <= shift_2_2_7 and AND_array;
            column_2_2_8   <= shift_2_2_8 and AND_array;
            column_2_2_9   <= shift_2_2_9 and AND_array;
            column_2_2_10  <= shift_2_2_10 and AND_array;
            column_2_2_11  <= shift_2_2_11 and AND_array;
            column_2_2_12  <= shift_2_2_12 and AND_array;
            column_2_2_13  <= shift_2_2_13 and AND_array;
            column_2_2_14  <= shift_2_2_14 and AND_array;
            column_2_2_15  <= shift_2_2_15 and AND_array;
            column_2_2_16  <= shift_2_2_16 and AND_array;
            column_2_3_1   <= shift_2_3_1 and AND_array;
            column_2_3_2   <= shift_2_3_2 and AND_array;
            column_2_3_3   <= shift_2_3_3 and AND_array;
            column_2_3_4   <= shift_2_3_4 and AND_array;
            column_2_3_5   <= shift_2_3_5 and AND_array;
            column_2_3_6   <= shift_2_3_6 and AND_array;
            column_2_3_7   <= shift_2_3_7 and AND_array;
            column_2_3_8   <= shift_2_3_8 and AND_array;
            column_2_3_9   <= shift_2_3_9 and AND_array;
            column_2_3_10  <= shift_2_3_10 and AND_array;
            column_2_3_11  <= shift_2_3_11 and AND_array;
            column_2_3_12  <= shift_2_3_12 and AND_array;
            column_2_3_13  <= shift_2_3_13 and AND_array;
            column_2_3_14  <= shift_2_3_14 and AND_array;
            column_2_3_15  <= shift_2_3_15 and AND_array;
            column_2_3_16  <= shift_2_3_16 and AND_array;
            column_2_4_1   <= shift_2_4_1 and AND_array;
            column_2_4_2   <= shift_2_4_2 and AND_array;
            column_2_4_3   <= shift_2_4_3 and AND_array;
            column_2_4_4   <= shift_2_4_4 and AND_array;
            column_2_4_5   <= shift_2_4_5 and AND_array;
            column_2_4_6   <= shift_2_4_6 and AND_array;
            column_2_4_7   <= shift_2_4_7 and AND_array;
            column_2_4_8   <= shift_2_4_8 and AND_array;
            column_2_4_9   <= shift_2_4_9 and AND_array;
            column_2_4_10  <= shift_2_4_10 and AND_array;
            column_2_4_11  <= shift_2_4_11 and AND_array;
            column_2_4_12  <= shift_2_4_12 and AND_array;
            column_2_4_13  <= shift_2_4_13 and AND_array;
            column_2_4_14  <= shift_2_4_14 and AND_array;
            column_2_4_15  <= shift_2_4_15 and AND_array;
            column_2_4_16  <= shift_2_4_16 and AND_array;
            column_2_5_1   <= shift_2_5_1 and AND_array;
            column_2_5_2   <= shift_2_5_2 and AND_array;
            column_2_5_3   <= shift_2_5_3 and AND_array;
            column_2_5_4   <= shift_2_5_4 and AND_array;
            column_2_5_5   <= shift_2_5_5 and AND_array;
            column_2_5_6   <= shift_2_5_6 and AND_array;
            column_2_5_7   <= shift_2_5_7 and AND_array;
            column_2_5_8   <= shift_2_5_8 and AND_array;
            column_2_5_9   <= shift_2_5_9 and AND_array;
            column_2_5_10  <= shift_2_5_10 and AND_array;
            column_2_5_11  <= shift_2_5_11 and AND_array;
            column_2_5_12  <= shift_2_5_12 and AND_array;
            column_2_5_13  <= shift_2_5_13 and AND_array;
            column_2_5_14  <= shift_2_5_14 and AND_array;
            column_2_5_15  <= shift_2_5_15 and AND_array;
            column_2_5_16  <= shift_2_5_16 and AND_array;
            column_2_6_1   <= shift_2_6_1 and AND_array;
            column_2_6_2   <= shift_2_6_2 and AND_array;
            column_2_6_3   <= shift_2_6_3 and AND_array;
            column_2_6_4   <= shift_2_6_4 and AND_array;
            column_2_6_5   <= shift_2_6_5 and AND_array;
            column_2_6_6   <= shift_2_6_6 and AND_array;
            column_2_6_7   <= shift_2_6_7 and AND_array;
            column_2_6_8   <= shift_2_6_8 and AND_array;
            column_2_6_9   <= shift_2_6_9 and AND_array;
            column_2_6_10  <= shift_2_6_10 and AND_array;
            column_2_6_11  <= shift_2_6_11 and AND_array;
            column_2_6_12  <= shift_2_6_12 and AND_array;
            column_2_6_13  <= shift_2_6_13 and AND_array;
            column_2_6_14  <= shift_2_6_14 and AND_array;
            column_2_6_15  <= shift_2_6_15 and AND_array;
            column_2_6_16  <= shift_2_6_16 and AND_array;
            column_2_7_1   <= shift_2_7_1 and AND_array;
            column_2_7_2   <= shift_2_7_2 and AND_array;
            column_2_7_3   <= shift_2_7_3 and AND_array;
            column_2_7_4   <= shift_2_7_4 and AND_array;
            column_2_7_5   <= shift_2_7_5 and AND_array;
            column_2_7_6   <= shift_2_7_6 and AND_array;
            column_2_7_7   <= shift_2_7_7 and AND_array;
            column_2_7_8   <= shift_2_7_8 and AND_array;
            column_2_7_9   <= shift_2_7_9 and AND_array;
            column_2_7_10  <= shift_2_7_10 and AND_array;
            column_2_7_11  <= shift_2_7_11 and AND_array;
            column_2_7_12  <= shift_2_7_12 and AND_array;
            column_2_7_13  <= shift_2_7_13 and AND_array;
            column_2_7_14  <= shift_2_7_14 and AND_array;
            column_2_7_15  <= shift_2_7_15 and AND_array;
            column_2_7_16  <= shift_2_7_16 and AND_array;
            column_2_8_1   <= shift_2_8_1 and AND_array;
            column_2_8_2   <= shift_2_8_2 and AND_array;
            column_2_8_3   <= shift_2_8_3 and AND_array;
            column_2_8_4   <= shift_2_8_4 and AND_array;
            column_2_8_5   <= shift_2_8_5 and AND_array;
            column_2_8_6   <= shift_2_8_6 and AND_array;
            column_2_8_7   <= shift_2_8_7 and AND_array;
            column_2_8_8   <= shift_2_8_8 and AND_array;
            column_2_8_9   <= shift_2_8_9 and AND_array;
            column_2_8_10  <= shift_2_8_10 and AND_array;
            column_2_8_11  <= shift_2_8_11 and AND_array;
            column_2_8_12  <= shift_2_8_12 and AND_array;
            column_2_8_13  <= shift_2_8_13 and AND_array;
            column_2_8_14  <= shift_2_8_14 and AND_array;
            column_2_8_15  <= shift_2_8_15 and AND_array;
            column_2_8_16  <= shift_2_8_16 and AND_array;
            column_2_9_1   <= shift_2_9_1 and AND_array;
            column_2_9_2   <= shift_2_9_2 and AND_array;
            column_2_9_3   <= shift_2_9_3 and AND_array;
            column_2_9_4   <= shift_2_9_4 and AND_array;
            column_2_9_5   <= shift_2_9_5 and AND_array;
            column_2_9_6   <= shift_2_9_6 and AND_array;
            column_2_9_7   <= shift_2_9_7 and AND_array;
            column_2_9_8   <= shift_2_9_8 and AND_array;
            column_2_9_9   <= shift_2_9_9 and AND_array;
            column_2_9_10  <= shift_2_9_10 and AND_array;
            column_2_9_11  <= shift_2_9_11 and AND_array;
            column_2_9_12  <= shift_2_9_12 and AND_array;
            column_2_9_13  <= shift_2_9_13 and AND_array;
            column_2_9_14  <= shift_2_9_14 and AND_array;
            column_2_9_15  <= shift_2_9_15 and AND_array;
            column_2_9_16  <= shift_2_9_16 and AND_array;
            column_2_10_1  <= shift_2_10_1 and AND_array;
            column_2_10_2  <= shift_2_10_2 and AND_array;
            column_2_10_3  <= shift_2_10_3 and AND_array;
            column_2_10_4  <= shift_2_10_4 and AND_array;
            column_2_10_5  <= shift_2_10_5 and AND_array;
            column_2_10_6  <= shift_2_10_6 and AND_array;
            column_2_10_7  <= shift_2_10_7 and AND_array;
            column_2_10_8  <= shift_2_10_8 and AND_array;
            column_2_10_9  <= shift_2_10_9 and AND_array;
            column_2_10_10 <= shift_2_10_10 and AND_array;
            column_2_10_11 <= shift_2_10_11 and AND_array;
            column_2_10_12 <= shift_2_10_12 and AND_array;
            column_2_10_13 <= shift_2_10_13 and AND_array;
            column_2_10_14 <= shift_2_10_14 and AND_array;
            column_2_10_15 <= shift_2_10_15 and AND_array;
            column_2_10_16 <= shift_2_10_16 and AND_array;
            column_2_11_1  <= shift_2_11_1 and AND_array;
            column_2_11_2  <= shift_2_11_2 and AND_array;
            column_2_11_3  <= shift_2_11_3 and AND_array;
            column_2_11_4  <= shift_2_11_4 and AND_array;
            column_2_11_5  <= shift_2_11_5 and AND_array;
            column_2_11_6  <= shift_2_11_6 and AND_array;
            column_2_11_7  <= shift_2_11_7 and AND_array;
            column_2_11_8  <= shift_2_11_8 and AND_array;
            column_2_11_9  <= shift_2_11_9 and AND_array;
            column_2_11_10 <= shift_2_11_10 and AND_array;
            column_2_11_11 <= shift_2_11_11 and AND_array;
            column_2_11_12 <= shift_2_11_12 and AND_array;
            column_2_11_13 <= shift_2_11_13 and AND_array;
            column_2_11_14 <= shift_2_11_14 and AND_array;
            column_2_11_15 <= shift_2_11_15 and AND_array;
            column_2_11_16 <= shift_2_11_16 and AND_array;
            column_2_12_1  <= shift_2_12_1 and AND_array;
            column_2_12_2  <= shift_2_12_2 and AND_array;
            column_2_12_3  <= shift_2_12_3 and AND_array;
            column_2_12_4  <= shift_2_12_4 and AND_array;
            column_2_12_5  <= shift_2_12_5 and AND_array;
            column_2_12_6  <= shift_2_12_6 and AND_array;
            column_2_12_7  <= shift_2_12_7 and AND_array;
            column_2_12_8  <= shift_2_12_8 and AND_array;
            column_2_12_9  <= shift_2_12_9 and AND_array;
            column_2_12_10 <= shift_2_12_10 and AND_array;
            column_2_12_11 <= shift_2_12_11 and AND_array;
            column_2_12_12 <= shift_2_12_12 and AND_array;
            column_2_12_13 <= shift_2_12_13 and AND_array;
            column_2_12_14 <= shift_2_12_14 and AND_array;
            column_2_12_15 <= shift_2_12_15 and AND_array;
            column_2_12_16 <= shift_2_12_16 and AND_array;
            column_2_13_1  <= shift_2_13_1 and AND_array;
            column_2_13_2  <= shift_2_13_2 and AND_array;
            column_2_13_3  <= shift_2_13_3 and AND_array;
            column_2_13_4  <= shift_2_13_4 and AND_array;
            column_2_13_5  <= shift_2_13_5 and AND_array;
            column_2_13_6  <= shift_2_13_6 and AND_array;
            column_2_13_7  <= shift_2_13_7 and AND_array;
            column_2_13_8  <= shift_2_13_8 and AND_array;
            column_2_13_9  <= shift_2_13_9 and AND_array;
            column_2_13_10 <= shift_2_13_10 and AND_array;
            column_2_13_11 <= shift_2_13_11 and AND_array;
            column_2_13_12 <= shift_2_13_12 and AND_array;
            column_2_13_13 <= shift_2_13_13 and AND_array;
            column_2_13_14 <= shift_2_13_14 and AND_array;
            column_2_13_15 <= shift_2_13_15 and AND_array;
            column_2_13_16 <= shift_2_13_16 and AND_array;
            column_2_14_1  <= shift_2_14_1 and AND_array;
            column_2_14_2  <= shift_2_14_2 and AND_array;
            column_2_14_3  <= shift_2_14_3 and AND_array;
            column_2_14_4  <= shift_2_14_4 and AND_array;
            column_2_14_5  <= shift_2_14_5 and AND_array;
            column_2_14_6  <= shift_2_14_6 and AND_array;
            column_2_14_7  <= shift_2_14_7 and AND_array;
            column_2_14_8  <= shift_2_14_8 and AND_array;
            column_2_14_9  <= shift_2_14_9 and AND_array;
            column_2_14_10 <= shift_2_14_10 and AND_array;
            column_2_14_11 <= shift_2_14_11 and AND_array;
            column_2_14_12 <= shift_2_14_12 and AND_array;
            column_2_14_13 <= shift_2_14_13 and AND_array;
            column_2_14_14 <= shift_2_14_14 and AND_array;
            column_2_14_15 <= shift_2_14_15 and AND_array;
            column_2_14_16 <= shift_2_14_16 and AND_array;
            column_2_15_1  <= shift_2_15_1 and AND_array;
            column_2_15_2  <= shift_2_15_2 and AND_array;
            column_2_15_3  <= shift_2_15_3 and AND_array;
            column_2_15_4  <= shift_2_15_4 and AND_array;
            column_2_15_5  <= shift_2_15_5 and AND_array;
            column_2_15_6  <= shift_2_15_6 and AND_array;
            column_2_15_7  <= shift_2_15_7 and AND_array;
            column_2_15_8  <= shift_2_15_8 and AND_array;
            column_2_15_9  <= shift_2_15_9 and AND_array;
            column_2_15_10 <= shift_2_15_10 and AND_array;
            column_2_15_11 <= shift_2_15_11 and AND_array;
            column_2_15_12 <= shift_2_15_12 and AND_array;
            column_2_15_13 <= shift_2_15_13 and AND_array;
            column_2_15_14 <= shift_2_15_14 and AND_array;
            column_2_15_15 <= shift_2_15_15 and AND_array;
            column_2_15_16 <= shift_2_15_16 and AND_array;
            column_2_16_1  <= shift_2_16_1 and AND_array;
            column_2_16_2  <= shift_2_16_2 and AND_array;
            column_2_16_3  <= shift_2_16_3 and AND_array;
            column_2_16_4  <= shift_2_16_4 and AND_array;
            column_2_16_5  <= shift_2_16_5 and AND_array;
            column_2_16_6  <= shift_2_16_6 and AND_array;
            column_2_16_7  <= shift_2_16_7 and AND_array;
            column_2_16_8  <= shift_2_16_8 and AND_array;
            column_2_16_9  <= shift_2_16_9 and AND_array;
            column_2_16_10 <= shift_2_16_10 and AND_array;
            column_2_16_11 <= shift_2_16_11 and AND_array;
            column_2_16_12 <= shift_2_16_12 and AND_array;
            column_2_16_13 <= shift_2_16_13 and AND_array;
            column_2_16_14 <= shift_2_16_14 and AND_array;
            column_2_16_15 <= shift_2_16_15 and AND_array;
            column_2_16_16 <= shift_2_16_16 and AND_array;
        end if;
    end process;
    -------------------------------------------------------------
    -- Process 3 : Cut the data into 8 bits
    -------------------------------------------------------------
    process (clk, reset)
    begin
        if (reset = '1') then
            --input_data_channel_d3 <= (others => (others => '0'));
            cut_column_1_1_1  <= (others => '0');
            cut_column_1_1_2  <= (others => '0');
            cut_column_1_1_3  <= (others => '0');
            cut_column_1_1_4  <= (others => '0');
            cut_column_1_1_5  <= (others => '0');
            cut_column_1_1_6  <= (others => '0');
            cut_column_1_1_7  <= (others => '0');
            cut_column_1_1_8  <= (others => '0');
            cut_column_1_1_9  <= (others => '0');
            cut_column_1_1_10 <= (others => '0');
            cut_column_1_1_11 <= (others => '0');
            cut_column_1_1_12 <= (others => '0');
            cut_column_1_1_13 <= (others => '0');
            cut_column_1_1_14 <= (others => '0');
            cut_column_1_1_15 <= (others => '0');
            cut_column_1_1_16 <= (others => '0');
        elsif (rising_edge(clk)) then
            -- Channel data
            cut_input_data_channel_r1  <= input_data_channel_r1(255 downto 240); -- First Row of the channel data
            cut_input_data_channel_r2  <= input_data_channel_r2(255 downto 240);
            cut_input_data_channel_r3  <= input_data_channel_r3(255 downto 240);
            cut_input_data_channel_r4  <= input_data_channel_r4(255 downto 240);
            cut_input_data_channel_r5  <= input_data_channel_r5(255 downto 240);
            cut_input_data_channel_r6  <= input_data_channel_r6(255 downto 240);
            cut_input_data_channel_r7  <= input_data_channel_r7(255 downto 240);
            cut_input_data_channel_r8  <= input_data_channel_r8(255 downto 240);
            cut_input_data_channel_r9  <= input_data_channel_r9(255 downto 240);
            cut_input_data_channel_r10 <= input_data_channel_r10(255 downto 240);
            cut_input_data_channel_r11 <= input_data_channel_r11(255 downto 240);
            cut_input_data_channel_r12 <= input_data_channel_r12(255 downto 240);
            cut_input_data_channel_r13 <= input_data_channel_r13(255 downto 240);
            cut_input_data_channel_r14 <= input_data_channel_r14(255 downto 240);
            cut_input_data_channel_r15 <= input_data_channel_r15(255 downto 240);
            cut_input_data_channel_r16 <= input_data_channel_r16(255 downto 240);
            -- First square
            cut_column_1_1_1   <= column_1_1_1(2047 downto 2040);
            cut_column_1_1_2   <= column_1_1_2(2047 downto 2040);
            cut_column_1_1_3   <= column_1_1_3(2047 downto 2040);
            cut_column_1_1_4   <= column_1_1_4(2047 downto 2040);
            cut_column_1_1_5   <= column_1_1_5(2047 downto 2040);
            cut_column_1_1_6   <= column_1_1_6(2047 downto 2040);
            cut_column_1_1_7   <= column_1_1_7(2047 downto 2040);
            cut_column_1_1_8   <= column_1_1_8(2047 downto 2040);
            cut_column_1_1_9   <= column_1_1_9(2047 downto 2040);
            cut_column_1_1_10  <= column_1_1_10(2047 downto 2040);
            cut_column_1_1_11  <= column_1_1_11(2047 downto 2040);
            cut_column_1_1_12  <= column_1_1_12(2047 downto 2040);
            cut_column_1_1_13  <= column_1_1_13(2047 downto 2040);
            cut_column_1_1_14  <= column_1_1_14(2047 downto 2040);
            cut_column_1_1_15  <= column_1_1_15(2047 downto 2040);
            cut_column_1_1_16  <= column_1_1_16(2047 downto 2040);
            cut_column_1_2_1   <= column_1_2_1(2047 downto 2040);
            cut_column_1_2_2   <= column_1_2_2(2047 downto 2040);
            cut_column_1_2_3   <= column_1_2_3(2047 downto 2040);
            cut_column_1_2_4   <= column_1_2_4(2047 downto 2040);
            cut_column_1_2_5   <= column_1_2_5(2047 downto 2040);
            cut_column_1_2_6   <= column_1_2_6(2047 downto 2040);
            cut_column_1_2_7   <= column_1_2_7(2047 downto 2040);
            cut_column_1_2_8   <= column_1_2_8(2047 downto 2040);
            cut_column_1_2_9   <= column_1_2_9(2047 downto 2040);
            cut_column_1_2_10  <= column_1_2_10(2047 downto 2040);
            cut_column_1_2_11  <= column_1_2_11(2047 downto 2040);
            cut_column_1_2_12  <= column_1_2_12(2047 downto 2040);
            cut_column_1_2_13  <= column_1_2_13(2047 downto 2040);
            cut_column_1_2_14  <= column_1_2_14(2047 downto 2040);
            cut_column_1_2_15  <= column_1_2_15(2047 downto 2040);
            cut_column_1_2_16  <= column_1_2_16(2047 downto 2040);
            cut_column_1_3_1   <= column_1_3_1(2047 downto 2040);
            cut_column_1_3_2   <= column_1_3_2(2047 downto 2040);
            cut_column_1_3_3   <= column_1_3_3(2047 downto 2040);
            cut_column_1_3_4   <= column_1_3_4(2047 downto 2040);
            cut_column_1_3_5   <= column_1_3_5(2047 downto 2040);
            cut_column_1_3_6   <= column_1_3_6(2047 downto 2040);
            cut_column_1_3_7   <= column_1_3_7(2047 downto 2040);
            cut_column_1_3_8   <= column_1_3_8(2047 downto 2040);
            cut_column_1_3_9   <= column_1_3_9(2047 downto 2040);
            cut_column_1_3_10  <= column_1_3_10(2047 downto 2040);
            cut_column_1_3_11  <= column_1_3_11(2047 downto 2040);
            cut_column_1_3_12  <= column_1_3_12(2047 downto 2040);
            cut_column_1_3_13  <= column_1_3_13(2047 downto 2040);
            cut_column_1_3_14  <= column_1_3_14(2047 downto 2040);
            cut_column_1_3_15  <= column_1_3_15(2047 downto 2040);
            cut_column_1_3_16  <= column_1_3_16(2047 downto 2040);
            cut_column_1_4_1   <= column_1_4_1(2047 downto 2040);
            cut_column_1_4_2   <= column_1_4_2(2047 downto 2040);
            cut_column_1_4_3   <= column_1_4_3(2047 downto 2040);
            cut_column_1_4_4   <= column_1_4_4(2047 downto 2040);
            cut_column_1_4_5   <= column_1_4_5(2047 downto 2040);
            cut_column_1_4_6   <= column_1_4_6(2047 downto 2040);
            cut_column_1_4_7   <= column_1_4_7(2047 downto 2040);
            cut_column_1_4_8   <= column_1_4_8(2047 downto 2040);
            cut_column_1_4_9   <= column_1_4_9(2047 downto 2040);
            cut_column_1_4_10  <= column_1_4_10(2047 downto 2040);
            cut_column_1_4_11  <= column_1_4_11(2047 downto 2040);
            cut_column_1_4_12  <= column_1_4_12(2047 downto 2040);
            cut_column_1_4_13  <= column_1_4_13(2047 downto 2040);
            cut_column_1_4_14  <= column_1_4_14(2047 downto 2040);
            cut_column_1_4_15  <= column_1_4_15(2047 downto 2040);
            cut_column_1_4_16  <= column_1_4_16(2047 downto 2040);
            cut_column_1_5_1   <= column_1_5_1(2047 downto 2040);
            cut_column_1_5_2   <= column_1_5_2(2047 downto 2040);
            cut_column_1_5_3   <= column_1_5_3(2047 downto 2040);
            cut_column_1_5_4   <= column_1_5_4(2047 downto 2040);
            cut_column_1_5_5   <= column_1_5_5(2047 downto 2040);
            cut_column_1_5_6   <= column_1_5_6(2047 downto 2040);
            cut_column_1_5_7   <= column_1_5_7(2047 downto 2040);
            cut_column_1_5_8   <= column_1_5_8(2047 downto 2040);
            cut_column_1_5_9   <= column_1_5_9(2047 downto 2040);
            cut_column_1_5_10  <= column_1_5_10(2047 downto 2040);
            cut_column_1_5_11  <= column_1_5_11(2047 downto 2040);
            cut_column_1_5_12  <= column_1_5_12(2047 downto 2040);
            cut_column_1_5_13  <= column_1_5_13(2047 downto 2040);
            cut_column_1_5_14  <= column_1_5_14(2047 downto 2040);
            cut_column_1_5_15  <= column_1_5_15(2047 downto 2040);
            cut_column_1_5_16  <= column_1_5_16(2047 downto 2040);
            cut_column_1_6_1   <= column_1_6_1(2047 downto 2040);
            cut_column_1_6_2   <= column_1_6_2(2047 downto 2040);
            cut_column_1_6_3   <= column_1_6_3(2047 downto 2040);
            cut_column_1_6_4   <= column_1_6_4(2047 downto 2040);
            cut_column_1_6_5   <= column_1_6_5(2047 downto 2040);
            cut_column_1_6_6   <= column_1_6_6(2047 downto 2040);
            cut_column_1_6_7   <= column_1_6_7(2047 downto 2040);
            cut_column_1_6_8   <= column_1_6_8(2047 downto 2040);
            cut_column_1_6_9   <= column_1_6_9(2047 downto 2040);
            cut_column_1_6_10  <= column_1_6_10(2047 downto 2040);
            cut_column_1_6_11  <= column_1_6_11(2047 downto 2040);
            cut_column_1_6_12  <= column_1_6_12(2047 downto 2040);
            cut_column_1_6_13  <= column_1_6_13(2047 downto 2040);
            cut_column_1_6_14  <= column_1_6_14(2047 downto 2040);
            cut_column_1_6_15  <= column_1_6_15(2047 downto 2040);
            cut_column_1_6_16  <= column_1_6_16(2047 downto 2040);
            cut_column_1_7_1   <= column_1_7_1(2047 downto 2040);
            cut_column_1_7_2   <= column_1_7_2(2047 downto 2040);
            cut_column_1_7_3   <= column_1_7_3(2047 downto 2040);
            cut_column_1_7_4   <= column_1_7_4(2047 downto 2040);
            cut_column_1_7_5   <= column_1_7_5(2047 downto 2040);
            cut_column_1_7_6   <= column_1_7_6(2047 downto 2040);
            cut_column_1_7_7   <= column_1_7_7(2047 downto 2040);
            cut_column_1_7_8   <= column_1_7_8(2047 downto 2040);
            cut_column_1_7_9   <= column_1_7_9(2047 downto 2040);
            cut_column_1_7_10  <= column_1_7_10(2047 downto 2040);
            cut_column_1_7_11  <= column_1_7_11(2047 downto 2040);
            cut_column_1_7_12  <= column_1_7_12(2047 downto 2040);
            cut_column_1_7_13  <= column_1_7_13(2047 downto 2040);
            cut_column_1_7_14  <= column_1_7_14(2047 downto 2040);
            cut_column_1_7_15  <= column_1_7_15(2047 downto 2040);
            cut_column_1_7_16  <= column_1_7_16(2047 downto 2040);
            cut_column_1_8_1   <= column_1_8_1(2047 downto 2040);
            cut_column_1_8_2   <= column_1_8_2(2047 downto 2040);
            cut_column_1_8_3   <= column_1_8_3(2047 downto 2040);
            cut_column_1_8_4   <= column_1_8_4(2047 downto 2040);
            cut_column_1_8_5   <= column_1_8_5(2047 downto 2040);
            cut_column_1_8_6   <= column_1_8_6(2047 downto 2040);
            cut_column_1_8_7   <= column_1_8_7(2047 downto 2040);
            cut_column_1_8_8   <= column_1_8_8(2047 downto 2040);
            cut_column_1_8_9   <= column_1_8_9(2047 downto 2040);
            cut_column_1_8_10  <= column_1_8_10(2047 downto 2040);
            cut_column_1_8_11  <= column_1_8_11(2047 downto 2040);
            cut_column_1_8_12  <= column_1_8_12(2047 downto 2040);
            cut_column_1_8_13  <= column_1_8_13(2047 downto 2040);
            cut_column_1_8_14  <= column_1_8_14(2047 downto 2040);
            cut_column_1_8_15  <= column_1_8_15(2047 downto 2040);
            cut_column_1_8_16  <= column_1_8_16(2047 downto 2040);
            cut_column_1_9_1   <= column_1_9_1(2047 downto 2040);
            cut_column_1_9_2   <= column_1_9_2(2047 downto 2040);
            cut_column_1_9_3   <= column_1_9_3(2047 downto 2040);
            cut_column_1_9_4   <= column_1_9_4(2047 downto 2040);
            cut_column_1_9_5   <= column_1_9_5(2047 downto 2040);
            cut_column_1_9_6   <= column_1_9_6(2047 downto 2040);
            cut_column_1_9_7   <= column_1_9_7(2047 downto 2040);
            cut_column_1_9_8   <= column_1_9_8(2047 downto 2040);
            cut_column_1_9_9   <= column_1_9_9(2047 downto 2040);
            cut_column_1_9_10  <= column_1_9_10(2047 downto 2040);
            cut_column_1_9_11  <= column_1_9_11(2047 downto 2040);
            cut_column_1_9_12  <= column_1_9_12(2047 downto 2040);
            cut_column_1_9_13  <= column_1_9_13(2047 downto 2040);
            cut_column_1_9_14  <= column_1_9_14(2047 downto 2040);
            cut_column_1_9_15  <= column_1_9_15(2047 downto 2040);
            cut_column_1_9_16  <= column_1_9_16(2047 downto 2040);
            cut_column_1_10_1  <= column_1_10_1(2047 downto 2040);
            cut_column_1_10_2  <= column_1_10_2(2047 downto 2040);
            cut_column_1_10_3  <= column_1_10_3(2047 downto 2040);
            cut_column_1_10_4  <= column_1_10_4(2047 downto 2040);
            cut_column_1_10_5  <= column_1_10_5(2047 downto 2040);
            cut_column_1_10_6  <= column_1_10_6(2047 downto 2040);
            cut_column_1_10_7  <= column_1_10_7(2047 downto 2040);
            cut_column_1_10_8  <= column_1_10_8(2047 downto 2040);
            cut_column_1_10_9  <= column_1_10_9(2047 downto 2040);
            cut_column_1_10_10 <= column_1_10_10(2047 downto 2040);
            cut_column_1_10_11 <= column_1_10_11(2047 downto 2040);
            cut_column_1_10_12 <= column_1_10_12(2047 downto 2040);
            cut_column_1_10_13 <= column_1_10_13(2047 downto 2040);
            cut_column_1_10_14 <= column_1_10_14(2047 downto 2040);
            cut_column_1_10_15 <= column_1_10_15(2047 downto 2040);
            cut_column_1_10_16 <= column_1_10_16(2047 downto 2040);
            cut_column_1_11_1  <= column_1_11_1(2047 downto 2040);
            cut_column_1_11_2  <= column_1_11_2(2047 downto 2040);
            cut_column_1_11_3  <= column_1_11_3(2047 downto 2040);
            cut_column_1_11_4  <= column_1_11_4(2047 downto 2040);
            cut_column_1_11_5  <= column_1_11_5(2047 downto 2040);
            cut_column_1_11_6  <= column_1_11_6(2047 downto 2040);
            cut_column_1_11_7  <= column_1_11_7(2047 downto 2040);
            cut_column_1_11_8  <= column_1_11_8(2047 downto 2040);
            cut_column_1_11_9  <= column_1_11_9(2047 downto 2040);
            cut_column_1_11_10 <= column_1_11_10(2047 downto 2040);
            cut_column_1_11_11 <= column_1_11_11(2047 downto 2040);
            cut_column_1_11_12 <= column_1_11_12(2047 downto 2040);
            cut_column_1_11_13 <= column_1_11_13(2047 downto 2040);
            cut_column_1_11_14 <= column_1_11_14(2047 downto 2040);
            cut_column_1_11_15 <= column_1_11_15(2047 downto 2040);
            cut_column_1_11_16 <= column_1_11_16(2047 downto 2040);
            cut_column_1_12_1  <= column_1_12_1(2047 downto 2040);
            cut_column_1_12_2  <= column_1_12_2(2047 downto 2040);
            cut_column_1_12_3  <= column_1_12_3(2047 downto 2040);
            cut_column_1_12_4  <= column_1_12_4(2047 downto 2040);
            cut_column_1_12_5  <= column_1_12_5(2047 downto 2040);
            cut_column_1_12_6  <= column_1_12_6(2047 downto 2040);
            cut_column_1_12_7  <= column_1_12_7(2047 downto 2040);
            cut_column_1_12_8  <= column_1_12_8(2047 downto 2040);
            cut_column_1_12_9  <= column_1_12_9(2047 downto 2040);
            cut_column_1_12_10 <= column_1_12_10(2047 downto 2040);
            cut_column_1_12_11 <= column_1_12_11(2047 downto 2040);
            cut_column_1_12_12 <= column_1_12_12(2047 downto 2040);
            cut_column_1_12_13 <= column_1_12_13(2047 downto 2040);
            cut_column_1_12_14 <= column_1_12_14(2047 downto 2040);
            cut_column_1_12_15 <= column_1_12_15(2047 downto 2040);
            cut_column_1_12_16 <= column_1_12_16(2047 downto 2040);
            cut_column_1_13_1  <= column_1_13_1(2047 downto 2040);
            cut_column_1_13_2  <= column_1_13_2(2047 downto 2040);
            cut_column_1_13_3  <= column_1_13_3(2047 downto 2040);
            cut_column_1_13_4  <= column_1_13_4(2047 downto 2040);
            cut_column_1_13_5  <= column_1_13_5(2047 downto 2040);
            cut_column_1_13_6  <= column_1_13_6(2047 downto 2040);
            cut_column_1_13_7  <= column_1_13_7(2047 downto 2040);
            cut_column_1_13_8  <= column_1_13_8(2047 downto 2040);
            cut_column_1_13_9  <= column_1_13_9(2047 downto 2040);
            cut_column_1_13_10 <= column_1_13_10(2047 downto 2040);
            cut_column_1_13_11 <= column_1_13_11(2047 downto 2040);
            cut_column_1_13_12 <= column_1_13_12(2047 downto 2040);
            cut_column_1_13_13 <= column_1_13_13(2047 downto 2040);
            cut_column_1_13_14 <= column_1_13_14(2047 downto 2040);
            cut_column_1_13_15 <= column_1_13_15(2047 downto 2040);
            cut_column_1_13_16 <= column_1_13_16(2047 downto 2040);
            cut_column_1_14_1  <= column_1_14_1(2047 downto 2040);
            cut_column_1_14_2  <= column_1_14_2(2047 downto 2040);
            cut_column_1_14_3  <= column_1_14_3(2047 downto 2040);
            cut_column_1_14_4  <= column_1_14_4(2047 downto 2040);
            cut_column_1_14_5  <= column_1_14_5(2047 downto 2040);
            cut_column_1_14_6  <= column_1_14_6(2047 downto 2040);
            cut_column_1_14_7  <= column_1_14_7(2047 downto 2040);
            cut_column_1_14_8  <= column_1_14_8(2047 downto 2040);
            cut_column_1_14_9  <= column_1_14_9(2047 downto 2040);
            cut_column_1_14_10 <= column_1_14_10(2047 downto 2040);
            cut_column_1_14_11 <= column_1_14_11(2047 downto 2040);
            cut_column_1_14_12 <= column_1_14_12(2047 downto 2040);
            cut_column_1_14_13 <= column_1_14_13(2047 downto 2040);
            cut_column_1_14_14 <= column_1_14_14(2047 downto 2040);
            cut_column_1_14_15 <= column_1_14_15(2047 downto 2040);
            cut_column_1_14_16 <= column_1_14_16(2047 downto 2040);
            cut_column_1_15_1  <= column_1_15_1(2047 downto 2040);
            cut_column_1_15_2  <= column_1_15_2(2047 downto 2040);
            cut_column_1_15_3  <= column_1_15_3(2047 downto 2040);
            cut_column_1_15_4  <= column_1_15_4(2047 downto 2040);
            cut_column_1_15_5  <= column_1_15_5(2047 downto 2040);
            cut_column_1_15_6  <= column_1_15_6(2047 downto 2040);
            cut_column_1_15_7  <= column_1_15_7(2047 downto 2040);
            cut_column_1_15_8  <= column_1_15_8(2047 downto 2040);
            cut_column_1_15_9  <= column_1_15_9(2047 downto 2040);
            cut_column_1_15_10 <= column_1_15_10(2047 downto 2040);
            cut_column_1_15_11 <= column_1_15_11(2047 downto 2040);
            cut_column_1_15_12 <= column_1_15_12(2047 downto 2040);
            cut_column_1_15_13 <= column_1_15_13(2047 downto 2040);
            cut_column_1_15_14 <= column_1_15_14(2047 downto 2040);
            cut_column_1_15_15 <= column_1_15_15(2047 downto 2040);
            cut_column_1_15_16 <= column_1_15_16(2047 downto 2040);
            cut_column_1_16_1  <= column_1_16_1(2047 downto 2040);
            cut_column_1_16_2  <= column_1_16_2(2047 downto 2040);
            cut_column_1_16_3  <= column_1_16_3(2047 downto 2040);
            cut_column_1_16_4  <= column_1_16_4(2047 downto 2040);
            cut_column_1_16_5  <= column_1_16_5(2047 downto 2040);
            cut_column_1_16_6  <= column_1_16_6(2047 downto 2040);
            cut_column_1_16_7  <= column_1_16_7(2047 downto 2040);
            cut_column_1_16_8  <= column_1_16_8(2047 downto 2040);
            cut_column_1_16_9  <= column_1_16_9(2047 downto 2040);
            cut_column_1_16_10 <= column_1_16_10(2047 downto 2040);
            cut_column_1_16_11 <= column_1_16_11(2047 downto 2040);
            cut_column_1_16_12 <= column_1_16_12(2047 downto 2040);
            cut_column_1_16_13 <= column_1_16_13(2047 downto 2040);
            cut_column_1_16_14 <= column_1_16_14(2047 downto 2040);
            cut_column_1_16_15 <= column_1_16_15(2047 downto 2040);
            cut_column_1_16_16 <= column_1_16_16(2047 downto 2040);
            -- Second square
            cut_column_2_1_1   <= column_2_1_1(2047 downto 2040);
            cut_column_2_1_2   <= column_2_1_2(2047 downto 2040);
            cut_column_2_1_3   <= column_2_1_3(2047 downto 2040);
            cut_column_2_1_4   <= column_2_1_4(2047 downto 2040);
            cut_column_2_1_5   <= column_2_1_5(2047 downto 2040);
            cut_column_2_1_6   <= column_2_1_6(2047 downto 2040);
            cut_column_2_1_7   <= column_2_1_7(2047 downto 2040);
            cut_column_2_1_8   <= column_2_1_8(2047 downto 2040);
            cut_column_2_1_9   <= column_2_1_9(2047 downto 2040);
            cut_column_2_1_10  <= column_2_1_10(2047 downto 2040);
            cut_column_2_1_11  <= column_2_1_11(2047 downto 2040);
            cut_column_2_1_12  <= column_2_1_12(2047 downto 2040);
            cut_column_2_1_13  <= column_2_1_13(2047 downto 2040);
            cut_column_2_1_14  <= column_2_1_14(2047 downto 2040);
            cut_column_2_1_15  <= column_2_1_15(2047 downto 2040);
            cut_column_2_1_16  <= column_2_1_16(2047 downto 2040);
            cut_column_2_2_1   <= column_2_2_1(2047 downto 2040);
            cut_column_2_2_2   <= column_2_2_2(2047 downto 2040);
            cut_column_2_2_3   <= column_2_2_3(2047 downto 2040);
            cut_column_2_2_4   <= column_2_2_4(2047 downto 2040);
            cut_column_2_2_5   <= column_2_2_5(2047 downto 2040);
            cut_column_2_2_6   <= column_2_2_6(2047 downto 2040);
            cut_column_2_2_7   <= column_2_2_7(2047 downto 2040);
            cut_column_2_2_8   <= column_2_2_8(2047 downto 2040);
            cut_column_2_2_9   <= column_2_2_9(2047 downto 2040);
            cut_column_2_2_10  <= column_2_2_10(2047 downto 2040);
            cut_column_2_2_11  <= column_2_2_11(2047 downto 2040);
            cut_column_2_2_12  <= column_2_2_12(2047 downto 2040);
            cut_column_2_2_13  <= column_2_2_13(2047 downto 2040);
            cut_column_2_2_14  <= column_2_2_14(2047 downto 2040);
            cut_column_2_2_15  <= column_2_2_15(2047 downto 2040);
            cut_column_2_2_16  <= column_2_2_16(2047 downto 2040);
            cut_column_2_3_1   <= column_2_3_1(2047 downto 2040);
            cut_column_2_3_2   <= column_2_3_2(2047 downto 2040);
            cut_column_2_3_3   <= column_2_3_3(2047 downto 2040);
            cut_column_2_3_4   <= column_2_3_4(2047 downto 2040);
            cut_column_2_3_5   <= column_2_3_5(2047 downto 2040);
            cut_column_2_3_6   <= column_2_3_6(2047 downto 2040);
            cut_column_2_3_7   <= column_2_3_7(2047 downto 2040);
            cut_column_2_3_8   <= column_2_3_8(2047 downto 2040);
            cut_column_2_3_9   <= column_2_3_9(2047 downto 2040);
            cut_column_2_3_10  <= column_2_3_10(2047 downto 2040);
            cut_column_2_3_11  <= column_2_3_11(2047 downto 2040);
            cut_column_2_3_12  <= column_2_3_12(2047 downto 2040);
            cut_column_2_3_13  <= column_2_3_13(2047 downto 2040);
            cut_column_2_3_14  <= column_2_3_14(2047 downto 2040);
            cut_column_2_3_15  <= column_2_3_15(2047 downto 2040);
            cut_column_2_3_16  <= column_2_3_16(2047 downto 2040);
            cut_column_2_4_1   <= column_2_4_1(2047 downto 2040);
            cut_column_2_4_2   <= column_2_4_2(2047 downto 2040);
            cut_column_2_4_3   <= column_2_4_3(2047 downto 2040);
            cut_column_2_4_4   <= column_2_4_4(2047 downto 2040);
            cut_column_2_4_5   <= column_2_4_5(2047 downto 2040);
            cut_column_2_4_6   <= column_2_4_6(2047 downto 2040);
            cut_column_2_4_7   <= column_2_4_7(2047 downto 2040);
            cut_column_2_4_8   <= column_2_4_8(2047 downto 2040);
            cut_column_2_4_9   <= column_2_4_9(2047 downto 2040);
            cut_column_2_4_10  <= column_2_4_10(2047 downto 2040);
            cut_column_2_4_11  <= column_2_4_11(2047 downto 2040);
            cut_column_2_4_12  <= column_2_4_12(2047 downto 2040);
            cut_column_2_4_13  <= column_2_4_13(2047 downto 2040);
            cut_column_2_4_14  <= column_2_4_14(2047 downto 2040);
            cut_column_2_4_15  <= column_2_4_15(2047 downto 2040);
            cut_column_2_4_16  <= column_2_4_16(2047 downto 2040);
            cut_column_2_5_1   <= column_2_5_1(2047 downto 2040);
            cut_column_2_5_2   <= column_2_5_2(2047 downto 2040);
            cut_column_2_5_3   <= column_2_5_3(2047 downto 2040);
            cut_column_2_5_4   <= column_2_5_4(2047 downto 2040);
            cut_column_2_5_5   <= column_2_5_5(2047 downto 2040);
            cut_column_2_5_6   <= column_2_5_6(2047 downto 2040);
            cut_column_2_5_7   <= column_2_5_7(2047 downto 2040);
            cut_column_2_5_8   <= column_2_5_8(2047 downto 2040);
            cut_column_2_5_9   <= column_2_5_9(2047 downto 2040);
            cut_column_2_5_10  <= column_2_5_10(2047 downto 2040);
            cut_column_2_5_11  <= column_2_5_11(2047 downto 2040);
            cut_column_2_5_12  <= column_2_5_12(2047 downto 2040);
            cut_column_2_5_13  <= column_2_5_13(2047 downto 2040);
            cut_column_2_5_14  <= column_2_5_14(2047 downto 2040);
            cut_column_2_5_15  <= column_2_5_15(2047 downto 2040);
            cut_column_2_5_16  <= column_2_5_16(2047 downto 2040);
            cut_column_2_6_1   <= column_2_6_1(2047 downto 2040);
            cut_column_2_6_2   <= column_2_6_2(2047 downto 2040);
            cut_column_2_6_3   <= column_2_6_3(2047 downto 2040);
            cut_column_2_6_4   <= column_2_6_4(2047 downto 2040);
            cut_column_2_6_5   <= column_2_6_5(2047 downto 2040);
            cut_column_2_6_6   <= column_2_6_6(2047 downto 2040);
            cut_column_2_6_7   <= column_2_6_7(2047 downto 2040);
            cut_column_2_6_8   <= column_2_6_8(2047 downto 2040);
            cut_column_2_6_9   <= column_2_6_9(2047 downto 2040);
            cut_column_2_6_10  <= column_2_6_10(2047 downto 2040);
            cut_column_2_6_11  <= column_2_6_11(2047 downto 2040);
            cut_column_2_6_12  <= column_2_6_12(2047 downto 2040);
            cut_column_2_6_13  <= column_2_6_13(2047 downto 2040);
            cut_column_2_6_14  <= column_2_6_14(2047 downto 2040);
            cut_column_2_6_15  <= column_2_6_15(2047 downto 2040);
            cut_column_2_6_16  <= column_2_6_16(2047 downto 2040);
            cut_column_2_7_1   <= column_2_7_1(2047 downto 2040);
            cut_column_2_7_2   <= column_2_7_2(2047 downto 2040);
            cut_column_2_7_3   <= column_2_7_3(2047 downto 2040);
            cut_column_2_7_4   <= column_2_7_4(2047 downto 2040);
            cut_column_2_7_5   <= column_2_7_5(2047 downto 2040);
            cut_column_2_7_6   <= column_2_7_6(2047 downto 2040);
            cut_column_2_7_7   <= column_2_7_7(2047 downto 2040);
            cut_column_2_7_8   <= column_2_7_8(2047 downto 2040);
            cut_column_2_7_9   <= column_2_7_9(2047 downto 2040);
            cut_column_2_7_10  <= column_2_7_10(2047 downto 2040);
            cut_column_2_7_11  <= column_2_7_11(2047 downto 2040);
            cut_column_2_7_12  <= column_2_7_12(2047 downto 2040);
            cut_column_2_7_13  <= column_2_7_13(2047 downto 2040);
            cut_column_2_7_14  <= column_2_7_14(2047 downto 2040);
            cut_column_2_7_15  <= column_2_7_15(2047 downto 2040);
            cut_column_2_7_16  <= column_2_7_16(2047 downto 2040);
            cut_column_2_8_1   <= column_2_8_1(2047 downto 2040);
            cut_column_2_8_2   <= column_2_8_2(2047 downto 2040);
            cut_column_2_8_3   <= column_2_8_3(2047 downto 2040);
            cut_column_2_8_4   <= column_2_8_4(2047 downto 2040);
            cut_column_2_8_5   <= column_2_8_5(2047 downto 2040);
            cut_column_2_8_6   <= column_2_8_6(2047 downto 2040);
            cut_column_2_8_7   <= column_2_8_7(2047 downto 2040);
            cut_column_2_8_8   <= column_2_8_8(2047 downto 2040);
            cut_column_2_8_9   <= column_2_8_9(2047 downto 2040);
            cut_column_2_8_10  <= column_2_8_10(2047 downto 2040);
            cut_column_2_8_11  <= column_2_8_11(2047 downto 2040);
            cut_column_2_8_12  <= column_2_8_12(2047 downto 2040);
            cut_column_2_8_13  <= column_2_8_13(2047 downto 2040);
            cut_column_2_8_14  <= column_2_8_14(2047 downto 2040);
            cut_column_2_8_15  <= column_2_8_15(2047 downto 2040);
            cut_column_2_8_16  <= column_2_8_16(2047 downto 2040);
            cut_column_2_9_1   <= column_2_9_1(2047 downto 2040);
            cut_column_2_9_2   <= column_2_9_2(2047 downto 2040);
            cut_column_2_9_3   <= column_2_9_3(2047 downto 2040);
            cut_column_2_9_4   <= column_2_9_4(2047 downto 2040);
            cut_column_2_9_5   <= column_2_9_5(2047 downto 2040);
            cut_column_2_9_6   <= column_2_9_6(2047 downto 2040);
            cut_column_2_9_7   <= column_2_9_7(2047 downto 2040);
            cut_column_2_9_8   <= column_2_9_8(2047 downto 2040);
            cut_column_2_9_9   <= column_2_9_9(2047 downto 2040);
            cut_column_2_9_10  <= column_2_9_10(2047 downto 2040);
            cut_column_2_9_11  <= column_2_9_11(2047 downto 2040);
            cut_column_2_9_12  <= column_2_9_12(2047 downto 2040);
            cut_column_2_9_13  <= column_2_9_13(2047 downto 2040);
            cut_column_2_9_14  <= column_2_9_14(2047 downto 2040);
            cut_column_2_9_15  <= column_2_9_15(2047 downto 2040);
            cut_column_2_9_16  <= column_2_9_16(2047 downto 2040);
            cut_column_2_10_1  <= column_2_10_1(2047 downto 2040);
            cut_column_2_10_2  <= column_2_10_2(2047 downto 2040);
            cut_column_2_10_3  <= column_2_10_3(2047 downto 2040);
            cut_column_2_10_4  <= column_2_10_4(2047 downto 2040);
            cut_column_2_10_5  <= column_2_10_5(2047 downto 2040);
            cut_column_2_10_6  <= column_2_10_6(2047 downto 2040);
            cut_column_2_10_7  <= column_2_10_7(2047 downto 2040);
            cut_column_2_10_8  <= column_2_10_8(2047 downto 2040);
            cut_column_2_10_9  <= column_2_10_9(2047 downto 2040);
            cut_column_2_10_10 <= column_2_10_10(2047 downto 2040);
            cut_column_2_10_11 <= column_2_10_11(2047 downto 2040);
            cut_column_2_10_12 <= column_2_10_12(2047 downto 2040);
            cut_column_2_10_13 <= column_2_10_13(2047 downto 2040);
            cut_column_2_10_14 <= column_2_10_14(2047 downto 2040);
            cut_column_2_10_15 <= column_2_10_15(2047 downto 2040);
            cut_column_2_10_16 <= column_2_10_16(2047 downto 2040);
            cut_column_2_11_1  <= column_2_11_1(2047 downto 2040);
            cut_column_2_11_2  <= column_2_11_2(2047 downto 2040);
            cut_column_2_11_3  <= column_2_11_3(2047 downto 2040);
            cut_column_2_11_4  <= column_2_11_4(2047 downto 2040);
            cut_column_2_11_5  <= column_2_11_5(2047 downto 2040);
            cut_column_2_11_6  <= column_2_11_6(2047 downto 2040);
            cut_column_2_11_7  <= column_2_11_7(2047 downto 2040);
            cut_column_2_11_8  <= column_2_11_8(2047 downto 2040);
            cut_column_2_11_9  <= column_2_11_9(2047 downto 2040);
            cut_column_2_11_10 <= column_2_11_10(2047 downto 2040);
            cut_column_2_11_11 <= column_2_11_11(2047 downto 2040);
            cut_column_2_11_12 <= column_2_11_12(2047 downto 2040);
            cut_column_2_11_13 <= column_2_11_13(2047 downto 2040);
            cut_column_2_11_14 <= column_2_11_14(2047 downto 2040);
            cut_column_2_11_15 <= column_2_11_15(2047 downto 2040);
            cut_column_2_11_16 <= column_2_11_16(2047 downto 2040);
            cut_column_2_12_1  <= column_2_12_1(2047 downto 2040);
            cut_column_2_12_2  <= column_2_12_2(2047 downto 2040);
            cut_column_2_12_3  <= column_2_12_3(2047 downto 2040);
            cut_column_2_12_4  <= column_2_12_4(2047 downto 2040);
            cut_column_2_12_5  <= column_2_12_5(2047 downto 2040);
            cut_column_2_12_6  <= column_2_12_6(2047 downto 2040);
            cut_column_2_12_7  <= column_2_12_7(2047 downto 2040);
            cut_column_2_12_8  <= column_2_12_8(2047 downto 2040);
            cut_column_2_12_9  <= column_2_12_9(2047 downto 2040);
            cut_column_2_12_10 <= column_2_12_10(2047 downto 2040);
            cut_column_2_12_11 <= column_2_12_11(2047 downto 2040);
            cut_column_2_12_12 <= column_2_12_12(2047 downto 2040);
            cut_column_2_12_13 <= column_2_12_13(2047 downto 2040);
            cut_column_2_12_14 <= column_2_12_14(2047 downto 2040);
            cut_column_2_12_15 <= column_2_12_15(2047 downto 2040);
            cut_column_2_12_16 <= column_2_12_16(2047 downto 2040);
            cut_column_2_13_1  <= column_2_13_1(2047 downto 2040);
            cut_column_2_13_2  <= column_2_13_2(2047 downto 2040);
            cut_column_2_13_3  <= column_2_13_3(2047 downto 2040);
            cut_column_2_13_4  <= column_2_13_4(2047 downto 2040);
            cut_column_2_13_5  <= column_2_13_5(2047 downto 2040);
            cut_column_2_13_6  <= column_2_13_6(2047 downto 2040);
            cut_column_2_13_7  <= column_2_13_7(2047 downto 2040);
            cut_column_2_13_8  <= column_2_13_8(2047 downto 2040);
            cut_column_2_13_9  <= column_2_13_9(2047 downto 2040);
            cut_column_2_13_10 <= column_2_13_10(2047 downto 2040);
            cut_column_2_13_11 <= column_2_13_11(2047 downto 2040);
            cut_column_2_13_12 <= column_2_13_12(2047 downto 2040);
            cut_column_2_13_13 <= column_2_13_13(2047 downto 2040);
            cut_column_2_13_14 <= column_2_13_14(2047 downto 2040);
            cut_column_2_13_15 <= column_2_13_15(2047 downto 2040);
            cut_column_2_13_16 <= column_2_13_16(2047 downto 2040);
            cut_column_2_14_1  <= column_2_14_1(2047 downto 2040);
            cut_column_2_14_2  <= column_2_14_2(2047 downto 2040);
            cut_column_2_14_3  <= column_2_14_3(2047 downto 2040);
            cut_column_2_14_4  <= column_2_14_4(2047 downto 2040);
            cut_column_2_14_5  <= column_2_14_5(2047 downto 2040);
            cut_column_2_14_6  <= column_2_14_6(2047 downto 2040);
            cut_column_2_14_7  <= column_2_14_7(2047 downto 2040);
            cut_column_2_14_8  <= column_2_14_8(2047 downto 2040);
            cut_column_2_14_9  <= column_2_14_9(2047 downto 2040);
            cut_column_2_14_10 <= column_2_14_10(2047 downto 2040);
            cut_column_2_14_11 <= column_2_14_11(2047 downto 2040);
            cut_column_2_14_12 <= column_2_14_12(2047 downto 2040);
            cut_column_2_14_13 <= column_2_14_13(2047 downto 2040);
            cut_column_2_14_14 <= column_2_14_14(2047 downto 2040);
            cut_column_2_14_15 <= column_2_14_15(2047 downto 2040);
            cut_column_2_14_16 <= column_2_14_16(2047 downto 2040);
            cut_column_2_15_1  <= column_2_15_1(2047 downto 2040);
            cut_column_2_15_2  <= column_2_15_2(2047 downto 2040);
            cut_column_2_15_3  <= column_2_15_3(2047 downto 2040);
            cut_column_2_15_4  <= column_2_15_4(2047 downto 2040);
            cut_column_2_15_5  <= column_2_15_5(2047 downto 2040);
            cut_column_2_15_6  <= column_2_15_6(2047 downto 2040);
            cut_column_2_15_7  <= column_2_15_7(2047 downto 2040);
            cut_column_2_15_8  <= column_2_15_8(2047 downto 2040);
            cut_column_2_15_9  <= column_2_15_9(2047 downto 2040);
            cut_column_2_15_10 <= column_2_15_10(2047 downto 2040);
            cut_column_2_15_11 <= column_2_15_11(2047 downto 2040);
            cut_column_2_15_12 <= column_2_15_12(2047 downto 2040);
            cut_column_2_15_13 <= column_2_15_13(2047 downto 2040);
            cut_column_2_15_14 <= column_2_15_14(2047 downto 2040);
            cut_column_2_15_15 <= column_2_15_15(2047 downto 2040);
            cut_column_2_15_16 <= column_2_15_16(2047 downto 2040);
            cut_column_2_16_1  <= column_2_16_1(2047 downto 2040);
            cut_column_2_16_2  <= column_2_16_2(2047 downto 2040);
            cut_column_2_16_3  <= column_2_16_3(2047 downto 2040);
            cut_column_2_16_4  <= column_2_16_4(2047 downto 2040);
            cut_column_2_16_5  <= column_2_16_5(2047 downto 2040);
            cut_column_2_16_6  <= column_2_16_6(2047 downto 2040);
            cut_column_2_16_7  <= column_2_16_7(2047 downto 2040);
            cut_column_2_16_8  <= column_2_16_8(2047 downto 2040);
            cut_column_2_16_9  <= column_2_16_9(2047 downto 2040);
            cut_column_2_16_10 <= column_2_16_10(2047 downto 2040);
            cut_column_2_16_11 <= column_2_16_11(2047 downto 2040);
            cut_column_2_16_12 <= column_2_16_12(2047 downto 2040);
            cut_column_2_16_13 <= column_2_16_13(2047 downto 2040);
            cut_column_2_16_14 <= column_2_16_14(2047 downto 2040);
            cut_column_2_16_15 <= column_2_16_15(2047 downto 2040);
            cut_column_2_16_16 <= column_2_16_16(2047 downto 2040);
        end if;
    end process;
    -------------------------------------------------------------
    -- Process 4 : Form the first half of codeword stage 1 (Establish the columns)
    -------------------------------------------------------------
    process (clk, reset)
    begin
        if (reset = '1') then
            --input_data_channel_d4 <= (others => (others => '0'));
            a_column_1_1  <= (others => (others => '0'));
            a_column_1_2  <= (others => (others => '0'));
            a_column_1_3  <= (others => (others => '0'));
            a_column_1_4  <= (others => (others => '0'));
            a_column_1_5  <= (others => (others => '0'));
            a_column_1_6  <= (others => (others => '0'));
            a_column_1_7  <= (others => (others => '0'));
            a_column_1_8  <= (others => (others => '0'));
            a_column_1_9  <= (others => (others => '0'));
            a_column_1_10 <= (others => (others => '0'));
            a_column_1_11 <= (others => (others => '0'));
            a_column_1_12 <= (others => (others => '0'));
            a_column_1_13 <= (others => (others => '0'));
            a_column_1_14 <= (others => (others => '0'));
            a_column_1_15 <= (others => (others => '0'));
            a_column_1_16 <= (others => (others => '0'));
        elsif (rising_edge(clk)) then
            -- Channel data
            delay_input_data_channel_r1  <= cut_input_data_channel_r1;
            delay_input_data_channel_r2  <= cut_input_data_channel_r2;
            delay_input_data_channel_r3  <= cut_input_data_channel_r3;
            delay_input_data_channel_r4  <= cut_input_data_channel_r4;
            delay_input_data_channel_r5  <= cut_input_data_channel_r5;
            delay_input_data_channel_r6  <= cut_input_data_channel_r6;
            delay_input_data_channel_r7  <= cut_input_data_channel_r7;
            delay_input_data_channel_r8  <= cut_input_data_channel_r8;
            delay_input_data_channel_r9  <= cut_input_data_channel_r9;
            delay_input_data_channel_r10 <= cut_input_data_channel_r10;
            delay_input_data_channel_r11 <= cut_input_data_channel_r11;
            delay_input_data_channel_r12 <= cut_input_data_channel_r12;
            delay_input_data_channel_r13 <= cut_input_data_channel_r13;
            delay_input_data_channel_r14 <= cut_input_data_channel_r14;
            delay_input_data_channel_r15 <= cut_input_data_channel_r15;
            delay_input_data_channel_r16 <= cut_input_data_channel_r16;
            -- Data of first column: First square
            a_column_1_1(0)  <= cut_column_1_1_1;
            a_column_1_1(1)  <= cut_column_1_1_2;
            a_column_1_1(2)  <= cut_column_1_1_3;
            a_column_1_1(3)  <= cut_column_1_1_4;
            a_column_1_1(4)  <= cut_column_1_1_5;
            a_column_1_1(5)  <= cut_column_1_1_6;
            a_column_1_1(6)  <= cut_column_1_1_7;
            a_column_1_1(7)  <= cut_column_1_1_8;
            a_column_1_1(8)  <= cut_column_1_1_9;
            a_column_1_1(9)  <= cut_column_1_1_10;
            a_column_1_1(10) <= cut_column_1_1_11;
            a_column_1_1(11) <= cut_column_1_1_12;
            a_column_1_1(12) <= cut_column_1_1_13;
            a_column_1_1(13) <= cut_column_1_1_14;
            a_column_1_1(14) <= cut_column_1_1_15;
            a_column_1_1(15) <= cut_column_1_1_16;
            -- Data of second column: First square
            a_column_1_2(0)  <= cut_column_1_2_1;
            a_column_1_2(1)  <= cut_column_1_2_2;
            a_column_1_2(2)  <= cut_column_1_2_3;
            a_column_1_2(3)  <= cut_column_1_2_4;
            a_column_1_2(4)  <= cut_column_1_2_5;
            a_column_1_2(5)  <= cut_column_1_2_6;
            a_column_1_2(6)  <= cut_column_1_2_7;
            a_column_1_2(7)  <= cut_column_1_2_8;
            a_column_1_2(8)  <= cut_column_1_2_9;
            a_column_1_2(9)  <= cut_column_1_2_10;
            a_column_1_2(10) <= cut_column_1_2_11;
            a_column_1_2(11) <= cut_column_1_2_12;
            a_column_1_2(12) <= cut_column_1_2_13;
            a_column_1_2(13) <= cut_column_1_2_14;
            a_column_1_2(14) <= cut_column_1_2_15;
            a_column_1_2(15) <= cut_column_1_2_16;
            -- Data of third column: First square
            a_column_1_3(0)  <= cut_column_1_3_1;
            a_column_1_3(1)  <= cut_column_1_3_2;
            a_column_1_3(2)  <= cut_column_1_3_3;
            a_column_1_3(3)  <= cut_column_1_3_4;
            a_column_1_3(4)  <= cut_column_1_3_5;
            a_column_1_3(5)  <= cut_column_1_3_6;
            a_column_1_3(6)  <= cut_column_1_3_7;
            a_column_1_3(7)  <= cut_column_1_3_8;
            a_column_1_3(8)  <= cut_column_1_3_9;
            a_column_1_3(9)  <= cut_column_1_3_10;
            a_column_1_3(10) <= cut_column_1_3_11;
            a_column_1_3(11) <= cut_column_1_3_12;
            a_column_1_3(12) <= cut_column_1_3_13;
            a_column_1_3(13) <= cut_column_1_3_14;
            a_column_1_3(14) <= cut_column_1_3_15;
            a_column_1_3(15) <= cut_column_1_3_16;
            -- Data of fourth column: First square
            a_column_1_4(0)  <= cut_column_1_4_1;
            a_column_1_4(1)  <= cut_column_1_4_2;
            a_column_1_4(2)  <= cut_column_1_4_3;
            a_column_1_4(3)  <= cut_column_1_4_4;
            a_column_1_4(4)  <= cut_column_1_4_5;
            a_column_1_4(5)  <= cut_column_1_4_6;
            a_column_1_4(6)  <= cut_column_1_4_7;
            a_column_1_4(7)  <= cut_column_1_4_8;
            a_column_1_4(8)  <= cut_column_1_4_9;
            a_column_1_4(9)  <= cut_column_1_4_10;
            a_column_1_4(10) <= cut_column_1_4_11;
            a_column_1_4(11) <= cut_column_1_4_12;
            a_column_1_4(12) <= cut_column_1_4_13;
            a_column_1_4(13) <= cut_column_1_4_14;
            a_column_1_4(14) <= cut_column_1_4_15;
            a_column_1_4(15) <= cut_column_1_4_16;
            -- Data of fifth column: First square
            a_column_1_5(0)  <= cut_column_1_5_1;
            a_column_1_5(1)  <= cut_column_1_5_2;
            a_column_1_5(2)  <= cut_column_1_5_3;
            a_column_1_5(3)  <= cut_column_1_5_4;
            a_column_1_5(4)  <= cut_column_1_5_5;
            a_column_1_5(5)  <= cut_column_1_5_6;
            a_column_1_5(6)  <= cut_column_1_5_7;
            a_column_1_5(7)  <= cut_column_1_5_8;
            a_column_1_5(8)  <= cut_column_1_5_9;
            a_column_1_5(9)  <= cut_column_1_5_10;
            a_column_1_5(10) <= cut_column_1_5_11;
            a_column_1_5(11) <= cut_column_1_5_12;
            a_column_1_5(12) <= cut_column_1_5_13;
            a_column_1_5(13) <= cut_column_1_5_14;
            a_column_1_5(14) <= cut_column_1_5_15;
            a_column_1_5(15) <= cut_column_1_5_16;
            -- Data of sixth column: First square
            a_column_1_6(0)  <= cut_column_1_6_1;
            a_column_1_6(1)  <= cut_column_1_6_2;
            a_column_1_6(2)  <= cut_column_1_6_3;
            a_column_1_6(3)  <= cut_column_1_6_4;
            a_column_1_6(4)  <= cut_column_1_6_5;
            a_column_1_6(5)  <= cut_column_1_6_6;
            a_column_1_6(6)  <= cut_column_1_6_7;
            a_column_1_6(7)  <= cut_column_1_6_8;
            a_column_1_6(8)  <= cut_column_1_6_9;
            a_column_1_6(9)  <= cut_column_1_6_10;
            a_column_1_6(10) <= cut_column_1_6_11;
            a_column_1_6(11) <= cut_column_1_6_12;
            a_column_1_6(12) <= cut_column_1_6_13;
            a_column_1_6(13) <= cut_column_1_6_14;
            a_column_1_6(14) <= cut_column_1_6_15;
            a_column_1_6(15) <= cut_column_1_6_16;
            -- Data of seventh column: First square
            a_column_1_7(0)  <= cut_column_1_7_1;
            a_column_1_7(1)  <= cut_column_1_7_2;
            a_column_1_7(2)  <= cut_column_1_7_3;
            a_column_1_7(3)  <= cut_column_1_7_4;
            a_column_1_7(4)  <= cut_column_1_7_5;
            a_column_1_7(5)  <= cut_column_1_7_6;
            a_column_1_7(6)  <= cut_column_1_7_7;
            a_column_1_7(7)  <= cut_column_1_7_8;
            a_column_1_7(8)  <= cut_column_1_7_9;
            a_column_1_7(9)  <= cut_column_1_7_10;
            a_column_1_7(10) <= cut_column_1_7_11;
            a_column_1_7(11) <= cut_column_1_7_12;
            a_column_1_7(12) <= cut_column_1_7_13;
            a_column_1_7(13) <= cut_column_1_7_14;
            a_column_1_7(14) <= cut_column_1_7_15;
            a_column_1_7(15) <= cut_column_1_7_16;
            -- Data of eighth column: First square
            a_column_1_8(0)  <= cut_column_1_8_1;
            a_column_1_8(1)  <= cut_column_1_8_2;
            a_column_1_8(2)  <= cut_column_1_8_3;
            a_column_1_8(3)  <= cut_column_1_8_4;
            a_column_1_8(4)  <= cut_column_1_8_5;
            a_column_1_8(5)  <= cut_column_1_8_6;
            a_column_1_8(6)  <= cut_column_1_8_7;
            a_column_1_8(7)  <= cut_column_1_8_8;
            a_column_1_8(8)  <= cut_column_1_8_9;
            a_column_1_8(9)  <= cut_column_1_8_10;
            a_column_1_8(10) <= cut_column_1_8_11;
            a_column_1_8(11) <= cut_column_1_8_12;
            a_column_1_8(12) <= cut_column_1_8_13;
            a_column_1_8(13) <= cut_column_1_8_14;
            a_column_1_8(14) <= cut_column_1_8_15;
            a_column_1_8(15) <= cut_column_1_8_16;
            -- Data of ninth column: First square
            a_column_1_9(0)  <= cut_column_1_9_1;
            a_column_1_9(1)  <= cut_column_1_9_2;
            a_column_1_9(2)  <= cut_column_1_9_3;
            a_column_1_9(3)  <= cut_column_1_9_4;
            a_column_1_9(4)  <= cut_column_1_9_5;
            a_column_1_9(5)  <= cut_column_1_9_6;
            a_column_1_9(6)  <= cut_column_1_9_7;
            a_column_1_9(7)  <= cut_column_1_9_8;
            a_column_1_9(8)  <= cut_column_1_9_9;
            a_column_1_9(9)  <= cut_column_1_9_10;
            a_column_1_9(10) <= cut_column_1_9_11;
            a_column_1_9(11) <= cut_column_1_9_12;
            a_column_1_9(12) <= cut_column_1_9_13;
            a_column_1_9(13) <= cut_column_1_9_14;
            a_column_1_9(14) <= cut_column_1_9_15;
            a_column_1_9(15) <= cut_column_1_9_16;
            -- Data of tenth column: First square
            a_column_1_10(0)  <= cut_column_1_10_1;
            a_column_1_10(1)  <= cut_column_1_10_2;
            a_column_1_10(2)  <= cut_column_1_10_3;
            a_column_1_10(3)  <= cut_column_1_10_4;
            a_column_1_10(4)  <= cut_column_1_10_5;
            a_column_1_10(5)  <= cut_column_1_10_6;
            a_column_1_10(6)  <= cut_column_1_10_7;
            a_column_1_10(7)  <= cut_column_1_10_8;
            a_column_1_10(8)  <= cut_column_1_10_9;
            a_column_1_10(9)  <= cut_column_1_10_10;
            a_column_1_10(10) <= cut_column_1_10_11;
            a_column_1_10(11) <= cut_column_1_10_12;
            a_column_1_10(12) <= cut_column_1_10_13;
            a_column_1_10(13) <= cut_column_1_10_14;
            a_column_1_10(14) <= cut_column_1_10_15;
            a_column_1_10(15) <= cut_column_1_10_16;
            -- Data of eleventh column: First square
            a_column_1_11(0)  <= cut_column_1_11_1;
            a_column_1_11(1)  <= cut_column_1_11_2;
            a_column_1_11(2)  <= cut_column_1_11_3;
            a_column_1_11(3)  <= cut_column_1_11_4;
            a_column_1_11(4)  <= cut_column_1_11_5;
            a_column_1_11(5)  <= cut_column_1_11_6;
            a_column_1_11(6)  <= cut_column_1_11_7;
            a_column_1_11(7)  <= cut_column_1_11_8;
            a_column_1_11(8)  <= cut_column_1_11_9;
            a_column_1_11(9)  <= cut_column_1_11_10;
            a_column_1_11(10) <= cut_column_1_11_11;
            a_column_1_11(11) <= cut_column_1_11_12;
            a_column_1_11(12) <= cut_column_1_11_13;
            a_column_1_11(13) <= cut_column_1_11_14;
            a_column_1_11(14) <= cut_column_1_11_15;
            a_column_1_11(15) <= cut_column_1_11_16;
            -- Data of twelveth column: First square
            a_column_1_12(0)  <= cut_column_1_12_1;
            a_column_1_12(1)  <= cut_column_1_12_2;
            a_column_1_12(2)  <= cut_column_1_12_3;
            a_column_1_12(3)  <= cut_column_1_12_4;
            a_column_1_12(4)  <= cut_column_1_12_5;
            a_column_1_12(5)  <= cut_column_1_12_6;
            a_column_1_12(6)  <= cut_column_1_12_7;
            a_column_1_12(7)  <= cut_column_1_12_8;
            a_column_1_12(8)  <= cut_column_1_12_9;
            a_column_1_12(9)  <= cut_column_1_12_10;
            a_column_1_12(10) <= cut_column_1_12_11;
            a_column_1_12(11) <= cut_column_1_12_12;
            a_column_1_12(12) <= cut_column_1_12_13;
            a_column_1_12(13) <= cut_column_1_12_14;
            a_column_1_12(14) <= cut_column_1_12_15;
            a_column_1_12(15) <= cut_column_1_12_16;
            -- Data of thirteenth column: First square
            a_column_1_13(0)  <= cut_column_1_13_1;
            a_column_1_13(1)  <= cut_column_1_13_2;
            a_column_1_13(2)  <= cut_column_1_13_3;
            a_column_1_13(3)  <= cut_column_1_13_4;
            a_column_1_13(4)  <= cut_column_1_13_5;
            a_column_1_13(5)  <= cut_column_1_13_6;
            a_column_1_13(6)  <= cut_column_1_13_7;
            a_column_1_13(7)  <= cut_column_1_13_8;
            a_column_1_13(8)  <= cut_column_1_13_9;
            a_column_1_13(9)  <= cut_column_1_13_10;
            a_column_1_13(10) <= cut_column_1_13_11;
            a_column_1_13(11) <= cut_column_1_13_12;
            a_column_1_13(12) <= cut_column_1_13_13;
            a_column_1_13(13) <= cut_column_1_13_14;
            a_column_1_13(14) <= cut_column_1_13_15;
            a_column_1_13(15) <= cut_column_1_13_16;
            -- Data of fourteenth column: First square
            a_column_1_14(0)  <= cut_column_1_14_1;
            a_column_1_14(1)  <= cut_column_1_14_2;
            a_column_1_14(2)  <= cut_column_1_14_3;
            a_column_1_14(3)  <= cut_column_1_14_4;
            a_column_1_14(4)  <= cut_column_1_14_5;
            a_column_1_14(5)  <= cut_column_1_14_6;
            a_column_1_14(6)  <= cut_column_1_14_7;
            a_column_1_14(7)  <= cut_column_1_14_8;
            a_column_1_14(8)  <= cut_column_1_14_9;
            a_column_1_14(9)  <= cut_column_1_14_10;
            a_column_1_14(10) <= cut_column_1_14_11;
            a_column_1_14(11) <= cut_column_1_14_12;
            a_column_1_14(12) <= cut_column_1_14_13;
            a_column_1_14(13) <= cut_column_1_14_14;
            a_column_1_14(14) <= cut_column_1_14_15;
            a_column_1_14(15) <= cut_column_1_14_16;
            -- Data of fifteenth column: First square
            a_column_1_15(0)  <= cut_column_1_15_1;
            a_column_1_15(1)  <= cut_column_1_15_2;
            a_column_1_15(2)  <= cut_column_1_15_3;
            a_column_1_15(3)  <= cut_column_1_15_4;
            a_column_1_15(4)  <= cut_column_1_15_5;
            a_column_1_15(5)  <= cut_column_1_15_6;
            a_column_1_15(6)  <= cut_column_1_15_7;
            a_column_1_15(7)  <= cut_column_1_15_8;
            a_column_1_15(8)  <= cut_column_1_15_9;
            a_column_1_15(9)  <= cut_column_1_15_10;
            a_column_1_15(10) <= cut_column_1_15_11;
            a_column_1_15(11) <= cut_column_1_15_12;
            a_column_1_15(12) <= cut_column_1_15_13;
            a_column_1_15(13) <= cut_column_1_15_14;
            a_column_1_15(14) <= cut_column_1_15_15;
            a_column_1_15(15) <= cut_column_1_15_16;
            -- Data of sixteenth column: First square
            a_column_1_16(0)  <= cut_column_1_16_1;
            a_column_1_16(1)  <= cut_column_1_16_2;
            a_column_1_16(2)  <= cut_column_1_16_3;
            a_column_1_16(3)  <= cut_column_1_16_4;
            a_column_1_16(4)  <= cut_column_1_16_5;
            a_column_1_16(5)  <= cut_column_1_16_6;
            a_column_1_16(6)  <= cut_column_1_16_7;
            a_column_1_16(7)  <= cut_column_1_16_8;
            a_column_1_16(8)  <= cut_column_1_16_9;
            a_column_1_16(9)  <= cut_column_1_16_10;
            a_column_1_16(10) <= cut_column_1_16_11;
            a_column_1_16(11) <= cut_column_1_16_12;
            a_column_1_16(12) <= cut_column_1_16_13;
            a_column_1_16(13) <= cut_column_1_16_14;
            a_column_1_16(14) <= cut_column_1_16_15;
            a_column_1_16(15) <= cut_column_1_16_16;
            -- Data of first column: Second square
            a_column_2_1(0)  <= cut_column_2_1_1;
            a_column_2_1(1)  <= cut_column_2_1_2;
            a_column_2_1(2)  <= cut_column_2_1_3;
            a_column_2_1(3)  <= cut_column_2_1_4;
            a_column_2_1(4)  <= cut_column_2_1_5;
            a_column_2_1(5)  <= cut_column_2_1_6;
            a_column_2_1(6)  <= cut_column_2_1_7;
            a_column_2_1(7)  <= cut_column_2_1_8;
            a_column_2_1(8)  <= cut_column_2_1_9;
            a_column_2_1(9)  <= cut_column_2_1_10;
            a_column_2_1(10) <= cut_column_2_1_11;
            a_column_2_1(11) <= cut_column_2_1_12;
            a_column_2_1(12) <= cut_column_2_1_13;
            a_column_2_1(13) <= cut_column_2_1_14;
            a_column_2_1(14) <= cut_column_2_1_15;
            a_column_2_1(15) <= cut_column_2_1_16;
            -- Data of second column: Second square
            a_column_2_2(0)  <= cut_column_2_2_1;
            a_column_2_2(1)  <= cut_column_2_2_2;
            a_column_2_2(2)  <= cut_column_2_2_3;
            a_column_2_2(3)  <= cut_column_2_2_4;
            a_column_2_2(4)  <= cut_column_2_2_5;
            a_column_2_2(5)  <= cut_column_2_2_6;
            a_column_2_2(6)  <= cut_column_2_2_7;
            a_column_2_2(7)  <= cut_column_2_2_8;
            a_column_2_2(8)  <= cut_column_2_2_9;
            a_column_2_2(9)  <= cut_column_2_2_10;
            a_column_2_2(10) <= cut_column_2_2_11;
            a_column_2_2(11) <= cut_column_2_2_12;
            a_column_2_2(12) <= cut_column_2_2_13;
            a_column_2_2(13) <= cut_column_2_2_14;
            a_column_2_2(14) <= cut_column_2_2_15;
            a_column_2_2(15) <= cut_column_2_2_16;
            -- Data of third column: Second square
            a_column_2_3(0)  <= cut_column_2_3_1;
            a_column_2_3(1)  <= cut_column_2_3_2;
            a_column_2_3(2)  <= cut_column_2_3_3;
            a_column_2_3(3)  <= cut_column_2_3_4;
            a_column_2_3(4)  <= cut_column_2_3_5;
            a_column_2_3(5)  <= cut_column_2_3_6;
            a_column_2_3(6)  <= cut_column_2_3_7;
            a_column_2_3(7)  <= cut_column_2_3_8;
            a_column_2_3(8)  <= cut_column_2_3_9;
            a_column_2_3(9)  <= cut_column_2_3_10;
            a_column_2_3(10) <= cut_column_2_3_11;
            a_column_2_3(11) <= cut_column_2_3_12;
            a_column_2_3(12) <= cut_column_2_3_13;
            a_column_2_3(13) <= cut_column_2_3_14;
            a_column_2_3(14) <= cut_column_2_3_15;
            a_column_2_3(15) <= cut_column_2_3_16;
            -- Data of fourth column: Second square
            a_column_2_4(0)  <= cut_column_2_4_1;
            a_column_2_4(1)  <= cut_column_2_4_2;
            a_column_2_4(2)  <= cut_column_2_4_3;
            a_column_2_4(3)  <= cut_column_2_4_4;
            a_column_2_4(4)  <= cut_column_2_4_5;
            a_column_2_4(5)  <= cut_column_2_4_6;
            a_column_2_4(6)  <= cut_column_2_4_7;
            a_column_2_4(7)  <= cut_column_2_4_8;
            a_column_2_4(8)  <= cut_column_2_4_9;
            a_column_2_4(9)  <= cut_column_2_4_10;
            a_column_2_4(10) <= cut_column_2_4_11;
            a_column_2_4(11) <= cut_column_2_4_12;
            a_column_2_4(12) <= cut_column_2_4_13;
            a_column_2_4(13) <= cut_column_2_4_14;
            a_column_2_4(14) <= cut_column_2_4_15;
            a_column_2_4(15) <= cut_column_2_4_16;
            -- Data of fifth column: Second square
            a_column_2_5(0)  <= cut_column_2_5_1;
            a_column_2_5(1)  <= cut_column_2_5_2;
            a_column_2_5(2)  <= cut_column_2_5_3;
            a_column_2_5(3)  <= cut_column_2_5_4;
            a_column_2_5(4)  <= cut_column_2_5_5;
            a_column_2_5(5)  <= cut_column_2_5_6;
            a_column_2_5(6)  <= cut_column_2_5_7;
            a_column_2_5(7)  <= cut_column_2_5_8;
            a_column_2_5(8)  <= cut_column_2_5_9;
            a_column_2_5(9)  <= cut_column_2_5_10;
            a_column_2_5(10) <= cut_column_2_5_11;
            a_column_2_5(11) <= cut_column_2_5_12;
            a_column_2_5(12) <= cut_column_2_5_13;
            a_column_2_5(13) <= cut_column_2_5_14;
            a_column_2_5(14) <= cut_column_2_5_15;
            a_column_2_5(15) <= cut_column_2_5_16;
            -- Data of sixth column: Second square
            a_column_2_6(0)  <= cut_column_2_6_1;
            a_column_2_6(1)  <= cut_column_2_6_2;
            a_column_2_6(2)  <= cut_column_2_6_3;
            a_column_2_6(3)  <= cut_column_2_6_4;
            a_column_2_6(4)  <= cut_column_2_6_5;
            a_column_2_6(5)  <= cut_column_2_6_6;
            a_column_2_6(6)  <= cut_column_2_6_7;
            a_column_2_6(7)  <= cut_column_2_6_8;
            a_column_2_6(8)  <= cut_column_2_6_9;
            a_column_2_6(9)  <= cut_column_2_6_10;
            a_column_2_6(10) <= cut_column_2_6_11;
            a_column_2_6(11) <= cut_column_2_6_12;
            a_column_2_6(12) <= cut_column_2_6_13;
            a_column_2_6(13) <= cut_column_2_6_14;
            a_column_2_6(14) <= cut_column_2_6_15;
            a_column_2_6(15) <= cut_column_2_6_16;
            -- Data of seventh column: Second square
            a_column_2_7(0)  <= cut_column_2_7_1;
            a_column_2_7(1)  <= cut_column_2_7_2;
            a_column_2_7(2)  <= cut_column_2_7_3;
            a_column_2_7(3)  <= cut_column_2_7_4;
            a_column_2_7(4)  <= cut_column_2_7_5;
            a_column_2_7(5)  <= cut_column_2_7_6;
            a_column_2_7(6)  <= cut_column_2_7_7;
            a_column_2_7(7)  <= cut_column_2_7_8;
            a_column_2_7(8)  <= cut_column_2_7_9;
            a_column_2_7(9)  <= cut_column_2_7_10;
            a_column_2_7(10) <= cut_column_2_7_11;
            a_column_2_7(11) <= cut_column_2_7_12;
            a_column_2_7(12) <= cut_column_2_7_13;
            a_column_2_7(13) <= cut_column_2_7_14;
            a_column_2_7(14) <= cut_column_2_7_15;
            a_column_2_7(15) <= cut_column_2_7_16;
            -- Data of eighth column: Second square
            a_column_2_8(0)  <= cut_column_2_8_1;
            a_column_2_8(1)  <= cut_column_2_8_2;
            a_column_2_8(2)  <= cut_column_2_8_3;
            a_column_2_8(3)  <= cut_column_2_8_4;
            a_column_2_8(4)  <= cut_column_2_8_5;
            a_column_2_8(5)  <= cut_column_2_8_6;
            a_column_2_8(6)  <= cut_column_2_8_7;
            a_column_2_8(7)  <= cut_column_2_8_8;
            a_column_2_8(8)  <= cut_column_2_8_9;
            a_column_2_8(9)  <= cut_column_2_8_10;
            a_column_2_8(10) <= cut_column_2_8_11;
            a_column_2_8(11) <= cut_column_2_8_12;
            a_column_2_8(12) <= cut_column_2_8_13;
            a_column_2_8(13) <= cut_column_2_8_14;
            a_column_2_8(14) <= cut_column_2_8_15;
            a_column_2_8(15) <= cut_column_2_8_16;
            -- Data of ninth column: Second square
            a_column_2_9(0)  <= cut_column_2_9_1;
            a_column_2_9(1)  <= cut_column_2_9_2;
            a_column_2_9(2)  <= cut_column_2_9_3;
            a_column_2_9(3)  <= cut_column_2_9_4;
            a_column_2_9(4)  <= cut_column_2_9_5;
            a_column_2_9(5)  <= cut_column_2_9_6;
            a_column_2_9(6)  <= cut_column_2_9_7;
            a_column_2_9(7)  <= cut_column_2_9_8;
            a_column_2_9(8)  <= cut_column_2_9_9;
            a_column_2_9(9)  <= cut_column_2_9_10;
            a_column_2_9(10) <= cut_column_2_9_11;
            a_column_2_9(11) <= cut_column_2_9_12;
            a_column_2_9(12) <= cut_column_2_9_13;
            a_column_2_9(13) <= cut_column_2_9_14;
            a_column_2_9(14) <= cut_column_2_9_15;
            a_column_2_9(15) <= cut_column_2_9_16;
            -- Data of tenth column: Second square
            a_column_2_10(0)  <= cut_column_2_10_1;
            a_column_2_10(1)  <= cut_column_2_10_2;
            a_column_2_10(2)  <= cut_column_2_10_3;
            a_column_2_10(3)  <= cut_column_2_10_4;
            a_column_2_10(4)  <= cut_column_2_10_5;
            a_column_2_10(5)  <= cut_column_2_10_6;
            a_column_2_10(6)  <= cut_column_2_10_7;
            a_column_2_10(7)  <= cut_column_2_10_8;
            a_column_2_10(8)  <= cut_column_2_10_9;
            a_column_2_10(9)  <= cut_column_2_10_10;
            a_column_2_10(10) <= cut_column_2_10_11;
            a_column_2_10(11) <= cut_column_2_10_12;
            a_column_2_10(12) <= cut_column_2_10_13;
            a_column_2_10(13) <= cut_column_2_10_14;
            a_column_2_10(14) <= cut_column_2_10_15;
            a_column_2_10(15) <= cut_column_2_10_16;
            -- Data of eleventh column: Second square
            a_column_2_11(0)  <= cut_column_2_11_1;
            a_column_2_11(1)  <= cut_column_2_11_2;
            a_column_2_11(2)  <= cut_column_2_11_3;
            a_column_2_11(3)  <= cut_column_2_11_4;
            a_column_2_11(4)  <= cut_column_2_11_5;
            a_column_2_11(5)  <= cut_column_2_11_6;
            a_column_2_11(6)  <= cut_column_2_11_7;
            a_column_2_11(7)  <= cut_column_2_11_8;
            a_column_2_11(8)  <= cut_column_2_11_9;
            a_column_2_11(9)  <= cut_column_2_11_10;
            a_column_2_11(10) <= cut_column_2_11_11;
            a_column_2_11(11) <= cut_column_2_11_12;
            a_column_2_11(12) <= cut_column_2_11_13;
            a_column_2_11(13) <= cut_column_2_11_14;
            a_column_2_11(14) <= cut_column_2_11_15;
            a_column_2_11(15) <= cut_column_2_11_16;
            -- Data of twelveth column: Second square
            a_column_2_12(0)  <= cut_column_2_12_1;
            a_column_2_12(1)  <= cut_column_2_12_2;
            a_column_2_12(2)  <= cut_column_2_12_3;
            a_column_2_12(3)  <= cut_column_2_12_4;
            a_column_2_12(4)  <= cut_column_2_12_5;
            a_column_2_12(5)  <= cut_column_2_12_6;
            a_column_2_12(6)  <= cut_column_2_12_7;
            a_column_2_12(7)  <= cut_column_2_12_8;
            a_column_2_12(8)  <= cut_column_2_12_9;
            a_column_2_12(9)  <= cut_column_2_12_10;
            a_column_2_12(10) <= cut_column_2_12_11;
            a_column_2_12(11) <= cut_column_2_12_12;
            a_column_2_12(12) <= cut_column_2_12_13;
            a_column_2_12(13) <= cut_column_2_12_14;
            a_column_2_12(14) <= cut_column_2_12_15;
            a_column_2_12(15) <= cut_column_2_12_16;
            -- Data of thirteenth column: Second square
            a_column_2_13(0)  <= cut_column_2_13_1;
            a_column_2_13(1)  <= cut_column_2_13_2;
            a_column_2_13(2)  <= cut_column_2_13_3;
            a_column_2_13(3)  <= cut_column_2_13_4;
            a_column_2_13(4)  <= cut_column_2_13_5;
            a_column_2_13(5)  <= cut_column_2_13_6;
            a_column_2_13(6)  <= cut_column_2_13_7;
            a_column_2_13(7)  <= cut_column_2_13_8;
            a_column_2_13(8)  <= cut_column_2_13_9;
            a_column_2_13(9)  <= cut_column_2_13_10;
            a_column_2_13(10) <= cut_column_2_13_11;
            a_column_2_13(11) <= cut_column_2_13_12;
            a_column_2_13(12) <= cut_column_2_13_13;
            a_column_2_13(13) <= cut_column_2_13_14;
            a_column_2_13(14) <= cut_column_2_13_15;
            a_column_2_13(15) <= cut_column_2_13_16;
            -- Data of fourteenth column: Second square
            a_column_2_14(0)  <= cut_column_2_14_1;
            a_column_2_14(1)  <= cut_column_2_14_2;
            a_column_2_14(2)  <= cut_column_2_14_3;
            a_column_2_14(3)  <= cut_column_2_14_4;
            a_column_2_14(4)  <= cut_column_2_14_5;
            a_column_2_14(5)  <= cut_column_2_14_6;
            a_column_2_14(6)  <= cut_column_2_14_7;
            a_column_2_14(7)  <= cut_column_2_14_8;
            a_column_2_14(8)  <= cut_column_2_14_9;
            a_column_2_14(9)  <= cut_column_2_14_10;
            a_column_2_14(10) <= cut_column_2_14_11;
            a_column_2_14(11) <= cut_column_2_14_12;
            a_column_2_14(12) <= cut_column_2_14_13;
            a_column_2_14(13) <= cut_column_2_14_14;
            a_column_2_14(14) <= cut_column_2_14_15;
            a_column_2_14(15) <= cut_column_2_14_16;
            -- Data of fifteenth column: Second square
            a_column_2_15(0)  <= cut_column_2_15_1;
            a_column_2_15(1)  <= cut_column_2_15_2;
            a_column_2_15(2)  <= cut_column_2_15_3;
            a_column_2_15(3)  <= cut_column_2_15_4;
            a_column_2_15(4)  <= cut_column_2_15_5;
            a_column_2_15(5)  <= cut_column_2_15_6;
            a_column_2_15(6)  <= cut_column_2_15_7;
            a_column_2_15(7)  <= cut_column_2_15_8;
            a_column_2_15(8)  <= cut_column_2_15_9;
            a_column_2_15(9)  <= cut_column_2_15_10;
            a_column_2_15(10) <= cut_column_2_15_11;
            a_column_2_15(11) <= cut_column_2_15_12;
            a_column_2_15(12) <= cut_column_2_15_13;
            a_column_2_15(13) <= cut_column_2_15_14;
            a_column_2_15(14) <= cut_column_2_15_15;
            a_column_2_15(15) <= cut_column_2_15_16;
            -- Data of sixteenth column: Second square
            a_column_2_16(0)  <= cut_column_2_16_1;
            a_column_2_16(1)  <= cut_column_2_16_2;
            a_column_2_16(2)  <= cut_column_2_16_3;
            a_column_2_16(3)  <= cut_column_2_16_4;
            a_column_2_16(4)  <= cut_column_2_16_5;
            a_column_2_16(5)  <= cut_column_2_16_6;
            a_column_2_16(6)  <= cut_column_2_16_7;
            a_column_2_16(7)  <= cut_column_2_16_8;
            a_column_2_16(8)  <= cut_column_2_16_9;
            a_column_2_16(9)  <= cut_column_2_16_10;
            a_column_2_16(10) <= cut_column_2_16_11;
            a_column_2_16(11) <= cut_column_2_16_12;
            a_column_2_16(12) <= cut_column_2_16_13;
            a_column_2_16(13) <= cut_column_2_16_14;
            a_column_2_16(14) <= cut_column_2_16_15;
            a_column_2_16(15) <= cut_column_2_16_16;
        end if;
    end process;
    -------------------------------------------------------------
    -- Process 5 : Assamble the Columns together stage 2
    -------------------------------------------------------------
    process (clk, reset)
    begin
        if (reset = '1') then

        elsif (rising_edge(clk)) then
            -- assamble the columns together
            -- Channel data
            delay_1_input_data_channel_r1  <= delay_input_data_channel_r1;
            delay_1_input_data_channel_r2  <= delay_input_data_channel_r2;
            delay_1_input_data_channel_r3  <= delay_input_data_channel_r3;
            delay_1_input_data_channel_r4  <= delay_input_data_channel_r4;
            delay_1_input_data_channel_r5  <= delay_input_data_channel_r5;
            delay_1_input_data_channel_r6  <= delay_input_data_channel_r6;
            delay_1_input_data_channel_r7  <= delay_input_data_channel_r7;
            delay_1_input_data_channel_r8  <= delay_input_data_channel_r8;
            delay_1_input_data_channel_r9  <= delay_input_data_channel_r9;
            delay_1_input_data_channel_r10 <= delay_input_data_channel_r10;
            delay_1_input_data_channel_r11 <= delay_input_data_channel_r11;
            delay_1_input_data_channel_r12 <= delay_input_data_channel_r12;
            delay_1_input_data_channel_r13 <= delay_input_data_channel_r13;
            delay_1_input_data_channel_r14 <= delay_input_data_channel_r14;
            delay_1_input_data_channel_r15 <= delay_input_data_channel_r15;
            delay_1_input_data_channel_r16 <= delay_input_data_channel_r16;
            -- first square and second square
            connected_column_1  <= a_column_1_1 & a_column_2_1;
            connected_column_2  <= a_column_1_2 & a_column_2_2;
            connected_column_3  <= a_column_1_3 & a_column_2_3;
            connected_column_4  <= a_column_1_4 & a_column_2_4;
            connected_column_5  <= a_column_1_5 & a_column_2_5;
            connected_column_6  <= a_column_1_6 & a_column_2_6;
            connected_column_7  <= a_column_1_7 & a_column_2_7;
            connected_column_8  <= a_column_1_8 & a_column_2_8;
            connected_column_9  <= a_column_1_9 & a_column_2_9;
            connected_column_10 <= a_column_1_10 & a_column_2_10;
            connected_column_11 <= a_column_1_11 & a_column_2_11;
            connected_column_12 <= a_column_1_12 & a_column_2_12;
            connected_column_13 <= a_column_1_13 & a_column_2_13;
            connected_column_14 <= a_column_1_14 & a_column_2_14;
            connected_column_15 <= a_column_1_15 & a_column_2_15;
            connected_column_16 <= a_column_1_16 & a_column_2_16;
        end if;
    end process;
    -------------------------------------------------------------
    -- Process 6 : Wait until all the columns are ready...
    -------------------------------------------------------------
    process (clk, reset)
    begin
        if (reset = '1') then

        elsif (rising_edge(clk)) then
            -- Channel Data
            delay_2_input_data_channel_r1  <= delay_1_input_data_channel_r1;
            delay_2_input_data_channel_r2  <= delay_1_input_data_channel_r2;
            delay_2_input_data_channel_r3  <= delay_1_input_data_channel_r3;
            delay_2_input_data_channel_r4  <= delay_1_input_data_channel_r4;
            delay_2_input_data_channel_r5  <= delay_1_input_data_channel_r5;
            delay_2_input_data_channel_r6  <= delay_1_input_data_channel_r6;
            delay_2_input_data_channel_r7  <= delay_1_input_data_channel_r7;
            delay_2_input_data_channel_r8  <= delay_1_input_data_channel_r8;
            delay_2_input_data_channel_r9  <= delay_1_input_data_channel_r9;
            delay_2_input_data_channel_r10 <= delay_1_input_data_channel_r10;
            delay_2_input_data_channel_r11 <= delay_1_input_data_channel_r11;
            delay_2_input_data_channel_r12 <= delay_1_input_data_channel_r12;
            delay_2_input_data_channel_r13 <= delay_1_input_data_channel_r13;
            delay_2_input_data_channel_r14 <= delay_1_input_data_channel_r14;
            delay_2_input_data_channel_r15 <= delay_1_input_data_channel_r15;
            delay_2_input_data_channel_r16 <= delay_1_input_data_channel_r16;

            -- Memory Data
            temp_1_connected_column_1  <= connected_column_1; -- Delay first and second square
            temp_1_connected_column_2  <= connected_column_2;
            temp_1_connected_column_3  <= connected_column_3;
            temp_1_connected_column_4  <= connected_column_4;
            temp_1_connected_column_5  <= connected_column_5;
            temp_1_connected_column_6  <= connected_column_6;
            temp_1_connected_column_7  <= connected_column_7;
            temp_1_connected_column_8  <= connected_column_8;
            temp_1_connected_column_9  <= connected_column_9;
            temp_1_connected_column_10 <= connected_column_10;
            temp_1_connected_column_11 <= connected_column_11;
            temp_1_connected_column_12 <= connected_column_12;
            temp_1_connected_column_13 <= connected_column_13;
            temp_1_connected_column_14 <= connected_column_14;
            temp_1_connected_column_15 <= connected_column_15;
            temp_1_connected_column_16 <= connected_column_16;
        end if;
    end process;
    -------------------------------------------------------------
    -- Process 7 : Wait until all the columns are ready...
    -------------------------------------------------------------
    process (clk, reset)
    begin
        if (reset = '1') then

        elsif (rising_edge(clk)) then
            -- Channel Data
            delay_3_input_data_channel_r1  <= delay_2_input_data_channel_r1;
            delay_3_input_data_channel_r2  <= delay_2_input_data_channel_r2;
            delay_3_input_data_channel_r3  <= delay_2_input_data_channel_r3;
            delay_3_input_data_channel_r4  <= delay_2_input_data_channel_r4;
            delay_3_input_data_channel_r5  <= delay_2_input_data_channel_r5;
            delay_3_input_data_channel_r6  <= delay_2_input_data_channel_r6;
            delay_3_input_data_channel_r7  <= delay_2_input_data_channel_r7;
            delay_3_input_data_channel_r8  <= delay_2_input_data_channel_r8;
            delay_3_input_data_channel_r9  <= delay_2_input_data_channel_r9;
            delay_3_input_data_channel_r10 <= delay_2_input_data_channel_r10;
            delay_3_input_data_channel_r11 <= delay_2_input_data_channel_r11;
            delay_3_input_data_channel_r12 <= delay_2_input_data_channel_r12;
            delay_3_input_data_channel_r13 <= delay_2_input_data_channel_r13;
            delay_3_input_data_channel_r14 <= delay_2_input_data_channel_r14;
            delay_3_input_data_channel_r15 <= delay_2_input_data_channel_r15;
            delay_3_input_data_channel_r16 <= delay_2_input_data_channel_r16;

            -- Memory Data
            temp_2_connected_column_1  <= temp_1_connected_column_1;-- Delay first and second square
            temp_2_connected_column_2  <= temp_1_connected_column_2;
            temp_2_connected_column_3  <= temp_1_connected_column_3;
            temp_2_connected_column_4  <= temp_1_connected_column_4;
            temp_2_connected_column_5  <= temp_1_connected_column_5;
            temp_2_connected_column_6  <= temp_1_connected_column_6;
            temp_2_connected_column_7  <= temp_1_connected_column_7;
            temp_2_connected_column_8  <= temp_1_connected_column_8;
            temp_2_connected_column_9  <= temp_1_connected_column_9;
            temp_2_connected_column_10 <= temp_1_connected_column_10;
            temp_2_connected_column_11 <= temp_1_connected_column_11;
            temp_2_connected_column_12 <= temp_1_connected_column_12;
            temp_2_connected_column_13 <= temp_1_connected_column_13;
            temp_2_connected_column_14 <= temp_1_connected_column_14;
            temp_2_connected_column_15 <= temp_1_connected_column_15;
            temp_2_connected_column_16 <= temp_1_connected_column_16;
        end if;
    end process;
    -------------------------------------------------------------
    -- Process 8 : Wait until all the columns are ready...
    -------------------------------------------------------------
    process (clk, reset)
    begin
        if (reset = '1') then

        elsif (rising_edge(clk)) then
            -- Channel Data
            delay_4_input_data_channel_r1  <= delay_3_input_data_channel_r1;
            delay_4_input_data_channel_r2  <= delay_3_input_data_channel_r2;
            delay_4_input_data_channel_r3  <= delay_3_input_data_channel_r3;
            delay_4_input_data_channel_r4  <= delay_3_input_data_channel_r4;
            delay_4_input_data_channel_r5  <= delay_3_input_data_channel_r5;
            delay_4_input_data_channel_r6  <= delay_3_input_data_channel_r6;
            delay_4_input_data_channel_r7  <= delay_3_input_data_channel_r7;
            delay_4_input_data_channel_r8  <= delay_3_input_data_channel_r8;
            delay_4_input_data_channel_r9  <= delay_3_input_data_channel_r9;
            delay_4_input_data_channel_r10 <= delay_3_input_data_channel_r10;
            delay_4_input_data_channel_r11 <= delay_3_input_data_channel_r11;
            delay_4_input_data_channel_r12 <= delay_3_input_data_channel_r12;
            delay_4_input_data_channel_r13 <= delay_3_input_data_channel_r13;
            delay_4_input_data_channel_r14 <= delay_3_input_data_channel_r14;
            delay_4_input_data_channel_r15 <= delay_3_input_data_channel_r15;
            delay_4_input_data_channel_r16 <= delay_3_input_data_channel_r16;

            -- Memory Data
            temp_3_connected_column_1  <= temp_2_connected_column_1;-- Delay first and second square
            temp_3_connected_column_2  <= temp_2_connected_column_2;
            temp_3_connected_column_3  <= temp_2_connected_column_3;
            temp_3_connected_column_4  <= temp_2_connected_column_4;
            temp_3_connected_column_5  <= temp_2_connected_column_5;
            temp_3_connected_column_6  <= temp_2_connected_column_6;
            temp_3_connected_column_7  <= temp_2_connected_column_7;
            temp_3_connected_column_8  <= temp_2_connected_column_8;
            temp_3_connected_column_9  <= temp_2_connected_column_9;
            temp_3_connected_column_10 <= temp_2_connected_column_10;
            temp_3_connected_column_11 <= temp_2_connected_column_11;
            temp_3_connected_column_12 <= temp_2_connected_column_12;
            temp_3_connected_column_13 <= temp_2_connected_column_13;
            temp_3_connected_column_14 <= temp_2_connected_column_14;
            temp_3_connected_column_15 <= temp_2_connected_column_15;
            temp_3_connected_column_16 <= temp_2_connected_column_16;
        end if;
    end process;
    -------------------------------------------------------------
    -- Process 9 : Wait until all the columns are ready...
    -------------------------------------------------------------
    process (clk, reset)
    begin
        if (reset = '1') then

        elsif (rising_edge(clk)) then
            -- Channel Data
            delay_5_input_data_channel_r1  <= delay_4_input_data_channel_r1;
            delay_5_input_data_channel_r2  <= delay_4_input_data_channel_r2;
            delay_5_input_data_channel_r3  <= delay_4_input_data_channel_r3;
            delay_5_input_data_channel_r4  <= delay_4_input_data_channel_r4;
            delay_5_input_data_channel_r5  <= delay_4_input_data_channel_r5;
            delay_5_input_data_channel_r6  <= delay_4_input_data_channel_r6;
            delay_5_input_data_channel_r7  <= delay_4_input_data_channel_r7;
            delay_5_input_data_channel_r8  <= delay_4_input_data_channel_r8;
            delay_5_input_data_channel_r9  <= delay_4_input_data_channel_r9;
            delay_5_input_data_channel_r10 <= delay_4_input_data_channel_r10;
            delay_5_input_data_channel_r11 <= delay_4_input_data_channel_r11;
            delay_5_input_data_channel_r12 <= delay_4_input_data_channel_r12;
            delay_5_input_data_channel_r13 <= delay_4_input_data_channel_r13;
            delay_5_input_data_channel_r14 <= delay_4_input_data_channel_r14;
            delay_5_input_data_channel_r15 <= delay_4_input_data_channel_r15;
            delay_5_input_data_channel_r16 <= delay_4_input_data_channel_r16;

            -- Memory Data
            column_1  <= temp_3_connected_column_1 & temp_2_connected_column_1 & temp_1_connected_column_1 & connected_column_1; -- First half codeword is assambled
            column_2  <= temp_3_connected_column_2 & temp_2_connected_column_2 & temp_1_connected_column_2 & connected_column_2;
            column_3  <= temp_3_connected_column_3 & temp_2_connected_column_3 & temp_1_connected_column_3 & connected_column_3;
            column_4  <= temp_3_connected_column_4 & temp_2_connected_column_4 & temp_1_connected_column_4 & connected_column_4;
            column_5  <= temp_3_connected_column_5 & temp_2_connected_column_5 & temp_1_connected_column_5 & connected_column_5;
            column_6  <= temp_3_connected_column_6 & temp_2_connected_column_6 & temp_1_connected_column_6 & connected_column_6;
            column_7  <= temp_3_connected_column_7 & temp_2_connected_column_7 & temp_1_connected_column_7 & connected_column_7;
            column_8  <= temp_3_connected_column_8 & temp_2_connected_column_8 & temp_1_connected_column_8 & connected_column_8;
            column_9  <= temp_3_connected_column_9 & temp_2_connected_column_9 & temp_1_connected_column_9 & connected_column_9;
            column_10 <= temp_3_connected_column_10 & temp_2_connected_column_10 & temp_1_connected_column_10 & connected_column_10;
            column_11 <= temp_3_connected_column_11 & temp_2_connected_column_11 & temp_1_connected_column_11 & connected_column_11;
            column_12 <= temp_3_connected_column_12 & temp_2_connected_column_12 & temp_1_connected_column_12 & connected_column_12;
            column_13 <= temp_3_connected_column_13 & temp_2_connected_column_13 & temp_1_connected_column_13 & connected_column_13;
            column_14 <= temp_3_connected_column_14 & temp_2_connected_column_14 & temp_1_connected_column_14 & connected_column_14;
            column_15 <= temp_3_connected_column_15 & temp_2_connected_column_15 & temp_1_connected_column_15 & connected_column_15;
            column_16 <= temp_3_connected_column_16 & temp_2_connected_column_16 & temp_1_connected_column_16 & connected_column_16;
        end if;
    end process;
    -------------------------------------------------------------
    -- Process 10 : Wait until all the columns are ready...
    -------------------------------------------------------------
    process (clk, reset)
    begin
        if (reset = '1') then

        elsif (rising_edge(clk)) then
            -- Channel Data
            delay_6_input_data_channel_r1  <= delay_5_input_data_channel_r1;
            delay_6_input_data_channel_r2  <= delay_5_input_data_channel_r2;
            delay_6_input_data_channel_r3  <= delay_5_input_data_channel_r3;
            delay_6_input_data_channel_r4  <= delay_5_input_data_channel_r4;
            delay_6_input_data_channel_r5  <= delay_5_input_data_channel_r5;
            delay_6_input_data_channel_r6  <= delay_5_input_data_channel_r6;
            delay_6_input_data_channel_r7  <= delay_5_input_data_channel_r7;
            delay_6_input_data_channel_r8  <= delay_5_input_data_channel_r8;
            delay_6_input_data_channel_r9  <= delay_5_input_data_channel_r9;
            delay_6_input_data_channel_r10 <= delay_5_input_data_channel_r10;
            delay_6_input_data_channel_r11 <= delay_5_input_data_channel_r11;
            delay_6_input_data_channel_r12 <= delay_5_input_data_channel_r12;
            delay_6_input_data_channel_r13 <= delay_5_input_data_channel_r13;
            delay_6_input_data_channel_r14 <= delay_5_input_data_channel_r14;
            delay_6_input_data_channel_r15 <= delay_5_input_data_channel_r15;
            delay_6_input_data_channel_r16 <= delay_5_input_data_channel_r16;

            -- Memory Data
            delay_1_column_1  <= column_1;
            delay_1_column_2  <= column_2;
            delay_1_column_3  <= column_3;
            delay_1_column_4  <= column_4;
            delay_1_column_5  <= column_5;
            delay_1_column_6  <= column_6;
            delay_1_column_7  <= column_7;
            delay_1_column_8  <= column_8;
            delay_1_column_9  <= column_9;
            delay_1_column_10 <= column_10;
            delay_1_column_11 <= column_11;
            delay_1_column_12 <= column_12;
            delay_1_column_13 <= column_13;
            delay_1_column_14 <= column_14;
            delay_1_column_15 <= column_15;
            delay_1_column_16 <= column_16;
        end if;
    end process;
    -------------------------------------------------------------
    -- Process 11 : Wait until all the columns are ready...
    -------------------------------------------------------------
    process (clk, reset)
    begin
        if (reset = '1') then

        elsif (rising_edge(clk)) then
            -- Channel Data
            final_input_data_channel_r1  <= cut_input_data_channel_r1 & delay_input_data_channel_r1 & delay_1_input_data_channel_r1 & delay_2_input_data_channel_r1 & delay_3_input_data_channel_r1 & delay_4_input_data_channel_r1 & delay_5_input_data_channel_r1 & delay_6_input_data_channel_r1;
            final_input_data_channel_r2  <= cut_input_data_channel_r2 & delay_input_data_channel_r2 & delay_1_input_data_channel_r2 & delay_2_input_data_channel_r2 & delay_3_input_data_channel_r2 & delay_4_input_data_channel_r2 & delay_5_input_data_channel_r2 & delay_6_input_data_channel_r2;
            final_input_data_channel_r3  <= cut_input_data_channel_r3 & delay_input_data_channel_r3 & delay_1_input_data_channel_r3 & delay_2_input_data_channel_r3 & delay_3_input_data_channel_r3 & delay_4_input_data_channel_r3 & delay_5_input_data_channel_r3 & delay_6_input_data_channel_r3;
            final_input_data_channel_r4  <= cut_input_data_channel_r4 & delay_input_data_channel_r4 & delay_1_input_data_channel_r4 & delay_2_input_data_channel_r4 & delay_3_input_data_channel_r4 & delay_4_input_data_channel_r4 & delay_5_input_data_channel_r4 & delay_6_input_data_channel_r4;
            final_input_data_channel_r5  <= cut_input_data_channel_r5 & delay_input_data_channel_r5 & delay_1_input_data_channel_r5 & delay_2_input_data_channel_r5 & delay_3_input_data_channel_r5 & delay_4_input_data_channel_r5 & delay_5_input_data_channel_r5 & delay_6_input_data_channel_r5;
            final_input_data_channel_r6  <= cut_input_data_channel_r6 & delay_input_data_channel_r6 & delay_1_input_data_channel_r6 & delay_2_input_data_channel_r6 & delay_3_input_data_channel_r6 & delay_4_input_data_channel_r6 & delay_5_input_data_channel_r6 & delay_6_input_data_channel_r6;
            final_input_data_channel_r7  <= cut_input_data_channel_r7 & delay_input_data_channel_r7 & delay_1_input_data_channel_r7 & delay_2_input_data_channel_r7 & delay_3_input_data_channel_r7 & delay_4_input_data_channel_r7 & delay_5_input_data_channel_r7 & delay_6_input_data_channel_r7;
            final_input_data_channel_r8  <= cut_input_data_channel_r8 & delay_input_data_channel_r8 & delay_1_input_data_channel_r8 & delay_2_input_data_channel_r8 & delay_3_input_data_channel_r8 & delay_4_input_data_channel_r8 & delay_5_input_data_channel_r8 & delay_6_input_data_channel_r8;
            final_input_data_channel_r9  <= cut_input_data_channel_r9 & delay_input_data_channel_r9 & delay_1_input_data_channel_r9 & delay_2_input_data_channel_r9 & delay_3_input_data_channel_r9 & delay_4_input_data_channel_r9 & delay_5_input_data_channel_r9 & delay_6_input_data_channel_r9;
            final_input_data_channel_r10 <= cut_input_data_channel_r10 & delay_input_data_channel_r10 & delay_1_input_data_channel_r10 & delay_2_input_data_channel_r10 & delay_3_input_data_channel_r10 & delay_4_input_data_channel_r10 & delay_5_input_data_channel_r10 & delay_6_input_data_channel_r10;
            final_input_data_channel_r11 <= cut_input_data_channel_r11 & delay_input_data_channel_r11 & delay_1_input_data_channel_r11 & delay_2_input_data_channel_r11 & delay_3_input_data_channel_r11 & delay_4_input_data_channel_r11 & delay_5_input_data_channel_r11 & delay_6_input_data_channel_r11;
            final_input_data_channel_r12 <= cut_input_data_channel_r12 & delay_input_data_channel_r12 & delay_1_input_data_channel_r12 & delay_2_input_data_channel_r12 & delay_3_input_data_channel_r12 & delay_4_input_data_channel_r12 & delay_5_input_data_channel_r12 & delay_6_input_data_channel_r12;
            final_input_data_channel_r13 <= cut_input_data_channel_r13 & delay_input_data_channel_r13 & delay_1_input_data_channel_r13 & delay_2_input_data_channel_r13 & delay_3_input_data_channel_r13 & delay_4_input_data_channel_r13 & delay_5_input_data_channel_r13 & delay_6_input_data_channel_r13;
            final_input_data_channel_r14 <= cut_input_data_channel_r14 & delay_input_data_channel_r14 & delay_1_input_data_channel_r14 & delay_2_input_data_channel_r14 & delay_3_input_data_channel_r14 & delay_4_input_data_channel_r14 & delay_5_input_data_channel_r14 & delay_6_input_data_channel_r14;
            final_input_data_channel_r15 <= cut_input_data_channel_r15 & delay_input_data_channel_r15 & delay_1_input_data_channel_r15 & delay_2_input_data_channel_r15 & delay_3_input_data_channel_r15 & delay_4_input_data_channel_r15 & delay_5_input_data_channel_r15 & delay_6_input_data_channel_r15;
            final_input_data_channel_r16 <= cut_input_data_channel_r16 & delay_input_data_channel_r16 & delay_1_input_data_channel_r16 & delay_2_input_data_channel_r16 & delay_3_input_data_channel_r16 & delay_4_input_data_channel_r16 & delay_5_input_data_channel_r16 & delay_6_input_data_channel_r16;

            pass_final_input_data_channel_r1  <= final_input_data_channel_r1;
            pass_final_input_data_channel_r2  <= final_input_data_channel_r2;
            pass_final_input_data_channel_r3  <= final_input_data_channel_r3;
            pass_final_input_data_channel_r4  <= final_input_data_channel_r4;
            pass_final_input_data_channel_r5  <= final_input_data_channel_r5;
            pass_final_input_data_channel_r6  <= final_input_data_channel_r6;
            pass_final_input_data_channel_r7  <= final_input_data_channel_r7;
            pass_final_input_data_channel_r8  <= final_input_data_channel_r8;
            pass_final_input_data_channel_r9  <= final_input_data_channel_r9;
            pass_final_input_data_channel_r10 <= final_input_data_channel_r10;
            pass_final_input_data_channel_r11 <= final_input_data_channel_r11;
            pass_final_input_data_channel_r12 <= final_input_data_channel_r12;
            pass_final_input_data_channel_r13 <= final_input_data_channel_r13;
            pass_final_input_data_channel_r14 <= final_input_data_channel_r14;
            pass_final_input_data_channel_r15 <= final_input_data_channel_r15;
            pass_final_input_data_channel_r16 <= final_input_data_channel_r16;
            -- Memory Data
            delay_2_column_1  <= delay_1_column_1;
            delay_2_column_2  <= delay_1_column_2;
            delay_2_column_3  <= delay_1_column_3;
            delay_2_column_4  <= delay_1_column_4;
            delay_2_column_5  <= delay_1_column_5;
            delay_2_column_6  <= delay_1_column_6;
            delay_2_column_7  <= delay_1_column_7;
            delay_2_column_8  <= delay_1_column_8;
            delay_2_column_9  <= delay_1_column_9;
            delay_2_column_10 <= delay_1_column_10;
            delay_2_column_11 <= delay_1_column_11;
            delay_2_column_12 <= delay_1_column_12;
            delay_2_column_13 <= delay_1_column_13;
            delay_2_column_14 <= delay_1_column_14;
            delay_2_column_15 <= delay_1_column_15;
            delay_2_column_16 <= delay_1_column_16;
        end if;
    end process;
    -------------------------------------------------------------
    -- Process 12 : Final stage of assambling the codewords
    -------------------------------------------------------------
    process (clk, reset)
    begin
        if (reset = '1') then

        elsif (rising_edge(clk)) then
            output_codeword_data(0)  <= delay_2_column_1  & pass_final_input_data_channel_r1;-- 16 codewords are assambled
            output_codeword_data(1)  <= delay_2_column_2  & pass_final_input_data_channel_r2;
            output_codeword_data(2)  <= delay_2_column_3  & pass_final_input_data_channel_r3;
            output_codeword_data(3)  <= delay_2_column_4  & pass_final_input_data_channel_r4;
            output_codeword_data(4)  <= delay_2_column_5  & pass_final_input_data_channel_r5;
            output_codeword_data(5)  <= delay_2_column_6  & pass_final_input_data_channel_r6;
            output_codeword_data(6)  <= delay_2_column_7  & pass_final_input_data_channel_r7;
            output_codeword_data(7)  <= delay_2_column_8  & pass_final_input_data_channel_r8;
            output_codeword_data(8)  <= delay_2_column_9  & pass_final_input_data_channel_r9;
            output_codeword_data(9)  <= delay_2_column_10 & pass_final_input_data_channel_r10;
            output_codeword_data(10) <= delay_2_column_11 & pass_final_input_data_channel_r11;
            output_codeword_data(11) <= delay_2_column_12 & pass_final_input_data_channel_r12;
            output_codeword_data(12) <= delay_2_column_13 & pass_final_input_data_channel_r13;
            output_codeword_data(13) <= delay_2_column_14 & pass_final_input_data_channel_r14;
            output_codeword_data(14) <= delay_2_column_15 & pass_final_input_data_channel_r15;
            output_codeword_data(15) <= delay_2_column_16 & pass_final_input_data_channel_r16;
        end if;
    end process;
    -------------------------------------------------------------
    -- Process 14 : Delay
    -------------------------------------------------------------
    process (clk, reset)
    begin
        if (reset = '1') then

        elsif (rising_edge(clk)) then
            delay_1_output_codeword_data <= output_codeword_data;
        end if;
    end process;
    -------------------------------------------------------------
    -- Process 15 : Delay
    -------------------------------------------------------------
    process (clk, reset)
    begin
        if (reset = '1') then

        elsif (rising_edge(clk)) then
            delay_2_output_codeword_data <= delay_1_output_codeword_data;
        end if;
    end process;
    -------------------------------------------------------------
    -- Process 16 : Delay
    -------------------------------------------------------------
    --process (clk, reset)
    --begin
    --    if (reset = '1') then
    --
    --    elsif (rising_edge(clk)) then
    --        delay_3_output_codeword_data <= delay_2_output_codeword_data;
    --    end if;
    --end process;
    -------------------------------------------------------------
    -- Process 17 : Delay
    -------------------------------------------------------------
    --process (clk, reset)
    --begin
    --    if (reset = '1') then
    --
    --    elsif (rising_edge(clk)) then
    --        delay_4_output_codeword_data <= delay_3_output_codeword_data;
    --    end if;
    --end process;
    -------------------------------------------------------------
    -- Process 18 : Delay
    -------------------------------------------------------------
    process (clk, reset)
    begin
        if (reset = '1') then

        elsif (rising_edge(clk)) then
            if i < 15 then
                i <= i + 1;
            else
                i <= 0;
            end if;

            if i = 0 then
                final_output_codeword_data <= delay_2_output_codeword_data;
            else
                final_output_codeword_data <= final_output_codeword_data;
            end if;
        end if;
    end process;
    -------------------------------------------------------------
    -- Process 19 : Send them out one by one
    -------------------------------------------------------------
    process (clk, reset)
    begin
        if (reset = '1') then

        elsif (rising_edge(clk)) then
            if j < 15 then
                j                <= j + 1;
                output_2_decoder <= final_output_codeword_data(j);
            else
                j                <= 0;
                output_2_decoder <= final_output_codeword_data(j);
            end if;
        end if;
    end process;
end architecture;
