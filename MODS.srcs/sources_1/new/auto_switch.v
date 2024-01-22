`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Edward Humianto
// 
// Create Date: 10/31/2023 10:27:49 PM
// Design Name: 
// Module Name: auto_switch
// Project Name: 
// Description: 
// Find the closest player to the ball for auto-switching, output the player's index
//////////////////////////////////////////////////////////////////////////////////


module auto_switch(input [6:0] x_ball, y_ball, x0, y0, x1, y1, x2, y2, output reg [1:0] player_index);
    wire [13:0] dist0, dist1, dist2;
    compute_distance player0_ball (x_ball, y_ball, x0, y0, dist0);
    compute_distance player1_ball (x_ball, y_ball, x1, y1, dist1);
    compute_distance player2_ball (x_ball, y_ball, x2, y2, dist2);
    
    always @ (*) begin
        if (dist0 <= dist1 && dist0 <= dist2) begin
            player_index = 2'b00;
        end
        else if (dist1 <= dist0 && dist1 <= dist2) begin
            player_index = 2'b01;
        end
        else if (dist2 <= dist0 && dist2 <= dist1) begin
            player_index = 2'b10;
        end
        else begin
            player_index = 2'b00;
        end
    end
endmodule
