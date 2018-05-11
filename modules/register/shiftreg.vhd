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
			constant DATAWIDTH : integer := 8
			);
	-- I/O signals
		Port(
			EN      :  in std_logic;
			SCK     :  in std_logic;
			CS      :  in std_logic;
			dIN     :  in std_logic;
			
			LOAD    :  in std_logic;
			dataIN  :  in std_logic_vector(DATAWIDTH - 1 downto 0);
			
			dOUT    : out std_logic;
			dataOUT : out std_logic_vector(DATAWIDTH - 1 downto 0)
			);
end shiftreg;

architecture Behavioral of shiftreg is
	signal intSCK	: std_logic := '0';
	signal intSHIFT	: unsigned(DATAWIDTH - 1 downto 0) := (others => '0');
begin

intSCK <= SCK WHEN CS = '0' ELSE not(LOAD); 

proc_status:	process(EN, CS, LOAD)
					
				begin
			
					if(EN = '0') then
					
						dataOUT <= (others => 'Z');
					
					elsif(rising_edge(CS) or (falling_edge(LOAD) and CS = '1')) then
						
						if(LOAD = '0') then
						
							dataOUT <= dataIN;
						
						else
						
							dataOUT <= std_logic_vector(intSHIFT);
						
						end if;

					end if;
				
				end process proc_status;


proc_shifter:	process(EN, intSCK)
					
				begin
				
					if(EN = '0') then
					
						dOUT <= '0';
						intSHIFT <= (others => '0');
					
					elsif(rising_edge(intSCK)) then
					
						if(CS = '0') then
						
							dOUT <= intSHIFT(DATAWIDTH - 1);
							intSHIFT <= intSHIFT(6 downto 0) & dIN;
						
						else
						
							intSHIFT <= unsigned(dataIN);
							dOUT <= '0';
						
						end if;
						
					end if;
				
				end process proc_shifter;

end Behavioral;
