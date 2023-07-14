-- From bit flipping_1 to weight_2
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
entity connection_1 is
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
end connection_1;

architecture rtl of connection_1 is
    -------------------------------------------------------------------------------------------------------------
    -- Signals for connection_1
    -------------------------------------------------------------------------------------------------------------
    signal soft_output_unflipped_temp_pass   :   input_data_array(255 downto 0);
    signal soft_output_flipped_temp_pass     :   input_data_array(255 downto 0);
    signal index_out_temp_pass               :   index_array(7 downto 0);
    signal weight_info_temp_pass             :   input_data_array(2 downto 0);
    signal soft_output_unflipped_temp_pass_1 :   input_data_array(255 downto 0);
    signal soft_output_flipped_temp_pass_1   :   input_data_array(255 downto 0);
    signal index_out_temp_pass_1             :   index_array(7 downto 0);
    signal weight_info_temp_pass_1           :   input_data_array(2 downto 0);
    ------------------------------------------------flipping_1 Block-----------------------------------------------
    signal soft_output_unflipped_temp : input_data_array(255 downto 0);
    signal soft_output_flipped_temp   : input_data_array(255 downto 0);
    signal weight_info_temp           : input_data_array(2 downto 0);
    signal index_out_temp             : index_array(7 downto 0);
    -----------------------------------------------Soft2hard Block-----------------------------------------------
    signal hard_output_temp_1 : std_logic_vector(255 downto 0);
    signal soft_output_temp_1 : input_data_array(255 downto 0);
    ----------------------------------------------syndrome Block-------------------------------------------------
    signal hard_output_temp : std_logic_vector(255 downto 0);
    signal s1_temp          : std_logic_vector(7 downto 0);
    signal s3_temp          : std_logic_vector(7 downto 0);
    signal soft_output_temp : input_data_array(255 downto 0);
    ----------------------------------------------BCH HIHO Block-------------------------------------------------
    signal corrections_temp    : std_logic_vector(2 downto 0);
    signal error_position_temp : output_error_location_array(2 downto 0);
    signal hard_output_temp_b  : std_logic_vector(255 downto 0);
    signal soft_output_temp_b  : input_data_array(255 downto 0);
    ----------------------------------------------Weight_1 Block-------------------------------------------------
    signal soft_output_unflipped_weight_1 : input_data_array(255 downto 0);
    signal output_weight_temp             : std_logic_vector(9 downto 0);
    signal index_out_temp_w2              : index_array(7 downto 0);
    -------------------------------------------------------------------------------------------------------------
    -- Declare Components
    -------------------------------------------------------------------------------------------------------------
    component flipping_1 is
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
            weight_info           : out input_data_array(2 downto 0)
        );
    end component;

    component soft2hard is
        generic (
            data_length : positive := 255
        );
        port (
            clk        : in std_logic;                              -- system clock
            reset      : in std_logic;                              -- reset
            soft_input : in input_data_array(data_length downto 0); -- 6 bits
            ----------------------------------------------------------------------------
            hard_output : out std_logic_vector(data_length downto 0); -- An array of integer
            soft_output : out input_data_array(data_length downto 0)
        );
    end component;

    component weight_1 is
        generic (
            data_in_length : positive := 255;
            data_length    : positive := 2
        );
        port (
            clk                   : in std_logic;
            reset                 : in std_logic;
            soft_input            : in input_data_array(data_length downto 0); -- From flipping block
            soft_input_unflipped  : in input_data_array(data_in_length downto 0);
            index_in              : in index_array(7 downto 0); -- From flipping block
            soft_output_unflipped : out input_data_array(data_in_length downto 0);
            index_out             : out index_array(7 downto 0);
            output_weight         : out std_logic_vector(9 downto 0)
        );
    end component;

    component syndrome is
        generic (
            data_length : positive := 255
        );
        port (
            clk        : in std_logic; -- system clock
            reset      : in std_logic; -- reset
            hard_input : in std_logic_vector(data_length downto 0);
            soft_input : in input_data_array(data_length downto 0); -- Soft input will be passed onto BCH block

            hard_output : out std_logic_vector(data_length downto 0); -- This should be the same as 'hard_input' and will be used in the BCH decoder
            s1          : out std_logic_vector(7 downto 0);
            s3          : out std_logic_vector(7 downto 0);
            soft_output : out input_data_array(data_length downto 0)
        );
    end component;

    component bch_decoder_HIHO is
        generic (
            data_length           : positive := 255;
            input_syndrome_length : positive := 7;
            softnum               : positive := 5
        );
        port (
            clk        : in std_logic;
            reset      : in std_logic;
            s1         : in std_logic_vector(7 downto 0);
            s3         : in std_logic_vector(7 downto 0);
            hard_input : in std_logic_vector(data_length downto 0);
            soft_input : in input_data_array(data_length downto 0);

            corrections    : out std_logic_vector(2 downto 0);
            error_position : out output_error_location_array(2 downto 0);
            hard_output    : out std_logic_vector(data_length downto 0);
            soft_output    : out input_data_array(data_length downto 0)
        );
    end component;

    component weight_2 is
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
    end component;

