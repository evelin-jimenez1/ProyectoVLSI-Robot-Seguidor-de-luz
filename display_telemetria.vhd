library ieee;
use ieee.std_logic_1164.all;

entity display_telemetria is
    generic (
        ACTIVO_BAJO : boolean := true -- true para Terasic DE10-Lite
    );
    port (
        bin_in  : in  std_logic_vector(3 downto 0);
        seg_out : out std_logic_vector(6 downto 0) -- g f e d c b a
    );
end entity display_telemetria;

architecture rtl of display_telemetria is
    signal seg_alto : std_logic_vector(6 downto 0);
begin
    with bin_in select
        seg_alto <= "0111111" when "0000", -- 0
                    "0000110" when "0001", -- 1 (BUSCAR)
                    "1011011" when "0010", -- 2 (SEGUIR)
                    "1001111" when "0011", -- 3 (ESQUIVA)
                    "1100110" when "0100", -- 4 (GIRO-ESQUINA)
                    "1101101" when "0101", -- 5 (META)
                    "1111101" when "0110", -- 6
                    "0000111" when "0111", -- 7
                    "1111111" when "1000", -- 8
                    "1101111" when "1001", -- 9
                    "1110111" when "1010", -- A
                    "1111100" when "1011", -- b
                    "0111001" when "1100", -- C
                    "1011110" when "1101", -- d
                    "1111001" when "1110", -- E
                    "1110001" when "1111", -- F
                    "0000000" when others;

    seg_out <= not seg_alto when ACTIVO_BAJO else seg_alto;
end architecture rtl;