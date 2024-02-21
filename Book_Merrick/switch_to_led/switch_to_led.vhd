library IEEE;
use IEEE.std_logic_1164.all;

entity switches_to_leds is
  port
  (
    -- Inputs
    PMOD1 : in std_logic;

    -- Outputs
    o_led5 : out std_logic
  );
end entity switches_to_leds;

architecture RTL of switches_to_leds is
  begin
    o_led5 <= PMOD1;
  end RTL;