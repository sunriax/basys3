--	--------------- Module ---------------
--	SUNriaX Technology!
--	GÄCHTER R.
--	
--	mail: https://www.sunriax.at/contact
--	web:  https://www.sunriax.at
--  git:  https://github.com/sunriax/
--	
--	(c) 2017 SUNriaX, All rights reserved
--	--------------------------------------
--	File: fifo_tb.vhd
--	Version: v1.0
--	--------------------------------------
--	Testbench zum testen des FIFO Moduls
--	--------------------------------------

library IEEE;
library UNISIM;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use UNISIM.VComponents.all;

entity fifo_tb is
--  Port ( );
end fifo_tb;

architecture Simulation of fifo_tb is

	-- Taktdefinitionen
	constant	clk_period	: time := 10 ns;	-- Simulationstakt (100 MHz)
	signal 		clk			: std_logic := '0';	-- Simulationstaktsignal

	-- Simulationskonstanten
	constant DATASIZE		: integer := 8;
	constant MEMORY			: integer := 3;

	-- Simulations Signale
	signal EN			: std_logic := '0';
	signal dataset		: std_logic_vector(DATASIZE - 1 downto 0) := (others => '0');
	signal set			: std_logic := '0';
	signal dataget		: std_logic_vector(DATASIZE - 1 downto 0) := (others => '0');
	signal get			: std_logic := '0';
	signal SREG			: std_logic_vector(3 downto 0) := (others => '0');

	-- Komponentendeklaration
	component fifo is
		 Generic(
				constant DATASIZE	:	integer;
				constant MEMORY		:	integer
				);
			Port(
				EN      :  in std_logic;
				clk     :  in std_logic;
				dataset :  in std_logic_vector(DATASIZE - 1 downto 0);
				set     :  in std_logic;
				dataget : out std_logic_vector(DATASIZE - 1 downto 0);
				get     :  in std_logic;
				SREG    : out std_logic_vector(3 downto 0)
				);
	end component fifo;

begin

-- Testkomponente instanzieren
UUT:	fifo	 generic map(
							DATASIZE 	=> DATASIZE,
							MEMORY		=> MEMORY
							)
					port map(
							EN		=>	EN,
							clk		=>	clk,
							dataset	=>	dataset,
							set		=>	set,
							dataget	=>	dataget,
							get		=>	get,
							SREG	=>	SREG
							);

-- Taktsignal erzeugen
procCLK:	process
						begin
							clk <= '0';	wait for clk_period/2;
							clk <= '1';	wait for clk_period/2;
					end process procCLK;

-- Simulationsprozess
procSIM:	process
				begin
					-- Initialisierung
					EN <= '0';	set <= '0';	dataset	<= (others => '0');	get <= '0';	wait for clk_period * 3;
					
					-- Datensatz in FIFO schreiben
					EN <= '1';	set <= '1';	dataset	<= x"E3";						wait for clk_period;
								set <= '1';	dataset	<= x"35";						wait for clk_period;
								set <= '1';	dataset	<= x"74";						wait for clk_period;
								set <= '1';	dataset	<= x"23";						wait for clk_period;
								set <= '1';	dataset	<= x"10";						wait for clk_period;
								set <= '1';	dataset	<= x"82";						wait for clk_period;
								set <= '1';	dataset	<= x"91";						wait for clk_period;
								set <= '1';	dataset	<= x"35";						wait for clk_period;
								set <= '0';	dataset	<= (others => '0');				wait for clk_period * 3;						
								
					-- Datensatz aus FIFO lesen
																		get <= '1';	wait for clk_period * 4;
																		get <= '0';	wait for clk_period * 3;
																		get <= '1';	wait for clk_period * 4;
																		get <= '0';	wait for clk_period * 3;
					
					-- Datensatz in FIFO schreiben
					EN <= '1';	set <= '1';	dataset	<= x"E3";						wait for clk_period;
								set <= '1';	dataset	<= x"35";						wait for clk_period;
								set <= '1';	dataset	<= x"74";						wait for clk_period;
								set <= '1';	dataset	<= x"23";						wait for clk_period;
								set <= '1';	dataset	<= x"10";						wait for clk_period;
								set <= '1';	dataset	<= x"82";						wait for clk_period;
								set <= '1';	dataset	<= x"91";						wait for clk_period;
								set <= '1';	dataset	<= x"35";						wait for clk_period;
					
					-- FIFO Voll, Daten schreiben fortsetzen
								set <= '1';	dataset	<= x"44";						wait for clk_period;
								set <= '1';	dataset	<= x"AA";						wait for clk_period;
								set <= '0';	dataset	<= (others => '0');				wait for clk_period * 3;
					
					-- Datensatz aus FIFO lesen
					-- x44, xAA dürfen nicht vorkommen
																		get <= '1';	wait for clk_period * 4;
																		get <= '0';	wait for clk_period * 3;
																		get <= '1';	wait for clk_period * 4;
																		get <= '0';	wait for clk_period * 3;
																		get <= '1';	wait for clk_period * 4;
																		get <= '0';	wait for clk_period * 3;
																		
					-- Datensatz aus FIFO lesen mit anschließendem auslesen
					-- Überprüfen ob Fifo bei Adressüberlauf weiterhin funktioniert
					EN <= '1';	set <= '1';	dataset	<= x"E3";						wait for clk_period;
                                set <= '1'; dataset <= x"35";                       wait for clk_period;
                                set <= '1'; dataset <= x"74";                       wait for clk_period;
                                set <= '1'; dataset <= x"23";                       wait for clk_period;
								set <= '1'; dataset <= x"74";                       wait for clk_period;
                                set <= '1'; dataset <= x"23";                       wait for clk_period;
								set <= '0';								get <= '1';	wait for clk_period * 2;
																		get <= '0';	wait for clk_period * 2;
								set <= '1'; dataset <= x"A2";                       wait for clk_period;
								set <= '1'; dataset <= x"07";                       wait for clk_period;
								set <= '0';								get <= '1';	wait for clk_period * 2;
																		get <= '0';	wait for clk_period * 2;
								set <= '1'; dataset <= x"63";                       wait for clk_period;
								set <= '1'; dataset <= x"54";                       wait for clk_period;
								set <= '0';								get <= '1';	wait for clk_period * 2;
																		get <= '0';	wait for clk_period * 2;
								set <= '1'; dataset <= x"31";                       wait for clk_period;
								set <= '1'; dataset <= x"ED";                       wait for clk_period;
								set <= '0';
								
								set <= '0';	dataset	<= (others => '0');	get <= '0';	wait for clk_period * 3;
					EN <= '0';

				-- Ablauf stoppen
				wait;
			end process procSIM;

end Simulation;
