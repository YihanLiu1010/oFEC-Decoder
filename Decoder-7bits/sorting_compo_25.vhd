library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use ieee.math_real.all;
USE work.arr_pkg_2.all;
USE work.arr_pkg_3.all;

entity sorting_compo_25 is
	generic(    
        data_length     : positive := 7                                 -- we can start from sorting 8 inputs 
        );
	port (
		clk             : in std_logic; 					                    -- system clock
		reset           : in std_logic; 					                    -- reset
		soft_input      : in input_data_array(data_length downto 0); 	        -- 6 bits
		
        index           : out index_array(data_length downto 0); 				-- We only need to output the index of the most 8 unreliable bits, so maybe having 8 index output is enough
		soft_output     : out input_data_array(data_length downto 0)            -- soft output should be the same as soft input, I think we only need the index
	);
end sorting_compo_25;

architecture rtl of sorting_compo_25 is 
------------------------------------------------------------------------------------------------------------
--CLK 1
signal soft_input_abs_8				: input_data_array(data_length downto 0);
------------------------------------------------------------------------------------------------------------
--CLK 2
signal index_A_1					: std_logic_vector(7 downto 0); 				  
signal index_B_1					: std_logic_vector(7 downto 0);  
signal index_C_1					: std_logic_vector(7 downto 0); 				  
signal index_D_1					: std_logic_vector(7 downto 0);
signal index_E_1					: std_logic_vector(7 downto 0); 				  
signal index_F_1					: std_logic_vector(7 downto 0);
signal index_G_1					: std_logic_vector(7 downto 0); 				  
signal index_H_1					: std_logic_vector(7 downto 0);
signal soft_input_8_s1				: input_data_array(data_length downto 0);
------------------------------------------------------------------------------------------------------------
--CLK 3
signal index_A_2					: std_logic_vector(7 downto 0); 				  
signal index_B_2					: std_logic_vector(7 downto 0);  
signal index_C_2					: std_logic_vector(7 downto 0); 				  
signal index_D_2					: std_logic_vector(7 downto 0);
signal index_E_2					: std_logic_vector(7 downto 0); 				  
signal index_F_2					: std_logic_vector(7 downto 0);
signal index_G_2					: std_logic_vector(7 downto 0); 				  
signal index_H_2					: std_logic_vector(7 downto 0);
signal soft_input_8_s2				: input_data_array(data_length downto 0);
------------------------------------------------------------------------------------------------------------
--CLK 4
signal index_A_3					: std_logic_vector(7 downto 0); 				  
signal index_B_3					: std_logic_vector(7 downto 0);  
signal index_C_3					: std_logic_vector(7 downto 0); 				  
signal index_D_3					: std_logic_vector(7 downto 0);
signal index_E_3					: std_logic_vector(7 downto 0); 				  
signal index_F_3					: std_logic_vector(7 downto 0);
signal index_G_3					: std_logic_vector(7 downto 0); 				  
signal index_H_3					: std_logic_vector(7 downto 0);
signal soft_input_8_s3				: input_data_array(data_length downto 0);
------------------------------------------------------------------------------------------------------------
--CLK 4
signal index_A_4					: std_logic_vector(7 downto 0); 				  
signal index_B_4					: std_logic_vector(7 downto 0);  
signal index_C_4					: std_logic_vector(7 downto 0); 				  
signal index_D_4					: std_logic_vector(7 downto 0); 
signal index_E_4					: std_logic_vector(7 downto 0); 				  
signal index_F_4					: std_logic_vector(7 downto 0);
signal index_G_4					: std_logic_vector(7 downto 0); 				  
signal index_H_4					: std_logic_vector(7 downto 0);				   				  
signal soft_input_8_s4				: input_data_array(data_length downto 0);
------------------------------------------------------------------------------------------------------------
--CLK 5
signal index_A_5					: std_logic_vector(7 downto 0); 				  
signal index_B_5					: std_logic_vector(7 downto 0);  
signal index_C_5					: std_logic_vector(7 downto 0); 				  
signal index_D_5					: std_logic_vector(7 downto 0); 
signal index_E_5					: std_logic_vector(7 downto 0); 				  
signal index_F_5					: std_logic_vector(7 downto 0);
signal index_G_5					: std_logic_vector(7 downto 0); 				  
signal index_H_5					: std_logic_vector(7 downto 0);					   				  
signal soft_input_8_s5				: input_data_array(data_length downto 0);
------------------------------------------------------------------------------------------------------------
--CLK 6
signal index_A_6					: std_logic_vector(7 downto 0); 	
signal index_B_6					: std_logic_vector(7 downto 0);  
signal index_C_6					: std_logic_vector(7 downto 0); 				  
signal index_D_6					: std_logic_vector(7 downto 0); 
signal index_E_6					: std_logic_vector(7 downto 0); 				  
signal index_F_6					: std_logic_vector(7 downto 0);
signal index_G_6					: std_logic_vector(7 downto 0); 				  
signal index_H_6					: std_logic_vector(7 downto 0);				  			   				  
signal soft_input_8_s6				: input_data_array(data_length downto 0);
begin
------------------------------------------------------------------------------------------------------------
-- Define processes : (CLK 1) Seems like no trouble converting 256 bits in one clock cycle
------------------------------------------------------------------------------------------------------------
process(clk, reset)
begin
	if (reset = '1') then
		soft_input_abs_8 <= (others => (others => '0'));
    elsif (rising_edge(clk)) then    
		-- soft_input_abs_8 <= soft_input(255 downto 248);
		for i in 0 to 7 loop
			soft_input_abs_8(i) <= std_logic_vector(abs(signed(soft_input(i)))); -- take a chunk of abs soft input data
		end loop;
	end if;
