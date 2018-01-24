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
--	File: counter.vhd
--	Version: v1.0
--	--------------------------------------
--	Modul zum Zählen von Takten mit
--	variabler Breite und Zählrichtung
--	--------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Modulkopf
entity counter is
	 Generic(
			-- Takt Einstellungen
			constant DATASIZE	: integer range 1 to 64 := 8;	-- Datenbreite des Zählers
			constant DIRECTION	: std_logic := '0'				-- 0=Vorwärts, 1=Rückwärts
			);
		Port(
			-- Enable und Takteingang
			EN		: in std_logic;
			clk		: in std_logic;
			
			-- Startwert Initialisieren
			INIT	: in std_logic_vector(DATASIZE - 1 downto 0);

			-- Zählerausgang
			COUNT	: out std_logic_vector(DATASIZE - 1 downto 0)
			);
end counter;

-- Modulverhalten
architecture Behavioral of counter is
	signal intCOUNT : unsigned(DATASIZE - 1 downto 0) := (others => '0');	-- Interne Zählvariable
begin

-- Interner Zählerwert ausgeben
COUNT <= std_logic_vector(intCOUNT);

-- Zählprozess
counter:	process(EN, clk, INIT)
			begin
				
				-- Asynchroner Reset
				if(EN <= '0') then
					
					-- Zähler auf Initialwert rücksetzten
					intCOUNT <= unsigned(INIT);
					
				-- Synchrones Schaltwerk
				elsif(rising_edge(CLK)) then
				
					-- Wenn Zähler vorwärts
					if(DIRECTION = '0') then
					
						intCOUNT <= intCOUNT + 1;	-- Zähler inkrementieren
					
					-- Wenn Zähler rückwärts
					else
					
						intCOUNT <= intCOUNT - 1;	-- Zähler dekrementieren
						
					end if;
				end if;
			end process counter;

end Behavioral;
