library ieee;
use ieee.std_logic_1164.all;

entity watchdog is
    generic (
        LIMITE : positive := 3 -- 3 ticks de 1 s = 3 segundos
    );
    port (
        clk     : in  std_logic;
        rst     : in  std_logic;
        tick    : in  std_logic;
        en      : in  std_logic;
        clear   : in  std_logic;
        timeout : out std_logic
    );
end entity watchdog;

architecture rtl of watchdog is
    signal cnt : integer range 0 to LIMITE := 0;
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' or clear = '1' then
                cnt     <= 0;
                timeout <= '0';
            elsif en = '1' and tick = '1' then
                if cnt >= LIMITE - 1 then
                    cnt     <= LIMITE;
                    timeout <= '1';
                else
                    cnt     <= cnt + 1;
                    timeout <= '0';
                end if;
            end if;
        end if;
    end process;
end architecture rtl;