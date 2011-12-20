LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;
LIBRARY WORK;
USE WORK.INTRA_LIBRARY.ALL;

ENTITY intra_pc IS
	GENERIC (n: INTEGER:= 8);
	PORT (
		clk, reset						: IN STD_LOGIC;
		start								: IN STD_LOGIC;
		blk_size							: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		
		ready								: OUT STD_LOGIC;
		mode								: OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
		reset_buffers					: OUT STD_LOGIC;
		--MEMORY ADDRESSES
		neighbor_address				: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		original_address_l			: OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
		original_address_a			: OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
		--CONTROLE DATA PATH
		sample_sel_data_path_a		: OUT STD_LOGIC;
		sample_sel_data_path_l		: OUT STD_LOGIC;
		bs_selector0_data_path_a0	: OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
		bs_selector1_data_path_a0	: OUT STD_LOGIC_VECTOR(4 DOWNTO 0);		
		bs_selector0_data_path_a1	: OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
		bs_selector1_data_path_a1	: OUT STD_LOGIC_VECTOR(4 DOWNTO 0);		
		bs_selector0_data_path_a2	: OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
		bs_selector1_data_path_a2	: OUT STD_LOGIC_VECTOR(4 DOWNTO 0);		
		bs_selector0_data_path_a3	: OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
		bs_selector1_data_path_a3	: OUT STD_LOGIC_VECTOR(4 DOWNTO 0);		
		bs_selector0_data_path_l0	: OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
		bs_selector1_data_path_l0	: OUT STD_LOGIC_VECTOR(4 DOWNTO 0);		
		bs_selector0_data_path_l1	: OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
		bs_selector1_data_path_l1	: OUT STD_LOGIC_VECTOR(4 DOWNTO 0);		
		bs_selector0_data_path_l2	: OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
		bs_selector1_data_path_l2	: OUT STD_LOGIC_VECTOR(4 DOWNTO 0);		
		bs_selector0_data_path_l3	: OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
		bs_selector1_data_path_l3	: OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
		--CONTROLE ORIGINAL BUFFER
		enable_a_original_buffer	: OUT STD_LOGIC;
		enable_l_original_buffer	: OUT STD_LOGIC;
		--CONTROLE NEIGHBOR BUFFER
		enable_neighbor_buffer		: OUT STD_LOGIC;
		mux_above_neighbor_buffer	: OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		mux_left_neighbor_buffer	: OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
		--CONTROLE SAD BUFFER
		enable_modes_sad_buffer_above	: OUT STD_LOGIC_VECTOR(16 DOWNTO 0);
		enable_modes_sad_buffer_left	: OUT STD_LOGIC_VECTOR(16 DOWNTO 0)
		);
END intra_pc;

ARCHITECTURE behavior OF intra_pc IS

SIGNAL cs, ns: fsm;
TYPE angle_table IS ARRAY (1 TO 17) OF INTEGER;
SIGNAL modes_angle: angle_table := (-32,-26,-21,-17,-13,-9,-5,-2,0,2,5,9,13,17,21,26,32);

