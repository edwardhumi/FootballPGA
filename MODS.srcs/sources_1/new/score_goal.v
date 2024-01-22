`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/03/2023 10:17:15 PM
// Design Name: 
// Module Name: score_goal
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


module score_goal(input [6:0] x_ball, y_ball, x, y, output team_a_scored, team_b_scored);
    wire goal_a = x == 0 && y >= 21 && y <= 42;
    wire goal_b = x == 95 && y >= 21 && y <= 42;
    
    wire a_scored = x_ball == 0 && y_ball >= 21 && y_ball <= 41;
    wire b_scored = x_ball + 1 == 95 && y_ball >= 21 && y_ball <= 41;
    
    assign team_a_scored = a_scored;
    assign team_b_scored = b_scored;
endmodule
