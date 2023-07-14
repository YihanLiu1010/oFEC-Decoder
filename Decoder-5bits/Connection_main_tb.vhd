library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use ieee.math_real.all;
use IEEE.STD_LOGIC_TEXTIO.all;
use STD.TEXTIO.all;
use work.arr_pkg_1.all;
use work.arr_pkg_2.all;
use work.arr_pkg_3.all;
use work.arr_pkg_4.all;
use work.arr_pkg_5.all;
use work.arr_pkg_6.all;

entity connection_main_tb is
end connection_main_tb;

architecture sim of connection_main_tb is

    component connection_main is
        generic (
            data_in_length : positive := 255
        );
        port (
            clk        : in std_logic;                                 -- system clock
            reset      : in std_logic;                                 -- reset
            soft_input : in input_data_array(data_in_length downto 0); -- 256 * 6 bits
            ---------------------------------------------------------------------------------------------
            extrinsic_info_half1 : out input_data_array(127 downto 0);
            extrinsic_info_half2 : out input_data_array(127 downto 0)
        );
    end component;

    ------------Inputs------------
    signal clk        : std_logic;
    signal reset      : std_logic;
    signal soft_input : input_data_array(255 downto 0);
    ------------Output-------------
    signal extrinsic_info_half1 : input_data_array(127 downto 0);
    signal extrinsic_info_half2 : input_data_array(127 downto 0);
    ------------Clock--------------
    constant ClockPeriod : time := 10 ns;
    ------------Signal for import data--------------
    file file_in : text;

begin
    --------------port map----------
    i_connection_main : entity work.connection_main port map(
        clk                  => clk,
        reset                => reset,
        soft_input           => soft_input,
        extrinsic_info_half1 => extrinsic_info_half1,
        extrinsic_info_half2 => extrinsic_info_half2
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
    -------------data input------------
    data_input : process
        variable line_in   : line;                         -- line number declaration
        variable input_tmp : std_logic_vector(5 downto 0); -- soft input bits
    begin

        -- Init
        file_open(file_in, "C:\Onedrive\OneDrive - Danmarks Tekniske Universitet\Semester4\My Code\VHDL\Connection_main_report\LLR_in(1).txt", read_mode);
        for i in 0 to 255 loop
            if not(endfile(file_in)) then
                readline(file_in, line_in);-- Read line from file
                read(line_in, input_tmp);-- Read value from line
                soft_input(i) <= input_tmp;
            end if;
        end loop;
        file_close(file_in);

        wait for 0.5 * ClockPeriod;

        wait for ClockPeriod;
        file_open(file_in, "C:\Onedrive\OneDrive - Danmarks Tekniske Universitet\Semester4\My Code\VHDL\Connection_main_report\LLR_in(1).txt", read_mode);
        for i in 0 to 255 loop
            if not(endfile(file_in)) then
                readline(file_in, line_in);-- Read line from file
                read(line_in, input_tmp);-- Read value from line
                soft_input(i) <= input_tmp;
            end if;
        end loop;
        file_close(file_in);

        wait for ClockPeriod;
        file_open(file_in, "C:\Onedrive\OneDrive - Danmarks Tekniske Universitet\Semester4\My Code\VHDL\Connection_main_report\LLR_in(2).txt", read_mode);
        for i in 0 to 255 loop
            if not(endfile(file_in)) then
                readline(file_in, line_in);-- Read line from file
                read(line_in, input_tmp);-- Read value from line
                soft_input(i) <= input_tmp;
            end if;
        end loop;
        file_close(file_in);

        wait for ClockPeriod;
        file_open(file_in, "C:\Onedrive\OneDrive - Danmarks Tekniske Universitet\Semester4\My Code\VHDL\Connection_main_report\LLR_in(3).txt", read_mode);
        for i in 0 to 255 loop
            if not(endfile(file_in)) then
                readline(file_in, line_in);-- Read line from file
                read(line_in, input_tmp);-- Read value from line
                soft_input(i) <= input_tmp;
            end if;
        end loop;
        file_close(file_in);

        wait for ClockPeriod;
        file_open(file_in, "C:\Onedrive\OneDrive - Danmarks Tekniske Universitet\Semester4\My Code\VHDL\Connection_main_report\LLR_in(4).txt", read_mode);
        for i in 0 to 255 loop
            if not(endfile(file_in)) then
                readline(file_in, line_in);-- Read line from file
                read(line_in, input_tmp);-- Read value from line
                soft_input(i) <= input_tmp;
            end if;
        end loop;
        file_close(file_in);

        wait for ClockPeriod;
        file_open(file_in, "C:\Onedrive\OneDrive - Danmarks Tekniske Universitet\Semester4\My Code\VHDL\Connection_main_report\LLR_in(5).txt", read_mode);
        for i in 0 to 255 loop
            if not(endfile(file_in)) then
                readline(file_in, line_in);-- Read line from file
                read(line_in, input_tmp);-- Read value from line
                soft_input(i) <= input_tmp;
            end if;
        end loop;
        file_close(file_in);

        wait for ClockPeriod;
        file_open(file_in, "C:\Onedrive\OneDrive - Danmarks Tekniske Universitet\Semester4\My Code\VHDL\Connection_main_report\LLR_in(6).txt", read_mode);
        for i in 0 to 255 loop
            if not(endfile(file_in)) then
                readline(file_in, line_in);-- Read line from file
                read(line_in, input_tmp);-- Read value from line
                soft_input(i) <= input_tmp;
            end if;
        end loop;
        file_close(file_in);

        wait for ClockPeriod;
        file_open(file_in, "C:\Onedrive\OneDrive - Danmarks Tekniske Universitet\Semester4\My Code\VHDL\Connection_main_report\LLR_in(7).txt", read_mode);
        for i in 0 to 255 loop
            if not(endfile(file_in)) then
                readline(file_in, line_in);-- Read line from file
                read(line_in, input_tmp);-- Read value from line
                soft_input(i) <= input_tmp;
            end if;
        end loop;
        file_close(file_in);

        wait;
    end process;
end architecture;
