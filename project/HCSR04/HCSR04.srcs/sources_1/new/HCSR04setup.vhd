-- -------------------------------------
-- SUNriaX Project
-- www.sunriax.at
-- -------------------------------------
-- Hardware: Basys3
-- Platform: Artix 7 CPG236 FPGA
-- -------------------------------------
-- Name: HCSR04setup.vhd
-- Ver.: 1.0 Release
-- Type: Structure
-- Text: Connecting the HCSR04 data to
--       an SPI bus master
--
-- (c) 2017 SUNriaX, All rights reserved
-- https://github.com/sunriax/basys3
-- -------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity HCSR04setup is
	Generic	(
			constant CLOCK		: integer := 100_000_000;		-- System speed (100 MHz)
			constant DATAWIDTH	: integer := 16							-- Datawidthof hcsr04DATA
			);

		Port(
			clk			:	 in std_logic;
			EN			:	 in std_logic;
			
			-- spiCLK		:	 in std_logic;
			-- spiMOSI		:	 in std_logic;
			-- spiSS		:	 in std_logic;
			-- spiMISO		:	out std_logic;
			
			trigger		: out std_logic;
			echo		:  in std_logic;
			valid		: out std_logic;
			data		: out std_logic_vector((DATAWIDTH - 1) downto 0)
			);
end HCSR04setup;

architecture Structure of HCSR04setup is

	component hcsr04 is
		Generic	(
				constant CLOCK		: integer;
				constant DATAWIDTH	: integer
				);
			Port(
				EN		:  in std_logic;
				clk		:  in std_logic;
				trigger	: out std_logic;
				echo	:  in std_logic;
				valid	: out std_logic;
				data	: out std_logic_vector((DATAWIDTH - 1) downto 0)
				);
	end component hcsr04;

begin

UUhcsr04: hcsr04	 generic map(
								CLOCK		=> 100_000_000,
								DATAWIDTH	=> DATAWIDTH
								)
						port map(
								EN		=> EN,
								clk		=> clk,
								trigger	=> trigger,
								echo	=> echo,
								valid	=> valid,
								data	=> data
								);

end Structure;
