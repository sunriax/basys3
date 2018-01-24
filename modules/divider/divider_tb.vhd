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
--	File: divider_tb.vhd
--	Version: v1.0
--	--------------------------------------
--	Testbench zum testen des Taktteilers
--	--------------------------------------

library IEEE;
library UNISIM;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use UNISIM.VComponents.all;

entity divider_tb is
--  Port ( );
end divider_tb;

architecture Simulation of divider_tb is

	-- Taktdefinitionen
	constant	clk_period	: time := 10 ns;	-- Simulationstakt (100 MHz)
	signal 		clk			: std_logic := '0';	-- Simulationstaktsignal

	-- Simulationskonstanten
	constant DATASIZE		: integer := 1;
	constant WIDTH			: integer := 25;
	constant INVERTED		: std_logic := '1';

	-- Simulations Signale
	signal EN		: std_logic;
	signal OFFSET	: std_logic_vector(DATASIZE - 1 downto 0);
	signal PULSE	: std_logic;

	-- Komponentendeklaration
	component divider is
		 Generic(
				constant DATASIZE	: integer;
				constant WIDTH		: integer;				
				constant INVERTED	: std_logic
				);
			Port(
				EN		: in std_logic;
				clk		: in std_logic;
				OFFSET	: in std_logic_vector(DATASIZE - 1 downto 0);
				PULSE	: out std_logic
				);
	end component divider;

begin

-- Testkomponente instanzieren
UUT:	divider  generic map(
							DATASIZE 	=> DATASIZE,
							WIDTH		=> WIDTH,
							INVERTED	=> INVERTED
							)
					port map(
							EN		=>	EN,
							clk		=>	clk,
							OFFSET	=>	OFFSET,
							PULSE	=>	PULSE
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
					EN <= '0';	OFFSET <= (others => '0');	wait for clk_period * 2;
					EN <= '1';								wait for clk_period * 258;
					EN <= '0';	OFFSET <= (others => '0');
				-- Ablauf stoppen
				wait;
			end process procSIM;
			
end Simulation;
