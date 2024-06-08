library ieee;
use ieee.std_logic_1164.all;

entity demux_blink_top is
  port
  (
    -- Inputs
    i_clock : in std_logic;

    i_switch1 : in std_logic;
    i_switch2 : in std_logic;

    -- Outputs
    o_led1 : out std_logic;
    o_led2 : out std_logic;
    o_led3 : out std_logic;
    o_led4 : out std_logic
  );
end entity demux_blink_top;

architecture RTL of demux_blink_top is
  signal r_lfsr_toggle : std_logic := '0';
  signal w_lfsr_done : std_logic;
begin
  lsfr_22 : entity work.lsfr_22
  port map
  (
    i_clock => i_clock,
    o_lfsr_data => open,
    o_lfsr_done => w_lfsr_done
  );

  process(i_clock) is begin
    if rising_edge(i_clock) then
      if w_lfsr_done = '1' then
        r_lfsr_toggle <= not r_lfsr_toggle;
      end if;
    end if;
  end process;

  demux_inst : entity work.demux_1to4
  port map
  (
    i_data => r_lfsr_toggle,

    i_sel0 => i_switch1,
    i_sel1 => i_switch2,

    o_data0 => o_led1,
    o_data1 => o_led2,
    o_data2 => o_led3,
    o_data3 => o_led4
  );
end architecture RTL;
  