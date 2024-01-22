`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/03/2023 05:13:33 PM
// Design Name: 
// Module Name: keeper_reset
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module keeper_reset(input clock, input [6:0] x6, y6, x7, y7, x_ball, y_ball, output reg [1:0] reset_keeper_status);
    reg touched = 0;
    reg [31:0] counter = 0;
    wire touch_left =
        (x_ball == x6 + 2 && y_ball == y6) ||
        (x_ball == x6 + 2 && y_ball == y6 + 1) ||
        (x_ball == x6 + 2 && y_ball == y6 + 2) ||   
        (x_ball == x6 + 2 && y_ball == y6 - 1) ||
        (x_ball == x6 + 2 && y_ball == y6 - 2) ||
        (x_ball == x6 + 2 && y_ball == y6 - 3) ||
        (x_ball == x6 + 2 && y_ball == y6 - 4) ||
        (x_ball == x6 + 2 && y_ball == y6 - 5);
        
    wire touch_right =
        (x_ball == x7 - 3 && y_ball == y7) ||
        (x_ball == x7 - 3 && y_ball == y7 + 1) ||
        (x_ball == x7 - 3 && y_ball == y7 + 2) ||   
        (x_ball == x7 - 3 && y_ball == y7 - 1) ||
        (x_ball == x7 - 3 && y_ball == y7 - 2) ||
        (x_ball == x7 - 3 && y_ball == y7 - 3) ||
        (x_ball == x7 - 3 && y_ball == y7 - 4) ||
        (x_ball == x7 - 3 && y_ball == y7 - 5);    
        
    initial begin
        reset_keeper_status = 0;
    end    
    
    always @ (posedge clock) begin
        if (touch_left || touch_right) begin
            touched = 1;
        end
        if (touched) begin
            reset_keeper_status = (touch_left)? 2'b10 : (touch_right)? 2'b01: 0;
            counter <= counter + 1;            
        end
        if (counter == 50_000_000) begin
            reset_keeper_status = 2'b00;
            counter = 0;
            touched = 0;
        end
    end
    
endmodule
