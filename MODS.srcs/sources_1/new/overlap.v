`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Edward Humianto
// 
// Create Date: 10/29/2023 01:38:40 PM
// Design Name: 
// Module Name: overlap
// Project Name: 
// Description: 
// Given the current position of a player, and 5 other players, detect if there are 
// overlap on 4 directions (left, right, up, down)
//////////////////////////////////////////////////////////////////////////////////

// Returns 2-bit overlap_status. [0] left, [1] right, [2] up, [3] down. HIGH if overlap, LOW otherwise
module overlap(input [6:0] x_current, y_current, x1, y1, x2, y2, x3, y3, x4, y4, x5, y5, output reg [3:0] overlap_status);
    parameter width = 3;
    parameter height = 8;
    
    always @ (*) begin
        if (x_current >= x1 && x_current - x1 <= width && (y_current >= y1 && y_current - y1 <= height || y_current <= y1 && y1 - y_current <= height) || 
            x_current >= x2 && x_current - x2 <= width && (y_current >= y2 && y_current - y2 <= height || y_current <= y2 && y2 - y_current <= height) || 
            x_current >= x3 && x_current - x3 <= width && (y_current >= y3 && y_current - y3 <= height || y_current <= y3 && y3 - y_current <= height) ||
            x_current >= x4 && x_current - x4 <= width && (y_current >= y4 && y_current - y4 <= height || y_current <= y4 && y4 - y_current <= height) || 
            x_current >= x5 && x_current - x5 <= width && (y_current >= y5 && y_current - y5 <= height || y_current <= y5 && y5 - y_current <= height)) begin
            overlap_status[0] = 1;
        end
        else begin
            overlap_status[0] = 0;
        end
        
        if (x_current <= x1 && x1 - x_current <= width && (y_current >= y1 && y_current - y1 <= height || y_current <= y1 && y1 - y_current <= height) || 
            x_current <= x2 && x2 - x_current <= width && (y_current >= y2 && y_current - y2 <= height || y_current <= y2 && y2 - y_current <= height) || 
            x_current <= x3 && x3 - x_current <= width && (y_current >= y3 && y_current - y3 <= height || y_current <= y3 && y3 - y_current <= height) ||
            x_current <= x4 && x4 - x_current <= width && (y_current >= y4 && y_current - y4 <= height || y_current <= y4 && y4 - y_current <= height) || 
            x_current <= x5 && x5 - x_current <= width && (y_current >= y5 && y_current - y5 <= height || y_current <= y5 && y5 - y_current <= height)) begin
            overlap_status[1] = 1;
        end
        else begin
            overlap_status[1] = 0;
        end
        
        if (y_current >= y1 && y_current - y1 <= height && (x_current >= x1 && x_current - x1 <= width || x_current <= x1 && x1 - x_current <= width) || 
            y_current >= y2 && y_current - y2 <= height && (x_current >= x2 && x_current - x2 <= width || x_current <= x2 && x2 - x_current <= width) || 
            y_current >= y3 && y_current - y3 <= height && (x_current >= x3 && x_current - x3 <= width || x_current <= x3 && x3 - x_current <= width) ||
            y_current >= y4 && y_current - y4 <= height && (x_current >= x4 && x_current - x4 <= width || x_current <= x4 && x4 - x_current <= width) || 
            y_current >= y5 && y_current - y5 <= height && (x_current >= x5 && x_current - x5 <= width || x_current <= x5 && x5 - x_current <= width)) begin
            overlap_status[2] = 1;
        end
        else begin
            overlap_status[2] = 0;
        end
        
        if (y_current <= y1 && y1 - y_current <= height && (x_current >= x1 && x_current - x1 <= width || x_current <= x1 && x1 - x_current <= width) || 
            y_current <= y2 && y2 - y_current <= height && (x_current >= x2 && x_current - x2 <= width || x_current <= x2 && x2 - x_current <= width) || 
            y_current <= y3 && y3 - y_current <= height && (x_current >= x3 && x_current - x3 <= width || x_current <= x3 && x3 - x_current <= width) ||
            y_current <= y4 && y4 - y_current <= height && (x_current >= x4 && x_current - x4 <= width || x_current <= x4 && x4 - x_current <= width) || 
            y_current <= y5 && y5 - y_current <= height && (x_current >= x5 && x_current - x5 <= width || x_current <= x5 && x5 - x_current <= width)) begin
            overlap_status[3] = 1;
        end
        else begin
            overlap_status[3] = 0;
        end        
    end
endmodule
