library ieee;
use ieee.std_logic_1164.all;

entity seg7 is
  port
  (
    -- Inputs
    clock : in std_logic;

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
end entity seg7;

architecture RTL of seg7 is

  signal cur_seg : std_logic := '1';

  begin
    process(clock) is
      begin
        if rising_edge(clock) then
          cur_seg <= not cur_seg;
        end if;
    end process;

    -- Assign cur_seg flipflop to PMOD8
    PMOD8 <= cur_seg;

    -- Combitional
    PMOD1 <= '0';
    PMOD2 <= '0';
    PMOD3 <= '0';
    PMOD4 <= '0';
    PMOD5 <= '1';
    PMOD6 <= '1';
    PMOD7 <= '0';
  end architecture RTL;