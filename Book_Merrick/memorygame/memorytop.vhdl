library ieee;
use ieee.std_logic_1164.all;

entity memory_top is
  port
  (
    i_clock : in std_logic;

    -- Input Switches for entering Pattern
    i_switch_1 : in std_logic;
    i_switch_2 : in std_logic;
    i_switch_3 : in std_logic;
    i_switch_4 : in std_logic;

    -- Output leds to show pattern
    o_led_1 : out std_logic;
    o_led_2 : out std_logic;
    o_led_3 : out std_logic;
    o_led_4 : out std_logic;

    -- Scoreboard 7 segment
    PMOD1 : out std_logic;
    PMOD2 : out std_logic;
    PMOD3 : out std_logic;
    PMOD4 : out std_logic;
    PMOD5 : out std_logic;
    PMOD6 : out std_logic;
    PMOD7 : out std_logic;
    PMOD8 : out std_logic
  );
end entity memory_top;

architecture RTL of memory_top is
  constant GAME_LIMIT : integer := 7; -- Increase to make game harder
  constant CLKS_PER_SEC : integer := 12000000 -- 12 MHZ clock
  constant DEBOUNCE_LIMIT : integer := 120000 -- 10ms debounce filter

  signal w_switch_1, w_switch_2, w_switch_3, w_switch_4 : std_logic;
  signal w_PMOD1, w_PMOD2, w_PMOD3, w_PMOD4, w_PMOD5, w_PMOD6, w_PMOD7, w_PMOD8 : std_logic;
  signal w_score : integer;

begin
  
  debounce_sw1 : entity work.debounce_filter
    generic map
    (
      DEBOUNCE_LIMIT => DEBOUNCE_LIMIT
    )
    port map
    (
      i_clock => i_clock,
      i_bouncy => i_switch_1,
      o_debounced => w_switch_1
    );
  debounce_sw2 : entity work.debounce_filter
  generic map
  (
    DEBOUNCE_LIMIT => DEBOUNCE_LIMIT
  )
  port map
  (
    i_clock => i_clock,
    i_bouncy => i_switch_2,
    o_debounced => w_switch_2
  );
  debounce_sw3 : entity work.debounce_filter
    generic map
    (
      DEBOUNCE_LIMIT => DEBOUNCE_LIMIT
    )
    port map
    (
      i_clock => i_clock,
      i_bouncy => i_switch_3,
      o_debounced => w_switch_3
    );
  debounce_sw4 : entity work.debounce_filter
  generic map
  (
    DEBOUNCE_LIMIT => DEBOUNCE_LIMIT
  )
  port map
  (
    i_clock => i_clock,
    i_bouncy => i_switch_4,
    o_debounced => w_switch_4
  );

  game_inst : entity work.fsm_game
  generic map
  (
    CLKS_PER_SEC => CLKS_PER_SEC,
    GAME_LIMIT => GAME_LIMIT
  )
  port map
  (
    i_clock => i_clock,
    i_switch_1 => w_switch_1,
    i_switch_2 => w_switch_2,
    i_switch_3 => w_switch_3,
    i_switch_4 => w_switch_4m
    o_score => w_score,
    o_led_1 => o_led_1,
    o_led_2 => o_led_2,
    o_led_3 => o_led_3,
    o_led_4 => o_led_4
  );

  scoreboard : entity work.seg7
  port map
  (
    i_number => w_score,
    A => PMOD1,
    B => PMOD2,
    C => PMOD3,
    D => PMOD4,
    E => PMOD5,
    F => PMOD6,
    G => PMOD7
  );
end architecture RTL;