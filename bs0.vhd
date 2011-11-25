LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY bs0 IS
	GENERIC (n: INTEGER:= 8)
	PORT (
		selector			: IN STD_LOGIC;
		sample			: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		shifted_sample	: OUT STD_LOGIC_VECTOR(n+3 DOWNTO 0)
		);
END bs0;

ARCHITECTURE behavior OF bs0 IS

BEGIN

WITH selector SELECT

	shifted_sample <=	(OTHERS=>'0')																	WHEN '0',
							sample(n-1) & sample(n-1) & sample(n-1) & sample(n-1) & sample WHEN OTHERS;
			

END behavior;
