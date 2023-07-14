-- Calculating the weight of the sequence after flipping
-- Converting the input into positive before further processing, because if they are negative, only ignoring the sign bit doesn't work

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use ieee.math_real.all;
use work.arr_pkg_1.all;
use work.arr_pkg_2.all;
use work.arr_pkg_3.all;

entity weight_1 is
  generic (
    data_in_length : positive := 255; -- 256 bits
    data_length    : positive := 2    -- Because only up to 3 bits can be flipped from the flipping block                                   
  );
  port (
    clk                   : in std_logic;
    reset                 : in std_logic;
    soft_input            : in input_data_array(data_length downto 0); -- From flipping block
    soft_input_unflipped  : in input_data_array(data_in_length downto 0);
    index_in              : in index_array(7 downto 0); -- From flipping block
    soft_output_unflipped : out input_data_array(data_in_length downto 0);
    index_out             : out index_array(7 downto 0);
    output_weight         : out std_logic_vector(7 downto 0)
  );
end weight_1;
architecture rtl of weight_1 is
  --------------------------------------------------------------------------------------------
  -- CLK 1
  signal soft_input_1            : input_data_array(data_length downto 0);
  signal soft_output_unflipped_1 : input_data_array(data_in_length downto 0);
  signal index_in_1              : index_array(7 downto 0);
  --------------------------------------------------------------------------------------------
  -- CLK 2
  signal soft_input_2            : input_data_array(data_length downto 0);
  signal soft_output_unflipped_2 : input_data_array(data_in_length downto 0);
  signal index_in_2              : index_array(7 downto 0);
  --------------------------------------------------------------------------------------------
  -- CLK 3
  signal soft_input_3            : input_data_array(data_length downto 0);
  signal soft_output_unflipped_3 : input_data_array(data_in_length downto 0);
  signal index_in_3              : index_array(7 downto 0);
  --------------------------------------------------------------------------------------------
  -- CLK 4
  signal soft_input_4            : input_data_array(data_length downto 0);
  signal soft_output_unflipped_4 : input_data_array(data_in_length downto 0);
  signal sum_1                   : std_logic_vector(6 downto 0);
  signal index_in_4              : index_array(7 downto 0);
  --------------------------------------------------------------------------------------------
  -- CLK 5
  signal soft_input_5            : input_data_array(data_length downto 0);
  signal soft_output_unflipped_5 : input_data_array(data_in_length downto 0);
  signal sum_2                   : std_logic_vector(7 downto 0);
  signal index_in_5              : index_array(7 downto 0);
  --------------------------------------------------------------------------------------------
  -- CLK 6
  signal output_weight_1         : std_logic_vector(7 downto 0);
  signal soft_output_unflipped_6 : input_data_array(data_in_length downto 0);
  signal index_in_6              : index_array(7 downto 0);
  --------------------------------------------------------------------------------------------
  -- CLK 7
  signal output_weight_2         : std_logic_vector(7 downto 0);
  signal soft_output_unflipped_7 : input_data_array(data_in_length downto 0);
  signal index_in_7              : index_array(7 downto 0);
  --------------------------------------------------------------------------------------------
  -- CLK 8
  signal output_weight_3         : std_logic_vector(7 downto 0);
  signal soft_output_unflipped_8 : input_data_array(data_in_length downto 0);
  signal index_in_8              : index_array(7 downto 0);
  --------------------------------------------------------------------------------------------
  -- CLK 9
  signal output_weight_4         : std_logic_vector(7 downto 0);
  signal soft_output_unflipped_9 : input_data_array(data_in_length downto 0);
  signal index_in_9              : index_array(7 downto 0);
  --------------------------------------------------------------------------------------------
  -- CLK 10
  signal output_weight_5          : std_logic_vector(7 downto 0);
  signal soft_output_unflipped_10 : input_data_array(data_in_length downto 0);
  signal index_in_10              : index_array(7 downto 0);
  --------------------------------------------------------------------------------------------
  -- CLK 11
  signal output_weight_6          : std_logic_vector(7 downto 0);
  signal soft_output_unflipped_11 : input_data_array(data_in_length downto 0);
  signal index_in_11              : index_array(7 downto 0);
  --------------------------------------------------------------------------------------------
  -- CLK 12
  signal output_weight_7          : std_logic_vector(7 downto 0);
  signal soft_output_unflipped_12 : input_data_array(data_in_length downto 0);
  signal index_in_12              : index_array(7 downto 0);
  --------------------------------------------------------------------------------------------
  -- CLK 13
  signal output_weight_8          : std_logic_vector(7 downto 0);
  signal soft_output_unflipped_13 : input_data_array(data_in_length downto 0);
  signal index_in_13              : index_array(7 downto 0);
  --------------------------------------------------------------------------------------------
  -- CLK 14
  signal output_weight_9          : std_logic_vector(7 downto 0);
  signal soft_output_unflipped_14 : input_data_array(data_in_length downto 0);
  signal index_in_14              : index_array(7 downto 0);
  --------------------------------------------------------------------------------------------
  -- CLK 15
  signal output_weight_10         : std_logic_vector(7 downto 0);
  signal soft_output_unflipped_15 : input_data_array(data_in_length downto 0);
  signal index_in_15              : index_array(7 downto 0);
  --------------------------------------------------------------------------------------------
  -- CLK 16
  signal output_weight_11         : std_logic_vector(7 downto 0);
  signal soft_output_unflipped_16 : input_data_array(data_in_length downto 0);
  signal index_in_16              : index_array(7 downto 0);
  --------------------------------------------------------------------------------------------
  -- CLK 17
  signal output_weight_12         : std_logic_vector(7 downto 0);
  signal soft_output_unflipped_17 : input_data_array(data_in_length downto 0);
  signal index_in_17              : index_array(7 downto 0);
  --------------------------------------------------------------------------------------------
  -- CLK 18
  signal output_weight_13         : std_logic_vector(7 downto 0);
  signal soft_output_unflipped_18 : input_data_array(data_in_length downto 0);
  signal index_in_18              : index_array(7 downto 0);
  --------------------------------------------------------------------------------------------
  -- CLK 19
  signal output_weight_14         : std_logic_vector(7 downto 0);
  signal soft_output_unflipped_19 : input_data_array(data_in_length downto 0);
  signal index_in_19              : index_array(7 downto 0);
  --------------------------------------------------------------------------------------------
  -- CLK 20
  signal output_weight_15         : std_logic_vector(7 downto 0);
  signal soft_output_unflipped_20 : input_data_array(data_in_length downto 0);
  signal index_in_20              : index_array(7 downto 0);
  --------------------------------------------------------------------------------------------
  -- CLK 21
  signal output_weight_16         : std_logic_vector(7 downto 0);
  signal soft_output_unflipped_21 : input_data_array(data_in_length downto 0);
  signal index_in_21              : index_array(7 downto 0);
  --------------------------------------------------------------------------------------------
  -- CLK 22
  signal output_weight_17         : std_logic_vector(7 downto 0);
  signal soft_output_unflipped_22 : input_data_array(data_in_length downto 0);
  signal index_in_22              : index_array(7 downto 0);
  --------------------------------------------------------------------------------------------
  -- CLK 23
  signal output_weight_18         : std_logic_vector(7 downto 0);
  signal soft_output_unflipped_23 : input_data_array(data_in_length downto 0);
  signal index_in_23              : index_array(7 downto 0);
  --------------------------------------------------------------------------------------------
  -- CLK 24
  signal output_weight_19         : std_logic_vector(7 downto 0);
  signal soft_output_unflipped_24 : input_data_array(data_in_length downto 0);
  signal index_in_24              : index_array(7 downto 0);
  --------------------------------------------------------------------------------------------
  -- CLK 25
  signal output_weight_20         : std_logic_vector(7 downto 0);
  signal soft_output_unflipped_25 : input_data_array(data_in_length downto 0);
  signal index_in_25              : index_array(7 downto 0);
  --------------------------------------------------------------------------------------------
  -- CLK 26
  signal output_weight_21         : std_logic_vector(7 downto 0);
  signal soft_output_unflipped_26 : input_data_array(data_in_length downto 0);
  signal index_in_26              : index_array(7 downto 0);
  --------------------------------------------------------------------------------------------
  -- CLK 27
  signal output_weight_22         : std_logic_vector(7 downto 0);
  signal soft_output_unflipped_27 : input_data_array(data_in_length downto 0);
  signal index_in_27              : index_array(7 downto 0);
  --------------------------------------------------------------------------------------------
  -- CLK 28
  signal output_weight_23         : std_logic_vector(7 downto 0);
  signal soft_output_unflipped_28 : input_data_array(data_in_length downto 0);
  signal index_in_28              : index_array(7 downto 0);
  --------------------------------------------------------------------------------------------
  -- CLK 29
  signal output_weight_24         : std_logic_vector(7 downto 0);
  signal soft_output_unflipped_29 : input_data_array(data_in_length downto 0);
  signal index_in_29              : index_array(7 downto 0);
  --------------------------------------------------------------------------------------------
  -- CLK 30
  signal output_weight_25         : std_logic_vector(7 downto 0);
  signal soft_output_unflipped_30 : input_data_array(data_in_length downto 0);
  signal index_in_30              : index_array(7 downto 0);
  --------------------------------------------------------------------------------------------
  -- CLK 31
  signal output_weight_26         : std_logic_vector(7 downto 0);
  signal soft_output_unflipped_31 : input_data_array(data_in_length downto 0);
  signal index_in_31              : index_array(7 downto 0);
  --------------------------------------------------------------------------------------------
  -- CLK 32
  signal output_weight_27         : std_logic_vector(7 downto 0);
  signal soft_output_unflipped_32 : input_data_array(data_in_length downto 0);
  signal index_in_32              : index_array(7 downto 0);
  --------------------------------------------------------------------------------------------
  -- CLK 33
  signal output_weight_28         : std_logic_vector(7 downto 0);
  signal soft_output_unflipped_33 : input_data_array(data_in_length downto 0);
  signal index_in_33              : index_array(7 downto 0);
  --------------------------------------------------------------------------------------------
  -- CLK 34
  signal output_weight_29         : std_logic_vector(7 downto 0);
  signal soft_output_unflipped_34 : input_data_array(data_in_length downto 0);
  signal index_in_34              : index_array(7 downto 0);
  --------------------------------------------------------------------------------------------
  -- CLK 35
  signal output_weight_30         : std_logic_vector(7 downto 0);
  signal soft_output_unflipped_35 : input_data_array(data_in_length downto 0);
  signal index_in_35              : index_array(7 downto 0);
  --------------------------------------------------------------------------------------------
  -- CLK 36
  signal output_weight_31         : std_logic_vector(7 downto 0);
  signal soft_output_unflipped_36 : input_data_array(data_in_length downto 0);
  signal index_in_36              : index_array(7 downto 0);
  --------------------------------------------------------------------------------------------
  -- CLK 37
  signal output_weight_32         : std_logic_vector(7 downto 0);
  signal soft_output_unflipped_37 : input_data_array(data_in_length downto 0);
  signal index_in_37              : index_array(7 downto 0);
  --------------------------------------------------------------------------------------------
  -- CLK 38
  signal output_weight_33         : std_logic_vector(7 downto 0);
  signal soft_output_unflipped_38 : input_data_array(data_in_length downto 0);
  signal index_in_38              : index_array(7 downto 0);
  --------------------------------------------------------------------------------------------
  -- CLK 39
  signal output_weight_34         : std_logic_vector(7 downto 0);
  signal soft_output_unflipped_39 : input_data_array(data_in_length downto 0);
  signal index_in_39              : index_array(7 downto 0);
  --------------------------------------------------------------------------------------------
  -- CLK 40
  signal output_weight_35         : std_logic_vector(7 downto 0);
  signal soft_output_unflipped_40 : input_data_array(data_in_length downto 0);
  signal index_in_40              : index_array(7 downto 0);
  --------------------------------------------------------------------------------------------
  -- CLK 41
  signal output_weight_36         : std_logic_vector(7 downto 0);
  signal soft_output_unflipped_41 : input_data_array(data_in_length downto 0);
  signal index_in_41              : index_array(7 downto 0);
  --------------------------------------------------------------------------------------------
  -- CLK 42
  signal output_weight_37         : std_logic_vector(7 downto 0);
  signal soft_output_unflipped_42 : input_data_array(data_in_length downto 0);
  signal index_in_42              : index_array(7 downto 0);
  --------------------------------------------------------------------------------------------
  -- CLK 43
  signal output_weight_38         : std_logic_vector(7 downto 0);
  signal soft_output_unflipped_43 : input_data_array(data_in_length downto 0);
  signal index_in_43              : index_array(7 downto 0);
  --------------------------------------------------------------------------------------------
  -- CLK 44
  signal output_weight_39         : std_logic_vector(7 downto 0);
  signal soft_output_unflipped_44 : input_data_array(data_in_length downto 0);
  signal index_in_44              : index_array(7 downto 0);
  --------------------------------------------------------------------------------------------
  -- CLK 45
  signal output_weight_40         : std_logic_vector(7 downto 0);
  signal soft_output_unflipped_45 : input_data_array(data_in_length downto 0);
  signal index_in_45              : index_array(7 downto 0);
  --------------------------------------------------------------------------------------------
  -- CLK 46
  signal output_weight_41         : std_logic_vector(7 downto 0);
  signal soft_output_unflipped_46 : input_data_array(data_in_length downto 0);
  signal index_in_46              : index_array(7 downto 0);
  --------------------------------------------------------------------------------------------
  -- CLK 47
  signal output_weight_42         : std_logic_vector(7 downto 0);
  signal soft_output_unflipped_47 : input_data_array(data_in_length downto 0);
  signal index_in_47              : index_array(7 downto 0);
  --------------------------------------------------------------------------------------------
  -- CLK 48
  signal output_weight_43         : std_logic_vector(7 downto 0);
  signal soft_output_unflipped_48 : input_data_array(data_in_length downto 0);
  signal index_in_48              : index_array(7 downto 0);
  --------------------------------------------------------------------------------------------
  -- CLK 49
  signal output_weight_44         : std_logic_vector(7 downto 0);
  signal soft_output_unflipped_49 : input_data_array(data_in_length downto 0);
  signal index_in_49              : index_array(7 downto 0);
  --------------------------------------------------------------------------------------------
  -- CLK 50
  signal output_weight_45         : std_logic_vector(7 downto 0);
  signal soft_output_unflipped_50 : input_data_array(data_in_length downto 0);
  signal index_in_50              : index_array(7 downto 0);
  --------------------------------------------------------------------------------------------
  -- CLK 51
  signal output_weight_46         : std_logic_vector(7 downto 0);
  signal soft_output_unflipped_51 : input_data_array(data_in_length downto 0);
  signal index_in_51              : index_array(7 downto 0);
  --------------------------------------------------------------------------------------------
  -- CLK 52
  signal output_weight_47         : std_logic_vector(7 downto 0);
  signal soft_output_unflipped_52 : input_data_array(data_in_length downto 0);
  signal index_in_52              : index_array(7 downto 0);
  --------------------------------------------------------------------------------------------
  -- CLK 53
  signal output_weight_48         : std_logic_vector(7 downto 0);
  signal soft_output_unflipped_53 : input_data_array(data_in_length downto 0);
  signal index_in_53              : index_array(7 downto 0);
  --------------------------------------------------------------------------------------------
  -- CLK 54
  signal output_weight_49         : std_logic_vector(7 downto 0);
  signal soft_output_unflipped_54 : input_data_array(data_in_length downto 0);
  signal index_in_54              : index_array(7 downto 0);
  --------------------------------------------------------------------------------------------
  -- CLK 55
  signal output_weight_50         : std_logic_vector(7 downto 0);
  signal soft_output_unflipped_55 : input_data_array(data_in_length downto 0);
  signal index_in_55              : index_array(7 downto 0);
  --------------------------------------------------------------------------------------------
  -- CLK 56
  signal output_weight_51         : std_logic_vector(7 downto 0);
  signal soft_output_unflipped_56 : input_data_array(data_in_length downto 0);
  signal index_in_56              : index_array(7 downto 0);
  --------------------------------------------------------------------------------------------
  -- CLK 57
  signal output_weight_52         : std_logic_vector(7 downto 0);
  signal soft_output_unflipped_57 : input_data_array(data_in_length downto 0);
  signal index_in_57              : index_array(7 downto 0);
  --------------------------------------------------------------------------------------------
  -- CLK 58
  signal output_weight_53         : std_logic_vector(7 downto 0);
  signal soft_output_unflipped_58 : input_data_array(data_in_length downto 0);
  signal index_in_58              : index_array(7 downto 0);
  --------------------------------------------------------------------------------------------
  -- CLK 59
  signal output_weight_54         : std_logic_vector(7 downto 0);
  signal soft_output_unflipped_59 : input_data_array(data_in_length downto 0);
  signal index_in_59              : index_array(7 downto 0);
  --------------------------------------------------------------------------------------------
  -- CLK 60
  signal output_weight_55         : std_logic_vector(7 downto 0);
  signal soft_output_unflipped_60 : input_data_array(data_in_length downto 0);
  signal index_in_60              : index_array(7 downto 0);
  --------------------------------------------------------------------------------------------
  -- CLK 61
  signal output_weight_56         : std_logic_vector(7 downto 0);
  signal soft_output_unflipped_61 : input_data_array(data_in_length downto 0);
  signal index_in_61              : index_array(7 downto 0);
  --------------------------------------------------------------------------------------------
  -- CLK 62
  signal output_weight_57         : std_logic_vector(7 downto 0);
  signal soft_output_unflipped_62 : input_data_array(data_in_length downto 0);
  signal index_in_62              : index_array(7 downto 0);
  --------------------------------------------------------------------------------------------
  -- CLK 63
  signal output_weight_58         : std_logic_vector(7 downto 0);
  signal soft_output_unflipped_63 : input_data_array(data_in_length downto 0);
  signal index_in_63              : index_array(7 downto 0);
  --------------------------------------------------------------------------------------------
  -- CLK 64
  signal output_weight_59         : std_logic_vector(7 downto 0);
  signal soft_output_unflipped_64 : input_data_array(data_in_length downto 0);
  signal index_in_64              : index_array(7 downto 0);
  --------------------------------------------------------------------------------------------
  -- CLK 65
  signal output_weight_60         : std_logic_vector(7 downto 0);
  signal soft_output_unflipped_65 : input_data_array(data_in_length downto 0);
  signal index_in_65              : index_array(7 downto 0);
  --------------------------------------------------------------------------------------------
  -- CLK 66
  signal output_weight_61         : std_logic_vector(7 downto 0);
  signal soft_output_unflipped_66 : input_data_array(data_in_length downto 0);
  signal index_in_66              : index_array(7 downto 0);
  --------------------------------------------------------------------------------------------
  -- CLK 67
  signal output_weight_62         : std_logic_vector(7 downto 0);
  signal soft_output_unflipped_67 : input_data_array(data_in_length downto 0);
  signal index_in_67              : index_array(7 downto 0);
  --------------------------------------------------------------------------------------------
  -- CLK 68
  signal output_weight_63         : std_logic_vector(7 downto 0);
  signal soft_output_unflipped_68 : input_data_array(data_in_length downto 0);
  signal index_in_68              : index_array(7 downto 0);
  --------------------------------------------------------------------------------------------
  -- CLK 69
  signal output_weight_64         : std_logic_vector(7 downto 0);
  signal soft_output_unflipped_69 : input_data_array(data_in_length downto 0);
  signal index_in_69              : index_array(7 downto 0);
  --------------------------------------------------------------------------------------------
  -- CLK 70
  signal output_weight_65         : std_logic_vector(7 downto 0);
  signal soft_output_unflipped_70 : input_data_array(data_in_length downto 0);
  signal index_in_70              : index_array(7 downto 0);
  --------------------------------------------------------------------------------------------
  -- CLK 71
  signal output_weight_66         : std_logic_vector(7 downto 0);
  signal soft_output_unflipped_71 : input_data_array(data_in_length downto 0);
  signal index_in_71              : index_array(7 downto 0);
  --------------------------------------------------------------------------------------------
  -- CLK 72
  signal output_weight_67         : std_logic_vector(7 downto 0);
  signal soft_output_unflipped_72 : input_data_array(data_in_length downto 0);
  signal index_in_72              : index_array(7 downto 0);
  --------------------------------------------------------------------------------------------
  -- CLK 73
  signal output_weight_68         : std_logic_vector(7 downto 0);
  signal soft_output_unflipped_73 : input_data_array(data_in_length downto 0);
  signal index_in_73              : index_array(7 downto 0);
  --------------------------------------------------------------------------------------------
  -- CLK 74
  signal output_weight_69         : std_logic_vector(7 downto 0);
  signal soft_output_unflipped_74 : input_data_array(data_in_length downto 0);
  signal index_in_74              : index_array(7 downto 0);
  --------------------------------------------------------------------------------------------
  -- CLK 75
  signal output_weight_70         : std_logic_vector(7 downto 0);
  signal soft_output_unflipped_75 : input_data_array(data_in_length downto 0);
  signal index_in_75              : index_array(7 downto 0);
  --------------------------------------------------------------------------------------------
  -- CLK 76
  signal output_weight_71         : std_logic_vector(7 downto 0);
  signal soft_output_unflipped_76 : input_data_array(data_in_length downto 0);
  signal index_in_76              : index_array(7 downto 0);
  --------------------------------------------------------------------------------------------
  -- CLK 77
  signal output_weight_72         : std_logic_vector(7 downto 0);
  signal soft_output_unflipped_77 : input_data_array(data_in_length downto 0);
  signal index_in_77              : index_array(7 downto 0);
  --------------------------------------------------------------------------------------------
  -- CLK 78
  signal output_weight_73         : std_logic_vector(7 downto 0);
  signal soft_output_unflipped_78 : input_data_array(data_in_length downto 0);
  signal index_in_78              : index_array(7 downto 0);
  --------------------------------------------------------------------------------------------
  -- CLK 79
  signal output_weight_74         : std_logic_vector(7 downto 0);
  signal soft_output_unflipped_79 : input_data_array(data_in_length downto 0);
  signal index_in_79              : index_array(7 downto 0);
  --------------------------------------------------------------------------------------------
  -- CLK 80
  signal output_weight_75         : std_logic_vector(7 downto 0);
  signal soft_output_unflipped_80 : input_data_array(data_in_length downto 0);
  signal index_in_80              : index_array(7 downto 0);
  --------------------------------------------------------------------------------------------
  -- CLK 81
  signal output_weight_76         : std_logic_vector(7 downto 0);
  signal soft_output_unflipped_81 : input_data_array(data_in_length downto 0);
  signal index_in_81              : index_array(7 downto 0);
  --------------------------------------------------------------------------------------------
  -- CLK 82
  signal output_weight_77         : std_logic_vector(7 downto 0);
  signal soft_output_unflipped_82 : input_data_array(data_in_length downto 0);
  signal index_in_82              : index_array(7 downto 0);
  --------------------------------------------------------------------------------------------
  -- CLK 83
  signal output_weight_78         : std_logic_vector(7 downto 0);
  signal soft_output_unflipped_83 : input_data_array(data_in_length downto 0);
  signal index_in_83              : index_array(7 downto 0);
  --------------------------------------------------------------------------------------------
  -- CLK 84
  signal output_weight_79         : std_logic_vector(7 downto 0);
  signal soft_output_unflipped_84 : input_data_array(data_in_length downto 0);
  signal index_in_84              : index_array(7 downto 0);
  --------------------------------------------------------------------------------------------
  -- CLK 85
  --signal output_weight_80         : std_logic_vector(7 downto 0);
  --signal soft_output_unflipped_85 : input_data_array(data_in_length downto 0);
  --signal index_in_85              : index_array(7 downto 0);
  --------------------------------------------------------------------------------------------
