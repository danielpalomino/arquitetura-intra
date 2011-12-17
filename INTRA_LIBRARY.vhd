LIBRARY ieee;
USE ieee.std_logic_1164.all;

PACKAGE INTRA_LIBRARY IS

	TYPE fsm IS (idle, inicio);

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
			input_sample: IN STD_LOGIC_VECTOR((n*4)-1 DOWNTO 0);
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
	
END INTRA_LIBRARY;