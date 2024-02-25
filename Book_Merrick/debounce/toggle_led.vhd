library ieee;
use ieee.std_logic_1164.all;

entity toggle_led is
  port
  (
    -- Inputs
    i_clock : in std_logic;
    i_switch : in std_logic;

    -- Outputs
    o_led : out std_logic
  );
end entity toggle_led;

architecture RTL of toggle_led is

signal r_led : std_logic := '0';
signal r_switch : std_logic := '0';

begin
  process(i_clock) is
    begin
      if rising_edge(i_clock) then
        r_switch <= i_switch;
        if i_switch = '0' and r_switch = '1' then
          r_led <= not r_led;
        end if;
      end if;
  end process;

  o_led <= r_led;
end architecture RTL; 