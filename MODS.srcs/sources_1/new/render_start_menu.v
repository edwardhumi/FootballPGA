`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/02/2023 10:46:53 PM
// Design Name: 
// Module Name: render_start_menu
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


module render_start_menu(input [6:0] x, [6:0] y, input CLK_25MHz, input [15:0]background, input [3:0]letter, output reg [15:0] oled_data);
    
    reg [15:0] color = 16'h0000;
    reg [6:0] x_center = 28;
    reg [6:0] x_center1 = 38;
    reg [6:0] x_center2 = 48;
    reg [6:0] x_center3 = 58;
    reg [6:0] x_center4 = 68;
    reg [6:0] y_center = 31;
    
    always @ (posedge CLK_25MHz) begin
           //S
           //line 1
           if (x >= x_center - 2 && x <= x_center + 3 && y == y_center - 4) begin
               oled_data <= color;
           end 
           //line 2
           else if (x >= x_center - 3 && x <= x_center + 4 && y == y_center - 3) begin
               oled_data <= color;
           end 
           //line 3
           else if (((x >= x_center - 3 && x <= x_center - 2) || (x >= x_center + 3 && x <= x_center + 4)) && y == y_center - 2) begin
               oled_data <= color;
           end 
           //line 4
           else if ((x >= x_center - 3 && x <= x_center - 2) && y == y_center - 1) begin
               oled_data <= color;
           end
           //line 5
           else if ((x >= x_center - 3 && x <= x_center + 3) && y == y_center) begin
               oled_data <= color;
           end 
           //line 6
           else if ((x >= x_center - 2 && x <= x_center + 4) && y == y_center + 1) begin
               oled_data <= color;
           end
           //line 7
           else if ((x >= x_center + 3 && x <= x_center + 4) && y == y_center + 2) begin
               oled_data <= color;
           end
           //line 8
           else if (((x >= x_center - 3 && x <= x_center - 2) || (x >= x_center + 3 && x <= x_center + 4)) && y == y_center + 3) begin
               oled_data <= color;
           end 
           //line 9
           else if (x >= x_center - 3 && x <= x_center + 4 && y == y_center + 4) begin
               oled_data <= color;
           end 
           //line 10
           else if (x >= x_center - 2 && x <= x_center + 3 && y == y_center + 5) begin
               oled_data <= color;
           end 
    
    
           //T
           //line 1-2
           else if (x >= x_center1 - 3 && x <= x_center1 + 4 && y >= y_center - 4 && y <= y_center - 3) begin
               oled_data <= color;
           end 
           //line 3-10
           else if (x >= x_center1 && x <= x_center1 + 1 && y >= y_center - 2 && y <= y_center + 5) begin
               oled_data <= color;
           end 
    
    
           //A
           else if (x >= x_center2 && x <= x_center2 + 1 && y == y_center - 4) begin
               oled_data <= color;
           end 
           //line 2
           else if (x >= x_center2 - 1 && x <= x_center2 + 2 && y == y_center - 3) begin
               oled_data <= color;
           end 
           //line 3
           else if (((x >= x_center2 - 2 && x <= x_center2 + 3)) && y == y_center - 2) begin
               oled_data <= color;
           end 
           //line 4
           else if (((x >= x_center2 - 3 && x <= x_center2 - 1) || (x >= x_center2 + 2 && x <= x_center2 + 4)) && y == y_center - 1) begin
               oled_data <= color;
           end
           //line 5
           else if (((x >= x_center2 - 3 && x <= x_center2 - 2) || (x >= x_center2 + 3 && x <= x_center2 + 4)) && y == y_center) begin
               oled_data <= color;
           end 
           //line 6
           else if (((x >= x_center2 - 3 && x <= x_center2 - 2) || (x >= x_center2 + 3 && x <= x_center2 + 4)) && y == y_center + 1) begin
               oled_data <= color;
           end
           //line 7
           else if ((x >= x_center2 - 3 && x <= x_center2 + 4) && y == y_center + 2) begin
               oled_data <= color;
           end
           //line 8
           else if ((x >= x_center2 - 3 && x <= x_center2 + 4) && y == y_center + 3) begin
               oled_data <= color;
           end 
           //line 9
           else if (((x >= x_center2 - 3 && x <= x_center2 - 2) || (x >= x_center2 + 3 && x <= x_center2 + 4)) && y == y_center + 4) begin
               oled_data <= color;
           end 
           //line 10
           else if (((x >= x_center2 - 3 && x <= x_center2 - 2) || (x >= x_center2 + 3 && x <= x_center2 + 4)) && y == y_center + 5) begin
               oled_data <= color;
           end 
    
           //R
           else if (x >= x_center3 - 3 && x <= x_center3 + 3 && y == y_center - 4) begin
               oled_data <= color;
           end 
           //line 2
           else if (x >= x_center3 - 3 && x <= x_center3 + 4 && y == y_center - 3) begin
               oled_data <= color;
           end 
           //line 3
           else if (((x >= x_center3 - 3 && x <= x_center3 - 2) || (x >= x_center3 + 3 && x <= x_center3 + 4)) && y == y_center - 2) begin
               oled_data <= color;
           end 
           //line 4
           else if (((x >= x_center3 - 3 && x <= x_center3 - 2) || (x >= x_center3 + 3 && x <= x_center3 + 4)) && y == y_center - 1) begin
               oled_data <= color;
           end
           //line 5
           else if (x >= x_center3 - 3 && x <= x_center3 + 4 && y == y_center) begin
               oled_data <= color;
           end 
           //line 6
           else if (x >= x_center3 - 3 && x <= x_center3 + 3 && y == y_center + 1) begin
               oled_data <= color;
           end
           //line 7
           else if (((x >= x_center3 - 3 && x <= x_center3 - 2) || (x >= x_center3 + 2 && x <= x_center3 + 4)) && y == y_center + 2) begin
               oled_data <= color;
           end
           //line 8
           else if (((x >= x_center3 - 3 && x <= x_center3 - 2) || (x >= x_center3 + 3 && x <= x_center3 + 4)) && y == y_center + 3) begin
               oled_data <= color;
           end 
           //line 9
           else if (((x >= x_center3 - 3 && x <= x_center3 - 2) || (x >= x_center3 + 3 && x <= x_center3 + 4)) && y == y_center + 4) begin
               oled_data <= color;
           end 
           //line 10
           else if (((x >= x_center3 - 3 && x <= x_center3 - 2) || (x >= x_center3 + 3 && x <= x_center3 + 4)) && y == y_center + 5) begin
               oled_data <= color;
           end 
           
           //T
           //line 1-2
           else if (x >= x_center4 - 3 && x <= x_center4 + 4 && y >= y_center - 4 && y <= y_center - 3) begin
               oled_data <= color;
           end 
           //line 3-10
           else if (x >= x_center4 && x <= x_center4 + 1 && y >= y_center - 2 && y <= y_center + 5) begin
               oled_data <= color;
           end 
           else 
               oled_data <= background;   
    end

endmodule