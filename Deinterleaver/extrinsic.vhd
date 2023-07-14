-- DUT, this one is unfinished, should extend the size of the RAM, and seperate the codeword into cubes here
library ieee;
use ieee.std_logic_1164.all;

package arr_pkg_8 is
    type data_square is array (natural range <>) of std_logic_vector(2047 downto 0);
end;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use ieee.math_real.all;
use work.arr_pkg_1.all;
use work.arr_pkg_2.all;
use work.arr_pkg_3.all;
use work.arr_pkg_4.all;
use work.arr_pkg_5.all;
use work.arr_pkg_6.all;
use work.arr_pkg_7.all;
use work.arr_pkg_8.all;
entity extrinsic is
    generic (
        data_length : positive := 255
    );
    port (
        clk                 : in std_logic;
        reset               : in std_logic;
        soft_input          : in output_data_array(data_length downto 0); -- From Soft_out block, the corrected data
        soft_input_original : in input_data_array(data_length downto 0);  -- From Soft_out block, raw input data

        soft_output          : out output_data_array(data_length downto 0); -- Decoded result
        extrinsic_info_half1 : out input_data_array(127 downto 0);          -- send to RAM block after combining with address
        extrinsic_info_half2 : out input_data_array(255 downto 128)
    );
end extrinsic;
architecture rtl of extrinsic is
    constant soft_bits       : integer                             := 8; -- Number of soft bits
    signal AND_array_3       : input_data_array(256 - 1 downto 16) := (others => (others => '0'));
    signal AND_array_4       : input_data_array(15 downto 0)       := (others => (others => '1'));
    signal channel_and_array : input_data_array(256 - 1 downto 0);
    --------------------------------------------------------------------------------------------
    -- CLK 1
    signal soft_input_1          : output_data_array(data_length downto 0);
    signal soft_input_original_1 : input_data_array(data_length downto 0);
    --------------------------------------------------------------------------------------------
    -- CLK 2
    signal soft_input_2          : output_data_array(data_length downto 0);
    signal soft_input_original_2 : output_data_array(data_length downto 0);
    --------------------------------------------------------------------------------------------
    -- CLK 3
    signal soft_input_3          : output_data_array(data_length downto 0);
    signal soft_input_original_3 : output_data_array(data_length downto 0);
    signal extrinsic_info_1      : extrinsic_array(127 downto 0);
    --------------------------------------------------------------------------------------------
    -- CLK 4
    signal storage_0          : input_data_array(255 downto 0);
    signal extrinsic_info_2   : extrinsic_array(255 downto 128);
    signal extrinsic_info_1_1 : extrinsic_array(127 downto 0);
    signal extrinsic_info_f1  : input_data_array(127 downto 0);
    signal extrinsic_info_f2  : input_data_array(255 downto 128);
    --------------------------------------------------------------------------------------------
    -- CLK 5
    signal storage_1            : input_data_array(255 downto 0);
    signal extrinsic_info_f1_e1 : input_data_array(127 downto 0);
    signal extrinsic_info_f2_e1 : input_data_array(255 downto 128);
    --------------------------------------------------------------------------------------------
    -- CLK 6
    signal storage_2            : input_data_array(255 downto 0);
    signal extrinsic_info_f1_e2 : input_data_array(127 downto 0);
    signal extrinsic_info_f2_e2 : input_data_array(255 downto 128);
    --------------------------------------------------------------------------------------------
    -- CLK 7
    signal storage_3            : input_data_array(255 downto 0);
    signal extrinsic_info_f1_e3 : input_data_array(127 downto 0);
    signal extrinsic_info_f2_e3 : input_data_array(255 downto 128);
    --------------------------------------------------------------------------------------------
    -- CLK 8
    signal storage_4            : input_data_array(255 downto 0);
    signal extrinsic_info_f1_e4 : input_data_array(127 downto 0);
    signal extrinsic_info_f2_e4 : input_data_array(255 downto 128);
    --------------------------------------------------------------------------------------------
    -- CLK 9
    signal storage_5            : input_data_array(255 downto 0);
    signal extrinsic_info_f1_e5 : input_data_array(127 downto 0);
    signal extrinsic_info_f2_e5 : input_data_array(255 downto 128);
    --------------------------------------------------------------------------------------------
    -- CLK 10
    signal storage_6            : input_data_array(255 downto 0);
    signal extrinsic_info_f1_e6 : input_data_array(127 downto 0);
    signal extrinsic_info_f2_e6 : input_data_array(255 downto 128);
    --------------------------------------------------------------------------------------------
    -- CLK 11
    signal storage_7            : input_data_array(255 downto 0);
    signal extrinsic_info_f1_e7 : input_data_array(127 downto 0);
    signal extrinsic_info_f2_e7 : input_data_array(255 downto 128);
    --------------------------------------------------------------------------------------------
    -- CLK 12
    signal storage_8            : input_data_array(255 downto 0);
    signal extrinsic_info_f1_e8 : input_data_array(127 downto 0);
    signal extrinsic_info_f2_e8 : input_data_array(255 downto 128);
    --------------------------------------------------------------------------------------------
    -- CLK 13
    signal storage_9            : input_data_array(255 downto 0);
    signal extrinsic_info_f1_e9 : input_data_array(127 downto 0);
    signal extrinsic_info_f2_e9 : input_data_array(255 downto 128);
    --------------------------------------------------------------------------------------------
    -- CLK 14
    signal storage_10            : input_data_array(255 downto 0);
    signal extrinsic_info_f1_e10 : input_data_array(127 downto 0);
    signal extrinsic_info_f2_e10 : input_data_array(255 downto 128);
    --------------------------------------------------------------------------------------------
    -- CLK 15
    signal channel_shift_1             : input_data_array(15 downto 0)  := (others => (others => '0'));
    signal channel_shift_2             : input_data_array(31 downto 0)  := (others => (others => '0'));
    signal channel_shift_3             : input_data_array(47 downto 0)  := (others => (others => '0'));
    signal channel_shift_4             : input_data_array(63 downto 0)  := (others => (others => '0'));
    signal channel_shift_5             : input_data_array(79 downto 0)  := (others => (others => '0'));
    signal channel_shift_6             : input_data_array(95 downto 0)  := (others => (others => '0'));
    signal channel_shift_7             : input_data_array(111 downto 0) := (others => (others => '0'));
    signal channel_shift_8             : input_data_array(127 downto 0) := (others => (others => '0'));
    signal channel_shift_9             : input_data_array(143 downto 0) := (others => (others => '0'));
    signal channel_shift_10            : input_data_array(159 downto 0) := (others => (others => '0'));
    signal channel_shift_11            : input_data_array(175 downto 0) := (others => (others => '0'));
    signal channel_shift_12            : input_data_array(191 downto 0) := (others => (others => '0'));
    signal channel_shift_13            : input_data_array(207 downto 0) := (others => (others => '0'));
    signal channel_shift_14            : input_data_array(223 downto 0) := (others => (others => '0'));
    signal channel_shift_15            : input_data_array(239 downto 0) := (others => (others => '0'));
    signal s_0_input_data_channel_r1   : input_data_array(255 downto 0);
    signal s_0_input_data_channel_r2   : input_data_array(255 downto 0);
    signal s_0_input_data_channel_r3   : input_data_array(255 downto 0);
    signal s_0_input_data_channel_r4   : input_data_array(255 downto 0);
    signal s_0_input_data_channel_r5   : input_data_array(255 downto 0);
    signal s_0_input_data_channel_r6   : input_data_array(255 downto 0);
    signal s_0_input_data_channel_r7   : input_data_array(255 downto 0);
    signal s_0_input_data_channel_r8   : input_data_array(255 downto 0);
    signal s_0_input_data_channel_r9   : input_data_array(255 downto 0);
    signal s_0_input_data_channel_r10  : input_data_array(255 downto 0);
    signal s_0_input_data_channel_r11  : input_data_array(255 downto 0);
    signal s_0_input_data_channel_r12  : input_data_array(255 downto 0);
    signal s_0_input_data_channel_r13  : input_data_array(255 downto 0);
    signal s_0_input_data_channel_r14  : input_data_array(255 downto 0);
    signal s_0_input_data_channel_r15  : input_data_array(255 downto 0);
    signal s_0_input_data_channel_r16  : input_data_array(255 downto 0);
    signal s_1_input_data_channel_r1   : input_data_array(255 downto 0);
    signal s_1_input_data_channel_r2   : input_data_array(255 downto 0);
    signal s_1_input_data_channel_r3   : input_data_array(255 downto 0);
    signal s_1_input_data_channel_r4   : input_data_array(255 downto 0);
    signal s_1_input_data_channel_r5   : input_data_array(255 downto 0);
    signal s_1_input_data_channel_r6   : input_data_array(255 downto 0);
    signal s_1_input_data_channel_r7   : input_data_array(255 downto 0);
    signal s_1_input_data_channel_r8   : input_data_array(255 downto 0);
    signal s_1_input_data_channel_r9   : input_data_array(255 downto 0);
    signal s_1_input_data_channel_r10  : input_data_array(255 downto 0);
    signal s_1_input_data_channel_r11  : input_data_array(255 downto 0);
    signal s_1_input_data_channel_r12  : input_data_array(255 downto 0);
    signal s_1_input_data_channel_r13  : input_data_array(255 downto 0);
    signal s_1_input_data_channel_r14  : input_data_array(255 downto 0);
    signal s_1_input_data_channel_r15  : input_data_array(255 downto 0);
    signal s_1_input_data_channel_r16  : input_data_array(255 downto 0);
    signal s_2_input_data_channel_r1   : input_data_array(255 downto 0);
    signal s_2_input_data_channel_r2   : input_data_array(255 downto 0);
    signal s_2_input_data_channel_r3   : input_data_array(255 downto 0);
    signal s_2_input_data_channel_r4   : input_data_array(255 downto 0);
    signal s_2_input_data_channel_r5   : input_data_array(255 downto 0);
    signal s_2_input_data_channel_r6   : input_data_array(255 downto 0);
    signal s_2_input_data_channel_r7   : input_data_array(255 downto 0);
    signal s_2_input_data_channel_r8   : input_data_array(255 downto 0);
    signal s_2_input_data_channel_r9   : input_data_array(255 downto 0);
    signal s_2_input_data_channel_r10  : input_data_array(255 downto 0);
    signal s_2_input_data_channel_r11  : input_data_array(255 downto 0);
    signal s_2_input_data_channel_r12  : input_data_array(255 downto 0);
    signal s_2_input_data_channel_r13  : input_data_array(255 downto 0);
    signal s_2_input_data_channel_r14  : input_data_array(255 downto 0);
    signal s_2_input_data_channel_r15  : input_data_array(255 downto 0);
    signal s_2_input_data_channel_r16  : input_data_array(255 downto 0);
    signal s_3_input_data_channel_r1   : input_data_array(255 downto 0);
    signal s_3_input_data_channel_r2   : input_data_array(255 downto 0);
    signal s_3_input_data_channel_r3   : input_data_array(255 downto 0);
    signal s_3_input_data_channel_r4   : input_data_array(255 downto 0);
    signal s_3_input_data_channel_r5   : input_data_array(255 downto 0);
    signal s_3_input_data_channel_r6   : input_data_array(255 downto 0);
    signal s_3_input_data_channel_r7   : input_data_array(255 downto 0);
    signal s_3_input_data_channel_r8   : input_data_array(255 downto 0);
    signal s_3_input_data_channel_r9   : input_data_array(255 downto 0);
    signal s_3_input_data_channel_r10  : input_data_array(255 downto 0);
    signal s_3_input_data_channel_r11  : input_data_array(255 downto 0);
    signal s_3_input_data_channel_r12  : input_data_array(255 downto 0);
    signal s_3_input_data_channel_r13  : input_data_array(255 downto 0);
    signal s_3_input_data_channel_r14  : input_data_array(255 downto 0);
    signal s_3_input_data_channel_r15  : input_data_array(255 downto 0);
    signal s_3_input_data_channel_r16  : input_data_array(255 downto 0);
    signal s_4_input_data_channel_r1   : input_data_array(255 downto 0);
    signal s_4_input_data_channel_r2   : input_data_array(255 downto 0);
    signal s_4_input_data_channel_r3   : input_data_array(255 downto 0);
    signal s_4_input_data_channel_r4   : input_data_array(255 downto 0);
    signal s_4_input_data_channel_r5   : input_data_array(255 downto 0);
    signal s_4_input_data_channel_r6   : input_data_array(255 downto 0);
    signal s_4_input_data_channel_r7   : input_data_array(255 downto 0);
    signal s_4_input_data_channel_r8   : input_data_array(255 downto 0);
    signal s_4_input_data_channel_r9   : input_data_array(255 downto 0);
    signal s_4_input_data_channel_r10  : input_data_array(255 downto 0);
    signal s_4_input_data_channel_r11  : input_data_array(255 downto 0);
    signal s_4_input_data_channel_r12  : input_data_array(255 downto 0);
    signal s_4_input_data_channel_r13  : input_data_array(255 downto 0);
    signal s_4_input_data_channel_r14  : input_data_array(255 downto 0);
    signal s_4_input_data_channel_r15  : input_data_array(255 downto 0);
    signal s_4_input_data_channel_r16  : input_data_array(255 downto 0);
    signal s_5_input_data_channel_r1   : input_data_array(255 downto 0);
    signal s_5_input_data_channel_r2   : input_data_array(255 downto 0);
    signal s_5_input_data_channel_r3   : input_data_array(255 downto 0);
    signal s_5_input_data_channel_r4   : input_data_array(255 downto 0);
    signal s_5_input_data_channel_r5   : input_data_array(255 downto 0);
    signal s_5_input_data_channel_r6   : input_data_array(255 downto 0);
    signal s_5_input_data_channel_r7   : input_data_array(255 downto 0);
    signal s_5_input_data_channel_r8   : input_data_array(255 downto 0);
    signal s_5_input_data_channel_r9   : input_data_array(255 downto 0);
    signal s_5_input_data_channel_r10  : input_data_array(255 downto 0);
    signal s_5_input_data_channel_r11  : input_data_array(255 downto 0);
    signal s_5_input_data_channel_r12  : input_data_array(255 downto 0);
    signal s_5_input_data_channel_r13  : input_data_array(255 downto 0);
    signal s_5_input_data_channel_r14  : input_data_array(255 downto 0);
    signal s_5_input_data_channel_r15  : input_data_array(255 downto 0);
    signal s_5_input_data_channel_r16  : input_data_array(255 downto 0);
    signal s_6_input_data_channel_r1   : input_data_array(255 downto 0);
    signal s_6_input_data_channel_r2   : input_data_array(255 downto 0);
    signal s_6_input_data_channel_r3   : input_data_array(255 downto 0);
    signal s_6_input_data_channel_r4   : input_data_array(255 downto 0);
    signal s_6_input_data_channel_r5   : input_data_array(255 downto 0);
    signal s_6_input_data_channel_r6   : input_data_array(255 downto 0);
    signal s_6_input_data_channel_r7   : input_data_array(255 downto 0);
    signal s_6_input_data_channel_r8   : input_data_array(255 downto 0);
    signal s_6_input_data_channel_r9   : input_data_array(255 downto 0);
    signal s_6_input_data_channel_r10  : input_data_array(255 downto 0);
    signal s_6_input_data_channel_r11  : input_data_array(255 downto 0);
    signal s_6_input_data_channel_r12  : input_data_array(255 downto 0);
    signal s_6_input_data_channel_r13  : input_data_array(255 downto 0);
    signal s_6_input_data_channel_r14  : input_data_array(255 downto 0);
    signal s_6_input_data_channel_r15  : input_data_array(255 downto 0);
    signal s_6_input_data_channel_r16  : input_data_array(255 downto 0);
    signal s_7_input_data_channel_r1   : input_data_array(255 downto 0);
    signal s_7_input_data_channel_r2   : input_data_array(255 downto 0);
    signal s_7_input_data_channel_r3   : input_data_array(255 downto 0);
    signal s_7_input_data_channel_r4   : input_data_array(255 downto 0);
    signal s_7_input_data_channel_r5   : input_data_array(255 downto 0);
    signal s_7_input_data_channel_r6   : input_data_array(255 downto 0);
    signal s_7_input_data_channel_r7   : input_data_array(255 downto 0);
    signal s_7_input_data_channel_r8   : input_data_array(255 downto 0);
    signal s_7_input_data_channel_r9   : input_data_array(255 downto 0);
    signal s_7_input_data_channel_r10  : input_data_array(255 downto 0);
    signal s_7_input_data_channel_r11  : input_data_array(255 downto 0);
    signal s_7_input_data_channel_r12  : input_data_array(255 downto 0);
    signal s_7_input_data_channel_r13  : input_data_array(255 downto 0);
    signal s_7_input_data_channel_r14  : input_data_array(255 downto 0);
    signal s_7_input_data_channel_r15  : input_data_array(255 downto 0);
    signal s_7_input_data_channel_r16  : input_data_array(255 downto 0);
    signal s_8_input_data_channel_r1   : input_data_array(255 downto 0);
    signal s_8_input_data_channel_r2   : input_data_array(255 downto 0);
    signal s_8_input_data_channel_r3   : input_data_array(255 downto 0);
    signal s_8_input_data_channel_r4   : input_data_array(255 downto 0);
    signal s_8_input_data_channel_r5   : input_data_array(255 downto 0);
    signal s_8_input_data_channel_r6   : input_data_array(255 downto 0);
    signal s_8_input_data_channel_r7   : input_data_array(255 downto 0);
    signal s_8_input_data_channel_r8   : input_data_array(255 downto 0);
    signal s_8_input_data_channel_r9   : input_data_array(255 downto 0);
    signal s_8_input_data_channel_r10  : input_data_array(255 downto 0);
    signal s_8_input_data_channel_r11  : input_data_array(255 downto 0);
    signal s_8_input_data_channel_r12  : input_data_array(255 downto 0);
    signal s_8_input_data_channel_r13  : input_data_array(255 downto 0);
    signal s_8_input_data_channel_r14  : input_data_array(255 downto 0);
    signal s_8_input_data_channel_r15  : input_data_array(255 downto 0);
    signal s_8_input_data_channel_r16  : input_data_array(255 downto 0);
    signal s_9_input_data_channel_r1   : input_data_array(255 downto 0);
    signal s_9_input_data_channel_r2   : input_data_array(255 downto 0);
    signal s_9_input_data_channel_r3   : input_data_array(255 downto 0);
    signal s_9_input_data_channel_r4   : input_data_array(255 downto 0);
    signal s_9_input_data_channel_r5   : input_data_array(255 downto 0);
    signal s_9_input_data_channel_r6   : input_data_array(255 downto 0);
    signal s_9_input_data_channel_r7   : input_data_array(255 downto 0);
    signal s_9_input_data_channel_r8   : input_data_array(255 downto 0);
    signal s_9_input_data_channel_r9   : input_data_array(255 downto 0);
    signal s_9_input_data_channel_r10  : input_data_array(255 downto 0);
    signal s_9_input_data_channel_r11  : input_data_array(255 downto 0);
    signal s_9_input_data_channel_r12  : input_data_array(255 downto 0);
    signal s_9_input_data_channel_r13  : input_data_array(255 downto 0);
    signal s_9_input_data_channel_r14  : input_data_array(255 downto 0);
    signal s_9_input_data_channel_r15  : input_data_array(255 downto 0);
    signal s_9_input_data_channel_r16  : input_data_array(255 downto 0);
    signal s_10_input_data_channel_r1  : input_data_array(255 downto 0);
    signal s_10_input_data_channel_r2  : input_data_array(255 downto 0);
    signal s_10_input_data_channel_r3  : input_data_array(255 downto 0);
    signal s_10_input_data_channel_r4  : input_data_array(255 downto 0);
    signal s_10_input_data_channel_r5  : input_data_array(255 downto 0);
    signal s_10_input_data_channel_r6  : input_data_array(255 downto 0);
    signal s_10_input_data_channel_r7  : input_data_array(255 downto 0);
    signal s_10_input_data_channel_r8  : input_data_array(255 downto 0);
    signal s_10_input_data_channel_r9  : input_data_array(255 downto 0);
    signal s_10_input_data_channel_r10 : input_data_array(255 downto 0);
    signal s_10_input_data_channel_r11 : input_data_array(255 downto 0);
    signal s_10_input_data_channel_r12 : input_data_array(255 downto 0);
    signal s_10_input_data_channel_r13 : input_data_array(255 downto 0);
    signal s_10_input_data_channel_r14 : input_data_array(255 downto 0);
    signal s_10_input_data_channel_r15 : input_data_array(255 downto 0);
    signal s_10_input_data_channel_r16 : input_data_array(255 downto 0);
    signal s_11_input_data_channel_r1  : input_data_array(255 downto 0);
    signal s_11_input_data_channel_r2  : input_data_array(255 downto 0);
    signal s_11_input_data_channel_r3  : input_data_array(255 downto 0);
    signal s_11_input_data_channel_r4  : input_data_array(255 downto 0);
    signal s_11_input_data_channel_r5  : input_data_array(255 downto 0);
    signal s_11_input_data_channel_r6  : input_data_array(255 downto 0);
    signal s_11_input_data_channel_r7  : input_data_array(255 downto 0);
    signal s_11_input_data_channel_r8  : input_data_array(255 downto 0);
    signal s_11_input_data_channel_r9  : input_data_array(255 downto 0);
    signal s_11_input_data_channel_r10 : input_data_array(255 downto 0);
    signal s_11_input_data_channel_r11 : input_data_array(255 downto 0);
    signal s_11_input_data_channel_r12 : input_data_array(255 downto 0);
    signal s_11_input_data_channel_r13 : input_data_array(255 downto 0);
    signal s_11_input_data_channel_r14 : input_data_array(255 downto 0);
    signal s_11_input_data_channel_r15 : input_data_array(255 downto 0);
    signal s_11_input_data_channel_r16 : input_data_array(255 downto 0);
    signal s_12_input_data_channel_r1  : input_data_array(255 downto 0);
    signal s_12_input_data_channel_r2  : input_data_array(255 downto 0);
    signal s_12_input_data_channel_r3  : input_data_array(255 downto 0);
    signal s_12_input_data_channel_r4  : input_data_array(255 downto 0);
    signal s_12_input_data_channel_r5  : input_data_array(255 downto 0);
    signal s_12_input_data_channel_r6  : input_data_array(255 downto 0);
    signal s_12_input_data_channel_r7  : input_data_array(255 downto 0);
    signal s_12_input_data_channel_r8  : input_data_array(255 downto 0);
    signal s_12_input_data_channel_r9  : input_data_array(255 downto 0);
    signal s_12_input_data_channel_r10 : input_data_array(255 downto 0);
    signal s_12_input_data_channel_r11 : input_data_array(255 downto 0);
    signal s_12_input_data_channel_r12 : input_data_array(255 downto 0);
    signal s_12_input_data_channel_r13 : input_data_array(255 downto 0);
    signal s_12_input_data_channel_r14 : input_data_array(255 downto 0);
    signal s_12_input_data_channel_r15 : input_data_array(255 downto 0);
    signal s_12_input_data_channel_r16 : input_data_array(255 downto 0);
    signal s_13_input_data_channel_r1  : input_data_array(255 downto 0);
    signal s_13_input_data_channel_r2  : input_data_array(255 downto 0);
    signal s_13_input_data_channel_r3  : input_data_array(255 downto 0);
    signal s_13_input_data_channel_r4  : input_data_array(255 downto 0);
    signal s_13_input_data_channel_r5  : input_data_array(255 downto 0);
    signal s_13_input_data_channel_r6  : input_data_array(255 downto 0);
    signal s_13_input_data_channel_r7  : input_data_array(255 downto 0);
    signal s_13_input_data_channel_r8  : input_data_array(255 downto 0);
    signal s_13_input_data_channel_r9  : input_data_array(255 downto 0);
    signal s_13_input_data_channel_r10 : input_data_array(255 downto 0);
    signal s_13_input_data_channel_r11 : input_data_array(255 downto 0);
    signal s_13_input_data_channel_r12 : input_data_array(255 downto 0);
    signal s_13_input_data_channel_r13 : input_data_array(255 downto 0);
    signal s_13_input_data_channel_r14 : input_data_array(255 downto 0);
    signal s_13_input_data_channel_r15 : input_data_array(255 downto 0);
    signal s_13_input_data_channel_r16 : input_data_array(255 downto 0);
    signal s_14_input_data_channel_r1  : input_data_array(255 downto 0);
    signal s_14_input_data_channel_r2  : input_data_array(255 downto 0);
    signal s_14_input_data_channel_r3  : input_data_array(255 downto 0);
    signal s_14_input_data_channel_r4  : input_data_array(255 downto 0);
    signal s_14_input_data_channel_r5  : input_data_array(255 downto 0);
    signal s_14_input_data_channel_r6  : input_data_array(255 downto 0);
    signal s_14_input_data_channel_r7  : input_data_array(255 downto 0);
    signal s_14_input_data_channel_r8  : input_data_array(255 downto 0);
    signal s_14_input_data_channel_r9  : input_data_array(255 downto 0);
    signal s_14_input_data_channel_r10 : input_data_array(255 downto 0);
    signal s_14_input_data_channel_r11 : input_data_array(255 downto 0);
    signal s_14_input_data_channel_r12 : input_data_array(255 downto 0);
    signal s_14_input_data_channel_r13 : input_data_array(255 downto 0);
    signal s_14_input_data_channel_r14 : input_data_array(255 downto 0);
    signal s_14_input_data_channel_r15 : input_data_array(255 downto 0);
    signal s_14_input_data_channel_r16 : input_data_array(255 downto 0);
    signal s_15_input_data_channel_r1  : input_data_array(255 downto 0);
    signal s_15_input_data_channel_r2  : input_data_array(255 downto 0);
    signal s_15_input_data_channel_r3  : input_data_array(255 downto 0);
    signal s_15_input_data_channel_r4  : input_data_array(255 downto 0);
    signal s_15_input_data_channel_r5  : input_data_array(255 downto 0);
    signal s_15_input_data_channel_r6  : input_data_array(255 downto 0);
    signal s_15_input_data_channel_r7  : input_data_array(255 downto 0);
    signal s_15_input_data_channel_r8  : input_data_array(255 downto 0);
    signal s_15_input_data_channel_r9  : input_data_array(255 downto 0);
    signal s_15_input_data_channel_r10 : input_data_array(255 downto 0);
    signal s_15_input_data_channel_r11 : input_data_array(255 downto 0);
    signal s_15_input_data_channel_r12 : input_data_array(255 downto 0);
    signal s_15_input_data_channel_r13 : input_data_array(255 downto 0);
    signal s_15_input_data_channel_r14 : input_data_array(255 downto 0);
    signal s_15_input_data_channel_r15 : input_data_array(255 downto 0);
    signal s_15_input_data_channel_r16 : input_data_array(255 downto 0);
    signal extrinsic_info_f1_e11       : input_data_array(127 downto 0);
    signal extrinsic_info_f2_e11       : input_data_array(255 downto 128);
    --------------------------------------------------------------------------------------------
    -- CLK 16
    signal storage_11                    : input_data_array(255 downto 0);
    signal extrinsic_info_f1_e12         : input_data_array(127 downto 0);
    signal extrinsic_info_f2_e12         : input_data_array(255 downto 128);
    signal and_0_input_data_channel_r1   : input_data_array(255 downto 0);
    signal and_0_input_data_channel_r2   : input_data_array(255 downto 0);
    signal and_0_input_data_channel_r3   : input_data_array(255 downto 0);
    signal and_0_input_data_channel_r4   : input_data_array(255 downto 0);
    signal and_0_input_data_channel_r5   : input_data_array(255 downto 0);
    signal and_0_input_data_channel_r6   : input_data_array(255 downto 0);
    signal and_0_input_data_channel_r7   : input_data_array(255 downto 0);
    signal and_0_input_data_channel_r8   : input_data_array(255 downto 0);
    signal and_0_input_data_channel_r9   : input_data_array(255 downto 0);
    signal and_0_input_data_channel_r10  : input_data_array(255 downto 0);
    signal and_0_input_data_channel_r11  : input_data_array(255 downto 0);
    signal and_0_input_data_channel_r12  : input_data_array(255 downto 0);
    signal and_0_input_data_channel_r13  : input_data_array(255 downto 0);
    signal and_0_input_data_channel_r14  : input_data_array(255 downto 0);
    signal and_0_input_data_channel_r15  : input_data_array(255 downto 0);
    signal and_0_input_data_channel_r16  : input_data_array(255 downto 0);
    signal and_1_input_data_channel_r1   : input_data_array(255 downto 0);
    signal and_1_input_data_channel_r2   : input_data_array(255 downto 0);
    signal and_1_input_data_channel_r3   : input_data_array(255 downto 0);
    signal and_1_input_data_channel_r4   : input_data_array(255 downto 0);
    signal and_1_input_data_channel_r5   : input_data_array(255 downto 0);
    signal and_1_input_data_channel_r6   : input_data_array(255 downto 0);
    signal and_1_input_data_channel_r7   : input_data_array(255 downto 0);
    signal and_1_input_data_channel_r8   : input_data_array(255 downto 0);
    signal and_1_input_data_channel_r9   : input_data_array(255 downto 0);
    signal and_1_input_data_channel_r10  : input_data_array(255 downto 0);
    signal and_1_input_data_channel_r11  : input_data_array(255 downto 0);
    signal and_1_input_data_channel_r12  : input_data_array(255 downto 0);
    signal and_1_input_data_channel_r13  : input_data_array(255 downto 0);
    signal and_1_input_data_channel_r14  : input_data_array(255 downto 0);
    signal and_1_input_data_channel_r15  : input_data_array(255 downto 0);
    signal and_1_input_data_channel_r16  : input_data_array(255 downto 0);
    signal and_2_input_data_channel_r1   : input_data_array(255 downto 0);
    signal and_2_input_data_channel_r2   : input_data_array(255 downto 0);
    signal and_2_input_data_channel_r3   : input_data_array(255 downto 0);
    signal and_2_input_data_channel_r4   : input_data_array(255 downto 0);
    signal and_2_input_data_channel_r5   : input_data_array(255 downto 0);
    signal and_2_input_data_channel_r6   : input_data_array(255 downto 0);
    signal and_2_input_data_channel_r7   : input_data_array(255 downto 0);
    signal and_2_input_data_channel_r8   : input_data_array(255 downto 0);
    signal and_2_input_data_channel_r9   : input_data_array(255 downto 0);
    signal and_2_input_data_channel_r10  : input_data_array(255 downto 0);
    signal and_2_input_data_channel_r11  : input_data_array(255 downto 0);
    signal and_2_input_data_channel_r12  : input_data_array(255 downto 0);
    signal and_2_input_data_channel_r13  : input_data_array(255 downto 0);
    signal and_2_input_data_channel_r14  : input_data_array(255 downto 0);
    signal and_2_input_data_channel_r15  : input_data_array(255 downto 0);
    signal and_2_input_data_channel_r16  : input_data_array(255 downto 0);
    signal and_3_input_data_channel_r1   : input_data_array(255 downto 0);
    signal and_3_input_data_channel_r2   : input_data_array(255 downto 0);
    signal and_3_input_data_channel_r3   : input_data_array(255 downto 0);
    signal and_3_input_data_channel_r4   : input_data_array(255 downto 0);
    signal and_3_input_data_channel_r5   : input_data_array(255 downto 0);
    signal and_3_input_data_channel_r6   : input_data_array(255 downto 0);
    signal and_3_input_data_channel_r7   : input_data_array(255 downto 0);
    signal and_3_input_data_channel_r8   : input_data_array(255 downto 0);
    signal and_3_input_data_channel_r9   : input_data_array(255 downto 0);
    signal and_3_input_data_channel_r10  : input_data_array(255 downto 0);
    signal and_3_input_data_channel_r11  : input_data_array(255 downto 0);
    signal and_3_input_data_channel_r12  : input_data_array(255 downto 0);
    signal and_3_input_data_channel_r13  : input_data_array(255 downto 0);
    signal and_3_input_data_channel_r14  : input_data_array(255 downto 0);
    signal and_3_input_data_channel_r15  : input_data_array(255 downto 0);
    signal and_3_input_data_channel_r16  : input_data_array(255 downto 0);
    signal and_4_input_data_channel_r1   : input_data_array(255 downto 0);
    signal and_4_input_data_channel_r2   : input_data_array(255 downto 0);
    signal and_4_input_data_channel_r3   : input_data_array(255 downto 0);
    signal and_4_input_data_channel_r4   : input_data_array(255 downto 0);
    signal and_4_input_data_channel_r5   : input_data_array(255 downto 0);
    signal and_4_input_data_channel_r6   : input_data_array(255 downto 0);
    signal and_4_input_data_channel_r7   : input_data_array(255 downto 0);
    signal and_4_input_data_channel_r8   : input_data_array(255 downto 0);
    signal and_4_input_data_channel_r9   : input_data_array(255 downto 0);
    signal and_4_input_data_channel_r10  : input_data_array(255 downto 0);
    signal and_4_input_data_channel_r11  : input_data_array(255 downto 0);
    signal and_4_input_data_channel_r12  : input_data_array(255 downto 0);
    signal and_4_input_data_channel_r13  : input_data_array(255 downto 0);
    signal and_4_input_data_channel_r14  : input_data_array(255 downto 0);
    signal and_4_input_data_channel_r15  : input_data_array(255 downto 0);
    signal and_4_input_data_channel_r16  : input_data_array(255 downto 0);
    signal and_5_input_data_channel_r1   : input_data_array(255 downto 0);
    signal and_5_input_data_channel_r2   : input_data_array(255 downto 0);
    signal and_5_input_data_channel_r3   : input_data_array(255 downto 0);
    signal and_5_input_data_channel_r4   : input_data_array(255 downto 0);
    signal and_5_input_data_channel_r5   : input_data_array(255 downto 0);
    signal and_5_input_data_channel_r6   : input_data_array(255 downto 0);
    signal and_5_input_data_channel_r7   : input_data_array(255 downto 0);
    signal and_5_input_data_channel_r8   : input_data_array(255 downto 0);
    signal and_5_input_data_channel_r9   : input_data_array(255 downto 0);
    signal and_5_input_data_channel_r10  : input_data_array(255 downto 0);
    signal and_5_input_data_channel_r11  : input_data_array(255 downto 0);
    signal and_5_input_data_channel_r12  : input_data_array(255 downto 0);
    signal and_5_input_data_channel_r13  : input_data_array(255 downto 0);
    signal and_5_input_data_channel_r14  : input_data_array(255 downto 0);
    signal and_5_input_data_channel_r15  : input_data_array(255 downto 0);
    signal and_5_input_data_channel_r16  : input_data_array(255 downto 0);
    signal and_6_input_data_channel_r1   : input_data_array(255 downto 0);
    signal and_6_input_data_channel_r2   : input_data_array(255 downto 0);
    signal and_6_input_data_channel_r3   : input_data_array(255 downto 0);
    signal and_6_input_data_channel_r4   : input_data_array(255 downto 0);
    signal and_6_input_data_channel_r5   : input_data_array(255 downto 0);
    signal and_6_input_data_channel_r6   : input_data_array(255 downto 0);
    signal and_6_input_data_channel_r7   : input_data_array(255 downto 0);
    signal and_6_input_data_channel_r8   : input_data_array(255 downto 0);
    signal and_6_input_data_channel_r9   : input_data_array(255 downto 0);
    signal and_6_input_data_channel_r10  : input_data_array(255 downto 0);
    signal and_6_input_data_channel_r11  : input_data_array(255 downto 0);
    signal and_6_input_data_channel_r12  : input_data_array(255 downto 0);
    signal and_6_input_data_channel_r13  : input_data_array(255 downto 0);
    signal and_6_input_data_channel_r14  : input_data_array(255 downto 0);
    signal and_6_input_data_channel_r15  : input_data_array(255 downto 0);
    signal and_6_input_data_channel_r16  : input_data_array(255 downto 0);
    signal and_7_input_data_channel_r1   : input_data_array(255 downto 0);
    signal and_7_input_data_channel_r2   : input_data_array(255 downto 0);
    signal and_7_input_data_channel_r3   : input_data_array(255 downto 0);
    signal and_7_input_data_channel_r4   : input_data_array(255 downto 0);
    signal and_7_input_data_channel_r5   : input_data_array(255 downto 0);
    signal and_7_input_data_channel_r6   : input_data_array(255 downto 0);
    signal and_7_input_data_channel_r7   : input_data_array(255 downto 0);
    signal and_7_input_data_channel_r8   : input_data_array(255 downto 0);
    signal and_7_input_data_channel_r9   : input_data_array(255 downto 0);
    signal and_7_input_data_channel_r10  : input_data_array(255 downto 0);
    signal and_7_input_data_channel_r11  : input_data_array(255 downto 0);
    signal and_7_input_data_channel_r12  : input_data_array(255 downto 0);
    signal and_7_input_data_channel_r13  : input_data_array(255 downto 0);
    signal and_7_input_data_channel_r14  : input_data_array(255 downto 0);
    signal and_7_input_data_channel_r15  : input_data_array(255 downto 0);
    signal and_7_input_data_channel_r16  : input_data_array(255 downto 0);
    signal and_8_input_data_channel_r1   : input_data_array(255 downto 0);
    signal and_8_input_data_channel_r2   : input_data_array(255 downto 0);
    signal and_8_input_data_channel_r3   : input_data_array(255 downto 0);
    signal and_8_input_data_channel_r4   : input_data_array(255 downto 0);
    signal and_8_input_data_channel_r5   : input_data_array(255 downto 0);
    signal and_8_input_data_channel_r6   : input_data_array(255 downto 0);
    signal and_8_input_data_channel_r7   : input_data_array(255 downto 0);
    signal and_8_input_data_channel_r8   : input_data_array(255 downto 0);
    signal and_8_input_data_channel_r9   : input_data_array(255 downto 0);
    signal and_8_input_data_channel_r10  : input_data_array(255 downto 0);
    signal and_8_input_data_channel_r11  : input_data_array(255 downto 0);
    signal and_8_input_data_channel_r12  : input_data_array(255 downto 0);
    signal and_8_input_data_channel_r13  : input_data_array(255 downto 0);
    signal and_8_input_data_channel_r14  : input_data_array(255 downto 0);
    signal and_8_input_data_channel_r15  : input_data_array(255 downto 0);
    signal and_8_input_data_channel_r16  : input_data_array(255 downto 0);
    signal and_9_input_data_channel_r1   : input_data_array(255 downto 0);
    signal and_9_input_data_channel_r2   : input_data_array(255 downto 0);
    signal and_9_input_data_channel_r3   : input_data_array(255 downto 0);
    signal and_9_input_data_channel_r4   : input_data_array(255 downto 0);
    signal and_9_input_data_channel_r5   : input_data_array(255 downto 0);
    signal and_9_input_data_channel_r6   : input_data_array(255 downto 0);
    signal and_9_input_data_channel_r7   : input_data_array(255 downto 0);
    signal and_9_input_data_channel_r8   : input_data_array(255 downto 0);
    signal and_9_input_data_channel_r9   : input_data_array(255 downto 0);
    signal and_9_input_data_channel_r10  : input_data_array(255 downto 0);
    signal and_9_input_data_channel_r11  : input_data_array(255 downto 0);
    signal and_9_input_data_channel_r12  : input_data_array(255 downto 0);
    signal and_9_input_data_channel_r13  : input_data_array(255 downto 0);
    signal and_9_input_data_channel_r14  : input_data_array(255 downto 0);
    signal and_9_input_data_channel_r15  : input_data_array(255 downto 0);
    signal and_9_input_data_channel_r16  : input_data_array(255 downto 0);
    signal and_10_input_data_channel_r1  : input_data_array(255 downto 0);
    signal and_10_input_data_channel_r2  : input_data_array(255 downto 0);
    signal and_10_input_data_channel_r3  : input_data_array(255 downto 0);
    signal and_10_input_data_channel_r4  : input_data_array(255 downto 0);
    signal and_10_input_data_channel_r5  : input_data_array(255 downto 0);
    signal and_10_input_data_channel_r6  : input_data_array(255 downto 0);
    signal and_10_input_data_channel_r7  : input_data_array(255 downto 0);
    signal and_10_input_data_channel_r8  : input_data_array(255 downto 0);
    signal and_10_input_data_channel_r9  : input_data_array(255 downto 0);
    signal and_10_input_data_channel_r10 : input_data_array(255 downto 0);
    signal and_10_input_data_channel_r11 : input_data_array(255 downto 0);
    signal and_10_input_data_channel_r12 : input_data_array(255 downto 0);
    signal and_10_input_data_channel_r13 : input_data_array(255 downto 0);
    signal and_10_input_data_channel_r14 : input_data_array(255 downto 0);
    signal and_10_input_data_channel_r15 : input_data_array(255 downto 0);
    signal and_10_input_data_channel_r16 : input_data_array(255 downto 0);
    signal and_11_input_data_channel_r1  : input_data_array(255 downto 0);
    signal and_11_input_data_channel_r2  : input_data_array(255 downto 0);
    signal and_11_input_data_channel_r3  : input_data_array(255 downto 0);
    signal and_11_input_data_channel_r4  : input_data_array(255 downto 0);
    signal and_11_input_data_channel_r5  : input_data_array(255 downto 0);
    signal and_11_input_data_channel_r6  : input_data_array(255 downto 0);
    signal and_11_input_data_channel_r7  : input_data_array(255 downto 0);
    signal and_11_input_data_channel_r8  : input_data_array(255 downto 0);
    signal and_11_input_data_channel_r9  : input_data_array(255 downto 0);
    signal and_11_input_data_channel_r10 : input_data_array(255 downto 0);
    signal and_11_input_data_channel_r11 : input_data_array(255 downto 0);
    signal and_11_input_data_channel_r12 : input_data_array(255 downto 0);
    signal and_11_input_data_channel_r13 : input_data_array(255 downto 0);
    signal and_11_input_data_channel_r14 : input_data_array(255 downto 0);
    signal and_11_input_data_channel_r15 : input_data_array(255 downto 0);
    signal and_11_input_data_channel_r16 : input_data_array(255 downto 0);
    signal and_12_input_data_channel_r1  : input_data_array(255 downto 0);
    signal and_12_input_data_channel_r2  : input_data_array(255 downto 0);
    signal and_12_input_data_channel_r3  : input_data_array(255 downto 0);
    signal and_12_input_data_channel_r4  : input_data_array(255 downto 0);
    signal and_12_input_data_channel_r5  : input_data_array(255 downto 0);
    signal and_12_input_data_channel_r6  : input_data_array(255 downto 0);
    signal and_12_input_data_channel_r7  : input_data_array(255 downto 0);
    signal and_12_input_data_channel_r8  : input_data_array(255 downto 0);
    signal and_12_input_data_channel_r9  : input_data_array(255 downto 0);
    signal and_12_input_data_channel_r10 : input_data_array(255 downto 0);
    signal and_12_input_data_channel_r11 : input_data_array(255 downto 0);
    signal and_12_input_data_channel_r12 : input_data_array(255 downto 0);
    signal and_12_input_data_channel_r13 : input_data_array(255 downto 0);
    signal and_12_input_data_channel_r14 : input_data_array(255 downto 0);
    signal and_12_input_data_channel_r15 : input_data_array(255 downto 0);
    signal and_12_input_data_channel_r16 : input_data_array(255 downto 0);
    signal and_13_input_data_channel_r1  : input_data_array(255 downto 0);
    signal and_13_input_data_channel_r2  : input_data_array(255 downto 0);
    signal and_13_input_data_channel_r3  : input_data_array(255 downto 0);
    signal and_13_input_data_channel_r4  : input_data_array(255 downto 0);
    signal and_13_input_data_channel_r5  : input_data_array(255 downto 0);
    signal and_13_input_data_channel_r6  : input_data_array(255 downto 0);
    signal and_13_input_data_channel_r7  : input_data_array(255 downto 0);
    signal and_13_input_data_channel_r8  : input_data_array(255 downto 0);
    signal and_13_input_data_channel_r9  : input_data_array(255 downto 0);
    signal and_13_input_data_channel_r10 : input_data_array(255 downto 0);
    signal and_13_input_data_channel_r11 : input_data_array(255 downto 0);
    signal and_13_input_data_channel_r12 : input_data_array(255 downto 0);
    signal and_13_input_data_channel_r13 : input_data_array(255 downto 0);
    signal and_13_input_data_channel_r14 : input_data_array(255 downto 0);
    signal and_13_input_data_channel_r15 : input_data_array(255 downto 0);
    signal and_13_input_data_channel_r16 : input_data_array(255 downto 0);
    signal and_14_input_data_channel_r1  : input_data_array(255 downto 0);
    signal and_14_input_data_channel_r2  : input_data_array(255 downto 0);
    signal and_14_input_data_channel_r3  : input_data_array(255 downto 0);
    signal and_14_input_data_channel_r4  : input_data_array(255 downto 0);
    signal and_14_input_data_channel_r5  : input_data_array(255 downto 0);
    signal and_14_input_data_channel_r6  : input_data_array(255 downto 0);
    signal and_14_input_data_channel_r7  : input_data_array(255 downto 0);
    signal and_14_input_data_channel_r8  : input_data_array(255 downto 0);
    signal and_14_input_data_channel_r9  : input_data_array(255 downto 0);
    signal and_14_input_data_channel_r10 : input_data_array(255 downto 0);
    signal and_14_input_data_channel_r11 : input_data_array(255 downto 0);
    signal and_14_input_data_channel_r12 : input_data_array(255 downto 0);
    signal and_14_input_data_channel_r13 : input_data_array(255 downto 0);
    signal and_14_input_data_channel_r14 : input_data_array(255 downto 0);
    signal and_14_input_data_channel_r15 : input_data_array(255 downto 0);
    signal and_14_input_data_channel_r16 : input_data_array(255 downto 0);
    signal and_15_input_data_channel_r1  : input_data_array(255 downto 0);
    signal and_15_input_data_channel_r2  : input_data_array(255 downto 0);
    signal and_15_input_data_channel_r3  : input_data_array(255 downto 0);
    signal and_15_input_data_channel_r4  : input_data_array(255 downto 0);
    signal and_15_input_data_channel_r5  : input_data_array(255 downto 0);
    signal and_15_input_data_channel_r6  : input_data_array(255 downto 0);
    signal and_15_input_data_channel_r7  : input_data_array(255 downto 0);
    signal and_15_input_data_channel_r8  : input_data_array(255 downto 0);
    signal and_15_input_data_channel_r9  : input_data_array(255 downto 0);
    signal and_15_input_data_channel_r10 : input_data_array(255 downto 0);
    signal and_15_input_data_channel_r11 : input_data_array(255 downto 0);
    signal and_15_input_data_channel_r12 : input_data_array(255 downto 0);
    signal and_15_input_data_channel_r13 : input_data_array(255 downto 0);
    signal and_15_input_data_channel_r14 : input_data_array(255 downto 0);
    signal and_15_input_data_channel_r15 : input_data_array(255 downto 0);
    signal and_15_input_data_channel_r16 : input_data_array(255 downto 0);
    --------------------------------------------------------------------------------------------
    -- CLK 17
    signal storage_12                    : input_data_array(255 downto 0);
    signal extrinsic_info_f1_e13         : input_data_array(127 downto 0);
    signal extrinsic_info_f2_e13         : input_data_array(255 downto 128);
    signal cut_0_input_data_channel_r1   : input_data_array(15 downto 0);
    signal cut_0_input_data_channel_r2   : input_data_array(15 downto 0);
    signal cut_0_input_data_channel_r3   : input_data_array(15 downto 0);
    signal cut_0_input_data_channel_r4   : input_data_array(15 downto 0);
    signal cut_0_input_data_channel_r5   : input_data_array(15 downto 0);
    signal cut_0_input_data_channel_r6   : input_data_array(15 downto 0);
    signal cut_0_input_data_channel_r7   : input_data_array(15 downto 0);
    signal cut_0_input_data_channel_r8   : input_data_array(15 downto 0);
    signal cut_0_input_data_channel_r9   : input_data_array(15 downto 0);
    signal cut_0_input_data_channel_r10  : input_data_array(15 downto 0);
    signal cut_0_input_data_channel_r11  : input_data_array(15 downto 0);
    signal cut_0_input_data_channel_r12  : input_data_array(15 downto 0);
    signal cut_0_input_data_channel_r13  : input_data_array(15 downto 0);
    signal cut_0_input_data_channel_r14  : input_data_array(15 downto 0);
    signal cut_0_input_data_channel_r15  : input_data_array(15 downto 0);
    signal cut_0_input_data_channel_r16  : input_data_array(15 downto 0);
    signal cut_1_input_data_channel_r1   : input_data_array(15 downto 0);
    signal cut_1_input_data_channel_r2   : input_data_array(15 downto 0);
    signal cut_1_input_data_channel_r3   : input_data_array(15 downto 0);
    signal cut_1_input_data_channel_r4   : input_data_array(15 downto 0);
    signal cut_1_input_data_channel_r5   : input_data_array(15 downto 0);
    signal cut_1_input_data_channel_r6   : input_data_array(15 downto 0);
    signal cut_1_input_data_channel_r7   : input_data_array(15 downto 0);
    signal cut_1_input_data_channel_r8   : input_data_array(15 downto 0);
    signal cut_1_input_data_channel_r9   : input_data_array(15 downto 0);
    signal cut_1_input_data_channel_r10  : input_data_array(15 downto 0);
    signal cut_1_input_data_channel_r11  : input_data_array(15 downto 0);
    signal cut_1_input_data_channel_r12  : input_data_array(15 downto 0);
    signal cut_1_input_data_channel_r13  : input_data_array(15 downto 0);
    signal cut_1_input_data_channel_r14  : input_data_array(15 downto 0);
    signal cut_1_input_data_channel_r15  : input_data_array(15 downto 0);
    signal cut_1_input_data_channel_r16  : input_data_array(15 downto 0);
    signal cut_2_input_data_channel_r1   : input_data_array(15 downto 0);
    signal cut_2_input_data_channel_r2   : input_data_array(15 downto 0);
    signal cut_2_input_data_channel_r3   : input_data_array(15 downto 0);
    signal cut_2_input_data_channel_r4   : input_data_array(15 downto 0);
    signal cut_2_input_data_channel_r5   : input_data_array(15 downto 0);
    signal cut_2_input_data_channel_r6   : input_data_array(15 downto 0);
    signal cut_2_input_data_channel_r7   : input_data_array(15 downto 0);
    signal cut_2_input_data_channel_r8   : input_data_array(15 downto 0);
    signal cut_2_input_data_channel_r9   : input_data_array(15 downto 0);
    signal cut_2_input_data_channel_r10  : input_data_array(15 downto 0);
    signal cut_2_input_data_channel_r11  : input_data_array(15 downto 0);
    signal cut_2_input_data_channel_r12  : input_data_array(15 downto 0);
    signal cut_2_input_data_channel_r13  : input_data_array(15 downto 0);
    signal cut_2_input_data_channel_r14  : input_data_array(15 downto 0);
    signal cut_2_input_data_channel_r15  : input_data_array(15 downto 0);
    signal cut_2_input_data_channel_r16  : input_data_array(15 downto 0);
    signal cut_3_input_data_channel_r1   : input_data_array(15 downto 0);
    signal cut_3_input_data_channel_r2   : input_data_array(15 downto 0);
    signal cut_3_input_data_channel_r3   : input_data_array(15 downto 0);
    signal cut_3_input_data_channel_r4   : input_data_array(15 downto 0);
    signal cut_3_input_data_channel_r5   : input_data_array(15 downto 0);
    signal cut_3_input_data_channel_r6   : input_data_array(15 downto 0);
    signal cut_3_input_data_channel_r7   : input_data_array(15 downto 0);
    signal cut_3_input_data_channel_r8   : input_data_array(15 downto 0);
    signal cut_3_input_data_channel_r9   : input_data_array(15 downto 0);
    signal cut_3_input_data_channel_r10  : input_data_array(15 downto 0);
    signal cut_3_input_data_channel_r11  : input_data_array(15 downto 0);
    signal cut_3_input_data_channel_r12  : input_data_array(15 downto 0);
    signal cut_3_input_data_channel_r13  : input_data_array(15 downto 0);
    signal cut_3_input_data_channel_r14  : input_data_array(15 downto 0);
    signal cut_3_input_data_channel_r15  : input_data_array(15 downto 0);
    signal cut_3_input_data_channel_r16  : input_data_array(15 downto 0);
    signal cut_4_input_data_channel_r1   : input_data_array(15 downto 0);
    signal cut_4_input_data_channel_r2   : input_data_array(15 downto 0);
    signal cut_4_input_data_channel_r3   : input_data_array(15 downto 0);
    signal cut_4_input_data_channel_r4   : input_data_array(15 downto 0);
    signal cut_4_input_data_channel_r5   : input_data_array(15 downto 0);
    signal cut_4_input_data_channel_r6   : input_data_array(15 downto 0);
    signal cut_4_input_data_channel_r7   : input_data_array(15 downto 0);
    signal cut_4_input_data_channel_r8   : input_data_array(15 downto 0);
    signal cut_4_input_data_channel_r9   : input_data_array(15 downto 0);
    signal cut_4_input_data_channel_r10  : input_data_array(15 downto 0);
    signal cut_4_input_data_channel_r11  : input_data_array(15 downto 0);
    signal cut_4_input_data_channel_r12  : input_data_array(15 downto 0);
    signal cut_4_input_data_channel_r13  : input_data_array(15 downto 0);
    signal cut_4_input_data_channel_r14  : input_data_array(15 downto 0);
    signal cut_4_input_data_channel_r15  : input_data_array(15 downto 0);
    signal cut_4_input_data_channel_r16  : input_data_array(15 downto 0);
    signal cut_5_input_data_channel_r1   : input_data_array(15 downto 0);
    signal cut_5_input_data_channel_r2   : input_data_array(15 downto 0);
    signal cut_5_input_data_channel_r3   : input_data_array(15 downto 0);
    signal cut_5_input_data_channel_r4   : input_data_array(15 downto 0);
    signal cut_5_input_data_channel_r5   : input_data_array(15 downto 0);
    signal cut_5_input_data_channel_r6   : input_data_array(15 downto 0);
    signal cut_5_input_data_channel_r7   : input_data_array(15 downto 0);
    signal cut_5_input_data_channel_r8   : input_data_array(15 downto 0);
    signal cut_5_input_data_channel_r9   : input_data_array(15 downto 0);
    signal cut_5_input_data_channel_r10  : input_data_array(15 downto 0);
    signal cut_5_input_data_channel_r11  : input_data_array(15 downto 0);
    signal cut_5_input_data_channel_r12  : input_data_array(15 downto 0);
    signal cut_5_input_data_channel_r13  : input_data_array(15 downto 0);
    signal cut_5_input_data_channel_r14  : input_data_array(15 downto 0);
    signal cut_5_input_data_channel_r15  : input_data_array(15 downto 0);
    signal cut_5_input_data_channel_r16  : input_data_array(15 downto 0);
    signal cut_6_input_data_channel_r1   : input_data_array(15 downto 0);
    signal cut_6_input_data_channel_r2   : input_data_array(15 downto 0);
    signal cut_6_input_data_channel_r3   : input_data_array(15 downto 0);
    signal cut_6_input_data_channel_r4   : input_data_array(15 downto 0);
    signal cut_6_input_data_channel_r5   : input_data_array(15 downto 0);
    signal cut_6_input_data_channel_r6   : input_data_array(15 downto 0);
    signal cut_6_input_data_channel_r7   : input_data_array(15 downto 0);
    signal cut_6_input_data_channel_r8   : input_data_array(15 downto 0);
    signal cut_6_input_data_channel_r9   : input_data_array(15 downto 0);
    signal cut_6_input_data_channel_r10  : input_data_array(15 downto 0);
    signal cut_6_input_data_channel_r11  : input_data_array(15 downto 0);
    signal cut_6_input_data_channel_r12  : input_data_array(15 downto 0);
    signal cut_6_input_data_channel_r13  : input_data_array(15 downto 0);
    signal cut_6_input_data_channel_r14  : input_data_array(15 downto 0);
    signal cut_6_input_data_channel_r15  : input_data_array(15 downto 0);
    signal cut_6_input_data_channel_r16  : input_data_array(15 downto 0);
    signal cut_7_input_data_channel_r1   : input_data_array(15 downto 0);
    signal cut_7_input_data_channel_r2   : input_data_array(15 downto 0);
    signal cut_7_input_data_channel_r3   : input_data_array(15 downto 0);
    signal cut_7_input_data_channel_r4   : input_data_array(15 downto 0);
    signal cut_7_input_data_channel_r5   : input_data_array(15 downto 0);
    signal cut_7_input_data_channel_r6   : input_data_array(15 downto 0);
    signal cut_7_input_data_channel_r7   : input_data_array(15 downto 0);
    signal cut_7_input_data_channel_r8   : input_data_array(15 downto 0);
    signal cut_7_input_data_channel_r9   : input_data_array(15 downto 0);
    signal cut_7_input_data_channel_r10  : input_data_array(15 downto 0);
    signal cut_7_input_data_channel_r11  : input_data_array(15 downto 0);
    signal cut_7_input_data_channel_r12  : input_data_array(15 downto 0);
    signal cut_7_input_data_channel_r13  : input_data_array(15 downto 0);
    signal cut_7_input_data_channel_r14  : input_data_array(15 downto 0);
    signal cut_7_input_data_channel_r15  : input_data_array(15 downto 0);
    signal cut_7_input_data_channel_r16  : input_data_array(15 downto 0);
    signal cut_8_input_data_channel_r1   : input_data_array(15 downto 0);
    signal cut_8_input_data_channel_r2   : input_data_array(15 downto 0);
    signal cut_8_input_data_channel_r3   : input_data_array(15 downto 0);
    signal cut_8_input_data_channel_r4   : input_data_array(15 downto 0);
    signal cut_8_input_data_channel_r5   : input_data_array(15 downto 0);
    signal cut_8_input_data_channel_r6   : input_data_array(15 downto 0);
    signal cut_8_input_data_channel_r7   : input_data_array(15 downto 0);
    signal cut_8_input_data_channel_r8   : input_data_array(15 downto 0);
    signal cut_8_input_data_channel_r9   : input_data_array(15 downto 0);
    signal cut_8_input_data_channel_r10  : input_data_array(15 downto 0);
    signal cut_8_input_data_channel_r11  : input_data_array(15 downto 0);
    signal cut_8_input_data_channel_r12  : input_data_array(15 downto 0);
    signal cut_8_input_data_channel_r13  : input_data_array(15 downto 0);
    signal cut_8_input_data_channel_r14  : input_data_array(15 downto 0);
    signal cut_8_input_data_channel_r15  : input_data_array(15 downto 0);
    signal cut_8_input_data_channel_r16  : input_data_array(15 downto 0);
    signal cut_9_input_data_channel_r1   : input_data_array(15 downto 0);
    signal cut_9_input_data_channel_r2   : input_data_array(15 downto 0);
    signal cut_9_input_data_channel_r3   : input_data_array(15 downto 0);
    signal cut_9_input_data_channel_r4   : input_data_array(15 downto 0);
    signal cut_9_input_data_channel_r5   : input_data_array(15 downto 0);
    signal cut_9_input_data_channel_r6   : input_data_array(15 downto 0);
    signal cut_9_input_data_channel_r7   : input_data_array(15 downto 0);
    signal cut_9_input_data_channel_r8   : input_data_array(15 downto 0);
    signal cut_9_input_data_channel_r9   : input_data_array(15 downto 0);
    signal cut_9_input_data_channel_r10  : input_data_array(15 downto 0);
    signal cut_9_input_data_channel_r11  : input_data_array(15 downto 0);
    signal cut_9_input_data_channel_r12  : input_data_array(15 downto 0);
    signal cut_9_input_data_channel_r13  : input_data_array(15 downto 0);
    signal cut_9_input_data_channel_r14  : input_data_array(15 downto 0);
    signal cut_9_input_data_channel_r15  : input_data_array(15 downto 0);
    signal cut_9_input_data_channel_r16  : input_data_array(15 downto 0);
    signal cut_10_input_data_channel_r1  : input_data_array(15 downto 0);
    signal cut_10_input_data_channel_r2  : input_data_array(15 downto 0);
    signal cut_10_input_data_channel_r3  : input_data_array(15 downto 0);
    signal cut_10_input_data_channel_r4  : input_data_array(15 downto 0);
    signal cut_10_input_data_channel_r5  : input_data_array(15 downto 0);
    signal cut_10_input_data_channel_r6  : input_data_array(15 downto 0);
    signal cut_10_input_data_channel_r7  : input_data_array(15 downto 0);
    signal cut_10_input_data_channel_r8  : input_data_array(15 downto 0);
    signal cut_10_input_data_channel_r9  : input_data_array(15 downto 0);
    signal cut_10_input_data_channel_r10 : input_data_array(15 downto 0);
    signal cut_10_input_data_channel_r11 : input_data_array(15 downto 0);
    signal cut_10_input_data_channel_r12 : input_data_array(15 downto 0);
    signal cut_10_input_data_channel_r13 : input_data_array(15 downto 0);
    signal cut_10_input_data_channel_r14 : input_data_array(15 downto 0);
    signal cut_10_input_data_channel_r15 : input_data_array(15 downto 0);
    signal cut_10_input_data_channel_r16 : input_data_array(15 downto 0);
    signal cut_11_input_data_channel_r1  : input_data_array(15 downto 0);
    signal cut_11_input_data_channel_r2  : input_data_array(15 downto 0);
    signal cut_11_input_data_channel_r3  : input_data_array(15 downto 0);
    signal cut_11_input_data_channel_r4  : input_data_array(15 downto 0);
    signal cut_11_input_data_channel_r5  : input_data_array(15 downto 0);
    signal cut_11_input_data_channel_r6  : input_data_array(15 downto 0);
    signal cut_11_input_data_channel_r7  : input_data_array(15 downto 0);
    signal cut_11_input_data_channel_r8  : input_data_array(15 downto 0);
    signal cut_11_input_data_channel_r9  : input_data_array(15 downto 0);
    signal cut_11_input_data_channel_r10 : input_data_array(15 downto 0);
    signal cut_11_input_data_channel_r11 : input_data_array(15 downto 0);
    signal cut_11_input_data_channel_r12 : input_data_array(15 downto 0);
    signal cut_11_input_data_channel_r13 : input_data_array(15 downto 0);
    signal cut_11_input_data_channel_r14 : input_data_array(15 downto 0);
    signal cut_11_input_data_channel_r15 : input_data_array(15 downto 0);
    signal cut_11_input_data_channel_r16 : input_data_array(15 downto 0);
    signal cut_12_input_data_channel_r1  : input_data_array(15 downto 0);
    signal cut_12_input_data_channel_r2  : input_data_array(15 downto 0);
    signal cut_12_input_data_channel_r3  : input_data_array(15 downto 0);
    signal cut_12_input_data_channel_r4  : input_data_array(15 downto 0);
    signal cut_12_input_data_channel_r5  : input_data_array(15 downto 0);
    signal cut_12_input_data_channel_r6  : input_data_array(15 downto 0);
    signal cut_12_input_data_channel_r7  : input_data_array(15 downto 0);
    signal cut_12_input_data_channel_r8  : input_data_array(15 downto 0);
    signal cut_12_input_data_channel_r9  : input_data_array(15 downto 0);
    signal cut_12_input_data_channel_r10 : input_data_array(15 downto 0);
    signal cut_12_input_data_channel_r11 : input_data_array(15 downto 0);
    signal cut_12_input_data_channel_r12 : input_data_array(15 downto 0);
    signal cut_12_input_data_channel_r13 : input_data_array(15 downto 0);
    signal cut_12_input_data_channel_r14 : input_data_array(15 downto 0);
    signal cut_12_input_data_channel_r15 : input_data_array(15 downto 0);
    signal cut_12_input_data_channel_r16 : input_data_array(15 downto 0);
    signal cut_13_input_data_channel_r1  : input_data_array(15 downto 0);
    signal cut_13_input_data_channel_r2  : input_data_array(15 downto 0);
    signal cut_13_input_data_channel_r3  : input_data_array(15 downto 0);
    signal cut_13_input_data_channel_r4  : input_data_array(15 downto 0);
    signal cut_13_input_data_channel_r5  : input_data_array(15 downto 0);
    signal cut_13_input_data_channel_r6  : input_data_array(15 downto 0);
    signal cut_13_input_data_channel_r7  : input_data_array(15 downto 0);
    signal cut_13_input_data_channel_r8  : input_data_array(15 downto 0);
    signal cut_13_input_data_channel_r9  : input_data_array(15 downto 0);
    signal cut_13_input_data_channel_r10 : input_data_array(15 downto 0);
    signal cut_13_input_data_channel_r11 : input_data_array(15 downto 0);
    signal cut_13_input_data_channel_r12 : input_data_array(15 downto 0);
    signal cut_13_input_data_channel_r13 : input_data_array(15 downto 0);
    signal cut_13_input_data_channel_r14 : input_data_array(15 downto 0);
    signal cut_13_input_data_channel_r15 : input_data_array(15 downto 0);
    signal cut_13_input_data_channel_r16 : input_data_array(15 downto 0);
    signal cut_14_input_data_channel_r1  : input_data_array(15 downto 0);
    signal cut_14_input_data_channel_r2  : input_data_array(15 downto 0);
    signal cut_14_input_data_channel_r3  : input_data_array(15 downto 0);
    signal cut_14_input_data_channel_r4  : input_data_array(15 downto 0);
    signal cut_14_input_data_channel_r5  : input_data_array(15 downto 0);
    signal cut_14_input_data_channel_r6  : input_data_array(15 downto 0);
    signal cut_14_input_data_channel_r7  : input_data_array(15 downto 0);
    signal cut_14_input_data_channel_r8  : input_data_array(15 downto 0);
    signal cut_14_input_data_channel_r9  : input_data_array(15 downto 0);
    signal cut_14_input_data_channel_r10 : input_data_array(15 downto 0);
    signal cut_14_input_data_channel_r11 : input_data_array(15 downto 0);
    signal cut_14_input_data_channel_r12 : input_data_array(15 downto 0);
    signal cut_14_input_data_channel_r13 : input_data_array(15 downto 0);
    signal cut_14_input_data_channel_r14 : input_data_array(15 downto 0);
    signal cut_14_input_data_channel_r15 : input_data_array(15 downto 0);
    signal cut_14_input_data_channel_r16 : input_data_array(15 downto 0);
    signal cut_15_input_data_channel_r1  : input_data_array(15 downto 0);
    signal cut_15_input_data_channel_r2  : input_data_array(15 downto 0);
    signal cut_15_input_data_channel_r3  : input_data_array(15 downto 0);
    signal cut_15_input_data_channel_r4  : input_data_array(15 downto 0);
    signal cut_15_input_data_channel_r5  : input_data_array(15 downto 0);
    signal cut_15_input_data_channel_r6  : input_data_array(15 downto 0);
    signal cut_15_input_data_channel_r7  : input_data_array(15 downto 0);
    signal cut_15_input_data_channel_r8  : input_data_array(15 downto 0);
    signal cut_15_input_data_channel_r9  : input_data_array(15 downto 0);
    signal cut_15_input_data_channel_r10 : input_data_array(15 downto 0);
    signal cut_15_input_data_channel_r11 : input_data_array(15 downto 0);
    signal cut_15_input_data_channel_r12 : input_data_array(15 downto 0);
    signal cut_15_input_data_channel_r13 : input_data_array(15 downto 0);
    signal cut_15_input_data_channel_r14 : input_data_array(15 downto 0);
    signal cut_15_input_data_channel_r15 : input_data_array(15 downto 0);
    signal cut_15_input_data_channel_r16 : input_data_array(15 downto 0);
    --------------------------------------------------------------------------------------------
    -- CLK 18
    signal storage_13            : input_data_array(255 downto 0);
    signal extrinsic_info_f1_e14 : input_data_array(127 downto 0);
    signal extrinsic_info_f2_e14 : input_data_array(255 downto 128);
    --------------------------------------------------------------------------------------------
    -- CLK 19
    signal storage_14            : input_data_array(255 downto 0);
    signal extrinsic_info_f1_e15 : input_data_array(127 downto 0);
    signal extrinsic_info_f2_e15 : input_data_array(255 downto 128);
    --------------------------------------------------------------------------------------------
    -- CLK 20
    signal storage_15            : input_data_array(255 downto 0);
    signal extrinsic_info_f1_e16 : input_data_array(127 downto 0);
    signal extrinsic_info_f2_e16 : input_data_array(255 downto 128);
    --------------------------------------------------------------------------------------------
    -- CLK 21
    signal send_out_square       : data_square(15 downto 0);
    signal storage_16            : input_data_array(255 downto 0);
    signal extrinsic_info_f1_e17 : input_data_array(127 downto 0);
    signal extrinsic_info_f2_e17 : input_data_array(255 downto 128);
