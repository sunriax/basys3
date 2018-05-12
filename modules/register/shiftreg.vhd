-- -------------------------------------
-- SUNriaX Project
-- www.sunriax.at
-- -------------------------------------
-- Hardware: Basys3
-- Platform: Artix 7 CPG236 FPGA
-- -------------------------------------
-- Name: shiftreg.vhd
-- Ver.: 1.0 Release
-- Type: Behavioural
-- Text: Module for shifting bits to
--       a latch or catching bits from
--       the latch
--
-- (c) 2017 SUNriaX, All rights reserved
-- https://github.com/sunriax/basys3
-- -------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity shiftreg is
	-- System parameters 
	 Generic(
			constant DATAWIDTH	: integer := 8;		-- Setup the datawidth of the shiftregister and I/O
			constant IN2OUT		: std_logic := '1'	-- Setup if the input should be gated to output
													-- if they are loaded in the shiftregister
			);
	-- I/O signals
		Port(
			EN      :  in std_logic;								-- Enable
			SCK     :  in std_logic;								-- Shiftclock
			CS      :  in std_logic;								-- Chip select
			dIN     :  in std_logic;								-- Serial data input
			
			LOAD    :  in std_logic;								-- Load data from parallel input 
			dataIN  :  in std_logic_vector(DATAWIDTH - 1 downto 0);	-- Parallel data input
			
			dOUT    : out std_logic;								-- Serial data output
			dataOUT : out std_logic_vector(DATAWIDTH - 1 downto 0)	-- Parallel data output
			);
end shiftreg;

architecture Behavioral of shiftreg is
	signal intSCK	: std_logic := '0';										-- internal SCK Clock
	signal intSHIFT	: unsigned(DATAWIDTH - 1 downto 0) := (others => '0');	-- internal SHIFT register
begin

intSCK <= SCK WHEN CS = '0' ELSE not(LOAD);	-- If CS is LOW the Clock will be generated through SCK signal
											-- otherwise it will be generated from inverted LOAD signal

-- Register Status
proc_status:	process(EN, CS, LOAD)
				begin
			
					-- Asynchronous logic system
					if(EN = '0') then
					
						dataOUT <= (others => 'Z');
					
					-- (Half)Synchronous logic system
					elsif(rising_edge(CS) or (falling_edge(LOAD) and CS = '1')) then
						
						-- Check if LOAD command has been executed
						if(LOAD = '0') then
						
							-- Check if LOAD command is enabled
							if(IN2OUT = '1') then
						
								-- Write input data to output data latch
								dataOUT <= dataIN;
						
							end if;
						
						else
						
							-- If CS command has been executed load internal shiftregister to output data latch
							dataOUT <= std_logic_vector(intSHIFT);
							
						end if;

					end if;
				
				end process proc_status;

-- Register Shift
proc_shifter:	process(EN, intSCK)
				begin
				
					-- Asynchronous logic system
					if(EN = '0') then
					
						-- Reset internal shift register
						intSHIFT <= (others => '0');
					
					-- Synchronous logic system
					elsif(rising_edge(intSCK)) then
					
						-- Check if chip select is LOW
						if(CS = '0') then
						
							-- Shift register and add new dIN bit
							intSHIFT <= intSHIFT(6 downto 0) & dIN;
						
						else
						
							-- If chip select is HIGH load input data into internal shift register
							intSHIFT <= unsigned(dataIN);
						
						end if;
						
					end if;
				
				end process proc_shifter;

-- Shift to Next Register
proc_next:		process(EN, intSCK)
				begin
				
					-- Asynchronous logic system
					if(EN = '0') then
					
						-- Reset serial data output
						dOUT <= '0';
					
					-- Synchronous logic system
					elsif(rising_edge(intSCK)) then
					
						-- Check if Chip select is low
						if(CS = '0') then
						
							-- Set last register bit to serial data output
							dOUT <= intSHIFT(DATAWIDTH - 1);
						
						else
						
							-- Set last register bit to LOW
							dOUT <= '0';
						
						end if;
						
					end if;
				
				end process proc_next;

end Behavioral;
