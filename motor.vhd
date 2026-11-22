library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity motor is
    generic (
        BITS : positive := 8
    );
    port (
        clk     : in  std_logic;
        rst     : in  std_logic;
        tick    : in  std_logic;
        duty    : in  std_logic_vector(BITS - 1 downto 0);
        pwm_out : out std_logic
    );
end entity motor;

architecture rtl of motor is
    signal cnt : unsigned(BITS - 1 downto 0) := (others => '0');
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                cnt <= (others => '0');
            elsif tick = '1' then
                cnt <= cnt + 1;
            end if;
        end if;
    end process;

    pwm_out <= '1' when (cnt < unsigned(duty) and unsigned(duty) /= 0) else '0';
end architecture rtl;