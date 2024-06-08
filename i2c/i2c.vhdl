library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity I2C is
  generic
  (
    CLOCK_DIV : integer range 0 to 1023 := 0
  );
  port
  (
    -- Input
    i_clock : in std_logic;
    i_data : in std_logic_vector(7 downto 0);
    i_start : in std_logic;
    i_stop : in std_logic;
    i_sr : in std_logic;
    i_sw : in std_logic;

    -- Output
    o_data : out std_logic_vector(7 downto 0); -- Data of read
    o_dv : out std_logic; -- Read is done and data is valid
    o_error : out std_logic;
    o_ready : out std_logic;

    -- Data Lines
    o_scl : out std_logic;
    io_sda : inout std_logic
  );
end entity I2C;

architecture RTL of I2C is
  

  -- Clock div
  signal r_div_counter : integer range 0 to CLOCK_DIV;
  signal r_div_done : std_logic;

  -- FSM
  type t_FSM is (START, WAITING, STOP_COND, START_COND, SENDING, RECEIVING);
  signal r_FSM : t_FSM;
  
  -- I2C
  signal r_wdata : std_logic_vector(7 downto 0);
  signal r_rdata : std_logic_vector(7 downto 0);
  signal r_current_bit : integer range 0 to 9;
  signal r_ack : std_logic;
  signal w_oe : std_logic;
  signal r_sda : std_logic;
  signal r_scl : std_logic;
  signal r_rw : std_logic;
begin
  process(i_clock)
  begin
    if rising_edge(i_clock) then
      -- Clock divison incase slave is slower
      if(r_div_counter < CLOCK_DIV)
      then
        r_div_counter <= r_div_counter + 1;
        r_div_done <= '0';
      elsif(r_div_counter = CLOCK_DIV)
      then
        r_div_done <= '1';
        r_div_counter <= 0;
      end if;

      -- State Machine start
      case r_FSM is
        when START =>
          r_scl <= 'Z';
          r_sda <= 'Z';
          r_FSM <= WAITING;
        when WAITING =>
        -- Wait for either start, stop or data send
          w_oe <= '1';
          o_ready <= '1';
          -- Send Start condition
          if(i_start = '1')
          then
            r_scl <= '0';
            o_ready <= '0';
            r_div_counter <= 0;
            r_FSM <= START_COND;
          -- Send Stop condition
          elsif(i_stop = '1')
          then
            r_scl <= '0';
            o_ready <= '0';
            r_div_counter <= 0;
            r_FSM <= STOP_COND;
          -- Start Writing 8 Bits and receive Ack
          elsif(i_sw = '1')
          then
            o_ready <= '0';
            r_wdata <= i_data;
            r_current_bit <= 0;
            r_div_counter <= 0;
            r_FSM <= SENDING;
          -- Start Reading 8 Bits and receive Ack
          elsif(i_sr = '1')
          then
            o_ready <= '0';
            r_current_bit <= 0;
            r_div_counter <= 0;
            w_oe <= '0';
            o_dv <= '0';
            r_FSM <= RECEIVING;
          end if;
        when START_COND =>
          r_sda <= '1';
          r_scl <= '1';
          if(r_div_done = '1')
          then
            r_sda <= '0';
            r_FSM <= WAITING;
          end if;
        when STOP_COND =>
          r_sda <= '0';
          r_scl <= '1';
          if(r_div_done = '1')
          then
            r_sda <= '1';
            r_FSM <= WAITING;
          end if;
        when SENDING =>
        -- Send 8 data bits, receive acknowledge afterwards
          if(r_current_bit < 8 and r_div_done = '1')
          then
            if(r_scl = '0')
            then
              r_scl <= '1';
              r_current_bit <= r_current_bit + 1;
            elsif(r_scl = '1')
            then
              r_sda <= r_wdata(7 - r_current_bit);
              r_scl <= '0';
            end if;
          elsif(r_current_bit = 8 and r_div_done = '1')
          then
            -- Check ack
            if(r_scl = '1')
            then
              w_oe <= '0';
              r_scl <= '0';
            elsif(r_scl = '0')
            then
              r_scl <= '1';
              r_current_bit <= r_current_bit + 1;
            end if;
          elsif(r_current_bit = 9 and r_div_done = '1')
          then
            r_ack <= io_sda;
            r_FSM <= START;
          end if;
        when RECEIVING =>
        -- receive 8 data bits, receive acknowledge afterwards
          if(r_current_bit < 8 and r_div_done = '1')
          then
            if(r_scl = '0')
            then
              r_scl <= '1';
            elsif(r_scl = '1')
            then
              r_rdata(r_current_bit) <= r_sda;
              r_scl <= '0';
            end if;
          elsif(r_current_bit = 8 and r_div_done = '1')
          then
            -- send ack
            if(r_scl = '1')
            then
              w_oe <= '1';
              r_sda <= '0';
              r_scl <= '0';
            elsif(r_scl = '0')
            then
              r_scl <= '1';
              r_current_bit <= r_current_bit + 1;
            end if;
          elsif(r_current_bit = 9 and r_div_done = '1')
          then
            r_ack <= '1';
            o_dv <= '1';
            r_FSM <= START;
          end if;
      end case;
    end if;
  o_scl <= r_scl;
  io_sda <= r_sda when w_oe = '1' else 'Z'; 
  end process;
end architecture RTL; -- RTL