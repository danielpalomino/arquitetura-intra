LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;
LIBRARY WORK;
USE WORK.INTRA_LIBRARY.ALL;

ENTITY intra_po IS
	GENERIC (n: INTEGER:= 8);
	PORT (
		clk, reset						: IN STD_LOGIC;
		--CONTROLE DATA PATH
		sample_sel_data_path_a		: IN STD_LOGIC;
		sample_sel_data_path_l		: IN STD_LOGIC;
		bs_selector0_data_path_a0	: IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		bs_selector1_data_path_a0	: IN STD_LOGIC_VECTOR(4 DOWNTO 0);		
		bs_selector0_data_path_a1	: IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		bs_selector1_data_path_a1	: IN STD_LOGIC_VECTOR(4 DOWNTO 0);		
		bs_selector0_data_path_a2	: IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		bs_selector1_data_path_a2	: IN STD_LOGIC_VECTOR(4 DOWNTO 0);		
		bs_selector0_data_path_a3	: IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		bs_selector1_data_path_a3	: IN STD_LOGIC_VECTOR(4 DOWNTO 0);		
		bs_selector0_data_path_l0	: IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		bs_selector1_data_path_l0	: IN STD_LOGIC_VECTOR(4 DOWNTO 0);		
		bs_selector0_data_path_l1	: IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		bs_selector1_data_path_l1	: IN STD_LOGIC_VECTOR(4 DOWNTO 0);		
		bs_selector0_data_path_l2	: IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		bs_selector1_data_path_l2	: IN STD_LOGIC_VECTOR(4 DOWNTO 0);		
		bs_selector0_data_path_l3	: IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		bs_selector1_data_path_l3	: IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		--CONTROLE ORIGINAL BUFFER
		enable_a_original_buffer	: IN STD_LOGIC;
		enable_l_original_buffer	: IN STD_LOGIC;
		--CONTROLE NEIGHBOR BUFFER
		enable_neighbor_buffer		: IN STD_LOGIC;
		mux_above_neighbor_buffer	: IN STD_LOGIC_VECTOR(6 DOWNTO 0);
		mux_left_neighbor_buffer	: IN STD_LOGIC_VECTOR(6 DOWNTO 0);
		--CONTROLE SAD BUFFER
		enable_modes_sad_buffer_above	: IN STD_LOGIC_VECTOR(16 DOWNTO 0);
		enable_modes_sad_buffer_left	: IN STD_LOGIC_VECTOR(16 DOWNTO 0);
		--ENTRADAS
		input_neighbor					: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		input_original_above			: IN STD_LOGIC_VECTOR ((n*4)-1 DOWNTO 0);
		input_original_left			: IN STD_LOGIC_VECTOR ((n*4)-1 DOWNTO 0);
		--SAIDAS
		output_sad_above				: OUT STD_LOGIC_VECTOR(n+23 DOWNTO 0);
		output_sad_left				: OUT STD_LOGIC_VECTOR(n+23 DOWNTO 0)
		);
END intra_po;

ARCHITECTURE behavior OF intra_po IS

SIGNAL neighbor_above0	: STD_LOGIC_VECTOR(n-1 DOWNTO 0);
SIGNAL neighbor_above1	: STD_LOGIC_VECTOR(n-1 DOWNTO 0);
SIGNAL neighbor_above2	: STD_LOGIC_VECTOR(n-1 DOWNTO 0);
SIGNAL neighbor_above3	: STD_LOGIC_VECTOR(n-1 DOWNTO 0);
SIGNAL neighbor_above4	: STD_LOGIC_VECTOR(n-1 DOWNTO 0);
SIGNAL neighbor_left0	: STD_LOGIC_VECTOR(n-1 DOWNTO 0);
SIGNAL neighbor_left1	: STD_LOGIC_VECTOR(n-1 DOWNTO 0);
SIGNAL neighbor_left2	: STD_LOGIC_VECTOR(n-1 DOWNTO 0);
SIGNAL neighbor_left3	: STD_LOGIC_VECTOR(n-1 DOWNTO 0);
SIGNAL neighbor_left4	: STD_LOGIC_VECTOR(n-1 DOWNTO 0);

