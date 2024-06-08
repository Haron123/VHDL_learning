library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fsm_game is
  generic
  (
    CLKS_PER_SEC : integer := 12000000;
    GAME_LIMIT : integer := 6
  );
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

    o_score : out integer
  );
end entity fsm_game;

type t_FSM_main is (START, PATTERN_OFF, PATTERN_SHOW, WAIT_PLAYER, INCR_SCORE, LOSER, WINNER);
type t_pattern is array(0 to 10) of std_logic_vector(1 do downto 0);

signal r_FSM_main : t_FSM_main;
signal w_count_en, w_toggle, r_toggle : std_logic;
signal r_switch_1, r_switch_2, r_switch_3, r_switch_4, r_button_dv : std_logic;
signal r_pattern : t_pattern; -- 2D Array: 2 bit wide x 11 deep

signal w_lfsr_data : std_logic_vector(21 downto 0);
signal r_index : integer range 0 to GAME_LIMIT;
signal w_index_SLV : std_logic_vector(7 downto 0);
signal r_button_id : std_logic_vector(1 downto 0);
signal r_score : integer;

begin
  process(i_clock) is
  begin
    if rising_edge(i_clock) then
      -- Reset game from any state
      if i_switch_1 = '1' and i_switch_2 = '1' then
        r_FSM_main <= START;
      else
        -- Main State machine switch statement
        case r_FSM_main is
          -- Stay in START state until user releases Buttons
          when START =>
            if(i_switch_0 = '0' and i_switch_1 = '0' and r_button_dv = '1') 
            then
              r_score <= 0;
              r_index <= 0;
              r_FSM_main <= PATTERN_OFF;
            end if;
          when PATTERN_OFF =>
            if(w_toggle = '0' and r_toggle = '1' then) -- Falling edge found
            then
              r_FSM_main <= PATTERN_SHOW;
            end if;
          when PATTERN_SHOW =>
            if(w_toggle = '0' and r_toggle = '1') -- Falling edge found
            then
              if(r_score = r_index)
              then
                r_index <= 0;
                r_FSM_main <= WAIT_PLAYER;
              else
                r_index <= r_index + 1;
                r_FSM_main <= PATTERN_OFF;
              end if;
            end if;
          when WAIT_PLAYER =>
            if(r_button_dv = '1')
            then
              if(r_pattern(r_index) = r_button_id and to_integer(unsigned(w_index_slv)) = r_score)
              then
                r_index <= 0;
                r_FSM_main <= INCR_SCORE;
              elsif r_pattern(r_index) /= r_button_id 
              then
                r_FSM_main <= LOSER;
              else
                r_index <= r_index + 1;
              end if;
            end if;
          when INCR_SCORE =>
            r_score <= r_score + 1;
            if r_score = GAME_LIMIT 
            then
              r_FSM_main <= WINNER;
            else
              r_FSM_main <= PATTERN_OFF;
            end if;
          when WINNER => 
            r_score <= 10; -- Winner
          when LOSER =>
            r_score <= 15; -- Loser
          when others =>
            r_FSM_main <= START;
        end case;
      end if;
    end process;

  process(i_clock)
  begin
    if rising_edge(i_clock) then
      if r_FSM_main = START
      then
        r_Pattern(0)  <= w_LFSR_Data(1 downto 0);
        r_Pattern(1)  <= w_LFSR_Data(3 downto 2);
        r_Pattern(2)  <= w_LFSR_Data(5 downto 4);
        r_Pattern(3)  <= w_LFSR_Data(7 downto 6);
        r_Pattern(4)  <= w_LFSR_Data(9 downto 8);
        r_Pattern(5)  <= w_LFSR_Data(11 downto 10);
        r_Pattern(6)  <= w_LFSR_Data(13 downto 12);
        r_Pattern(7)  <= w_LFSR_Data(15 downto 14);
        r_Pattern(8)  <= w_LFSR_Data(17 downto 16);
        r_Pattern(9)  <= w_LFSR_Data(19 downto 18);
        r_Pattern(10) <= w_LFSR_Data(21 downto 20);
      end if;
    end if;
  end process;

  w_index_slv <= std_logic_vector(to_unsigned(r_index, w_index_slv'length));

  o_led_1 <= '1' when (r_FSM_main = PATTERN_SHOW and r_pattern(r_index) = "00") else i_switch_1;
  o_led_1 <= '1' when (r_FSM_main = PATTERN_SHOW and r_pattern(r_index) = "01") else i_switch_1;
  o_led_1 <= '1' when (r_FSM_main = PATTERN_SHOW and r_pattern(r_index) = "10") else i_switch_1;
  o_led_1 <= '1' when (r_FSM_main = PATTERN_SHOW and r_pattern(r_index) = "11") else i_switch_1;

  process(i_clock) is
  begin
    if rising_edge(i_clock)
    then
      r_toggle <= w_toggle;
      r_switch_1 <= i_switch_1;
      r_switch_2 <= i_switch_2;
      r_switch_3 <= i_switch_3;
      r_switch_4 <= i_switch_4;
      if r_switch_1 = '1' and i_switch_1 = '0' then
        r_button_dv <= '1';
        r_button_id <= "00";
      elsif r_switch_2 = '1' and i_switch_2 = '0' then
        r_button_dv <= '1';
        r_button_id <= "01";
      elsif r_switch_3 = '1' and i_switch_3 = '0' then
        r_button_dv <= '1';
        r_button_id <= "10";
      elsif r_switch_4 = '1' and i_switch_4 = '0' then
        r_button_dv <= '1';
        r_button_id <= "11";
      else
        r_button_dv <= '0';
        r_button_id <= "00";
      end if;
    end if;
  end process;
            

