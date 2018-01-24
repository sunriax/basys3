--	--------------- Module ---------------
--	SUNriaX Technology!
--	G�CHTER R.
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
--	Modul zum Z�hlen von Takten mit
--	variabler Breite und Z�hlrichtung
--	--------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Modulkopf
entity counter is
	 Generic(
			-- Takt Einstellungen
			constant DATASIZE	: integer range 1 to 64 := 8;	-- Datenbreite des Z�hlers
			constant DIRECTION	: std_logic := '0'				-- 0=Vorw�rts, 1=R�ckw�rts
			);
		Port(
			-- Enable und Takteingang
			EN		: in std_logic;
			clk		: in std_logic;
			
			-- Startwert Initialisieren
			INIT	: in std_logic_vector(DATASIZE - 1 downto 0);

			-- Z�hlerausgang
			COUNT	: out std_logic_vector(DATASIZE - 1 downto 0)
			);
end counter;

-- Modulverhalten
architecture Behavioral of counter is
	signal intCOUNT : unsigned(DATASIZE - 1 downto 0) := (others => '0');	-- Interne Z�hlvariable
begin

-- Interner Z�hlerwert ausgeben
COUNT <= std_logic_vector(intCOUNT);

-- Z�hlprozess
counter:	process(EN, clk, INIT)
			begin
				
				-- Asynchroner Reset
				if(EN <= '0') then
					
					-- Z�hler auf Initialwert r�cksetzten
					intCOUNT <= unsigned(INIT);
					
				-- Synchrones Schaltwerk
				elsif(rising_edge(CLK)) then
				
					-- Wenn Z�hler vorw�rts
					if(DIRECTION = '0') then
					
						intCOUNT <= intCOUNT + 1;	-- Z�hler inkrementieren
					
					-- Wenn Z�hler r�ckw�rts
					else
					
						intCOUNT <= intCOUNT - 1;	-- Z�hler dekrementieren
						
					end if;
				end if;
			end process counter;

end Behavioral;
