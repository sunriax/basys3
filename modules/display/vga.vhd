--	------------------------------------
--	Diplomarbeit elmProject@HTL-Rankweil
--	G.Raf@elmProject
--	2AAELI | 2016/2017
--	------------------------------------
--	File: vga.vhd
--	Version: v1.0
--	------------------------------------
--	VGA Ausgabemodul zum erzeugen der
--	benötigten Horizontal/Vertikalen
--	Synchronisierungssignale sowie zur
--	Einstellung der Auflösung und der
--	anzeige der Pixelposition
--	------------------------------------

-- Standardbibliotheken einbinden
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity vga is
	Generic	(
			-- Systemtakt
			nCLK			: integer := 108000000;		-- VGA Systemtakt
	
			-- Horizontale Einstellungen
			h_DISPLAY		: integer := 1280;	-- Sichtbarer Bereich in Pixel
			h_porchFRONT	: integer := 48;	-- Vordere Schwarzschzlter in pixel
			h_porchBACK		: integer := 248;	-- Hintere Schwarzschulter in pixel
			h_syncPULSE		: integer := 112;	-- Synchronisierungsimpuls zwischen Vorderer/Hinterer Schulter in Pixel
			h_POLARITY		: STD_LOGIC := '1';	-- Positive Synchronisierungssignal Logik

			-- Vertiakle Einstellungen
			v_DISPLAY		: integer := 1024;	-- Sichtbarer Bereich in Pixel
			v_porchFRONT	: integer := 1;		-- Vordere Schwarzschzlter in pixel
			v_porchBACK		: integer := 38;	-- Hintere Schwarzschulter in pixel
			v_syncPULSE		: integer := 3;		-- Synchronisierungsimpuls zwischen Vorderer/Hinterer Schulter in Pixel
			v_POLARITY		: STD_LOGIC := '1';	-- Positive Synchronisierungssignal Logik
	
			-- Pixel Einstellungen
			pxDATASIZE		: integer := 4;			-- Pixel Auflösung in Bit pro Kanal
			pxMAX			: integer := 12			-- max. Anzahl an Pixeln (horizontal/vertikal) 2^pxMAX
			);
	Port	(
			EN				:  in STD_LOGIC;
			
			-- VGA Taktfrequenzen
			CLK				:  in STD_LOGIC;
			
			-- Rot/Grün/Blau Daten für aktuellen Pixel
			pixelDATA		:  in STD_LOGIC_VECTOR((pxDATASIZE * 3) - 1 downto 0);
			
			-- Horizontal/Vertikal Synchronisierungssignal
			h_SYNC			: out STD_LOGIC;
			v_SYNC			: out STD_LOGIC;
			
			-- Ausgabedaten für Pixel auf welchen der Pixelzeiger referenziert ist
			vgaR			: out STD_LOGIC_VECTOR(pxDATASIZE - 1 downto 0);
			vgaG			: out STD_LOGIC_VECTOR(pxDATASIZE - 1 downto 0);
			vgaB			: out STD_LOGIC_VECTOR(pxDATASIZE - 1 downto 0);
			
			-- Positionsdaten des Pixelzeigers
			pixelX			: out unsigned((pxMAX - 1) downto 0);
			pixelY			: out unsigned((pxMAX - 1) downto 0)
			);
end vga;

--	VGA Darstellungsbereich/Signalverlauf, hoizontal sowie vertikal
--
--	+---------------------------------------------------------------+---+	+---+
--								h_Display							  f | p	| b
--																		+---+
--
--	+---------------------------------------------------------------+-----------+	+
--	|																|			|	| 
--	|																|			|	| v
--	|																|			|	| |
--	|																|			|	| D
--	|					Sicherbarer Bildbereich						|			|	| i
--	|																|			|	| s
--	|																|			|	| p
--	|																|			|	| l
--	|																|			|	| a
--	|																|			|	| y
--	|																|			|	|
--	+---------------------------------------------------------------+			|	+
--	|																			|	| f
--	|																			|	+---+
--	|						Schwarz Schulter									|	  p	|
--	|																			|	+---+
--	|																			|	| b
--	+---------------------------------------------------------------------------+	+
--
--	Der Synchronisierungsimpuls kann sowohl in positiver als auch negativer logik
--	ausgeführt sein. Dies ist spezifisch aus den VGA-Einstellungen zu übernehmen!

