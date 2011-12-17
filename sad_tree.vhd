LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY sad_tree IS
	GENERIC (n: INTEGER:= 8);
	PORT (
		clk,reset	: IN STD_LOGIC;
		sample0		: IN STD_LOGIC_VECTOR(n+3 DOWNTO 0);
		sample1		: IN STD_LOGIC_VECTOR(n+3 DOWNTO 0);
		sample2		: IN STD_LOGIC_VECTOR(n+3 DOWNTO 0);
		sample3		: IN STD_LOGIC_VECTOR(n+3 DOWNTO 0);		
		sad			: OUT STD_LOGIC_VECTOR(n+5 DOWNTO 0)
		);
END sad_tree;



ARCHITECTURE behavior OF sad_tree IS

SIGNAL sum01,sum23	: STD_LOGIC_VECTOR(n+4 DOWNTO 0);	
SIGNAL abs_sample0	: STD_LOGIC_VECTOR(n+3 DOWNTO 0);
SIGNAL abs_sample1	: STD_LOGIC_VECTOR(n+3 DOWNTO 0);
SIGNAL abs_sample2	: STD_LOGIC_VECTOR(n+3 DOWNTO 0);
SIGNAL abs_sample3	: STD_LOGIC_VECTOR(n+3 DOWNTO 0);
SIGNAL reg_abs_sample0	: STD_LOGIC_VECTOR(n+3 DOWNTO 0);
SIGNAL reg_abs_sample1	: STD_LOGIC_VECTOR(n+3 DOWNTO 0);
SIGNAL reg_abs_sample2	: STD_LOGIC_VECTOR(n+3 DOWNTO 0);
SIGNAL reg_abs_sample3	: STD_LOGIC_VECTOR(n+3 DOWNTO 0);

BEGIN

	WITH sample0(n+3) SELECT
	abs_sample0	<=	sample0				WHEN '0',
						(not sample0) + 1 WHEN OTHERS;
	WITH sample1(n+3) SELECT
	abs_sample1	<=	sample1				WHEN '0',
						(not sample1) + 1 WHEN OTHERS;
	WITH sample2(n+3) SELECT
	abs_sample2	<=	sample2				WHEN '0',
						(not sample2) + 1 WHEN OTHERS;
	WITH sample3(n+3) SELECT
	abs_sample3	<=	sample3				WHEN '0',
						(not sample3) + 1 WHEN OTHERS;

	PROCESS (clk,reset)
	BEGIN
		IF reset = '1' THEN
			sum01 			 <= (OTHERS=>'0');
			sum23 			 <= (OTHERS=>'0');
			reg_abs_sample0 <= (OTHERS=>'0');
			reg_abs_sample1 <= (OTHERS=>'0');
			reg_abs_sample2 <= (OTHERS=>'0');
			reg_abs_sample3 <= (OTHERS=>'0');
		ELSIF clk'EVENT AND clk = '1' THEN
			reg_abs_sample0 <= abs_sample0;
			reg_abs_sample1 <= abs_sample1;
			reg_abs_sample2 <= abs_sample2;
			reg_abs_sample3 <= abs_sample3;
			sum01 			 <= (reg_abs_sample0(n+3) & reg_abs_sample0) + (reg_abs_sample1(n+3) & reg_abs_sample1);
			sum23 			 <= (reg_abs_sample2(n+3) & reg_abs_sample2) + (reg_abs_sample3(n+3) & reg_abs_sample3);
			sad				 <= (sum01(n+4) & sum01) + (sum23(n+4) & sum23);
		END IF;
	END PROCESS;	
	
END behavior;
