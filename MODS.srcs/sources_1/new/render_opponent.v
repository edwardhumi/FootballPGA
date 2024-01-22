`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/31/2023 10:15:16 AM
// Design Name: 
// Module Name: render_opponent
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


module render_opponent(input [6:0] x, [6:0] y, input [6:0]x_center, [6:0]y_center, input CLK_25MHz, input holding_ball, is_keeper, is_moving, controlled, is_kick, output reg [15:0] oled_data);
    
    reg [31:0] counter = 0;
    wire running;
    reg state = 0;
    reg kick = 0;
    reg [31:0] kick_counter = 0;

    assign running = is_moving;
   
    always @ (posedge CLK_25MHz) begin       
        //body
        if (x >= x_center && x <= x_center + 1 && y >= y_center - 1 && y <= y_center + 1) begin
            if (is_keeper) begin
                oled_data <= 16'b11111_001111_00000;
            end
            else begin  
                oled_data <= (controlled) ? 16'b11000_11000_11111 : 16'b00000_000000_00111;
            end
        end
        if (x == x_center - 1 && y >= y_center - 1 && y <= y_center) begin
            oled_data <= 16'b11111_11111_11111;
        end
        if (x == x_center - 1 && y == y_center + 1) begin
            oled_data <= 16'b01110_101000_00000;
        end
        //head
        if (x >= x_center && x <= x_center + 1 && y == y_center - 2) begin
            oled_data <= 16'b01110_101000_00000;
        end
        if (x >= x_center && x <= x_center + 1 && y == y_center - 3) begin
            oled_data <= 16'b00000_000000_00000;
        end
        //legs
        if ((x == x_center - 1 || x == x_center + 1) && y >= y_center + 2 && y <= y_center + 3) begin
            oled_data <= 16'b00000_101000_11111;
        end
        if ((x == x_center || x == x_center + 2 || x == x_center - 2) && y >= y_center + 2 && y <= y_center + 4) begin
            oled_data <= 16'b00000_111111_00000;
        end
        if (running || kick) begin 
          if (running && ~kick) begin
              if ((x == x_center - 2 && y == y_center + 3) || ((x == x_center + 1) && y == y_center + 4)) begin
                  oled_data <= (state) ? 16'b00000_000000_00000 : 16'b00000_111111_00000;
              end
              if ((x == x_center && y == y_center + 3) || ((x == x_center - 1) && y == y_center + 4)) begin
                  oled_data <= (state) ? 16'b00000_111111_00000 : 16'b00000_000000_00000;
              end
          end
          if (kick) begin
              if ((x == x_center + 2 && y == y_center + 3) || ((x == x_center - 1) && y == y_center + 4)) begin
                  oled_data <= 16'b00000_000000_00000;
              end
          end
        end
        else begin
          if ((x == x_center - 1 || x == x_center + 1) && y == y_center + 4) begin
              oled_data <= 16'b00000_000000_00000;
          end
        end
    end
    
    always @ (posedge CLK_25MHz) begin
        counter = (counter == 6_249_999) ? 0 : counter + 1;
        state <= (counter == 0) ? ~state : state;    
        if (is_kick && controlled) begin
            kick_counter = (kick_counter == 3_000_000) ? kick_counter : kick_counter + 1;
            kick <= (kick_counter < 4_000_000) ? 1 : 0;
        end
        else begin
            kick_counter = 0;
            kick = 0;
        end
    end
endmodule