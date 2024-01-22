`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/03/2023 12:16:40 PM
// Design Name: 
// Module Name: winner_popup
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


module winner_popup(input [6:0] x, [6:0] y, input CLK_25MHz, input CLK_D, input team, output reg [15:0] oled_data);
    
    reg [15:0] color = 16'hFFFF;
    
    //blue and win
    reg [6:0] x_center = 32;
    reg [6:0] x_center1 = 43;
    reg [6:0] x_center2 = 54;
    reg [6:0] x_center3 = 65;
    
    //red
    reg [6:0] x_center4 = 38;
    reg [6:0] x_center5 = 48;
    reg [6:0] x_center6 = 58;
        
    
    reg [6:0] y_center = 24;
    reg [6:0] y_center2 = 37;
    
    always @ (posedge CLK_25MHz) begin
        //Blue
        if (team == 0) begin
            //B
            //line 1
            if (x >= x_center - 3 && x <= x_center + 3 && y == y_center - 4) begin
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
            else if (((x >= x_center - 3 && x <= x_center - 2) || (x >= x_center + 3 && x <= x_center + 4)) && y == y_center - 1) begin
                oled_data <= color;
            end
            //line 5
            else if (x >= x_center - 3 && x <= x_center + 3 && y == y_center) begin
                oled_data <= color;
            end 
            //line 6
            else if (x >= x_center - 3 && x <= x_center + 3 && y == y_center + 1) begin
                oled_data <= color;
            end
            //line 7
            else if (((x >= x_center - 3 && x <= x_center - 2) || (x >= x_center + 3 && x <= x_center + 4)) && y == y_center + 2) begin
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
            else if (x >= x_center - 3 && x <= x_center + 3 && y == y_center + 5) begin
                oled_data <= color;
            end 
            
            //L
            //line 1 - 8
            else if (x >= x_center1 - 3 && x <= x_center1 - 2 && y >= y_center - 4 && y <= y_center + 3) begin
                oled_data <= color;
            end 
            //line 9 - 10
            else if (x >= x_center1 - 3 && x <= x_center1 + 4 && y >= y_center + 4 && y <= y_center + 5) begin
                oled_data <= color;
            end
            
            //U
            //line 1
            else if (((x >= x_center2 - 3 && x <= x_center2 - 2) || (x >= x_center2 + 3 && x <= x_center2 + 4)) && y >= y_center - 4 && y <= y_center + 3) begin
                oled_data <= color;
            end 
            //line 9
            else if (x >= x_center2 - 3 && x <= x_center2 + 4 && y == y_center + 4) begin
                oled_data <= color;
            end 
            //line 10
            else if (x >= x_center2 - 2 && x <= x_center2 + 3 && y == y_center + 5) begin
                oled_data <= color;
            end     
            
            //E       
            //line 1 - 2
            else if (x >= x_center3 - 3 && x <= x_center3 + 4 && y >= y_center - 4 && y <= y_center - 3) begin
                oled_data <= color;
            end        
            //line 3 - 4     
            else if (x >= x_center3 - 3 && x <= x_center3 - 2 && y >= y_center - 2 && y <= y_center - 1) begin
                oled_data <= color;
            end 
            //line 5 - 6
            else if (x >= x_center3 - 3 && x <= x_center3 + 2 && y >= y_center && y <= y_center + 1) begin
                oled_data <= color;
            end  
            //line 7 - 8           
            else if (x >= x_center3 - 3 && x <= x_center3 - 2 && y >= y_center + 2 && y <= y_center + 3) begin
                oled_data <= color;
            end
            //line 9 - 10
            else if (x >= x_center3 - 3 && x <= x_center3 + 4 && y >= y_center + 4 && y <= y_center + 5) begin
                oled_data <= color;
            end 
                        
            //W
            //line 1 - 5
            else if (((x >= x_center - 3 && x <= x_center - 2) || (x >= x_center + 3 && x <= x_center + 4)) && y >= y_center2 - 4 && y <= y_center2) begin
                oled_data <= color;
            end 
            //line 6
            else if (((x >= x_center - 3 && x <= x_center - 2) || (x >= x_center && x <= x_center + 1) || (x >= x_center + 3 && x <= x_center + 4))&& y == y_center2 + 1) begin
                oled_data <= color;
            end 
            //line 5
            else if (x >= x_center - 3 && x <= x_center + 4 && y >= y_center2 + 2 && y <= y_center2 + 3) begin
                oled_data <= color;
            end 
            //line 7
            else if (((x >= x_center - 3 && x <= x_center - 1) || (x >= x_center + 2 && x <= x_center + 4)) && y == y_center2 + 4) begin
                oled_data <= color;
            end
            //line 8 - 10
            else if (((x >= x_center - 3 && x <= x_center - 2) || (x >= x_center + 3 && x <= x_center + 4)) && y == y_center2 + 5) begin
                oled_data <= color;
            end 
            
            //I
            //line 1 - 2
            else if (x >= x_center1 - 3 && x <= x_center1 + 4 && y >= y_center2 - 4 && y <= y_center2 - 3) begin
                oled_data <= color;
            end        
            //line 3 - 8     
            else if (x >= x_center1 && x <= x_center1 + 1 && y >= y_center2 - 2 && y <= y_center2 + 3) begin
                oled_data <= color;
            end 
            //line 9 - 10
            else if (x >= x_center1 - 3 && x <= x_center1 + 4 && y >= y_center2 + 4 && y <= y_center2 + 5) begin
                oled_data <= color;
            end       
            
            //N
            //line 1
            else if (((x >= x_center2 - 3 && x <= x_center2 - 2) || (x >= x_center2 + 3 && x <= x_center2 + 4)) && y == y_center2 - 4) begin
                oled_data <= color;
            end 
            //line 2
            else if (((x >= x_center2 - 3 && x <= x_center2 - 1) || (x >= x_center2 + 3 && x <= x_center2 + 4))&& y == y_center2 - 3) begin
                oled_data <= color;
            end 
            //line 3
            else if (((x >= x_center2 - 3 && x <= x_center2) || (x >= x_center2 + 3 && x <= x_center2 + 4)) && y == y_center2 - 2) begin
                oled_data <= color;
            end 
            //line 4
            else if (((x >= x_center2 - 3 && x <= x_center2 + 1) || (x >= x_center2 + 3 && x <= x_center2 + 4)) && y == y_center2 - 1) begin
                oled_data <= color;
            end
            //line 5
            else if (((x >= x_center2 - 3 && x <= x_center2 - 2) || (x >= x_center2 && x <= x_center2 + 4)) && y == y_center2) begin
                oled_data <= color;
            end 
            //line 6
            else if (((x >= x_center2 - 3 && x <= x_center2 - 2) || (x >= x_center2 + 1 && x <= x_center2 + 4)) && y == y_center2 + 1) begin
                oled_data <= color;
            end
            //line 7
            else if (((x >= x_center2 - 3 && x <= x_center2 - 2) || (x >= x_center2 + 2 && x <= x_center2 + 4)) && y == y_center2 + 2) begin
                oled_data <= color;
            end
            //line 8 - 10
            else if (((x >= x_center2 - 3 && x <= x_center2 - 2) || (x >= x_center2 + 3 && x <= x_center2 + 4)) && y >= y_center2 + 3 && y <= y_center2 + 5) begin
                oled_data <= color;
            end
                 
            //S
            //line 1
            else if (x >= x_center3 - 2 && x <= x_center3 + 3 && y == y_center2 - 4) begin
                oled_data <= color;
            end 
            //line 2
            else if (x >= x_center3 - 3 && x <= x_center3 + 4 && y == y_center2 - 3) begin
                oled_data <= color;
            end 
            //line 3
            else if (((x >= x_center3 - 3 && x <= x_center3 - 2) || (x >= x_center3 + 3 && x <= x_center3 + 4)) && y == y_center2 - 2) begin
                oled_data <= color;
            end 
            //line 4
            else if ((x >= x_center3 - 3 && x <= x_center3 - 2) && y == y_center2 - 1) begin
                oled_data <= color;
            end
            //line 5
            else if ((x >= x_center3 - 3 && x <= x_center3 + 3) && y == y_center2) begin
                oled_data <= color;
            end 
            //line 6
            else if ((x >= x_center3 - 2 && x <= x_center3 + 4) && y == y_center2 + 1) begin
                oled_data <= color;
            end
            //line 7
            else if ((x >= x_center3 + 3 && x <= x_center3 + 4) && y == y_center2 + 2) begin
                oled_data <= color;
            end
            //line 8
            else if (((x >= x_center3 - 3 && x <= x_center3 - 2) || (x >= x_center3 + 3 && x <= x_center3 + 4)) && y == y_center2 + 3) begin
                oled_data <= color;
            end 
            //line 9
            else if (x >= x_center3 - 3 && x <= x_center3 + 4 && y == y_center2 + 4) begin
                oled_data <= color;
            end 
            //line 10
            else if (x >= x_center3 - 2 && x <= x_center3 + 3 && y == y_center2 + 5) begin
                oled_data <= color;
            end      
                 
            else
                oled_data <= (CLK_D) ? 16'b00000_000000_11111 : 16'h0000;   
        end
        
        // Red
        else begin
            //R
            if (x >= x_center4 - 3 && x <= x_center4 + 3 && y == y_center - 4) begin
                oled_data <= color;
            end 
            //line 2
            else if (x >= x_center4 - 3 && x <= x_center4 + 4 && y == y_center - 3) begin
                oled_data <= color;
            end 
            //line 3
            else if (((x >= x_center4 - 3 && x <= x_center4 - 2) || (x >= x_center4 + 3 && x <= x_center4 + 4)) && y == y_center - 2) begin
                oled_data <= color;
            end 
            //line 4
            else if (((x >= x_center4 - 3 && x <= x_center4 - 2) || (x >= x_center4 + 3 && x <= x_center4 + 4)) && y == y_center - 1) begin
                oled_data <= color;
            end
            //line 5
            else if (x >= x_center4 - 3 && x <= x_center4 + 4 && y == y_center) begin
                oled_data <= color;
            end 
            //line 6
            else if (x >= x_center4 - 3 && x <= x_center4 + 3 && y == y_center + 1) begin
                oled_data <= color;
            end
            //line 7
            else if (((x >= x_center4 - 3 && x <= x_center4 - 2) || (x >= x_center4 + 2 && x <= x_center4 + 4)) && y == y_center + 2) begin
                oled_data <= color;
            end
            //line 8
            else if (((x >= x_center4 - 3 && x <= x_center4 - 2) || (x >= x_center4 + 3 && x <= x_center4 + 4)) && y == y_center + 3) begin
                oled_data <= color;
            end 
            //line 9
            else if (((x >= x_center4 - 3 && x <= x_center4 - 2) || (x >= x_center4 + 3 && x <= x_center4 + 4)) && y == y_center + 4) begin
                oled_data <= color;
            end 
            //line 10
            else if (((x >= x_center4 - 3 && x <= x_center4 - 2) || (x >= x_center4 + 3 && x <= x_center4 + 4)) && y == y_center + 5) begin
                oled_data <= color;
            end          
            
            //E
            else if (x >= x_center5 - 3 && x <= x_center5 + 4 && y >= y_center - 4 && y <= y_center - 3) begin
                oled_data <= color;
            end        
            //line 3 - 4     
            else if (x >= x_center5 - 3 && x <= x_center5 - 2 && y >= y_center - 2 && y <= y_center - 1) begin
                oled_data <= color;
            end 
            //line 5 - 6
            else if (x >= x_center5 - 3 && x <= x_center5 + 2 && y >= y_center && y <= y_center + 1) begin
                oled_data <= color;
            end  
            //line 7 - 8           
            else if (x >= x_center5 - 3 && x <= x_center5 - 2 && y >= y_center + 2 && y <= y_center + 3) begin
                oled_data <= color;
            end
            //line 9 - 10
            else if (x >= x_center5 - 3 && x <= x_center5 + 4 && y >= y_center + 4 && y <= y_center + 5) begin
                oled_data <= color;
            end         
            
            //D
            //line 1
            else if (x >= x_center6 - 3 && x <= x_center6 + 3 && y == y_center - 4) begin
                oled_data <= color;
            end 
            //line 2
            else if (x >= x_center6 - 3 && x <= x_center6 + 4 && y == y_center - 3) begin
                oled_data <= color;
            end 
            //line 3 - 8
            else if (((x >= x_center6 - 2 && x <= x_center6 - 1) || (x >= x_center6 + 3 && x <= x_center6 + 4)) && y >= y_center - 2 && y <= y_center + 3) begin
                oled_data <= color;
            end 
            //line 9
            else if (x >= x_center6 - 3 && x <= x_center6 + 4 && y == y_center + 4) begin
                oled_data <= color;
            end 
            //line 10
            else if (x >= x_center6 - 3 && x <= x_center6 + 3 && y == y_center + 5) begin
                oled_data <= color;
            end         
            
            //W
            //line 1 - 5
            else if (((x >= x_center - 3 && x <= x_center - 2) || (x >= x_center + 3 && x <= x_center + 4)) && y >= y_center2 - 4 && y <= y_center2) begin
                oled_data <= color;
            end 
            //line 6
            else if (((x >= x_center - 3 && x <= x_center - 2) || (x >= x_center && x <= x_center + 1) || (x >= x_center + 3 && x <= x_center + 4))&& y == y_center2 + 1) begin
                oled_data <= color;
            end 
            //line 5
            else if (x >= x_center - 3 && x <= x_center + 4 && y >= y_center2 + 2 && y <= y_center2 + 3) begin
                oled_data <= color;
            end 
            //line 7
            else if (((x >= x_center - 3 && x <= x_center - 1) || (x >= x_center + 2 && x <= x_center + 4)) && y == y_center2 + 4) begin
                oled_data <= color;
            end
            //line 8 - 10
            else if (((x >= x_center - 3 && x <= x_center - 2) || (x >= x_center + 3 && x <= x_center + 4)) && y == y_center2 + 5) begin
                oled_data <= color;
            end 
            
            //I
            //line 1 - 2
            else if (x >= x_center1 - 3 && x <= x_center1 + 4 && y >= y_center2 - 4 && y <= y_center2 - 3) begin
                oled_data <= color;
            end        
            //line 3 - 8     
            else if (x >= x_center1 && x <= x_center1 + 1 && y >= y_center2 - 2 && y <= y_center2 + 3) begin
                oled_data <= color;
            end 
            //line 9 - 10
            else if (x >= x_center1 - 3 && x <= x_center1 + 4 && y >= y_center2 + 4 && y <= y_center2 + 5) begin
                oled_data <= color;
            end       
            
            //N
            //line 1
            else if (((x >= x_center2 - 3 && x <= x_center2 - 2) || (x >= x_center2 + 3 && x <= x_center2 + 4)) && y == y_center2 - 4) begin
                oled_data <= color;
            end 
            //line 2
            else if (((x >= x_center2 - 3 && x <= x_center2 - 1) || (x >= x_center2 + 3 && x <= x_center2 + 4))&& y == y_center2 - 3) begin
                oled_data <= color;
            end 
            //line 3
            else if (((x >= x_center2 - 3 && x <= x_center2) || (x >= x_center2 + 3 && x <= x_center2 + 4)) && y == y_center2 - 2) begin
                oled_data <= color;
            end 
            //line 4
            else if (((x >= x_center2 - 3 && x <= x_center2 + 1) || (x >= x_center2 + 3 && x <= x_center2 + 4)) && y == y_center2 - 1) begin
                oled_data <= color;
            end
            //line 5
            else if (((x >= x_center2 - 3 && x <= x_center2 - 2) || (x >= x_center2 && x <= x_center2 + 4)) && y == y_center2) begin
                oled_data <= color;
            end 
            //line 6
            else if (((x >= x_center2 - 3 && x <= x_center2 - 2) || (x >= x_center2 + 1 && x <= x_center2 + 4)) && y == y_center2 + 1) begin
                oled_data <= color;
            end
            //line 7
            else if (((x >= x_center2 - 3 && x <= x_center2 - 2) || (x >= x_center2 + 2 && x <= x_center2 + 4)) && y == y_center2 + 2) begin
                oled_data <= color;
            end
            //line 8 - 10
            else if (((x >= x_center2 - 3 && x <= x_center2 - 2) || (x >= x_center2 + 3 && x <= x_center2 + 4)) && y >= y_center2 + 3 && y <= y_center2 + 5) begin
                oled_data <= color;
            end
                 
            //S
            //line 1
            else if (x >= x_center3 - 2 && x <= x_center3 + 3 && y == y_center2 - 4) begin
                oled_data <= color;
            end 
            //line 2
            else if (x >= x_center3 - 3 && x <= x_center3 + 4 && y == y_center2 - 3) begin
                oled_data <= color;
            end 
            //line 3
            else if (((x >= x_center3 - 3 && x <= x_center3 - 2) || (x >= x_center3 + 3 && x <= x_center3 + 4)) && y == y_center2 - 2) begin
                oled_data <= color;
            end 
            //line 4
            else if ((x >= x_center3 - 3 && x <= x_center3 - 2) && y == y_center2 - 1) begin
                oled_data <= color;
            end
            //line 5
            else if ((x >= x_center3 - 3 && x <= x_center3 + 3) && y == y_center2) begin
                oled_data <= color;
            end 
            //line 6
            else if ((x >= x_center3 - 2 && x <= x_center3 + 4) && y == y_center2 + 1) begin
                oled_data <= color;
            end
            //line 7
            else if ((x >= x_center3 + 3 && x <= x_center3 + 4) && y == y_center2 + 2) begin
                oled_data <= color;
            end
            //line 8
            else if (((x >= x_center3 - 3 && x <= x_center3 - 2) || (x >= x_center3 + 3 && x <= x_center3 + 4)) && y == y_center2 + 3) begin
                oled_data <= color;
            end 
            //line 9
            else if (x >= x_center3 - 3 && x <= x_center3 + 4 && y == y_center2 + 4) begin
                oled_data <= color;
            end 
            //line 10
            else if (x >= x_center3 - 2 && x <= x_center3 + 3 && y == y_center2 + 5) begin
                oled_data <= color;
            end      
                 
            else
                oled_data <= (CLK_D) ? 16'b11111_000000_00000 : 16'h0000;   
        end
    end

endmodule