--library ieee;
--use ieee.std_logic_1164.all;
--
--PACKAGE arr_pkg_4 IS
--    type input_data_array is array (natural range <>) of std_logic_vector(5 downto 0); -- 6 bits, should be soft input this time!
--END; 
--
--library ieee;
--use ieee.std_logic_1164.all;
--
--PACKAGE arr_pkg_5 IS
--    type index_array is array (natural range <>) of std_logic_vector(7 downto 0); -- 8 bits, index can go from 0 to 255, 8 bits should be enough
--END; 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use ieee.math_real.all;
use work.arr_pkg_1.all;
use work.arr_pkg_2.all;
use work.arr_pkg_3.all;

entity sorting_merge is
	generic(    
        data_length     : positive := 7                                 -- we can start from sorting 8 inputs 
        );
	port (
		clk             : in std_logic; 					                    -- system clock
		reset           : in std_logic; 					                    -- reset
		A      			: in input_data_array(data_length downto 0); 	        -- soft input A
		B      			: in input_data_array(data_length downto 0); 	        -- soft input B
		index_A        	: in index_array(data_length downto 0); 			    -- index 4 soft input A
		index_B        	: in index_array(data_length downto 0);  				-- index 4 soft input B
		
        index           : out index_array(data_length downto 0); 				-- We only need to output the index of the most 8 unreliable bits, so maybe having 8 index output is enough
		soft_output     : out input_data_array(data_length downto 0)            -- soft output should be the same as soft input, I think we only need the index
	);
end sorting_merge;

architecture rtl of sorting_merge is 
type state_machine   is (A_0, B_0);
type state_machine_1 is (B_1_1, A_0_1, B_0_1, A_1_1);
type state_machine_2 is (A_0_2, B_0_2, A_1_2, B_1_2, A_2_2, B_2_2);
type state_machine_3 is (A_0_3, B_0_3, A_1_3, B_1_3, A_2_3, B_2_3, A_3_3, B_3_3); 
type state_machine_4 is (A_0_4, A_1_4, A_2_4, A_3_4, A_4_4, B_0_4, B_1_4, B_2_4, B_3_4, B_4_4);
type state_machine_5 is (A_0_5, A_1_5, A_2_5, A_3_5, A_4_5, A_5_5, B_0_5, B_1_5, B_2_5, B_3_5, B_4_5, B_5_5);
type state_machine_6 is (A_0_6, A_1_6, A_2_6, A_3_6, A_4_6, A_5_6, A_6_6, B_0_6, B_1_6, B_2_6, B_3_6, B_4_6, B_5_6, B_6_6);
signal state    	 : state_machine  ;
signal state_1    	 : state_machine_1;
signal state_2    	 : state_machine_2;
signal state_3    	 : state_machine_3;
signal state_4    	 : state_machine_4;
signal state_5    	 : state_machine_5;
signal state_6    	 : state_machine_6;
------------------------------------------------------------------------------------------------------------
--CLK 1
signal m_1							: input_data_array(data_length downto 0); -- Merge sequence 1
signal index_m_1					: index_array(data_length downto 0);
signal A_pass_1						: input_data_array(data_length downto 0); 
signal B_pass_1						: input_data_array(data_length downto 0); 
signal index_A_pass_1				: index_array(data_length downto 0);
signal index_B_pass_1				: index_array(data_length downto 0);
------------------------------------------------------------------------------------------------------------
--CLK 2
signal m_2							: input_data_array(data_length downto 0);
signal index_m_2					: index_array(data_length downto 0);
signal A_pass_2						: input_data_array(data_length downto 0); 
signal B_pass_2						: input_data_array(data_length downto 0); 
signal index_A_pass_2				: index_array(data_length downto 0);
signal index_B_pass_2				: index_array(data_length downto 0);
------------------------------------------------------------------------------------------------------------
--CLK 3
signal m_3							: input_data_array(data_length downto 0);
signal index_m_3					: index_array(data_length downto 0);
signal A_pass_3						: input_data_array(data_length downto 0); 
signal B_pass_3						: input_data_array(data_length downto 0); 
signal index_A_pass_3				: index_array(data_length downto 0);
signal index_B_pass_3				: index_array(data_length downto 0);
------------------------------------------------------------------------------------------------------------
--CLK 4
signal m_4							: input_data_array(data_length downto 0);
signal index_m_4					: index_array(data_length downto 0);
signal A_pass_4						: input_data_array(data_length downto 0); 
signal B_pass_4						: input_data_array(data_length downto 0); 
signal index_A_pass_4				: index_array(data_length downto 0);
signal index_B_pass_4				: index_array(data_length downto 0);
------------------------------------------------------------------------------------------------------------
--CLK 5
signal m_5							: input_data_array(data_length downto 0);
signal index_m_5					: index_array(data_length downto 0);
signal A_pass_5						: input_data_array(data_length downto 0); 
signal B_pass_5						: input_data_array(data_length downto 0); 
signal index_A_pass_5				: index_array(data_length downto 0);
signal index_B_pass_5				: index_array(data_length downto 0);
------------------------------------------------------------------------------------------------------------
--CLK 6
signal m_6							: input_data_array(data_length downto 0);
signal index_m_6					: index_array(data_length downto 0);
signal A_pass_6						: input_data_array(data_length downto 0); 
signal B_pass_6						: input_data_array(data_length downto 0); 
signal index_A_pass_6				: index_array(data_length downto 0);
signal index_B_pass_6				: index_array(data_length downto 0);
------------------------------------------------------------------------------------------------------------
--CLK 7
signal m_7							: input_data_array(data_length downto 0);
signal index_m_7					: index_array(data_length downto 0);
signal A_pass_7						: input_data_array(data_length downto 0); 
signal B_pass_7						: input_data_array(data_length downto 0); 
signal index_A_pass_7				: index_array(data_length downto 0);
signal index_B_pass_7				: index_array(data_length downto 0);
------------------------------------------------------------------------------------------------------------
--CLK 8
signal m_8							: input_data_array(data_length downto 0);
signal index_m_8					: index_array(data_length downto 0);
begin
------------------------------------------------------------------------------------------------------------
-- Define processes : (CLK 1) Input data is also the absolute value, start merging
------------------------------------------------------------------------------------------------------------
process(clk, reset)
begin
	if (reset = '1') then
		state		     <= A_0;
		A_pass_1 	     <= (others => (others => '0'));
		B_pass_1 	     <= (others => (others => '0'));
		index_A_pass_1   <= (others => (others => '0'));
		index_B_pass_1   <= (others => (others => '0'));
		m_1      		 <= (others => (others => '0'));
		index_m_1		 <= (others => (others => '0'));
    elsif (rising_edge(clk)) then    
		A_pass_1 	     <= A;
		B_pass_1 	     <= B;
		index_A_pass_1   <= index_A;
		index_B_pass_1   <= index_B;
		if A(0) < B(0) or A(0) = B(0) then
			m_1(0)       <= A(0);
			index_m_1(0) <= index_A(0);
			state		 <= A_0;
		else
			m_1(0)       <= B(0);
			index_m_1(0) <= index_B(0);
			state		 <= B_0;
		end if;
	end if;
