library ieee;
use ieee.std_logic_1164.all;

entity debounce_top is
  port
  (
    -- Input
    i_clock : in std_logic;
    i_switch : in std_logic;

    -- Output
    o_led : out std_logic
  );
end entity debounce_top;

architecture RTL of debounce_top is
  signal w_debounced_switch : std_logic;
begin
  debounce_inst : entity work.debounce_filter
    generic map
    (
      DEBOUNCE_LIMIT => 250000
    )
    port map
    (
      i_clock => i_clock,
      i_bouncy => i_switch,
      o_debounced => w_debounced_switch
    );
  toggle_led_inst : entity work.toggle_led
    port map
    (
      i_clock => i_clock,
      i_switch => w_debounced_switch,
      o_led => o_led
    );
end architecture RTL;