`timescale 1us/1ns

module target_tracking_unit(
    input rst,
    input track_target_command,
    input clk,
    input echo,
    output reg trigger_radar_transmitter,
    output reg [13:0] distance_to_target,
    output reg target_locked,
    output reg [1:0] TTU_state
);

    reg[31:0] temp_time = 32'd0;

    //Calculates target to distance immediately or changes trigger_radar_transmitter to HIGH.
    always @(track_target_command or echo)begin
        if(trigger_radar_transmitter != 1'b1 && track_target_command == 1'b1 && (TTU_state == 2'b00 | TTU_state == 2'b11))begin
            trigger_radar_transmitter <= 1'b1;
            target_locked <= 1'b0;
        end
        else if(TTU_state == 2'b10 && echo == 1'b1)begin
            distance_to_target <= (($stime - temp_time)*3*100)/2;
            target_locked <= 1'b1;
            temp_time <= $stime;
        end
    end

    //Sets the ending time of the radar_transmitter signal so it can go to listen_for_echo state.
    always @ (posedge trigger_radar_transmitter)begin
        trigger_radar_transmitter <= #50 1'b0;
        temp_time <= $stime + 50;
    end
    //Handles everything that happens at posedge of the clock tick.
    always @(posedge clk)begin
        // resets everything 
        if (rst)begin 
            trigger_radar_transmitter<= 0;
            target_locked <=0;
            distance_to_target <= 0;
            TTU_state <= 2'b00;
        end

        // changes state to TRANSMIT
        else if(trigger_radar_transmitter == 1'b1)begin
            TTU_state <= 2'b01;
        end
        //changes state to Listen_For_Echo
        else if(track_target_command == 1'b0 && TTU_state == 2'b01)
            TTU_state <= 2'b10;
        // if echo input doesn't come within 100 seconds then changes state to IDLE
        else if(TTU_state == 2'b10)begin
            if(echo == 1'b0 && $stime - temp_time >= 100)begin
                TTU_state <= 2'b00;
            end
        end
        //sets state to TRACK
        if((echo == 1'b1 || target_locked == 1'b1) && TTU_state != 2'b11)begin
            TTU_state <= 2'b11;
        end

        //Calculates the ending time of target_locked and distance_to_target signals.
        if(target_locked == 1'b1)begin
            if($stime - temp_time >= 300)begin
                target_locked <= 1'b0;
                distance_to_target <= 0;
                TTU_state <= 2'b00;
            end
        end
    end

endmodule