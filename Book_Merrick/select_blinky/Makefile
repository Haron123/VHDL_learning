all:
  # analyze vhdl
	ghdl -a --std=08 demux_1to4.vhdl
	ghdl -a --std=08 lfsr_22.vhdl
	ghdl -a --std=08 demux_blink_top.vhdl

  # Synthesize
	yosys -m ghdl -p 'ghdl --std=08; synth_ice40 -json synth.json'

  # P&R
	nextpnr-ice40 --package hx1k --pcf constraint.pcf --asc result.asc --json synth.json

  # Generate Bitstream
	icepack result.asc result.bin

# Programm the chip
burn:
	iceprog result.bin
	make clean

clean:
	rm -rf result.asc result.bin synth.json *.o *.cf