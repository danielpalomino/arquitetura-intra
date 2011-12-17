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
		original_address				: OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
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
					original_address				<= "0000000000";
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
						cs <= load_neighbors;
					ELSE
						cs <= load_original_above;
					END IF;
					int_neighbor_address	:= int_neighbor_address + 1;
					
				WHEN load_original_above =>
					enable_a_original_buffer	<= '1';
					original_address				<= conv_std_logic_vector((line_above*16+col_above),9);
					IF int_original_address_above < 1024 THEN
						line_above := line_above + 1;
					ELSE
						line_above := 0;
						col_above := col_above + 1;
					END IF;
					cs <= load_original_left;
					
				WHEN load_original_left =>
					enable_a_original_buffer <= '0';
					enable_l_original_buffer <= '1';
					original_address			 <= conv_std_logic_vector((line_left*16+col_left),9);
					IF int_original_address_left < 1024 THEN
						line_left := line_left + 1;
						IF line_left%4 == 0 THEN
							
						ELSE
							line_left := line_left + 1;
						END IF;
					ELSE
						line_left := 0;
						col_left := col_left + 1;
					cs <= compute_mode0;	
					
					
					
					
				WHEN compute_mode_9_25 =>
					enable_l_original_buffer <= '0';
					sample_sel_data_path_a	 <= '0';
					sample_sel_data_path_l	 <= '0';
					mux_above_neighbor_buffer	<= "0111100";
					mux_left_neighbor_buffer	<= "0100000";
					
					

			END CASE;
		--BLOCO 32
		ELSIF blk_size = "001" THEN
			CASE cs IS
				WHEN idle =>
				WHEN load_neighbors =>
			END CASE;
		--BLOCO 16
		ELSIF blk_size = "010" THEN
			CASE cs IS
				WHEN idle =>
				WHEN load_neighbors =>
			END CASE;
		--BLOCO 8
		ELSIF blk_size = "011" THEN
			CASE cs IS
				WHEN idle =>
				WHEN load_neighbors =>
			END CASE;
		--BLOCO 4
		ELSIF blk_size = "100" THEN
			CASE cs IS
				WHEN idle =>
				WHEN load_neighbors =>
			END CASE;
		END IF;
	END PROCESS;
	
END behavior;
