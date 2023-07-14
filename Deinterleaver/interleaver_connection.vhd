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
entity interleaver_connection is
    port (
        clk                : in std_logic;
        reset              : in std_logic;
        data_in_1          : in std_logic_vector(2047 downto 0); -- input from the extrinsic block
        data_in_2          : in std_logic_vector(2047 downto 0);
        rdreq              : in std_logic;
        wrreq              : in std_logic;
        input_data_channel : in input_data_array(255 downto 0); -- From Channel, it also comes in one square per clock cycle
        output_2_decoder   : out input_data_array(255 downto 0) -- To decoder
    );
end interleaver_connection;

architecture rtl of interleaver_connection is
    -------------------------------------------------------------------------------------------------------------
    -- Signals for interleaver_connection
    -------------------------------------------------------------------------------------------------------------
    signal data_out_1_temp : std_logic_vector(2047 downto 0);
    signal data_out_2_temp : std_logic_vector(2047 downto 0);
    -------------------------------------------------------------------------------------------------------------
    -- Declare Components
    -------------------------------------------------------------------------------------------------------------
    component ram_top is
        port (
            clk        : in std_logic;
            reset      : in std_logic;
            data_in_1  : in std_logic_vector(2047 downto 0); -- input from the extrinsic block
            data_in_2  : in std_logic_vector(2047 downto 0);
            rdreq      : in std_logic;
            wrreq      : in std_logic;
            data_out_1 : out std_logic_vector(2047 downto 0); -- output to assamble codewords
            data_out_2 : out std_logic_vector(2047 downto 0)
        );
    end component;

    component interleaver_control is -- For assamble codeword from RAM data
        port (
            clk                 : in std_logic;
            reset               : in std_logic;
            input_data_memory_1 : in std_logic_vector(2047 downto 0); -- From memory 256*8(16*16*8), a square
            input_data_memory_2 : in std_logic_vector(2047 downto 0);
            input_data_channel  : in input_data_array(255 downto 0); -- From Channel, it also comes in one square per clock cycle
            output_2_decoder    : out input_data_array(255 downto 0)
        );
    end component;
begin

    -- ram_top
    ram_top_block : ram_top
    port map(clk, reset, data_in_1, data_in_2, rdreq, wrreq, data_out_1_temp, data_out_2_temp);

    -- interleaver_control
    interleaver_control_block : interleaver_control
    port map(clk, reset, data_out_1_temp, data_out_2_temp, input_data_channel, output_2_decoder);
end architecture;
