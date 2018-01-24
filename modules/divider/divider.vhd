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
--	File: divider.vhd
--	Version: v1.0
--	--------------------------------------
--	Modul zum erzeugen von Taktsignalen
--	mit bestimmtem Ton/Toff Verhältnis
--	--------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Modulkopf
entity divider is
	 Generic(
			-- Daten Einstellungen
			constant DATASIZE	: integer range 1 to 64  := 8;	-- Datenbreite des Taktteilers (8 = fsys/256)
			constant WIDTH		: integer range 1 to 100 := 50;	-- Aktive Signalzeit in Prozent (%)
																-- (nur ganzzahlige vielfache
																-- der Datenbreite möglich)
																-- z.B. 4 Bit = 16 /4(25%) /8(50%)!
			constant INVERTED	: std_logic := '0'				-- 0=not inverted, 1=inverted
			);
		Port(
			-- Enable und Takteingang
			EN		: in std_logic;
			clk		: in std_logic;
			
			-- Taktversatz
			OFFSET	: in std_logic_vector(DATASIZE - 1 downto 0);

			-- Taktsignal
			PULSE	: out std_logic
			);
end divider;

-- Modulbeschreibung
architecture Behavioral of divider is

	-- Intere Signale
	signal intCOUNT	:	std_logic_vector(DATASIZE - 1 downto 0) := (others => '0');
	signal intPULSE	:	std_logic := '0';

	-- Zähler einbinden
	component counter is
		 Generic(
				-- Takt Einstellungen
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

begin

clk_counter: counter	generic map	(
									DATASIZE	=>	DATASIZE,
									DIRECTION	=>	'0'
									)
							port map(
									EN		=>	EN,
									clk		=>	clk,
									INIT	=>	OFFSET,
									COUNT	=>	intCOUNT
									);

-- Interner Pulse ausgeben
PULSE <= intPULSE;

clk_generator:	process(EN, clk)
				begin
				
					-- Asynchroner Reset
					if(EN <= '0') then
						
						-- Zähler auf Offsetwert rücksetzten
						intPULSE <= INVERTED;
						
					-- Synchrones Schaltwerk
					elsif(rising_edge(CLK)) then
					
						-- Wenn Zähler auf 0
						if(unsigned(intCOUNT) = 0) then
						
							intPULSE <= not(intPULSE);	-- Taktimpul invertieren
					
						-- Wenn Zähler auf eingestellter Pulsbreite (%)
						elsif(unsigned(intCOUNT) = ((2**DATASIZE) * WIDTH / 100)) then
						
							intPULSE <= not(intPULSE);
						
						end if;
					
					end if;
				end process clk_generator;	


end Behavioral;
