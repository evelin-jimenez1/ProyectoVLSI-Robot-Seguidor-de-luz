library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ultrasonico is
    generic (
        UMBRAL_US  : positive := 870;   -- 870 us (~15 cm), 580 us (~10 cm)
        TIMEOUT_US : positive := 38000  -- Tiempo máximo sin eco
    );
    port (
        clk     : in  std_logic;
        rst     : in  std_logic;
        tick_us : in  std_logic;
        start   : in  std_logic;
        echo    : in  std_logic;
        trig    : out std_logic;
        alerta  : out std_logic;
        dist_us : out std_logic_vector(15 downto 0)
    );
end entity ultrasonico;

architecture rtl of ultrasonico is
    type t_est is (IDLE, DISPARO, ESPERA, MEDIR);
    signal est     : t_est := IDLE;
    signal us_cnt  : unsigned(15 downto 0) := (others => '0');
    signal dist_r  : unsigned(15 downto 0) := to_unsigned(TIMEOUT_US, 16);
    signal alert_r : std_logic := '0';
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                est     <= IDLE;
                us_cnt  <= (others => '0');
                trig    <= '0';
                alert_r <= '0';
                dist_r  <= to_unsigned(TIMEOUT_US, 16);
            else
                trig <= '0';
                case est is
                    when IDLE =>
                        if start = '1' then
                            us_cnt <= (others => '0');
                            est    <= DISPARO;
                        end if;

                    when DISPARO =>
                        trig <= '1';
                        if tick_us = '1' then
                            if us_cnt = 10 then
                                us_cnt <= (others => '0');
                                est    <= ESPERA;
                            else
                                us_cnt <= us_cnt + 1;
                            end if;
                        end if;

                    when ESPERA =>
                        if echo = '1' then
                            us_cnt <= (others => '0');
                            est    <= MEDIR;
                        elsif tick_us = '1' then
                            if us_cnt >= TIMEOUT_US then
                                alert_r <= '0';
                                dist_r  <= to_unsigned(TIMEOUT_US, 16);
                                est     <= IDLE;
                            else
                                us_cnt <= us_cnt + 1;
                            end if;
                        end if;

                    when MEDIR =>
                        if echo = '0' then
                            dist_r <= us_cnt;
                            if us_cnt < UMBRAL_US then
                                alert_r <= '1';
                            else
                                alert_r <= '0';
                            end if;
                            est <= IDLE;
                        elsif tick_us = '1' then
                            if us_cnt >= TIMEOUT_US then
                                alert_r <= '0';
                                dist_r  <= to_unsigned(TIMEOUT_US, 16);
                                est     <= IDLE;
                            else
                                us_cnt <= us_cnt + 1;
                            end if;
                        end if;
                end case;
            end if;
        end if;
    end process;

    alerta  <= alert_r;
    dist_us <= std_logic_vector(dist_r);
end architecture rtl;