library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity comparador is
    generic (
        ANCHO  : positive := 16;
        UMBRAL : natural  := 580 -- 580 us (~10 cm)
    );
    port (
        dato_in   : in  std_logic_vector(ANCHO - 1 downto 0);
        menor_que : out std_logic
    );
end entity comparador;

architecture rtl of comparador is
begin
    menor_que <= '1' when unsigned(dato_in) < to_unsigned(UMBRAL, ANCHO) else '0';
end architecture rtl;