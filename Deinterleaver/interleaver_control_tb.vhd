library ieee;
use STD.textio.all;
use ieee.std_logic_textio.all;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use work.arr_pkg_1.all;
use work.arr_pkg_2.all;
use work.arr_pkg_3.all;
use work.arr_pkg_4.all;
use work.arr_pkg_5.all;
use work.arr_pkg_6.all;

entity interleaver_control_tb is
end interleaver_control_tb;

architecture sim of interleaver_control_tb is

    component interleaver_control is
        port (
            clk                 : in std_logic;
            reset               : in std_logic;
            input_data_memory_1 : in std_logic_vector(2047 downto 0); -- From memory 256*8(16*16*8), a square
            input_data_memory_2 : in std_logic_vector(2047 downto 0);
            input_data_channel  : in input_data_array(255 downto 0); -- From Channel, it also comes in one square per clock cycle
            output_2_decoder    : out input_data_array(255 downto 0)
        );
    end component;

    ------------Inputs------------
    signal clk                 : std_logic;
    signal reset               : std_logic;
    signal input_data_memory_1 : std_logic_vector(2047 downto 0);
    signal input_data_memory_2 : std_logic_vector(2047 downto 0);
    signal input_data_channel  : input_data_array(255 downto 0);
    ------------Output-------------
    signal output_2_decoder : input_data_array(255 downto 0);
    ------------Clock--------------
    constant ClockPeriod : time := 10 ns;
begin
    --------------port map----------
    i_interleaver_control : entity work.interleaver_control port map(
        clk                 => clk,
        reset               => reset,
        input_data_memory_1 => input_data_memory_1,
        input_data_memory_2 => input_data_memory_2,
        input_data_channel  => input_data_channel,
        output_2_decoder    => output_2_decoder
        );
    --------------Generate clock pulse-----------
    clk_process : process
    begin
        clk <= '0';
        wait for ClockPeriod/2; --for 5 ns signal is '0'.
        clk <= '1';
        wait for ClockPeriod/2; --for next 5 ns signal is '1'.
    end process;
    -------------reset simulation------------
    reset_process : process
    begin
        reset <= '1';
        wait for ClockPeriod/2;
        reset <= '0';
        wait for ClockPeriod/2;
        wait;
    end process;
    -------------read/write simulation------------
    read_process : process
    begin
        input_data_memory_1 <= (others => '0');
        input_data_memory_2 <= (others => '0');
        input_data_channel  <= (others => (others => '0'));
        wait for ClockPeriod/2;
        input_data_memory_1 <= (others => '1'); -- first input data
        input_data_memory_2 <= (others => '1');
        input_data_channel  <= (others => (others => '1'));
        wait for ClockPeriod;
        input_data_memory_1(1023 downto 0)    <= (others => '1'); -- Second input data
        input_data_memory_1(2047 downto 1024) <= (others => '0');
        input_data_memory_2(1023 downto 0)    <= (others => '1');
        input_data_memory_2(2047 downto 1024) <= (others => '0');
        input_data_channel(127 downto 0)      <= (others => (others => '1'));
        input_data_channel(255 downto 128)    <= (others => (others => '0'));
        wait for ClockPeriod;
        input_data_memory_1(1023 downto 0)    <= (others => '0'); -- Third input data
        input_data_memory_1(2047 downto 1024) <= (others => '1');
        input_data_memory_2(1023 downto 0)    <= (others => '0');
        input_data_memory_2(2047 downto 1024) <= (others => '1');
        input_data_channel(127 downto 0)      <= (others => (others => '0'));
        input_data_channel(255 downto 128)    <= (others => (others => '1'));
        wait for ClockPeriod;
        input_data_memory_1(1023 downto 0)    <= (others => '1'); -- Fourth input data
        input_data_memory_1(2047 downto 1024) <= (others => '1');
        input_data_memory_2(1023 downto 0)    <= (others => '1');
        input_data_memory_2(2047 downto 1024) <= (others => '1');
        input_data_channel(127 downto 0)      <= (others => (others => '1')); -- Beware! We only have 4 input channel data here
        input_data_channel(255 downto 128)    <= (others => (others => '1'));
        wait for ClockPeriod;
        input_data_channel(127 downto 0)   <= (others => (others => '0'));
        input_data_channel(255 downto 128) <= (others => (others => '1'));
        wait for ClockPeriod;
        input_data_channel(127 downto 0)   <= (others => (others => '1'));
        input_data_channel(255 downto 128) <= (others => (others => '0'));
        wait for ClockPeriod;
        input_data_channel(127 downto 0)   <= (others => (others => '0'));
        input_data_channel(255 downto 128) <= (others => (others => '0'));
        wait for ClockPeriod;
        input_data_channel(127 downto 0)   <= (others => (others => '1'));
        input_data_channel(255 downto 128) <= (others => (others => '1'));
        wait;
    end process;
end architecture;
