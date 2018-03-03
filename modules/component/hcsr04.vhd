-- -------------------------------------
-- SUNriaX Project
-- www.sunriax.at
-- -------------------------------------
-- Hardware: Basys3
-- Platform: Artix 7 CPG236 FPGA
-- -------------------------------------
-- Name: hcsr04.vhd
-- Ver.: 1.0 Release
-- Type: Behavioural
-- Text: Get the distance of an object
--       with the hcsr04 module
--
-- (c) 2017 SUNriaX, All rights reserved
-- https://github.com/sunriax/basys3
-- -------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity hcsr04 is
	-- System parameters
	Generic	(
			constant CLOCK		: integer := 100_000_000;	-- System clock speed
			constant TEMP		: integer := 20;			-- Air Temperature (can be optimized with a Temperature sensor)
			constant VELOCITY	: integer := 331500;		-- Air velocity in mm/s
			constant PULSEWIDTH	: integer := 1000;			-- Start clock cycles
			constant PULSEEXP	: integer := 10;			-- 2^PULSE_EXP > PULSEWIDTH !!!
			constant ECHOWIDTH	: integer := 21;			-- 2^ECHOWIDTH > CLOCK * MAX_ECHO_WIDTH(1/40Hz)
			constant DATAWIDTH	: integer := 16				-- Measurement output width
			);
	-- I/O signals
		Port(
			EN		:  in std_logic;
			clk		:  in std_logic;
			trigger	: out std_logic;
			echo	:  in std_logic;
			valid	: out std_logic;
			data	: out std_logic_vector((DATAWIDTH - 1) downto 0)
			);
end hcsr04;

architecture Behavioural of hcsr04 is

	constant ECHOMAX		:	unsigned(ECHOWIDTH - 1 downto 0) := (others => '1');

	signal echoperiod		:	unsigned(ECHOWIDTH - 1 downto 0) := (others => '0');
	signal startcycle		:	unsigned(PULSEEXP - 1 downto 0)	 := (others => '0');
	signal echostate		:	unsigned(1 downto 0) := (others => '0');

begin

proc_TRIGGER:	process(EN, clk)
				begin
					-- Asynchronous logic system
					if(EN = '0') then
					
						-- Reset all outputs
						trigger		<= '0';
						valid		<= '0';
						startcycle	<= (others => '0');
						data		<= (others => '0');
					
					-- Synchronous logic system
					elsif(rising_edge(clk)) then
					
						if(startcycle < PULSEWIDTH) then
					
							trigger <= '1';
							startcycle <= startcycle + 1;
						
						else
							
								trigger <= '0';
								echostate <= echostate(0) & echo;
								echoperiod <= echoperiod + 1;
							
							if(echoperiod >= ECHOMAX) then
							
								data <= (others => '0');
								startcycle <= (others => '0');
							
							else
							
								if(echostate = "01") then
								
									valid <= '0';
									--echoresult <= RESIZE((echoperiod * (VELOCITY + 600 * TEMP) / (2 * CLOCK)), 16);
									--data <= std_logic_vector(echoresult(data'HIGH downto 0));
									data <= std_logic_vector(RESIZE((echoperiod * (VELOCITY + 600 * TEMP) / (2 * CLOCK)), DATAWIDTH));
									
								elsif(echostate = "10") then
								
									valid <= '1';
									startcycle <= (others => '0');
									echoperiod <= (others => '0');
								
								end if;
							
							end if;
						end if;
					end if;
				end process proc_TRIGGER;

end Behavioural;
