`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/31/2023 10:26:17 AM
// Design Name: 
// Module Name: render_field
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


module render_field(input [6:0] x, input [6:0] y, input CLK_25MHz, output reg [15:0] oled_data);
    
    reg [4:0] radius = 10;
    reg [6:0] center_x = 47;  // X-coordinate of the circle center
    reg [6:0] center_y = 31;
    reg [8:0] angle = 0;      // Angle for polar coordinates
    reg [6:0] x_integer;
    reg [6:0] y_integer;
    
    always @ (posedge CLK_25MHz) begin
    
        if (x >= center_x && y >= center_y) begin
            x_integer = x - center_x;
            y_integer = y - center_y;
        end
        
        if (x >= center_x && y <= center_y) begin
            x_integer = x - center_x;
            y_integer = center_y - y;
        end
 
        if (x <= center_x && y >= center_y) begin
            x_integer = center_x - x;
            y_integer = y - center_y;
        end

        if (x <= center_x && y <= center_y) begin
            x_integer = center_x - x;
            y_integer = center_y - y;
        end
  
        //mid-line
        if (x >= 47 && x <= 48) begin
            oled_data <= 16'hFFFF;
        end
        //penalty area
        else if ((x <= 10 || x >= 85) && (y == 21 || y == 42)) begin
            oled_data <= 16'hFFFF;
        end
        else if ((x == 10 || x == 85) && (y >= 21 && y <= 42)) begin
            oled_data <= 16'hFFFF;
        end
        //center circle
        else if (x_integer*x_integer + y_integer*y_integer >= radius*radius - 10 && x_integer*x_integer + y_integer*y_integer <= radius*radius + 10) begin
            oled_data <= 16'hFFFF;  // Set the color to white
        end 
        else begin
            oled_data <= 16'h07E0;
        end
    end
   
endmodule