`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Edward Humianto
// 
// Create Date: 10/29/2023 02:49:47 PM
// Design Name: 
// Module Name: move_diagonal
// Project Name: 
// Description: 
// Given inital and destination coordinates, deduce how the current coordinate should
// be updated in each clock cycle.
//////////////////////////////////////////////////////////////////////////////////


module move_diagonal(input CLK_BOT, input [6:0] x_init, y_init, x_dest, y_dest, input [3:0] overlap_status, output reg [6:0] x, y, output reg is_bot_moving);    
    always @ (posedge CLK_BOT) begin
        if (x_init == x_dest && y_init == y_dest) begin
            x <= x_init;
            y <= y_init;
            is_bot_moving = 0;
        end
        else begin
            if (x_dest > x_init && ~overlap_status[1] && x < 93) begin
                x <= x_init + 1;
                is_bot_moving = 1;
            end
            if (x_dest < x_init && ~overlap_status[0] && x > 1) begin
                x <= x_init - 1;
                is_bot_moving = 1;
            end
            if (y_dest > y_init && ~overlap_status[3] && y < 59) begin
                y <= y_init + 1;
                is_bot_moving = 1;
            end
            if (y_dest < y_init && ~overlap_status[2] && y > 3) begin
                y <= y_init - 1;
                is_bot_moving = 1;
            end
        end
    end
endmodule