begin

    -- flipping_1
    flipping_1_block : flipping_1
    port map(clk, reset, soft_input, index, soft_output_unflipped_temp, soft_output_flipped_temp, index_out_temp, weight_info_temp);

    -- soft2hard
    soft2hard_block : soft2hard
    port map(clk, reset, soft_output_flipped_temp_pass_1, hard_output_temp_1, soft_output_temp_1);

    -- weight_1
    weight_block : weight_1
    port map(clk, reset, weight_info_temp_pass_1, soft_output_unflipped_temp_pass_1, index_out_temp_pass_1, soft_output_unflipped_weight_1, index_out_temp_w2, output_weight_temp);

    -- syndrome calculator 
    syndrome_block : syndrome
    port map(clk, reset, hard_output_temp_1, soft_output_temp_1, hard_output_temp, s1_temp, s3_temp, soft_output_temp);

    -- bch
    bch_block : bch_decoder_HIHO
    port map(clk, reset, s1_temp, s3_temp, hard_output_temp, soft_output_temp, corrections_temp, error_position_temp, hard_output_temp_b, soft_output_temp_b);

    -- weight_2
    weight_block_2 : weight_2
    port map(clk, reset, soft_output_temp_b, hard_output_temp_b, error_position_temp, corrections_temp, output_weight_temp, soft_output_unflipped_weight_1, index_out_temp_w2, soft_output, hard_output, corrections_out, error_position_out, soft_output_unflipped, final_weight_value);

    -- from flipping to weight_1 and soft2hard
    process (clk, reset)
    begin
        if (reset = '1') then
            soft_output_unflipped_temp_pass   <= (others => (others => '0'));
            soft_output_flipped_temp_pass     <= (others => (others => '0')); 
            index_out_temp_pass               <= (others => (others => '0'));
            weight_info_temp_pass             <= (others => (others => '0'));
        elsif (rising_edge(clk)) then
            soft_output_unflipped_temp_pass   <= soft_output_unflipped_temp;
            soft_output_flipped_temp_pass     <= soft_output_flipped_temp;
            index_out_temp_pass               <= index_out_temp;
            weight_info_temp_pass             <= weight_info_temp;
        end if;
    end process;
    process (clk, reset)
    begin
        if (reset = '1') then
            soft_output_unflipped_temp_pass_1   <= (others => (others => '0'));
            soft_output_flipped_temp_pass_1     <= (others => (others => '0')); 
            index_out_temp_pass_1               <= (others => (others => '0'));
            weight_info_temp_pass_1             <= (others => (others => '0'));
        elsif (rising_edge(clk)) then
            soft_output_unflipped_temp_pass_1   <= soft_output_unflipped_temp_pass;
            soft_output_flipped_temp_pass_1     <= soft_output_flipped_temp_pass;
            index_out_temp_pass_1               <= index_out_temp_pass;
            weight_info_temp_pass_1             <= weight_info_temp_pass;
        end if;
    end process;
end architecture;
