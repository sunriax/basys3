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
--	File: pwm.vhd
--	Version: v1.0
--	--------------------------------------
--	Modul zum erstellen von Signalen mit
--	bestimmten Frequenzen. Signalformen
--	Rechteck/Dreieck/Sägezahn/Rauschen
--	--------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pwm is
	 Generic(
			-- PWM Einstellungen
			constant DATASIZE	: integer range 2 to 64 := 8;	-- Datenbreite
			constant INVERTED	: std_logic := '0'				-- 0=not inverted, 1=inverted
			);
		Port(
			-- Enable und Takteingang
			EN		: in std_logic;
			clk		: in std_logic;
			
			-- PWM Ton/T width
			LOAD	: in std_logic_vector(DATASIZE - 1 downto 0);
			
			-- PWM Output Signal
			PULSE	: out std_logic;
			CLOCK	: out std_logic
			);
end pwm;

architecture Behavioral of pwm is

	-- Interne Variablen
	signal intCOUNT 	:	std_logic_vector(DATASIZE - 1 downto 0) := (others => '0');	-- Interne Zählvariable
	signal intLOAD		:	std_logic_vector(DATASIZE - 1 downto 0) := (others => '0');
	signal intPULSE		:	std_logic := '0';
	signal intCLOCK		:	std_logic := '0';
	signal intVALID		:	std_logic := '0';

	-- Zähler einbinden
	component counter is
		 Generic(
				constant DATASIZE	: integer;
				constant DIRECTION	: std_logic
				);
			Port(
				EN		: in std_logic;
				clk		: in std_logic;
				INIT	: in std_logic_vector(DATASIZE - 1 downto 0);
				COUNT	: out std_logic_vector(DATASIZE - 1 downto 0)
				);
	end component counter;

		-- Zähler einbinden
	component divider is
		 Generic(
				constant DATASIZE	: integer;
				constant WIDTH		: integer;				
				constant INVERTED	: std_logic
				);
			Port(
				-- Enable und Takteingang
				EN		: in std_logic;
				clk		: in std_logic;
				OFFSET	: in std_logic_vector(DATASIZE - 1 downto 0);
				PULSE	: out std_logic
				);
	end component divider;

begin

pwm_counter: counter	generic map	(
									DATASIZE	=>	DATASIZE,
									DIRECTION	=>	'0'
									)
							port map(
									EN		=>	EN,
									clk		=>	clk,
									INIT	=>	(others => '1'),
									COUNT	=>	intCOUNT
									);

pwm_clock:	divider  generic map(
								DATASIZE 	=> DATASIZE,
								WIDTH		=> 50,
								INVERTED	=> INVERTED
								)
						port map(
								EN		=>	EN,
								clk		=>	clk,
								OFFSET	=>	(others => '1'),
								PULSE	=>	intCLOCK
								);
								
pwm_pulse:	divider  generic map(
								DATASIZE 	=> DATASIZE,
								WIDTH		=> 50,
								INVERTED	=> INVERTED
								)
						port map(
								EN		=>	EN,
								clk		=>	clk,
								OFFSET	=>	(others => '0'),
								PULSE	=>	intVALID
								);

CLOCK <= intCLOCK;
PULSE <= intPULSE;

pwm_loader:	process(EN, intVALID)
				begin
					
					-- Asynchroner Reset
					if(EN <= '0') then
						
						intLOAD <= (others => '0');
						
					-- Synchrones Schaltwerk
					elsif(rising_edge(intVALID)) then
					
						intLOAD <= LOAD;
						
					end if;
				end process pwm_loader;

pwm_generator:	process(EN, clk)
				begin
					
					-- Asynchroner Reset
					if(EN <= '0') then
						
						intPULSE <= INVERTED;
						
					-- Synchrones Schaltwerk
					elsif(rising_edge(clk)) then
					
						if(unsigned(intLOAD) <= unsigned(intCOUNT)) then
																
							intPULSE <= INVERTED;
							
						else
						
							intPULSE <= not(INVERTED);
						
						end if;
					
					end if;
					
				end process pwm_generator;

end Behavioral;
