-- -------------------------------------
-- SUNriaX Project
-- www.sunriax.at
-- -------------------------------------
-- Hardware: Basys3
-- Platform: Artix 7 CPG236 FPGA
-- -------------------------------------
-- Name: spi_slave.vhd
-- Ver.: 1.0 Release
-- Type: Behavioural
-- Text: Transmit/Receive data over SPI
--       bus protocol
--
-- (c) 2017 SUNriaX, All rights reserved
-- https://github.com/sunriax/basys3
-- -------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity spi_slave is
	Generic	(
			constant DATAWIDTH		:	integer		:= 16;
			constant SPI_POLARITY	: 	std_logic	:= '0';
			constant SPI_PHASE		: 	std_logic	:= '0'
			);
		Port(
			EN		:  in std_logic;
			clk		:  in std_logic;
			valid	:  in std_logic;
			dataIN	:  in std_logic_vector(DATAWIDTH - 1 downto 0) := (others => '0');
			dataOUT	:  in std_logic_vector(DATAWIDTH - 1 downto 0) := (others => '0');
			SCK		:  in std_logic;
			SS		:  in std_logic;
			MOSI	:  in std_logic;
			MISO	: out std_logic := '0'
			);
end spi_slave;

architecture Behavioural of spi_slave is
	signal LATCH	: std_logic_vector(7 downto 0) := (others => '0');
begin

MISO <= MOSI;

FF:	process(SCK, EN, SS)
		begin
			-- Asynchrones rücksetzten
			if(EN = '0') Then

				LATCH <= (others => '0');
				
			-- Wenn steigende Taktflanke
			elsif(falling_edge(SCK)) Then
				-- Nur durchführen wenn SS LOW
				if(SS= '0') Then
					-- Schiebeoperation
					LATCH <= LATCH(6 downto 0) & MOSI;
				end if;
			end if;
		end process FF;

CS:	process(SCK, SS, EN)
		begin
			-- Asynchrones rücksetzten
			if(EN = '0') Then
		
				DATA <= (others => '0');
				
			-- Wenn steigende Taktflanke
			elsif(rising_edge(SS)) Then
			
				-- Schiebeoperation
				DATA <= LATCH;
				
			end if;
	end process CS;

end Behavioural;

