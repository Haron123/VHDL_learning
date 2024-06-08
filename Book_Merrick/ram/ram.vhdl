library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ram is
  generic
  (
    DEPTH : integer := 256;
    WIDTH : integer := 8
  );

  port
  (
    -- Write signals
    i_wr_clk : in std_logic;
    i_wr_addr : in std_logic_vector;
    i_wr_dv : in std_logic;
    i_wr_data : in std_logic_vector(BIT_WIDTH-1 downto 0);

    -- Read signals
    i_rd_clk : in std_logic;
    i_rd_addr : in std_logic_vector;
    i_rd_en : in std_logic;
    o_rd_dv : out std_logic;
    o_rd_data : out std_logic_vector(BIT_WIDTH-1 downto 0)
  );
end entity ram;

architecture RTL of ram is
  type t_mem is array(0 to DEPTH-1) of std_logic_vector(BIT_WIDTH-1 downto 0);
  signal r_mem : t_mem;
begin
  process(i_wr_clk) begin
    if rising_edge(i_wr_clk) then
      if i_wr_dv = '1' then
        r_mem(to_integer(unsigned(i_wr_addr))) <= i_wr_data;
      end if;
    end if;
  end process;

  process(i_rd_clk) begin
    if rising_edge(i_rd_clk) then
      o_rd_data <= r_mem(to_integer(unsigned(i_rd_addr)));
      o_rd_dv <= i_rd_en;
    end if;
  end process;
end RTL ; -- RTL