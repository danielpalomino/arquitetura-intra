LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY sad_modes_buffer IS
	GENERIC (n: INTEGER:= 8);
	PORT (
		clk,reset	: IN STD_LOGIC;
		enable_modes: IN STD_LOGIC_VECTOR(16 DOWNTO 0);
		sad			: IN STD_LOGIC_VECTOR(n+5 DOWNTO 0);
		acum_sad		: OUT STD_LOGIC_VECTOR(n+23 DOWNTO 0)
		);
END sad_modes_buffer;



ARCHITECTURE behavior OF sad_modes_buffer IS

SIGNAL 	sad_mode0,
			sad_mode1,
			sad_mode2,
			sad_mode3,
			sad_mode4,
			sad_mode5,
			sad_mode6,
			sad_mode7,
			sad_mode8,
			sad_mode9,
			sad_mode10,
			sad_mode11,
			sad_mode12,
			sad_mode13,
			sad_mode14,
			sad_mode15,
			sad_mode16: STD_LOGIC_VECTOR (n+23 DOWNTO 0);

SIGNAL out_mux: STD_LOGIC_VECTOR (n+23 DOWNTO 0);
SIGNAL out_sum: STD_LOGIC_VECTOR (n+23 DOWNTO 0);
			
BEGIN

	PROCESS (clk,reset)
	BEGIN
		IF reset = '1' THEN
			sad_mode0 <= (OTHERS=>'0');
			sad_mode1 <= (OTHERS=>'0');
			sad_mode2 <= (OTHERS=>'0');
			sad_mode3 <= (OTHERS=>'0');
			sad_mode4 <= (OTHERS=>'0');
			sad_mode5 <= (OTHERS=>'0');
			sad_mode6 <= (OTHERS=>'0');
			sad_mode7 <= (OTHERS=>'0');
			sad_mode8 <= (OTHERS=>'0');
			sad_mode9 <= (OTHERS=>'0');
			sad_mode10 <= (OTHERS=>'0');
			sad_mode11 <= (OTHERS=>'0');
			sad_mode12 <= (OTHERS=>'0');
			sad_mode13 <= (OTHERS=>'0');
			sad_mode14 <= (OTHERS=>'0');
			sad_mode15 <= (OTHERS=>'0');
			sad_mode16 <= (OTHERS=>'0');
		ELSIF clk'EVENT AND clk = '1' THEN
			IF enable_modes(0) = '1' THEN
				sad_mode0 <= out_sum;
			ELSIF enable_modes(1) = '1' THEN
				sad_mode1 <= out_sum;
			ELSIF enable_modes(2) = '1' THEN
				sad_mode2 <= out_sum;
			ELSIF enable_modes(3) = '1' THEN
				sad_mode3 <= out_sum;
			ELSIF enable_modes(4) = '1' THEN
				sad_mode4 <= out_sum;
			ELSIF enable_modes(5) = '1' THEN
				sad_mode5 <= out_sum;
			ELSIF enable_modes(6) = '1' THEN
				sad_mode6 <= out_sum;
			ELSIF enable_modes(7) = '1' THEN
				sad_mode7 <= out_sum;
			ELSIF enable_modes(8) = '1' THEN
				sad_mode8 <= out_sum;
			ELSIF enable_modes(9) = '1' THEN
				sad_mode9 <= out_sum;
			ELSIF enable_modes(10) = '1' THEN
				sad_mode10 <= out_sum;
			ELSIF enable_modes(11) = '1' THEN
				sad_mode11 <= out_sum;
			ELSIF enable_modes(12) = '1' THEN
				sad_mode12 <= out_sum;
			ELSIF enable_modes(13) = '1' THEN
				sad_mode13 <= out_sum;
			ELSIF enable_modes(14) = '1' THEN
				sad_mode14 <= out_sum;
			ELSIF enable_modes(15) = '1' THEN
				sad_mode15 <= out_sum;
			ELSIF enable_modes(16) = '1' THEN
				sad_mode16 <= out_sum;
			END IF;
			acum_sad <= out_sum;
		END IF;
	END PROCESS;
	
	WITH enable_modes SELECT
	out_mux	<=	sad_mode0	WHEN "00000000000000001",
					sad_mode1	WHEN "00000000000000010",
					sad_mode2	WHEN "00000000000000100",
					sad_mode3	WHEN "00000000000001000",
					sad_mode4	WHEN "00000000000010000",
					sad_mode5	WHEN "00000000000100000",
					sad_mode6	WHEN "00000000001000000",
					sad_mode7	WHEN "00000000010000000",
					sad_mode8	WHEN "00000000100000000",
					sad_mode9	WHEN "00000001000000000",
					sad_mode10	WHEN "00000010000000000",
					sad_mode11	WHEN "00000100000000000",
					sad_mode12	WHEN "00001000000000000",
					sad_mode13	WHEN "00010000000000000",
					sad_mode14	WHEN "00100000000000000",
					sad_mode15	WHEN "01000000000000000",
					sad_mode16	WHEN OTHERS;

	out_sum <= out_mux + (sad(n+5) & sad(n+5) & sad(n+5) & sad(n+5) & sad(n+5) & sad(n+5) & sad(n+5) & sad(n+5) &
								 sad(n+5) & sad(n+5) & sad(n+5) & sad(n+5) & sad(n+5) & sad(n+5) & sad(n+5) & sad(n+5) & 
								 sad(n+5) & sad(n+5) & sad);

END behavior;