end process;
------------------------------------------------------------------------------------------------------------
-- Define processes : (CLK 2)
------------------------------------------------------------------------------------------------------------
process(clk, reset)
begin
	if (reset = '1') then
		state_1  		 		<= A_0_1;
		m_2      		 		<= (others => (others => '0'));
		index_m_2		 		<= (others => (others => '0'));
		A_pass_2 	     		<= (others => (others => '0'));
		B_pass_2 	     		<= (others => (others => '0'));
		index_A_pass_2   		<= (others => (others => '0'));
		index_B_pass_2   		<= (others => (others => '0'));
    elsif (rising_edge(clk)) then  
		m_2      				<= m_1;
		index_m_2				<= index_m_1;
		A_pass_2 				<= A_pass_1;
		B_pass_2 				<= B_pass_1;
		index_A_pass_2 			<= index_A_pass_1;
		index_B_pass_2 			<= index_B_pass_1;
		case state is
			when A_0 =>
				if A_pass_1(1) < B_pass_1(0) or A_pass_1(1) = B_pass_1(0) then
					m_2(1) 		 <= A_pass_1(1);
					index_m_2(1) <= index_A_pass_1(1);
					state_1		 <= A_1_1;
				else
					m_2(1) 		 <= B_pass_1(0);
					index_m_2(1) <= index_B_pass_1(0);
					state_1		 <= B_0_1;
				end if;
			when B_0 =>
				if A_pass_1(0) > B_pass_1(1) or A_pass_1(0) = B_pass_1(1) then
					m_2(1) 		 <= B_pass_1(1);
					index_m_2(1) <= index_B_pass_1(1);
					state_1		 <= B_1_1;
				else
					m_2(1) 		 <= A_pass_1(0);
					index_m_2(1) <= index_A_pass_1(0);
					state_1		 <= A_0_1;
				end if;
		end case;
	end if;
