`timescale 1us/1ns

module combat_control_unit(
    input rst,
    input track_target_command, 
    input clk, 
    input radar_echo, 
    input fire_command,
    output [13:0] distance_to_target, 
    output trigger_radar_transmitter, 
    output launch_missile,
    output [1:0] TTU_state,
    output [1:0] WCU_state,
    output [3:0] remaining_missiles
);
    wire target_locked;
    target_tracking_unit ttu(.rst(rst), .clk(clk), .track_target_command(track_target_command), .echo(radar_echo), .TTU_state(TTU_state), .trigger_radar_transmitter(trigger_radar_transmitter), .distance_to_target(distance_to_target), .target_locked(target_locked));
    weapons_control_unit wcu(.rst(rst), .clk(clk), .target_locked(target_locked), .fire_command(fire_command), .WCU_state(WCU_state), .remaining_missiles(remaining_missiles), .launch_missile(launch_missile));

endmodule