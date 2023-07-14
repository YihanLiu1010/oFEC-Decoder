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

entity ram_top_tb is
end ram_top_tb;

architecture sim of ram_top_tb is

    component ram_top is
        port (
            clk        : in std_logic;
            reset      : in std_logic;
            data_in_1  : in std_logic_vector(2047 downto 0);
            data_in_2  : in std_logic_vector(2047 downto 0);
            rdreq      : in std_logic;
            wrreq      : in std_logic;
            data_out_1 : out std_logic_vector(2047 downto 0);
            data_out_2 : out std_logic_vector(2047 downto 0)
        );
    end component;

    ------------Inputs------------
    signal clk       : std_logic;
    signal reset     : std_logic;
    signal data_in_1 : std_logic_vector(2047 downto 0);
    signal data_in_2 : std_logic_vector(2047 downto 0);
    signal rdreq     : std_logic;
    signal wrreq     : std_logic;
    ------------Output-------------
    signal data_out_1 : std_logic_vector(2047 downto 0);
    signal data_out_2 : std_logic_vector(2047 downto 0);
    ------------Clock--------------
    constant ClockPeriod : time := 10 ns;
begin
    --------------port map----------
    i_ram_top : entity work.ram_top port map(
        clk        => clk,
        reset      => reset,
        data_in_1  => data_in_1,
        data_in_2  => data_in_2,
        rdreq      => rdreq,
        wrreq      => wrreq,
        data_out_1 => data_out_1,
        data_out_2 => data_out_2
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
        rdreq <= '0';
        wrreq <= '0';
        wait for ClockPeriod/2;
        rdreq <= '1';
        wrreq <= '0';
        wait for ClockPeriod/2;
        wait;
    end process;
end architecture;