end process;
------------------------------------------------------------------------------------------------------------
-- Define processes : (CLK 3)
------------------------------------------------------------------------------------------------------------
process(clk, reset)
begin
	if (reset = '1') then
		state_2  				<= A_0_2;
		m_3      				<= (others => (others => '0'));
		index_m_3				<= (others => (others => '0'));
		A_pass_3 	    		<= (others => (others => '0'));
		B_pass_3 	    		<= (others => (others => '0'));
		index_A_pass_3  		<= (others => (others => '0'));
		index_B_pass_3  		<= (others => (others => '0'));
    elsif (rising_edge(clk)) then     
		m_3      				<= m_2;
		index_m_3				<= index_m_2;
		A_pass_3 				<= A_pass_2;
		B_pass_3 				<= B_pass_2;
		index_A_pass_3 			<= index_A_pass_2;
		index_B_pass_3 			<= index_B_pass_2;
		case state_1 is
			when B_1_1 =>
				if A_pass_2(0) > B_pass_2(2) or A_pass_2(0) = B_pass_2(2) then
					m_3(2) 		 <= B_pass_2(2);
					index_m_3(2) <= index_B_pass_2(2);
					state_2		 <= B_2_2;
				else
					m_3(2) 		 <= A_pass_2(0);
					index_m_3(2) <= index_A_pass_2(0);
					state_2		 <= A_0_2;
				end if;
			when A_0_1 =>
			    if A_pass_2(1) > B_pass_2(1) or A_pass_2(1) = B_pass_2(1) then
			    	m_3(2) 		 <= B_pass_2(1);
			    	index_m_3(2) <= index_B_pass_2(1);
			    	state_2		 <= B_1_2;
			    else
			    	m_3(2) 		 <= A_pass_2(1);
			    	index_m_3(2) <= index_A_pass_2(1);
			    	state_2		 <= A_1_2;
			    end if;
			when B_0_1 =>
				if A_pass_2(1) > B_pass_2(1) or A_pass_2(1) = B_pass_2(1) then
					m_3(2) 		 <= B_pass_2(1);
					index_m_3(2) <= index_B_pass_2(1);
					state_2		 <= B_1_2;
				else
					m_3(2) 		 <= A_pass_2(1);
					index_m_3(2) <= index_A_pass_2(1);
					state_2		 <= A_1_2;
				end if;
			when A_1_1 =>
				if A_pass_2(2) > B_pass_2(0) then
					m_3(2) 		 <= B_pass_2(0);
					index_m_3(2) <= index_B_pass_2(0);
					state_2		 <= B_0_2;
				else
					m_3(2) 		 <= A_pass_2(2);
					index_m_3(2) <= index_A_pass_2(2);
					state_2		 <= A_2_2;
				end if;
		end case;		
	end if;
end process;
------------------------------------------------------------------------------------------------------------
-- Define processes : (CLK 4)
------------------------------------------------------------------------------------------------------------
process(clk, reset)
begin
	if (reset = '1') then
		state_3  		 		<= A_0_3;
		m_4      		 		<= (others => (others => '0'));
		index_m_4		 		<= (others => (others => '0'));
		A_pass_4 	     		<= (others => (others => '0'));
		B_pass_4 	     		<= (others => (others => '0'));
		index_A_pass_4   		<= (others => (others => '0'));
		index_B_pass_4   		<= (others => (others => '0'));
    elsif (rising_edge(clk)) then   
		m_4      				<= m_3;
		index_m_4				<= index_m_3;
		A_pass_4 				<= A_pass_3;
		B_pass_4 				<= B_pass_3;
		index_A_pass_4 			<= index_A_pass_3;
		index_B_pass_4 			<= index_B_pass_3;
		case state_2 is
			when B_2_2 =>
				if A_pass_3(0) > B_pass_3(3) or A_pass_3(0) = B_pass_3(3) then
					m_4(3) 		 <= B_pass_3(3);
					index_m_4(3) <= index_B_pass_3(3);
					state_3		 <= B_3_3;
				else
					m_4(3) 		 <= A_pass_3(0);
					index_m_4(3) <= index_A_pass_3(0);
					state_3		 <= A_0_3;
				end if;
			when A_0_2 =>
				if A_pass_3(1) > B_pass_3(2) or A_pass_3(1) = B_pass_3(2) then
					m_4(3) 		 <= B_pass_3(2);
					index_m_4(3) <= index_B_pass_3(2);
					state_3		 <= B_2_3;
				else
					m_4(3) 		 <= A_pass_3(1);
					index_m_4(3) <= index_A_pass_3(1);
					state_3		 <= A_1_3;
				end if;
			when B_1_2 =>
				if A_pass_3(1) > B_pass_3(2) or A_pass_3(1) = B_pass_3(2) then
					m_4(3) 		 <= B_pass_3(2);
					index_m_4(3) <= index_B_pass_3(2);
					state_3		 <= B_2_3;
				else
					m_4(3) 		 <= A_pass_3(1);
					index_m_4(3) <= index_A_pass_3(1);
					state_3		 <= A_1_3;
				end if;				
			when A_1_2 =>
				if A_pass_3(2) > B_pass_3(1) or A_pass_3(2) = B_pass_3(1) then
					m_4(3) 		 <= B_pass_3(1);
					index_m_4(3) <= index_B_pass_3(1);
					state_3		 <= B_1_3;
				else
					m_4(3) 		 <= A_pass_3(2);
					index_m_4(3) <= index_A_pass_3(2);
					state_3		 <= A_2_3;
				end if;	
			when B_0_2 =>
				if A_pass_3(2) > B_pass_3(1) or A_pass_3(2) = B_pass_3(1) then
					m_4(3) 		 <= B_pass_3(1);
					index_m_4(3) <= index_B_pass_3(1);
					state_3		 <= B_1_3;
				else
					m_4(3) 		 <= A_pass_3(2);
					index_m_4(3) <= index_A_pass_3(2);
					state_3		 <= A_2_3;
				end if;	
			when A_2_2 =>
				if A_pass_3(3) > B_pass_3(0) then
					m_4(3) 		 <= B_pass_3(0);
					index_m_4(3) <= index_B_pass_3(0);
					state_3		 <= B_0_3;
				else
					m_4(3) 		 <= A_pass_3(3);
					index_m_4(3) <= index_A_pass_3(3);
					state_3		 <= A_3_3;
				end if;					
		end case;
	end if;
