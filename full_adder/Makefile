all:
  # analyze vhdl
	ghdl -a fulladder.vhdl

  # Synthesize
	yosys -m ghdl -p 'ghdl; synth_ice40 -json synth.json'

  # P&R
	nextpnr-ice40 --package hx1k --pcf constraint.pcf --asc result.asc --json synth.json

  # Generate Bitstream
	icepack result.asc result.bin

# Programm the chip
burn:
	iceprog result.bin

clean:
	rm -rf result.asc result.bin