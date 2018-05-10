--	-------------------------------------
--	Diplomarbeit elmProject@HTL-Rankweil
--	GÄCHTER Raffael
--	elm-project@hotmail.com
--	2AAELI | 2016/2017
--	-------------------------------------
--	File: pipelogic.vhd
--	Version: v1.0
--	-------------------------------------
--	Pipelogic Schnittstelle mit
--	asynchronem Reset, um eine
--	Taktverzögerung (Pipelogic)
--	eines Logikzustands zu erzeugen.
--	minimale verzögerung 1 Takt
--	(DATA_LOOP := 2)!
--	-------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;
-- niemals beide NUMERIC_STD und STD_LOGIC_ARITH verwenden!!!
--use IEEE.STD_LOGIC_ARITH.ALL;

entity pipelogic is
	Generic	(
			constant DATA_LOOP	: integer range 0 to 32 := 2	-- Einstellung der Taktverzögerung (Datenübernahme -> Datenausgabe)
			);
		Port(
			EN		: in  STD_LOGIC;		-- Enable
			CLK		: in  STD_LOGIC;		-- Systemtakt
			dataIN	: in  STD_LOGIC;		-- Dateneingabe
			dataOUT	: out STD_LOGIC := '0'	-- Datenausgabe
			);
end pipelogic;

architecture Behavioral of pipelogic is
	signal delay	: STD_LOGIC_VECTOR(DATA_LOOP - 1 downto 0) := (others => '0');	-- Verzögerungsvector
begin

	dataOUT <= delay(DATA_LOOP - 1) WHEN EN = '1' ELSE '0';	-- Datenausgabe wenn Enable HIGH (Reset asynchron)

PROC:	process(CLK)
			begin
				-- Pipelogic Funktion
				if(rising_edge(CLK)) Then

					-- Eingabedaten in Pipelogic schreiben
					delay <= delay(DATA_LOOP - 2 downto 0) & dataIN;

					-- Pipelogic leeren wenn Enable Low (Synchron)
					if(EN = '0') Then
						-- Daten in Pipelogic auf Low
						delay <= (others => '0');
					end if;
					
				end if;
		end process PROC;

end Behavioral;
