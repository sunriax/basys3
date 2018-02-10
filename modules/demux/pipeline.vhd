--	-------------------------------------
--	Diplomarbeit elmProject@HTL-Rankweil
--	GÄCHTER Raffael
--	elm-project@hotmail.com
--	2AAELI | 2016/2017
--	-------------------------------------
--	File: pipeline.vhd
--	Version: v1.0
--	-------------------------------------
--	Pipline Schnittstelle mit asychronem
--	Reset um eine Taktverzögerung eines
--	Vector (Pipeline) zu erzeugen.
--	minimale verzögerung 1 Takt
--	(DATA_LOOP := 2)!
--	-------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;
-- niemals beide NUMERIC_STD und STD_LOGIC_ARITH verwenden!!!
--use IEEE.STD_LOGIC_ARITH.ALL;

entity pipeline is
	Generic	(
			constant DATA_LOOP	: integer range 0 to 32 := 2;	-- Einstellung der Taktverzögerung (Datenübernahme -> Datenausgabe)
			constant DATA_WIDTH	: integer range 0 to 64 := 8	-- Einstellung der Datenbreite (8 Bit Standarddatenbreite)
			);
		Port(
			EN		: in  STD_LOGIC;														-- Enable
			CLK		: in  STD_LOGIC;														-- Systemtakt
			dataIN	: in  STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);						-- Dateneingabe
			dataOUT	: out STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0) := (others => '0')	-- Datenausgabe
			);
end pipeline;

architecture Behavioral of pipeline is
	signal delay	: STD_LOGIC_VECTOR(((DATA_LOOP * DATA_WIDTH) - 1) downto 0) := (others => '0');										-- Verzögerungsvector
begin

	dataOUT <= delay(((DATA_LOOP * DATA_WIDTH) - 1)  downto ((DATA_LOOP * DATA_WIDTH) - DATA_WIDTH)) WHEN EN = '1' ELSE (others => '0');	-- Datenausgabe wenn Enable HIGH (Reset asynchron)

PROC:	process(CLK)
			begin
				-- Pipeline Funktion
				if(rising_edge(CLK)) Then

					-- Eingabedaten in Pipeline schreiben
					delay(DATA_WIDTH - 1 downto 0) <= dataIN;
					
						-- Loop je nach verzögerung automatisch einstellbar
						for I in DATA_LOOP downto 2 loop
							-- Daten durch Pipeline schieben
							delay(((I * 8) - 1) downto ((I - 1) * 8)) <= delay((((I - 1) * 8) - 1) downto (I - 2) * 8);
						end loop;
					
					-- Pipeline leeren wenn Enable Low (Synchron)
					if(EN = '0') Then
						-- Daten in Pipeline auf Low
						delay <= (others => '0');
					end if;
					
				end if;
		end process PROC;

end Behavioral;

