-- -------------------------------------
-- SUNriaX Project
-- www.sunriax.at
-- -------------------------------------
-- Hardware: Basys3
-- Platform: Artix 7 CPG236 FPGA
-- -------------------------------------
-- Name: counter_tb.vhd
-- Ver.: 1.0 Release
-- Type: Testbench
-- Text: Simulate the execution of a
--       up/down counting sequence
--
-- (c) 2017 SUNriaX, All rights reserved
-- https://github.com/sunriax/basys3
-- -------------------------------------

library IEEE;
library UNISIM;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use UNISIM.VComponents.all;

entity counter_tb is
--  Port ( );
end counter_tb;

architecture Simulation of counter_tb is

	-- Taktdefinitionen
	constant clk_period	: time := 10 ns;	-- Simulationstakt (100 MHz)
	constant DATAWIDTH	: integer := 8;


	-- Simulations Signale
	signal clk		: std_logic := '0';
	signal EN		: std_logic := '0';
	signal DIR		: std_logic := '0';
	signal INIT		: std_logic_vector(DATAWIDTH - 1 downto 0) := (others => '0');
	signal COUNT	: std_logic_vector(DATAWIDTH - 1 downto 0) := (others => '0');

	-- Komponentendeklaration
	component counter is
		 Generic(
				constant DATAWIDTH		:	integer
				);
			Port(
				EN		: in std_logic;
				clk		: in std_logic;
				DIR		: in std_logic;
				INIT	: in std_logic_vector(DATAWIDTH - 1 downto 0);
				COUNT	: out std_logic_vector(DATAWIDTH - 1 downto 0)
				);
	end component counter;

begin

-- Testkomponente instanzieren
UUT:	counter  generic map(
							DATAWIDTH 	=> DATAWIDTH
							)
					port map(
							EN		=>	EN,
							clk		=>	clk,
							DIR		=>	DIR,
							INIT	=>	INIT,
							COUNT	=>	COUNT
							);

-- Taktsignal erzeugen
procCLK:	process
				begin
					clk <= '0';	wait for clk_period/2;
					clk <= '1';	wait for clk_period/2;
			end process procCLK;

-- Simulationsprozess
procSIM:	process
				begin
					-- Initialisierung
					EN <= '0';	INIT <= (others => '0');	wait for clk_period * 2;
					EN <= '1';								wait for clk_period * 258;
					EN <= '0';	INIT <= x"F0";				wait for clk_period * 2;
					EN <= '1';								wait for clk_period * 258;
					EN <= '0';	INIT <= (others => '0');	wait for clk_period * 2;
					EN <= '0';	INIT <= (others => '1');	wait for clk_period * 2;
					EN <= '1';	DIR  <= '1';				wait for clk_period * 258;
					EN <= '0';	INIT <= x"F0";				wait for clk_period * 2;
					EN <= '1';								wait for clk_period * 258;
					EN <= '0';	DIR  <= '0'; INIT <= (others => '0');
				-- Ablauf stoppen
				wait;
			end process procSIM;
			
end Simulation;