end process;
------------------------------------------------------------------------------------------------------------
-- Define processes : (CLK 6)
------------------------------------------------------------------------------------------------------------
process(clk, reset)
begin
	if (reset = '1') then
		state_4  		 		<= A_0_4;
		m_5      		 		<= (others => (others => '0'));
		index_m_5		 		<= (others => (others => '0'));
		A_pass_5 	     		<= (others => (others => '0'));
		B_pass_5 	     		<= (others => (others => '0'));
		index_A_pass_5   		<= (others => (others => '0'));
		index_B_pass_5   		<= (others => (others => '0'));
    elsif (rising_edge(clk)) then   
		m_5      				<= m_4;
		index_m_5				<= index_m_4;
		A_pass_5 				<= A_pass_4;
		B_pass_5 				<= B_pass_4;
		index_A_pass_5 			<= index_A_pass_4;
		index_B_pass_5 			<= index_B_pass_4;
		case state_3 is
			when B_3_3 =>
				if A_pass_4(0) > B_pass_4(4) or A_pass_4(0) = B_pass_4(4) then
					m_5(4) 		 <= B_pass_4(4);
					index_m_5(4) <= index_B_pass_4(4);
					state_4		 <= B_4_4;
				else
					m_5(4) 		 <= A_pass_4(0);
					index_m_5(4) <= index_A_pass_4(0);
					state_4		 <= A_0_4;
				end if;
			when A_0_3 =>
				if A_pass_4(1) > B_pass_4(3) or A_pass_4(1) = B_pass_4(3) then
					m_5(4) 		 <= B_pass_4(3);
					index_m_5(4) <= index_B_pass_4(3);
					state_4		 <= B_3_4;
				else
					m_5(4) 		 <= A_pass_4(1);
					index_m_5(4) <= index_A_pass_4(1);
					state_4		 <= A_1_4;
				end if;
			when A_1_3 =>
				if A_pass_4(2) > B_pass_4(2) or A_pass_4(2) = B_pass_4(2) then
					m_5(4) 		 <= B_pass_4(2);
					index_m_5(4) <= index_B_pass_4(2);
					state_4		 <= B_2_4;
				else
					m_5(4) 		 <= A_pass_4(2);
					index_m_5(4) <= index_A_pass_4(2);
					state_4		 <= A_2_4;
				end if;
			when B_2_3 =>
				if A_pass_4(1) > B_pass_4(3) or A_pass_4(1) = B_pass_4(3) then
					m_5(4) 		 <= B_pass_4(3);
					index_m_5(4) <= index_B_pass_4(3);
					state_4		 <= B_3_4;
				else
					m_5(4) 		 <= A_pass_4(1);
					index_m_5(4) <= index_A_pass_4(1);
					state_4		 <= A_1_4;
				end if;
			when B_1_3 =>
				if A_pass_4(2) > B_pass_4(2) or A_pass_4(2) = B_pass_4(2) then
					m_5(4) 		 <= B_pass_4(2);
					index_m_5(4) <= index_B_pass_4(2);
					state_4		 <= B_2_4;
				else
					m_5(4) 		 <= A_pass_4(2);
					index_m_5(4) <= index_A_pass_4(2);
					state_4		 <= A_2_4;
				end if;
			when A_2_3 =>
				if A_pass_4(3) > B_pass_4(1) or A_pass_4(3) = B_pass_4(1) then
					m_5(4) 		 <= B_pass_4(1);
					index_m_5(4) <= index_B_pass_4(1);
					state_4		 <= B_1_4;
				else
					m_5(4) 		 <= A_pass_4(3);
					index_m_5(4) <= index_A_pass_4(3);
					state_4		 <= A_3_4;
				end if;
			when A_3_3 =>
				if A_pass_4(4) > B_pass_4(0) then
					m_5(4) 		 <= B_pass_4(0);
					index_m_5(4) <= index_B_pass_4(0);
					state_4		 <= B_0_4;
				else
					m_5(4) 		 <= A_pass_4(4);
					index_m_5(4) <= index_A_pass_4(4);
					state_4		 <= A_4_4;
				end if;
			when B_0_3 =>
				if A_pass_4(3) > B_pass_4(1) or A_pass_4(3) = B_pass_4(1) then
					m_5(4) 		 <= B_pass_4(1);
					index_m_5(4) <= index_B_pass_4(1);
					state_4		 <= B_1_4;
				else
					m_5(4) 		 <= A_pass_4(3);
					index_m_5(4) <= index_A_pass_4(3);
					state_4		 <= A_3_4;
				end if;
		end case;
	end if;