SIGNAL original_a0	:  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
SIGNAL original_a1	:  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
SIGNAL original_a2	:  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
SIGNAL original_a3	:  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
SIGNAL original_l0	:  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
SIGNAL original_l1	:  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
SIGNAL original_l2	:  STD_LOGIC_VECTOR(n-1 DOWNTO 0);
SIGNAL original_l3	:  STD_LOGIC_VECTOR(n-1 DOWNTO 0);

SIGNAL residual_above0	: STD_LOGIC_VECTOR(n+3 DOWNTO 0);
SIGNAL residual_above1	: STD_LOGIC_VECTOR(n+3 DOWNTO 0);
SIGNAL residual_above2	: STD_LOGIC_VECTOR(n+3 DOWNTO 0);
SIGNAL residual_above3	: STD_LOGIC_VECTOR(n+3 DOWNTO 0);
SIGNAL residual_left0	: STD_LOGIC_VECTOR(n+3 DOWNTO 0);
SIGNAL residual_left1	: STD_LOGIC_VECTOR(n+3 DOWNTO 0);
SIGNAL residual_left2	: STD_LOGIC_VECTOR(n+3 DOWNTO 0);
SIGNAL residual_left3	: STD_LOGIC_VECTOR(n+3 DOWNTO 0);

SIGNAL sad_above	: STD_LOGIC_VECTOR(n+5 DOWNTO 0);
SIGNAL sad_left	: STD_LOGIC_VECTOR(n+5 DOWNTO 0);

