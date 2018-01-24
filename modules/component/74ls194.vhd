
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity SN74LS194 is
    Port ( CLK		: in STD_LOGIC;
           RESET	: in STD_LOGIC;
           S		: in STD_LOGIC_VECTOR (1 downto 0);
           P		: in STD_LOGIC_VECTOR (3 downto 0);
           DSR		: in STD_LOGIC;
           DSL		: in STD_LOGIC;
           Q		: out STD_LOGIC_VECTOR (3 downto 0));
end SN74LS194;

architecture Behavioral of SN74LS194 is
	signal DATA	: STD_LOGIC_VECTOR(3 downto 0);
begin
	process(CLK, RESET)
		begin
			if(RESET = '0')then
				DATA <= "0000";
				Q <= "0000";
			else
				if rising_edge(CLK) then
					if(S = "00") then
						DATA <= DATA;
					elsif(S = "10") then
						DATA(0) <= DATA(1);
						DATA(1) <= DATA(2);
						DATA(2) <= DATA(3);
						
						if(DSL = '0') then
							DATA(3) <= '0';
						else
							DATA(3) <= '1';
						end if;
					elsif(S = "01") then
						DATA(3) <= DATA(2);
						DATA(2) <= DATA(1);
						DATA(1) <= DATA(0);
											
						if(DSR = '0') then
							DATA(0) <= '0';
						else
							DATA(0) <= '1';
						end if;
					elsif(S = "11") then
						DATA <= P;
					end if;
				end if;
				
				Q <= DATA;
				
			end if;
	end process;
end Behavioral;