end process;
------------------------------------------------------------------------------------------------------------
-- Define processes : (CLK 7)
------------------------------------------------------------------------------------------------------------
process(clk, reset)
begin
	if (reset = '1') then
		state_5  		 		<= A_0_5;
		m_6      		 		<= (others => (others => '0'));
		index_m_6		 		<= (others => (others => '0'));
		A_pass_6 	     		<= (others => (others => '0'));
		B_pass_6 	     		<= (others => (others => '0'));
		index_A_pass_6   		<= (others => (others => '0'));
		index_B_pass_6   		<= (others => (others => '0'));		
    elsif (rising_edge(clk)) then  
		m_6      				<= m_5;
		index_m_6				<= index_m_5;
		A_pass_6 				<= A_pass_5;
		B_pass_6 				<= B_pass_5;
		index_A_pass_6 			<= index_A_pass_5;
		index_B_pass_6 			<= index_B_pass_5;
		case state_4 is
			when A_0_4 =>
				if A_pass_5(1) > B_pass_5(4) or A_pass_5(1) = B_pass_5(4) then
					m_6(5) 		 <= B_pass_5(4);
					index_m_6(5) <= index_B_pass_5(4);
					state_5		 <= B_4_5;
				else
					m_6(5) 		 <= A_pass_5(1);
					index_m_6(5) <= index_A_pass_5(1);
					state_5		 <= A_1_5;
				end if;
			when A_1_4 =>
				if A_pass_5(2) > B_pass_5(3) or A_pass_5(2) = B_pass_5(3) then
					m_6(5) 		 <= B_pass_5(3);
					index_m_6(5) <= index_B_pass_5(3);
					state_5		 <= B_3_5;
				else
					m_6(5) 		 <= A_pass_5(2);
					index_m_6(5) <= index_A_pass_5(2);
					state_5		 <= A_2_5;
				end if;
			when A_2_4 =>
				if A_pass_5(3) > B_pass_5(2) or A_pass_5(3) = B_pass_5(2) then
					m_6(5) 		 <= B_pass_5(2);
					index_m_6(5) <= index_B_pass_5(2);
					state_5		 <= B_2_5;
				else
					m_6(5) 		 <= A_pass_5(3);
					index_m_6(5) <= index_A_pass_5(3);
					state_5		 <= A_3_5;
				end if;			
			when A_3_4 =>
				if A_pass_5(4) > B_pass_5(1) or A_pass_5(4) = B_pass_5(1) then
					m_6(5) 		 <= B_pass_5(1);
					index_m_6(5) <= index_B_pass_5(1);
					state_5		 <= B_1_5;
				else
					m_6(5) 		 <= A_pass_5(4);
					index_m_6(5) <= index_A_pass_5(4);
					state_5		 <= A_4_5;
				end if;			
			when A_4_4 =>
				if A_pass_5(5) > B_pass_5(0) then
					m_6(5) 		 <= B_pass_5(0);
					index_m_6(5) <= index_B_pass_5(0);
					state_5		 <= B_0_5;
				else
					m_6(5) 		 <= A_pass_5(5);
					index_m_6(5) <= index_A_pass_5(5);
					state_5		 <= A_5_5;
				end if;	
			when B_0_4 =>
				if A_pass_5(4) > B_pass_5(1) or A_pass_5(4) = B_pass_5(1) then
					m_6(5) 		 <= B_pass_5(1);
					index_m_6(5) <= index_B_pass_5(1);
					state_5		 <= B_1_5;
				else
					m_6(5) 		 <= A_pass_5(4);
					index_m_6(5) <= index_A_pass_5(4);
					state_5		 <= A_4_5;
				end if;				
			when B_1_4 =>
				if A_pass_5(3) > B_pass_5(2) or A_pass_5(3) = B_pass_5(2) then
					m_6(5) 		 <= B_pass_5(2);
					index_m_6(5) <= index_B_pass_5(2);
					state_5		 <= B_2_5;
				else
					m_6(5) 		 <= A_pass_5(3);
					index_m_6(5) <= index_A_pass_5(3);
					state_5		 <= A_3_5;
				end if;	
			when B_2_4 =>
				if A_pass_5(2) > B_pass_5(3) or A_pass_5(2) = B_pass_5(3) then
					m_6(5) 		 <= B_pass_5(3);
					index_m_6(5) <= index_B_pass_5(3);
					state_5		 <= B_3_5;
				else
					m_6(5) 		 <= A_pass_5(2);
					index_m_6(5) <= index_A_pass_5(2);
					state_5		 <= A_2_5;
				end if;				
			when B_3_4 =>
				if A_pass_5(1) > B_pass_5(4) or A_pass_5(1) = B_pass_5(4) then
					m_6(5) 		 <= B_pass_5(4);
					index_m_6(5) <= index_B_pass_5(4);
					state_5		 <= B_4_5;
				else
					m_6(5) 		 <= A_pass_5(1);
					index_m_6(5) <= index_A_pass_5(1);
					state_5		 <= A_1_5;
				end if;
			when B_4_4 =>
				if A_pass_5(0) > B_pass_5(5) or A_pass_5(0) = B_pass_5(5) then
					m_6(5) 		 <= B_pass_5(5);
					index_m_6(5) <= index_B_pass_5(5);
					state_5		 <= B_5_5;
				else
					m_6(5) 		 <= A_pass_5(0);
					index_m_6(5) <= index_A_pass_5(0);
					state_5		 <= A_0_5;
				end if;
		end case;
	end if;
