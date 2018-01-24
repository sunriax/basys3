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
--	File: dds_tb.vhd
--	Version: v1.0
--	--------------------------------------
--	Testbench zum testen des DDS Moduls
--	--------------------------------------

library IEEE;
library UNISIM;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use UNISIM.VComponents.all;

entity dds_tb is
--  Port ( );
end dds_tb;

architecture Simulation of dds_tb is

	-- Taktdefinitionen
	constant	clk_period	: time := 10 ns;	-- Simulationstakt (100 MHz)
	signal 		clk			: std_logic := '0';	-- Simulationstaktsignal

	-- Simulationskonstanten
	constant FILENAME		: string  := "tab_sin64x8.mif";
	constant DATASIZE		: integer := 8;
	constant SAMPLE			: integer := 6;
	constant startQUADRANT	: integer := 0;
	constant startSAMPLE	: integer := 0;

	-- Simulations Signale
	signal EN		: std_logic := '0';
	signal curve	: std_logic_vector(DATASIZE - 1 downto 0) := (others => '0');

	-- Komponentendeklaration
	component dds is
		 Generic(
				constant FILENAME		:	string;
				constant DATASIZE		:	integer;
				constant SAMPLE			:	integer;
				constant startQUADRANT	:	integer;
				constant startSAMPLE	:	integer
				);
			Port(
				EN		: in std_logic;
				clk		: in std_logic;
				curve	: out std_logic_vector(DATASIZE - 1 downto 0)
				);
	end component dds;

begin

-- Testkomponente instanzieren
UUT:	dds	 generic map(
						FILENAME		=> FILENAME,
						DATASIZE 		=> DATASIZE,
						SAMPLE			=> SAMPLE,
						startQUADRANT	=> startQUADRANT,
						startSAMPLE		=> startSAMPLE
						)
				port map(
						EN		=>	EN,
						clk		=>	clk,
						curve	=>	curve
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
					EN <= '0';	wait for clk_period * 2;
					EN <= '1';	wait for clk_period * 512;
					
				-- Ablauf stoppen
				wait;
			end process procSIM;
			
end Simulation;
