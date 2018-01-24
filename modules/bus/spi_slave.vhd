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
-- Text: SPI Slave interface for data
--       transmission
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
			constant SPI_MODE	:  STD_LOGIC := '0'
			);
		Port(
			EN		:  in STD_LOGIC;
			SW		:  in STD_LOGIC_VECTOR(7 downto 0);
			SCK		:  in STD_LOGIC;
			SS		:  in STD_LOGIC;
			MOSI	:  in STD_LOGIC;
			MISO	: out STD_LOGIC := '0';
			DATA	: out STD_LOGIC_VECTOR(7 downto 0) := (others => '0')
			);
end spi_slave;

architecture Behavioural of spi_slave is
	signal LATCH	: STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
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

