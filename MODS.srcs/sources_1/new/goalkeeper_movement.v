`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Edward Humianto
// 
// Create Date: 10/31/2023 09:20:39 PM
// Design Name: 
// Module Name: goalkeeper_movement
// Project Name: 
// Description: 
// Given the position of the ball, deduce where the keeper should move.
//////////////////////////////////////////////////////////////////////////////////


module goalkeeper_movement(input CLK_KEEPER, input [6:0] x0, y0, x_ball, y_ball, output reg [6:0] x1, y1, output reg is_moving);
    wire [6:0] y_dest;
    assign y_dest = (y_ball > 41) ? 39 : (y_ball < 21) ? 24 : y_ball; 
    
    always @ (posedge CLK_KEEPER) begin
        x1 <= x0;
        if (y0 < y_dest) begin
            y1 <= y0 + 1;
            is_moving = 1;
        end
        else if (y0 > y_dest) begin
            y1 <= y0 - 1;
            is_moving = 1;
        end
        else begin
            y1 <= y0;
            is_moving = 0;
        end
    end
endmodule
