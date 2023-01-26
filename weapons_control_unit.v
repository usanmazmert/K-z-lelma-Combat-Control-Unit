`timescale 1us/1ns

module weapons_control_unit(
    input target_locked,
    input clk,
    input rst,
    input fire_command,
    output reg launch_missile,
    output reg[3:0] remaining_missiles,
    output reg[1:0] WCU_state
);
    //resets the state to IDLE and resets launch_missile
    always @(negedge target_locked)begin
        launch_missile <= 0;
        WCU_state <= 2'b00;
    end


    always @(posedge clk)begin
        //resets everything
        if (rst)begin 
            WCU_state <= 2'b00;
            remaining_missiles <= 4'b0100;
            launch_missile <= 0;
        end
        //changes state to OUT_OF_AMMO and resets launch_missile
        else if(remaining_missiles == 4'b0000)begin
            launch_missile = 0;
            WCU_state<= 2'b11;
        end
        //sets launch_missile 0 and change state to target_locked and resets launch_missile
        else if(target_locked == 1'b1 && (WCU_state == 2'b00 || WCU_state == 2'b10))begin
            launch_missile = 0;
            WCU_state <= 2'b01;
        end
        // change state to fire and launch a missile
        else if(fire_command == 1'b1 && WCU_state == 2'b01)begin
            launch_missile <= 1;
            remaining_missiles--;
            WCU_state <= 2'b10;
        end
    end
endmodule