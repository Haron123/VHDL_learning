library ieee;
use ieee.std_logic_1164.all;

entity debounce_filter is
  generic(DEBOUNCE_LIMIT : integer := 20);
  port
  (
    -- Input
    i_clock : in std_logic;
    i_bouncy : in std_logic;

    -- Output
    o_debounced : out std_logic
  );
end entity debounce_filter;

architecture RTL of debounce_filter is
  signal r_counter : integer range 0 to DEBOUNCE_LIMIT := 0;
  signal r_state : std_logic := '0';
begin
  process(i_clock) is
  begin
    if rising_edge(i_clock) then
      -- Button has been pressed (Button doesnt equal previous state) and counter below debounce limit
      if(i_bouncy /= r_state and r_counter < DEBOUNCE_LIMIT- 1) then 
        r_counter <= r_counter + 1;

      -- Waited for DEBOUNCE_LIMIT (Assumes button is stable now)
      elsif(r_counter = DEBOUNCE_LIMIT - 1) then
        r_state <= i_bouncy;
        r_counter <= 0;

      -- Limit of r_counter reached  
      else
        r_counter <= 0;
      end if;
    end if;
  end process;
  o_Debounced <= r_State;
end architecture RTL;

        


