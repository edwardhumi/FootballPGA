`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Edward Humianto
// 
// Create Date: 10/25/2023 09:51:07 PM
// Design Name: 
// Module Name: player_movement
// Project Name: 
// Description: 
// Given the coordinates of the current player, deduce how the coordinate will be
// updated in each clock cycle. Handles both CONTROLLED and BOT movement.
//////////////////////////////////////////////////////////////////////////////////


module player_movement(input reset, input [2:0] index, input CLK_PLAYER, CLK_BOT, input[2:0] defense_mode, input attack_mode, input [6:0] x0, y0, input controlled, input [1:0] direction_x, direction_y, input status,
                       input [6:0] x_ball, y_ball, x_team1, y_team1, x_team2, y_team2, x_opp1, y_opp1, x_opp2, y_opp2, x_opp3, y_opp3, 
                       output [6:0] x1, y1, output is_moving);
    
    // CONTROLLED and BOT MOVEMENT                   
    reg [6:0] x_player, y_player;
    wire [6:0] x_bot, y_bot;
    assign x1 = (controlled) ? x_player : x_bot;
    assign y1 = (controlled) ? y_player : y_bot;
    wire is_player_moving, is_bot_moving;
    assign is_player_moving = (direction_x > 0) || (direction_y > 0);
    assign is_moving = controlled ? is_player_moving : is_bot_moving;
    
    // PREVENTS OVERLAPPING MOVEMENT
    wire [3:0] overlap_status;    
    overlap overlap_mod(x0, y0, x_team1, y_team1, x_team2, y_team2, x_opp1, y_opp1, x_opp2, y_opp2, x_opp3, y_opp3, overlap_status);
    
    // BOT MOVEMENT
    reg [6:0] x_dest, y_dest;
    move_diagonal diag_mod(CLK_BOT, x0, y0, x_dest, y_dest, overlap_status, x_bot, y_bot, is_bot_moving);                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
    
    // SORT THE Y-POSITION OF EACH PLAYER
    wire [1:0] position;
    wire [5:0] pos_opp;
    assign position = (y0 < y_team1) ? (y0 < y_team2) ? 2'b00 : 2'b01 : (y0 < y_team2) ? 2'b01 : 2'b10;
    assign pos_opp = (y_opp1 < y_opp2 && y_opp1 < y_opp3 && y_opp2 < y_opp3) ? 6'b100100 : (y_opp1 < y_opp2 && y_opp1 < y_opp3 && ~(y_opp2 < y_opp3)) ? 6'b011000 :
                     (~(y_opp1 < y_opp2) && y_opp2 < y_opp3 && y_opp1 < y_opp3) ? 6'b100001 : (~(y_opp1 < y_opp2) && y_opp2 < y_opp3 && ~(y_opp1 < y_opp3)) ? 6'b010010 :
                     (~(y_opp1 < y_opp3) && ~(y_opp2 < y_opp3) && y_opp1 < y_opp2) ? 6'b001001 : (~(y_opp1 < y_opp3) && ~(y_opp2 < y_opp3) && ~(y_opp1 < y_opp2)) ? 6'b000110 : 6'b111111; 
    
    
    always @ (posedge CLK_PLAYER) begin
        if (reset) begin
            x_player <= x0;
            y_player <= y0;
        end
        else begin
            if (controlled) begin   // CONTROLLED BY PLAYER
                if (direction_x == 0) begin   //stop
                    x_player <= x0;
                end                
                if (direction_y == 0) begin   //stop
                    y_player <= y0;
                end
                if (direction_y == 1) begin   //up
                    y_player <= (y0 > 3 && ~overlap_status[2]) ? y0 - 1 : y0;
                end
                if (direction_x == 1) begin   //right
                    x_player <= (x0 < 92 && ~overlap_status[1]) ? x0 + 1 : x0;
                end        
                if (direction_y == 2) begin   //down
                    y_player <= (y0 < 60 && ~overlap_status[3]) ? y0 + 1 : y0;            
                end
                if (direction_x == 2) begin   //left
                    x_player <= (x0 > 3 && ~overlap_status[0]) ? x0 - 1 : x0;
                end         
            end
            else begin
                x_player <= x0;
                y_player <= y0;            
            end
        end
    end
    
    // CONTROLLED BY BOT
    always @ (*) begin
        if (reset) begin
            x_dest <= x0;
            y_dest <= y0;
        end
        else begin
            if (~controlled) begin
                if (status == 0) begin //ATTACKING
                    if (attack_mode) begin
                        // LEFT TEAM
                        if (index == 3'b000 || index == 3'b001 || index == 3'b010) begin                            
                            if (position == 2'b00) begin
                                x_dest <= (x_ball < 38) ? 47 : (x_ball < 70) ? x_ball + 20 : 83;                                                    
                                y_dest <= (x_ball < 38) ? 13 : (x_ball < 70) ? 6 : 13;
                            end
                            else if (position == 2'b01) begin 
                                x_dest <= (x_ball < 49) ? 38 : (x_ball < 70) ? x_ball - 10 : 65;                        
                                y_dest <= 31;
                            end
                            else if (position == 2'b10) begin 
                                x_dest <= (x_ball < 38) ? 47 : (x_ball < 70) ? x_ball + 20 : 83;                        
                                y_dest <= (x_ball < 38) ? 50 : (x_ball < 70) ? 57 : 50;
                            end
                            else begin
                                x_dest <= 0;
                                y_dest <= 0;
                            end
                        end
                        // RIGHT TEAM
                        else begin
                            if (position == 2'b00) begin
                                x_dest <= (x_ball > 57) ? 47 : (x_ball > 25) ? x_ball - 20 : 12;                                                    
                                y_dest <= (x_ball > 57) ? 13 : (x_ball > 25) ? 6 : 13;
                            end
                            else if (position == 2'b01) begin 
                                x_dest <= (x_ball > 46) ? 38 : (x_ball > 25) ? x_ball + 10 : 65;                          
                                y_dest <= 31;
                            end
                            else if (position == 2'b10) begin 
                                x_dest <= (x_ball > 57) ? 47 : (x_ball > 25) ? x_ball - 20 : 12;                        
                                y_dest <= (x_ball > 57) ? 50 : (x_ball > 25) ? 57 : 50;
                            end
                            else begin
                                x_dest <= 0;
                                y_dest <= 0;
                            end                        
                        end              
                    end
                    else begin
                        x_dest <= x0;
                        y_dest <= y0;
                    end
                end
                else begin  //DEFENDING
                    if (defense_mode[0]) begin   //PRESSING MODE
                        x_dest <= x_ball;
                        y_dest <= y_ball;
                    end  
                    else if (defense_mode[1]) begin    // MAN-TO-MAN MODE
                        if (pos_opp[1:0] == position) begin
                            x_dest <= (index == 3'b000 || index == 3'b001 || index == 3'b010) ?  x_opp1 - 6: x_opp1 + 6;
                            y_dest <= y_opp1;
                        end    
                        else if (pos_opp[3:2] == position) begin
                            x_dest <= (index == 3'b000 || index == 3'b001 || index == 3'b010) ?  x_opp2 - 6: x_opp2 + 6;
                            y_dest <= y_opp2;
                        end
                        else if (pos_opp[5:4] == position) begin
                            x_dest <= (index == 3'b000 || index == 3'b001 || index == 3'b010) ?  x_opp3 - 6: x_opp3 + 6;
                            y_dest <= y_opp3;
                        end
                        else begin
                            x_dest <= 0;
                            y_dest <= 0;
                        end
                    end                
                    else if (defense_mode[2]) begin    // FALL-BACK MODE
                        if (index == 3'b000 || index == 3'b001 || index == 3'b010) begin                        
                            if (position == 2'b00) begin
                                x_dest <= (x_opp1 < 25 || x_opp2 < 25 || x_opp3 < 25) ? 10 : (x_opp1 < 42 || x_opp2 < 42 || x_opp3 < 42) ? 20 : 30;                                                    
                                y_dest <= (x_opp1 < 25 || x_opp2 < 25 || x_opp3 < 25) ? 23 : (x_opp1 < 42 || x_opp2 < 42 || x_opp3 < 42) ? 18 : 12;
                            end
                            else if (position == 2'b01) begin 
                                x_dest <= (x_opp1 < 42 || x_opp2 < 42 || x_opp3 < 42) ? 15 : 20;                        
                                y_dest <= 31;
                            end
                            else if (position == 2'b10) begin 
                                x_dest <= (x_opp1 < 25 || x_opp2 < 25 || x_opp3 < 25) ? 10 : (x_opp1 < 42 || x_opp2 < 42 || x_opp3 < 42) ? 20 : 30;                      
                                y_dest <= (x_opp1 < 25 || x_opp2 < 25 || x_opp3 < 25) ? 40 : (x_opp1 < 42 || x_opp2 < 42 || x_opp3 < 42) ? 45 : 51;
                            end
                            else begin
                                x_dest <= 0;
                                y_dest <= 0;
                            end
                        end
                        else begin
                            if (position == 2'b00) begin
                                x_dest <= (x_opp1 > 70 || x_opp2 > 70 || x_opp3 > 70) ? 85 : (x_opp1 >= 52 || x_opp2 >= 52 || x_opp3 >= 52) ? 75 : 65;                                                    
                                y_dest <= (x_opp1 > 70 || x_opp2 > 70 || x_opp3 > 70) ? 23 : (x_opp1 >= 52 || x_opp2 >= 52 || x_opp3 >= 52) ? 18 : 12;
                            end
                            else if (position == 2'b01) begin 
                                x_dest <= (x_opp1 >= 52 || x_opp2 >= 52 || x_opp3 >= 52) ? 80 : 75;                        
                                y_dest <= 31;
                            end
                            else if (position == 2'b10) begin 
                                x_dest <= (x_opp1 > 70 || x_opp2 > 70 || x_opp3 > 70) ? 85 : (x_opp1 >= 52 || x_opp2 >= 52 || x_opp3 >= 52) ? 75 : 65;                        
                                y_dest <= (x_opp1 > 70 || x_opp2 > 70 || x_opp3 > 70) ? 40 : (x_opp1 >= 52 || x_opp2 >= 52 || x_opp3 >= 52) ? 45 : 51;
                            end
                            else begin
                                x_dest <= 0;
                                y_dest <= 0;
                            end                        
                        end    
                    end
                    else begin
                        x_dest <= x0;
                        y_dest <= y0;
                    end
               end       
            end 
            else begin
                x_dest <= x0;
                y_dest <= y0;        
            end  
        end
    end
endmodule