end process;
------------------------------------------------------------------------------------------------------------
-- Define processes : (CLK 2)
------------------------------------------------------------------------------------------------------------
process(clk, reset)
begin
	if (reset = '1') then
		index_A_1				 <= (others => '0');		  
		index_B_1				 <= (others => '0');
		index_C_1				 <= (others => '0');		  
		index_D_1				 <= (others => '0');
		index_E_1				 <= (others => '0');		  
		index_F_1				 <= (others => '0');
		index_G_1				 <= (others => '0');		  
		index_H_1				 <= (others => '0');
		soft_input_8_s1			 <= (others => (others => '0'));
    elsif (rising_edge(clk)) then   
		-- BN1_1
		if soft_input_abs_8(0) > soft_input_abs_8(1) then
			soft_input_8_s1(0) 	 <= soft_input_abs_8(1);
		  	index_A_1	 		 <= "11001001";
			soft_input_8_s1(2) 	 <= soft_input_abs_8(0);
		  	index_C_1	 		 <= "11001000";
		else
			soft_input_8_s1(0) 	 <= soft_input_abs_8(0);
		  	index_A_1	 		 <= "11001000";
			soft_input_8_s1(2)	 <= soft_input_abs_8(1);
		  	index_C_1	 		 <= "11001001";
		end if;

		-- BN_1
		if (soft_input_abs_8(2) > soft_input_abs_8(3)) or (soft_input_abs_8(2) = soft_input_abs_8(3)) then
			soft_input_8_s1(1) 	 <= soft_input_abs_8(2);
		  	index_B_1			 <= "11001010";
		  	soft_input_8_s1(3)	 <= soft_input_abs_8(3);
		  	index_D_1			 <= "11001011";
		else
			soft_input_8_s1(1) 	 <= soft_input_abs_8(3);
		  	index_B_1			 <= "11001011";
		  	soft_input_8_s1(3) 	 <= soft_input_abs_8(2);
		  	index_D_1			 <= "11001010";
		end if;

		-- BN1_1
		if soft_input_abs_8(4) > soft_input_abs_8(5) then
			soft_input_8_s1(4) 	 <= soft_input_abs_8(5);
			index_E_1	 		 <= "11001101";
			soft_input_8_s1(6) 	 <= soft_input_abs_8(4);
			index_G_1	 		 <= "11001100";
		else
			soft_input_8_s1(4) 	 <= soft_input_abs_8(4);
			index_E_1	 		 <= "11001100";
			soft_input_8_s1(6)	 <= soft_input_abs_8(5);
			index_G_1	 		 <= "11001101";
		end if;

		-- BN_1
		if soft_input_abs_8(6) > soft_input_abs_8(7) then
			soft_input_8_s1(5) 	 <= soft_input_abs_8(6);
			index_F_1			 <= "11001110";
			soft_input_8_s1(7)	 <= soft_input_abs_8(7);
			index_H_1			 <= "11001111";
		else
			soft_input_8_s1(5) 	 <= soft_input_abs_8(7);
			index_F_1			 <= "11001111";
			soft_input_8_s1(7) 	 <= soft_input_abs_8(6);
			index_H_1			 <= "11001110";
		end if;
	end if;
