library ieee;
use ieee.std_logic_1164.all;

entity seg_counter is
  port
  (
    -- Inputs
    i_clock : in std_logic;

    -- Outputs
    PMOD1 : out std_logic;
    PMOD2 : out std_logic;
    PMOD3 : out std_logic;
    PMOD4 : out std_logic;
    PMOD5 : out std_logic;
    PMOD6 : out std_logic;
    PMOD7 : out std_logic;
    PMOD8 : out std_logic
  );
end entity seg_counter;

architecture RTL of seg_counter is
  constant COUNT_DELAY : integer := 5000000;

  signal r_curseg : std_logic := '1';

  signal r_binary : integer range 0 to 7 := 0;
  signal r_counter : integer range 0 to COUNT_DELAY := 0;
begin
  seg7_inst : entity work.seg7
  port map
  (
    i_number => r_binary,

    A => PMOD1,
    B => PMOD2,
    C => PMOD3,
    D => PMOD4,
    E => PMOD5,
    F => PMOD6,
    G => PMOD7
  );

  process(i_clock) begin
    if rising_edge(i_clock) then
      if (r_counter = COUNT_DELAY and r_binary < 7) then
        r_binary <= r_binary + 1;
        r_counter <= 0;
        r_curseg <= not r_curseg;
      elsif (r_counter = COUNT_DELAY) then
        r_binary <= 0;
        r_counter <= 0;
        r_curseg <= not r_curseg;
      else
        r_counter <= r_counter + 1;
      end if;
    end if;
  end process;

  PMOD8 <= r_curseg;
end architecture RTL;