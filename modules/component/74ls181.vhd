
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
-- use IEEE.STD_LOGIC_ARITH.ALL; // niemals beide NUMERIC_STD und STD_LOGIC_ARITH verwenden!!!
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity alu is
	Generic(nWIDTH	:	INTEGER := 8;		-- BUS länge
			tDELAY	:	time := 4 ns	);	-- Gatter Laufzeiten
	Port (	EN, CLK		: in  STD_LOGIC;								-- Enable/Clock
			opA			: in  STD_LOGIC_VECTOR(nWIDTH - 1 downto 0);	-- Operand A
			opB			: in  STD_LOGIC_VECTOR(nWIDTH - 1 downto 0);	-- Operand B
			carryIN		: in  STD_LOGIC;								-- Carry BitIn
			MODE		: in  STD_LOGIC;								-- Modus
			CMD			: in  STD_LOGIC_VECTOR(3 downto 0);				-- Command
			DATA		: out STD_LOGIC_VECTOR(nWIDTH - 1 downto 0);	-- Data Out
			carryOUT,
			zeroFLAG,
			overFLOW 	: out STD_LOGIC);								-- Carry BitOut, Zeroflag, Overflow
end alu;

architecture Behavioral of alu is
	signal operandA, operandB, dataTEMP	:	STD_LOGIC_VECTOR(nWIDTH - 1 downto 0);
	signal dataMATH						:	STD_LOGIC_VECTOR(nWIDTH downto 0);
	signal cI, cO, oV					:	STD_LOGIC;
