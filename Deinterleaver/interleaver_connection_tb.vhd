library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
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
use work.arr_pkg_7.all;
entity interleaver_connection_tb is
end interleaver_connection_tb;

architecture sim of interleaver_connection_tb is

    component interleaver_connection is
        port (
            clk                : in std_logic;
            reset              : in std_logic;
            data_in_1          : in std_logic_vector(2047 downto 0); -- input from the extrinsic block
            data_in_2          : in std_logic_vector(2047 downto 0);
            rdreq              : in std_logic := '1';
            wrreq              : in std_logic := '1';
            input_data_channel : in input_data_array(255 downto 0); -- From Channel, it also comes in one square per clock cycle
            output_2_decoder   : out input_data_array(255 downto 0) -- To decoder
        );
    end component;

    ------------Inputs------------
    signal clk                : std_logic;
    signal reset              : std_logic;
    signal data_in_1          : std_logic_vector(2047 downto 0);
    signal data_in_2          : std_logic_vector(2047 downto 0);
    signal rdreq              : std_logic := '1';
    signal wrreq              : std_logic := '1';
    signal input_data_channel : input_data_array(255 downto 0);
    ------------Output-------------
    signal output_2_decoder : input_data_array(255 downto 0);
    ------------Clock--------------
    constant ClockPeriod : time := 10 ns;
    ------------Signal for import data--------------
    file file_in : text;

