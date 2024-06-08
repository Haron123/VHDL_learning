library ieee;
use ieee.std_logic_1164.all;

entity demux_1to4 is
  port
  (
    i_data : in std_logic;

    i_sel0 : in std_logic;
    i_sel1 : in std_logic;

    o_data0 : out std_logic;
    o_data1 : out std_logic;
    o_data2 : out std_logic;
    o_data3 : out std_logic
  );
end entity demux_1to4;

architecture RTL of demux_1to4 is
begin
  o_data0 <= i_data when i_sel0 = '0' and i_sel1 = '0' else '0';
  o_data1 <= i_data when i_sel0 = '1' and i_sel1 = '0' else '0';
  o_data2 <= i_data when i_sel0 = '0' and i_sel1 = '1' else '0';
  o_data3 <= i_data when i_sel0 = '1' and i_sel1 = '1' else '0';
end architecture RTL;