begin
    channel_and_array <= AND_array_4 & AND_array_3;
    ------------------------------------------------------------------------------------------------------------
    -- Define processes : (CLK 1)
    ------------------------------------------------------------------------------------------------------------
    process (clk, reset)
    begin
        if (reset = '1') then
            soft_input_1          <= (others => (others => '0'));
            soft_input_original_1 <= (others => (others => '0'));
        elsif (rising_edge(clk)) then
            for i in 0 to 255 loop
                storage_0(i) <= soft_input(i)(10 downto 3);
            end loop;
            soft_input_1          <= soft_input;
            soft_input_original_1 <= soft_input_original;
        end if;
    end process;
    ------------------------------------------------------------------------------------------------------------
    -- Define processes : (CLK 2)
    ------------------------------------------------------------------------------------------------------------
    process (clk, reset)
    begin
        if (reset = '1') then
            soft_input_2          <= (others => (others => '0'));
            soft_input_original_2 <= (others => (others => '0'));
        elsif (rising_edge(clk)) then
            storage_1    <= storage_0;
            soft_input_2 <= soft_input_1;
            for i in 0 to 255 loop
                if soft_input_original_1(i)(7) = '1' then
                    soft_input_original_2(i) <= "111" & soft_input_original_1(i);
                else
                    soft_input_original_2(i) <= "000" & soft_input_original_1(i);
                end if;
            end loop;
        end if;
    end process;

    ------------------------------------------------------------------------------------------------------------
    -- Define processes : (CLK 3)
    ------------------------------------------------------------------------------------------------------------
    process (clk, reset)
    begin
        if (reset = '1') then
            soft_input_3          <= (others => (others => '0'));
            soft_input_original_3 <= (others => (others => '0'));
            extrinsic_info_1      <= (others => (others => '0'));
        elsif (rising_edge(clk)) then
            storage_2             <= storage_1;
            soft_input_3          <= soft_input_2;
            soft_input_original_3 <= soft_input_original_2;
            for i in 127 downto 0 loop
                extrinsic_info_1(i) <= (soft_input_2(i)(10) & soft_input_2(i)) - (soft_input_original_2(i)(10) & soft_input_original_2(i));
            end loop;
        end if;
    end process;
    ------------------------------------------------------------------------------------------------------------
    -- Define processes : (CLK 4) Disassemble the codeword
    ------------------------------------------------------------------------------------------------------------
    process (clk, reset)
    begin
        if (reset = '1') then
            extrinsic_info_2   <= (others => (others => '0'));
            extrinsic_info_1_1 <= (others => (others => '0'));

        elsif (rising_edge(clk)) then
            storage_3          <= storage_2;
            extrinsic_info_1_1 <= extrinsic_info_1;
            for i in 255 downto 128 loop
                extrinsic_info_2(i) <= (soft_input_3(i)(10) & soft_input_3(i)) - (soft_input_original_3(i)(10) & soft_input_original_3(i));
            end loop;
        end if;
    end process;
    ------------------------------------------------------------------------------------------------------------
    -- Define processes : (CLK 5)
    ------------------------------------------------------------------------------------------------------------
    process (clk, reset)
    begin
        if (reset = '1') then
            extrinsic_info_f1 <= (others => (others => '0'));
            extrinsic_info_f2 <= (others => (others => '0'));
        elsif (rising_edge(clk)) then
            storage_4 <= storage_3;
            for i in 127 downto 0 loop
                extrinsic_info_f1(i) <= extrinsic_info_1_1(i)(11 downto 4);
            end loop;
            for i in 255 downto 128 loop
                extrinsic_info_f2(i) <= extrinsic_info_2(i)(11 downto 4);
            end loop;
        end if;
    end process;
    ------------------------------------------------------------------------------------------------------------
    -- Define processes : (CLK 6) Start seperating decoded codewords
    ------------------------------------------------------------------------------------------------------------
    process (clk, reset)
    begin
        if (reset = '1') then
            extrinsic_info_f1_e1 <= (others => (others => '0'));
            extrinsic_info_f2_e1 <= (others => (others => '0'));
        elsif (rising_edge(clk)) then
            storage_5            <= storage_4;
            extrinsic_info_f1_e1 <= extrinsic_info_f1;
            extrinsic_info_f2_e1 <= extrinsic_info_f2;
        end if;
    end process;
    ------------------------------------------------------------------------------------------------------------
    -- Define processes : (CLK 7)
    ------------------------------------------------------------------------------------------------------------
    process (clk, reset)
    begin
        if (reset = '1') then
            extrinsic_info_f1_e2 <= (others => (others => '0'));
            extrinsic_info_f2_e2 <= (others => (others => '0'));
        elsif (rising_edge(clk)) then
            storage_6            <= storage_5;
            extrinsic_info_f1_e2 <= extrinsic_info_f1_e1;
            extrinsic_info_f2_e2 <= extrinsic_info_f2_e1;
        end if;
    end process;
    ------------------------------------------------------------------------------------------------------------
    -- Define processes : (CLK 8)
    ------------------------------------------------------------------------------------------------------------
    process (clk, reset)
    begin
        if (reset = '1') then
            extrinsic_info_f1_e3 <= (others => (others => '0'));
            extrinsic_info_f2_e3 <= (others => (others => '0'));
        elsif (rising_edge(clk)) then
            storage_7            <= storage_6;
            extrinsic_info_f1_e3 <= extrinsic_info_f1_e2;
            extrinsic_info_f2_e3 <= extrinsic_info_f2_e2;
        end if;
    end process;
    ------------------------------------------------------------------------------------------------------------
    -- Define processes : (CLK 9)
    ------------------------------------------------------------------------------------------------------------
    process (clk, reset)
    begin
        if (reset = '1') then
            extrinsic_info_f1_e4 <= (others => (others => '0'));
            extrinsic_info_f2_e4 <= (others => (others => '0'));
        elsif (rising_edge(clk)) then
            storage_8            <= storage_7;
            extrinsic_info_f1_e4 <= extrinsic_info_f1_e3;
            extrinsic_info_f2_e4 <= extrinsic_info_f2_e3;
        end if;
    end process;
    ------------------------------------------------------------------------------------------------------------
    -- Define processes : (CLK 10)
    ------------------------------------------------------------------------------------------------------------
    process (clk, reset)
    begin
        if (reset = '1') then
            extrinsic_info_f1_e5 <= (others => (others => '0'));
            extrinsic_info_f2_e5 <= (others => (others => '0'));
        elsif (rising_edge(clk)) then
            storage_9            <= storage_8;
            extrinsic_info_f1_e5 <= extrinsic_info_f1_e4;
            extrinsic_info_f2_e5 <= extrinsic_info_f2_e4;
        end if;
    end process;
    ------------------------------------------------------------------------------------------------------------
    -- Define processes : (CLK 11)
    ------------------------------------------------------------------------------------------------------------
    process (clk, reset)
    begin
        if (reset = '1') then
            extrinsic_info_f1_e6 <= (others => (others => '0'));
            extrinsic_info_f2_e6 <= (others => (others => '0'));
        elsif (rising_edge(clk)) then
            storage_10           <= storage_9;
            extrinsic_info_f1_e6 <= extrinsic_info_f1_e5;
            extrinsic_info_f2_e6 <= extrinsic_info_f2_e5;
        end if;
    end process;
    ------------------------------------------------------------------------------------------------------------
    -- Define processes : (CLK 12)
    ------------------------------------------------------------------------------------------------------------
    process (clk, reset)
    begin
        if (reset = '1') then
            extrinsic_info_f1_e7 <= (others => (others => '0'));
            extrinsic_info_f2_e7 <= (others => (others => '0'));
        elsif (rising_edge(clk)) then
            storage_11           <= storage_10;
            extrinsic_info_f1_e7 <= extrinsic_info_f1_e6;
            extrinsic_info_f2_e7 <= extrinsic_info_f2_e6;
        end if;
    end process;
    ------------------------------------------------------------------------------------------------------------
    -- Define processes : (CLK 13)
    ------------------------------------------------------------------------------------------------------------
    process (clk, reset)
    begin
        if (reset = '1') then
            extrinsic_info_f1_e8 <= (others => (others => '0'));
            extrinsic_info_f2_e8 <= (others => (others => '0'));
        elsif (rising_edge(clk)) then
            storage_12           <= storage_11;
            extrinsic_info_f1_e8 <= extrinsic_info_f1_e7;
            extrinsic_info_f2_e8 <= extrinsic_info_f2_e7;
        end if;
    end process;
    ------------------------------------------------------------------------------------------------------------
    -- Define processes : (CLK 14)
    ------------------------------------------------------------------------------------------------------------
    process (clk, reset)
    begin
        if (reset = '1') then
            extrinsic_info_f1_e9 <= (others => (others => '0'));
            extrinsic_info_f2_e9 <= (others => (others => '0'));
        elsif (rising_edge(clk)) then
            storage_13           <= storage_12;
            extrinsic_info_f1_e9 <= extrinsic_info_f1_e8;
            extrinsic_info_f2_e9 <= extrinsic_info_f2_e8;
        end if;
    end process;
    ------------------------------------------------------------------------------------------------------------
    -- Define processes : (CLK 15)
    ------------------------------------------------------------------------------------------------------------
    process (clk, reset)
    begin
        if (reset = '1') then
            extrinsic_info_f1_e10 <= (others => (others => '0'));
            extrinsic_info_f2_e10 <= (others => (others => '0'));
        elsif (rising_edge(clk)) then
            storage_14            <= storage_13;
            extrinsic_info_f1_e10 <= extrinsic_info_f1_e9;
            extrinsic_info_f2_e10 <= extrinsic_info_f2_e9;
        end if;
    end process;
    ------------------------------------------------------------------------------------------------------------
    -- Define processes : (CLK 16)
    ------------------------------------------------------------------------------------------------------------
    process (clk, reset)
    begin
        if (reset = '1') then
            extrinsic_info_f1_e11 <= (others => (others => '0'));
            extrinsic_info_f2_e11 <= (others => (others => '0'));
        elsif (rising_edge(clk)) then
            storage_15            <= storage_14;
            extrinsic_info_f1_e11 <= extrinsic_info_f1_e10;
            extrinsic_info_f2_e11 <= extrinsic_info_f2_e10;
        end if;
    end process;
    ------------------------------------------------------------------------------------------------------------
    -- Define processes : (CLK 17) shift
    ------------------------------------------------------------------------------------------------------------
    process (clk, reset)
    begin
        if (reset = '1') then
            extrinsic_info_f1_e12 <= (others => (others => '0'));
            extrinsic_info_f2_e12 <= (others => (others => '0'));
        elsif (rising_edge(clk)) then
            --storage_array(0)      <= storage_0;
            --storage_array(1)      <= storage_1;
            --storage_array(2)      <= storage_2;
            --storage_array(3)      <= storage_3;
            --storage_array(4)      <= storage_4;
            --storage_array(5)      <= storage_5;
            --storage_array(6)      <= storage_6;
            --storage_array(7)      <= storage_7;
            --storage_array(8)      <= storage_8;
            --storage_array(9)      <= storage_9;
            --storage_array(10)     <= storage_10;
            --storage_array(11)     <= storage_11;
            --storage_array(12)     <= storage_12;
            --storage_array(13)     <= storage_13;
            --storage_array(14)     <= storage_14;
            --storage_array(15)     <= storage_15;
            s_0_input_data_channel_r1   <= storage_0;                                 -- First row
            s_0_input_data_channel_r2   <= storage_0(239 downto 0) & channel_shift_1; -- Second row
            s_0_input_data_channel_r3   <= storage_0(223 downto 0) & channel_shift_2;
            s_0_input_data_channel_r4   <= storage_0(207 downto 0) & channel_shift_3;
            s_0_input_data_channel_r5   <= storage_0(191 downto 0) & channel_shift_4;
            s_0_input_data_channel_r6   <= storage_0(175 downto 0) & channel_shift_5;
            s_0_input_data_channel_r7   <= storage_0(159 downto 0) & channel_shift_6;
            s_0_input_data_channel_r8   <= storage_0(143 downto 0) & channel_shift_7;
            s_0_input_data_channel_r9   <= storage_0(127 downto 0) & channel_shift_8;
            s_0_input_data_channel_r10  <= storage_0(111 downto 0) & channel_shift_9;
            s_0_input_data_channel_r11  <= storage_0(95 downto 0) & channel_shift_10;
            s_0_input_data_channel_r12  <= storage_0(79 downto 0) & channel_shift_11;
            s_0_input_data_channel_r13  <= storage_0(63 downto 0) & channel_shift_12;
            s_0_input_data_channel_r14  <= storage_0(47 downto 0) & channel_shift_13;
            s_0_input_data_channel_r15  <= storage_0(31 downto 0) & channel_shift_14;
            s_0_input_data_channel_r16  <= storage_0(15 downto 0) & channel_shift_15;
            s_1_input_data_channel_r1   <= storage_1;                                 -- First row
            s_1_input_data_channel_r2   <= storage_1(239 downto 0) & channel_shift_1; -- Second row
            s_1_input_data_channel_r3   <= storage_1(223 downto 0) & channel_shift_2;
            s_1_input_data_channel_r4   <= storage_1(207 downto 0) & channel_shift_3;
            s_1_input_data_channel_r5   <= storage_1(191 downto 0) & channel_shift_4;
            s_1_input_data_channel_r6   <= storage_1(175 downto 0) & channel_shift_5;
            s_1_input_data_channel_r7   <= storage_1(159 downto 0) & channel_shift_6;
            s_1_input_data_channel_r8   <= storage_1(143 downto 0) & channel_shift_7;
            s_1_input_data_channel_r9   <= storage_1(127 downto 0) & channel_shift_8;
            s_1_input_data_channel_r10  <= storage_1(111 downto 0) & channel_shift_9;
            s_1_input_data_channel_r11  <= storage_1(95 downto 0) & channel_shift_10;
            s_1_input_data_channel_r12  <= storage_1(79 downto 0) & channel_shift_11;
            s_1_input_data_channel_r13  <= storage_1(63 downto 0) & channel_shift_12;
            s_1_input_data_channel_r14  <= storage_1(47 downto 0) & channel_shift_13;
            s_1_input_data_channel_r15  <= storage_1(31 downto 0) & channel_shift_14;
            s_1_input_data_channel_r16  <= storage_1(15 downto 0) & channel_shift_15;
            s_2_input_data_channel_r1   <= storage_2;                                 -- First row
            s_2_input_data_channel_r2   <= storage_2(239 downto 0) & channel_shift_1; -- Second row
            s_2_input_data_channel_r3   <= storage_2(223 downto 0) & channel_shift_2;
            s_2_input_data_channel_r4   <= storage_2(207 downto 0) & channel_shift_3;
            s_2_input_data_channel_r5   <= storage_2(191 downto 0) & channel_shift_4;
            s_2_input_data_channel_r6   <= storage_2(175 downto 0) & channel_shift_5;
            s_2_input_data_channel_r7   <= storage_2(159 downto 0) & channel_shift_6;
            s_2_input_data_channel_r8   <= storage_2(143 downto 0) & channel_shift_7;
            s_2_input_data_channel_r9   <= storage_2(127 downto 0) & channel_shift_8;
            s_2_input_data_channel_r10  <= storage_2(111 downto 0) & channel_shift_9;
            s_2_input_data_channel_r11  <= storage_2(95 downto 0) & channel_shift_10;
            s_2_input_data_channel_r12  <= storage_2(79 downto 0) & channel_shift_11;
            s_2_input_data_channel_r13  <= storage_2(63 downto 0) & channel_shift_12;
            s_2_input_data_channel_r14  <= storage_2(47 downto 0) & channel_shift_13;
            s_2_input_data_channel_r15  <= storage_2(31 downto 0) & channel_shift_14;
            s_2_input_data_channel_r16  <= storage_2(15 downto 0) & channel_shift_15;
            s_3_input_data_channel_r1   <= storage_3;                                 -- First row
            s_3_input_data_channel_r2   <= storage_3(239 downto 0) & channel_shift_1; -- Second row
            s_3_input_data_channel_r3   <= storage_3(223 downto 0) & channel_shift_2;
            s_3_input_data_channel_r4   <= storage_3(207 downto 0) & channel_shift_3;
            s_3_input_data_channel_r5   <= storage_3(191 downto 0) & channel_shift_4;
            s_3_input_data_channel_r6   <= storage_3(175 downto 0) & channel_shift_5;
            s_3_input_data_channel_r7   <= storage_3(159 downto 0) & channel_shift_6;
            s_3_input_data_channel_r8   <= storage_3(143 downto 0) & channel_shift_7;
            s_3_input_data_channel_r9   <= storage_3(127 downto 0) & channel_shift_8;
            s_3_input_data_channel_r10  <= storage_3(111 downto 0) & channel_shift_9;
            s_3_input_data_channel_r11  <= storage_3(95 downto 0) & channel_shift_10;
            s_3_input_data_channel_r12  <= storage_3(79 downto 0) & channel_shift_11;
            s_3_input_data_channel_r13  <= storage_3(63 downto 0) & channel_shift_12;
            s_3_input_data_channel_r14  <= storage_3(47 downto 0) & channel_shift_13;
            s_3_input_data_channel_r15  <= storage_3(31 downto 0) & channel_shift_14;
            s_3_input_data_channel_r16  <= storage_3(15 downto 0) & channel_shift_15;
            s_4_input_data_channel_r1   <= storage_4;                                 -- First row
            s_4_input_data_channel_r2   <= storage_4(239 downto 0) & channel_shift_1; -- Second row
            s_4_input_data_channel_r3   <= storage_4(223 downto 0) & channel_shift_2;
            s_4_input_data_channel_r4   <= storage_4(207 downto 0) & channel_shift_3;
            s_4_input_data_channel_r5   <= storage_4(191 downto 0) & channel_shift_4;
            s_4_input_data_channel_r6   <= storage_4(175 downto 0) & channel_shift_5;
            s_4_input_data_channel_r7   <= storage_4(159 downto 0) & channel_shift_6;
            s_4_input_data_channel_r8   <= storage_4(143 downto 0) & channel_shift_7;
            s_4_input_data_channel_r9   <= storage_4(127 downto 0) & channel_shift_8;
            s_4_input_data_channel_r10  <= storage_4(111 downto 0) & channel_shift_9;
            s_4_input_data_channel_r11  <= storage_4(95 downto 0) & channel_shift_10;
            s_4_input_data_channel_r12  <= storage_4(79 downto 0) & channel_shift_11;
            s_4_input_data_channel_r13  <= storage_4(63 downto 0) & channel_shift_12;
            s_4_input_data_channel_r14  <= storage_4(47 downto 0) & channel_shift_13;
            s_4_input_data_channel_r15  <= storage_4(31 downto 0) & channel_shift_14;
            s_4_input_data_channel_r16  <= storage_4(15 downto 0) & channel_shift_15;
            s_5_input_data_channel_r1   <= storage_5;                                 -- First row
            s_5_input_data_channel_r2   <= storage_5(239 downto 0) & channel_shift_1; -- Second row
            s_5_input_data_channel_r3   <= storage_5(223 downto 0) & channel_shift_2;
            s_5_input_data_channel_r4   <= storage_5(207 downto 0) & channel_shift_3;
            s_5_input_data_channel_r5   <= storage_5(191 downto 0) & channel_shift_4;
            s_5_input_data_channel_r6   <= storage_5(175 downto 0) & channel_shift_5;
            s_5_input_data_channel_r7   <= storage_5(159 downto 0) & channel_shift_6;
            s_5_input_data_channel_r8   <= storage_5(143 downto 0) & channel_shift_7;
            s_5_input_data_channel_r9   <= storage_5(127 downto 0) & channel_shift_8;
            s_5_input_data_channel_r10  <= storage_5(111 downto 0) & channel_shift_9;
            s_5_input_data_channel_r11  <= storage_5(95 downto 0) & channel_shift_10;
            s_5_input_data_channel_r12  <= storage_5(79 downto 0) & channel_shift_11;
            s_5_input_data_channel_r13  <= storage_5(63 downto 0) & channel_shift_12;
            s_5_input_data_channel_r14  <= storage_5(47 downto 0) & channel_shift_13;
            s_5_input_data_channel_r15  <= storage_5(31 downto 0) & channel_shift_14;
            s_5_input_data_channel_r16  <= storage_5(15 downto 0) & channel_shift_15;
            s_6_input_data_channel_r1   <= storage_6;                                 -- First row
            s_6_input_data_channel_r2   <= storage_6(239 downto 0) & channel_shift_1; -- Second row
            s_6_input_data_channel_r3   <= storage_6(223 downto 0) & channel_shift_2;
            s_6_input_data_channel_r4   <= storage_6(207 downto 0) & channel_shift_3;
            s_6_input_data_channel_r5   <= storage_6(191 downto 0) & channel_shift_4;
            s_6_input_data_channel_r6   <= storage_6(175 downto 0) & channel_shift_5;
            s_6_input_data_channel_r7   <= storage_6(159 downto 0) & channel_shift_6;
            s_6_input_data_channel_r8   <= storage_6(143 downto 0) & channel_shift_7;
            s_6_input_data_channel_r9   <= storage_6(127 downto 0) & channel_shift_8;
            s_6_input_data_channel_r10  <= storage_6(111 downto 0) & channel_shift_9;
            s_6_input_data_channel_r11  <= storage_6(95 downto 0) & channel_shift_10;
            s_6_input_data_channel_r12  <= storage_6(79 downto 0) & channel_shift_11;
            s_6_input_data_channel_r13  <= storage_6(63 downto 0) & channel_shift_12;
            s_6_input_data_channel_r14  <= storage_6(47 downto 0) & channel_shift_13;
            s_6_input_data_channel_r15  <= storage_6(31 downto 0) & channel_shift_14;
            s_6_input_data_channel_r16  <= storage_6(15 downto 0) & channel_shift_15;
            s_7_input_data_channel_r1   <= storage_7;                                 -- First row
            s_7_input_data_channel_r2   <= storage_7(239 downto 0) & channel_shift_1; -- Second row
            s_7_input_data_channel_r3   <= storage_7(223 downto 0) & channel_shift_2;
            s_7_input_data_channel_r4   <= storage_7(207 downto 0) & channel_shift_3;
            s_7_input_data_channel_r5   <= storage_7(191 downto 0) & channel_shift_4;
            s_7_input_data_channel_r6   <= storage_7(175 downto 0) & channel_shift_5;
            s_7_input_data_channel_r7   <= storage_7(159 downto 0) & channel_shift_6;
            s_7_input_data_channel_r8   <= storage_7(143 downto 0) & channel_shift_7;
            s_7_input_data_channel_r9   <= storage_7(127 downto 0) & channel_shift_8;
            s_7_input_data_channel_r10  <= storage_7(111 downto 0) & channel_shift_9;
            s_7_input_data_channel_r11  <= storage_7(95 downto 0) & channel_shift_10;
            s_7_input_data_channel_r12  <= storage_7(79 downto 0) & channel_shift_11;
            s_7_input_data_channel_r13  <= storage_7(63 downto 0) & channel_shift_12;
            s_7_input_data_channel_r14  <= storage_7(47 downto 0) & channel_shift_13;
            s_7_input_data_channel_r15  <= storage_7(31 downto 0) & channel_shift_14;
            s_7_input_data_channel_r16  <= storage_7(15 downto 0) & channel_shift_15;
            s_8_input_data_channel_r1   <= storage_8;                                 -- First row
            s_8_input_data_channel_r2   <= storage_8(239 downto 0) & channel_shift_1; -- Second row
            s_8_input_data_channel_r3   <= storage_8(223 downto 0) & channel_shift_2;
            s_8_input_data_channel_r4   <= storage_8(207 downto 0) & channel_shift_3;
            s_8_input_data_channel_r5   <= storage_8(191 downto 0) & channel_shift_4;
            s_8_input_data_channel_r6   <= storage_8(175 downto 0) & channel_shift_5;
            s_8_input_data_channel_r7   <= storage_8(159 downto 0) & channel_shift_6;
            s_8_input_data_channel_r8   <= storage_8(143 downto 0) & channel_shift_7;
            s_8_input_data_channel_r9   <= storage_8(127 downto 0) & channel_shift_8;
            s_8_input_data_channel_r10  <= storage_8(111 downto 0) & channel_shift_9;
            s_8_input_data_channel_r11  <= storage_8(95 downto 0) & channel_shift_10;
            s_8_input_data_channel_r12  <= storage_8(79 downto 0) & channel_shift_11;
            s_8_input_data_channel_r13  <= storage_8(63 downto 0) & channel_shift_12;
            s_8_input_data_channel_r14  <= storage_8(47 downto 0) & channel_shift_13;
            s_8_input_data_channel_r15  <= storage_8(31 downto 0) & channel_shift_14;
            s_8_input_data_channel_r16  <= storage_8(15 downto 0) & channel_shift_15;
            s_9_input_data_channel_r1   <= storage_9;                                 -- First row
            s_9_input_data_channel_r2   <= storage_9(239 downto 0) & channel_shift_1; -- Second row
            s_9_input_data_channel_r3   <= storage_9(223 downto 0) & channel_shift_2;
            s_9_input_data_channel_r4   <= storage_9(207 downto 0) & channel_shift_3;
            s_9_input_data_channel_r5   <= storage_9(191 downto 0) & channel_shift_4;
            s_9_input_data_channel_r6   <= storage_9(175 downto 0) & channel_shift_5;
            s_9_input_data_channel_r7   <= storage_9(159 downto 0) & channel_shift_6;
            s_9_input_data_channel_r8   <= storage_9(143 downto 0) & channel_shift_7;
            s_9_input_data_channel_r9   <= storage_9(127 downto 0) & channel_shift_8;
            s_9_input_data_channel_r10  <= storage_9(111 downto 0) & channel_shift_9;
            s_9_input_data_channel_r11  <= storage_9(95 downto 0) & channel_shift_10;
            s_9_input_data_channel_r12  <= storage_9(79 downto 0) & channel_shift_11;
            s_9_input_data_channel_r13  <= storage_9(63 downto 0) & channel_shift_12;
            s_9_input_data_channel_r14  <= storage_9(47 downto 0) & channel_shift_13;
            s_9_input_data_channel_r15  <= storage_9(31 downto 0) & channel_shift_14;
            s_9_input_data_channel_r16  <= storage_9(15 downto 0) & channel_shift_15;
            s_10_input_data_channel_r1  <= storage_10;                                 -- First row
            s_10_input_data_channel_r2  <= storage_10(239 downto 0) & channel_shift_1; -- Second row
            s_10_input_data_channel_r3  <= storage_10(223 downto 0) & channel_shift_2;
            s_10_input_data_channel_r4  <= storage_10(207 downto 0) & channel_shift_3;
            s_10_input_data_channel_r5  <= storage_10(191 downto 0) & channel_shift_4;
            s_10_input_data_channel_r6  <= storage_10(175 downto 0) & channel_shift_5;
            s_10_input_data_channel_r7  <= storage_10(159 downto 0) & channel_shift_6;
            s_10_input_data_channel_r8  <= storage_10(143 downto 0) & channel_shift_7;
            s_10_input_data_channel_r9  <= storage_10(127 downto 0) & channel_shift_8;
            s_10_input_data_channel_r10 <= storage_10(111 downto 0) & channel_shift_9;
            s_10_input_data_channel_r11 <= storage_10(95 downto 0) & channel_shift_10;
            s_10_input_data_channel_r12 <= storage_10(79 downto 0) & channel_shift_11;
            s_10_input_data_channel_r13 <= storage_10(63 downto 0) & channel_shift_12;
            s_10_input_data_channel_r14 <= storage_10(47 downto 0) & channel_shift_13;
            s_10_input_data_channel_r15 <= storage_10(31 downto 0) & channel_shift_14;
            s_10_input_data_channel_r16 <= storage_10(15 downto 0) & channel_shift_15;
            s_11_input_data_channel_r1  <= storage_11;                                 -- First row
            s_11_input_data_channel_r2  <= storage_11(239 downto 0) & channel_shift_1; -- Second row
            s_11_input_data_channel_r3  <= storage_11(223 downto 0) & channel_shift_2;
            s_11_input_data_channel_r4  <= storage_11(207 downto 0) & channel_shift_3;
            s_11_input_data_channel_r5  <= storage_11(191 downto 0) & channel_shift_4;
            s_11_input_data_channel_r6  <= storage_11(175 downto 0) & channel_shift_5;
            s_11_input_data_channel_r7  <= storage_11(159 downto 0) & channel_shift_6;
            s_11_input_data_channel_r8  <= storage_11(143 downto 0) & channel_shift_7;
            s_11_input_data_channel_r9  <= storage_11(127 downto 0) & channel_shift_8;
            s_11_input_data_channel_r10 <= storage_11(111 downto 0) & channel_shift_9;
            s_11_input_data_channel_r11 <= storage_11(95 downto 0) & channel_shift_10;
            s_11_input_data_channel_r12 <= storage_11(79 downto 0) & channel_shift_11;
            s_11_input_data_channel_r13 <= storage_11(63 downto 0) & channel_shift_12;
            s_11_input_data_channel_r14 <= storage_11(47 downto 0) & channel_shift_13;
            s_11_input_data_channel_r15 <= storage_11(31 downto 0) & channel_shift_14;
            s_11_input_data_channel_r16 <= storage_11(15 downto 0) & channel_shift_15;
            s_12_input_data_channel_r1  <= storage_12;                                 -- First row
            s_12_input_data_channel_r2  <= storage_12(239 downto 0) & channel_shift_1; -- Second row
            s_12_input_data_channel_r3  <= storage_12(223 downto 0) & channel_shift_2;
            s_12_input_data_channel_r4  <= storage_12(207 downto 0) & channel_shift_3;
            s_12_input_data_channel_r5  <= storage_12(191 downto 0) & channel_shift_4;
            s_12_input_data_channel_r6  <= storage_12(175 downto 0) & channel_shift_5;
            s_12_input_data_channel_r7  <= storage_12(159 downto 0) & channel_shift_6;
            s_12_input_data_channel_r8  <= storage_12(143 downto 0) & channel_shift_7;
            s_12_input_data_channel_r9  <= storage_12(127 downto 0) & channel_shift_8;
            s_12_input_data_channel_r10 <= storage_12(111 downto 0) & channel_shift_9;
            s_12_input_data_channel_r11 <= storage_12(95 downto 0) & channel_shift_10;
            s_12_input_data_channel_r12 <= storage_12(79 downto 0) & channel_shift_11;
            s_12_input_data_channel_r13 <= storage_12(63 downto 0) & channel_shift_12;
            s_12_input_data_channel_r14 <= storage_12(47 downto 0) & channel_shift_13;
            s_12_input_data_channel_r15 <= storage_12(31 downto 0) & channel_shift_14;
            s_12_input_data_channel_r16 <= storage_12(15 downto 0) & channel_shift_15;
            s_13_input_data_channel_r1  <= storage_13;                                 -- First row
            s_13_input_data_channel_r2  <= storage_13(239 downto 0) & channel_shift_1; -- Second row
            s_13_input_data_channel_r3  <= storage_13(223 downto 0) & channel_shift_2;
            s_13_input_data_channel_r4  <= storage_13(207 downto 0) & channel_shift_3;
            s_13_input_data_channel_r5  <= storage_13(191 downto 0) & channel_shift_4;
            s_13_input_data_channel_r6  <= storage_13(175 downto 0) & channel_shift_5;
            s_13_input_data_channel_r7  <= storage_13(159 downto 0) & channel_shift_6;
            s_13_input_data_channel_r8  <= storage_13(143 downto 0) & channel_shift_7;
            s_13_input_data_channel_r9  <= storage_13(127 downto 0) & channel_shift_8;
            s_13_input_data_channel_r10 <= storage_13(111 downto 0) & channel_shift_9;
            s_13_input_data_channel_r11 <= storage_13(95 downto 0) & channel_shift_10;
            s_13_input_data_channel_r12 <= storage_13(79 downto 0) & channel_shift_11;
            s_13_input_data_channel_r13 <= storage_13(63 downto 0) & channel_shift_12;
            s_13_input_data_channel_r14 <= storage_13(47 downto 0) & channel_shift_13;
            s_13_input_data_channel_r15 <= storage_13(31 downto 0) & channel_shift_14;
            s_13_input_data_channel_r16 <= storage_13(15 downto 0) & channel_shift_15;
            s_14_input_data_channel_r1  <= storage_14;                                 -- First row
            s_14_input_data_channel_r2  <= storage_14(239 downto 0) & channel_shift_1; -- Second row
            s_14_input_data_channel_r3  <= storage_14(223 downto 0) & channel_shift_2;
            s_14_input_data_channel_r4  <= storage_14(207 downto 0) & channel_shift_3;
            s_14_input_data_channel_r5  <= storage_14(191 downto 0) & channel_shift_4;
            s_14_input_data_channel_r6  <= storage_14(175 downto 0) & channel_shift_5;
            s_14_input_data_channel_r7  <= storage_14(159 downto 0) & channel_shift_6;
            s_14_input_data_channel_r8  <= storage_14(143 downto 0) & channel_shift_7;
            s_14_input_data_channel_r9  <= storage_14(127 downto 0) & channel_shift_8;
            s_14_input_data_channel_r10 <= storage_14(111 downto 0) & channel_shift_9;
            s_14_input_data_channel_r11 <= storage_14(95 downto 0) & channel_shift_10;
            s_14_input_data_channel_r12 <= storage_14(79 downto 0) & channel_shift_11;
            s_14_input_data_channel_r13 <= storage_14(63 downto 0) & channel_shift_12;
            s_14_input_data_channel_r14 <= storage_14(47 downto 0) & channel_shift_13;
            s_14_input_data_channel_r15 <= storage_14(31 downto 0) & channel_shift_14;
            s_14_input_data_channel_r16 <= storage_14(15 downto 0) & channel_shift_15;
            s_15_input_data_channel_r1  <= storage_15;                                 -- First row
            s_15_input_data_channel_r2  <= storage_15(239 downto 0) & channel_shift_1; -- Second row
            s_15_input_data_channel_r3  <= storage_15(223 downto 0) & channel_shift_2;
            s_15_input_data_channel_r4  <= storage_15(207 downto 0) & channel_shift_3;
            s_15_input_data_channel_r5  <= storage_15(191 downto 0) & channel_shift_4;
            s_15_input_data_channel_r6  <= storage_15(175 downto 0) & channel_shift_5;
            s_15_input_data_channel_r7  <= storage_15(159 downto 0) & channel_shift_6;
            s_15_input_data_channel_r8  <= storage_15(143 downto 0) & channel_shift_7;
            s_15_input_data_channel_r9  <= storage_15(127 downto 0) & channel_shift_8;
            s_15_input_data_channel_r10 <= storage_15(111 downto 0) & channel_shift_9;
            s_15_input_data_channel_r11 <= storage_15(95 downto 0) & channel_shift_10;
            s_15_input_data_channel_r12 <= storage_15(79 downto 0) & channel_shift_11;
            s_15_input_data_channel_r13 <= storage_15(63 downto 0) & channel_shift_12;
            s_15_input_data_channel_r14 <= storage_15(47 downto 0) & channel_shift_13;
            s_15_input_data_channel_r15 <= storage_15(31 downto 0) & channel_shift_14;
            s_15_input_data_channel_r16 <= storage_15(15 downto 0) & channel_shift_15;
            extrinsic_info_f1_e12       <= extrinsic_info_f1_e11;
            extrinsic_info_f2_e12       <= extrinsic_info_f2_e11;
        end if;
    end process;
    ------------------------------------------------------------------------------------------------------------
    -- Define processes : (CLK 18) -- First 16
    ------------------------------------------------------------------------------------------------------------
    process (clk, reset)
    begin
        if (reset = '1') then
            extrinsic_info_f1_e13 <= (others => (others => '0'));
            extrinsic_info_f2_e13 <= (others => (others => '0'));
        elsif (rising_edge(clk)) then
            for i in 0 to 255 loop
                and_0_input_data_channel_r1 (i)  <= s_0_input_data_channel_r1 (i)and channel_and_array(i);
                and_0_input_data_channel_r2 (i)  <= s_0_input_data_channel_r2 (i)and channel_and_array(i);
                and_0_input_data_channel_r3 (i)  <= s_0_input_data_channel_r3 (i)and channel_and_array(i);
                and_0_input_data_channel_r4 (i)  <= s_0_input_data_channel_r4 (i)and channel_and_array(i);
                and_0_input_data_channel_r5 (i)  <= s_0_input_data_channel_r5 (i)and channel_and_array(i);
                and_0_input_data_channel_r6 (i)  <= s_0_input_data_channel_r6 (i)and channel_and_array(i);
                and_0_input_data_channel_r7 (i)  <= s_0_input_data_channel_r7 (i)and channel_and_array(i);
                and_0_input_data_channel_r8 (i)  <= s_0_input_data_channel_r8 (i)and channel_and_array(i);
                and_0_input_data_channel_r9 (i)  <= s_0_input_data_channel_r9 (i)and channel_and_array(i);
                and_0_input_data_channel_r10 (i) <= s_0_input_data_channel_r10(i) and channel_and_array(i);
                and_0_input_data_channel_r11 (i) <= s_0_input_data_channel_r11(i) and channel_and_array(i);
                and_0_input_data_channel_r12 (i) <= s_0_input_data_channel_r12(i) and channel_and_array(i);
                and_0_input_data_channel_r13 (i) <= s_0_input_data_channel_r13(i) and channel_and_array(i);
                and_0_input_data_channel_r14 (i) <= s_0_input_data_channel_r14(i) and channel_and_array(i);
                and_0_input_data_channel_r15 (i) <= s_0_input_data_channel_r15(i) and channel_and_array(i);
                and_0_input_data_channel_r16 (i) <= s_0_input_data_channel_r16(i) and channel_and_array(i);
                and_1_input_data_channel_r1 (i)  <= s_1_input_data_channel_r1 (i)and channel_and_array(i);
                and_1_input_data_channel_r2 (i)  <= s_1_input_data_channel_r2 (i)and channel_and_array(i);
                and_1_input_data_channel_r3 (i)  <= s_1_input_data_channel_r3 (i)and channel_and_array(i);
                and_1_input_data_channel_r4 (i)  <= s_1_input_data_channel_r4 (i)and channel_and_array(i);
                and_1_input_data_channel_r5 (i)  <= s_1_input_data_channel_r5 (i)and channel_and_array(i);
                and_1_input_data_channel_r6 (i)  <= s_1_input_data_channel_r6 (i)and channel_and_array(i);
                and_1_input_data_channel_r7 (i)  <= s_1_input_data_channel_r7 (i)and channel_and_array(i);
                and_1_input_data_channel_r8 (i)  <= s_1_input_data_channel_r8 (i)and channel_and_array(i);
                and_1_input_data_channel_r9 (i)  <= s_1_input_data_channel_r9 (i)and channel_and_array(i);
                and_1_input_data_channel_r10 (i) <= s_1_input_data_channel_r10(i) and channel_and_array(i);
                and_1_input_data_channel_r11 (i) <= s_1_input_data_channel_r11(i) and channel_and_array(i);
                and_1_input_data_channel_r12 (i) <= s_1_input_data_channel_r12(i) and channel_and_array(i);
                and_1_input_data_channel_r13 (i) <= s_1_input_data_channel_r13(i) and channel_and_array(i);
                and_1_input_data_channel_r14 (i) <= s_1_input_data_channel_r14(i) and channel_and_array(i);
                and_1_input_data_channel_r15 (i) <= s_1_input_data_channel_r15(i) and channel_and_array(i);
                and_1_input_data_channel_r16 (i) <= s_1_input_data_channel_r16(i) and channel_and_array(i);
                and_2_input_data_channel_r1 (i)  <= s_2_input_data_channel_r1 (i)and channel_and_array(i);
                and_2_input_data_channel_r2 (i)  <= s_2_input_data_channel_r2 (i)and channel_and_array(i);
                and_2_input_data_channel_r3 (i)  <= s_2_input_data_channel_r3 (i)and channel_and_array(i);
                and_2_input_data_channel_r4 (i)  <= s_2_input_data_channel_r4 (i)and channel_and_array(i);
                and_2_input_data_channel_r5 (i)  <= s_2_input_data_channel_r5 (i)and channel_and_array(i);
                and_2_input_data_channel_r6 (i)  <= s_2_input_data_channel_r6 (i)and channel_and_array(i);
                and_2_input_data_channel_r7 (i)  <= s_2_input_data_channel_r7 (i)and channel_and_array(i);
                and_2_input_data_channel_r8 (i)  <= s_2_input_data_channel_r8 (i)and channel_and_array(i);
                and_2_input_data_channel_r9 (i)  <= s_2_input_data_channel_r9 (i)and channel_and_array(i);
                and_2_input_data_channel_r10 (i) <= s_2_input_data_channel_r10(i) and channel_and_array(i);
                and_2_input_data_channel_r11 (i) <= s_2_input_data_channel_r11(i) and channel_and_array(i);
                and_2_input_data_channel_r12 (i) <= s_2_input_data_channel_r12(i) and channel_and_array(i);
                and_2_input_data_channel_r13 (i) <= s_2_input_data_channel_r13(i) and channel_and_array(i);
                and_2_input_data_channel_r14 (i) <= s_2_input_data_channel_r14(i) and channel_and_array(i);
                and_2_input_data_channel_r15 (i) <= s_2_input_data_channel_r15(i) and channel_and_array(i);
                and_2_input_data_channel_r16 (i) <= s_2_input_data_channel_r16(i) and channel_and_array(i);
                and_3_input_data_channel_r1 (i)  <= s_3_input_data_channel_r1 (i)and channel_and_array(i);
                and_3_input_data_channel_r2 (i)  <= s_3_input_data_channel_r2 (i)and channel_and_array(i);
                and_3_input_data_channel_r3 (i)  <= s_3_input_data_channel_r3 (i)and channel_and_array(i);
                and_3_input_data_channel_r4 (i)  <= s_3_input_data_channel_r4 (i)and channel_and_array(i);
                and_3_input_data_channel_r5 (i)  <= s_3_input_data_channel_r5 (i)and channel_and_array(i);
                and_3_input_data_channel_r6 (i)  <= s_3_input_data_channel_r6 (i)and channel_and_array(i);
                and_3_input_data_channel_r7 (i)  <= s_3_input_data_channel_r7 (i)and channel_and_array(i);
                and_3_input_data_channel_r8 (i)  <= s_3_input_data_channel_r8 (i)and channel_and_array(i);
                and_3_input_data_channel_r9 (i)  <= s_3_input_data_channel_r9 (i)and channel_and_array(i);
                and_3_input_data_channel_r10 (i) <= s_3_input_data_channel_r10(i) and channel_and_array(i);
                and_3_input_data_channel_r11 (i) <= s_3_input_data_channel_r11(i) and channel_and_array(i);
                and_3_input_data_channel_r12 (i) <= s_3_input_data_channel_r12(i) and channel_and_array(i);
                and_3_input_data_channel_r13 (i) <= s_3_input_data_channel_r13(i) and channel_and_array(i);
                and_3_input_data_channel_r14 (i) <= s_3_input_data_channel_r14(i) and channel_and_array(i);
                and_3_input_data_channel_r15 (i) <= s_3_input_data_channel_r15(i) and channel_and_array(i);
                and_3_input_data_channel_r16 (i) <= s_3_input_data_channel_r16(i) and channel_and_array(i);
                and_4_input_data_channel_r1 (i)  <= s_4_input_data_channel_r1 (i)and channel_and_array(i);
                and_4_input_data_channel_r2 (i)  <= s_4_input_data_channel_r2 (i)and channel_and_array(i);
                and_4_input_data_channel_r3 (i)  <= s_4_input_data_channel_r3 (i)and channel_and_array(i);
                and_4_input_data_channel_r4 (i)  <= s_4_input_data_channel_r4 (i)and channel_and_array(i);
                and_4_input_data_channel_r5 (i)  <= s_4_input_data_channel_r5 (i)and channel_and_array(i);
                and_4_input_data_channel_r6 (i)  <= s_4_input_data_channel_r6 (i)and channel_and_array(i);
                and_4_input_data_channel_r7 (i)  <= s_4_input_data_channel_r7 (i)and channel_and_array(i);
                and_4_input_data_channel_r8 (i)  <= s_4_input_data_channel_r8 (i)and channel_and_array(i);
                and_4_input_data_channel_r9 (i)  <= s_4_input_data_channel_r9 (i)and channel_and_array(i);
                and_4_input_data_channel_r10 (i) <= s_4_input_data_channel_r10(i) and channel_and_array(i);
                and_4_input_data_channel_r11 (i) <= s_4_input_data_channel_r11(i) and channel_and_array(i);
                and_4_input_data_channel_r12 (i) <= s_4_input_data_channel_r12(i) and channel_and_array(i);
                and_4_input_data_channel_r13 (i) <= s_4_input_data_channel_r13(i) and channel_and_array(i);
                and_4_input_data_channel_r14 (i) <= s_4_input_data_channel_r14(i) and channel_and_array(i);
                and_4_input_data_channel_r15 (i) <= s_4_input_data_channel_r15(i) and channel_and_array(i);
                and_4_input_data_channel_r16 (i) <= s_4_input_data_channel_r16(i) and channel_and_array(i);
                and_5_input_data_channel_r1 (i)  <= s_5_input_data_channel_r1 (i)and channel_and_array(i);
                and_5_input_data_channel_r2 (i)  <= s_5_input_data_channel_r2 (i)and channel_and_array(i);
                and_5_input_data_channel_r3 (i)  <= s_5_input_data_channel_r3 (i)and channel_and_array(i);
                and_5_input_data_channel_r4 (i)  <= s_5_input_data_channel_r4 (i)and channel_and_array(i);
                and_5_input_data_channel_r5 (i)  <= s_5_input_data_channel_r5 (i)and channel_and_array(i);
                and_5_input_data_channel_r6 (i)  <= s_5_input_data_channel_r6 (i)and channel_and_array(i);
                and_5_input_data_channel_r7 (i)  <= s_5_input_data_channel_r7 (i)and channel_and_array(i);
                and_5_input_data_channel_r8 (i)  <= s_5_input_data_channel_r8 (i)and channel_and_array(i);
                and_5_input_data_channel_r9 (i)  <= s_5_input_data_channel_r9 (i)and channel_and_array(i);
                and_5_input_data_channel_r10 (i) <= s_5_input_data_channel_r10(i) and channel_and_array(i);
                and_5_input_data_channel_r11 (i) <= s_5_input_data_channel_r11(i) and channel_and_array(i);
                and_5_input_data_channel_r12 (i) <= s_5_input_data_channel_r12(i) and channel_and_array(i);
                and_5_input_data_channel_r13 (i) <= s_5_input_data_channel_r13(i) and channel_and_array(i);
                and_5_input_data_channel_r14 (i) <= s_5_input_data_channel_r14(i) and channel_and_array(i);
                and_5_input_data_channel_r15 (i) <= s_5_input_data_channel_r15(i) and channel_and_array(i);
                and_5_input_data_channel_r16 (i) <= s_5_input_data_channel_r16(i) and channel_and_array(i);
                and_6_input_data_channel_r1 (i)  <= s_6_input_data_channel_r1 (i)and channel_and_array(i);
                and_6_input_data_channel_r2 (i)  <= s_6_input_data_channel_r2 (i)and channel_and_array(i);
                and_6_input_data_channel_r3 (i)  <= s_6_input_data_channel_r3 (i)and channel_and_array(i);
                and_6_input_data_channel_r4 (i)  <= s_6_input_data_channel_r4 (i)and channel_and_array(i);
                and_6_input_data_channel_r5 (i)  <= s_6_input_data_channel_r5 (i)and channel_and_array(i);
                and_6_input_data_channel_r6 (i)  <= s_6_input_data_channel_r6 (i)and channel_and_array(i);
                and_6_input_data_channel_r7 (i)  <= s_6_input_data_channel_r7 (i)and channel_and_array(i);
                and_6_input_data_channel_r8 (i)  <= s_6_input_data_channel_r8 (i)and channel_and_array(i);
                and_6_input_data_channel_r9 (i)  <= s_6_input_data_channel_r9 (i)and channel_and_array(i);
                and_6_input_data_channel_r10 (i) <= s_6_input_data_channel_r10(i) and channel_and_array(i);
                and_6_input_data_channel_r11 (i) <= s_6_input_data_channel_r11(i) and channel_and_array(i);
                and_6_input_data_channel_r12 (i) <= s_6_input_data_channel_r12(i) and channel_and_array(i);
                and_6_input_data_channel_r13 (i) <= s_6_input_data_channel_r13(i) and channel_and_array(i);
                and_6_input_data_channel_r14 (i) <= s_6_input_data_channel_r14(i) and channel_and_array(i);
                and_6_input_data_channel_r15 (i) <= s_6_input_data_channel_r15(i) and channel_and_array(i);
                and_6_input_data_channel_r16 (i) <= s_6_input_data_channel_r16(i) and channel_and_array(i);
                and_7_input_data_channel_r1 (i)  <= s_7_input_data_channel_r1 (i)and channel_and_array(i);
                and_7_input_data_channel_r2 (i)  <= s_7_input_data_channel_r2 (i)and channel_and_array(i);
                and_7_input_data_channel_r3 (i)  <= s_7_input_data_channel_r3 (i)and channel_and_array(i);
                and_7_input_data_channel_r4 (i)  <= s_7_input_data_channel_r4 (i)and channel_and_array(i);
                and_7_input_data_channel_r5 (i)  <= s_7_input_data_channel_r5 (i)and channel_and_array(i);
                and_7_input_data_channel_r6 (i)  <= s_7_input_data_channel_r6 (i)and channel_and_array(i);
                and_7_input_data_channel_r7 (i)  <= s_7_input_data_channel_r7 (i)and channel_and_array(i);
                and_7_input_data_channel_r8 (i)  <= s_7_input_data_channel_r8 (i)and channel_and_array(i);
                and_7_input_data_channel_r9 (i)  <= s_7_input_data_channel_r9 (i)and channel_and_array(i);
                and_7_input_data_channel_r10 (i) <= s_7_input_data_channel_r10(i) and channel_and_array(i);
                and_7_input_data_channel_r11 (i) <= s_7_input_data_channel_r11(i) and channel_and_array(i);
                and_7_input_data_channel_r12 (i) <= s_7_input_data_channel_r12(i) and channel_and_array(i);
                and_7_input_data_channel_r13 (i) <= s_7_input_data_channel_r13(i) and channel_and_array(i);
                and_7_input_data_channel_r14 (i) <= s_7_input_data_channel_r14(i) and channel_and_array(i);
                and_7_input_data_channel_r15 (i) <= s_7_input_data_channel_r15(i) and channel_and_array(i);
                and_7_input_data_channel_r16 (i) <= s_7_input_data_channel_r16(i) and channel_and_array(i);
                and_8_input_data_channel_r1 (i)  <= s_8_input_data_channel_r1 (i)and channel_and_array(i);
                and_8_input_data_channel_r2 (i)  <= s_8_input_data_channel_r2 (i)and channel_and_array(i);
                and_8_input_data_channel_r3 (i)  <= s_8_input_data_channel_r3 (i)and channel_and_array(i);
                and_8_input_data_channel_r4 (i)  <= s_8_input_data_channel_r4 (i)and channel_and_array(i);
                and_8_input_data_channel_r5 (i)  <= s_8_input_data_channel_r5 (i)and channel_and_array(i);
                and_8_input_data_channel_r6 (i)  <= s_8_input_data_channel_r6 (i)and channel_and_array(i);
                and_8_input_data_channel_r7 (i)  <= s_8_input_data_channel_r7 (i)and channel_and_array(i);
                and_8_input_data_channel_r8 (i)  <= s_8_input_data_channel_r8 (i)and channel_and_array(i);
                and_8_input_data_channel_r9 (i)  <= s_8_input_data_channel_r9 (i)and channel_and_array(i);
                and_8_input_data_channel_r10 (i) <= s_8_input_data_channel_r10(i) and channel_and_array(i);
                and_8_input_data_channel_r11 (i) <= s_8_input_data_channel_r11(i) and channel_and_array(i);
                and_8_input_data_channel_r12 (i) <= s_8_input_data_channel_r12(i) and channel_and_array(i);
                and_8_input_data_channel_r13 (i) <= s_8_input_data_channel_r13(i) and channel_and_array(i);
                and_8_input_data_channel_r14 (i) <= s_8_input_data_channel_r14(i) and channel_and_array(i);
                and_8_input_data_channel_r15 (i) <= s_8_input_data_channel_r15(i) and channel_and_array(i);
                and_8_input_data_channel_r16 (i) <= s_8_input_data_channel_r16(i) and channel_and_array(i);
                and_9_input_data_channel_r1 (i)  <= s_9_input_data_channel_r1 (i)and channel_and_array(i);
                and_9_input_data_channel_r2 (i)  <= s_9_input_data_channel_r2 (i)and channel_and_array(i);
                and_9_input_data_channel_r3 (i)  <= s_9_input_data_channel_r3 (i)and channel_and_array(i);
                and_9_input_data_channel_r4 (i)  <= s_9_input_data_channel_r4 (i)and channel_and_array(i);
                and_9_input_data_channel_r5 (i)  <= s_9_input_data_channel_r5 (i)and channel_and_array(i);
                and_9_input_data_channel_r6 (i)  <= s_9_input_data_channel_r6 (i)and channel_and_array(i);
                and_9_input_data_channel_r7 (i)  <= s_9_input_data_channel_r7 (i)and channel_and_array(i);
                and_9_input_data_channel_r8 (i)  <= s_9_input_data_channel_r8 (i)and channel_and_array(i);
                and_9_input_data_channel_r9 (i)  <= s_9_input_data_channel_r9 (i)and channel_and_array(i);
                and_9_input_data_channel_r10 (i) <= s_9_input_data_channel_r10(i) and channel_and_array(i);
                and_9_input_data_channel_r11 (i) <= s_9_input_data_channel_r11(i) and channel_and_array(i);
                and_9_input_data_channel_r12 (i) <= s_9_input_data_channel_r12(i) and channel_and_array(i);
                and_9_input_data_channel_r13 (i) <= s_9_input_data_channel_r13(i) and channel_and_array(i);
                and_9_input_data_channel_r14 (i) <= s_9_input_data_channel_r14(i) and channel_and_array(i);
                and_9_input_data_channel_r15 (i) <= s_9_input_data_channel_r15(i) and channel_and_array(i);
                and_9_input_data_channel_r16 (i) <= s_9_input_data_channel_r16(i) and channel_and_array(i);
                and_10_input_data_channel_r1 (i) <= s_10_input_data_channel_r1(i) and channel_and_array(i);
                and_10_input_data_channel_r2 (i) <= s_10_input_data_channel_r2(i) and channel_and_array(i);
                and_10_input_data_channel_r3 (i) <= s_10_input_data_channel_r3(i) and channel_and_array(i);
                and_10_input_data_channel_r4 (i) <= s_10_input_data_channel_r4(i) and channel_and_array(i);
                and_10_input_data_channel_r5 (i) <= s_10_input_data_channel_r5(i) and channel_and_array(i);
                and_10_input_data_channel_r6 (i) <= s_10_input_data_channel_r6(i) and channel_and_array(i);
                and_10_input_data_channel_r7 (i) <= s_10_input_data_channel_r7(i) and channel_and_array(i);
                and_10_input_data_channel_r8 (i) <= s_10_input_data_channel_r8(i) and channel_and_array(i);
                and_10_input_data_channel_r9 (i) <= s_10_input_data_channel_r9(i) and channel_and_array(i);
                and_10_input_data_channel_r10(i) <= s_10_input_data_channel_r10(i) and channel_and_array(i);
                and_10_input_data_channel_r11(i) <= s_10_input_data_channel_r11(i) and channel_and_array(i);
                and_10_input_data_channel_r12(i) <= s_10_input_data_channel_r12(i) and channel_and_array(i);
                and_10_input_data_channel_r13(i) <= s_10_input_data_channel_r13(i) and channel_and_array(i);
                and_10_input_data_channel_r14(i) <= s_10_input_data_channel_r14(i) and channel_and_array(i);
                and_10_input_data_channel_r15(i) <= s_10_input_data_channel_r15(i) and channel_and_array(i);
                and_10_input_data_channel_r16(i) <= s_10_input_data_channel_r16(i) and channel_and_array(i);
                and_11_input_data_channel_r1 (i) <= s_11_input_data_channel_r1(i) and channel_and_array(i);
                and_11_input_data_channel_r2 (i) <= s_11_input_data_channel_r2(i) and channel_and_array(i);
                and_11_input_data_channel_r3 (i) <= s_11_input_data_channel_r3(i) and channel_and_array(i);
                and_11_input_data_channel_r4 (i) <= s_11_input_data_channel_r4(i) and channel_and_array(i);
                and_11_input_data_channel_r5 (i) <= s_11_input_data_channel_r5(i) and channel_and_array(i);
                and_11_input_data_channel_r6 (i) <= s_11_input_data_channel_r6(i) and channel_and_array(i);
                and_11_input_data_channel_r7 (i) <= s_11_input_data_channel_r7(i) and channel_and_array(i);
                and_11_input_data_channel_r8 (i) <= s_11_input_data_channel_r8(i) and channel_and_array(i);
                and_11_input_data_channel_r9 (i) <= s_11_input_data_channel_r9(i) and channel_and_array(i);
                and_11_input_data_channel_r10(i) <= s_11_input_data_channel_r10(i) and channel_and_array(i);
                and_11_input_data_channel_r11(i) <= s_11_input_data_channel_r11(i) and channel_and_array(i);
                and_11_input_data_channel_r12(i) <= s_11_input_data_channel_r12(i) and channel_and_array(i);
                and_11_input_data_channel_r13(i) <= s_11_input_data_channel_r13(i) and channel_and_array(i);
                and_11_input_data_channel_r14(i) <= s_11_input_data_channel_r14(i) and channel_and_array(i);
                and_11_input_data_channel_r15(i) <= s_11_input_data_channel_r15(i) and channel_and_array(i);
                and_11_input_data_channel_r16(i) <= s_11_input_data_channel_r16(i) and channel_and_array(i);
                and_12_input_data_channel_r1 (i) <= s_12_input_data_channel_r1(i) and channel_and_array(i);
                and_12_input_data_channel_r2 (i) <= s_12_input_data_channel_r2(i) and channel_and_array(i);
                and_12_input_data_channel_r3 (i) <= s_12_input_data_channel_r3(i) and channel_and_array(i);
                and_12_input_data_channel_r4 (i) <= s_12_input_data_channel_r4(i) and channel_and_array(i);
                and_12_input_data_channel_r5 (i) <= s_12_input_data_channel_r5(i) and channel_and_array(i);
                and_12_input_data_channel_r6 (i) <= s_12_input_data_channel_r6(i) and channel_and_array(i);
                and_12_input_data_channel_r7 (i) <= s_12_input_data_channel_r7(i) and channel_and_array(i);
                and_12_input_data_channel_r8 (i) <= s_12_input_data_channel_r8(i) and channel_and_array(i);
                and_12_input_data_channel_r9 (i) <= s_12_input_data_channel_r9(i) and channel_and_array(i);
                and_12_input_data_channel_r10(i) <= s_12_input_data_channel_r10(i) and channel_and_array(i);
                and_12_input_data_channel_r11(i) <= s_12_input_data_channel_r11(i) and channel_and_array(i);
                and_12_input_data_channel_r12(i) <= s_12_input_data_channel_r12(i) and channel_and_array(i);
                and_12_input_data_channel_r13(i) <= s_12_input_data_channel_r13(i) and channel_and_array(i);
                and_12_input_data_channel_r14(i) <= s_12_input_data_channel_r14(i) and channel_and_array(i);
                and_12_input_data_channel_r15(i) <= s_12_input_data_channel_r15(i) and channel_and_array(i);
                and_12_input_data_channel_r16(i) <= s_12_input_data_channel_r16(i) and channel_and_array(i);
                and_13_input_data_channel_r1 (i) <= s_13_input_data_channel_r1(i) and channel_and_array(i);
                and_13_input_data_channel_r2 (i) <= s_13_input_data_channel_r2(i) and channel_and_array(i);
                and_13_input_data_channel_r3 (i) <= s_13_input_data_channel_r3(i) and channel_and_array(i);
                and_13_input_data_channel_r4 (i) <= s_13_input_data_channel_r4(i) and channel_and_array(i);
                and_13_input_data_channel_r5 (i) <= s_13_input_data_channel_r5(i) and channel_and_array(i);
                and_13_input_data_channel_r6 (i) <= s_13_input_data_channel_r6(i) and channel_and_array(i);
                and_13_input_data_channel_r7 (i) <= s_13_input_data_channel_r7(i) and channel_and_array(i);
                and_13_input_data_channel_r8 (i) <= s_13_input_data_channel_r8(i) and channel_and_array(i);
                and_13_input_data_channel_r9 (i) <= s_13_input_data_channel_r9(i) and channel_and_array(i);
                and_13_input_data_channel_r10(i) <= s_13_input_data_channel_r10(i) and channel_and_array(i);
                and_13_input_data_channel_r11(i) <= s_13_input_data_channel_r11(i) and channel_and_array(i);
                and_13_input_data_channel_r12(i) <= s_13_input_data_channel_r12(i) and channel_and_array(i);
                and_13_input_data_channel_r13(i) <= s_13_input_data_channel_r13(i) and channel_and_array(i);
                and_13_input_data_channel_r14(i) <= s_13_input_data_channel_r14(i) and channel_and_array(i);
                and_13_input_data_channel_r15(i) <= s_13_input_data_channel_r15(i) and channel_and_array(i);
                and_13_input_data_channel_r16(i) <= s_13_input_data_channel_r16(i) and channel_and_array(i);
                and_14_input_data_channel_r1 (i) <= s_14_input_data_channel_r1(i) and channel_and_array(i);
                and_14_input_data_channel_r2 (i) <= s_14_input_data_channel_r2(i) and channel_and_array(i);
                and_14_input_data_channel_r3 (i) <= s_14_input_data_channel_r3(i) and channel_and_array(i);
                and_14_input_data_channel_r4 (i) <= s_14_input_data_channel_r4(i) and channel_and_array(i);
                and_14_input_data_channel_r5 (i) <= s_14_input_data_channel_r5(i) and channel_and_array(i);
                and_14_input_data_channel_r6 (i) <= s_14_input_data_channel_r6(i) and channel_and_array(i);
                and_14_input_data_channel_r7 (i) <= s_14_input_data_channel_r7(i) and channel_and_array(i);
                and_14_input_data_channel_r8 (i) <= s_14_input_data_channel_r8(i) and channel_and_array(i);
                and_14_input_data_channel_r9 (i) <= s_14_input_data_channel_r9(i) and channel_and_array(i);
                and_14_input_data_channel_r10(i) <= s_14_input_data_channel_r10(i) and channel_and_array(i);
                and_14_input_data_channel_r11(i) <= s_14_input_data_channel_r11(i) and channel_and_array(i);
                and_14_input_data_channel_r12(i) <= s_14_input_data_channel_r12(i) and channel_and_array(i);
                and_14_input_data_channel_r13(i) <= s_14_input_data_channel_r13(i) and channel_and_array(i);
                and_14_input_data_channel_r14(i) <= s_14_input_data_channel_r14(i) and channel_and_array(i);
                and_14_input_data_channel_r15(i) <= s_14_input_data_channel_r15(i) and channel_and_array(i);
                and_14_input_data_channel_r16(i) <= s_14_input_data_channel_r16(i) and channel_and_array(i);
                and_15_input_data_channel_r1 (i) <= s_15_input_data_channel_r1(i) and channel_and_array(i);
                and_15_input_data_channel_r2 (i) <= s_15_input_data_channel_r2(i) and channel_and_array(i);
                and_15_input_data_channel_r3 (i) <= s_15_input_data_channel_r3(i) and channel_and_array(i);
                and_15_input_data_channel_r4 (i) <= s_15_input_data_channel_r4(i) and channel_and_array(i);
                and_15_input_data_channel_r5 (i) <= s_15_input_data_channel_r5(i) and channel_and_array(i);
                and_15_input_data_channel_r6 (i) <= s_15_input_data_channel_r6(i) and channel_and_array(i);
                and_15_input_data_channel_r7 (i) <= s_15_input_data_channel_r7(i) and channel_and_array(i);
                and_15_input_data_channel_r8 (i) <= s_15_input_data_channel_r8(i) and channel_and_array(i);
                and_15_input_data_channel_r9 (i) <= s_15_input_data_channel_r9(i) and channel_and_array(i);
                and_15_input_data_channel_r10(i) <= s_15_input_data_channel_r10(i) and channel_and_array(i);
                and_15_input_data_channel_r11(i) <= s_15_input_data_channel_r11(i) and channel_and_array(i);
                and_15_input_data_channel_r12(i) <= s_15_input_data_channel_r12(i) and channel_and_array(i);
                and_15_input_data_channel_r13(i) <= s_15_input_data_channel_r13(i) and channel_and_array(i);
                and_15_input_data_channel_r14(i) <= s_15_input_data_channel_r14(i) and channel_and_array(i);
                and_15_input_data_channel_r15(i) <= s_15_input_data_channel_r15(i) and channel_and_array(i);
                and_15_input_data_channel_r16(i) <= s_15_input_data_channel_r16(i) and channel_and_array(i);
            end loop;
            extrinsic_info_f1_e13 <= extrinsic_info_f1_e12;
            extrinsic_info_f2_e13 <= extrinsic_info_f2_e12;
        end if;
    end process;
    ------------------------------------------------------------------------------------------------------------
    -- Define processes : (CLK 19)
    ------------------------------------------------------------------------------------------------------------
    process (clk, reset)
    begin
        if (reset = '1') then
            extrinsic_info_f1_e14 <= (others => (others => '0'));
            extrinsic_info_f2_e14 <= (others => (others => '0'));
        elsif (rising_edge(clk)) then
            cut_0_input_data_channel_r1   <= and_0_input_data_channel_r1(255 downto 240);
            cut_0_input_data_channel_r2   <= and_0_input_data_channel_r2(255 downto 240);
            cut_0_input_data_channel_r3   <= and_0_input_data_channel_r3(255 downto 240);
            cut_0_input_data_channel_r4   <= and_0_input_data_channel_r4(255 downto 240);
            cut_0_input_data_channel_r5   <= and_0_input_data_channel_r5(255 downto 240);
            cut_0_input_data_channel_r6   <= and_0_input_data_channel_r6(255 downto 240);
            cut_0_input_data_channel_r7   <= and_0_input_data_channel_r7(255 downto 240);
            cut_0_input_data_channel_r8   <= and_0_input_data_channel_r8(255 downto 240);
            cut_0_input_data_channel_r9   <= and_0_input_data_channel_r9(255 downto 240);
            cut_0_input_data_channel_r10  <= and_0_input_data_channel_r10(255 downto 240);
            cut_0_input_data_channel_r11  <= and_0_input_data_channel_r11(255 downto 240);
            cut_0_input_data_channel_r12  <= and_0_input_data_channel_r12(255 downto 240);
            cut_0_input_data_channel_r13  <= and_0_input_data_channel_r13(255 downto 240);
            cut_0_input_data_channel_r14  <= and_0_input_data_channel_r14(255 downto 240);
            cut_0_input_data_channel_r15  <= and_0_input_data_channel_r15(255 downto 240);
            cut_0_input_data_channel_r16  <= and_0_input_data_channel_r16(255 downto 240);
            cut_1_input_data_channel_r1   <= and_1_input_data_channel_r1(255 downto 240);
            cut_1_input_data_channel_r2   <= and_1_input_data_channel_r2(255 downto 240);
            cut_1_input_data_channel_r3   <= and_1_input_data_channel_r3(255 downto 240);
            cut_1_input_data_channel_r4   <= and_1_input_data_channel_r4(255 downto 240);
            cut_1_input_data_channel_r5   <= and_1_input_data_channel_r5(255 downto 240);
            cut_1_input_data_channel_r6   <= and_1_input_data_channel_r6(255 downto 240);
            cut_1_input_data_channel_r7   <= and_1_input_data_channel_r7(255 downto 240);
            cut_1_input_data_channel_r8   <= and_1_input_data_channel_r8(255 downto 240);
            cut_1_input_data_channel_r9   <= and_1_input_data_channel_r9(255 downto 240);
            cut_1_input_data_channel_r10  <= and_1_input_data_channel_r10(255 downto 240);
            cut_1_input_data_channel_r11  <= and_1_input_data_channel_r11(255 downto 240);
            cut_1_input_data_channel_r12  <= and_1_input_data_channel_r12(255 downto 240);
            cut_1_input_data_channel_r13  <= and_1_input_data_channel_r13(255 downto 240);
            cut_1_input_data_channel_r14  <= and_1_input_data_channel_r14(255 downto 240);
            cut_1_input_data_channel_r15  <= and_1_input_data_channel_r15(255 downto 240);
            cut_1_input_data_channel_r16  <= and_1_input_data_channel_r16(255 downto 240);
            cut_2_input_data_channel_r1   <= and_2_input_data_channel_r1(255 downto 240);
            cut_2_input_data_channel_r2   <= and_2_input_data_channel_r2(255 downto 240);
            cut_2_input_data_channel_r3   <= and_2_input_data_channel_r3(255 downto 240);
            cut_2_input_data_channel_r4   <= and_2_input_data_channel_r4(255 downto 240);
            cut_2_input_data_channel_r5   <= and_2_input_data_channel_r5(255 downto 240);
            cut_2_input_data_channel_r6   <= and_2_input_data_channel_r6(255 downto 240);
            cut_2_input_data_channel_r7   <= and_2_input_data_channel_r7(255 downto 240);
            cut_2_input_data_channel_r8   <= and_2_input_data_channel_r8(255 downto 240);
            cut_2_input_data_channel_r9   <= and_2_input_data_channel_r9(255 downto 240);
            cut_2_input_data_channel_r10  <= and_2_input_data_channel_r10(255 downto 240);
            cut_2_input_data_channel_r11  <= and_2_input_data_channel_r11(255 downto 240);
            cut_2_input_data_channel_r12  <= and_2_input_data_channel_r12(255 downto 240);
            cut_2_input_data_channel_r13  <= and_2_input_data_channel_r13(255 downto 240);
            cut_2_input_data_channel_r14  <= and_2_input_data_channel_r14(255 downto 240);
            cut_2_input_data_channel_r15  <= and_2_input_data_channel_r15(255 downto 240);
            cut_2_input_data_channel_r16  <= and_2_input_data_channel_r16(255 downto 240);
            cut_3_input_data_channel_r1   <= and_3_input_data_channel_r1(255 downto 240);
            cut_3_input_data_channel_r2   <= and_3_input_data_channel_r2(255 downto 240);
            cut_3_input_data_channel_r3   <= and_3_input_data_channel_r3(255 downto 240);
            cut_3_input_data_channel_r4   <= and_3_input_data_channel_r4(255 downto 240);
            cut_3_input_data_channel_r5   <= and_3_input_data_channel_r5(255 downto 240);
            cut_3_input_data_channel_r6   <= and_3_input_data_channel_r6(255 downto 240);
            cut_3_input_data_channel_r7   <= and_3_input_data_channel_r7(255 downto 240);
            cut_3_input_data_channel_r8   <= and_3_input_data_channel_r8(255 downto 240);
            cut_3_input_data_channel_r9   <= and_3_input_data_channel_r9(255 downto 240);
            cut_3_input_data_channel_r10  <= and_3_input_data_channel_r10(255 downto 240);
            cut_3_input_data_channel_r11  <= and_3_input_data_channel_r11(255 downto 240);
            cut_3_input_data_channel_r12  <= and_3_input_data_channel_r12(255 downto 240);
            cut_3_input_data_channel_r13  <= and_3_input_data_channel_r13(255 downto 240);
            cut_3_input_data_channel_r14  <= and_3_input_data_channel_r14(255 downto 240);
            cut_3_input_data_channel_r15  <= and_3_input_data_channel_r15(255 downto 240);
            cut_3_input_data_channel_r16  <= and_3_input_data_channel_r16(255 downto 240);
            cut_4_input_data_channel_r1   <= and_4_input_data_channel_r1(255 downto 240);
            cut_4_input_data_channel_r2   <= and_4_input_data_channel_r2(255 downto 240);
            cut_4_input_data_channel_r3   <= and_4_input_data_channel_r3(255 downto 240);
            cut_4_input_data_channel_r4   <= and_4_input_data_channel_r4(255 downto 240);
            cut_4_input_data_channel_r5   <= and_4_input_data_channel_r5(255 downto 240);
            cut_4_input_data_channel_r6   <= and_4_input_data_channel_r6(255 downto 240);
            cut_4_input_data_channel_r7   <= and_4_input_data_channel_r7(255 downto 240);
            cut_4_input_data_channel_r8   <= and_4_input_data_channel_r8(255 downto 240);
            cut_4_input_data_channel_r9   <= and_4_input_data_channel_r9(255 downto 240);
            cut_4_input_data_channel_r10  <= and_4_input_data_channel_r10(255 downto 240);
            cut_4_input_data_channel_r11  <= and_4_input_data_channel_r11(255 downto 240);
            cut_4_input_data_channel_r12  <= and_4_input_data_channel_r12(255 downto 240);
            cut_4_input_data_channel_r13  <= and_4_input_data_channel_r13(255 downto 240);
            cut_4_input_data_channel_r14  <= and_4_input_data_channel_r14(255 downto 240);
            cut_4_input_data_channel_r15  <= and_4_input_data_channel_r15(255 downto 240);
            cut_4_input_data_channel_r16  <= and_4_input_data_channel_r16(255 downto 240);
            cut_5_input_data_channel_r1   <= and_5_input_data_channel_r1(255 downto 240);
            cut_5_input_data_channel_r2   <= and_5_input_data_channel_r2(255 downto 240);
            cut_5_input_data_channel_r3   <= and_5_input_data_channel_r3(255 downto 240);
            cut_5_input_data_channel_r4   <= and_5_input_data_channel_r4(255 downto 240);
            cut_5_input_data_channel_r5   <= and_5_input_data_channel_r5(255 downto 240);
            cut_5_input_data_channel_r6   <= and_5_input_data_channel_r6(255 downto 240);
            cut_5_input_data_channel_r7   <= and_5_input_data_channel_r7(255 downto 240);
            cut_5_input_data_channel_r8   <= and_5_input_data_channel_r8(255 downto 240);
            cut_5_input_data_channel_r9   <= and_5_input_data_channel_r9(255 downto 240);
            cut_5_input_data_channel_r10  <= and_5_input_data_channel_r10(255 downto 240);
            cut_5_input_data_channel_r11  <= and_5_input_data_channel_r11(255 downto 240);
            cut_5_input_data_channel_r12  <= and_5_input_data_channel_r12(255 downto 240);
            cut_5_input_data_channel_r13  <= and_5_input_data_channel_r13(255 downto 240);
            cut_5_input_data_channel_r14  <= and_5_input_data_channel_r14(255 downto 240);
            cut_5_input_data_channel_r15  <= and_5_input_data_channel_r15(255 downto 240);
            cut_5_input_data_channel_r16  <= and_5_input_data_channel_r16(255 downto 240);
            cut_6_input_data_channel_r1   <= and_6_input_data_channel_r1(255 downto 240);
            cut_6_input_data_channel_r2   <= and_6_input_data_channel_r2(255 downto 240);
            cut_6_input_data_channel_r3   <= and_6_input_data_channel_r3(255 downto 240);
            cut_6_input_data_channel_r4   <= and_6_input_data_channel_r4(255 downto 240);
            cut_6_input_data_channel_r5   <= and_6_input_data_channel_r5(255 downto 240);
            cut_6_input_data_channel_r6   <= and_6_input_data_channel_r6(255 downto 240);
            cut_6_input_data_channel_r7   <= and_6_input_data_channel_r7(255 downto 240);
            cut_6_input_data_channel_r8   <= and_6_input_data_channel_r8(255 downto 240);
            cut_6_input_data_channel_r9   <= and_6_input_data_channel_r9(255 downto 240);
            cut_6_input_data_channel_r10  <= and_6_input_data_channel_r10(255 downto 240);
            cut_6_input_data_channel_r11  <= and_6_input_data_channel_r11(255 downto 240);
            cut_6_input_data_channel_r12  <= and_6_input_data_channel_r12(255 downto 240);
            cut_6_input_data_channel_r13  <= and_6_input_data_channel_r13(255 downto 240);
            cut_6_input_data_channel_r14  <= and_6_input_data_channel_r14(255 downto 240);
            cut_6_input_data_channel_r15  <= and_6_input_data_channel_r15(255 downto 240);
            cut_6_input_data_channel_r16  <= and_6_input_data_channel_r16(255 downto 240);
            cut_7_input_data_channel_r1   <= and_7_input_data_channel_r1(255 downto 240);
            cut_7_input_data_channel_r2   <= and_7_input_data_channel_r2(255 downto 240);
            cut_7_input_data_channel_r3   <= and_7_input_data_channel_r3(255 downto 240);
            cut_7_input_data_channel_r4   <= and_7_input_data_channel_r4(255 downto 240);
            cut_7_input_data_channel_r5   <= and_7_input_data_channel_r5(255 downto 240);
            cut_7_input_data_channel_r6   <= and_7_input_data_channel_r6(255 downto 240);
            cut_7_input_data_channel_r7   <= and_7_input_data_channel_r7(255 downto 240);
            cut_7_input_data_channel_r8   <= and_7_input_data_channel_r8(255 downto 240);
            cut_7_input_data_channel_r9   <= and_7_input_data_channel_r9(255 downto 240);
            cut_7_input_data_channel_r10  <= and_7_input_data_channel_r10(255 downto 240);
            cut_7_input_data_channel_r11  <= and_7_input_data_channel_r11(255 downto 240);
            cut_7_input_data_channel_r12  <= and_7_input_data_channel_r12(255 downto 240);
            cut_7_input_data_channel_r13  <= and_7_input_data_channel_r13(255 downto 240);
            cut_7_input_data_channel_r14  <= and_7_input_data_channel_r14(255 downto 240);
            cut_7_input_data_channel_r15  <= and_7_input_data_channel_r15(255 downto 240);
            cut_7_input_data_channel_r16  <= and_7_input_data_channel_r16(255 downto 240);
            cut_8_input_data_channel_r1   <= and_8_input_data_channel_r1(255 downto 240);
            cut_8_input_data_channel_r2   <= and_8_input_data_channel_r2(255 downto 240);
            cut_8_input_data_channel_r3   <= and_8_input_data_channel_r3(255 downto 240);
            cut_8_input_data_channel_r4   <= and_8_input_data_channel_r4(255 downto 240);
            cut_8_input_data_channel_r5   <= and_8_input_data_channel_r5(255 downto 240);
            cut_8_input_data_channel_r6   <= and_8_input_data_channel_r6(255 downto 240);
            cut_8_input_data_channel_r7   <= and_8_input_data_channel_r7(255 downto 240);
            cut_8_input_data_channel_r8   <= and_8_input_data_channel_r8(255 downto 240);
            cut_8_input_data_channel_r9   <= and_8_input_data_channel_r9(255 downto 240);
            cut_8_input_data_channel_r10  <= and_8_input_data_channel_r10(255 downto 240);
            cut_8_input_data_channel_r11  <= and_8_input_data_channel_r11(255 downto 240);
            cut_8_input_data_channel_r12  <= and_8_input_data_channel_r12(255 downto 240);
            cut_8_input_data_channel_r13  <= and_8_input_data_channel_r13(255 downto 240);
            cut_8_input_data_channel_r14  <= and_8_input_data_channel_r14(255 downto 240);
            cut_8_input_data_channel_r15  <= and_8_input_data_channel_r15(255 downto 240);
            cut_8_input_data_channel_r16  <= and_8_input_data_channel_r16(255 downto 240);
            cut_9_input_data_channel_r1   <= and_9_input_data_channel_r1(255 downto 240);
            cut_9_input_data_channel_r2   <= and_9_input_data_channel_r2(255 downto 240);
            cut_9_input_data_channel_r3   <= and_9_input_data_channel_r3(255 downto 240);
            cut_9_input_data_channel_r4   <= and_9_input_data_channel_r4(255 downto 240);
            cut_9_input_data_channel_r5   <= and_9_input_data_channel_r5(255 downto 240);
            cut_9_input_data_channel_r6   <= and_9_input_data_channel_r6(255 downto 240);
            cut_9_input_data_channel_r7   <= and_9_input_data_channel_r7(255 downto 240);
            cut_9_input_data_channel_r8   <= and_9_input_data_channel_r8(255 downto 240);
            cut_9_input_data_channel_r9   <= and_9_input_data_channel_r9(255 downto 240);
            cut_9_input_data_channel_r10  <= and_9_input_data_channel_r10(255 downto 240);
            cut_9_input_data_channel_r11  <= and_9_input_data_channel_r11(255 downto 240);
            cut_9_input_data_channel_r12  <= and_9_input_data_channel_r12(255 downto 240);
            cut_9_input_data_channel_r13  <= and_9_input_data_channel_r13(255 downto 240);
            cut_9_input_data_channel_r14  <= and_9_input_data_channel_r14(255 downto 240);
            cut_9_input_data_channel_r15  <= and_9_input_data_channel_r15(255 downto 240);
            cut_9_input_data_channel_r16  <= and_9_input_data_channel_r16(255 downto 240);
            cut_10_input_data_channel_r1  <= and_10_input_data_channel_r1(255 downto 240);
            cut_10_input_data_channel_r2  <= and_10_input_data_channel_r2(255 downto 240);
            cut_10_input_data_channel_r3  <= and_10_input_data_channel_r3(255 downto 240);
            cut_10_input_data_channel_r4  <= and_10_input_data_channel_r4(255 downto 240);
            cut_10_input_data_channel_r5  <= and_10_input_data_channel_r5(255 downto 240);
            cut_10_input_data_channel_r6  <= and_10_input_data_channel_r6(255 downto 240);
            cut_10_input_data_channel_r7  <= and_10_input_data_channel_r7(255 downto 240);
            cut_10_input_data_channel_r8  <= and_10_input_data_channel_r8(255 downto 240);
            cut_10_input_data_channel_r9  <= and_10_input_data_channel_r9(255 downto 240);
            cut_10_input_data_channel_r10 <= and_10_input_data_channel_r10(255 downto 240);
            cut_10_input_data_channel_r11 <= and_10_input_data_channel_r11(255 downto 240);
            cut_10_input_data_channel_r12 <= and_10_input_data_channel_r12(255 downto 240);
            cut_10_input_data_channel_r13 <= and_10_input_data_channel_r13(255 downto 240);
            cut_10_input_data_channel_r14 <= and_10_input_data_channel_r14(255 downto 240);
            cut_10_input_data_channel_r15 <= and_10_input_data_channel_r15(255 downto 240);
            cut_10_input_data_channel_r16 <= and_10_input_data_channel_r16(255 downto 240);
            cut_11_input_data_channel_r1  <= and_11_input_data_channel_r1(255 downto 240);
            cut_11_input_data_channel_r2  <= and_11_input_data_channel_r2(255 downto 240);
            cut_11_input_data_channel_r3  <= and_11_input_data_channel_r3(255 downto 240);
            cut_11_input_data_channel_r4  <= and_11_input_data_channel_r4(255 downto 240);
            cut_11_input_data_channel_r5  <= and_11_input_data_channel_r5(255 downto 240);
            cut_11_input_data_channel_r6  <= and_11_input_data_channel_r6(255 downto 240);
            cut_11_input_data_channel_r7  <= and_11_input_data_channel_r7(255 downto 240);
            cut_11_input_data_channel_r8  <= and_11_input_data_channel_r8(255 downto 240);
            cut_11_input_data_channel_r9  <= and_11_input_data_channel_r9(255 downto 240);
            cut_11_input_data_channel_r10 <= and_11_input_data_channel_r10(255 downto 240);
            cut_11_input_data_channel_r11 <= and_11_input_data_channel_r11(255 downto 240);
            cut_11_input_data_channel_r12 <= and_11_input_data_channel_r12(255 downto 240);
            cut_11_input_data_channel_r13 <= and_11_input_data_channel_r13(255 downto 240);
            cut_11_input_data_channel_r14 <= and_11_input_data_channel_r14(255 downto 240);
            cut_11_input_data_channel_r15 <= and_11_input_data_channel_r15(255 downto 240);
            cut_11_input_data_channel_r16 <= and_11_input_data_channel_r16(255 downto 240);
            cut_12_input_data_channel_r1  <= and_12_input_data_channel_r1(255 downto 240);
            cut_12_input_data_channel_r2  <= and_12_input_data_channel_r2(255 downto 240);
            cut_12_input_data_channel_r3  <= and_12_input_data_channel_r3(255 downto 240);
            cut_12_input_data_channel_r4  <= and_12_input_data_channel_r4(255 downto 240);
            cut_12_input_data_channel_r5  <= and_12_input_data_channel_r5(255 downto 240);
            cut_12_input_data_channel_r6  <= and_12_input_data_channel_r6(255 downto 240);
            cut_12_input_data_channel_r7  <= and_12_input_data_channel_r7(255 downto 240);
            cut_12_input_data_channel_r8  <= and_12_input_data_channel_r8(255 downto 240);
            cut_12_input_data_channel_r9  <= and_12_input_data_channel_r9(255 downto 240);
            cut_12_input_data_channel_r10 <= and_12_input_data_channel_r10(255 downto 240);
            cut_12_input_data_channel_r11 <= and_12_input_data_channel_r11(255 downto 240);
            cut_12_input_data_channel_r12 <= and_12_input_data_channel_r12(255 downto 240);
            cut_12_input_data_channel_r13 <= and_12_input_data_channel_r13(255 downto 240);
            cut_12_input_data_channel_r14 <= and_12_input_data_channel_r14(255 downto 240);
            cut_12_input_data_channel_r15 <= and_12_input_data_channel_r15(255 downto 240);
            cut_12_input_data_channel_r16 <= and_12_input_data_channel_r16(255 downto 240);
            cut_13_input_data_channel_r1  <= and_13_input_data_channel_r1(255 downto 240);
            cut_13_input_data_channel_r2  <= and_13_input_data_channel_r2(255 downto 240);
            cut_13_input_data_channel_r3  <= and_13_input_data_channel_r3(255 downto 240);
            cut_13_input_data_channel_r4  <= and_13_input_data_channel_r4(255 downto 240);
            cut_13_input_data_channel_r5  <= and_13_input_data_channel_r5(255 downto 240);
            cut_13_input_data_channel_r6  <= and_13_input_data_channel_r6(255 downto 240);
            cut_13_input_data_channel_r7  <= and_13_input_data_channel_r7(255 downto 240);
            cut_13_input_data_channel_r8  <= and_13_input_data_channel_r8(255 downto 240);
            cut_13_input_data_channel_r9  <= and_13_input_data_channel_r9(255 downto 240);
            cut_13_input_data_channel_r10 <= and_13_input_data_channel_r10(255 downto 240);
            cut_13_input_data_channel_r11 <= and_13_input_data_channel_r11(255 downto 240);
            cut_13_input_data_channel_r12 <= and_13_input_data_channel_r12(255 downto 240);
            cut_13_input_data_channel_r13 <= and_13_input_data_channel_r13(255 downto 240);
            cut_13_input_data_channel_r14 <= and_13_input_data_channel_r14(255 downto 240);
            cut_13_input_data_channel_r15 <= and_13_input_data_channel_r15(255 downto 240);
            cut_13_input_data_channel_r16 <= and_13_input_data_channel_r16(255 downto 240);
            cut_14_input_data_channel_r1  <= and_14_input_data_channel_r1(255 downto 240);
            cut_14_input_data_channel_r2  <= and_14_input_data_channel_r2(255 downto 240);
            cut_14_input_data_channel_r3  <= and_14_input_data_channel_r3(255 downto 240);
            cut_14_input_data_channel_r4  <= and_14_input_data_channel_r4(255 downto 240);
            cut_14_input_data_channel_r5  <= and_14_input_data_channel_r5(255 downto 240);
            cut_14_input_data_channel_r6  <= and_14_input_data_channel_r6(255 downto 240);
            cut_14_input_data_channel_r7  <= and_14_input_data_channel_r7(255 downto 240);
            cut_14_input_data_channel_r8  <= and_14_input_data_channel_r8(255 downto 240);
            cut_14_input_data_channel_r9  <= and_14_input_data_channel_r9(255 downto 240);
            cut_14_input_data_channel_r10 <= and_14_input_data_channel_r10(255 downto 240);
            cut_14_input_data_channel_r11 <= and_14_input_data_channel_r11(255 downto 240);
            cut_14_input_data_channel_r12 <= and_14_input_data_channel_r12(255 downto 240);
            cut_14_input_data_channel_r13 <= and_14_input_data_channel_r13(255 downto 240);
            cut_14_input_data_channel_r14 <= and_14_input_data_channel_r14(255 downto 240);
            cut_14_input_data_channel_r15 <= and_14_input_data_channel_r15(255 downto 240);
            cut_14_input_data_channel_r16 <= and_14_input_data_channel_r16(255 downto 240);
            cut_15_input_data_channel_r1  <= and_15_input_data_channel_r1(255 downto 240);
            cut_15_input_data_channel_r2  <= and_15_input_data_channel_r2(255 downto 240);
            cut_15_input_data_channel_r3  <= and_15_input_data_channel_r3(255 downto 240);
            cut_15_input_data_channel_r4  <= and_15_input_data_channel_r4(255 downto 240);
            cut_15_input_data_channel_r5  <= and_15_input_data_channel_r5(255 downto 240);
            cut_15_input_data_channel_r6  <= and_15_input_data_channel_r6(255 downto 240);
            cut_15_input_data_channel_r7  <= and_15_input_data_channel_r7(255 downto 240);
            cut_15_input_data_channel_r8  <= and_15_input_data_channel_r8(255 downto 240);
            cut_15_input_data_channel_r9  <= and_15_input_data_channel_r9(255 downto 240);
            cut_15_input_data_channel_r10 <= and_15_input_data_channel_r10(255 downto 240);
            cut_15_input_data_channel_r11 <= and_15_input_data_channel_r11(255 downto 240);
            cut_15_input_data_channel_r12 <= and_15_input_data_channel_r12(255 downto 240);
            cut_15_input_data_channel_r13 <= and_15_input_data_channel_r13(255 downto 240);
            cut_15_input_data_channel_r14 <= and_15_input_data_channel_r14(255 downto 240);
            cut_15_input_data_channel_r15 <= and_15_input_data_channel_r15(255 downto 240);
            cut_15_input_data_channel_r16 <= and_15_input_data_channel_r16(255 downto 240);
            extrinsic_info_f1_e14         <= extrinsic_info_f1_e13;
            extrinsic_info_f2_e14         <= extrinsic_info_f2_e13;
        end if;
    end process;
    ------------------------------------------------------------------------------------------------------------
    -- Define processes : (CLK 20)
    ------------------------------------------------------------------------------------------------------------
    process (clk, reset)
    begin
        if (reset = '1') then
            extrinsic_info_f1_e15 <= (others => (others => '0'));
            extrinsic_info_f2_e15 <= (others => (others => '0'));
        elsif (rising_edge(clk)) then
            v_0_input_data_channel_r0  <= cut_0_input_data_channel_r1(0); -- input_data goes into std_logic_vector
            v_0_input_data_channel_r1  <= cut_0_input_data_channel_r1(1);
            v_0_input_data_channel_r2  <= cut_0_input_data_channel_r1(2);
            v_0_input_data_channel_r3  <= cut_0_input_data_channel_r1(3);
            v_0_input_data_channel_r4  <= cut_0_input_data_channel_r1(4);
            v_0_input_data_channel_r5  <= cut_0_input_data_channel_r1(5);
            v_0_input_data_channel_r6  <= cut_0_input_data_channel_r1(6);
            v_0_input_data_channel_r7  <= cut_0_input_data_channel_r1(7);
            v_0_input_data_channel_r8  <= cut_0_input_data_channel_r1(8);
            v_0_input_data_channel_r9  <= cut_0_input_data_channel_r1(9);
            v_0_input_data_channel_r10 <= cut_0_input_data_channel_r1(10);
            v_0_input_data_channel_r11 <= cut_0_input_data_channel_r1(11);
            v_0_input_data_channel_r12 <= cut_0_input_data_channel_r1(12);
            v_0_input_data_channel_r13 <= cut_0_input_data_channel_r1(13);
            v_0_input_data_channel_r14 <= cut_0_input_data_channel_r1(14);
            v_0_input_data_channel_r15 <= cut_0_input_data_channel_r1(15);
            v_0_input_data_channel_r16 <= cut_0_input_data_channel_r1(16);
            v_1_input_data_channel_r0  <= cut_1_input_data_channel_r1(0);
            v_1_input_data_channel_r1  <= cut_1_input_data_channel_r1(1);
            v_1_input_data_channel_r2  <= cut_1_input_data_channel_r1(2);
            v_1_input_data_channel_r3  <= cut_1_input_data_channel_r1(3);
            v_1_input_data_channel_r4  <= cut_1_input_data_channel_r1(4);
            v_1_input_data_channel_r5  <= cut_1_input_data_channel_r1(5);
            v_1_input_data_channel_r6  <= cut_1_input_data_channel_r1(6);
            v_1_input_data_channel_r7  <= cut_1_input_data_channel_r1(7);
            v_1_input_data_channel_r8  <= cut_1_input_data_channel_r1(8);
            v_1_input_data_channel_r9  <= cut_1_input_data_channel_r1(9);
            v_1_input_data_channel_r10 <= cut_1_input_data_channel_r1(10);
            v_1_input_data_channel_r11 <= cut_1_input_data_channel_r1(11);
            v_1_input_data_channel_r12 <= cut_1_input_data_channel_r1(12);
            v_1_input_data_channel_r13 <= cut_1_input_data_channel_r1(13);
            v_1_input_data_channel_r14 <= cut_1_input_data_channel_r1(14);
            v_1_input_data_channel_r15 <= cut_1_input_data_channel_r1(15);
            v_1_input_data_channel_r16 <= cut_1_input_data_channel_r1(16);

            extrinsic_info_f1_e15 <= extrinsic_info_f1_e14;
            extrinsic_info_f2_e15 <= extrinsic_info_f2_e14;
        end if;
    end process;
    ------------------------------------------------------------------------------------------------------------
    -- Define processes : (CLK 21)
    ------------------------------------------------------------------------------------------------------------
    process (clk, reset)
    begin
        if (reset = '1') then
            extrinsic_info_f1_e16 <= (others => (others => '0'));
            extrinsic_info_f2_e16 <= (others => (others => '0'));
        elsif (rising_edge(clk)) then
            extrinsic_info_f1_e16 <= extrinsic_info_f1_e15;
            extrinsic_info_f2_e16 <= extrinsic_info_f2_e15;
        end if;
    end process;
    ------------------------------------------------------------------------------------------------------------
    -- Define processes : (CLK 22)
    ------------------------------------------------------------------------------------------------------------
    process (clk, reset)
    begin
        if (reset = '1') then
            extrinsic_info_f1_e17 <= (others => (others => '0'));
            extrinsic_info_f2_e17 <= (others => (others => '0'));
        elsif (rising_edge(clk)) then
            extrinsic_info_f1_e17 <= extrinsic_info_f1_e16;
            extrinsic_info_f2_e17 <= extrinsic_info_f2_e16;
        end if;
    end process;
    ------------------------------------------------------------------------------------------------------------
    -- Define processes : (CLK 23)
    ------------------------------------------------------------------------------------------------------------
    process (clk, reset)
    begin
        if (reset = '1') then
            extrinsic_info_f1_e18 <= (others => (others => '0'));
            extrinsic_info_f2_e18 <= (others => (others => '0'));
        elsif (rising_edge(clk)) then
            extrinsic_info_f1_e18 <= extrinsic_info_f1_e17;
            extrinsic_info_f2_e18 <= extrinsic_info_f2_e17;
        end if;
    end process;
    ------------------------------------------------------------------------------------------------------------
    -- Define processes : (CLK 24)
    ------------------------------------------------------------------------------------------------------------

    ------------------------------------------------------------------------------------------------------------
    -- Define processes : (CLK 25)
    ------------------------------------------------------------------------------------------------------------

    ------------------------------------------------------------------------------------------------------------
    -- Define processes : (CLK 26)
    ------------------------------------------------------------------------------------------------------------

    ------------------------------------------------------------------------------------------------------------
    -- Define processes : (CLK 27)
    ------------------------------------------------------------------------------------------------------------

    ------------------------------------------------------------------------------------------------------------
    -- Define processes : (CLK 28)
    ------------------------------------------------------------------------------------------------------------

    ------------------------------------------------------------------------------------------------------------
    -- Define processes : (CLK 29)
    ------------------------------------------------------------------------------------------------------------

    ------------------------------------------------------------------------------------------------------------
    -- Define processes : (CLK 30)
    ------------------------------------------------------------------------------------------------------------

    ------------------------------------------------------------------------------------------------------------
    -- Define processes : (CLK 31)
    ------------------------------------------------------------------------------------------------------------

    ------------------------------------------------------------------------------------------------------------
    -- Define processes : (CLK 32)
    ------------------------------------------------------------------------------------------------------------

    ------------------------------------------------------------------------------------------------------------
    -- Define processes : (CLK 33)
    ------------------------------------------------------------------------------------------------------------

    ------------------------------------------------------------------------------------------------------------
    -- Define processes : (CLK 34)
    ------------------------------------------------------------------------------------------------------------
end architecture;
