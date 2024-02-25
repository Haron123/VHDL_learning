library ieee;
use ieee.std_logic_1164.all;

entity toggleled is
  port
  (
    -- Inputs
    clock : in std_logic;
    PMOD1 : in std_logic;

    -- Outputs
    led4 : out std_logic
  );
end entity toggleled;

architecture RTL of toggleled is
  signal r_led4 : std_logic := '0';
  signal r_led4_delay : std_logic := '0';

  begin
    process(clock) is
      begin
        if rising_edge(clock) 
        then
          -- Sequential
          r_led4 <= not r_led4;
        end if;
    end process;

    -- Combitional
    led4 <= r_led4;
end architecture RTL;
    