CC = iverilog 
FLAGS = -Wall 
library_input: *.v

# USAGE:
#		make combat_control_unit
#		→ Compile and simulate combat_control_unit, open the resulting waveform
#		make target_tracking_unit
#		→ Compile and simulate target_tracking_unit, open the resulting waveform
#		make weapons_control_unit
#		→ Compile and simulate weapons_control_unit, open the resulting waveform
#		make clean
#		→ Clean generated waveforms and build targets

combat_control_unit:
	$(CC) $(FLAGS) -o combat_control_unit_t combat_control_unit.v combat_control_unit_tb.v target_tracking_unit.v weapons_control_unit.v
	vvp combat_control_unit_t
	gtkwave combat_control_unit_result.vcd ccu.gtkw .gtkwaverc
target_tracking_unit:
	$(CC) $(FLAGS) -o target_tracking_unit_t target_tracking_unit.v target_tracking_unit_tb.v
	vvp target_tracking_unit_t
	gtkwave target_tracking_unit_result.vcd ttu.gtkw .gtkwaverc
weapons_control_unit:
	$(CC) $(FLAGS) -o weapons_control_unit_t weapons_control_unit.v weapons_control_unit_tb.v
	vvp weapons_control_unit_t
	gtkwave weapons_control_unit_result.vcd wcu.gtkw .gtkwaverc

clean:
	rm *.vcd
	rm combat_control_unit_t
	rm target_tracking_unit_t
	rm weapons_control_unit_t