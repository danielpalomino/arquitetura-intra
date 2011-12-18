LIBRARY ieee;
USE ieee.std_logic_1164.all;

PACKAGE INTRA_LIBRARY IS

	TYPE fsm IS (idle, load_neighbors, load_original,load_original_left3,compute_mode_9_25,final0,final1,final2,final3,final4,final5);
	

	COMPONENT bs0 IS
		GENERIC (n: INTEGER:= 8);
		PORT (
			selector			: IN STD_LOGIC;
			sample			: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
			shifted_sample	: OUT STD_LOGIC_VECTOR(n+3 DOWNTO 0)
			);
	END COMPONENT;

	COMPONENT bs1 IS
		GENERIC (n: INTEGER:= 8);
		PORT (
			selector			: IN STD_LOGIC;
			sample			: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
			shifted_sample	: OUT STD_LOGIC_VECTOR(n+3 DOWNTO 0)
			);
	END COMPONENT;

	COMPONENT bs2 IS
		GENERIC (n: INTEGER:= 8);
		PORT (
			selector			: IN STD_LOGIC;
			sample			: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
			shifted_sample	: OUT STD_LOGIC_VECTOR(n+3 DOWNTO 0)
			);
	END COMPONENT;

	COMPONENT bs3 IS
		GENERIC (n: INTEGER:= 8);
		PORT (
			selector			: IN STD_LOGIC;
			sample			: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
			shifted_sample	: OUT STD_LOGIC_VECTOR(n+3 DOWNTO 0)
			);
	END COMPONENT;

	COMPONENT bs4 IS
		GENERIC (n: INTEGER:= 8);
		PORT (
			selector			: IN STD_LOGIC;
			sample			: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
			shifted_sample	: OUT STD_LOGIC_VECTOR(n+3 DOWNTO 0)
			);
	END COMPONENT;
	
	COMPONENT multiplier IS
		GENERIC (n: INTEGER:= 8);
		PORT (
			clk, reset		: IN STD_LOGIC;
			bs_selector		: IN STD_LOGIC_VECTOR(4 DOWNTO 0);
			sample			: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
			result			: OUT STD_LOGIC_VECTOR(n+6 DOWNTO 0)
			);
	END COMPONENT;
	
	COMPONENT pf IS
		GENERIC (n: INTEGER:= 8);
		PORT (
			clk,reset						: IN STD_LOGIC;
			bs_selector0, bs_selector1	: IN STD_LOGIC_VECTOR(4 DOWNTO 0);
			sample0,sample1				: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
			fract_predicted_pixel		: OUT STD_LOGIC_VECTOR(n+2 DOWNTO 0)
			);
	END COMPONENT;
	
	COMPONENT neighbor_buffer IS
		GENERIC (n: INTEGER:= 8);
		PORT (
			clk,reset		: IN STD_LOGIC;
			enable			: IN STD_LOGIC;
			mux_above		: IN STD_LOGIC_VECTOR(6 DOWNTO 0);
			mux_left			: IN STD_LOGIC_VECTOR(6 DOWNTO 0);
			input_sample	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
			neighbor_above0: OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0);
			neighbor_above1: OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0);
			neighbor_above2: OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0);
			neighbor_above3: OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0);
			neighbor_above4: OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0);
			neighbor_left0	: OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0);
			neighbor_left1	: OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0);
			neighbor_left2	: OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0);
			neighbor_left3	: OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0);
			neighbor_left4	: OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
			);
	END COMPONENT;
	
	COMPONENT original_buffer IS
		GENERIC (n: INTEGER:= 8);
		PORT (
			clk,reset	: IN STD_LOGIC;
			enable_a		: IN STD_LOGIC;
			enable_l		: IN STD_LOGIC;
			input_sample_above: IN STD_LOGIC_VECTOR((n*4)-1 DOWNTO 0);
			input_sample_left: IN STD_LOGIC_VECTOR((n*4)-1 DOWNTO 0);
			original_a0	: OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0);
			original_a1	: OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0);
			original_a2	: OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0);
			original_a3	: OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0);
			original_l0	: OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0);
			original_l1	: OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0);
			original_l2	: OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0);
			original_l3	: OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
			);
	END COMPONENT;
	
	COMPONENT data_path IS
		GENERIC (n: INTEGER:= 8);
		PORT (
			clk,reset						: IN STD_LOGIC;
			sample_sel						: IN STD_LOGIC;
			bs_selector0,bs_selector1	: IN STD_LOGIC_VECTOR(4 DOWNTO 0);
			sample0, sample1, orig		: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
			residual							: OUT STD_LOGIC_VECTOR(n+3 DOWNTO 0)
			);
	END COMPONENT;
	
	COMPONENT sad_tree IS
		GENERIC (n: INTEGER:= 8);
		PORT (
			clk,reset	: IN STD_LOGIC;
			sample0		: IN STD_LOGIC_VECTOR(n+3 DOWNTO 0);
			sample1		: IN STD_LOGIC_VECTOR(n+3 DOWNTO 0);
			sample2		: IN STD_LOGIC_VECTOR(n+3 DOWNTO 0);
			sample3		: IN STD_LOGIC_VECTOR(n+3 DOWNTO 0);		
			sad			: OUT STD_LOGIC_VECTOR(n+5 DOWNTO 0)
			);
	END COMPONENT;
	
	COMPONENT sad_modes_buffer IS
		GENERIC (n: INTEGER:= 8);
		PORT (
			clk,reset	: IN STD_LOGIC;
			enable_modes: IN STD_LOGIC_VECTOR(16 DOWNTO 0);
			sad			: IN STD_LOGIC_VECTOR(n+5 DOWNTO 0);
			acum_sad		: OUT STD_LOGIC_VECTOR(n+23 DOWNTO 0)
			);
	END COMPONENT;
	
	COMPONENT intra_po IS
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
	END COMPONENT;
	
	COMPONENT intra_pc IS
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
	END COMPONENT;
	
END INTRA_LIBRARY;