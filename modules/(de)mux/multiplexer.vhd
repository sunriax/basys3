--	------------------------------------
--	Diplomarbeit elmProject@HTL-Rankweil
--	G.Raf@elmProject
--	2AAELI | 2016/2017
--	------------------------------------
--	File: multiplexer.vhd
--	Version: v1.0
--	------------------------------------
--	Signalmultiplexer zum wandeln von
--	parallellen zu seriellen Signalen
--	------------------------------------

-- Standardbibliotheken einbinden
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity multiplexer is
 Generic(
 		constant EXPONENT	: integer range 0 to 8 := 3			-- 2^EXPONENT Datenbit Länge (2^3 = 8 bit)
 		);
	Port(
		EN			:  in STD_LOGIC;										-- Enable Signal
		ADDR		:  in STD_LOGIC_VECTOR(EXPONENT - 1 downto 0);		-- Kanalwahl Signal
		inDATA		:  in STD_LOGIC_VECTOR((2**EXPONENT) - 1 downto 0);	-- Eingabedaten
		outDATA		: out STD_LOGIC := '0'									-- Ausgabedaten
		);
end multiplexer;

architecture Behavioral of multiplexer is
begin
	outDATA <= inDATA(to_integer(unsigned(ADDR))) WHEN EN = '1' ELSE '0';
end Behavioral;