begin
    --------------port map----------
    i_interleaver_connection : entity work.interleaver_connection port map(
        clk                => clk,
        reset              => reset,
        data_in_1          => data_in_1,
        data_in_2          => data_in_2,
        rdreq              => rdreq,
        wrreq              => wrreq,
        input_data_channel => input_data_channel,
        output_2_decoder   => output_2_decoder
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
    data_input : process
        variable line_in   : line;                         -- line number declaration
        variable input_tmp : std_logic_vector(7 downto 0); -- soft input bits
    begin

        -- Init
        file_open(file_in, "C:\Onedrive\OneDrive - Danmarks Tekniske Universitet\Semester4\My Code\VHDL\Interleaver\YL\LLR_in(1).txt", read_mode);
        for i in 0 to 255 loop
            if not(endfile(file_in)) then
                readline(file_in, line_in);-- Read line from file
                read(line_in, input_tmp);-- Read value from line
                input_data_channel(i) <= input_tmp;
            end if;
        end loop;
        file_close(file_in);

        wait for 0.5 * ClockPeriod;

        wait for ClockPeriod;
        file_open(file_in, "C:\Onedrive\OneDrive - Danmarks Tekniske Universitet\Semester4\My Code\VHDL\Interleaver\YL\LLR_in(1).txt", read_mode);
        for i in 0 to 255 loop
            if not(endfile(file_in)) then
                readline(file_in, line_in);-- Read line from file
                read(line_in, input_tmp);-- Read value from line
                input_data_channel(i) <= input_tmp;
            end if;
        end loop;
        file_close(file_in);

        wait for ClockPeriod;
        file_open(file_in, "C:\Onedrive\OneDrive - Danmarks Tekniske Universitet\Semester4\My Code\VHDL\Interleaver\YL\LLR_in(1).txt", read_mode);
        for i in 0 to 255 loop
            if not(endfile(file_in)) then
                readline(file_in, line_in);-- Read line from file
                read(line_in, input_tmp);-- Read value from line
                input_data_channel(i) <= input_tmp;
            end if;
        end loop;
        file_close(file_in);

        wait for ClockPeriod;
        file_open(file_in, "C:\Onedrive\OneDrive - Danmarks Tekniske Universitet\Semester4\My Code\VHDL\Interleaver\YL\LLR_in(2).txt", read_mode);
        for i in 0 to 255 loop
            if not(endfile(file_in)) then
                readline(file_in, line_in);-- Read line from file
                read(line_in, input_tmp);-- Read value from line
                input_data_channel(i) <= input_tmp;
            end if;
        end loop;
        file_close(file_in);

        wait for ClockPeriod;
        file_open(file_in, "C:\Onedrive\OneDrive - Danmarks Tekniske Universitet\Semester4\My Code\VHDL\Interleaver\YL\LLR_in(2).txt", read_mode);
        for i in 0 to 255 loop
            if not(endfile(file_in)) then
                readline(file_in, line_in);-- Read line from file
                read(line_in, input_tmp);-- Read value from line
                input_data_channel(i) <= input_tmp;
            end if;
        end loop;
        file_close(file_in);

        wait for ClockPeriod;
        file_open(file_in, "C:\Onedrive\OneDrive - Danmarks Tekniske Universitet\Semester4\My Code\VHDL\Interleaver\YL\LLR_in(3).txt", read_mode);
        for i in 0 to 255 loop
            if not(endfile(file_in)) then
                readline(file_in, line_in);-- Read line from file
                read(line_in, input_tmp);-- Read value from line
                input_data_channel(i) <= input_tmp;
            end if;
        end loop;
        file_close(file_in);

        wait for ClockPeriod;
        file_open(file_in, "C:\Onedrive\OneDrive - Danmarks Tekniske Universitet\Semester4\My Code\VHDL\Interleaver\YL\LLR_in(3).txt", read_mode);
        for i in 0 to 255 loop
            if not(endfile(file_in)) then
                readline(file_in, line_in);-- Read line from file
                read(line_in, input_tmp);-- Read value from line
                input_data_channel(i) <= input_tmp;
            end if;
        end loop;
        file_close(file_in);

        wait for ClockPeriod;
        file_open(file_in, "C:\Onedrive\OneDrive - Danmarks Tekniske Universitet\Semester4\My Code\VHDL\Interleaver\YL\LLR_in(4).txt", read_mode);
        for i in 0 to 255 loop
            if not(endfile(file_in)) then
                readline(file_in, line_in);-- Read line from file
                read(line_in, input_tmp);-- Read value from line
                input_data_channel(i) <= input_tmp;
            end if;
        end loop;
        file_close(file_in);

        wait for ClockPeriod;
        file_open(file_in, "C:\Onedrive\OneDrive - Danmarks Tekniske Universitet\Semester4\My Code\VHDL\Interleaver\YL\LLR_in(4).txt", read_mode);
        for i in 0 to 255 loop
            if not(endfile(file_in)) then
                readline(file_in, line_in);-- Read line from file
                read(line_in, input_tmp);-- Read value from line
                input_data_channel(i) <= input_tmp;
            end if;
        end loop;
        file_close(file_in);

        wait for ClockPeriod;
        file_open(file_in, "C:\Onedrive\OneDrive - Danmarks Tekniske Universitet\Semester4\My Code\VHDL\Interleaver\YL\LLR_in(5).txt", read_mode);
        for i in 0 to 255 loop
            if not(endfile(file_in)) then
                readline(file_in, line_in);-- Read line from file
                read(line_in, input_tmp);-- Read value from line
                input_data_channel(i) <= input_tmp;
            end if;
        end loop;
        file_close(file_in);

        wait for ClockPeriod;
        file_open(file_in, "C:\Onedrive\OneDrive - Danmarks Tekniske Universitet\Semester4\My Code\VHDL\Interleaver\YL\LLR_in(5).txt", read_mode);
        for i in 0 to 255 loop
            if not(endfile(file_in)) then
                readline(file_in, line_in);-- Read line from file
                read(line_in, input_tmp);-- Read value from line
                input_data_channel(i) <= input_tmp;
            end if;
        end loop;
        file_close(file_in);

        wait for ClockPeriod;
        file_open(file_in, "C:\Onedrive\OneDrive - Danmarks Tekniske Universitet\Semester4\My Code\VHDL\Interleaver\YL\LLR_in(6).txt", read_mode);
        for i in 0 to 255 loop
            if not(endfile(file_in)) then
                readline(file_in, line_in);-- Read line from file
                read(line_in, input_tmp);-- Read value from line
                input_data_channel(i) <= input_tmp;
            end if;
        end loop;
        file_close(file_in);

        wait for ClockPeriod;
        file_open(file_in, "C:\Onedrive\OneDrive - Danmarks Tekniske Universitet\Semester4\My Code\VHDL\Interleaver\YL\LLR_in(6).txt", read_mode);
        for i in 0 to 255 loop
            if not(endfile(file_in)) then
                readline(file_in, line_in);-- Read line from file
                read(line_in, input_tmp);-- Read value from line
                input_data_channel(i) <= input_tmp;
            end if;
        end loop;
        file_close(file_in);

        wait for ClockPeriod;
        file_open(file_in, "C:\Onedrive\OneDrive - Danmarks Tekniske Universitet\Semester4\My Code\VHDL\Interleaver\YL\LLR_in(7).txt", read_mode);
        for i in 0 to 255 loop
            if not(endfile(file_in)) then
                readline(file_in, line_in);-- Read line from file
                read(line_in, input_tmp);-- Read value from line
                input_data_channel(i) <= input_tmp;
            end if;
        end loop;
        file_close(file_in);

        wait for ClockPeriod;
        file_open(file_in, "C:\Onedrive\OneDrive - Danmarks Tekniske Universitet\Semester4\My Code\VHDL\Interleaver\YL\LLR_in(7).txt", read_mode);
        for i in 0 to 255 loop
            if not(endfile(file_in)) then
                readline(file_in, line_in);-- Read line from file
                read(line_in, input_tmp);-- Read value from line
                input_data_channel(i) <= input_tmp;
            end if;
        end loop;
        file_close(file_in);

        wait;
    end process;
end architecture;
