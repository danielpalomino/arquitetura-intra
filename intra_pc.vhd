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
	BEGIN
		--BLOCO 64
		IF blk_size = "000" THEN
			CASE cs IS
				WHEN idle =>
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
					--CONTROLE ORIGINAL BUFFER
					enable_a_original_buffer	<= '0';
					enable_l_original_buffer	<= '0';
					--CONTROLE NEIGHBOR BUFFER
					enable_neighbor_buffer		<= '0';
					mux_above_neighbor_buffer	<= "0000000";
					mux_left_neighbor_buffer	<= "0000000";
					--CONTROLE SAD BUFFER
					enable_modes_sad_buffer_above	<= "00000000000000000";
					enable_modes_sad_buffer_left	<= "00000000000000000";
					IF start = '1' then
						ns <= inicio;
					ELSE
						ns <= idle;
					END IF;
				WHEN inicio =>
			END CASE;
		--BLOCO 32
		ELSIF blk_size = "001" THEN
			CASE cs IS
				WHEN idle =>
				WHEN inicio =>
			END CASE;
		--BLOCO 16
		ELSIF blk_size = "010" THEN
			CASE cs IS
				WHEN idle =>
				WHEN inicio =>
			END CASE;
		--BLOCO 8
		ELSIF blk_size = "011" THEN
			CASE cs IS
				WHEN idle =>
				WHEN inicio =>
			END CASE;
		--BLOCO 4
		ELSIF blk_size = "100" THEN
			CASE cs IS
				WHEN idle =>
				WHEN inicio =>
			END CASE;
		END IF;
	END PROCESS;
	
END behavior;
