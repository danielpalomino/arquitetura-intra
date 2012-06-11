LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;
LIBRARY WORK;
USE WORK.INTRA_LIBRARY.ALL;

ENTITY pf IS
	GENERIC (n: INTEGER:= 8);
	PORT (
		clk,reset						: IN STD_LOGIC;
		bs_selector0, bs_selector1	: IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		sample0,sample1				: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		fract_predicted_pixel		: OUT STD_LOGIC_VECTOR(n+2 DOWNTO 0)
		);
END pf;

ARCHITECTURE behavior OF pf IS

SIGNAL result_mult0, result_mult1: STD_LOGIC_VECTOR(n+6 DOWNTO 0);
SIGNAL sum01: STD_LOGIC_VECTOR(n+7 DOWNTO 0);

BEGIN

MULT_0: multiplier GENERIC MAP (n) PORT MAP (
clk			=> clk,
reset			=> reset,
bs_selector => bs_selector0,
sample		=> sample0,
result		=> result_mult0
);

MULT_1: multiplier GENERIC MAP (n) PORT MAP (
clk			=> clk,
reset			=> reset,
bs_selector	=> bs_selector1,
sample		=> sample1,
result		=> result_mult1
);

sum01 <= (result_mult0(n+6) & result_mult0) + (result_mult1(n+6) & result_mult1);

PROCESS (clk,reset)
BEGIN
	IF reset = '1' THEN
		fract_predicted_pixel <= (OTHERS=>'0');
	ELSIF clk'EVENT AND clk = '1' THEN
		fract_predicted_pixel <= sum01(n+7 DOWNTO 5);
	END IF;
END PROCESS;

END behavior;
