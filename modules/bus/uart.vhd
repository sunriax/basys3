-- -------------------------------------
-- SUNriaX Project
-- www.sunriax.at
-- -------------------------------------
-- Hardware: Basys3
-- Platform: Artix 7 CPG236 FPGA
-- -------------------------------------
-- Name: bridge.vhd
-- Ver.: 1.0 Release
-- Type: Behavioural
-- Text: UART Receiver/Transmitter for
--       data transmission
--
-- (c) 2017 SUNriaX, All rights reserved
-- https://github.com/sunriax/basys3
-- -------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Modulkopf
entity uart is
	 Generic(
			-- Systemeinstellungen
			constant CLOCK		:	integer := 100 * 10**6;					-- Systemtakt 100 MHz
			constant SAMPLE		:	integer range 1 to 16 := 16;			-- Abtastungen/Bit
			constant DECISION	:	integer range 1 to 4  := 3;				-- Vergleiche/Bit (Mehrheitsentscheidung)
			
			-- UART Einstellungen
			constant DATASIZE	:	integer range 7 to 9 := 8;				-- Datenbreite
			constant PARITY		:	integer range 0 to 2 := 0;				-- Paritätsbit (0=None, 1=Even, 2=Odd)
			constant STOPBIT	:	integer range 1 to 2 := 1;				-- 1=1 Stoppbit, 2=2 Stoppbit
			constant CONTROL	:	integer range 0 to 3 := 0;				-- Flusskontrolle (0=None, 1=CTS/RTS, 2=XON/XOFF, 3=CTS/RTS+XON/XOFF)
			constant BAUD		:	integer range 1200 to 921600 := 921600;	-- Übertragungsrate in Bits/Sekunde
	 		
	 		-- FIFO Einstellungen
	 		constant MEMORY		:	integer	range 1 to 1000 := 32			-- Anzahl der Puffergröße
	 		);

		Port(
			-- Enable und Takteingang
			EN      :  in std_logic;
			clk     :  in std_logic;
			
			-- UART Datenleitung
			TXD     : out std_logic;
			RXD     :  in std_logic;
			
			-- UART Handshake
			CTS     :  in std_logic;
			RTS     : out std_logic;
			
			-- Daten Ein/Ausgabe
			dataset :  in std_logic_vector(DATASIZE - 1 downto 0);
			set     :  in std_logic;
			dataget : out std_logic_vector(DATASIZE - 1 downto 0);
			get     :  in std_logic;
			
			-- Status Register
			SREG    : out std_logic_vector(7 downto 0)
			);
end uart;

-- Modulbeschreibung
architecture Behavioral of uart is

begin


end Behavioral;
