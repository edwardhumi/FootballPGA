`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/02/2023 11:27:13 PM
// Design Name: 
// Module Name: goal_popup
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


module goal_popup(input [6:0] x, [6:0] y, input CLK_25MHz, input CLK_D, input team, output reg [15:0] oled_data);
    
    reg [15:0] color = 16'hFFFF;
    reg [6:0] x_center = 32;
    reg [6:0] x_center1 = 43;
    reg [6:0] x_center2 = 54;
    reg [6:0] x_center3 = 65;
    reg [6:0] y_center = 31;
    
    always @ (posedge CLK_25MHz) begin
        //G
        //line 1
        if (x >= x_center - 2 && x <= x_center + 3 && y == y_center - 4) begin
            oled_data <= color;
        end 
        //line 2
        else if (x >= x_center - 3 && x <= x_center + 4 && y == y_center - 3) begin
            oled_data <= color;
        end 
        //line 3 - 4
        else if ((x >= x_center - 3 && x <= x_center - 2) && y >= y_center - 2 && y <= y_center - 1) begin
            oled_data <= color;
        end
        //line 5 - 6
        else if (((x >= x_center - 3 && x <= x_center - 2) || (x >= x_center + 1 && x <= x_center + 4)) && y >= y_center && y <= y_center + 1) begin
            oled_data <= color;
        end
        //line 7 - 8
        else if (((x >= x_center - 3 && x <= x_center - 2) || (x >= x_center + 3 && x <= x_center + 4)) && y >= y_center + 2 && y <= y_center + 3) begin
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
        
        //O
        //line 1
        else if (x >= x_center1 - 2 && x <= x_center1 + 3 && y == y_center - 4) begin
            oled_data <= color;
        end 
        //line 2
        else if (x >= x_center1 - 3 && x <= x_center1 + 4 && y == y_center - 3) begin
            oled_data <= color;
        end 
        //line 3 - 8
        else if (((x >= x_center1 - 3 && x <= x_center1 - 2) || (x >= x_center1 + 3 && x <= x_center1 + 4)) && y >= y_center - 2 && y <= y_center + 3) begin
            oled_data <= color;
        end
        //line 9
        else if (x >= x_center1 - 3 && x <= x_center1 + 4 && y == y_center + 4) begin
            oled_data <= color;
        end 
        //line 10
        else if (x >= x_center1 - 2 && x <= x_center1 + 3 && y == y_center + 5) begin
            oled_data <= color;
        end    
    
        //A
        //line 1
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
        
        //L
        //line 1
        else if (x >= x_center3 - 3 && x <= x_center3 - 2 && y >= y_center - 4 && y <= y_center + 3) begin
            oled_data <= color;
        end 
        //line 2
        else if (x >= x_center3 - 3 && x <= x_center3 + 4 && y >= y_center + 4 && y <= y_center + 5) begin
            oled_data <= color;
        end   
               
        else 
           oled_data <= (CLK_D) ? (team ? 16'b11111_000000_00000 : 16'b00000_000000_11111) : 16'h0000;   
    end

endmodule