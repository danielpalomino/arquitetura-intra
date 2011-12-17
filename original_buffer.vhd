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

SIGNAL original_left00, original_left01, original_left02, original_left03,
		 original_left10, original_left11, original_left12, original_left13,
		 original_left20, original_left21, original_left22, original_left23,
		 original_left30, original_left31, original_left32, original_left33: STD_LOGIC_VECTOR(n-1 DOWNTO 0);

BEGIN

	PROCESS (clk,reset)
	BEGIN
		IF reset = '1' THEN
			original_a0 <= (OTHERS=>'0');
			original_a1 <= (OTHERS=>'0');
			original_a2 <= (OTHERS=>'0');
			original_a3 <= (OTHERS=>'0');
			original_left30	<=	(OTHERS=>'0');
			original_left31	<=	(OTHERS=>'0');
			original_left32	<=	(OTHERS=>'0');
			original_left33	<=	(OTHERS=>'0');
			
			original_left20	<=	(OTHERS=>'0');
			original_left21	<=	(OTHERS=>'0');
			original_left22	<=	(OTHERS=>'0');
			original_left23	<= (OTHERS=>'0');
			
			original_left10	<=	(OTHERS=>'0');
			original_left11	<=	(OTHERS=>'0');
			original_left12	<=	(OTHERS=>'0');
			original_left13	<= (OTHERS=>'0');
			
			original_left00	<=	(OTHERS=>'0');
			original_left01	<=	(OTHERS=>'0');
			original_left02	<=	(OTHERS=>'0');
			original_left03	<= (OTHERS=>'0');
		ELSIF clk'EVENT AND clk = '1' THEN
			IF enable_a = '1' THEN
				original_a0 <= input_sample(n-1 DOWNTO 0);
				original_a1 <= input_sample((n*2)-1 DOWNTO n);
				original_a2 <= input_sample((n*3)-1 DOWNTO n*2);
				original_a3 <= input_sample((n*4)-1 DOWNTO n*3);
			END IF;
			IF enable_l = '1' THEN
				original_left30	<=	input_sample(n-1 DOWNTO 0);
				original_left31	<=	input_sample((n*2)-1 DOWNTO n);
				original_left32	<=	input_sample((n*3)-1 DOWNTO n*2);
				original_left33	<=	input_sample((n*4)-1 DOWNTO n*3);
				
				original_left20	<=	original_left30;
				original_left21	<=	original_left31;
				original_left22	<=	original_left32;
				original_left23	<= original_left33;
				
				original_left10	<=	original_left20;
				original_left11	<=	original_left21;
				original_left12	<=	original_left22;
				original_left13	<= original_left23;
				
				original_left00	<=	original_left10;
				original_left01	<=	original_left11;
				original_left02	<=	original_left12;
				original_left03	<= original_left13;
			END IF;
		END IF;
	END PROCESS;
	
	original_l0 <= original_left00;
	original_l1 <= original_left10;
	original_l2 <= original_left20;
	original_l3 <= original_left30;
	
END behavior;