library ieee;
use ieee.std_logic_1164.all;

entity verificador is
    generic (
        ANCHO    : positive := 4;
        INVERTIR : boolean  := false
    );
    port (
        clk   : in  std_logic;
        rst   : in  std_logic;
        d_in  : in  std_logic_vector(ANCHO - 1 downto 0);
        d_out : out std_logic_vector(ANCHO - 1 downto 0)
    );
end entity verificador;

architecture rtl of verificador is
    signal ff1, ff2 : std_logic_vector(ANCHO - 1 downto 0) := (others => '0');
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                ff1 <= (others => '0');
                ff2 <= (others => '0');
            else
                ff1 <= d_in;
                ff2 <= ff1;
            end if;
        end if;
    end process;

    d_out <= not ff2 when INVERTIR else ff2;
end architecture rtl;