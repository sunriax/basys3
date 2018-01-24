--	------------------------------------
--	Diplomarbeit elmProject@HTL-Rankweil
--	G.Raf@elmProject
--	2AAELI | 2016/2017
--	------------------------------------
--	File: vga.vhd
--	Version: v1.0
--	------------------------------------
--	VGA Ausgabemodul zum erzeugen der
--	ben�tigten Horizontal/Vertikalen
--	Synchronisierungssignale sowie zur
--	Einstellung der Aufl�sung und der
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
			pxDATASIZE		: integer := 4;			-- Pixel Aufl�sung in Bit pro Kanal
			pxMAX			: integer := 12			-- max. Anzahl an Pixeln (horizontal/vertikal) 2^pxMAX
			);
	Port	(
			EN				:  in STD_LOGIC;
			
			-- VGA Taktfrequenzen
			CLK				:  in STD_LOGIC;
			
			-- Rot/Gr�n/Blau Daten f�r aktuellen Pixel
			pixelDATA		:  in STD_LOGIC_VECTOR((pxDATASIZE * 3) - 1 downto 0);
			
			-- Horizontal/Vertikal Synchronisierungssignal
			h_SYNC			: out STD_LOGIC;
			v_SYNC			: out STD_LOGIC;
			
			-- Ausgabedaten f�r Pixel auf welchen der Pixelzeiger referenziert ist
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
--	ausgef�hrt sein. Dies ist spezifisch aus den VGA-Einstellungen zu �bernehmen!

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
		variable pixelXCNT	: unsigned((pxMAX - 1) downto 0) := (others => '0');	-- Prozess Pixelz�hler in X-Richtung
		variable pixelYCNT	: unsigned((pxMAX - 1) downto 0) := (others => '0');	-- Prozess Pixelz�hler in Y-Richtung
		
	begin
		-- Asynchrones R�cksetzten 
		if(EN = '0') Then
			
			-- R�cksetzen der internen Prozess Pixelz�hler
			-- pixelXCNT := 0;
			-- pixelYCNT := 0;
		
			-- R�cksetzten der externen Pixel Positionszeiger
			pixelX <= (others => '0');
			pixelY <= (others => '0');
		
			h_SYNC <= '0';
			v_SYNC <= '0';
		
			intvgaR <= (others => '0');
			intvgaG <= (others => '0');
			intvgaB <= (others => '0');
		
		-- Taktflankengesteuerter Ablauf wenn Verarbeitung (�ber vgaMODE) angew�hlt
		elsif(rising_edge(CLK)) Then
			
			-- Wenn X-Pixelz�hler >= Horizontale Pixell�nge (gesamt)
			if (pixelXCNT >= (h_porchFRONT + h_porchBACK + h_syncPULSE + h_display - 1)) then
				-- R�cksetzten des X-Pixelz�hlers sowie inkrementieren des Y-Pixelz�hlers
				pixelXCNT := (others => '0');
				pixelYCNT := pixelYCNT + 1;
			else
				-- Erzeugen des horizontalen Synchronisierungssignals
				if(pixelXCNT > (h_DISPLAY + h_porchFRONT - 1) and pixelXCNT < (h_display + h_porchFRONT + h_syncPULSE - 1)) then
					h_SYNC <= h_POLARITY;
				else
					h_SYNC <= not(h_POLARITY);
				end if;
			
				-- Inkrementieren des Y-Pixelz�hlers
				pixelXCNT := pixelXCNT + 1;
			end if;

			-- Wenn Y-Pixelz�hler >= Vertikale Pixell�nge (gesamt)
			if(pixelYCNT >= (v_porchFRONT + v_porchBACK + v_syncPULSE + v_display) - 1) then
				-- R�cksetzen des Y-Pixelz�hlers
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
				-- Stand der internen Prozesspixelz�hler auf externe Pixel Positionszeiger
				pixelX <= pixelXCNT;
				pixelY <= pixelYCNT;
				
				-- Ausgabe der Eingabedaten
				intvgaR <= pixeldata((pxDATASIZE * 3) - 1 downto (pxDATASIZE * 2));
				intvgaG <= pixeldata((pxDATASIZE * 2) - 1 downto pxDATASIZE);
				intvgaB <= pixeldata(pxDATASIZE - 1 downto 0);
			else
				-- R�cksetzen der Pixelz�hler
				pixelX <= (others => '0');
			
				if(pixelYCNT > (v_DISPLAY - 1)) Then
					pixelY <= (others => '0');
				end if;
			
				-- R�cksetzten der VGA Datenausg�nge
				intvgaR <= (others => '0');
				intvgaG <= (others => '0');
				intvgaB <= (others => '0');
			end if;
			
		end if;
end process;

end Behavioral;
