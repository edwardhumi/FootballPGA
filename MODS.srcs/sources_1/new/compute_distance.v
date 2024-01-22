`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Edward Humianto
// 
// Create Date: 10/31/2023 10:04:34 PM
// Design Name: 
// Module Name: compute_distance
// Project Name: 
// Description: 
// Given the coordinates of two points, compute the distance.
//////////////////////////////////////////////////////////////////////////////////


module compute_distance(input [6:0] x1, y1, x2, y2, output reg [13:0] distance);
    reg [6:0] dx, dy;
    always @ (*) begin
        dx = (x2 > x1) ? x2 - x1 : x1 - x2;
        dy = (y2 > y1) ? y2 - y1 : y1 - y2;
        distance = dx * dx + dy * dy;
    end
endmodule