BEGIN

	NEIGHBOR_BUFFER0: neighbor_buffer GENERIC MAP (n) PORT MAP(
	clk 					=> clk,
	reset 				=> reset,
	enable 				=> enable_neighbor_buffer,
	mux_above 			=> mux_above_neighbor_buffer,
	mux_left				=> mux_left_neighbor_buffer,
	input_sample		=> input_neighbor,
	neighbor_above0	=> neighbor_above0,
	neighbor_above1	=> neighbor_above1,
	neighbor_above2	=> neighbor_above2,
	neighbor_above3	=> neighbor_above3,
	neighbor_above4	=> neighbor_above4,
	neighbor_left0		=> neighbor_left0,
	neighbor_left1		=> neighbor_left1,
	neighbor_left2		=> neighbor_left2,
	neighbor_left3		=> neighbor_left3,
	neighbor_left4		=> neighbor_left4
	);
	
	ORIGINAL_BUFFER0: original_buffer GENERIC MAP (n) PORT MAP(
	clk				=> clk,
	reset				=> reset,
	enable_a			=> enable_a_original_buffer,
	enable_l			=> enable_l_original_buffer,
	input_sample_above	=> input_original_above,
	input_sample_left	=> input_original_left,
	original_a0		=> original_a0,
	original_a1		=> original_a1,
	original_a2		=> original_a2,
	original_a3		=> original_a3,
	original_l0		=> original_l0,
	original_l1		=> original_l1,
	original_l2		=> original_l2,
	original_l3		=> original_l3
	);
	
	-- DATA PATHs ABOVE
	DATA_PATH0: data_path GENERIC MAP (n) PORT MAP(
	clk				=> clk,
	reset				=> reset,
	sample_sel		=> sample_sel_data_path_a,
	bs_selector0	=> bs_selector0_data_path_a0,
	bs_selector1	=> bs_selector1_data_path_a0,
	sample0			=> neighbor_above0,
	sample1			=> neighbor_above1,
	orig				=> original_a0,
	residual			=> residual_above0
	);
	
	DATA_PATH_ABOVE1: data_path GENERIC MAP (n) PORT MAP(
	clk				=> clk,
	reset				=> reset,
	sample_sel		=> sample_sel_data_path_a,
	bs_selector0	=> bs_selector0_data_path_a1,
	bs_selector1	=> bs_selector1_data_path_a1,
	sample0			=> neighbor_above1,
	sample1			=> neighbor_above2,
	orig				=> original_a1,
	residual			=> residual_above1
	);
	
	DATA_PATH_ABOVE2: data_path GENERIC MAP (n) PORT MAP(
	clk				=> clk,
	reset				=> reset,
	sample_sel		=> sample_sel_data_path_a,
	bs_selector0	=> bs_selector0_data_path_a2,
	bs_selector1	=> bs_selector1_data_path_a2,
	sample0			=> neighbor_above2,
	sample1			=> neighbor_above3,
	orig				=> original_a2,
	residual			=> residual_above2
	);
	
	DATA_PATH_ABOVE3: data_path GENERIC MAP (n) PORT MAP(
	clk				=> clk,
	reset				=> reset,
	sample_sel		=> sample_sel_data_path_a,
	bs_selector0	=> bs_selector0_data_path_a3,
	bs_selector1	=> bs_selector1_data_path_a3,
	sample0			=> neighbor_above3,
	sample1			=> neighbor_above4,
	orig				=> original_a3,
	residual			=> residual_above3
	);
	
	-- DATA PATHs LEFT
	DATA_PATH_LEFT0: data_path GENERIC MAP (n) PORT MAP(
	clk				=> clk,
	reset				=> reset,
	sample_sel		=> sample_sel_data_path_l,
	bs_selector0	=> bs_selector0_data_path_l0,
	bs_selector1	=> bs_selector1_data_path_l0,
	sample0			=> neighbor_left0,
	sample1			=> neighbor_left1,
	orig				=> original_l0,
	residual			=> residual_left0
	);
	
	DATA_PATH_LEFT1: data_path GENERIC MAP (n) PORT MAP(
	clk				=> clk,
	reset				=> reset,
	sample_sel		=> sample_sel_data_path_l,
	bs_selector0	=> bs_selector0_data_path_l1,
	bs_selector1	=> bs_selector1_data_path_l1,
	sample0			=> neighbor_left1,
	sample1			=> neighbor_left2,
	orig				=> original_l1,
	residual			=> residual_left1
	);
	
	DATA_PATH_LEFT2: data_path GENERIC MAP (n) PORT MAP(
	clk				=> clk,
	reset				=> reset,
	sample_sel		=> sample_sel_data_path_l,
	bs_selector0	=> bs_selector0_data_path_l2,
	bs_selector1	=> bs_selector1_data_path_l2,
	sample0			=> neighbor_left2,
	sample1			=> neighbor_left3,
	orig				=> original_l2,
	residual			=> residual_left2
	);
	
	DATA_PATH_LEFT3: data_path GENERIC MAP (n) PORT MAP(
	clk				=> clk,
	reset				=> reset,
	sample_sel		=> sample_sel_data_path_l,
	bs_selector0	=> bs_selector0_data_path_l3,
	bs_selector1	=> bs_selector1_data_path_l3,
	sample0			=> neighbor_left3,
	sample1			=> neighbor_left4,
	orig				=> original_l3,
	residual			=> residual_left3
	);	
	
	
	-- SAD TREE ABOVE
	SAD_TREE_ABOVE0: sad_tree GENERIC MAP (n) PORT MAP(
	clk		=> clk,
	reset		=> reset,
	sample0	=> residual_above0,
	sample1	=> residual_above1,
	sample2	=> residual_above2,
	sample3	=> residual_above3,
	sad		=> sad_above
	);
	
	SAD_TREE_LEFT0: sad_tree GENERIC MAP (n) PORT MAP(
	clk		=> clk,
	reset		=> reset,
	sample0	=> residual_left0,
	sample1	=> residual_left1,
	sample2	=> residual_left2,
	sample3	=> residual_left3,
	sad		=> sad_left
	);
	--SAD BUFFER ABOVE
	SAD_MODES_BUFFER_ABOVE0: sad_modes_buffer GENERIC MAP (n) PORT MAP(
	clk				=> clk,
	reset				=> reset,
	enable_modes	=> enable_modes_sad_buffer_above,
	sad				=> sad_above,
	acum_sad			=> output_sad_above
	);
	--SAD BUFFER LEFT
	SAD_MODES_BUFFER_LEFT0: sad_modes_buffer GENERIC MAP (n) PORT MAP(
	clk				=> clk,
	reset				=> reset,
	enable_modes	=> enable_modes_sad_buffer_left,
	sad				=> sad_left,
	acum_sad			=> output_sad_left
	);

END behavior;
