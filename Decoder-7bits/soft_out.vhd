-- 1. weight should be a value without sign
-- 2. soft_input and soft_output should have sign
--library ieee;
--use ieee.std_logic_1164.all;
--
--PACKAGE arr_pkg_10 IS
--    type input_data_array is array (natural range <>) of std_logic_vector(7 downto 0); -- 8 bits, should be soft input this time!
--END; 
--
--library ieee;
--use ieee.std_logic_1164.all;
--
--PACKAGE arr_pkg_11 IS
--    type weight_array is array (natural range <>) of std_logic_vector(10 downto 0);
--END;  

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use IEEE.numeric_std.all;
use ieee.math_real.all;
use work.arr_pkg_1.all;
use work.arr_pkg_2.all;
use work.arr_pkg_3.all;
use work.arr_pkg_4.all;
use work.arr_pkg_5.all;

entity soft_out is
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
end soft_out;

architecture rtl of soft_out is
    constant const_llr_1 : std_logic_vector(10 downto 0) := "00001111111";
    constant const_llr_2 : std_logic_vector(10 downto 0) := "00001111111";
    ------------------------------------------------------------------------------------------------------------
    --CLK 0
    signal soft_input_original_m   :  input_data_array(data_in_length downto 0);
    signal hard_input_1_m          :  std_logic_vector(data_in_length downto 0);
    signal weight_1_m              :  std_logic_vector(10 downto 0);
    signal corrections_in_1_m      :  std_logic_vector(index_length downto 0);
    signal hard_input_2_m          :  std_logic_vector(data_in_length downto 0);
    signal weight_2_m              :  std_logic_vector(10 downto 0);
    signal corrections_in_2_m      :  std_logic_vector(index_length downto 0);  
    signal hard_input_3_m          :  std_logic_vector(data_in_length downto 0); 
    signal weight_3_m              :  std_logic_vector(10 downto 0);  
    signal corrections_in_3_m      :  std_logic_vector(index_length downto 0); 
    signal hard_input_4_m          :  std_logic_vector(data_in_length downto 0); 
    signal weight_4_m              :  std_logic_vector(10 downto 0); 
    signal corrections_in_4_m      :  std_logic_vector(index_length downto 0); 
    signal hard_input_5_m          :  std_logic_vector(data_in_length downto 0);   
    signal weight_5_m              :  std_logic_vector(10 downto 0);  
    signal corrections_in_5_m      :  std_logic_vector(index_length downto 0);  
    signal hard_input_6_m          :  std_logic_vector(data_in_length downto 0);   
    signal weight_6_m              :  std_logic_vector(10 downto 0);   
    signal corrections_in_6_m      :  std_logic_vector(index_length downto 0);  
    signal hard_input_7_m          :  std_logic_vector(data_in_length downto 0);   
    signal weight_7_m              :  std_logic_vector(10 downto 0);  
    signal corrections_in_7_m      :  std_logic_vector(index_length downto 0);    
    signal hard_input_8_m          :  std_logic_vector(data_in_length downto 0);  
    signal weight_8_m              :  std_logic_vector(10 downto 0);   
    signal corrections_in_8_m      :  std_logic_vector(index_length downto 0);  
    signal const_llr_1_m           :  std_logic_vector(10 downto 0);
    signal const_llr_2_m           :  std_logic_vector(10 downto 0);
    ------------------------------------------------------------------------------------------------------------
    --CLK 1  
    signal const_llr_1_1         : std_logic_vector(10 downto 0);
    signal const_llr_2_1         : std_logic_vector(10 downto 0);
    signal weight_1_1            : std_logic_vector(10 downto 0);
    signal weight_2_1            : std_logic_vector(10 downto 0);
    signal weight_3_1            : std_logic_vector(10 downto 0);
    signal weight_4_1            : std_logic_vector(10 downto 0);
    signal weight_5_1            : std_logic_vector(10 downto 0);
    signal weight_6_1            : std_logic_vector(10 downto 0);
    signal weight_7_1            : std_logic_vector(10 downto 0);
    signal weight_8_1            : std_logic_vector(10 downto 0);
    signal indi_1                : indi_array(127 downto 0);
    signal indi_3                : indi_array(127 downto 0);
    signal indi_5                : indi_array(127 downto 0);
    signal indi_7                : indi_array(127 downto 0);
    signal hard_input_1_temp     : std_logic_vector(255 downto 0);
    signal hard_input_2_temp     : std_logic_vector(255 downto 0);
    signal hard_input_3_temp     : std_logic_vector(255 downto 0);
    signal hard_input_4_temp     : std_logic_vector(255 downto 0);
    signal hard_input_5_temp     : std_logic_vector(255 downto 0);
    signal hard_input_6_temp     : std_logic_vector(255 downto 0);
    signal hard_input_7_temp     : std_logic_vector(255 downto 0);
    signal hard_input_8_temp     : std_logic_vector(255 downto 0);
    signal max_weight_temp_1     : std_logic_vector(10 downto 0);
    signal max_weight_temp_2     : std_logic_vector(10 downto 0);
    signal max_weight_temp_3     : std_logic_vector(10 downto 0);
    signal max_weight_temp_4     : std_logic_vector(10 downto 0);
    signal corrections_in_1_pass : std_logic_vector(2 downto 0);
    signal corrections_in_2_pass : std_logic_vector(2 downto 0);
    signal corrections_in_3_pass : std_logic_vector(2 downto 0);
    signal corrections_in_4_pass : std_logic_vector(2 downto 0);
    signal corrections_in_5_pass : std_logic_vector(2 downto 0);
    signal corrections_in_6_pass : std_logic_vector(2 downto 0);
    signal corrections_in_7_pass : std_logic_vector(2 downto 0);
    signal corrections_in_8_pass : std_logic_vector(2 downto 0);
    signal soft_input_original_1 : input_data_array(255 downto 0);
    ------------------------------------------------------------------------------------------------------------
    --CLK 2    
    signal const_llr_1_2         : std_logic_vector(10 downto 0);
    signal const_llr_2_2         : std_logic_vector(10 downto 0);
    signal indi_1_temp           : indi_array(127 downto 0);
    signal indi_3_temp           : indi_array(127 downto 0);
    signal indi_5_temp           : indi_array(127 downto 0);
    signal indi_7_temp           : indi_array(127 downto 0);
    signal indi_2                : indi_array(255 downto 128);
    signal indi_4                : indi_array(255 downto 128);
    signal indi_6                : indi_array(255 downto 128);
    signal indi_8                : indi_array(255 downto 128);
    signal flag_1                : boolean; -- weight_1 > weight_2
    signal flag_2                : boolean; -- weight_1 < weight_2 or weight_1 = weight_2
    signal flag_3                : boolean; -- weight_3 > weight_4
    signal flag_4                : boolean; -- weight_3 < weight_4 or weight_3 = weight_4
    signal flag_5                : boolean; -- weight_5 > weight_6
    signal flag_6                : boolean; -- weight_5 < weight_6 or weight_5 = weight_6
    signal flag_7                : boolean; -- weight_7 > weight_8
    signal flag_8                : boolean; -- weight_7 < weight_8 or weight_7 = weight_8
    signal weight_1_2            : std_logic_vector(10 downto 0);
    signal weight_2_2            : std_logic_vector(10 downto 0);
    signal weight_3_2            : std_logic_vector(10 downto 0);
    signal weight_4_2            : std_logic_vector(10 downto 0);
    signal weight_5_2            : std_logic_vector(10 downto 0);
    signal weight_6_2            : std_logic_vector(10 downto 0);
    signal weight_7_2            : std_logic_vector(10 downto 0);
    signal weight_8_2            : std_logic_vector(10 downto 0);
    signal hard_input_1_temp_1   : std_logic_vector(255 downto 0);
    signal hard_input_2_temp_1   : std_logic_vector(255 downto 0);
    signal hard_input_3_temp_1   : std_logic_vector(255 downto 0);
    signal hard_input_4_temp_1   : std_logic_vector(255 downto 0);
    signal hard_input_5_temp_1   : std_logic_vector(255 downto 0);
    signal hard_input_6_temp_1   : std_logic_vector(255 downto 0);
    signal hard_input_7_temp_1   : std_logic_vector(255 downto 0);
    signal hard_input_8_temp_1   : std_logic_vector(255 downto 0);
    signal llr_1_temp_1          : output_data_array(255 downto 0);
    signal llr_0_temp_1          : output_data_array(255 downto 0);
    signal llr_1_temp_2          : output_data_array(255 downto 0);
    signal llr_0_temp_2          : output_data_array(255 downto 0);
    signal llr_1_temp_3          : output_data_array(255 downto 0);
    signal llr_0_temp_3          : output_data_array(255 downto 0);
    signal llr_1_temp_4          : output_data_array(255 downto 0);
    signal llr_0_temp_4          : output_data_array(255 downto 0);
    signal llr_1_temp_5          : output_data_array(255 downto 0);
    signal llr_0_temp_5          : output_data_array(255 downto 0);
    signal llr_1_temp_6          : output_data_array(255 downto 0);
    signal llr_0_temp_6          : output_data_array(255 downto 0);
    signal llr_1_temp_7          : output_data_array(255 downto 0);
    signal llr_0_temp_7          : output_data_array(255 downto 0);
    signal llr_1_temp_8          : output_data_array(255 downto 0);
    signal llr_0_temp_8          : output_data_array(255 downto 0);
    signal soft_input_original_2 : input_data_array(255 downto 0);
    signal max_weight_b1         : std_logic_vector(10 downto 0);
    signal max_weight_b2         : std_logic_vector(10 downto 0);
    ------------------------------------------------------------------------------------------------------------
    --CLK 3   
    signal const_llr_1_3         : std_logic_vector(10 downto 0);
    signal const_llr_2_3         : std_logic_vector(10 downto 0);
    signal llr_1_temp_1_1        : output_data_array(255 downto 0);
    signal llr_0_temp_1_1        : output_data_array(255 downto 0);
    signal llr_1_temp_2_1        : output_data_array(255 downto 0);
    signal llr_0_temp_2_1        : output_data_array(255 downto 0);
    signal llr_1_temp_3_1        : output_data_array(255 downto 0);
    signal llr_0_temp_3_1        : output_data_array(255 downto 0);
    signal llr_1_temp_4_1        : output_data_array(255 downto 0);
    signal llr_0_temp_4_1        : output_data_array(255 downto 0);
    signal max_weight_1          : std_logic_vector(10 downto 0);
    signal soft_input_original_3 : input_data_array(255 downto 0);
    ------------------------------------------------------------------------------------------------------------
    --CLK 4    
    signal const_llr_1_4         : std_logic_vector(10 downto 0);
    signal const_llr_2_4         : std_logic_vector(10 downto 0);
    signal llr_1_final_1         : output_data_array(255 downto 0);
    signal llr_0_final_1         : output_data_array(255 downto 0);
    signal llr_1_final_2         : output_data_array(255 downto 0);
    signal llr_0_final_2         : output_data_array(255 downto 0);
    signal max_weight_2          : std_logic_vector(10 downto 0);
    signal soft_input_original_4 : input_data_array(255 downto 0);
    ------------------------------------------------------------------------------------------------------------
    --CLK 5  
    signal const_llr_1_5         : std_logic_vector(10 downto 0);
    signal const_llr_2_5         : std_logic_vector(10 downto 0);
    signal llr_1_last            : output_data_array(255 downto 0);
    signal llr_0_last            : output_data_array(255 downto 0);
    signal max_weight_3          : std_logic_vector(10 downto 0);
    signal soft_input_original_5 : input_data_array(255 downto 0);
    ------------------------------------------------------------------------------------------------------------
    --CLK 6   
    signal llr_1_final           : output_data_array(255 downto 0);
    signal llr_0_final           : output_data_array(255 downto 0);
    signal max_weight_4          : std_logic_vector(10 downto 0);
    signal soft_input_original_6 : input_data_array(255 downto 0);
    signal sub                   : output_data_array(255 downto 0);
    signal const_llr_1_6         : std_logic_vector(10 downto 0);
    signal const_llr_2_6         : std_logic_vector(10 downto 0);
