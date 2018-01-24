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
--	File: fifo.vhd
--	Version: v1.0
--	--------------------------------------
--	Modul zum zwischenspeichern von Daten
--	in einem First-In-First-Out Puffer mit
--	wählbarer Speicherbreite/tiefe
--	--------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Modulkopf
entity fifo is
	 Generic(
			-- FIFO Einstellungen
			constant DATASIZE	:	integer := 8;				-- Datenbreite
			constant MEMORY		:	integer	:= 4				-- Anzahl der verfügbaren Speicherplätze 2^MEMORY
			);
		Port(
			-- Enable und Takteingang
			EN      :  in std_logic;
			clk     :  in std_logic;
			
			-- Daten Ein/Ausgabe
			dataset :  in std_logic_vector(DATASIZE - 1 downto 0);
			set     :  in std_logic;
			dataget : out std_logic_vector(DATASIZE - 1 downto 0);
			get     :  in std_logic;
			
			-- Status Register
			SREG    : out std_logic_vector(3 downto 0)
			);
end fifo;

architecture Behavioral of fifo is
	-- FIFO Pointer
	signal ptHEAD	:	unsigned(MEMORY - 1 downto 0) := (others => '0');
	signal ptFOOT	:	unsigned(MEMORY - 1 downto 0) := (others => '0');
	
	-- Status Register
	signal intSREG		:	std_logic_vector(2 downto 0);
	signal writeFAULT	:	std_logic := '0';
	signal readFAULT	:	std_logic := '0';
	
	-- Datenpuffer
	type mem is array (0 to (2**MEMORY - 1)) of std_logic_vector((DATASIZE - 1) downto 0);	-- Datenarray mit ((2^MEMORY) - 1) Speicherplätzen
	signal DATA	: mem := (others => (others => '0'));										-- Datenspeicher mit 0 initialisieren
begin

--	         SREG Register
--	+-----+--------+---------------+
--	| BIT | STATUS | BESCHREIBUNG  |
--	+-----+--------+---------------+
--	|  0  | EMPTY  | Puffer leer   |
--	|  1  | FULL   | Puffer voll   |
--	|  2  | FULL-1 | Puffer voll-1 |
--	|  3  | FAULT  | Puffer Fehler |
--	+-----+--------+---------------+

-- Ausgabe des Statusregisters
SREG <= (writeFAULT or readFAULT) & intSREG;

-- Status Prozess
status:	process(EN, ptHEAD, ptFOOT, intSREG)
			begin
				-- Wenn Freigabe vorhanden
				if(EN = '1') then
				
					-- Wenn Kopfzeiger = Fußzeiger
					if(intSREG(2) = '0' and ptHEAD = ptFOOT) then
					
						intSREG(0) <= '1';	-- Ausgabe Datenpuffer leer
						intSREG(1) <= '0';
						intSREG(2) <= '0';
						
					-- Wenn Kopfzeiger - 1 = Fußzeiger
					elsif((ptHEAD + 1) = ptFOOT) then
					
						intSREG(0) <= '0';
						intSREG(1) <= '0';
						intSREG(2) <= '1';	-- Ausgabe Datenpuffer fast voll
					
					-- Wenn Datenpuffer fast voll und Kopfzeiger = Fußzeiger
					elsif(intSREG(2) = '1' and ptHEAD = ptFOOT) Then
					
						intSREG(0) <= '0';
						intSREG(1) <= '1';	-- Ausgabe Datenpuffer voll
						intSREG(2) <= '1';	-- Ausgabe Datenpuffer fast voll
					
					-- Ansonsten
					else
						-- Statusregister rücksetzten
						intSREG <= (others => '0');
					
					end if;
				
				-- Wenn Freigabe nicht vorhanden
				else
					
					intSREG <= (others => '0');	-- Statusregister Rücksetzten
				
				end if;
		end process status;

-- Schreib Porzess (Taktgesteuert)
write:	process(EN, clk)
			begin
				-- Asynchroner Schaltungsteil
				if(EN = '0') then
				
					writeFAULT <= '0';							-- Schreibfehler rücksetzten
					ptHEAD <= (others => '0');					-- Kopfzeiger rücksetzen
				
				-- Synchroner Schaltungsteil
				elsif(rising_edge(clk)) then
				
					-- Überprüfen ob Daten schreiben aktiv und Puffer /= Voll
					if(set = '1' and intSREG(1) = '0') then
						
						DATA(to_integer(ptHEAD)) <= dataset;	-- Eingabedaten in Datenpuffer schreiben
						ptHEAD <= ptHEAD + 1;					-- Kopfzeiger inkrementieren
					
					-- Überprüfen ob Daten schreiben bei vollem Puffer aktiv
					elsif(set = '1' and intSREG(1) = '1') then
					
						writeFAULT <= '1';						-- Schreibfehler (Puffer voll)
					
					else
					
						writeFAULT <= '0';						-- Schreibfehler rücksetzten
					
					end if;
				
				end if;
		end process write;

-- Lese Prozess (Taktgesteuert)
read:	process(EN, clk)
			begin
				-- Asynchroner Schaltungsteil
				if(EN = '0') then
				
					readFAULT <= '0';							-- Lesefehler rücksetzten
					ptFOOT <= (others => '0');					-- Fußzeiger rücksetzen
					dataget <= (others => '0');					-- Datenausgabe rücksetzen
				
				-- Synchroner Schaltungsteil
				elsif(rising_edge(clk)) then
				
					-- Überprüfen ob Daten lesen aktiv und Puffer /= Leer
					if(get = '1' and intSREG(0) = '0') then
					
						
						dataget <= DATA(to_integer(ptFOOT));	-- Datenausgabe aus Datenpuffer
						ptFOOT <= ptFOOT + 1;					-- Kopfzeiger inkrementieren
					
					-- Überprüfen ob Daten lesen bei leerem Puffer aktiv
					elsif(get = '1' and intSREG(0) = '1') then
					
						readFAULT <= '1';						-- Lesefehler (keine Daten mehr im Puffer)
						dataget <= (others => '0');				-- Datenausgabe rücksetzen
					
					else
					
						readFAULT <= '0';						-- Lesefehler rücksetzten
						dataget <= (others => '0');				-- Datenausgabe rücksetzen
					
					end if;
				
				end if;
		end process read;

end Behavioral;
