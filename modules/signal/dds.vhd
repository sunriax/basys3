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
--	File: dds.vhd
--	Version: v1.0
--	--------------------------------------
--	Modul zum erstellen von Signalen mit
--	bestimmten Frequenzen. Signalformen
--	Rechteck/Dreieck/Sägezahn/Rauschen
--	--------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_TEXTIO.all;
use IEEE.NUMERIC_STD.ALL;
use std.textio.all;

-- Modulkopf
entity dds is
	 Generic(
			-- DDS Einstellungen
			constant FILENAME		:	string := "tab_sin64x8.mif";	-- Dateiname für Speicherinitialisierung
			constant DATASIZE		:	integer range 2 to 64 := 8;		-- Datenbreite
			constant SAMPLE			:	integer	range 2 to 64 := 6;		-- Anzahl der Datensamples 2^SAMPLE (0 bis PI/2)
																		-- Damit ergibt sich eine Gesamptsamplezahl von
																		-- 2^SAMPLE * 4 (da Kurve nur von 0 - 90 ° Grad)
			constant startQUADRANT	:	integer range 0 to 3 := 0;		-- Quadrant in dem gestartet wird
			constant startSAMPLE	:	integer := 0					-- Sample mit dem gestartet wird
			);
		Port(
			-- Enable und Takteingang
			EN		: in std_logic;
			clk		: in std_logic;
			
			-- Signalausgabe
			curve	: out std_logic_vector(DATASIZE - 1 downto 0)
			);
end dds;

-- Modulverhalten
architecture Behavioral of dds is

	signal position : unsigned(SAMPLE - 1 downto 0) := (others => '0');
	signal quadrant : unsigned(1 downto 0) := (others => '0');

	type rom is array (0 to 2**SAMPLE - 1) of unsigned(DATASIZE - 1 downto 0);

-- Initialisierung von Speicherzellen mithilfe von externen Dateien
impure function init_mem(mif_file_name : in string) return rom is
	-- Speicherinitailisierungsdatei öffnen
    file mif_file : text open read_mode is mif_file_name;
    
    -- Funktionsvariablen
    variable mif_line	: line;
    variable temp_slv	: std_logic_vector(DATASIZE - 1 downto 0);
    variable temp_mem	: rom;
begin
	-- Auslesen der Daten aus Datei
    for i in rom'range loop
        readline(mif_file, mif_line);
        read(mif_line, temp_slv);
        
        -- Temporären Speicher füllen
        temp_mem(i) := unsigned(temp_slv);
    end loop;
    
    -- Rückgabe der ausgelesenen Daten
    return temp_mem;
end function;

-- Laden der Sinustabelle in den Speicher
constant sinus : rom := init_mem(FILENAME);

begin

count:		process(EN, clk)
			begin
			
				-- Asynchroner Reset
				if(EN <= '0') then
					
					-- Rücksetzten von Quadrant und Positionszeiger
					position <= to_unsigned(startSAMPLE, SAMPLE);
					quadrant <= to_unsigned(startQUADRANT, 2);
					
				-- Synchrones Schaltwerk
				elsif(rising_edge(CLK)) then
					
					-- Quadrantenwahl
					case quadrant is
						-- 2 Quadrant PI/2 - PI
						when "01"	=>	-- Wenn Position <= 0
										if(position <= 0) then
						
											quadrant <= "10";			-- 3. Quadrant wählen
										
										-- Ansonsten
										else
										
											position <= position - 1;	-- Positionzeiger dekrementieren
										
										end if;
						
						-- 3 Quadrant PI/2 - PI*3/2
						when "10"	=>	-- Wenn Position >= max. Wert
										if(position >= 2**SAMPLE - 1) then
						
											quadrant <= "11";			-- 4. Quadrant wählen
										
										-- Ansonsten
										else
										
											position <= position + 1;	-- Positionszeiger inkrementieren
										
										end if;
						
						-- 4 Quadrant PI*3/2 - 2*PI
						when "11"	=>	-- Wenn Position <= 0
										if(position <= 0) then
						
											quadrant <= "00";			-- 1. Quadrant wählen
										
										-- Ansonsten
										else
										
											position <= position - 1;	-- Positionszeiger dekrementieren
										
										end if;
						
						-- 1 Quadrant 0 - PI/2
						when others	=>	-- Wenn Position >= max. Wert
										if(position >= 2**SAMPLE - 1) then
										
											quadrant <= "01";			-- 2. Quadrant wählen
										
										else
										
											position <= position + 1;	-- Positionszeiger inkrementieren
										
										end if;
					end case;	
				end if;
			end process count;

samples:	process(EN, clk)
			begin
				
				-- Asynchroner Reset
				if(EN <= '0') then
					
					-- Ausgang Rücksetzten
					curve <= (others => '0');
					
				-- Synchrones Schaltwerk
				elsif(rising_edge(CLK)) then
				
					-- Wenn 1/2 Quadrant (addieren)
					if(quadrant = "00" or quadrant = "01")  then
						
						curve <= std_logic_vector(((2**DATASIZE) / 2) + sinus(to_integer(position)));		-- Singalausgabe (pos. Halbwelle)
					
					-- Wenn 3/4 Quadrant (subtrahieren)
					else
										
						curve <= std_logic_vector(((2**DATASIZE) / 2) - 1 - sinus(to_integer(position)));	-- Singalausgabe (neg. Halbwelle)
						
					end if;
				end if;
			end process samples;

end Behavioral;