begin
    ------------------------------------------------------------------------------------------------------------
    -- Define processes : (CLK 0)
    ------------------------------------------------------------------------------------------------------------
    process (clk, reset)
    begin
        if (reset = '1') then
            soft_input_original_m <= (others => (others => '0'));
            hard_input_1_m        <= (others => '0');
            weight_1_m            <= (others => '0');
            corrections_in_1_m    <= (others => '0');
            hard_input_2_m        <= (others => '0');
            weight_2_m            <= (others => '0');
            corrections_in_2_m    <= (others => '0');
            hard_input_3_m        <= (others => '0');
            weight_3_m            <= (others => '0');
            corrections_in_3_m    <= (others => '0');
            hard_input_4_m        <= (others => '0');
            weight_4_m            <= (others => '0');
            corrections_in_4_m    <= (others => '0');
            hard_input_5_m        <= (others => '0');
            weight_5_m            <= (others => '0');
            corrections_in_5_m    <= (others => '0');
            hard_input_6_m        <= (others => '0');
            weight_6_m            <= (others => '0');
            corrections_in_6_m    <= (others => '0');
            hard_input_7_m        <= (others => '0');
            weight_7_m            <= (others => '0');
            corrections_in_7_m    <= (others => '0');
            hard_input_8_m        <= (others => '0');
            weight_8_m            <= (others => '0');
            corrections_in_8_m    <= (others => '0');
            const_llr_1_m             <= (others => '0');
            const_llr_2_m             <= (others => '0');
        elsif (rising_edge(clk)) then
            const_llr_1_m             <= const_llr_1;
            const_llr_2_m             <= const_llr_2;
            soft_input_original_m     <=  soft_input_original;
            hard_input_1_m            <=  hard_input_1;       
            weight_1_m                <=  weight_1;           
            corrections_in_1_m        <=  corrections_in_1;   
            hard_input_2_m            <=  hard_input_2;       
            weight_2_m                <=  weight_2;           
            corrections_in_2_m        <=  corrections_in_2;   
            hard_input_3_m            <=  hard_input_3;       
            weight_3_m                <=  weight_3;           
            corrections_in_3_m        <=  corrections_in_3;   
            hard_input_4_m            <=  hard_input_4;       
            weight_4_m                <=  weight_4;           
            corrections_in_4_m        <=  corrections_in_4;   
            hard_input_5_m            <=  hard_input_5;       
            weight_5_m                <=  weight_5;           
            corrections_in_5_m        <=  corrections_in_5;   
            hard_input_6_m            <=  hard_input_6;       
            weight_6_m                <=  weight_6;           
            corrections_in_6_m        <=  corrections_in_6;   
            hard_input_7_m            <=  hard_input_7;       
            weight_7_m                <=  weight_7;           
            corrections_in_7_m        <=  corrections_in_7;   
            hard_input_8_m            <=  hard_input_8;       
            weight_8_m                <=  weight_8;           
            corrections_in_8_m        <=  corrections_in_8;   
        end if;
    end process;
    ------------------------------------------------------------------------------------------------------------
    -- Define processes : (CLK 1)
    ------------------------------------------------------------------------------------------------------------
    process (clk, reset)
    begin
        if (reset = '1') then
            const_llr_1_1         <= (others => '0');
            const_llr_2_1         <= (others => '0');
            weight_1_1            <= (others => '0');
            weight_2_1            <= (others => '0');
            weight_3_1            <= (others => '0');
            weight_4_1            <= (others => '0');
            weight_5_1            <= (others => '0');
            weight_6_1            <= (others => '0');
            weight_7_1            <= (others => '0');
            weight_8_1            <= (others => '0');
            max_weight_temp_1     <= (others => '0');
            max_weight_temp_2     <= (others => '0');
            max_weight_temp_3     <= (others => '0');
            max_weight_temp_4     <= (others => '0');
            hard_input_1_temp     <= (others => '0');
            hard_input_2_temp     <= (others => '0');
            hard_input_3_temp     <= (others => '0');
            hard_input_4_temp     <= (others => '0');
            hard_input_5_temp     <= (others => '0');
            hard_input_6_temp     <= (others => '0');
            hard_input_7_temp     <= (others => '0');
            hard_input_8_temp     <= (others => '0');
            soft_input_original_1 <= (others => (others => '0'));
            corrections_in_1_pass <= (others => '0');
            corrections_in_2_pass <= (others => '0');
            corrections_in_3_pass <= (others => '0');
            corrections_in_4_pass <= (others => '0');
            corrections_in_5_pass <= (others => '0');
            corrections_in_6_pass <= (others => '0');
            corrections_in_7_pass <= (others => '0');
            corrections_in_8_pass <= (others => '0');
        elsif (rising_edge(clk)) then
            if weight_1_m > weight_2_m then
                max_weight_temp_1 <= weight_1_m;
            else
                max_weight_temp_1 <= weight_2_m;
            end if;
            if weight_3_m > weight_4_m then
                max_weight_temp_2 <= weight_3_m;
            else
                max_weight_temp_2 <= weight_4_m;
            end if;
            if weight_5_m > weight_6_m then
                max_weight_temp_3 <= weight_5_m;
            else
                max_weight_temp_3 <= weight_6_m;
            end if;
            if weight_7_m > weight_8_m then
                max_weight_temp_4 <= weight_7_m;
            else
                max_weight_temp_4 <= weight_8_m;
            end if;
            const_llr_1_1         <= const_llr_1_m;
            const_llr_2_1         <= const_llr_2_m;
            soft_input_original_1 <= soft_input_original_m;
            weight_1_1            <= weight_1_m;
            weight_2_1            <= weight_2_m;
            weight_3_1            <= weight_3_m;
            weight_4_1            <= weight_4_m;
            weight_5_1            <= weight_5_m;
            weight_6_1            <= weight_6_m;
            weight_7_1            <= weight_7_m;
            weight_8_1            <= weight_8_m;
            corrections_in_1_pass <= corrections_in_1_m;
            corrections_in_2_pass <= corrections_in_2_m;
            corrections_in_3_pass <= corrections_in_3_m;
            corrections_in_4_pass <= corrections_in_4_m;
            corrections_in_5_pass <= corrections_in_5_m;
            corrections_in_6_pass <= corrections_in_6_m;
            corrections_in_7_pass <= corrections_in_7_m;
            corrections_in_8_pass <= corrections_in_8_m;
            hard_input_1_temp     <= hard_input_1_m;
            hard_input_2_temp     <= hard_input_2_m;
            hard_input_3_temp     <= hard_input_3_m;
            hard_input_4_temp     <= hard_input_4_m;
            hard_input_5_temp     <= hard_input_5_m;
            hard_input_6_temp     <= hard_input_6_m;
            hard_input_7_temp     <= hard_input_7_m;
            hard_input_8_temp     <= hard_input_8_m;
        end if;
    end process;
    ------------------------------------------------------------------------------------------------------------
    -- Define processes : (CLK 2)
    ------------------------------------------------------------------------------------------------------------
    process (clk, reset)
    begin
        if (reset = '1') then
            flag_1                <= false;
            flag_2                <= false;
            flag_3                <= false;
            flag_4                <= false;
            flag_5                <= false;
            flag_6                <= false;
            flag_7                <= false;
            flag_8                <= false;
            weight_1_2            <= (others => '0');
            weight_2_2            <= (others => '0');
            weight_3_2            <= (others => '0');
            weight_4_2            <= (others => '0');
            weight_5_2            <= (others => '0');
            weight_6_2            <= (others => '0');
            weight_7_2            <= (others => '0');
            weight_8_2            <= (others => '0');
            hard_input_1_temp_1   <= (others => '0');
            hard_input_2_temp_1   <= (others => '0');
            hard_input_3_temp_1   <= (others => '0');
            hard_input_4_temp_1   <= (others => '0');
            hard_input_5_temp_1   <= (others => '0');
            hard_input_6_temp_1   <= (others => '0');
            hard_input_7_temp_1   <= (others => '0');
            hard_input_8_temp_1   <= (others => '0');
            soft_input_original_2 <= (others => (others => '0'));
            max_weight_b1         <= (others => '0');
            max_weight_b2         <= (others => '0');
            const_llr_1_2         <= (others => '0');
            const_llr_2_2         <= (others => '0');
        elsif (rising_edge(clk)) then
            if max_weight_temp_1 > max_weight_temp_2 then
                max_weight_b1 <= max_weight_temp_1;
            else
                max_weight_b1 <= max_weight_temp_2;
            end if;
            if max_weight_temp_3 > max_weight_temp_4 then
                max_weight_b2 <= max_weight_temp_3;
            else
                max_weight_b2 <= max_weight_temp_4;
            end if;
            const_llr_1_2         <= const_llr_1_1;
            const_llr_2_2         <= const_llr_2_1;
            weight_1_2            <= weight_1_1;
            weight_2_2            <= weight_2_1;
            weight_3_2            <= weight_3_1;
            weight_4_2            <= weight_4_1;
            weight_5_2            <= weight_5_1;
            weight_6_2            <= weight_6_1;
            weight_7_2            <= weight_7_1;
            weight_8_2            <= weight_8_1;
            hard_input_1_temp_1   <= hard_input_1_temp;
            hard_input_2_temp_1   <= hard_input_2_temp;
            hard_input_3_temp_1   <= hard_input_3_temp;
            hard_input_4_temp_1   <= hard_input_4_temp;
            hard_input_5_temp_1   <= hard_input_5_temp;
            hard_input_6_temp_1   <= hard_input_6_temp;
            hard_input_7_temp_1   <= hard_input_7_temp;
            hard_input_8_temp_1   <= hard_input_8_temp;
            soft_input_original_2 <= soft_input_original_1;
            -------------------------invalid indicator for input 1 and input 2---------------------------
            llr_1_temp_1 <= (others => "01111111111");
            llr_0_temp_1 <= (others => "01111111111");
            llr_1_temp_2 <= (others => "01111111111");
            llr_0_temp_2 <= (others => "01111111111");
            llr_1_temp_3 <= (others => "01111111111");
            llr_0_temp_3 <= (others => "01111111111");
            llr_1_temp_4 <= (others => "01111111111");
            llr_0_temp_4 <= (others => "01111111111");
            llr_1_temp_5 <= (others => "01111111111");
            llr_0_temp_5 <= (others => "01111111111");
            llr_1_temp_6 <= (others => "01111111111");
            llr_0_temp_6 <= (others => "01111111111");
            llr_1_temp_7 <= (others => "01111111111");
            llr_0_temp_7 <= (others => "01111111111");
            llr_1_temp_8 <= (others => "01111111111");
            llr_0_temp_8 <= (others => "01111111111");
            if corrections_in_1_pass = "100" then
                llr_1_temp_1 <= (others => "01111111111");
                llr_0_temp_1 <= (others => "01111111111");
            else
                for i in 255 downto 0 loop
                    if hard_input_1_temp(i) = '1' then
                        llr_1_temp_1(i) <= weight_1_1;
                    else
                        llr_0_temp_1(i) <= weight_1_1;
                    end if;
                end loop;
            end if;
            if corrections_in_2_pass = "100" then
                llr_1_temp_2 <= (others => "01111111111");
                llr_0_temp_2 <= (others => "01111111111");
            else
                for i in 255 downto 0 loop
                    if hard_input_2_temp(i) = '1' then
                        llr_1_temp_2(i) <= weight_2_1;
                    else
                        llr_0_temp_2(i) <= weight_2_1;
                    end if;
                end loop;
            end if;
            if corrections_in_3_pass = "100" then
                llr_1_temp_3 <= (others => "01111111111");
                llr_0_temp_3 <= (others => "01111111111");
            else
                for i in 255 downto 0 loop
                    if hard_input_3_temp(i) = '1' then
                        llr_1_temp_3(i) <= weight_3_1;
                    else
                        llr_0_temp_3(i) <= weight_3_1;
                    end if;
                end loop;
            end if;
            if corrections_in_4_pass = "100" then
                llr_1_temp_4 <= (others => "01111111111");
                llr_0_temp_4 <= (others => "01111111111");
            else
                for i in 255 downto 0 loop
                    if hard_input_4_temp(i) = '1' then
                        llr_1_temp_4(i) <= weight_4_1;
                    else
                        llr_0_temp_4(i) <= weight_4_1;
                    end if;
                end loop;
            end if;
            if corrections_in_5_pass = "100" then
                llr_1_temp_5 <= (others => "01111111111");
                llr_0_temp_5 <= (others => "01111111111");
            else
                for i in 255 downto 0 loop
                    if hard_input_5_temp(i) = '1' then
                        llr_1_temp_5(i) <= weight_5_1;
                    else
                        llr_0_temp_5(i) <= weight_5_1;
                    end if;
                end loop;
            end if;
            if corrections_in_6_pass = "100" then
                llr_1_temp_6 <= (others => "01111111111");
                llr_0_temp_6 <= (others => "01111111111");
            else
                for i in 255 downto 0 loop
                    if hard_input_6_temp(i) = '1' then
                        llr_1_temp_6(i) <= weight_6_1;
                    else
                        llr_0_temp_6(i) <= weight_6_1;
                    end if;
                end loop;
            end if;
            if corrections_in_7_pass = "100" then
                llr_1_temp_7 <= (others => "01111111111");
                llr_0_temp_7 <= (others => "01111111111");
            else
                for i in 255 downto 0 loop
                    if hard_input_7_temp(i) = '1' then
                        llr_1_temp_7(i) <= weight_7_1;
                    else
                        llr_0_temp_7(i) <= weight_7_1;
                    end if;
                end loop;
            end if;
            if corrections_in_8_pass = "100" then
                llr_1_temp_8 <= (others => "01111111111");
                llr_0_temp_8 <= (others => "01111111111");
            else
                for i in 255 downto 0 loop
                    if hard_input_8_temp(i) = '1' then
                        llr_1_temp_8(i) <= weight_8_1;
                    else
                        llr_0_temp_8(i) <= weight_8_1;
                    end if;
                end loop;
            end if;
        end if;
    end process;
    ------------------------------------------------------------------------------------------------------------
    -- Define processes : (CLK 3)
    ------------------------------------------------------------------------------------------------------------
    process (clk, reset)
    begin
        if (reset = '1') then
            llr_1_temp_1_1        <= (others => "01111111111"); -- for input 1 and 2
            llr_0_temp_1_1        <= (others => "01111111111");
            llr_1_temp_2_1        <= (others => "01111111111"); -- for input 3 and 4
            llr_0_temp_2_1        <= (others => "01111111111");
            llr_1_temp_3_1        <= (others => "01111111111"); -- for input 5 and 6
            llr_0_temp_3_1        <= (others => "01111111111");
            llr_1_temp_4_1        <= (others => "01111111111"); -- for input 7 and 8
            llr_0_temp_4_1        <= (others => "01111111111");
            max_weight_1          <= (others => '0');
            soft_input_original_3 <= (others => (others => '0'));
            const_llr_1_3         <= (others => '0');
            const_llr_2_3         <= (others => '0');
        elsif (rising_edge(clk)) then
            const_llr_1_3         <= const_llr_1_2;
            const_llr_2_3         <= const_llr_2_2;
            llr_1_temp_1_1        <= (others => "01111111111");
            llr_0_temp_1_1        <= (others => "01111111111");
            llr_1_temp_2_1        <= (others => "01111111111");
            llr_0_temp_2_1        <= (others => "01111111111");
            llr_1_temp_3_1        <= (others => "01111111111");
            llr_0_temp_3_1        <= (others => "01111111111");
            llr_1_temp_4_1        <= (others => "01111111111");
            llr_0_temp_4_1        <= (others => "01111111111");
            soft_input_original_3 <= soft_input_original_2;
            if max_weight_b1 > max_weight_b2 then
                max_weight_1 <= max_weight_b1;
            else
                max_weight_1 <= max_weight_b2;
            end if;
            ---------------------------------between input 1 and 2---------------------------------------
            for i in 0 to 255 loop
                ---- compare between llr_0_temp_1 and llr_0_temp_2
                if llr_0_temp_2(i) > llr_0_temp_1(i) then
                    llr_0_temp_1_1(i) <= llr_0_temp_1(i);
                else
                    llr_0_temp_1_1(i) <= llr_0_temp_2(i);
                end if;
                if llr_1_temp_2(i) > llr_1_temp_1(i) then
                    llr_1_temp_1_1(i) <= llr_1_temp_1(i);
                else
                    llr_1_temp_1_1(i) <= llr_1_temp_2(i);
                end if;
                ---- compare between llr_0_temp_3 and llr_0_temp_4
                if llr_0_temp_4(i) > llr_0_temp_3(i) then
                    llr_0_temp_2_1(i) <= llr_0_temp_3(i);
                else
                    llr_0_temp_2_1(i) <= llr_0_temp_4(i);
                end if;
                if llr_1_temp_4(i) > llr_1_temp_3(i) then
                    llr_1_temp_2_1(i) <= llr_1_temp_3(i);
                else
                    llr_1_temp_2_1(i) <= llr_1_temp_4(i);
                end if;
                ---- compare between llr_0_temp_5 and llr_0_temp_6
                if llr_0_temp_6(i) > llr_0_temp_5(i) then
                    llr_0_temp_3_1(i) <= llr_0_temp_5(i);
                else
                    llr_0_temp_3_1(i) <= llr_0_temp_6(i);
                end if;
                if llr_1_temp_6(i) > llr_1_temp_5(i) then
                    llr_1_temp_3_1(i) <= llr_1_temp_5(i);
                else
                    llr_1_temp_3_1(i) <= llr_1_temp_6(i);
                end if;
                ---- compare between llr_0_temp_7 and llr_0_temp_8
                if llr_0_temp_8(i) > llr_0_temp_7(i) then
                    llr_0_temp_4_1(i) <= llr_0_temp_7(i);
                else
                    llr_0_temp_4_1(i) <= llr_0_temp_8(i);
                end if;
                if llr_1_temp_4(i) > llr_1_temp_3(i) then
                    llr_1_temp_4_1(i) <= llr_1_temp_7(i);
                else
                    llr_1_temp_4_1(i) <= llr_1_temp_8(i);
                end if;
            end loop;
        end if;
    end process;
    --------------------------------------------------------------------------------------------------------------
    ---- Define processes : (CLK 4)
    --------------------------------------------------------------------------------------------------------------
    process (clk, reset)
    begin
        if (reset = '1') then
            llr_1_final_1         <= (others => (others => '0'));
            llr_0_final_1         <= (others => (others => '0'));
            llr_1_final_2         <= (others => (others => '0'));
            llr_0_final_2         <= (others => (others => '0'));
            max_weight_2          <= (others => '0');
            soft_input_original_4 <= (others => (others => '0'));
            const_llr_1_4         <= (others => '0');
            const_llr_2_4         <= (others => '0');
        elsif (rising_edge(clk)) then
            const_llr_1_4         <= const_llr_1_3;
            const_llr_2_4         <= const_llr_2_3;
            soft_input_original_4 <= soft_input_original_3;
            max_weight_2          <= max_weight_1;
            for i in 0 to 255 loop
                ---- compare between llr_0_temp_1_1 and llr_0_temp_2_1
                if llr_0_temp_2_1(i) > llr_0_temp_1_1(i) then
                    llr_0_final_1(i) <= llr_0_temp_1_1(i);
                else
                    llr_0_final_1(i) <= llr_0_temp_2_1(i);
                end if;
                if llr_1_temp_2_1(i) > llr_1_temp_1_1(i) then
                    llr_1_final_1(i) <= llr_1_temp_1_1(i);
                else
                    llr_1_final_1(i) <= llr_1_temp_2_1(i);
                end if;
                ---- compare between llr_0_temp_3_1 and llr_0_temp_4_1
                if llr_0_temp_4_1(i) > llr_0_temp_3_1(i) then
                    llr_0_final_2(i) <= llr_0_temp_3_1(i);
                else
                    llr_0_final_2(i) <= llr_0_temp_4_1(i);
                end if;
                if llr_1_temp_4_1(i) > llr_1_temp_3_1(i) then
                    llr_1_final_2(i) <= llr_1_temp_3_1(i);
                else
                    llr_1_final_2(i) <= llr_1_temp_4_1(i);
                end if;
            end loop;
        end if;
    end process;
    --------------------------------------------------------------------------------------------------------------
    ---- Define processes : (CLK 5)
    --------------------------------------------------------------------------------------------------------------
    process (clk, reset)
    begin
        if (reset = '1') then
            const_llr_1_5         <= (others => '0');
            const_llr_2_5         <= (others => '0');
            llr_1_last            <= (others => (others => '0'));
            llr_0_last            <= (others => (others => '0'));
            max_weight_3          <= (others => '0');
            soft_input_original_5 <= (others => (others => '0'));
        elsif (rising_edge(clk)) then
            const_llr_1_5         <= const_llr_1_4;
            const_llr_2_5         <= const_llr_2_4;
            soft_input_original_5 <= soft_input_original_4;
            max_weight_3          <= max_weight_2;
            for i in 0 to 255 loop
                if llr_0_final_1(i) > llr_0_final_2(i) then
                    llr_0_last(i) <= llr_0_final_2(i);
                else
                    llr_0_last(i) <= llr_0_final_1(i);
                end if;
                if llr_1_final_1(i) > llr_1_final_2(i) then
                    llr_1_last(i) <= llr_1_final_2(i);
                else
                    llr_1_last(i) <= llr_1_final_1(i);
                end if;
            end loop;
        end if;
    end process;
    --------------------------------------------------------------------------------------------------------------
    -- Define processes : (CLK 6)
    --------------------------------------------------------------------------------------------------------------
    process (clk, reset)
    begin
        if (reset = '1') then
            const_llr_1_6         <= (others => '0');
            const_llr_2_6         <= (others => '0');
            max_weight_4          <= (others => '0');
            soft_input_original_6 <= (others => (others => '0'));
            sub                   <= (others => (others => '0'));
            llr_1_final           <= (others => (others => '0'));
            llr_0_final           <= (others => (others => '0'));
        elsif (rising_edge(clk)) then
            const_llr_1_6         <= const_llr_1_5;
            const_llr_2_6         <= const_llr_2_5;
            soft_input_original_6 <= soft_input_original_5;
            max_weight_4          <= max_weight_3;
            llr_0_final           <= llr_0_last;
            llr_1_final           <= llr_1_last;
            for i in 0 to 255 loop
                sub(i) <= std_logic_vector(unsigned(llr_1_last(i)) - unsigned(llr_0_last(i)));
            end loop;
        end if;
    end process;
    --------------------------------------------------------------------------------------------------------------
    -- Define processes : (CLK 7)
    --------------------------------------------------------------------------------------------------------------
    process (clk, reset)
    begin
        if (reset = '1') then
            soft_output           <= (others => (others => '0'));
            soft_output_unflipped <= (others => (others => '0'));
        elsif (rising_edge(clk)) then
            soft_output_unflipped <= soft_input_original_6;
            for i in 0 to 127 loop
                if (llr_0_final(i) = "01111111111") then
                    soft_output(i) <= const_llr_2_6;
                else
                    if (llr_1_final(i) = "01111111111") then
                        soft_output(i) <= not const_llr_2_6 + '1';
                    else
                        soft_output(i) <= not sub(i) + '1';
                    end if;
                end if;
            end loop;
            for i in 128 to 255 loop
                if (llr_0_final(i) = "01111111111") then
                    soft_output(i) <= const_llr_1_6;
                else
                    if (llr_1_final(i) = "01111111111") then
                        soft_output(i) <= not const_llr_1_6 + '1';
                    else
                        soft_output(i) <= not sub(i) + '1';
                    end if;
                end if;
            end loop;
        end if;
    end process;
end architecture;
