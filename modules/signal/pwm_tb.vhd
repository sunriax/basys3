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
--	File: pwm_tb.vhd
--	Version: v1.0
--	--------------------------------------
--	Testbench zum testen des PWM Moduls
--	--------------------------------------

library IEEE;
library UNISIM;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use UNISIM.VComponents.all;

entity pwm_tb is
--  Port ( );
end pwm_tb;

architecture Simulation of pwm_tb is

	-- Taktdefinitionen
	constant	clk_period	: time := 10 ns;	-- Simulationstakt (100 MHz)
	signal 		clk			: std_logic := '0';	-- Simulationstaktsignal

	-- Simulationskonstanten
	constant DATASIZE		: integer := 4;
	constant INVERTED		: std_logic := '0';

	-- Simulations Signale
	signal EN			: std_logic;
	signal LOAD			: std_logic_vector(DATASIZE - 1 downto 0) := (others => '0');
	signal PULSE		: std_logic;
	signal CLOCK		: std_logic;

	-- Komponentendeklaration
	component pwm is
		 Generic(
				constant DATASIZE	: integer;
				constant INVERTED	: std_logic
				);
			Port(
				EN		: in std_logic;
				clk		: in std_logic;
				LOAD	: in std_logic_vector(DATASIZE - 1 downto 0);
				PULSE	: out std_logic;
				CLOCK	: out std_logic
				);
	end component pwm;

begin

-- Testkomponente instanzieren
UUT:	pwm  generic map(
						DATASIZE 	=> DATASIZE,
						INVERTED	=> INVERTED
						)
				port map(
						EN		=>	EN,
						clk		=>	clk,
						LOAD	=>	LOAD,
						PULSE	=>	PULSE,
						CLOCK	=>	CLOCK
						);

-- Taktsignal erzeugen
procCLK:	process
				begin
					clk <= '0';	wait for clk_period/2;
					clk <= '1';	wait for clk_period/2;
			end process procCLK;

procDATA:	process(CLOCK)
				variable DATA : unsigned(DATASIZE - 1 downto 0) := (others => '0');
			begin
			
				if(EN = '0') then
					
					DATA := (others => '0');
					
				elsif(falling_edge(CLOCK)) then
				
					LOAD <= std_logic_vector(DATA);
					DATA := DATA + 1;
				
				end if;
			
			end process procDATA;

-- Simulationsprozess
procSIM:	process
				begin
					-- Initialisierung
					EN <= '0';	wait for clk_period * 2;
					EN <= '1';	wait for clk_period * 400;
					EN <= '0';
				-- Ablauf stoppen
				wait;
			end process procSIM;
			
end Simulation;