begin
  ------------------------------------------------------------------------------------------------------------
  -- Define processes : (CLK 1)
  ------------------------------------------------------------------------------------------------------------
  process (clk, reset)
  begin
    if (reset = '1') then
      soft_input_1            <= (others => (others => '0'));
      soft_output_unflipped_1 <= (others => (others => '0'));
      index_in_1              <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
      index_in_1              <= index_in;
      soft_output_unflipped_1 <= soft_input_unflipped;
      soft_input_1(2)         <= soft_input(2);
      soft_input_1(1)         <= soft_input(1);
      if soft_input(0)(5) = '0' then -- sign position
        soft_input_1(0) <= soft_input(0);
      else
        soft_input_1(0) <= not soft_input(0) + '1';
      end if;
    end if;
  end process;
  ------------------------------------------------------------------------------------------------------------
  -- Define processes : (CLK 2)
  ------------------------------------------------------------------------------------------------------------
  process (clk, reset)
  begin
    if (reset = '1') then
      soft_input_2            <= (others => (others => '0'));
      soft_output_unflipped_2 <= (others => (others => '0'));
      index_in_2              <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
      index_in_2              <= index_in_1;
      soft_output_unflipped_2 <= soft_output_unflipped_1;
      soft_input_2(2)         <= soft_input_1(2);
      soft_input_2(0)         <= soft_input_1(0);
      if soft_input_1(1)(5) = '0' then -- sign position
        soft_input_2(1) <= soft_input_1(1);
      else
        soft_input_2(1) <= not soft_input_1(1) + '1';
      end if;
    end if;
  end process;
  ------------------------------------------------------------------------------------------------------------
  -- Define processes : (CLK 3)
  ------------------------------------------------------------------------------------------------------------
  process (clk, reset)
  begin
    if (reset = '1') then
      soft_input_3            <= (others => (others => '0'));
      soft_output_unflipped_3 <= (others => (others => '0'));
      index_in_3              <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
      index_in_3              <= index_in_2;
      soft_output_unflipped_3 <= soft_output_unflipped_2;
      soft_input_3(1)         <= soft_input_2(1);
      soft_input_3(0)         <= soft_input_2(0);
      if soft_input_2(2)(5) = '0' then -- sign position
        soft_input_3(2) <= soft_input_2(2);
      else
        soft_input_3(2) <= not soft_input_2(2) + '1';
      end if;
    end if;
  end process;
  ------------------------------------------------------------------------------------------------------------
  -- Define processes : (CLK 4)
  ------------------------------------------------------------------------------------------------------------
  process (clk, reset)
  begin
    if (reset = '1') then
      soft_input_4            <= (others => (others => '0'));
      sum_1                   <= (others => '0');
      soft_output_unflipped_4 <= (others => (others => '0'));
      index_in_4              <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
      index_in_4              <= index_in_3;
      soft_output_unflipped_4 <= soft_output_unflipped_3;
      soft_input_4            <= soft_input_3;
      sum_1                   <= (soft_input_3(0)(5) & soft_input_3(0)) + (soft_input_3(1)(5) & soft_input_3(1)); -- Add up two input data
    end if;
  end process;
  ------------------------------------------------------------------------------------------------------------
  -- Define processes : (CLK 5)
  ------------------------------------------------------------------------------------------------------------
  process (clk, reset)
  begin
    if (reset = '1') then
      soft_output_unflipped_5 <= (others => (others => '0'));
      sum_2                   <= (others => '0');
      index_in_5              <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
      index_in_5              <= index_in_4;
      soft_output_unflipped_5 <= soft_output_unflipped_4;
      sum_2                   <= (sum_1(6) & sum_1) + (soft_input_4(2)(5) & soft_input_4(2)(5) & soft_input_4(2));
    end if;
  end process;
  ------------------------------------------------------------------------------------------------------------
  -- Define processes : (CLK 6)
  ------------------------------------------------------------------------------------------------------------
  process (clk, reset)
  begin
    if (reset = '1') then
      soft_output_unflipped_6 <= (others => (others => '0'));
      output_weight_1         <= (others => '0');
      index_in_6              <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
      soft_output_unflipped_6 <= soft_output_unflipped_5;
      output_weight_1         <= sum_2;
      index_in_6              <= index_in_5;
    end if;
  end process;
  ------------------------------------------------------------------------------------------------------------
  -- Define processes : (CLK 7)
  ------------------------------------------------------------------------------------------------------------
  process (clk, reset)
  begin
    if (reset = '1') then
      soft_output_unflipped_7 <= (others => (others => '0'));
      output_weight_2         <= (others => '0');
      index_in_7              <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
      soft_output_unflipped_7 <= soft_output_unflipped_6;
      output_weight_2         <= output_weight_1;
      index_in_7              <= index_in_6;
    end if;
  end process;
  --------------------------------------------------------------------------------------------------------------
  ---- Define processes : (CLK 8)
  --------------------------------------------------------------------------------------------------------------
  process (clk, reset)
  begin
    if (reset = '1') then
      soft_output_unflipped_8 <= (others => (others => '0'));
      output_weight_3         <= (others => '0');
      index_in_8              <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
      soft_output_unflipped_8 <= soft_output_unflipped_7;
      output_weight_3         <= output_weight_2;
      index_in_8              <= index_in_7;
    end if;
  end process;
  --------------------------------------------------------------------------------------------------------------
  ---- Define processes : (CLK 9)
  --------------------------------------------------------------------------------------------------------------
  process (clk, reset)
  begin
    if (reset = '1') then
      soft_output_unflipped_9 <= (others => (others => '0'));
      output_weight_4         <= (others => '0');
      index_in_9              <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
      soft_output_unflipped_9 <= soft_output_unflipped_8;
      output_weight_4         <= output_weight_3;
      index_in_9              <= index_in_8;
    end if;
  end process;
  --------------------------------------------------------------------------------------------------------------
  ---- Define processes : (CLK 10)
  --------------------------------------------------------------------------------------------------------------
  process (clk, reset)
  begin
    if (reset = '1') then
      soft_output_unflipped_10 <= (others => (others => '0'));
      output_weight_5          <= (others => '0');
      index_in_10              <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
      soft_output_unflipped_10 <= soft_output_unflipped_9;
      output_weight_5          <= output_weight_4;
      index_in_10              <= index_in_9;
    end if;
  end process;
  --------------------------------------------------------------------------------------------------------------
  ---- Define processes : (CLK 11)
  --------------------------------------------------------------------------------------------------------------
  process (clk, reset)
  begin
    if (reset = '1') then
      soft_output_unflipped_11 <= (others => (others => '0'));
      output_weight_6          <= (others => '0');
      index_in_11              <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
      soft_output_unflipped_11 <= soft_output_unflipped_10;
      output_weight_6          <= output_weight_5;
      index_in_11              <= index_in_10;
    end if;
  end process;
  --------------------------------------------------------------------------------------------------------------
  ---- Define processes : (CLK 12)
  --------------------------------------------------------------------------------------------------------------
  process (clk, reset)
  begin
    if (reset = '1') then
      soft_output_unflipped_12 <= (others => (others => '0'));
      output_weight_7          <= (others => '0');
      index_in_12              <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
      soft_output_unflipped_12 <= soft_output_unflipped_11;
      output_weight_7          <= output_weight_6;
      index_in_12              <= index_in_11;
    end if;
  end process;
  --------------------------------------------------------------------------------------------------------------
  ---- Define processes : (CLK 13)
  --------------------------------------------------------------------------------------------------------------
  process (clk, reset)
  begin
    if (reset = '1') then
      soft_output_unflipped_13 <= (others => (others => '0'));
      output_weight_8          <= (others => '0');
      index_in_13              <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
      soft_output_unflipped_13 <= soft_output_unflipped_12;
      output_weight_8          <= output_weight_7;
      index_in_13              <= index_in_12;
    end if;
  end process;
  --------------------------------------------------------------------------------------------------------------
  ---- Define processes : (CLK 14)
  --------------------------------------------------------------------------------------------------------------
  process (clk, reset)
  begin
    if (reset = '1') then
      soft_output_unflipped_14 <= (others => (others => '0'));
      output_weight_9          <= (others => '0');
      index_in_14              <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
      soft_output_unflipped_14 <= soft_output_unflipped_13;
      output_weight_9          <= output_weight_8;
      index_in_14              <= index_in_13;
    end if;
  end process;
  --------------------------------------------------------------------------------------------------------------
  ---- Define processes : (CLK 15)
  --------------------------------------------------------------------------------------------------------------
  process (clk, reset)
  begin
    if (reset = '1') then
      soft_output_unflipped_15 <= (others => (others => '0'));
      output_weight_10         <= (others => '0');
      index_in_15              <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
      soft_output_unflipped_15 <= soft_output_unflipped_14;
      output_weight_10         <= output_weight_9;
      index_in_15              <= index_in_14;
    end if;
  end process;
  --------------------------------------------------------------------------------------------------------------
  ---- Define processes : (CLK 16)
  --------------------------------------------------------------------------------------------------------------
  process (clk, reset)
  begin
    if (reset = '1') then
      soft_output_unflipped_16 <= (others => (others => '0'));
      output_weight_11         <= (others => '0');
      index_in_16              <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
      soft_output_unflipped_16 <= soft_output_unflipped_15;
      output_weight_11         <= output_weight_10;
      index_in_16              <= index_in_15;
    end if;
  end process;
  --------------------------------------------------------------------------------------------------------------
  ---- Define processes : (CLK 17)
  --------------------------------------------------------------------------------------------------------------
  process (clk, reset)
  begin
    if (reset = '1') then
      soft_output_unflipped_17 <= (others => (others => '0'));
      output_weight_12         <= (others => '0');
      index_in_17              <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
      soft_output_unflipped_17 <= soft_output_unflipped_16;
      output_weight_12         <= output_weight_11;
      index_in_17              <= index_in_16;
    end if;
  end process;
  --------------------------------------------------------------------------------------------------------------
  ---- Define processes : (CLK 18)
  --------------------------------------------------------------------------------------------------------------
  process (clk, reset)
  begin
    if (reset = '1') then
      soft_output_unflipped_18 <= (others => (others => '0'));
      output_weight_13         <= (others => '0');
      index_in_18              <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
      soft_output_unflipped_18 <= soft_output_unflipped_17;
      output_weight_13         <= output_weight_12;
      index_in_18              <= index_in_17;
    end if;
  end process;
  --------------------------------------------------------------------------------------------------------------
  ---- Define processes : (CLK 19)
  --------------------------------------------------------------------------------------------------------------
  process (clk, reset)
  begin
    if (reset = '1') then
      soft_output_unflipped_19 <= (others => (others => '0'));
      output_weight_14         <= (others => '0');
      index_in_19              <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
      soft_output_unflipped_19 <= soft_output_unflipped_18;
      output_weight_14         <= output_weight_13;
      index_in_19              <= index_in_18;
    end if;
  end process;
  --------------------------------------------------------------------------------------------------------------
  ---- Define processes : (CLK 20)
  --------------------------------------------------------------------------------------------------------------
  process (clk, reset)
  begin
    if (reset = '1') then
      soft_output_unflipped_20 <= (others => (others => '0'));
      output_weight_15         <= (others => '0');
      index_in_20              <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
      soft_output_unflipped_20 <= soft_output_unflipped_19;
      output_weight_15         <= output_weight_14;
      index_in_20              <= index_in_19;
    end if;
  end process;
  --------------------------------------------------------------------------------------------------------------
  ---- Define processes : (CLK 21)
  --------------------------------------------------------------------------------------------------------------
  process (clk, reset)
  begin
    if (reset = '1') then
      soft_output_unflipped_21 <= (others => (others => '0'));
      output_weight_16         <= (others => '0');
      index_in_21              <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
      soft_output_unflipped_21 <= soft_output_unflipped_20;
      output_weight_16         <= output_weight_15;
      index_in_21              <= index_in_20;
    end if;
  end process;
  --------------------------------------------------------------------------------------------------------------
  ---- Define processes : (CLK 22)
  --------------------------------------------------------------------------------------------------------------
  process (clk, reset)
  begin
    if (reset = '1') then
      soft_output_unflipped_22 <= (others => (others => '0'));
      output_weight_17         <= (others => '0');
      index_in_22              <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
      soft_output_unflipped_22 <= soft_output_unflipped_21;
      output_weight_17         <= output_weight_16;
      index_in_22              <= index_in_21;
    end if;
  end process;
  --------------------------------------------------------------------------------------------------------------
  ---- Define processes : (CLK 23)
  --------------------------------------------------------------------------------------------------------------
  process (clk, reset)
  begin
    if (reset = '1') then
      soft_output_unflipped_23 <= (others => (others => '0'));
      output_weight_18         <= (others => '0');
      index_in_23              <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
      soft_output_unflipped_23 <= soft_output_unflipped_22;
      output_weight_18         <= output_weight_17;
      index_in_23              <= index_in_22;
    end if;
  end process;
  --------------------------------------------------------------------------------------------------------------
  ---- Define processes : (CLK 24)
  --------------------------------------------------------------------------------------------------------------
  process (clk, reset)
  begin
    if (reset = '1') then
      soft_output_unflipped_24 <= (others => (others => '0'));
      output_weight_19         <= (others => '0');
      index_in_24              <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
      soft_output_unflipped_24 <= soft_output_unflipped_23;
      output_weight_19         <= output_weight_18;
      index_in_24              <= index_in_23;
    end if;
  end process;
  --------------------------------------------------------------------------------------------------------------
  ---- Define processes : (CLK 25)
  --------------------------------------------------------------------------------------------------------------
  process (clk, reset)
  begin
    if (reset = '1') then
      soft_output_unflipped_25 <= (others => (others => '0'));
      output_weight_20         <= (others => '0');
      index_in_25              <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
      soft_output_unflipped_25 <= soft_output_unflipped_24;
      output_weight_20         <= output_weight_19;
      index_in_25              <= index_in_24;
    end if;
  end process;
  --------------------------------------------------------------------------------------------------------------
  ---- Define processes : (CLK 26)
  --------------------------------------------------------------------------------------------------------------
  process (clk, reset)
  begin
    if (reset = '1') then
      soft_output_unflipped_26 <= (others => (others => '0'));
      output_weight_21         <= (others => '0');
      index_in_26              <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
      soft_output_unflipped_26 <= soft_output_unflipped_25;
      output_weight_21         <= output_weight_20;
      index_in_26              <= index_in_25;
    end if;
  end process;
  --------------------------------------------------------------------------------------------------------------
  ---- Define processes : (CLK 27)
  --------------------------------------------------------------------------------------------------------------
  process (clk, reset)
  begin
    if (reset = '1') then
      soft_output_unflipped_27 <= (others => (others => '0'));
      output_weight_22         <= (others => '0');
      index_in_27              <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
      soft_output_unflipped_27 <= soft_output_unflipped_26;
      output_weight_22         <= output_weight_21;
      index_in_27              <= index_in_26;
    end if;
  end process;
  --------------------------------------------------------------------------------------------------------------
  ---- Define processes : (CLK 28)
  --------------------------------------------------------------------------------------------------------------
  process (clk, reset)
  begin
    if (reset = '1') then
      soft_output_unflipped_28 <= (others => (others => '0'));
      output_weight_23         <= (others => '0');
      index_in_28              <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
      soft_output_unflipped_28 <= soft_output_unflipped_27;
      output_weight_23         <= output_weight_22;
      index_in_28              <= index_in_27;
    end if;
  end process;
  --------------------------------------------------------------------------------------------------------------
  ---- Define processes : (CLK 29)
  --------------------------------------------------------------------------------------------------------------
  process (clk, reset)
  begin
    if (reset = '1') then
      soft_output_unflipped_29 <= (others => (others => '0'));
      output_weight_24         <= (others => '0');
      index_in_29              <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
      soft_output_unflipped_29 <= soft_output_unflipped_28;
      output_weight_24         <= output_weight_23;
      index_in_29              <= index_in_28;
    end if;
  end process;
  --------------------------------------------------------------------------------------------------------------
  ---- Define processes : (CLK 30)
  --------------------------------------------------------------------------------------------------------------
  process (clk, reset)
  begin
    if (reset = '1') then
      soft_output_unflipped_30 <= (others => (others => '0'));
      output_weight_25         <= (others => '0');
      index_in_30              <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
      soft_output_unflipped_30 <= soft_output_unflipped_29;
      output_weight_25         <= output_weight_24;
      index_in_30              <= index_in_29;
    end if;
  end process;
  --------------------------------------------------------------------------------------------------------------
  ---- Define processes : (CLK 31)
  --------------------------------------------------------------------------------------------------------------
  process (clk, reset)
  begin
    if (reset = '1') then
      soft_output_unflipped_31 <= (others => (others => '0'));
      output_weight_26         <= (others => '0');
      index_in_31              <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
      soft_output_unflipped_31 <= soft_output_unflipped_30;
      output_weight_26         <= output_weight_25;
      index_in_31              <= index_in_30;
    end if;
  end process;
  --------------------------------------------------------------------------------------------------------------
  ---- Define processes : (CLK 32)
  --------------------------------------------------------------------------------------------------------------
  process (clk, reset)
  begin
    if (reset = '1') then
      soft_output_unflipped_32 <= (others => (others => '0'));
      output_weight_27         <= (others => '0');
      index_in_32              <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
      soft_output_unflipped_32 <= soft_output_unflipped_31;
      output_weight_27         <= output_weight_26;
      index_in_32              <= index_in_31;
    end if;
  end process;
  --------------------------------------------------------------------------------------------------------------
  ---- Define processes : (CLK 33)
  --------------------------------------------------------------------------------------------------------------
  process (clk, reset)
  begin
    if (reset = '1') then
      soft_output_unflipped_33 <= (others => (others => '0'));
      output_weight_28         <= (others => '0');
      index_in_33              <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
      soft_output_unflipped_33 <= soft_output_unflipped_32;
      output_weight_28         <= output_weight_27;
      index_in_33              <= index_in_32;
    end if;
  end process;
  --------------------------------------------------------------------------------------------------------------
  ---- Define processes : (CLK 34)
  --------------------------------------------------------------------------------------------------------------
  process (clk, reset)
  begin
    if (reset = '1') then
      soft_output_unflipped_34 <= (others => (others => '0'));
      output_weight_29         <= (others => '0');
      index_in_34              <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
      soft_output_unflipped_34 <= soft_output_unflipped_33;
      output_weight_29         <= output_weight_28;
      index_in_34              <= index_in_33;
    end if;
  end process;
  --------------------------------------------------------------------------------------------------------------
  ---- Define processes : (CLK 35)
  --------------------------------------------------------------------------------------------------------------
  process (clk, reset)
  begin
    if (reset = '1') then
      soft_output_unflipped_35 <= (others => (others => '0'));
      output_weight_30         <= (others => '0');
      index_in_35              <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
      soft_output_unflipped_35 <= soft_output_unflipped_34;
      output_weight_30         <= output_weight_29;
      index_in_35              <= index_in_34;
    end if;
  end process;
  --------------------------------------------------------------------------------------------------------------
  ---- Define processes : (CLK 36)
  --------------------------------------------------------------------------------------------------------------
  process (clk, reset)
  begin
    if (reset = '1') then
      soft_output_unflipped_36 <= (others => (others => '0'));
      output_weight_31         <= (others => '0');
      index_in_36              <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
      soft_output_unflipped_36 <= soft_output_unflipped_35;
      output_weight_31         <= output_weight_30;
      index_in_36              <= index_in_35;
    end if;
  end process;
  --------------------------------------------------------------------------------------------------------------
  ---- Define processes : (CLK 37)
  --------------------------------------------------------------------------------------------------------------
  process (clk, reset)
  begin
    if (reset = '1') then
      soft_output_unflipped_37 <= (others => (others => '0'));
      output_weight_32         <= (others => '0');
      index_in_37              <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
      soft_output_unflipped_37 <= soft_output_unflipped_36;
      output_weight_32         <= output_weight_31;
      index_in_37              <= index_in_36;
    end if;
  end process;
  --------------------------------------------------------------------------------------------------------------
  ---- Define processes : (CLK 38)
  --------------------------------------------------------------------------------------------------------------
  process (clk, reset)
  begin
    if (reset = '1') then
      soft_output_unflipped_38 <= (others => (others => '0'));
      output_weight_33         <= (others => '0');
      index_in_38              <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
      soft_output_unflipped_38 <= soft_output_unflipped_37;
      output_weight_33         <= output_weight_32;
      index_in_38              <= index_in_37;
    end if;
  end process;
  --------------------------------------------------------------------------------------------------------------
  ---- Define processes : (CLK 39)
  --------------------------------------------------------------------------------------------------------------
  process (clk, reset)
  begin
    if (reset = '1') then
      soft_output_unflipped_39 <= (others => (others => '0'));
      output_weight_34         <= (others => '0');
      index_in_39              <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
      soft_output_unflipped_39 <= soft_output_unflipped_38;
      output_weight_34         <= output_weight_33;
      index_in_39              <= index_in_38;
    end if;
  end process;
  --------------------------------------------------------------------------------------------------------------
  ---- Define processes : (CLK 40)
  --------------------------------------------------------------------------------------------------------------
  process (clk, reset)
  begin
    if (reset = '1') then
      soft_output_unflipped_40 <= (others => (others => '0'));
      output_weight_35         <= (others => '0');
      index_in_40              <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
      soft_output_unflipped_40 <= soft_output_unflipped_39;
      output_weight_35         <= output_weight_34;
      index_in_40              <= index_in_39;
    end if;
  end process;
  --------------------------------------------------------------------------------------------------------------
  ---- Define processes : (CLK 41)
  --------------------------------------------------------------------------------------------------------------
  process (clk, reset)
  begin
    if (reset = '1') then
      soft_output_unflipped_41 <= (others => (others => '0'));
      output_weight_36         <= (others => '0');
      index_in_41              <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
      soft_output_unflipped_41 <= soft_output_unflipped_40;
      output_weight_36         <= output_weight_35;
      index_in_41              <= index_in_40;
    end if;
  end process;
  --------------------------------------------------------------------------------------------------------------
  ---- Define processes : (CLK 42)
  --------------------------------------------------------------------------------------------------------------
  process (clk, reset)
  begin
    if (reset = '1') then
      soft_output_unflipped_42 <= (others => (others => '0'));
      output_weight_37         <= (others => '0');
      index_in_42              <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
      soft_output_unflipped_42 <= soft_output_unflipped_41;
      output_weight_37         <= output_weight_36;
      index_in_42              <= index_in_41;
    end if;
  end process;
  --------------------------------------------------------------------------------------------------------------
  ---- Define processes : (CLK 43)
  --------------------------------------------------------------------------------------------------------------
  process (clk, reset)
  begin
    if (reset = '1') then
      soft_output_unflipped_43 <= (others => (others => '0'));
      output_weight_38         <= (others => '0');
      index_in_43              <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
      soft_output_unflipped_43 <= soft_output_unflipped_42;
      output_weight_38         <= output_weight_37;
      index_in_43              <= index_in_42;
    end if;
  end process;
  --------------------------------------------------------------------------------------------------------------
  ---- Define processes : (CLK 44)
  --------------------------------------------------------------------------------------------------------------
  process (clk, reset)
  begin
    if (reset = '1') then
      soft_output_unflipped_44 <= (others => (others => '0'));
      output_weight_39         <= (others => '0');
      index_in_44              <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
      soft_output_unflipped_44 <= soft_output_unflipped_43;
      output_weight_39         <= output_weight_38;
      index_in_44              <= index_in_43;
    end if;
  end process;
  --------------------------------------------------------------------------------------------------------------
  ---- Define processes : (CLK 45)
  --------------------------------------------------------------------------------------------------------------
  process (clk, reset)
  begin
    if (reset = '1') then
      soft_output_unflipped_45 <= (others => (others => '0'));
      output_weight_40         <= (others => '0');
      index_in_45              <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
      soft_output_unflipped_45 <= soft_output_unflipped_44;
      output_weight_40         <= output_weight_39;
      index_in_45              <= index_in_44;
    end if;
  end process;
  --------------------------------------------------------------------------------------------------------------
  ---- Define processes : (CLK 46)
  --------------------------------------------------------------------------------------------------------------
  process (clk, reset)
  begin
    if (reset = '1') then
      soft_output_unflipped_46 <= (others => (others => '0'));
      output_weight_41         <= (others => '0');
      index_in_46              <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
      soft_output_unflipped_46 <= soft_output_unflipped_45;
      output_weight_41         <= output_weight_40;
      index_in_46              <= index_in_45;
    end if;
  end process;
  --------------------------------------------------------------------------------------------------------------
  ---- Define processes : (CLK 47)
  --------------------------------------------------------------------------------------------------------------
  process (clk, reset)
  begin
    if (reset = '1') then
      soft_output_unflipped_47 <= (others => (others => '0'));
      output_weight_42         <= (others => '0');
      index_in_47              <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
      soft_output_unflipped_47 <= soft_output_unflipped_46;
      output_weight_42         <= output_weight_41;
      index_in_47              <= index_in_46;
    end if;
  end process;
  --------------------------------------------------------------------------------------------------------------
  ---- Define processes : (CLK 48)
  --------------------------------------------------------------------------------------------------------------
  process (clk, reset)
  begin
    if (reset = '1') then
      soft_output_unflipped_48 <= (others => (others => '0'));
      output_weight_43         <= (others => '0');
      index_in_48              <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
      soft_output_unflipped_48 <= soft_output_unflipped_47;
      output_weight_43         <= output_weight_42;
      index_in_48              <= index_in_47;
    end if;
  end process;
  --------------------------------------------------------------------------------------------------------------
  ---- Define processes : (CLK 49)
  --------------------------------------------------------------------------------------------------------------
  process (clk, reset)
  begin
    if (reset = '1') then
      soft_output_unflipped_49 <= (others => (others => '0'));
      output_weight_44         <= (others => '0');
      index_in_49              <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
      soft_output_unflipped_49 <= soft_output_unflipped_48;
      output_weight_44         <= output_weight_43;
      index_in_49              <= index_in_48;
    end if;
  end process;
  --------------------------------------------------------------------------------------------------------------
  ---- Define processes : (CLK 50)
  --------------------------------------------------------------------------------------------------------------
  process (clk, reset)
  begin
    if (reset = '1') then
      soft_output_unflipped_50 <= (others => (others => '0'));
      output_weight_45         <= (others => '0');
      index_in_50              <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
      soft_output_unflipped_50 <= soft_output_unflipped_49;
      output_weight_45         <= output_weight_44;
      index_in_50              <= index_in_49;
    end if;
  end process;
  --------------------------------------------------------------------------------------------------------------
  ---- Define processes : (CLK 51)
  --------------------------------------------------------------------------------------------------------------
  process (clk, reset)
  begin
    if (reset = '1') then
      soft_output_unflipped_51 <= (others => (others => '0'));
      output_weight_46         <= (others => '0');
      index_in_51              <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
      soft_output_unflipped_51 <= soft_output_unflipped_50;
      output_weight_46         <= output_weight_45;
      index_in_51              <= index_in_50;
    end if;
  end process;
  --------------------------------------------------------------------------------------------------------------
  ---- Define processes : (CLK 52)
  --------------------------------------------------------------------------------------------------------------
  process (clk, reset)
  begin
    if (reset = '1') then
      soft_output_unflipped_52 <= (others => (others => '0'));
      output_weight_47         <= (others => '0');
      index_in_52              <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
      soft_output_unflipped_52 <= soft_output_unflipped_51;
      output_weight_47         <= output_weight_46;
      index_in_52              <= index_in_51;
    end if;
  end process;
  --------------------------------------------------------------------------------------------------------------
  ---- Define processes : (CLK 53)
  --------------------------------------------------------------------------------------------------------------
  process (clk, reset)
  begin
    if (reset = '1') then
      soft_output_unflipped_53 <= (others => (others => '0'));
      output_weight_48         <= (others => '0');
      index_in_53              <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
      soft_output_unflipped_53 <= soft_output_unflipped_52;
      output_weight_48         <= output_weight_47;
      index_in_53              <= index_in_52;
    end if;
  end process;
  --------------------------------------------------------------------------------------------------------------
  ---- Define processes : (CLK 54)
  --------------------------------------------------------------------------------------------------------------
  process (clk, reset)
  begin
    if (reset = '1') then
      soft_output_unflipped_54 <= (others => (others => '0'));
      output_weight_49         <= (others => '0');
      index_in_54              <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
      soft_output_unflipped_54 <= soft_output_unflipped_53;
      output_weight_49         <= output_weight_48;
      index_in_54              <= index_in_53;
    end if;
  end process;
  --------------------------------------------------------------------------------------------------------------
  ---- Define processes : (CLK 55)
  --------------------------------------------------------------------------------------------------------------
  process (clk, reset)
  begin
    if (reset = '1') then
      soft_output_unflipped_55 <= (others => (others => '0'));
      output_weight_50         <= (others => '0');
      index_in_55              <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
      soft_output_unflipped_55 <= soft_output_unflipped_54;
      output_weight_50         <= output_weight_49;
      index_in_55              <= index_in_54;
    end if;
  end process;
  --------------------------------------------------------------------------------------------------------------
  ---- Define processes : (CLK 56)
  --------------------------------------------------------------------------------------------------------------
  process (clk, reset)
  begin
    if (reset = '1') then
      soft_output_unflipped_56 <= (others => (others => '0'));
      output_weight_51         <= (others => '0');
      index_in_56              <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
      soft_output_unflipped_56 <= soft_output_unflipped_55;
      output_weight_51         <= output_weight_50;
      index_in_56              <= index_in_55;
    end if;
  end process;
  --------------------------------------------------------------------------------------------------------------
  ---- Define processes : (CLK 57)
  --------------------------------------------------------------------------------------------------------------
  process (clk, reset)
  begin
    if (reset = '1') then
      soft_output_unflipped_57 <= (others => (others => '0'));
      output_weight_52         <= (others => '0');
      index_in_57              <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
      soft_output_unflipped_57 <= soft_output_unflipped_56;
      output_weight_52         <= output_weight_51;
      index_in_57              <= index_in_56;
    end if;
  end process;
  --------------------------------------------------------------------------------------------------------------
  ---- Define processes : (CLK 58)
  --------------------------------------------------------------------------------------------------------------
  process (clk, reset)
  begin
    if (reset = '1') then
      soft_output_unflipped_58 <= (others => (others => '0'));
      output_weight_53         <= (others => '0');
      index_in_58              <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
      soft_output_unflipped_58 <= soft_output_unflipped_57;
      output_weight_53         <= output_weight_52;
      index_in_58              <= index_in_57;
    end if;
  end process;
  --------------------------------------------------------------------------------------------------------------
  ---- Define processes : (CLK 59)
  --------------------------------------------------------------------------------------------------------------
  process (clk, reset)
  begin
    if (reset = '1') then
      soft_output_unflipped_59 <= (others => (others => '0'));
      output_weight_54         <= (others => '0');
      index_in_59              <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
      soft_output_unflipped_59 <= soft_output_unflipped_58;
      output_weight_54         <= output_weight_53;
      index_in_59              <= index_in_58;
    end if;
  end process;
  --------------------------------------------------------------------------------------------------------------
  ---- Define processes : (CLK 60)
  --------------------------------------------------------------------------------------------------------------
  process (clk, reset)
  begin
    if (reset = '1') then
      soft_output_unflipped_60 <= (others => (others => '0'));
      output_weight_55         <= (others => '0');
      index_in_60              <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
      soft_output_unflipped_60 <= soft_output_unflipped_59;
      output_weight_55         <= output_weight_54;
      index_in_60              <= index_in_59;
    end if;
  end process;
  --------------------------------------------------------------------------------------------------------------
  ---- Define processes : (CLK 61)
  --------------------------------------------------------------------------------------------------------------
  process (clk, reset)
  begin
    if (reset = '1') then
      soft_output_unflipped_61 <= (others => (others => '0'));
      output_weight_56         <= (others => '0');
      index_in_61              <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
      soft_output_unflipped_61 <= soft_output_unflipped_60;
      output_weight_56         <= output_weight_55;
      index_in_61              <= index_in_60;
    end if;
  end process;
  --------------------------------------------------------------------------------------------------------------
  ---- Define processes : (CLK 62)
  --------------------------------------------------------------------------------------------------------------
  process (clk, reset)
  begin
    if (reset = '1') then
      soft_output_unflipped_62 <= (others => (others => '0'));
      output_weight_57         <= (others => '0');
      index_in_62              <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
      soft_output_unflipped_62 <= soft_output_unflipped_61;
      output_weight_57         <= output_weight_56;
      index_in_62              <= index_in_61;
    end if;
  end process;
  --------------------------------------------------------------------------------------------------------------
  ---- Define processes : (CLK 63)
  --------------------------------------------------------------------------------------------------------------
  process (clk, reset)
  begin
    if (reset = '1') then
      soft_output_unflipped_63 <= (others => (others => '0'));
      output_weight_58         <= (others => '0');
      index_in_63              <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
      soft_output_unflipped_63 <= soft_output_unflipped_62;
      output_weight_58         <= output_weight_57;
      index_in_63              <= index_in_62;
    end if;
  end process;
  --------------------------------------------------------------------------------------------------------------
  ---- Define processes : (CLK 64)
  --------------------------------------------------------------------------------------------------------------
  process (clk, reset)
  begin
    if (reset = '1') then
      soft_output_unflipped_64 <= (others => (others => '0'));
      output_weight_59         <= (others => '0');
      index_in_64              <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
      soft_output_unflipped_64 <= soft_output_unflipped_63;
      output_weight_59         <= output_weight_58;
      index_in_64              <= index_in_63;
    end if;
  end process;
  --------------------------------------------------------------------------------------------------------------
  ---- Define processes : (CLK 65)
  --------------------------------------------------------------------------------------------------------------
  process (clk, reset)
  begin
    if (reset = '1') then
      soft_output_unflipped_65 <= (others => (others => '0'));
      output_weight_60         <= (others => '0');
      index_in_65              <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
      soft_output_unflipped_65 <= soft_output_unflipped_64;
      output_weight_60         <= output_weight_59;
      index_in_65              <= index_in_64;
    end if;
  end process;
  --------------------------------------------------------------------------------------------------------------
  ---- Define processes : (CLK 66)
  --------------------------------------------------------------------------------------------------------------
  process (clk, reset)
  begin
    if (reset = '1') then
      soft_output_unflipped_66 <= (others => (others => '0'));
      output_weight_61         <= (others => '0');
      index_in_66              <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
      soft_output_unflipped_66 <= soft_output_unflipped_65;
      output_weight_61         <= output_weight_60;
      index_in_66              <= index_in_65;
    end if;
  end process;
  --------------------------------------------------------------------------------------------------------------
  ---- Define processes : (CLK 67)
  --------------------------------------------------------------------------------------------------------------
  process (clk, reset)
  begin
    if (reset = '1') then
      soft_output_unflipped_67 <= (others => (others => '0'));
      output_weight_62         <= (others => '0');
      index_in_67              <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
      soft_output_unflipped_67 <= soft_output_unflipped_66;
      output_weight_62         <= output_weight_61;
      index_in_67              <= index_in_66;
    end if;
  end process;
  --------------------------------------------------------------------------------------------------------------
  ---- Define processes : (CLK 68)
  --------------------------------------------------------------------------------------------------------------
  process (clk, reset)
  begin
    if (reset = '1') then
      soft_output_unflipped_68 <= (others => (others => '0'));
      output_weight_63         <= (others => '0');
      index_in_68              <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
      soft_output_unflipped_68 <= soft_output_unflipped_67;
      output_weight_63         <= output_weight_62;
      index_in_68              <= index_in_67;
    end if;
  end process;
  --------------------------------------------------------------------------------------------------------------
  ---- Define processes : (CLK 69)
  --------------------------------------------------------------------------------------------------------------
  process (clk, reset)
  begin
    if (reset = '1') then
      soft_output_unflipped_69 <= (others => (others => '0'));
      output_weight_64         <= (others => '0');
      index_in_69              <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
      soft_output_unflipped_69 <= soft_output_unflipped_68;
      output_weight_64         <= output_weight_63;
      index_in_69              <= index_in_68;
    end if;
  end process;
  --------------------------------------------------------------------------------------------------------------
  ---- Define processes : (CLK 70)
  --------------------------------------------------------------------------------------------------------------
  process (clk, reset)
  begin
    if (reset = '1') then
      soft_output_unflipped_70 <= (others => (others => '0'));
      output_weight_65         <= (others => '0');
      index_in_70              <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
      soft_output_unflipped_70 <= soft_output_unflipped_69;
      output_weight_65         <= output_weight_64;
      index_in_70              <= index_in_69;
    end if;
  end process;
  --------------------------------------------------------------------------------------------------------------
  ---- Define processes : (CLK 71)
  --------------------------------------------------------------------------------------------------------------
  process (clk, reset)
  begin
    if (reset = '1') then
      soft_output_unflipped_71 <= (others => (others => '0'));
      output_weight_66         <= (others => '0');
      index_in_71              <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
      soft_output_unflipped_71 <= soft_output_unflipped_70;
      output_weight_66         <= output_weight_65;
      index_in_71              <= index_in_70;
    end if;
  end process;
  --------------------------------------------------------------------------------------------------------------
  ---- Define processes : (CLK 72)
  --------------------------------------------------------------------------------------------------------------
  process (clk, reset)
  begin
    if (reset = '1') then
      soft_output_unflipped_72 <= (others => (others => '0'));
      output_weight_67         <= (others => '0');
      index_in_72              <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
      soft_output_unflipped_72 <= soft_output_unflipped_71;
      output_weight_67         <= output_weight_66;
      index_in_72              <= index_in_71;
    end if;
  end process;
  --------------------------------------------------------------------------------------------------------------
  ---- Define processes : (CLK 73)
  --------------------------------------------------------------------------------------------------------------
  process (clk, reset)
  begin
    if (reset = '1') then
      soft_output_unflipped_73 <= (others => (others => '0'));
      output_weight_68         <= (others => '0');
      index_in_73              <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
      soft_output_unflipped_73 <= soft_output_unflipped_72;
      output_weight_68         <= output_weight_67;
      index_in_73              <= index_in_72;
    end if;
  end process;
  --------------------------------------------------------------------------------------------------------------
  ---- Define processes : (CLK 74)
  --------------------------------------------------------------------------------------------------------------
  process (clk, reset)
  begin
    if (reset = '1') then
      soft_output_unflipped_74 <= (others => (others => '0'));
      output_weight_69         <= (others => '0');
      index_in_74              <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
      soft_output_unflipped_74 <= soft_output_unflipped_73;
      output_weight_69         <= output_weight_68;
      index_in_74              <= index_in_73;
    end if;
  end process;
  --------------------------------------------------------------------------------------------------------------
  ---- Define processes : (CLK 75)
  --------------------------------------------------------------------------------------------------------------
  process (clk, reset)
  begin
    if (reset = '1') then
      soft_output_unflipped_75 <= (others => (others => '0'));
      output_weight_70         <= (others => '0');
      index_in_75              <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
      soft_output_unflipped_75 <= soft_output_unflipped_74;
      output_weight_70         <= output_weight_69;
      index_in_75              <= index_in_74;
    end if;
  end process;
  --------------------------------------------------------------------------------------------------------------
  ---- Define processes : (CLK 76)
  --------------------------------------------------------------------------------------------------------------
  process (clk, reset)
  begin
    if (reset = '1') then
      soft_output_unflipped_76 <= (others => (others => '0'));
      output_weight_71         <= (others => '0');
      index_in_76              <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
      soft_output_unflipped_76 <= soft_output_unflipped_75;
      output_weight_71         <= output_weight_70;
      index_in_76              <= index_in_75;
    end if;
  end process;
  --------------------------------------------------------------------------------------------------------------
  ---- Define processes : (CLK 77)
  --------------------------------------------------------------------------------------------------------------
  process (clk, reset)
  begin
    if (reset = '1') then
      soft_output_unflipped_77 <= (others => (others => '0'));
      output_weight_72         <= (others => '0');
      index_in_77              <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
      soft_output_unflipped_77 <= soft_output_unflipped_76;
      output_weight_72         <= output_weight_71;
      index_in_77              <= index_in_76;
    end if;
  end process;
  --------------------------------------------------------------------------------------------------------------
  ---- Define processes : (CLK 78)
  --------------------------------------------------------------------------------------------------------------
  process (clk, reset)
  begin
    if (reset = '1') then
      soft_output_unflipped_78 <= (others => (others => '0'));
      output_weight_73         <= (others => '0');
      index_in_78              <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
      soft_output_unflipped_78 <= soft_output_unflipped_77;
      output_weight_73         <= output_weight_72;
      index_in_78              <= index_in_77;
    end if;
  end process;
  --------------------------------------------------------------------------------------------------------------
  ---- Define processes : (CLK 79)
  --------------------------------------------------------------------------------------------------------------
  process (clk, reset)
  begin
    if (reset = '1') then
      soft_output_unflipped_79 <= (others => (others => '0'));
      output_weight_74         <= (others => '0');
      index_in_79              <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
      soft_output_unflipped_79 <= soft_output_unflipped_78;
      output_weight_74         <= output_weight_73;
      index_in_79              <= index_in_78;
    end if;
  end process;
  --------------------------------------------------------------------------------------------------------------
  ---- Define processes : (CLK 80)
  --------------------------------------------------------------------------------------------------------------
  process (clk, reset)
  begin
    if (reset = '1') then
      soft_output_unflipped_80 <= (others => (others => '0'));
      output_weight_75         <= (others => '0');
      index_in_80              <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
      soft_output_unflipped_80 <= soft_output_unflipped_79;
      output_weight_75         <= output_weight_74;
      index_in_80              <= index_in_79;
    end if;
  end process;
  --------------------------------------------------------------------------------------------------------------
  ---- Define processes : (CLK 81)
  --------------------------------------------------------------------------------------------------------------
  process (clk, reset)
  begin
    if (reset = '1') then
      soft_output_unflipped_81 <= (others => (others => '0'));
      output_weight_76         <= (others => '0');
      index_in_81              <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
      soft_output_unflipped_81 <= soft_output_unflipped_80;
      output_weight_76         <= output_weight_75;
      index_in_81              <= index_in_80;
    end if;
  end process;

  --------------------------------------------------------------------------------------------------------------
  ---- Define processes : (CLK 82)
  --------------------------------------------------------------------------------------------------------------
  process (clk, reset)
  begin
    if (reset = '1') then
      soft_output_unflipped_82 <= (others => (others => '0'));
      output_weight_77         <= (others => '0');
      index_in_82              <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
      soft_output_unflipped_82 <= soft_output_unflipped_81;
      output_weight_77         <= output_weight_76;
      index_in_82              <= index_in_81;
    end if;
  end process;
  --------------------------------------------------------------------------------------------------------------
  ---- Define processes : (CLK 83)
  --------------------------------------------------------------------------------------------------------------
  process (clk, reset)
  begin
    if (reset = '1') then
      soft_output_unflipped_83 <= (others => (others => '0'));
      output_weight_78         <= (others => '0');
      index_in_83              <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
      soft_output_unflipped_83 <= soft_output_unflipped_82;
      output_weight_78         <= output_weight_77;
      index_in_83              <= index_in_82;
    end if;
  end process;
  --------------------------------------------------------------------------------------------------------------
  ---- Define processes : (CLK 84)
  --------------------------------------------------------------------------------------------------------------
  process (clk, reset)
  begin
    if (reset = '1') then
      soft_output_unflipped_84 <= (others => (others => '0'));
      output_weight_79         <= (others => '0');
      index_in_84              <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
      soft_output_unflipped_84 <= soft_output_unflipped_83;
      output_weight_79         <= output_weight_78;
      index_in_84              <= index_in_83;
    end if;
  end process;
  --------------------------------------------------------------------------------------------------------------
  ---- Define processes : (CLK 85)
  --------------------------------------------------------------------------------------------------------------
  process (clk, reset)
  begin
    if (reset = '1') then
      soft_output_unflipped <= (others => (others => '0'));
      output_weight         <= (others => '0');
      index_out             <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
      soft_output_unflipped <= soft_output_unflipped_84;
      output_weight         <= output_weight_79;
      index_out             <= index_in_84;
    end if;
  end process;
  --------------------------------------------------------------------------------------------------------------
  ---- Define processes : (CLK 86)
  --------------------------------------------------------------------------------------------------------------
  --process (clk, reset)
  --begin
  --  if (reset = '1') then
  --    soft_output_unflipped <= (others => (others => '0'));
  --    output_weight         <= (others => '0');
  --  elsif (rising_edge(clk)) then
  --    soft_output_unflipped <= soft_output_unflipped_85;
  --    output_weight         <= output_weight_80;
  --  end if;
  --end process;
end architecture;
