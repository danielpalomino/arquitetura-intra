LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;
LIBRARY WORK;
USE WORK.INTRA_LIBRARY.ALL;

ENTITY intra_prediction IS
	GENERIC(n : INTEGER := 8);
	PORT(
		clk, reset						: IN STD_LOGIC;
		--ENTRADAS
		start								: IN STD_LOGIC;
		blk_size							: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		input_neighbor					: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		input_original_above			: IN STD_LOGIC_VECTOR ((n*4)-1 DOWNTO 0);
		input_original_left			: IN STD_LOGIC_VECTOR ((n*4)-1 DOWNTO 0);
		--SAIDAS
		ready								: OUT STD_LOGIC;
		mode								: OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
		neighbor_address 				: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		original_address_l			: OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
		original_address_a 			: OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
		output_sad_above				: OUT STD_LOGIC_VECTOR(n+23 DOWNTO 0);
		output_sad_left				: OUT STD_LOGIC_VECTOR(n+23 DOWNTO 0)
	);
END intra_prediction;

ARCHITECTURE behavorial OF intra_prediction IS
	
	--CONTROLE DATA PATH
	SIGNAL sample_sel_data_path_a		: STD_LOGIC;
	SIGNAL sample_sel_data_path_l		: STD_LOGIC;
	SIGNAL bs_selector0_data_path_a0	: STD_LOGIC_VECTOR(4 DOWNTO 0);
	SIGNAL bs_selector1_data_path_a0	: STD_LOGIC_VECTOR(4 DOWNTO 0);		
	SIGNAL bs_selector0_data_path_a1	: STD_LOGIC_VECTOR(4 DOWNTO 0);
	SIGNAL bs_selector1_data_path_a1	: STD_LOGIC_VECTOR(4 DOWNTO 0);		
	SIGNAL bs_selector0_data_path_a2	: STD_LOGIC_VECTOR(4 DOWNTO 0);
	SIGNAL bs_selector1_data_path_a2	: STD_LOGIC_VECTOR(4 DOWNTO 0);		
	SIGNAL bs_selector0_data_path_a3	: STD_LOGIC_VECTOR(4 DOWNTO 0);
	SIGNAL bs_selector1_data_path_a3	: STD_LOGIC_VECTOR(4 DOWNTO 0);		
	SIGNAL bs_selector0_data_path_l0	: STD_LOGIC_VECTOR(4 DOWNTO 0);
	SIGNAL bs_selector1_data_path_l0	: STD_LOGIC_VECTOR(4 DOWNTO 0);		
	SIGNAL bs_selector0_data_path_l1	: STD_LOGIC_VECTOR(4 DOWNTO 0);
	SIGNAL bs_selector1_data_path_l1	: STD_LOGIC_VECTOR(4 DOWNTO 0);		
	SIGNAL bs_selector0_data_path_l2	: STD_LOGIC_VECTOR(4 DOWNTO 0);
	SIGNAL bs_selector1_data_path_l2	: STD_LOGIC_VECTOR(4 DOWNTO 0);		
	SIGNAL bs_selector0_data_path_l3	: STD_LOGIC_VECTOR(4 DOWNTO 0);
	SIGNAL bs_selector1_data_path_l3	: STD_LOGIC_VECTOR(4 DOWNTO 0);
	--CONTROLE ORIGINAL BUFFER
	SIGNAL enable_a_original_buffer	: STD_LOGIC;
	SIGNAL enable_l_original_buffer	: STD_LOGIC;
	--CONTROLE NEIGHBOR BUFFER
	SIGNAL enable_neighbor_buffer		: STD_LOGIC;
	SIGNAL mux_above_neighbor_buffer	: STD_LOGIC_VECTOR(6 DOWNTO 0);
	SIGNAL mux_left_neighbor_buffer	: STD_LOGIC_VECTOR(6 DOWNTO 0);
	--CONTROLE SAD BUFFER
	SIGNAL enable_modes_sad_buffer_above	: STD_LOGIC_VECTOR(16 DOWNTO 0);
	SIGNAL enable_modes_sad_buffer_left	: STD_LOGIC_VECTOR(16 DOWNTO 0);
	
	BEGIN
	
	PO_0: intra_po GENERIC map (8)
		PORT MAP (
			clk => clk,
			reset => reset,
			sample_sel_data_path_a => sample_sel_data_path_a,
			sample_sel_data_path_l => sample_sel_data_path_l,
			bs_selector0_data_path_a0 => bs_selector0_data_path_a0,
			bs_selector1_data_path_a0 => bs_selector1_data_path_a0,
			bs_selector0_data_path_a1 => bs_selector0_data_path_a1,
			bs_selector1_data_path_a1 => bs_selector1_data_path_a1,
			bs_selector0_data_path_a2 => bs_selector0_data_path_a2,
			bs_selector1_data_path_a2 => bs_selector1_data_path_a2,
			bs_selector0_data_path_a3 => bs_selector0_data_path_a3,
			bs_selector1_data_path_a3 => bs_selector1_data_path_a3,
			bs_selector0_data_path_l0 => bs_selector0_data_path_l0,
			bs_selector1_data_path_l0 => bs_selector1_data_path_l0,
			bs_selector0_data_path_l1 => bs_selector0_data_path_l1,
			bs_selector1_data_path_l1 => bs_selector1_data_path_l1,
			bs_selector0_data_path_l2 => bs_selector0_data_path_l2,
			bs_selector1_data_path_l2 => bs_selector1_data_path_l2,
			bs_selector0_data_path_l3 => bs_selector0_data_path_l3,
			bs_selector1_data_path_l3 => bs_selector1_data_path_l3,
			enable_a_original_buffer => enable_a_original_buffer,
			enable_l_original_buffer => enable_l_original_buffer,
			enable_neighbor_buffer => enable_neighbor_buffer,
			mux_above_neighbor_buffer => mux_above_neighbor_buffer,
			mux_left_neighbor_buffer => mux_left_neighbor_buffer,
			enable_modes_sad_buffer_above => enable_modes_sad_buffer_above,
			enable_modes_sad_buffer_left => enable_modes_sad_buffer_left,
			input_neighbor => input_neighbor,
			input_original_above => input_original_above,
			input_original_left => input_original_left,
			output_sad_above => output_sad_above,
			output_sad_left => output_sad_left
		);
		
	PC_0: intra_pc GENERIC MAP (8)
		PORT MAP (
			clk => clk,
			reset => reset,
			start => start,
			blk_size => blk_size,
			ready => ready,
			mode => mode,
			reset_buffers => open,
			neighbor_address => neighbor_address,
			original_address_l => original_address_l,
			original_address_a => original_address_a,
			sample_sel_data_path_a => sample_sel_data_path_a,
			sample_sel_data_path_l => sample_sel_data_path_l,
			bs_selector0_data_path_a0 => bs_selector0_data_path_a0,
			bs_selector1_data_path_a0 => bs_selector1_data_path_a0,
			bs_selector0_data_path_a1 => bs_selector0_data_path_a1,
			bs_selector1_data_path_a1 => bs_selector1_data_path_a1,
			bs_selector0_data_path_a2 => bs_selector0_data_path_a2,
			bs_selector1_data_path_a2 => bs_selector1_data_path_a2,
			bs_selector0_data_path_a3 => bs_selector0_data_path_a3,
			bs_selector1_data_path_a3 => bs_selector1_data_path_a3,
			bs_selector0_data_path_l0 => bs_selector0_data_path_l0,
			bs_selector1_data_path_l0 => bs_selector1_data_path_l0,
			bs_selector0_data_path_l1 => bs_selector0_data_path_l1,
			bs_selector1_data_path_l1 => bs_selector1_data_path_l1,
			bs_selector0_data_path_l2 => bs_selector0_data_path_l2,
			bs_selector1_data_path_l2 => bs_selector1_data_path_l2,
			bs_selector0_data_path_l3 => bs_selector0_data_path_l3,
			bs_selector1_data_path_l3 => bs_selector1_data_path_l3,
			enable_a_original_buffer => enable_a_original_buffer,
			enable_l_original_buffer => enable_l_original_buffer,
			enable_neighbor_buffer => enable_neighbor_buffer,
			mux_above_neighbor_buffer => mux_above_neighbor_buffer,
			mux_left_neighbor_buffer => mux_left_neighbor_buffer,
			enable_modes_sad_buffer_above => enable_modes_sad_buffer_above,
			enable_modes_sad_buffer_left => enable_modes_sad_buffer_left
		);

END behavorial;