end process;
------------------------------------------------------------------------------------------------------------
-- Define processes : (CLK 8)
------------------------------------------------------------------------------------------------------------
process(clk, reset)
begin
	if (reset = '1') then
		state_6  		 		<= A_0_6;
		m_7      		 		<= (others => (others => '0'));
		index_m_7		 		<= (others => (others => '0'));
		A_pass_7 	     		<= (others => (others => '0'));
		B_pass_7 	     		<= (others => (others => '0'));
		index_A_pass_7   		<= (others => (others => '0'));
		index_B_pass_7   		<= (others => (others => '0'));			
    elsif (rising_edge(clk)) then    
		m_7      				<= m_6;
		index_m_7				<= index_m_6;
		A_pass_7 				<= A_pass_6;
		B_pass_7 				<= B_pass_6;
		index_A_pass_7 			<= index_A_pass_6;
		index_B_pass_7 			<= index_B_pass_6;
		case state_5 is
			when A_0_5 =>
				if A_pass_6(1) > B_pass_6(5) or A_pass_6(1) = B_pass_6(5) then
					m_7(6) 		 <= B_pass_6(5);
					index_m_7(6) <= index_B_pass_6(5);
					state_6		 <= B_5_6;
				else
					m_7(6) 		 <= A_pass_6(1);
					index_m_7(6) <= index_A_pass_6(1);
					state_6		 <= A_1_6;
				end if;
			when A_1_5 =>
				if A_pass_6(2) > B_pass_6(4) or A_pass_6(2) = B_pass_6(4) then
					m_7(6) 		 <= B_pass_6(4);
					index_m_7(6) <= index_B_pass_6(4);
					state_6		 <= B_4_6;
				else
					m_7(6) 		 <= A_pass_6(2);
					index_m_7(6) <= index_A_pass_6(2);
					state_6		 <= A_2_6;
				end if;
			when A_2_5 =>
				if A_pass_6(3) > B_pass_6(3) or A_pass_6(3) = B_pass_6(3) then
					m_7(6) 		 <= B_pass_6(3);
					index_m_7(6) <= index_B_pass_6(3);
					state_6		 <= B_3_6;
				else
					m_7(6) 		 <= A_pass_6(3);
					index_m_7(6) <= index_A_pass_6(3);
					state_6		 <= A_3_6;
				end if;
			when A_3_5 =>
				if A_pass_6(4) > B_pass_6(2) or A_pass_6(4) = B_pass_6(2) then
					m_7(6) 		 <= B_pass_6(2);
					index_m_7(6) <= index_B_pass_6(2);
					state_6		 <= B_2_6;
				else
					m_7(6) 		 <= A_pass_6(4);
					index_m_7(6) <= index_A_pass_6(4);
					state_6		 <= A_4_6;
				end if;
			when A_4_5 =>
				if A_pass_6(5) > B_pass_6(1) or A_pass_6(5) = B_pass_6(1) then
					m_7(6) 		 <= B_pass_6(1);
					index_m_7(6) <= index_B_pass_6(1);
					state_6		 <= B_1_6;
				else
					m_7(6) 		 <= A_pass_6(5);
					index_m_7(6) <= index_A_pass_6(5);
					state_6		 <= A_4_6;
				end if;
			when A_5_5 =>
				if A_pass_6(6) > B_pass_6(0) then
					m_7(6) 		 <= B_pass_6(0);
					index_m_7(6) <= index_B_pass_6(0);
					state_6		 <= B_0_6;
				else
					m_7(6) 		 <= A_pass_6(6);
					index_m_7(6) <= index_A_pass_6(6);
					state_6		 <= A_6_6;
				end if;
			when B_0_5 =>
				if A_pass_6(5) > B_pass_6(1) or A_pass_6(5) = B_pass_6(1) then
					m_7(6) 		 <= B_pass_6(1);
					index_m_7(6) <= index_B_pass_6(1);
					state_6		 <= B_1_6;
				else
					m_7(6) 		 <= A_pass_6(5);
					index_m_7(6) <= index_A_pass_6(5);
					state_6		 <= A_5_6;
				end if;
			when B_1_5 =>
				if A_pass_6(4) > B_pass_6(2) or A_pass_6(4) = B_pass_6(2) then
					m_7(6) 		 <= B_pass_6(2);
					index_m_7(6) <= index_B_pass_6(2);
					state_6		 <= B_2_6;
				else
					m_7(6) 		 <= A_pass_6(4);
					index_m_7(6) <= index_A_pass_6(4);
					state_6		 <= A_4_6;
				end if;
			when B_2_5 =>
				if A_pass_6(3) > B_pass_6(3) or A_pass_6(3) = B_pass_6(3) then
					m_7(6) 		 <= B_pass_6(3);
					index_m_7(6) <= index_B_pass_6(3);
					state_6		 <= B_3_6;
				else
					m_7(6) 		 <= A_pass_6(3);
					index_m_7(6) <= index_A_pass_6(3);
					state_6		 <= A_3_6;
				end if;
			when B_3_5 =>
				if A_pass_6(2) > B_pass_6(4) or A_pass_6(2) = B_pass_6(4) then
					m_7(6) 		 <= B_pass_6(4);
					index_m_7(6) <= index_B_pass_6(4);
					state_6		 <= B_4_6;
				else
					m_7(6) 		 <= A_pass_6(2);
					index_m_7(6) <= index_A_pass_6(2);
					state_6		 <= A_2_6;
				end if;
			when B_4_5 =>
				if A_pass_6(1) > B_pass_6(5) or A_pass_6(1) = B_pass_6(5) then
					m_7(6) 		 <= B_pass_6(5);
					index_m_7(6) <= index_B_pass_6(5);
					state_6		 <= B_5_6;
				else
					m_7(6) 		 <= A_pass_6(1);
					index_m_7(6) <= index_A_pass_6(1);
					state_6		 <= A_1_6;
				end if;		
			when B_5_5 =>
				if A_pass_6(0) > B_pass_6(6) or A_pass_6(0) = B_pass_6(6) then
					m_7(6) 		 <= B_pass_6(6);
					index_m_7(6) <= index_B_pass_6(6);
					state_6		 <= B_6_6;
				else
					m_7(6) 		 <= A_pass_6(0);
					index_m_7(6) <= index_A_pass_6(0);
					state_6		 <= A_0_6;
				end if;		
		end case;
	end if;