begin
	process(EN, CLK, MODE, CMD, opA, opB, carryIN ,cI, cO)
			variable x00_DATA, xFF_DATA		: STD_LOGIC_VECTOR(nWIDTH - 1 downto 0);
		begin
		
				operandA <= opA;	-- Temporäre ablage
				operandB <= opB;	-- Temporäre ablage
		
			if(EN = '1') then
				if(MODE = '1') then	-- Logische Operationen
					-- Befehlsdecoder
						case (CMD) is
							when "0000"	=>	dataTEMP <= not(operandA);										-- Befehl not(A)
							when "0001" =>	dataTEMP <= not(operandA or operandB);							-- Befehl not(A + B)
							when "0010" =>	dataTEMP <= not(operandA) and operandB;							-- Befehl not(A) * B
							when "0011" =>	dataTEMP <= x00_DATA;											-- Befehl 0
							when "0100" =>	dataTEMP <= not(operandA and operandB);							-- Befehl not(A * B)
							when "0101" =>	dataTEMP <= not(operandB);										-- Befehl not(B)
							when "0110" =>	dataTEMP <= operandA xor operandB;								-- Befehl A xor B
							when "0111" =>	dataTEMP <= operandA and not(operandB);							-- Befehl A * not(B)
							when "1000" =>	dataTEMP <= not(operandA) or operandB;							-- Befehl not(A) + B
							when "1001" =>	dataTEMP <= not(operandA xor operandB);							-- Befehl not(A xor B)
							when "1010" =>	dataTEMP <=	operandB;											-- Befehl load B
							when "1011" =>	dataTEMP <= operandA and operandB;								-- Befehl A * B
							when "1100" =>	dataTEMP <= xFF_DATA;											-- Befehl A + (shift A - 1) + 1
							when "1101" =>	dataTEMP <= operandA or not(operandB);							-- Befehl A + not(B)
							when "1110" =>	dataTEMP <= operandA or operandB;								-- Befehl A + B
							when "1111" =>	dataTEMP <= operandA;											-- Befehl load A
							when others =>	dataTEMP <= x00_DATA;
						end case;

				else	-- Arithmetische Operationen
					if(carryIN = '1') then	-- Operation wenn CarryBit='1'						
						-- Befehlsdecoder
						case (CMD) is
							-- Befehl lade A
							when "0000"	=>	dataTEMP <= operandA;
							-- Befehl A + B with Overflow (carryOut)
							when "0001"	=>	dataTEMP <= operandA or operandB;
							-- Befehl A + not(B) with Overflow (carryOut)
							when "0010"	=>	dataTEMP <= operandA or not(operandB);
							-- Befehl dataTEMP - 1
							when "0011"	=>	dataMATH <= std_logic_vector(unsigned(signed('0' & dataTEMP) - 1));
											dataTEMP <= dataMATH(nWIDTH - 1 downto 0);	cO <= dataMATH(nWIDTH);
							-- Befehl A + (A and not(B)) with Overflow (carryOut)
							when "0100"	=>	dataMATH <= std_logic_vector(unsigned(signed('0' & operandA) + signed('0' & (operandA and not(operandB)))));
											dataTEMP <= dataMATH(nWIDTH - 1 downto 0);	cO <= dataMATH(nWIDTH);
							-- Befehl (A or B) + (A and not(B)) with Overflow (carryOut)
							when "0101"	=>	dataMATH <= std_logic_vector(unsigned(signed('0' & (operandA or operandB)) + signed('0' & (operandA and not(operandB)))));
											dataTEMP <= dataMATH(nWIDTH - 1 downto 0);	cO <= dataMATH(nWIDTH);
							-- Befehl A - B - 1 with Overflow (carryOut)
							when "0110"	=>	dataMATH <= std_logic_vector(unsigned(signed('0' & operandA) - signed('0' & operandB) - 1));
											dataTEMP <= dataMATH(nWIDTH - 1 downto 0);	cO <= dataMATH(nWIDTH);
							-- Befehl (A and not(B)) - 1 with Overflow (carryOut)
							when "0111"	=>	dataMATH <= std_logic_vector(unsigned(signed('0' & (operandA and not(operandB))) - 1));
											dataTEMP <= dataMATH(nWIDTH - 1 downto 0);	cO <= dataMATH(nWIDTH);
							-- Befehl A + (A and B) with Overflow (carryOut)
							when "1000"	=>	dataMATH <= std_logic_vector(unsigned(signed('0' & operandA) + signed('0' & (operandA and operandB))));
											dataTEMP <= dataMATH(nWIDTH - 1 downto 0);	cO <= dataMATH(nWIDTH);
							-- Befehl A + B with Overflow (carryOut)
							when "1001"	=>	dataMATH <= std_logic_vector(unsigned(signed('0' & operandA) + signed('0' & operandB)));
											dataTEMP <= dataMATH(nWIDTH - 1 downto 0);	cO <= dataMATH(nWIDTH);
							-- Befehl (A or not(B)) + (A and B) with Overflow (carryOut)
							when "1010"	=>	dataMATH <= std_logic_vector(unsigned(signed('0' & (operandA or not(operandB))) + signed('0' & (operandA and operandB))));
											dataTEMP <= dataMATH(nWIDTH - 1 downto 0);	cO <= dataMATH(nWIDTH);
							-- Befehl A and B - 1 with Overflow (carryOut)
							when "1011"	=>	dataMATH <= std_logic_vector(unsigned(signed('0' & (operandA or operandB)) - 1));
											dataTEMP <= dataMATH(nWIDTH - 1 downto 0);	cO <= dataMATH(nWIDTH);
							-- Befehl A + A with Overflow (carryOut)
							when "1100"	=>	dataMATH <= std_logic_vector(unsigned(signed('0' & operandA) + signed('0' & operandA)));
											dataTEMP <= dataMATH(nWIDTH - 1 downto 0);	cO <= dataMATH(nWIDTH);
							-- Befehl (A or B) + B with Overflow (carryOut)
							when "1101"	=>	dataMATH <= std_logic_vector(unsigned(signed('0' & (operandA or operandB)) + signed('0' & operandA)));
											dataTEMP <= dataMATH(nWIDTH - 1 downto 0);	cO <= dataMATH(nWIDTH);
							-- Befehl (A or not(B)) + A with Overflow (carryOut)
							when "1110"	=>	dataMATH <= std_logic_vector(unsigned(signed('0' & (operandA or not(operandB))) + signed('0' & operandA)));
											dataTEMP <= dataMATH(nWIDTH - 1 downto 0);	cO <= dataMATH(nWIDTH);
							-- Befehl A - 1 with Overflow (carryOut)
							when "1111"	=>	dataMATH <= std_logic_vector(unsigned(signed('0' & operandA) - 1));
											dataTEMP <= dataMATH(nWIDTH - 1 downto 0);	cO <= dataMATH(nWIDTH);
							when others =>	dataTEMP <= xFF_DATA;
						end case;

					else	-- Operation wenn CarryBit='0'
					-- Befehlsdecoder
						case (CMD) is
							-- Befehl A + 1
							when "0000"	=>	dataMATH <= std_logic_vector(unsigned(signed('0' & operandA) + 1));
											dataTEMP <= dataMATH(nWIDTH - 1 downto 0);	cO <= dataMATH(nWIDTH);
							-- Befehl (A or B) + 1 with Overflow (carryOut)
							when "0001"	=>	dataMATH <= std_logic_vector(unsigned(signed('0' & (operandA or operandB)) + 1));
											dataTEMP <= dataMATH(nWIDTH - 1 downto 0);	cO <= dataMATH(nWIDTH);
							-- Befehl (A or not(B)) + 1 with Overflow (carryOut)
							when "0010"	=>	dataMATH <= std_logic_vector(unsigned(signed('0' & (operandA or not(operandB))) + 1));
											dataTEMP <= dataMATH(nWIDTH - 1 downto 0);	cO <= dataMATH(nWIDTH);
							-- Befehl dataTEMP - 1
							when "0011"	=>	dataTEMP <= dataTEMP;
							-- Befehl A + (A and not(B)) + 1 with Overflow (carryOut)
							when "0100"	=>	dataMATH <= std_logic_vector(unsigned(signed('0' & operandA) + signed('0' & (operandA and not(operandB))) + 1));
											dataTEMP <= dataMATH(nWIDTH - 1 downto 0);	cO <= dataMATH(nWIDTH);
							-- Befehl (A or B) + (A and not(B)) + 1 with Overflow (carryOut)
							when "0101"	=>	dataMATH <= std_logic_vector(unsigned(signed('0' & (operandA or operandB)) + signed('0' & (operandA and not(operandB))) + 1));
											dataTEMP <= dataMATH(nWIDTH - 1 downto 0);	cO <= dataMATH(nWIDTH);
							-- Befehl A - B with Overflow (carryOut)
							when "0110"	=>	dataMATH <= std_logic_vector(unsigned(signed('0' & operandA) - signed('0' & operandB)));
											dataTEMP <= dataMATH(nWIDTH - 1 downto 0);	cO <= dataMATH(nWIDTH);
							-- Befehl (A and not(B)) with Overflow (carryOut)
							when "0111"	=>	dataMATH <= std_logic_vector(unsigned(signed('0' & (operandA and not(operandB)))));
											dataTEMP <= dataMATH(nWIDTH - 1 downto 0);	cO <= dataMATH(nWIDTH);
							-- Befehl A + (A and B) + 1 with Overflow (carryOut)
							when "1000"	=>	dataMATH <= std_logic_vector(unsigned(signed('0' & operandA) + signed('0' & (operandA and operandB)) + 1));
											dataTEMP <= dataMATH(nWIDTH - 1 downto 0);	cO <= dataMATH(nWIDTH);
							-- Befehl A + B + 1 with Overflow (carryOut)
							when "1001"	=>	dataMATH <= std_logic_vector(unsigned(signed('0' & operandA) + signed('0' & operandB) + 1));
											dataTEMP <= dataMATH(nWIDTH - 1 downto 0);	cO <= dataMATH(nWIDTH);
							-- Befehl (A or not(B)) + (A and B) + 1 with Overflow (carryOut)
							when "1010"	=>	dataMATH <= std_logic_vector(unsigned(signed('0' & (operandA or not(operandB))) + signed('0' & (operandA and operandB)) + 1));
											dataTEMP <= dataMATH(nWIDTH - 1 downto 0);	cO <= dataMATH(nWIDTH);
							-- Befehl A and B with Overflow (carryOut)
							when "1011"	=>	dataMATH <= std_logic_vector(unsigned(signed('0' & (operandA and operandB))));
											dataTEMP <= dataMATH(nWIDTH - 1 downto 0);	cO <= dataMATH(nWIDTH);
							-- Befehl A + A + 1 with Overflow (carryOut)
							when "1100"	=>	dataMATH <= std_logic_vector(unsigned(signed('0' & operandA) + signed('0' & operandA) + 1));
											dataTEMP <= dataMATH(nWIDTH - 1 downto 0);	cO <= dataMATH(nWIDTH);
							-- Befehl (A or B) + A + 1 with Overflow (carryOut)
							when "1101"	=>	dataMATH <= std_logic_vector(unsigned(signed('0' & (operandA or operandB)) + signed('0' & operandA) + 1));
											dataTEMP <= dataMATH(nWIDTH - 1 downto 0);	cO <= dataMATH(nWIDTH);
							-- Befehl (A or not(B)) + A with Overflow (carryOut)
							when "1110"	=>	dataMATH <= std_logic_vector(unsigned(signed('0' & (operandA or not(operandB))) + signed('0' & operandA) + 1));
											dataTEMP <= dataMATH(nWIDTH - 1 downto 0);	cO <= dataMATH(nWIDTH);
							-- Befehl A - 1 with Overflow (carryOut)
							when "1111"	=>	dataTEMP <= operandA;
							when others =>	dataTEMP <= xFF_DATA;
						end case;

					end if;
				end if;

				if rising_edge(CLK) then	-- steigende Flanke
						DATA <= dataTEMP;
						carryOUT <= cO;

					if(dataTEMP = x00_DATA) then	-- Überprüfen ob Ergebnis = 0
						zeroFLAG <= '1';
					else
						zeroFLAG <= '0';
					end if;
					
				end if;
			else	-- Reset Outputs if EN='0'
				-- Entity Ausgänge
				carryOUT <= '0';
				zeroFLAG <= '0';
				overFLOW <= '0';

				-- Interne Signale
				cO <= '0';
				cI <= '0';
				oV <= '0';

				x00_DATA := (others => '0');
				xFF_DATA := (others => '1');
					
				DATA <= x00_DATA;

			end if;
			
	end process;
end Behavioral;
