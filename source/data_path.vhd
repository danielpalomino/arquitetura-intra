LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;
LIBRARY WORK;
USE WORK.INTRA_LIBRARY.ALL;

ENTITY data_path IS
	GENERIC (n: INTEGER:= 8);
	PORT (
		clk,reset						: IN STD_LOGIC;
		sample_sel						: IN STD_LOGIC;
		bs_selector0,bs_selector1	: IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		sample0, sample1, orig		: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		residual							: OUT STD_LOGIC_VECTOR(n+3 DOWNTO 0)
		);
END data_path;

ARCHITECTURE behavior OF data_path IS

SIGNAL predicted_pixel			: STD_LOGIC_VECTOR (n+2 DOWNTO 0);
SIGNAL fract_predicted_pixel	: STD_LOGIC_VECTOR (n+2 DOWNTO 0);

BEGIN

	PF_OPERATOR: pf GENERIC MAP (n) PORT MAP (
	clk 							=> clk,
	reset 						=> reset,
	bs_selector0 				=> bs_selector0,
	bs_selector1 				=> bs_selector1,
	sample0 						=> sample0,
	sample1 						=> sample1,
	fract_predicted_pixel	=> fract_predicted_pixel
	);

	WITH sample_sel SELECT
	predicted_pixel	<=	(sample0(n-1) & sample0(n-1) & sample0(n-1) & sample0)	WHEN '0',
								fract_predicted_pixel												WHEN OTHERS;

	PROCESS (clk,reset)
	BEGIN
		IF reset = '1' THEN
			residual <= (OTHERS=>'0');
		ELSIF clk'EVENT AND clk = '1' THEN
			residual <= (orig(n-1) & orig(n-1) & orig(n-1) & orig(n-1) & orig) - (predicted_pixel(n+2) & predicted_pixel);
		END IF;
	END PROCESS;					


END behavior;