architecture Behavioral of vga is

	signal intvgaR		: STD_LOGIC_VECTOR(pxDATASIZE - 1 downto 0) := (others => '1');
	signal intvgaG		: STD_LOGIC_VECTOR(pxDATASIZE - 1 downto 0) := (others => '1');
	signal intvgaB		: STD_LOGIC_VECTOR(pxDATASIZE - 1 downto 0) := (others => '1');

begin

vgaR <= intvgaR;
vgaG <= intvgaG;
vgaB <= intvgaB;

process(EN, CLK, pixelDATA)

		-- Prozessinterne Variablen
		variable pixelXCNT	: unsigned((pxMAX - 1) downto 0) := (others => '0');	-- Prozess Pixelzähler in X-Richtung
		variable pixelYCNT	: unsigned((pxMAX - 1) downto 0) := (others => '0');	-- Prozess Pixelzähler in Y-Richtung
		
	begin
		-- Asynchrones Rücksetzten 
		if(EN = '0') Then
			
			-- Rücksetzen der internen Prozess Pixelzähler
			-- pixelXCNT := 0;
			-- pixelYCNT := 0;
		
			-- Rücksetzten der externen Pixel Positionszeiger
			pixelX <= (others => '0');
			pixelY <= (others => '0');
		
			h_SYNC <= '0';
			v_SYNC <= '0';
		
			intvgaR <= (others => '0');
			intvgaG <= (others => '0');
			intvgaB <= (others => '0');
		
		-- Taktflankengesteuerter Ablauf wenn Verarbeitung (über vgaMODE) angewählt
		elsif(rising_edge(CLK)) Then
			
			-- Wenn X-Pixelzähler >= Horizontale Pixellänge (gesamt)
			if (pixelXCNT >= (h_porchFRONT + h_porchBACK + h_syncPULSE + h_display - 1)) then
				-- Rücksetzten des X-Pixelzählers sowie inkrementieren des Y-Pixelzählers
				pixelXCNT := (others => '0');
				pixelYCNT := pixelYCNT + 1;
			else
				-- Erzeugen des horizontalen Synchronisierungssignals
				if(pixelXCNT > (h_DISPLAY + h_porchFRONT - 1) and pixelXCNT < (h_display + h_porchFRONT + h_syncPULSE - 1)) then
					h_SYNC <= h_POLARITY;
				else
					h_SYNC <= not(h_POLARITY);
				end if;
			
				-- Inkrementieren des Y-Pixelzählers
				pixelXCNT := pixelXCNT + 1;
			end if;

			-- Wenn Y-Pixelzähler >= Vertikale Pixellänge (gesamt)
			if(pixelYCNT >= (v_porchFRONT + v_porchBACK + v_syncPULSE + v_display) - 1) then
				-- Rücksetzen des Y-Pixelzählers
				pixelYCNT := (others => '0');
			else
				-- Erzeugen des vertikalen Synchronisierungssignals
				if(pixelYCNT > (v_display + v_porchFRONT - 1) and pixelYCNT < (v_display + v_porchFRONT + v_syncPULSE - 1)) then
					v_SYNC <= v_POLARITY;
				else
					v_SYNC <= not(v_POLARITY);
				end if;
			end if;

			-- Ausgabe der Pixeldaten
			if((pixelXCNT < (h_DISPLAY - 1)) and (pixelYCNT < (v_DISPLAY - 1))) Then
				-- Stand der internen Prozesspixelzähler auf externe Pixel Positionszeiger
				pixelX <= pixelXCNT;
				pixelY <= pixelYCNT;
				
				-- Ausgabe der Eingabedaten
				intvgaR <= pixeldata((pxDATASIZE * 3) - 1 downto (pxDATASIZE * 2));
				intvgaG <= pixeldata((pxDATASIZE * 2) - 1 downto pxDATASIZE);
				intvgaB <= pixeldata(pxDATASIZE - 1 downto 0);
			else
				-- Rücksetzen der Pixelzähler
				pixelX <= (others => '0');
			
				if(pixelYCNT > (v_DISPLAY - 1)) Then
					pixelY <= (others => '0');
				end if;
			
				-- Rücksetzten der VGA Datenausgänge
				intvgaR <= (others => '0');
				intvgaG <= (others => '0');
				intvgaB <= (others => '0');
			end if;
			
		end if;
end process;

end Behavioral;