end process;
------------------------------------------------------------------------------------------------------------
-- Define processes : (CLK 3)
------------------------------------------------------------------------------------------------------------
process(clk, reset)
begin
	if (reset = '1') then
		index_A_2				 <= (others => '0');		  
		index_B_2				 <= (others => '0');
		index_C_2				 <= (others => '0');		  
		index_D_2				 <= (others => '0');
		index_E_2				 <= (others => '0');		  
		index_F_2				 <= (others => '0');
		index_G_2				 <= (others => '0');		  
		index_H_2				 <= (others => '0');
		soft_input_8_s2			 <= (others => (others => '0'));
    elsif (rising_edge(clk)) then     
		-- BN1_2
		if soft_input_8_s1(0) > soft_input_8_s1(1) then
			soft_input_8_s2(0) 	 <= soft_input_8_s1(1);
		  	index_A_2	 		 <= index_B_1;
			soft_input_8_s2(2) 	 <= soft_input_8_s1(0);
		  	index_C_2	 		 <= index_A_1;
		else
			soft_input_8_s2(0) 	 <= soft_input_8_s1(0);
		  	index_A_2	 		 <= index_A_1;
			soft_input_8_s2(2)	 <= soft_input_8_s1(1);
		  	index_C_2	 		 <= index_B_1;
		end if;

		-- BN1_2
		if soft_input_8_s1(2) > soft_input_8_s1(3) then
			soft_input_8_s2(1) 	 <= soft_input_8_s1(3);
			index_B_2	 		 <= index_D_1;
			soft_input_8_s2(3) 	 <= soft_input_8_s1(2);
			index_D_2	 		 <= index_C_1;
		else
			soft_input_8_s2(1) 	 <= soft_input_8_s1(2);
			index_B_2	 		 <= index_C_1;
			soft_input_8_s2(3)	 <= soft_input_8_s1(3);
			index_D_2	 		 <= index_D_1;
		end if;

		-- BN_2
		if soft_input_8_s1(4) > soft_input_8_s1(5) then
			soft_input_8_s2(4) 	 <= soft_input_8_s1(4);
		  	index_E_2			 <= index_E_1;
		  	soft_input_8_s2(6)	 <= soft_input_8_s1(5);
		  	index_G_2			 <= index_F_1;
		else
			soft_input_8_s2(4) 	 <= soft_input_8_s1(5);
			index_E_2			 <= index_F_1;
		  	soft_input_8_s2(6) 	 <= soft_input_8_s1(4);
		  	index_G_2			 <= index_E_1;
		end if;

		-- BN_2
		if soft_input_8_s1(6) > soft_input_8_s1(7) then
			soft_input_8_s2(5) 	 <= soft_input_8_s1(6);
			index_F_2			 <= index_G_1;
			soft_input_8_s2(7)	 <= soft_input_8_s1(7);
			index_H_2			 <= index_H_1;
		else
			soft_input_8_s2(5) 	 <= soft_input_8_s1(7);
			index_F_2			 <= index_H_1;
			soft_input_8_s2(7) 	 <= soft_input_8_s1(6);
			index_H_2			 <= index_G_1;
		end if;
	end if;
