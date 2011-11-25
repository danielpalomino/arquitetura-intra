LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;
LIBRARY WORK;
USE WORK.INTRA_LIBRARY.ALL;

ENTITY multiplier IS
	GENERIC (n: INTEGER:= 8)
	PORT (
		clk, reset		: IN STD_LOGIC;
		bs_selector		: IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		sample			: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		result			: OUT STD_LOGIC_VECTOR(n+5 DOWNTO 0)
		);
END multiplier;

ARCHITECTURE behavior OF multiplier IS

SIGNAL shifted_sample0, shifted_sample1, shifted_sample2, shifted_sample3, shifted_sample4: STD_LOGIC_VECTOR(n+3 DOWNTO 0);
SIGNAL sum01, sum23, sum48: STD_LOGIC_VECTOR(n+4 DOWNTO 0);
SIGNAL sum_out: STD_LOGIC_VECTOR(n+5 DOWNTO 0);

BEGIN

SHIFTER_0: bs0 GENERIC MAP (n) PORT MAP(
selector			<= bs_selector(0),
sample			<= sample,
shifted_sample	<= shifted_sample0
);

SHIFTER_1: bs1 GENERIC MAP (n) PORT MAP(
selector			<= bs_selector(1),
sample			<= sample,
shifted_sample	<= shifted_sample1
);

SHIFTER_2: bs2 GENERIC MAP (n) PORT MAP(
selector			<= bs_selector(2),
sample			<= sample,
shifted_sample	<= shifted_sample2
);

SHIFTER_3: bs3 GENERIC MAP (n) PORT MAP(
selector			<= bs_selector(3),
sample			<= sample,
shifted_sample	<= shifted_sample3
);

SHIFTER_4: bs4 GENERIC MAP (n) PORT MAP(
selector			<= bs_selector(4),
sample			<= sample,
shifted_sample	<= shifted_sample4
);



END behavior;
