LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY original_buffer IS
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
END original_buffer;


ARCHITECTURE behavior OF original_buffer IS


BEGIN

	PROCESS (clk,reset)
	BEGIN
		IF reset = '1' THEN
			original_a0 <= (OTHERS=>'0');
			original_a1 <= (OTHERS=>'0');
			original_a2 <= (OTHERS=>'0');
			original_a3 <= (OTHERS=>'0');
			original_l0 <= (OTHERS=>'0');
			original_l1 <= (OTHERS=>'0');
			original_l2 <= (OTHERS=>'0');
			original_l3 <= (OTHERS=>'0');
		ELSIF clk'EVENT AND clk = '1' THEN
			IF enable_a = '1' THEN
				original_a0 <= input_sample(n-1 DOWNTO 0);
				original_a1 <= input_sample((n*2)-1 DOWNTO n);
				original_a2 <= input_sample((n*3)-1 DOWNTO n*2);
				original_a3 <= input_sample((n*4)-1 DOWNTO n*3);
			END IF;
			IF enable_l = '1' THEN
				original_l0 <= input_sample(n-1 DOWNTO 0);
				original_l1 <= input_sample((n*2)-1 DOWNTO n);
				original_l2 <= input_sample((n*3)-1 DOWNTO n*2);
				original_l3 <= input_sample((n*4)-1 DOWNTO n*3);
			END IF;
		END IF;
	END PROCESS;
	
	
END behavior;