end process;
------------------------------------------------------------------------------------------------------------
-- Define processes : (CLK 4)
------------------------------------------------------------------------------------------------------------
process(clk, reset)
begin
	if (reset = '1') then
		index_A_3				 <= (others => '0');		  
		index_B_3				 <= (others => '0');
		index_C_3				 <= (others => '0');		  
		index_D_3				 <= (others => '0');
		index_E_3				 <= (others => '0');		  
		index_F_3				 <= (others => '0');
		index_G_3				 <= (others => '0');		  
		index_H_3				 <= (others => '0');
		soft_input_8_s3			 <= (others => (others => '0'));
    elsif (rising_edge(clk)) then   
		-- BN1_3
		if soft_input_8_s2(0) > soft_input_8_s2(1) then
			soft_input_8_s3(0) 	 <= soft_input_8_s2(1);
		  	index_A_3	 		 <= index_B_2;
			soft_input_8_s3(2) 	 <= soft_input_8_s2(0);
		  	index_C_3	 		 <= index_A_2;
		else
			soft_input_8_s3(0) 	 <= soft_input_8_s2(0);
		  	index_A_3	 		 <= index_A_2;
			soft_input_8_s3(2)	 <= soft_input_8_s2(1);
		  	index_C_3	 		 <= index_B_2;
		end if;

		-- BN1_3
		if soft_input_8_s2(2) > soft_input_8_s2(3) then
			soft_input_8_s3(4) 	 <= soft_input_8_s2(3);
			index_E_3	 		 <= index_D_2;
			soft_input_8_s3(6) 	 <= soft_input_8_s2(2);
			index_G_3	 		 <= index_C_2;
		else
			soft_input_8_s3(4) 	 <= soft_input_8_s2(2);
			index_E_3	 		 <= index_C_2;
			soft_input_8_s3(6)	 <= soft_input_8_s2(3);
			index_G_3	 		 <= index_D_2;
		end if;

		-- BN_3
		if soft_input_8_s2(4) > soft_input_8_s2(5) then
			soft_input_8_s3(1) 	 <= soft_input_8_s2(4);
		  	index_B_3			 <= index_E_2;
		  	soft_input_8_s3(3)	 <= soft_input_8_s2(5);
		  	index_D_3			 <= index_F_2;
		else
			soft_input_8_s3(1) 	 <= soft_input_8_s2(5);
			index_B_3			 <= index_F_2;
			soft_input_8_s3(3) 	 <= soft_input_8_s2(4);
		  	index_D_3			 <= index_E_2;
		end if;

		-- BN_3
		if soft_input_8_s2(6) > soft_input_8_s2(7) then
			soft_input_8_s3(5) 	 <= soft_input_8_s2(6);
			index_F_3			 <= index_G_2;
			soft_input_8_s3(7)	 <= soft_input_8_s2(7);
			index_H_3			 <= index_H_2;
		else
			soft_input_8_s3(5) 	 <= soft_input_8_s2(7);
			index_F_3			 <= index_H_2;
			soft_input_8_s3(7) 	 <= soft_input_8_s2(6);
			index_H_3			 <= index_G_2;
		end if;
	end if;
end process;
------------------------------------------------------------------------------------------------------------
-- Define processes : (CLK 5)
------------------------------------------------------------------------------------------------------------
process(clk, reset)
begin
	if (reset = '1') then
		index_A_4				 <= (others => '0');		  
		index_B_4				 <= (others => '0');
		index_C_4				 <= (others => '0');		  
		index_D_4				 <= (others => '0');
		index_E_4				 <= (others => '0');
		index_F_4				 <= (others => '0');
		index_G_4				 <= (others => '0');
		index_H_4				 <= (others => '0');
		soft_input_8_s4			 <= (others => (others => '0'));
    elsif (rising_edge(clk)) then
		-- BN1_4
		if soft_input_8_s3(0) > soft_input_8_s3(1) then
			soft_input_8_s4(0) 	 <= soft_input_8_s3(1);
		  	index_A_4	 		 <= index_B_3;
			soft_input_8_s4(4) 	 <= soft_input_8_s3(0);
			index_E_4	 		 <= index_A_3;
		else
			soft_input_8_s4(0) 	 <= soft_input_8_s3(0);
		  	index_A_4	 		 <= index_A_3;
			soft_input_8_s4(4) 	 <= soft_input_8_s3(1);
			index_E_4	 		 <= index_B_3;
		end if;

		-- BN1_4
		if soft_input_8_s3(2) > soft_input_8_s3(3) then
			soft_input_8_s4(2) 	 <= soft_input_8_s3(3);
			index_C_4	 		 <= index_D_3;
			soft_input_8_s4(6) 	 <= soft_input_8_s3(2);
			index_G_4	 		 <= index_C_3;
		else
			soft_input_8_s4(2) 	 <= soft_input_8_s3(2);
			index_C_4	 		 <= index_C_3;
			soft_input_8_s4(6) 	 <= soft_input_8_s3(3);
			index_G_4            <= index_D_3;
		end if;

		-- BN1_4
		if soft_input_8_s3(4) > soft_input_8_s3(5) then
			soft_input_8_s4(1) 	 <= soft_input_8_s3(5);
			index_B_4	 		 <= index_F_3;
			soft_input_8_s4(5) 	 <= soft_input_8_s3(4);
			index_F_4	 		 <= index_E_3;
		else
			soft_input_8_s4(1) 	 <= soft_input_8_s3(4);
			index_B_4	 		 <= index_E_3;
			soft_input_8_s4(5) 	 <= soft_input_8_s3(5);
			index_F_4	 		 <= index_F_3;
		end if;

		-- BN1_4
		if soft_input_8_s3(6) > soft_input_8_s3(7) then
			soft_input_8_s4(3) 	 <= soft_input_8_s3(7);
			index_D_4	 		 <= index_H_3;
			soft_input_8_s4(7)   <= soft_input_8_s3(6);
			index_H_4	 		 <= index_G_3;
		else
			soft_input_8_s4(3) 	 <= soft_input_8_s3(6);
			index_D_4	 		 <= index_G_3;
			soft_input_8_s4(7)   <= soft_input_8_s3(7);
			index_H_4            <= index_H_3;
		end if;
	end if;
