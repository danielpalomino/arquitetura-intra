LIBRARY ieee;
USE ieee.std_logic_1164.all;

PACKAGE INTRA_LIBRARY IS

	COMPONENT bs0 IS
		GENERIC (n: INTEGER:= 8)
		PORT (
			selector			: IN STD_LOGIC;
			sample			: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
			shifted_sample	: OUT STD_LOGIC_VECTOR(n+3 DOWNTO 0)
			);
	END COMPONENT;

	COMPONENT bs1 IS
		GENERIC (n: INTEGER:= 8)
		PORT (
			selector			: IN STD_LOGIC;
			sample			: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
			shifted_sample	: OUT STD_LOGIC_VECTOR(n+3 DOWNTO 0)
			);
	END COMPONENT;

	COMPONENT bs2 IS
		GENERIC (n: INTEGER:= 8)
		PORT (
			selector			: IN STD_LOGIC;
			sample			: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
			shifted_sample	: OUT STD_LOGIC_VECTOR(n+3 DOWNTO 0)
			);
	END COMPONENT;

	COMPONENT bs3 IS
		GENERIC (n: INTEGER:= 8)
		PORT (
			selector			: IN STD_LOGIC;
			sample			: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
			shifted_sample	: OUT STD_LOGIC_VECTOR(n+3 DOWNTO 0)
			);
	END COMPONENT;

	COMPONENT bs4 IS
		GENERIC (n: INTEGER:= 8)
		PORT (
			selector			: IN STD_LOGIC;
			sample			: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
			shifted_sample	: OUT STD_LOGIC_VECTOR(n+3 DOWNTO 0)
			);
	END COMPONENT;

END INTRA_LIBRARY;