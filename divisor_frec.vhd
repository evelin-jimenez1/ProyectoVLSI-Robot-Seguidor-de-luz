library ieee;
use ieee.std_logic_1164.all;

entity divisor_frec is
    generic (
        N : positive := 50 -- 50 MHz / N
    );
    port (
        clk  : in  std_logic;
        rst  : in  std_logic;
        tick : out std_logic
    );
end entity divisor_frec;

architecture rtl of divisor_frec is
    signal cnt : integer range 0 to N - 1 := 0;
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                cnt  <= 0;
                tick <= '0';
            elsif cnt = N - 1 then
                cnt  <= 0;
                tick <= '1';
            else
                cnt  <= cnt + 1;
                tick <= '0';
            end if;
        end if;
    end process;
end architecture rtl;