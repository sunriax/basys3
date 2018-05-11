-- -------------------------------------
-- SUNriaX Project
-- www.sunriax.at
-- -------------------------------------
-- Hardware: Basys3
-- Platform: Artix 7 CPG236 FPGA
-- -------------------------------------
-- Name: shiftreg_tb.vhd
-- Ver.: 1.0 Release
-- Type: Testbench
-- Text: Simulate the transmission to
--       and from shift register
--
-- (c) 2017 SUNriaX, All rights reserved
-- https://github.com/sunriax/basys3
-- -------------------------------------

library IEEE;
library UNISIM;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use UNISIM.VComponents.all;

entity shiftreg_tb is
--  Port ( );
end shiftreg_tb;

architecture Simulation of shiftreg_tb is

	-- Taktdefinitionen
	constant sck_period	: time := 1 us;	-- Simulationstakt (1 MHz)
	constant DATAWIDTH	: integer := 8;


	-- Simulations Signale
	signal SCK		: std_logic := '0';
	signal EN		: std_logic := '0';
	signal CS		: std_logic := '0';
	signal dIN		: std_logic := '0';
	signal LOAD		: std_logic := '0';
	signal dOUT		: std_logic := '0';
	signal dataIN	: std_logic_vector(DATAWIDTH - 1 downto 0) := (others => '0');
	signal dataOUT	: std_logic_vector(DATAWIDTH - 1 downto 0) := (others => '0');

	-- Komponentendeklaration
	component shiftreg is
		 Generic(
				constant DATAWIDTH		:	integer
				);
			Port(
				EN      :  in std_logic;
				SCK     :  in std_logic;
				CS      :  in std_logic;
				dIN     :  in std_logic;
				LOAD    :  in std_logic;
				dataIN  :  in std_logic_vector(DATAWIDTH - 1 downto 0);
				dOUT    : out std_logic;
				dataOUT : out std_logic_vector(DATAWIDTH - 1 downto 0)
				);
	end component shiftreg;

begin

-- Testkomponente instanzieren
UUT:	shiftreg	 generic map(
								DATAWIDTH 	=> DATAWIDTH
								)
						port map(
								EN		=>	EN,
								SCK		=>	SCK,
								CS		=>	CS,
								dIN		=>	dIN,
								LOAD	=>	LOAD,
								dataIN	=>	dataIN,
								dOUT	=>	dOUT,
								dataOUT	=>	dataOUT
								);

-- Taktsignal erzeugen
-- procCLK:	process
--				begin
--					SCK <= '0';	wait for sck_period/2;
--					SCK <= '1';	wait for sck_period/2;
--			end process procCLK;