end process;
------------------------------------------------------------------------------------------------------------
-- Define processes : (CLK 9)
------------------------------------------------------------------------------------------------------------
process(clk, reset)
begin
	if (reset = '1') then
		m_8      		 		<= (others => (others => '0'));
		index_m_8		 		<= (others => (others => '0'));
    elsif (rising_edge(clk)) then    
		m_8      				<= m_7;
		index_m_8				<= index_m_7;
		case state_6 is
			when A_0_6 =>
				if A_pass_7(1) > B_pass_7(6) or A_pass_7(1) = B_pass_7(6) then
					m_8(7) 		 <= B_pass_7(6);
					index_m_8(7) <= index_B_pass_7(6);
				else
					m_8(7) 		 <= A_pass_7(1);
					index_m_8(7) <= index_A_pass_7(1);
				end if;	
			when A_1_6 =>
				if A_pass_7(2) > B_pass_7(5) or A_pass_7(2) = B_pass_7(5) then
					m_8(7) 		 <= B_pass_7(5);
					index_m_8(7) <= index_B_pass_7(5);
				else
					m_8(7) 		 <= A_pass_7(2);
					index_m_8(7) <= index_A_pass_7(2);
				end if;	
			when A_2_6 =>
				if A_pass_7(3) > B_pass_7(4) or A_pass_7(3) = B_pass_7(4) then
					m_8(7) 		 <= B_pass_7(4);
					index_m_8(7) <= index_B_pass_7(4);
				else
					m_8(7) 		 <= A_pass_7(3);
					index_m_8(7) <= index_A_pass_7(3);
				end if;	
			when A_3_6 =>
				if A_pass_7(4) > B_pass_7(3) or A_pass_7(4) = B_pass_7(3) then
					m_8(7) 		 <= B_pass_7(3);
					index_m_8(7) <= index_B_pass_7(3);
				else
					m_8(7) 		 <= A_pass_7(4);
					index_m_8(7) <= index_A_pass_7(4);
				end if;
			when A_4_6 =>
				if A_pass_7(5) > B_pass_7(2) or A_pass_7(5) = B_pass_7(2) then
					m_8(7) 		 <= B_pass_7(2);
					index_m_8(7) <= index_B_pass_7(2);
				else
					m_8(7) 		 <= A_pass_7(5);
					index_m_8(7) <= index_A_pass_7(5);
				end if;
			when A_5_6 =>
				if A_pass_7(6) > B_pass_7(2) or A_pass_7(6) = B_pass_7(2) then
					m_8(7) 		 <= B_pass_7(2);
					index_m_8(7) <= index_B_pass_7(2);
				else
					m_8(7) 		 <= A_pass_7(6);
					index_m_8(7) <= index_A_pass_7(6);
				end if;
			when A_6_6 =>
				if A_pass_7(7) > B_pass_7(0) then
					m_8(7) 		 <= B_pass_7(0);
					index_m_8(7) <= index_B_pass_7(0);
				else
					m_8(7) 		 <= A_pass_7(7);
					index_m_8(7) <= index_A_pass_7(7);
				end if;
			when B_0_6 =>
				if A_pass_7(6) > B_pass_7(1) or A_pass_7(6) = B_pass_7(1) then
					m_8(7) 		 <= B_pass_7(1);
					index_m_8(7) <= index_B_pass_7(1);
				else
					m_8(7) 		 <= A_pass_7(6);
					index_m_8(7) <= index_A_pass_7(6);
				end if;
			when B_1_6 =>
				if A_pass_7(5) > B_pass_7(2) or A_pass_7(5) = B_pass_7(2) then
					m_8(7) 		 <= B_pass_7(2);
					index_m_8(7) <= index_B_pass_7(2);
				else
					m_8(7) 		 <= A_pass_7(5);
					index_m_8(7) <= index_A_pass_7(5);
				end if;
			when B_2_6 =>
				if A_pass_7(4) > B_pass_7(3) or A_pass_7(4) = B_pass_7(3) then
					m_8(7) 		 <= B_pass_7(3);
					index_m_8(7) <= index_B_pass_7(3);
				else
					m_8(7) 		 <= A_pass_7(4);
					index_m_8(7) <= index_A_pass_7(4);
				end if;
			when B_3_6 =>
				if A_pass_7(3) > B_pass_7(4) or A_pass_7(3) = B_pass_7(4) then
					m_8(7) 		 <= B_pass_7(4);
					index_m_8(7) <= index_B_pass_7(4);
				else
					m_8(7) 		 <= A_pass_7(3);
					index_m_8(7) <= index_A_pass_7(3);
				end if;
			when B_4_6 =>
				if A_pass_7(2) > B_pass_7(5) or A_pass_7(2) = B_pass_7(5) then
					m_8(7) 		 <= B_pass_7(5);
					index_m_8(7) <= index_B_pass_7(5);
				else
					m_8(7) 		 <= A_pass_7(2);
					index_m_8(7) <= index_A_pass_7(2);
				end if;
			when B_5_6 =>
				if A_pass_7(1) > B_pass_7(6) or A_pass_7(1) = B_pass_7(6) then
					m_8(7) 		 <= B_pass_7(6);
					index_m_8(7) <= index_B_pass_7(6);
				else
					m_8(7) 		 <= A_pass_7(1);
					index_m_8(7) <= index_A_pass_7(1);
				end if;
			when B_6_6 =>
				if A_pass_7(0) > B_pass_7(7) or A_pass_7(0) = B_pass_7(7) then
					m_8(7) 		 <= B_pass_7(7);
					index_m_8(7) <= index_B_pass_7(7);
				else
					m_8(7) 		 <= A_pass_7(0);
					index_m_8(7) <= index_A_pass_7(0);
				end if;		
		end case;
	end if;
end process;
------------------------------------------------------------------------------------------------------------
-- Define processes : (CLK 10)
------------------------------------------------------------------------------------------------------------
process(clk, reset)
begin
	if (reset = '1') then
		index           <= (others => (others => '0'));
		soft_output     <= (others => (others => '0'));
    elsif (rising_edge(clk)) then    
		index           <= index_m_8;
		soft_output     <= m_8;
	end if;
end process;
end architecture;