library ieee;
use ieee.std_logic_1164.all;

entity tristate is
  port
  (
    PMOD1 : inout std_logic 
  );
end entity tristate;

architecture RTL of tristate is
  signal w_tri_en : std_logic;
begin
  w_tri_en <= '0';
  PMOD1 <= '1' when w_tri_en = '1' else 'Z'; 
end architecture RTL;

-- 