library ieee;
use ieee.std_logic_1164.all;

entity and_gate_led is
  port
  (
    -- Inputs
    PMOD1 : in std_logic;
    PMOD2 : in std_logic;

    -- Outputs
    led5 : out std_logic;
    led3 : out std_logic;
    led4 : out std_logic
  );
end entity and_gate_led;

architecture RTL of and_gate_led is
  begin
    led5 <= PMOD1 xor PMOD2;
  end RTL;