end process;
------------------------------------------------------------------------------------------------------------
-- Define processes : (CLK 6)
------------------------------------------------------------------------------------------------------------
process(clk, reset)
begin
	if (reset = '1') then
		index_A_5				 <= (others => '0');		  
		index_B_5				 <= (others => '0');
		index_C_5				 <= (others => '0');
		index_D_5				 <= (others => '0');
		index_E_5				 <= (others => '0');
		index_F_5				 <= (others => '0');
		index_G_5				 <= (others => '0');
		index_H_5				 <= (others => '0');
		soft_input_8_s5			 <= (others => (others => '0'));
    elsif (rising_edge(clk)) then   
		-- BN1_5
		if soft_input_8_s4(0) > soft_input_8_s4(1) then
			soft_input_8_s5(0) 	 <= soft_input_8_s4(1);
		  	index_A_5	 		 <= index_B_4;
			soft_input_8_s5(2) 	 <= soft_input_8_s4(0);
		  	index_C_5	 		 <= index_A_4;
		else
			soft_input_8_s5(0) 	 <= soft_input_8_s4(0);
		  	index_A_5	 		 <= index_A_4;
			soft_input_8_s5(2)   <= soft_input_8_s4(1);
			index_C_5	 		 <= index_B_4;
		end if;

		-- BN1_5
		if soft_input_8_s4(2) > soft_input_8_s4(3) then
			soft_input_8_s5(1) 	 <= soft_input_8_s4(3);
			index_B_5	 		 <= index_D_4;
			soft_input_8_s5(3)   <= soft_input_8_s4(2);
			index_D_5	 		 <= index_C_4;
		else
			soft_input_8_s5(1) 	 <= soft_input_8_s4(2);
			index_B_5	 		 <= index_C_4;
			soft_input_8_s5(3)   <= soft_input_8_s4(3);
			index_D_5            <= index_D_4;
		end if;

		-- BN1_5
		if soft_input_8_s4(4) > soft_input_8_s4(5) or soft_input_8_s4(4) = soft_input_8_s4(5) then
			soft_input_8_s5(4) 	 <= soft_input_8_s4(5);
			index_E_5	 		 <= index_F_4;
			soft_input_8_s5(6)   <= soft_input_8_s4(4);
			index_G_5	 		 <= index_E_4;
		else
			soft_input_8_s5(4) 	 <= soft_input_8_s4(4);
			index_E_5	 		 <= index_E_4;
			soft_input_8_s5(6)   <= soft_input_8_s4(5);
			index_G_5            <= index_F_4;
		end if;

		-- BN1_5
		if soft_input_8_s4(6) > soft_input_8_s4(7) or soft_input_8_s4(6) = soft_input_8_s4(7) then
			soft_input_8_s5(5) 	 <= soft_input_8_s4(7);
			index_F_5	 		 <= index_H_4;
			soft_input_8_s5(7)   <= soft_input_8_s4(6);
			index_H_5	 		 <= index_G_4;
		else
			soft_input_8_s5(5) 	 <= soft_input_8_s4(6);
			index_F_5	 		 <= index_G_4;
			soft_input_8_s5(7)   <= soft_input_8_s4(7);
			index_H_5            <= index_H_4;
		end if;
	end if;