BEGIN

	PROCESS (clk, reset)
	BEGIN
		IF(reset='1') THEN
			cs <= idle;
		ELSIF clk'EVENT AND clk='1' THEN
			cs <= ns;
		END IF;
	END PROCESS;
	
	PROCESS (cs,start)
	VARIABLE int_neighbor_address: INTEGER;
	VARIABLE line_above: INTEGER;
	VARIABLE line_left: INTEGER;
	VARIABLE col_left: INTEGER;
	VARIABLE col_above: INTEGER;
	BEGIN
		--BLOCO 64
		IF blk_size = "000" THEN
			CASE cs IS
				WHEN idle =>
					int_neighbor_address			:= 0;
					line_above						:= 0;
					line_left						:= 0;
					col_above						:= 0;
					col_left							:= 0;
					
					ready 							<= '0';
					mode 								<= "000000";
					reset_buffers 					<= '0';
					--MEMORY ADDRESSES
					neighbor_address				<= "00000000";
					original_address_a			<= "0000000000";
					original_address_l			<= "0000000000";
					--CONTROLE DATA PATH
					sample_sel_data_path_a		<= '0';
					sample_sel_data_path_l		<= '0';
					bs_selector0_data_path_a0	<= "00000";
					bs_selector1_data_path_a0	<= "00000";
					bs_selector0_data_path_a1	<= "00000";
					bs_selector1_data_path_a1	<= "00000";
					bs_selector0_data_path_a2	<= "00000";
					bs_selector1_data_path_a2	<= "00000";
					bs_selector0_data_path_a3	<= "00000";
					bs_selector1_data_path_a3	<= "00000";		
					bs_selector0_data_path_l0	<= "00000";
					bs_selector1_data_path_l0	<= "00000";		
					bs_selector0_data_path_l1	<= "00000";
					bs_selector1_data_path_l1	<= "00000";		
					bs_selector0_data_path_l2	<= "00000";
					bs_selector1_data_path_l2	<= "00000";		
					bs_selector0_data_path_l3	<= "00000";
					bs_selector1_data_path_l3	<= "00000";
					enable_a_original_buffer	<= '0';
					enable_l_original_buffer	<= '0';
					enable_neighbor_buffer		<= '0';
					mux_above_neighbor_buffer	<= "0000000";
					mux_left_neighbor_buffer	<= "0000000";
					enable_modes_sad_buffer_above	<= "00000000000000000";
					enable_modes_sad_buffer_left	<= "00000000000000000";
					IF start = '1' then
						ns <= load_neighbors;
					ELSE
						ns <= idle;
					END IF;
					
				WHEN load_neighbors =>
					neighbor_address				<= conv_std_logic_vector(int_neighbor_address,8);
					enable_neighbor_buffer		<= '1';
					IF int_neighbor_address < 129 THEN
						ns <= load_neighbors;
					ELSE
						ns <= load_original;
					END IF;
					int_neighbor_address	:= int_neighbor_address + 1;
					
				WHEN load_original =>
					enable_a_original_buffer <= '1';
					enable_l_original_buffer <= '1';
					original_address_a   	 <= conv_std_logic_vector((line_above*16+col_above),10);
					original_address_l		 <= conv_std_logic_vector((line_left*16+col_left),10);					
					
					line_above := line_above + 1;
					line_left := line_left + 1;
					
					ns <= load_original_left3;
					
				WHEN load_original_left3 =>
					enable_a_original_buffer <= '0';
					original_address_l		 <= conv_std_logic_vector((line_left*16+col_left),10);
					line_left := line_left + 1;
					IF line_left < 4 THEN
						ns <= load_original_left3;
					ELSE
						ns <= compute_mode_9_25;
					END IF;
				
				WHEN compute_mode_9_25 =>
					enable_modes_sad_buffer_above	<= "00000000100000000";
					enable_modes_sad_buffer_left	<= "00000000100000000";
					
					sample_sel_data_path_a	 <= '0';
					sample_sel_data_path_l	 <= '0';
					enable_a_original_buffer <= '1';
					enable_l_original_buffer <= '1';
					original_address_a   	 <= conv_std_logic_vector((line_above*16+col_above),10);
					original_address_l		 <= conv_std_logic_vector((line_left*16+col_left),10);
					line_above := line_above + 1;
					line_left := line_left + 1;
				
					IF (line_above = 63) THEN
						line_above := 0;
						col_above := col_above + 1;
					END IF;
					
					IF (line_left = 63) THEN
						line_left := 0;
						col_left := col_left + 1;
					END IF;
					
					IF (col_above = 15 and line_above = 63) THEN
						ns <= final0;
					END IF;
					
					mux_above_neighbor_buffer	<= conv_std_logic_vector(60, 7) - 
															conv_std_logic_vector(col_above,7) - 
															(conv_std_logic_vector(line_above * modes_angle(9), 7));
		
					mux_left_neighbor_buffer	<= conv_std_logic_vector(60, 7) - 
															conv_std_logic_vector(col_above,7) - 
															(conv_std_logic_vector(line_above * modes_angle(9), 7));
					
					
					ns <= compute_mode_9_25;
				
				WHEN compute_mode_1_1 =>
					ns <= final0;
				WHEN compute_mode_2_18 =>
					ns <= final0;
				WHEN compute_mode_3_19 =>
					ns <= final0;
				WHEN compute_mode_4_20 =>
					ns <= final0;
				WHEN compute_mode_5_21 =>
					ns <= final0;
				WHEN compute_mode_6_22 =>
					ns <= final0;
				WHEN compute_mode_7_23 =>
					ns <= final0;
				WHEN compute_mode_8_24 =>
					ns <= final0;
				WHEN compute_mode_10_26 =>
					ns <= final0;
				WHEN compute_mode_11_27 =>
					ns <= final0;
				WHEN compute_mode_12_28 =>
					ns <= final0;
				WHEN compute_mode_13_29 =>
					ns <= final0;
				WHEN compute_mode_14_30 =>
					ns <= final0;
				WHEN compute_mode_15_31 =>
					ns <= final0;
				WHEN compute_mode_16_32 =>
					ns <= final0;
				WHEN compute_mode_17_33 =>
					ns <= final0;
				
				WHEN final0 =>
					ns <= final1;
				WHEN final1 =>
					ns <= final2;
				WHEN final2 =>
					ns <= final3;
				WHEN final3 =>
					ns <= final4;
				WHEN final4 =>
					ns <= final5;
				WHEN final5 =>
					ns <= idle;

			END CASE;
		--BLOCO 32
		ELSIF blk_size = "001" THEN
			CASE cs IS
				WHEN idle =>
					int_neighbor_address			:= 0;
					line_above						:= 0;
					line_left						:= 0;
					col_above						:= 0;
					col_left							:= 0;
					
					ready 							<= '0';
					mode 								<= "000000";
					reset_buffers 					<= '0';
					--MEMORY ADDRESSES
					neighbor_address				<= "00000000";
					original_address_a			<= "0000000000";
					original_address_l			<= "0000000000";
					--CONTROLE DATA PATH
					sample_sel_data_path_a		<= '0';
					sample_sel_data_path_l		<= '0';
					bs_selector0_data_path_a0	<= "00000";
					bs_selector1_data_path_a0	<= "00000";
					bs_selector0_data_path_a1	<= "00000";
					bs_selector1_data_path_a1	<= "00000";
					bs_selector0_data_path_a2	<= "00000";
					bs_selector1_data_path_a2	<= "00000";
					bs_selector0_data_path_a3	<= "00000";
					bs_selector1_data_path_a3	<= "00000";		
					bs_selector0_data_path_l0	<= "00000";
					bs_selector1_data_path_l0	<= "00000";		
					bs_selector0_data_path_l1	<= "00000";
					bs_selector1_data_path_l1	<= "00000";		
					bs_selector0_data_path_l2	<= "00000";
					bs_selector1_data_path_l2	<= "00000";		
					bs_selector0_data_path_l3	<= "00000";
					bs_selector1_data_path_l3	<= "00000";
					enable_a_original_buffer	<= '0';
					enable_l_original_buffer	<= '0';
					enable_neighbor_buffer		<= '0';
					mux_above_neighbor_buffer	<= "0000000";
					mux_left_neighbor_buffer	<= "0000000";
					enable_modes_sad_buffer_above	<= "00000000000000000";
					enable_modes_sad_buffer_left	<= "00000000000000000";
					IF start = '1' then
						ns <= load_neighbors;
					ELSE
						ns <= idle;
					END IF;
					
				WHEN load_neighbors =>
					neighbor_address				<= conv_std_logic_vector(int_neighbor_address,8);
					enable_neighbor_buffer		<= '1';
					IF int_neighbor_address < 129 THEN
						ns <= load_neighbors;
					ELSE
						ns <= load_original;
					END IF;
					int_neighbor_address	:= int_neighbor_address + 1;
					
				WHEN load_original =>
					enable_a_original_buffer <= '1';
					enable_l_original_buffer <= '1';
					original_address_a   	 <= conv_std_logic_vector((line_above*16+col_above),10);
					original_address_l		 <= conv_std_logic_vector((line_left*16+col_left),10);					
					
					line_above := line_above + 1;
					line_left := line_left + 1;
					
					ns <= load_original_left3;
					
				WHEN load_original_left3 =>
					enable_a_original_buffer <= '0';
					original_address_l		 <= conv_std_logic_vector((line_left*16+col_left),10);
					line_left := line_left + 1;
					IF line_left < 4 THEN
						ns <= load_original_left3;
					ELSE
						ns <= compute_mode_1_1;
					END IF;
				
				WHEN compute_mode_1_1 =>
					enable_modes_sad_buffer_above	<= "00000000000000001";
					enable_modes_sad_buffer_left	<= "00000000000000001";
					
					sample_sel_data_path_a	 <= '0';
					sample_sel_data_path_l	 <= '0';
					enable_a_original_buffer <= '1';
					enable_l_original_buffer <= '1';
					original_address_a   	 <= conv_std_logic_vector((line_above*8+col_above),10);
					original_address_l		 <= conv_std_logic_vector((line_left*8+col_left),10);
					line_above := line_above + 1;
					line_left := line_left + 1;
				
					IF (line_above = 31) THEN
						line_above := 0;
						col_above := col_above + 1;
					END IF;
					
					IF (line_left = 31) THEN
						line_left := 0;
						col_left := col_left + 1;
					END IF;
					
					IF (col_above = 7 and line_above = 31) THEN
						ns <= final0;
					END IF;
					
					mux_above_neighbor_buffer	<= conv_std_logic_vector(60, 7) - 
															conv_std_logic_vector(col_above,7) - 
															(conv_std_logic_vector(line_above * modes_angle(1), 7));
		
					mux_left_neighbor_buffer	<= conv_std_logic_vector(60, 7) - 
															conv_std_logic_vector(col_above,7) - 
															(conv_std_logic_vector(line_above * modes_angle(1), 7));
					
					
					ns <= compute_mode_2_18;
					
				WHEN compute_mode_2_18 =>
					enable_modes_sad_buffer_above	<= "00000000000000010";
					enable_modes_sad_buffer_left	<= "00000000000000010";
					
					sample_sel_data_path_a	 <= '0';
					sample_sel_data_path_l	 <= '0';
					enable_a_original_buffer <= '1';
					enable_l_original_buffer <= '1';
					original_address_a   	 <= conv_std_logic_vector((line_above*8+col_above),10);
					original_address_l		 <= conv_std_logic_vector((line_left*8+col_left),10);
					line_above := line_above + 1;
					line_left := line_left + 1;
				
					IF (line_above = 31) THEN
						line_above := 0;
						col_above := col_above + 1;
					END IF;
					
					IF (line_left = 31) THEN
						line_left := 0;
						col_left := col_left + 1;
					END IF;
					
					IF (col_above = 7 and line_above = 31) THEN
						ns <= final0;
					END IF;
					
					mux_above_neighbor_buffer	<= conv_std_logic_vector(60, 7) - 
															conv_std_logic_vector(col_above,7) - 
															(conv_std_logic_vector(line_above * modes_angle(2), 7));
		
					mux_left_neighbor_buffer	<= conv_std_logic_vector(60, 7) - 
															conv_std_logic_vector(col_above,7) - 
															(conv_std_logic_vector(line_above * modes_angle(2), 7));
					
					
					ns <= compute_mode_3_19;
					
				WHEN compute_mode_3_19 =>
					enable_modes_sad_buffer_above	<= "00000000000000100";
					enable_modes_sad_buffer_left	<= "00000000000000100";
					
					sample_sel_data_path_a	 <= '0';
					sample_sel_data_path_l	 <= '0';
					enable_a_original_buffer <= '1';
					enable_l_original_buffer <= '1';
					original_address_a   	 <= conv_std_logic_vector((line_above*8+col_above),10);
					original_address_l		 <= conv_std_logic_vector((line_left*8+col_left),10);
					line_above := line_above + 1;
					line_left := line_left + 1;
				
					IF (line_above = 31) THEN
						line_above := 0;
						col_above := col_above + 1;
					END IF;
					
					IF (line_left = 31) THEN
						line_left := 0;
						col_left := col_left + 1;
					END IF;
					
					IF (col_above = 7 and line_above = 31) THEN
						ns <= final0;
					END IF;
					
					mux_above_neighbor_buffer	<= conv_std_logic_vector(60, 7) - 
															conv_std_logic_vector(col_above,7) - 
															(conv_std_logic_vector(line_above * modes_angle(3), 7));
		
					mux_left_neighbor_buffer	<= conv_std_logic_vector(60, 7) - 
															conv_std_logic_vector(col_above,7) - 
															(conv_std_logic_vector(line_above * modes_angle(3), 7));
					
					
					ns <= compute_mode_4_20;
					
				WHEN compute_mode_4_20 =>
					enable_modes_sad_buffer_above	<= "00000000000001000";
					enable_modes_sad_buffer_left	<= "00000000000001000";
					
					sample_sel_data_path_a	 <= '0';
					sample_sel_data_path_l	 <= '0';
					enable_a_original_buffer <= '1';
					enable_l_original_buffer <= '1';
					original_address_a   	 <= conv_std_logic_vector((line_above*8+col_above),10);
					original_address_l		 <= conv_std_logic_vector((line_left*8+col_left),10);
					line_above := line_above + 1;
					line_left := line_left + 1;
				
					IF (line_above = 31) THEN
						line_above := 0;
						col_above := col_above + 1;
					END IF;
					
					IF (line_left = 31) THEN
						line_left := 0;
						col_left := col_left + 1;
					END IF;
					
					IF (col_above = 7 and line_above = 31) THEN
						ns <= final0;
					END IF;
					
					mux_above_neighbor_buffer	<= conv_std_logic_vector(60, 7) - 
															conv_std_logic_vector(col_above,7) - 
															(conv_std_logic_vector(line_above * modes_angle(4), 7));
		
					mux_left_neighbor_buffer	<= conv_std_logic_vector(60, 7) - 
															conv_std_logic_vector(col_above,7) - 
															(conv_std_logic_vector(line_above * modes_angle(4), 7));
					
					
					ns <= compute_mode_5_21;
					
				WHEN compute_mode_5_21 =>
					enable_modes_sad_buffer_above	<= "00000000000010000";
					enable_modes_sad_buffer_left	<= "00000000000010000";
					
					sample_sel_data_path_a	 <= '0';
					sample_sel_data_path_l	 <= '0';
					enable_a_original_buffer <= '1';
					enable_l_original_buffer <= '1';
					original_address_a   	 <= conv_std_logic_vector((line_above*8+col_above),10);
					original_address_l		 <= conv_std_logic_vector((line_left*8+col_left),10);
					line_above := line_above + 1;
					line_left := line_left + 1;
				
					IF (line_above = 31) THEN
						line_above := 0;
						col_above := col_above + 1;
					END IF;
					
					IF (line_left = 31) THEN
						line_left := 0;
						col_left := col_left + 1;
					END IF;
					
					IF (col_above = 7 and line_above = 31) THEN
						ns <= final0;
					END IF;
					
					mux_above_neighbor_buffer	<= conv_std_logic_vector(60, 7) - 
															conv_std_logic_vector(col_above,7) - 
															(conv_std_logic_vector(line_above * modes_angle(5), 7));
		
					mux_left_neighbor_buffer	<= conv_std_logic_vector(60, 7) - 
															conv_std_logic_vector(col_above,7) - 
															(conv_std_logic_vector(line_above * modes_angle(5), 7));
					
					
					ns <= compute_mode_6_22;
				
				WHEN compute_mode_6_22 =>
					enable_modes_sad_buffer_above	<= "00000000000100000";
					enable_modes_sad_buffer_left	<= "00000000000100000";
					
					sample_sel_data_path_a	 <= '0';
					sample_sel_data_path_l	 <= '0';
					enable_a_original_buffer <= '1';
					enable_l_original_buffer <= '1';
					original_address_a   	 <= conv_std_logic_vector((line_above*8+col_above),10);
					original_address_l		 <= conv_std_logic_vector((line_left*8+col_left),10);
					line_above := line_above + 1;
					line_left := line_left + 1;
				
					IF (line_above = 31) THEN
						line_above := 0;
						col_above := col_above + 1;
					END IF;
					
					IF (line_left = 31) THEN
						line_left := 0;
						col_left := col_left + 1;
					END IF;
					
					IF (col_above = 7 and line_above = 31) THEN
						ns <= final0;
					END IF;
					
					mux_above_neighbor_buffer	<= conv_std_logic_vector(60, 7) - 
															conv_std_logic_vector(col_above,7) - 
															(conv_std_logic_vector(line_above * modes_angle(6), 7));
		
					mux_left_neighbor_buffer	<= conv_std_logic_vector(60, 7) - 
															conv_std_logic_vector(col_above,7) - 
															(conv_std_logic_vector(line_above * modes_angle(6), 7));
					
					
					ns <= compute_mode_7_23;
					
				WHEN compute_mode_7_23 =>
					enable_modes_sad_buffer_above	<= "00000000001000000";
					enable_modes_sad_buffer_left	<= "00000000001000000";
					
					sample_sel_data_path_a	 <= '0';
					sample_sel_data_path_l	 <= '0';
					enable_a_original_buffer <= '1';
					enable_l_original_buffer <= '1';
					original_address_a   	 <= conv_std_logic_vector((line_above*8+col_above),10);
					original_address_l		 <= conv_std_logic_vector((line_left*8+col_left),10);
					line_above := line_above + 1;
					line_left := line_left + 1;
				
					IF (line_above = 31) THEN
						line_above := 0;
						col_above := col_above + 1;
					END IF;
					
					IF (line_left = 31) THEN
						line_left := 0;
						col_left := col_left + 1;
					END IF;
					
					IF (col_above = 7 and line_above = 31) THEN
						ns <= final0;
					END IF;
					
					mux_above_neighbor_buffer	<= conv_std_logic_vector(60, 7) - 
															conv_std_logic_vector(col_above,7) - 
															(conv_std_logic_vector(line_above * modes_angle(7), 7));
		
					mux_left_neighbor_buffer	<= conv_std_logic_vector(60, 7) - 
															conv_std_logic_vector(col_above,7) - 
															(conv_std_logic_vector(line_above * modes_angle(7), 7));
					
					
					ns <= compute_mode_8_24;
				
				WHEN compute_mode_8_24 =>
					enable_modes_sad_buffer_above	<= "00000000010000000";
					enable_modes_sad_buffer_left	<= "00000000010000000";
					
					sample_sel_data_path_a	 <= '0';
					sample_sel_data_path_l	 <= '0';
					enable_a_original_buffer <= '1';
					enable_l_original_buffer <= '1';
					original_address_a   	 <= conv_std_logic_vector((line_above*8+col_above),10);
					original_address_l		 <= conv_std_logic_vector((line_left*8+col_left),10);
					line_above := line_above + 1;
					line_left := line_left + 1;
				
					IF (line_above = 31) THEN
						line_above := 0;
						col_above := col_above + 1;
					END IF;
					
					IF (line_left = 31) THEN
						line_left := 0;
						col_left := col_left + 1;
					END IF;
					
					IF (col_above = 7 and line_above = 31) THEN
						ns <= final0;
					END IF;
					
					mux_above_neighbor_buffer	<= conv_std_logic_vector(60, 7) - 
															conv_std_logic_vector(col_above,7) - 
															(conv_std_logic_vector(line_above * modes_angle(8), 7));
		
					mux_left_neighbor_buffer	<= conv_std_logic_vector(60, 7) - 
															conv_std_logic_vector(col_above,7) - 
															(conv_std_logic_vector(line_above * modes_angle(8), 7));
					
					
					ns <= compute_mode_9_25;
				
				WHEN compute_mode_9_25 =>
					enable_modes_sad_buffer_above	<= "00000000100000000";
					enable_modes_sad_buffer_left	<= "00000000100000000";
					
					sample_sel_data_path_a	 <= '0';
					sample_sel_data_path_l	 <= '0';
					enable_a_original_buffer <= '1';
					enable_l_original_buffer <= '1';
					original_address_a   	 <= conv_std_logic_vector((line_above*8+col_above),10);
					original_address_l		 <= conv_std_logic_vector((line_left*8+col_left),10);
					line_above := line_above + 1;
					line_left := line_left + 1;
				
					IF (line_above = 31) THEN
						line_above := 0;
						col_above := col_above + 1;
					END IF;
					
					IF (line_left = 31) THEN
						line_left := 0;
						col_left := col_left + 1;
					END IF;
					
					IF (col_above = 7 and line_above = 31) THEN
						ns <= final0;
					END IF;
					
					mux_above_neighbor_buffer	<= conv_std_logic_vector(60, 7) - 
															conv_std_logic_vector(col_above,7) - 
															(conv_std_logic_vector(line_above * modes_angle(9), 7));
		
					mux_left_neighbor_buffer	<= conv_std_logic_vector(60, 7) - 
															conv_std_logic_vector(col_above,7) - 
															(conv_std_logic_vector(line_above * modes_angle(9), 7));
					
					
					ns <= compute_mode_10_26;					
				
				WHEN compute_mode_10_26 =>
					enable_modes_sad_buffer_above	<= "00000001000000000";
					enable_modes_sad_buffer_left	<= "00000001000000000";
					
					sample_sel_data_path_a	 <= '0';
					sample_sel_data_path_l	 <= '0';
					enable_a_original_buffer <= '1';
					enable_l_original_buffer <= '1';
					original_address_a   	 <= conv_std_logic_vector((line_above*8+col_above),10);
					original_address_l		 <= conv_std_logic_vector((line_left*8+col_left),10);
					line_above := line_above + 1;
					line_left := line_left + 1;
				
					IF (line_above = 31) THEN
						line_above := 0;
						col_above := col_above + 1;
					END IF;
					
					IF (line_left = 31) THEN
						line_left := 0;
						col_left := col_left + 1;
					END IF;
					
					IF (col_above = 7 and line_above = 31) THEN
						ns <= final0;
					END IF;
					
					mux_above_neighbor_buffer	<= conv_std_logic_vector(60, 7) - 
															conv_std_logic_vector(col_above,7) - 
															(conv_std_logic_vector(line_above * modes_angle(10), 7));
		
					mux_left_neighbor_buffer	<= conv_std_logic_vector(60, 7) - 
															conv_std_logic_vector(col_above,7) - 
															(conv_std_logic_vector(line_above * modes_angle(10), 7));
					
					
					ns <= compute_mode_11_27;
				
				WHEN compute_mode_11_27 =>
					enable_modes_sad_buffer_above	<= "00000010000000000";
					enable_modes_sad_buffer_left	<= "00000010000000000";
					
					sample_sel_data_path_a	 <= '0';
					sample_sel_data_path_l	 <= '0';
					enable_a_original_buffer <= '1';
					enable_l_original_buffer <= '1';
					original_address_a   	 <= conv_std_logic_vector((line_above*8+col_above),10);
					original_address_l		 <= conv_std_logic_vector((line_left*8+col_left),10);
					line_above := line_above + 1;
					line_left := line_left + 1;
				
					IF (line_above = 31) THEN
						line_above := 0;
						col_above := col_above + 1;
					END IF;
					
					IF (line_left = 31) THEN
						line_left := 0;
						col_left := col_left + 1;
					END IF;
					
					IF (col_above = 7 and line_above = 31) THEN
						ns <= final0;
					END IF;
					
					mux_above_neighbor_buffer	<= conv_std_logic_vector(60, 7) - 
															conv_std_logic_vector(col_above,7) - 
															(conv_std_logic_vector(line_above * modes_angle(11), 7));
		
					mux_left_neighbor_buffer	<= conv_std_logic_vector(60, 7) - 
															conv_std_logic_vector(col_above,7) - 
															(conv_std_logic_vector(line_above * modes_angle(11), 7));
					
					
					ns <= compute_mode_12_28;
					
				WHEN compute_mode_12_28 =>
					enable_modes_sad_buffer_above	<= "00000100000000000";
					enable_modes_sad_buffer_left	<= "00000100000000000";
					
					sample_sel_data_path_a	 <= '0';
					sample_sel_data_path_l	 <= '0';
					enable_a_original_buffer <= '1';
					enable_l_original_buffer <= '1';
					original_address_a   	 <= conv_std_logic_vector((line_above*8+col_above),10);
					original_address_l		 <= conv_std_logic_vector((line_left*8+col_left),10);
					line_above := line_above + 1;
					line_left := line_left + 1;
				
					IF (line_above = 31) THEN
						line_above := 0;
						col_above := col_above + 1;
					END IF;
					
					IF (line_left = 31) THEN
						line_left := 0;
						col_left := col_left + 1;
					END IF;
					
					IF (col_above = 7 and line_above = 31) THEN
						ns <= final0;
					END IF;
					
					mux_above_neighbor_buffer	<= conv_std_logic_vector(60, 7) - 
															conv_std_logic_vector(col_above,7) - 
															(conv_std_logic_vector(line_above * modes_angle(12), 7));
		
					mux_left_neighbor_buffer	<= conv_std_logic_vector(60, 7) - 
															conv_std_logic_vector(col_above,7) - 
															(conv_std_logic_vector(line_above * modes_angle(12), 7));
					
					
					ns <= compute_mode_13_29;
				
				WHEN compute_mode_13_29 =>
					enable_modes_sad_buffer_above	<= "00001000000000000";
					enable_modes_sad_buffer_left	<= "00001000000000000";
					
					sample_sel_data_path_a	 <= '0';
					sample_sel_data_path_l	 <= '0';
					enable_a_original_buffer <= '1';
					enable_l_original_buffer <= '1';
					original_address_a   	 <= conv_std_logic_vector((line_above*8+col_above),10);
					original_address_l		 <= conv_std_logic_vector((line_left*8+col_left),10);
					line_above := line_above + 1;
					line_left := line_left + 1;
				
					IF (line_above = 31) THEN
						line_above := 0;
						col_above := col_above + 1;
					END IF;
					
					IF (line_left = 31) THEN
						line_left := 0;
						col_left := col_left + 1;
					END IF;
					
					IF (col_above = 7 and line_above = 31) THEN
						ns <= final0;
					END IF;
					
					mux_above_neighbor_buffer	<= conv_std_logic_vector(60, 7) - 
															conv_std_logic_vector(col_above,7) - 
															(conv_std_logic_vector(line_above * modes_angle(13), 7));
		
					mux_left_neighbor_buffer	<= conv_std_logic_vector(60, 7) - 
															conv_std_logic_vector(col_above,7) - 
															(conv_std_logic_vector(line_above * modes_angle(13), 7));
					
					
					ns <= compute_mode_14_30;
					
				WHEN compute_mode_14_30 =>
					enable_modes_sad_buffer_above	<= "00010000000000000";
					enable_modes_sad_buffer_left	<= "00010000000000000";
					
					sample_sel_data_path_a	 <= '0';
					sample_sel_data_path_l	 <= '0';
					enable_a_original_buffer <= '1';
					enable_l_original_buffer <= '1';
					original_address_a   	 <= conv_std_logic_vector((line_above*8+col_above),10);
					original_address_l		 <= conv_std_logic_vector((line_left*8+col_left),10);
					line_above := line_above + 1;
					line_left := line_left + 1;
				
					IF (line_above = 31) THEN
						line_above := 0;
						col_above := col_above + 1;
					END IF;
					
					IF (line_left = 31) THEN
						line_left := 0;
						col_left := col_left + 1;
					END IF;
					
					IF (col_above = 7 and line_above = 31) THEN
						ns <= final0;
					END IF;
					
					mux_above_neighbor_buffer	<= conv_std_logic_vector(60, 7) - 
															conv_std_logic_vector(col_above,7) - 
															(conv_std_logic_vector(line_above * modes_angle(14), 7));
		
					mux_left_neighbor_buffer	<= conv_std_logic_vector(60, 7) - 
															conv_std_logic_vector(col_above,7) - 
															(conv_std_logic_vector(line_above * modes_angle(14), 7));
					
					
					ns <= compute_mode_15_31;
				
				WHEN compute_mode_15_31 =>
					enable_modes_sad_buffer_above	<= "00100000000000000";
					enable_modes_sad_buffer_left	<= "00100000000000000";
					
					sample_sel_data_path_a	 <= '0';
					sample_sel_data_path_l	 <= '0';
					enable_a_original_buffer <= '1';
					enable_l_original_buffer <= '1';
					original_address_a   	 <= conv_std_logic_vector((line_above*8+col_above),10);
					original_address_l		 <= conv_std_logic_vector((line_left*8+col_left),10);
					line_above := line_above + 1;
					line_left := line_left + 1;
				
					IF (line_above = 31) THEN
						line_above := 0;
						col_above := col_above + 1;
					END IF;
					
					IF (line_left = 31) THEN
						line_left := 0;
						col_left := col_left + 1;
					END IF;
					
					IF (col_above = 7 and line_above = 31) THEN
						ns <= final0;
					END IF;
					
					mux_above_neighbor_buffer	<= conv_std_logic_vector(60, 7) - 
															conv_std_logic_vector(col_above,7) - 
															(conv_std_logic_vector(line_above * modes_angle(15), 7));
		
					mux_left_neighbor_buffer	<= conv_std_logic_vector(60, 7) - 
															conv_std_logic_vector(col_above,7) - 
															(conv_std_logic_vector(line_above * modes_angle(15), 7));
					
					
					ns <= compute_mode_16_32;
					
				WHEN compute_mode_16_32 =>
					enable_modes_sad_buffer_above	<= "01000000000000000";
					enable_modes_sad_buffer_left	<= "01000000000000000";
					
					sample_sel_data_path_a	 <= '0';
					sample_sel_data_path_l	 <= '0';
					enable_a_original_buffer <= '1';
					enable_l_original_buffer <= '1';
					original_address_a   	 <= conv_std_logic_vector((line_above*8+col_above),10);
					original_address_l		 <= conv_std_logic_vector((line_left*8+col_left),10);
					line_above := line_above + 1;
					line_left := line_left + 1;
				
					IF (line_above = 31) THEN
						line_above := 0;
						col_above := col_above + 1;
					END IF;
					
					IF (line_left = 31) THEN
						line_left := 0;
						col_left := col_left + 1;
					END IF;
					
					IF (col_above = 7 and line_above = 31) THEN
						ns <= final0;
					END IF;
					
					mux_above_neighbor_buffer	<= conv_std_logic_vector(60, 7) - 
															conv_std_logic_vector(col_above,7) - 
															(conv_std_logic_vector(line_above * modes_angle(16), 7));
		
					mux_left_neighbor_buffer	<= conv_std_logic_vector(60, 7) - 
															conv_std_logic_vector(col_above,7) - 
															(conv_std_logic_vector(line_above * modes_angle(16), 7));
					
					
					ns <= compute_mode_17_33;
					
				WHEN compute_mode_17_33 =>
					enable_modes_sad_buffer_above	<= "10000000000000000";
					enable_modes_sad_buffer_left	<= "10000000000000000";
					
					sample_sel_data_path_a	 <= '0';
					sample_sel_data_path_l	 <= '0';
					enable_a_original_buffer <= '1';
					enable_l_original_buffer <= '1';
					original_address_a   	 <= conv_std_logic_vector((line_above*8+col_above),10);
					original_address_l		 <= conv_std_logic_vector((line_left*8+col_left),10);
					line_above := line_above + 1;
					line_left := line_left + 1;
				
					IF (line_above = 31) THEN
						line_above := 0;
						col_above := col_above + 1;
					END IF;
					
					IF (line_left = 31) THEN
						line_left := 0;
						col_left := col_left + 1;
					END IF;
					
					IF (col_above = 7 and line_above = 31) THEN
						ns <= final0;
					END IF;
					
					mux_above_neighbor_buffer	<= conv_std_logic_vector(60, 7) - 
															conv_std_logic_vector(col_above,7) - 
															(conv_std_logic_vector(line_above * modes_angle(17), 7));
		
					mux_left_neighbor_buffer	<= conv_std_logic_vector(60, 7) - 
															conv_std_logic_vector(col_above,7) - 
															(conv_std_logic_vector(line_above * modes_angle(17), 7));
					
					
					ns <= final0;
					
				WHEN final0 =>
					ns <= final1;
				WHEN final1 =>
					ns <= final2;
				WHEN final2 =>
					ns <= final3;
				WHEN final3 =>
					ns <= final4;
				WHEN final4 =>
					ns <= final5;
				WHEN final5 =>
					ns <= idle;
			END CASE;
		--BLOCO 16
		ELSIF blk_size = "010" THEN
			CASE cs IS
				WHEN idle =>					
				WHEN load_neighbors =>					
				WHEN load_original =>				
				WHEN load_original_left3 =>				
				WHEN compute_mode_1_1 =>					
				WHEN compute_mode_2_18 =>				
				WHEN compute_mode_3_19 =>					
				WHEN compute_mode_4_20 =>					
				WHEN compute_mode_5_21 =>					
				WHEN compute_mode_6_22 =>					
				WHEN compute_mode_7_23 =>					
				WHEN compute_mode_8_24 =>
				WHEN compute_mode_9_25 =>					
				WHEN compute_mode_10_26 =>					
				WHEN compute_mode_11_27 =>					
				WHEN compute_mode_12_28 =>					
				WHEN compute_mode_13_29 =>					
				WHEN compute_mode_14_30 =>					
				WHEN compute_mode_15_31 =>					
				WHEN compute_mode_16_32 =>					
				WHEN compute_mode_17_33 =>				
				WHEN final0 =>
					ns <= final1;
				WHEN final1 =>
					ns <= final2;
				WHEN final2 =>
					ns <= final3;
				WHEN final3 =>
					ns <= final4;
				WHEN final4 =>
					ns <= final5;
				WHEN final5 =>
					ns <= idle;
			END CASE;
		--BLOCO 8
		ELSIF blk_size = "011" THEN
			CASE cs IS
				
				
				WHEN idle =>					
				WHEN load_neighbors =>					
				WHEN load_original =>				
				WHEN load_original_left3 =>				
				WHEN compute_mode_1_1 =>					
				WHEN compute_mode_2_18 =>				
				WHEN compute_mode_3_19 =>					
				WHEN compute_mode_4_20 =>					
				WHEN compute_mode_5_21 =>					
				WHEN compute_mode_6_22 =>					
				WHEN compute_mode_7_23 =>					
				WHEN compute_mode_8_24 =>
				WHEN compute_mode_9_25 =>					
				WHEN compute_mode_10_26 =>					
				WHEN compute_mode_11_27 =>					
				WHEN compute_mode_12_28 =>					
				WHEN compute_mode_13_29 =>					
				WHEN compute_mode_14_30 =>					
				WHEN compute_mode_15_31 =>					
				WHEN compute_mode_16_32 =>					
				WHEN compute_mode_17_33 =>				
				WHEN final0 =>
					ns <= final1;
				WHEN final1 =>
					ns <= final2;
				WHEN final2 =>
					ns <= final3;
				WHEN final3 =>
					ns <= final4;
				WHEN final4 =>
					ns <= final5;
				WHEN final5 =>
					ns <= idle;

			END CASE;
		--BLOCO 4
		ELSIF blk_size = "100" THEN
			CASE cs IS
				WHEN idle =>					
				WHEN load_neighbors =>					
				WHEN load_original =>				
				WHEN load_original_left3 =>				
				WHEN compute_mode_1_1 =>					
				WHEN compute_mode_2_18 =>				
				WHEN compute_mode_3_19 =>					
				WHEN compute_mode_4_20 =>					
				WHEN compute_mode_5_21 =>					
				WHEN compute_mode_6_22 =>					
				WHEN compute_mode_7_23 =>					
				WHEN compute_mode_8_24 =>
				WHEN compute_mode_9_25 =>					
				WHEN compute_mode_10_26 =>					
				WHEN compute_mode_11_27 =>					
				WHEN compute_mode_12_28 =>					
				WHEN compute_mode_13_29 =>					
				WHEN compute_mode_14_30 =>					
				WHEN compute_mode_15_31 =>					
				WHEN compute_mode_16_32 =>					
				WHEN compute_mode_17_33 =>				
				WHEN final0 =>
					ns <= final1;
				WHEN final1 =>
					ns <= final2;
				WHEN final2 =>
					ns <= final3;
				WHEN final3 =>
					ns <= final4;
				WHEN final4 =>
					ns <= final5;
				WHEN final5 =>
					ns <= idle;
			END CASE;
		END IF;
	END PROCESS;
	
END behavior;
