library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity fifo is
  generic
  (
    WIDTH : integer := 8;
    DEPTH : integer := 256
  );

  port
  (
    i_rst_l : in std_logic;
    i_clock : in std_logic;

    -- Write
    i_wr_dv : in std_logic;
    i_wr_data : in std_logic_vector(WIDTH-1 downto 0);
    i_af_level : in integer;
    o_af_flag : out std_logic;
    o_full : out std_logic;

    -- Read
    i_rd_en : in std_logic;
    o_rd_dv : out std_logic;
    o_rd_data : in std_logic_vector(WIDTH-1 downto 0);
    i_ae_level : in integer;
    o_ae_flag : out std_logic;
    o_empty : out std_logic
  );
end entity fifo;

architecture RTL of fifo is

  -- Number of bits required to store DEPTH words
  constant DEPTH_BITS : integer := integer(ceil(log2(real(DEPTH))));

  signal r_wr_addr, r_rd_addr : natural range 0 to DEPTH-1;
  signal r_count : natural range 0 to DEPTH; -- 1 extra to go to depth

  signal w_rd_dv : std_logic;
  signal w_rd_data : std_logic_vector(WIDTH-1 downto 0);

  signal w_wr_addr, w_rd_addr : std_logic_vector(DEPTH_BITS-1 downto 0);

begin

  w_wr_addr <= std_logic_vector(to_unsigned(r_wr_addr, DEPTH_BITS));
  w_rd_addr <= std_logic_vector(to_unsigned(r_rd_addr, DEPTH_BITS));

  -- Dual Port Ram init
  ram_inst : entity work.ram
    generic map
    (
      WIDTH => WIDTH,
      DEPTH => DEPTH
    )
    port map
    (
      -- write port
      i_wr_clk  => i_clk,
      i_wr_addr => w_wr_addr,
      i_wr_dv   => i_wr_dv,
      i_wr_data => i_wr_data,

      -- read port
      i_rd_clk  => i_clk,
      i_rd_addr => w_rd_addr,
      i_rd_en   => i_rd_en,
      o_rd_dv   => w_rd_dv,
      o_rd_data => w_rd_data
    );
  
  -- Main process
  process(i_clock, i_rst_l) is
  begin
    if not i_rst_l then
      r_wr_addr <= 0;
      r_rd_addr <= 0;
      r_count <= 0;
    elsif rising_edge(i_clock) then

      -- Write
      if i_wr_dv then
        if r_wr_addr = DEPTH-1 then
          r_wr_addr = 0;
        else
          r_wr_addr <= r_wr_addr +1;
        end if;
      end if;

      -- Read
      if i_rd_en then
        if r_rd_addr = DEPTH-1 then
          r_rd_addr <= 0;
        else
          r_rd_addr <= r_rd_addr + 1;
        end if;
      end if;

      -- Keep track of number of words in the FIFO
      -- Read with no write
      if i_rd_en = '1' and i_wr_dv = '0' then
        if(r_count /= 0) then
          r_count <= r_count - 1;
        end if;
      -- Write with no read
      elsif i_wr_dv = '1' and i_rd_en = '0' then
        if r_count /= DEPTH then
          r_count <= r_count + 1;
        end if;
      end if;

      if i_rd_en = '1' then
        o_rd_data <= w_rd_data;
      end if;
    end if;
  end process;

  o_full <= '1' when ((r_count = DEPTH) or (r_count = DEPTH + 1 and i_wr_dv = '1' and i_rd_en = '0')) else '0';

  o_empty <= '1' when (r_count = 0) else '0';

  o_af_flag <= '1' when (r_count > depth - i_af_level) else '0';
  o_ae_flag <= '1' when (r_count < i_ae_level) else '0';

  o_rd_dv <= w_rd_dv;

  ----------------------------------------------------------------------------
  -- ASSERTION CODE, NOT SYNTHESIZED
  -- synthesis translate_off
  -- Ensures that we never read from empty FIFO or write to full FIFO.
  process (i_Clk) is
    begin
      if rising_edge(i_Clk) then
        if (i_Rd_En = '1' and i_Wr_DV = '0' and r_Count = 0) then
          assert false report "Error! Reading Empty FIFO";
        end if;
  
        if (i_Wr_DV = '1' and i_Rd_En = '0' and r_Count = DEPTH) then
          assert false report "Error! Writing Full FIFO";
        end if;
      end if;
    end process;
    -- synthesis translate_on
    ----------------------------------------------------------------------------
    
  end RTL;
        
