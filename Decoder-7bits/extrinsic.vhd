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
    signal extrinsic_info_2   : extrinsic_array(255 downto 128);
    signal extrinsic_info_1_1 : extrinsic_array(127 downto 0);
    signal extrinsic_info_f1  : input_data_array(127 downto 0);
    signal extrinsic_info_f2  : input_data_array(255 downto 128);
    --------------------------------------------------------------------------------------------
    -- CLK 5
    signal extrinsic_info_f1_e1 : input_data_array(127 downto 0);
    signal extrinsic_info_f2_e1 : input_data_array(255 downto 128);
    --------------------------------------------------------------------------------------------
    -- CLK 6
    signal extrinsic_info_f1_e2 : input_data_array(127 downto 0);
    signal extrinsic_info_f2_e2 : input_data_array(255 downto 128);
    --------------------------------------------------------------------------------------------
    -- CLK 7
    signal extrinsic_info_f1_e3 : input_data_array(127 downto 0);
    signal extrinsic_info_f2_e3 : input_data_array(255 downto 128);
    --------------------------------------------------------------------------------------------
    -- CLK 8
    signal extrinsic_info_f1_e4 : input_data_array(127 downto 0);
    signal extrinsic_info_f2_e4 : input_data_array(255 downto 128);
    --------------------------------------------------------------------------------------------
    -- CLK 9
    signal extrinsic_info_f1_e5 : input_data_array(127 downto 0);
    signal extrinsic_info_f2_e5 : input_data_array(255 downto 128);
    --------------------------------------------------------------------------------------------
    -- CLK 10
    signal extrinsic_info_f1_e6 : input_data_array(127 downto 0);
    signal extrinsic_info_f2_e6 : input_data_array(255 downto 128);
    --------------------------------------------------------------------------------------------
    -- CLK 11
    signal extrinsic_info_f1_e7 : input_data_array(127 downto 0);
    signal extrinsic_info_f2_e7 : input_data_array(255 downto 128);
    --------------------------------------------------------------------------------------------
    -- CLK 12
    signal extrinsic_info_f1_e8 : input_data_array(127 downto 0);
    signal extrinsic_info_f2_e8 : input_data_array(255 downto 128);
    --------------------------------------------------------------------------------------------
    -- CLK 13
    signal extrinsic_info_f1_e9 : input_data_array(127 downto 0);
    signal extrinsic_info_f2_e9 : input_data_array(255 downto 128);
    --------------------------------------------------------------------------------------------
    -- CLK 14
    signal extrinsic_info_f1_e10 : input_data_array(127 downto 0);
    signal extrinsic_info_f2_e10 : input_data_array(255 downto 128);
    --------------------------------------------------------------------------------------------
    -- CLK 15
    signal extrinsic_info_f1_e11 : input_data_array(127 downto 0);
    signal extrinsic_info_f2_e11 : input_data_array(255 downto 128);
begin
    ------------------------------------------------------------------------------------------------------------
    -- Define processes : (CLK 1)
    ------------------------------------------------------------------------------------------------------------
    process (clk, reset)
    begin
        if (reset = '1') then
            soft_input_1          <= (others => (others => '0'));
            soft_input_original_1 <= (others => (others => '0'));
        elsif (rising_edge(clk)) then
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
            soft_input_3          <= soft_input_2;
            soft_input_original_3 <= soft_input_original_2;
            for i in 127 downto 0 loop
                extrinsic_info_1(i) <= (soft_input_2(i)(10) & soft_input_2(i)) - (soft_input_original_2(i)(10) & soft_input_original_2(i));
            end loop;
        end if;
    end process;
    ------------------------------------------------------------------------------------------------------------
    -- Define processes : (CLK 4)
    ------------------------------------------------------------------------------------------------------------
    process (clk, reset)
    begin
        if (reset = '1') then
            extrinsic_info_2   <= (others => (others => '0'));
            extrinsic_info_1_1 <= (others => (others => '0'));
            soft_output_1      <= (others => (others => '0'));
        elsif (rising_edge(clk)) then
            soft_output_1      <= soft_input_3;
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
            soft_output_2     <= (others => (others => '0'));
        elsif (rising_edge(clk)) then
            soft_output_2     <= soft_output_1;
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
            extrinsic_info_f1_e11 <= extrinsic_info_f1_e10;
            extrinsic_info_f2_e11 <= extrinsic_info_f2_e10;
        end if;
    end process;
    ------------------------------------------------------------------------------------------------------------
    -- Define processes : (CLK 17)
    ------------------------------------------------------------------------------------------------------------
    process (clk, reset)
    begin
        if (reset = '1') then
            extrinsic_info_half1 <= (others => (others => '0'));
            extrinsic_info_half2 <= (others => (others => '0'));
        elsif (rising_edge(clk)) then
            extrinsic_info_half1 <= extrinsic_info_f1_e11;
            extrinsic_info_half2 <= extrinsic_info_f2_e11;
        end if;
    end process;
end architecture;
