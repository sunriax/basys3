--	--------------- Module ---------------
--	SUNriaX Technology!
--	GÄCHTER R.
--	
--	mail: https://www.sunriax.at/contact
--	web:  https://www.sunriax.at
--  git:  https://github.com/sunriax/
--	
--	(c) 2017 SUNriaX, All rights reserved
--	--------------------------------------
--	File: counter_tb.vhd
--	Version: v1.0
--	--------------------------------------
--	Testbench zum testen des Zählermoduls
--	--------------------------------------

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
	constant	clk_period	: time := 10 ns;	-- Simulationstakt (100 MHz)
	signal 		clk			: std_logic := '0';	-- Simulationstaktsignal

	-- Simulationskonstanten
	constant DATASIZE		: integer := 8;
	constant DIRECTION		: std_logic := '0';

	-- Simulations Signale
	signal EN		: std_logic := '0';
	signal INIT		: std_logic_vector(DATASIZE - 1 downto 0) := (others => '0');
	signal COUNT	: std_logic_vector(DATASIZE - 1 downto 0) := (others => '0');

	-- Komponentendeklaration
	component counter is
		 Generic(
				constant DATASIZE		:	integer;
				constant DIRECTION		:	std_logic
				);
			Port(
				EN		: in std_logic;
				clk		: in std_logic;
				INIT	: in std_logic_vector(DATASIZE - 1 downto 0);
				COUNT	: out std_logic_vector(DATASIZE - 1 downto 0)
				);
	end component counter;

begin

-- Testkomponente instanzieren
UUT:	counter  generic map(
							DATASIZE 	=> DATASIZE,
							DIRECTION	=>	DIRECTION
							)
					port map(
							EN		=>	EN,
							clk		=>	clk,
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
					EN <= '0';	INIT <= (others => '0');
				-- Ablauf stoppen
				wait;
			end process procSIM;
			
end Simulation;