end process;
------------------------------------------------------------------------------------------------------------
-- Define processes : (CLK 7)
------------------------------------------------------------------------------------------------------------
process(clk, reset)
begin
	if (reset = '1') then
		index_A_6				 <= (others => '0');		  
		index_B_6				 <= (others => '0');
		index_C_6				 <= (others => '0');
		index_D_6				 <= (others => '0');
		index_E_6				 <= (others => '0');
		index_F_6				 <= (others => '0');
		index_G_6				 <= (others => '0');
		index_H_6				 <= (others => '0');	  
		soft_input_8_s6			 <= (others => (others => '0'));
    elsif (rising_edge(clk)) then  
		-- BN1_6
		if soft_input_8_s5(0) > soft_input_8_s5(1) then
			soft_input_8_s6(0) 	 <= soft_input_8_s5(1);
		  	index_A_6	 		 <= index_B_5;
			soft_input_8_s6(1) 	 <= soft_input_8_s5(0);
			index_B_6	 		 <= index_A_5;
		else
			soft_input_8_s6(0) 	 <= soft_input_8_s5(0);
		  	index_A_6	 		 <= index_A_5;
			soft_input_8_s6(1) 	 <= soft_input_8_s5(1);
			index_B_6	 		 <= index_B_5;
		end if;

		-- BN1_6
		if soft_input_8_s5(2) > soft_input_8_s5(3) then
			soft_input_8_s6(2) 	 <= soft_input_8_s5(3);
		  	index_C_6	 		 <= index_D_5;
			soft_input_8_s6(3) 	 <= soft_input_8_s5(2);
			index_D_6	 		 <= index_C_5;
		else
			soft_input_8_s6(2) 	 <= soft_input_8_s5(2);
		  	index_D_6	 		 <= index_D_5;
			soft_input_8_s6(3) 	 <= soft_input_8_s5(3);
			index_C_6	 		 <= index_C_5;
		end if;

		-- BN1_6
		if soft_input_8_s5(4) > soft_input_8_s5(5) or soft_input_8_s5(4) = soft_input_8_s5(5) then
			soft_input_8_s6(4) 	 <= soft_input_8_s5(5);
			index_E_6	 		 <= index_F_5;
			soft_input_8_s6(5) 	 <= soft_input_8_s5(4);
			index_F_6	 		 <= index_E_5;
		else
			soft_input_8_s6(4) 	 <= soft_input_8_s5(4);
			index_E_6	 		 <= index_E_5;
			soft_input_8_s6(5) 	 <= soft_input_8_s5(5);
			index_F_6	 		 <= index_F_5;
		end if;

		-- BN1_6
		if soft_input_8_s5(6) > soft_input_8_s5(7) then
			soft_input_8_s6(6) 	 <= soft_input_8_s5(7);
		  	index_G_6	 		 <= index_H_5;
			soft_input_8_s6(7) 	 <= soft_input_8_s5(6);
			index_H_6	 		 <= index_G_5;
		else
			soft_input_8_s6(6) 	 <= soft_input_8_s5(6);
		  	index_G_6	 		 <= index_G_5;
			soft_input_8_s6(7) 	 <= soft_input_8_s5(7);
			index_H_6	 		 <= index_H_5;
		end if;
	end if;
end process;
------------------------------------------------------------------------------------------------------------
-- Define processes : (CLK 8)
------------------------------------------------------------------------------------------------------------
process(clk, reset)
begin
	if (reset = '1') then
		index               <= (others => (others => '0'));		  
		soft_output			<= (others => (others => '0'));		
    elsif (rising_edge(clk)) then    
		index(0)            <= index_A_6;
		index(1)            <= index_B_6;
		index(2)            <= index_C_6;
		index(3)            <= index_D_6;
		index(4)            <= index_E_6;
		index(5)            <= index_F_6;
		index(6)            <= index_G_6;
		index(7)            <= index_H_6;
		soft_output(0)		<= soft_input_8_s6(0);
		soft_output(1)		<= soft_input_8_s6(1);
		soft_output(2)		<= soft_input_8_s6(2);
		soft_output(3)		<= soft_input_8_s6(3);
		soft_output(4)		<= soft_input_8_s6(4);
		soft_output(5)		<= soft_input_8_s6(5);
		soft_output(6)		<= soft_input_8_s6(6);
		soft_output(7)		<= soft_input_8_s6(7);
	end if;
end process;
end architecture;



---- BN
--if (A > B) or (A = B) then
--	A_1 	 <= A;
--  index_A_1<= index_A;
--	B_1 	 <= B;
--  index_B_1<= index_B;
--else
--	A_1 	 <= B;
--  index_A_1<= index_B;
--	B_1 	 <= A;
--  index_B_1<= index_A;
--end if;

---- BN1
--if (A > B) or (A = B) then
--	A_1 	 <= B;
--  index_A_1<= index_B;
--	B_1 	 <= A;
--  index_B_1<= index_A;
--else
--	A_1 	 <= A;
--  index_A_1<= index_A;
--	B_1 	 <= B;
--  index_B_1<= index_B;
--end if;