`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/06/2023 02:43:42 PM
// Design Name: 
// Module Name: flexible_clock
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


module flexible_clock(input clock, input [31:0] m, output reg clk);
    reg [31:0] count = 0;
    initial begin
        clk = 0;
    end
    always @ (posedge clock) begin
        count <= (count == m) ? 0 : count + 1;
        clk <= (count == 0) ? ~clk : clk;
    end
endmodule