-- Simulationsprozess
procSIM:	process
				begin
					-- Initialisierung
					EN <= '0';	SCK <= '0';	CS <= '0';	dIN <= '0'; LOAD <= '1'; dataIN <= (others => '0');		wait for sck_period * 2;
					EN <= '1';	SCK <= '0';	CS <= '1';	dIN <= '0'; LOAD <= '1'; dataIN <= (others => '0');		wait for sck_period * 2;
					
								SCK <= '0';	CS <= '0';	dIN <= '1'; LOAD <= '1'; dataIN <= (others => '0');		wait for sck_period * 1;
								SCK <= '1';	CS <= '0';	dIN <= '1'; LOAD <= '1'; dataIN <= (others => '0');		wait for sck_period * 1;
					
								SCK <= '0';	CS <= '0';	dIN <= '0'; LOAD <= '1'; dataIN <= (others => '0');		wait for sck_period * 1;
								SCK <= '1';	CS <= '0';	dIN <= '0'; LOAD <= '1'; dataIN <= (others => '0');		wait for sck_period * 1;
					
								SCK <= '0';	CS <= '0';	dIN <= '1'; LOAD <= '1'; dataIN <= (others => '0');		wait for sck_period * 1;
								SCK <= '1';	CS <= '0';	dIN <= '1'; LOAD <= '1'; dataIN <= (others => '0');		wait for sck_period * 1;
					
								SCK <= '0';	CS <= '0';	dIN <= '0'; LOAD <= '1'; dataIN <= (others => '0');		wait for sck_period * 1;
								SCK <= '1';	CS <= '0';	dIN <= '0'; LOAD <= '1'; dataIN <= (others => '0');		wait for sck_period * 1;
					
								SCK <= '0';	CS <= '0';	dIN <= '0'; LOAD <= '1'; dataIN <= (others => '0');		wait for sck_period * 1;
								SCK <= '1';	CS <= '0';	dIN <= '0'; LOAD <= '1'; dataIN <= (others => '0');		wait for sck_period * 1;
					
								SCK <= '0';	CS <= '0';	dIN <= '1'; LOAD <= '1'; dataIN <= (others => '0');		wait for sck_period * 1;
								SCK <= '1';	CS <= '0';	dIN <= '1'; LOAD <= '1'; dataIN <= (others => '0');		wait for sck_period * 1;
					
								SCK <= '0';	CS <= '0';	dIN <= '1'; LOAD <= '1'; dataIN <= (others => '0');		wait for sck_period * 1;
								SCK <= '1';	CS <= '0';	dIN <= '1'; LOAD <= '1'; dataIN <= (others => '0');		wait for sck_period * 1;
					
								SCK <= '0';	CS <= '0';	dIN <= '0'; LOAD <= '1'; dataIN <= (others => '0');		wait for sck_period * 1;
								SCK <= '1';	CS <= '0';	dIN <= '0'; LOAD <= '1'; dataIN <= (others => '0');		wait for sck_period * 1;
													
								SCK <= '0';	CS <= '0';	dIN <= '0'; LOAD <= '1'; dataIN <= (others => '0');		wait for sck_period * 1;
								SCK <= '1';	CS <= '0';	dIN <= '0'; LOAD <= '1'; dataIN <= (others => '0');		wait for sck_period * 1;
																					
								--SCK <= '0';	CS <= '0';	dIN <= '0'; LOAD <= '1'; dataIN <= (others => '0');		wait for sck_period * 1;
								--SCK <= '1';	CS <= '0';	dIN <= '0'; LOAD <= '1'; dataIN <= (others => '0');		wait for sck_period * 1;

								--SCK <= '0';	CS <= '0';	dIN <= '0'; LOAD <= '1'; dataIN <= (others => '0');		wait for sck_period * 1;
								--SCK <= '1';	CS <= '0';	dIN <= '0'; LOAD <= '1'; dataIN <= (others => '0');		wait for sck_period * 1;

								--SCK <= '0';	CS <= '0';	dIN <= '0'; LOAD <= '1'; dataIN <= (others => '0');		wait for sck_period * 1;
								--SCK <= '1';	CS <= '0';	dIN <= '0'; LOAD <= '1'; dataIN <= (others => '0');		wait for sck_period * 1;

								SCK <= '0';	CS <= '0';	dIN <= '0'; LOAD <= '1'; dataIN <= (others => '0');		wait for sck_period * 1;
								SCK <= '0';	CS <= '1';	dIN <= '0'; LOAD <= '1'; dataIN <= (others => '0');		wait for sck_period * 8;
					
								SCK <= '0';	CS <= '1';	dIN <= '0'; LOAD <= '0'; dataIN <= (others => '1');		wait for sck_period * 2;
								SCK <= '0';	CS <= '1';	dIN <= '0'; LOAD <= '1'; dataIN <= (others => '0');		wait for sck_period * 8;
					
					EN <= '0';	SCK <= '0';	CS <= '1';	dIN <= '0'; LOAD <= '1'; dataIN <= (others => '0');		wait for sck_period * 2;
					
				-- Ablauf stoppen
				wait;
			end process procSIM;
			
end Simulation;
