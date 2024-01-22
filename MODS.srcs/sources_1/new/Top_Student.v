`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
//
//  FILL IN THE FOLLOWING INFORMATION:
//  STUDENT A NAME: Edward Humianto
//  STUDENT B NAME: Wilbert Liawantara
//  STUDENT C NAME: Jason Lienardi
//  STUDENT D NAME: Bryan Castorius Halim
//
//////////////////////////////////////////////////////////////////////////////////


module Top_Student (input clock, btnR, btnL, btnC, btnU, btnD, input [15:0] sw, input [7:0] JB, output [7:0] JC,
                    output [7:0] JA, input [7:0] JXADC, output reg [15:0] led, output reg [6:0] seg=7'b1111111,
                    output reg [3:0] an = 4'b1111, output reg dp, inout PS2Clk, inout PS2Data);
    // ESSENTIAL WIRE
    wire fb, sdpx, sppx;
    wire [12:0] pixel_index;
    wire [11:0] xpos;
    wire [11:0] ypos;
    wire [3:0] zpos;
    wire left, middle, right, new_event, mousepress, mousereset, mousepressx, mousepressy;
    reg [15:0] oled_data;  
    wire [7:0] JC_1;
    
    //Switches from second board
    wire sw_a = sw[15];
    wire [7:0] sw_2;
    wire btnU2, btnR2, btnC2, btnL2, btnD2;
    wire left2, right2, middle2;
    assign JC[0] = (sw_a && sw[0]) || (~sw_a && JC_1[0]);
    assign sw_2[0] = (~sw_a && JB[0]); 
    assign JC[1] = (sw_a && sw[1]) || (~sw_a && JC_1[1]);
    assign sw_2[1] = (~sw_a && JB[1]); 
    assign JC[2] = (sw_a && sw[2]) || (~sw_a && JC_1[2]);
    assign sw_2[2] = (~sw_a && JB[2]); 
    assign JC[3] = (sw_a && sw[3]) || (~sw_a && JC_1[3]);
    assign sw_2[3] = (~sw_a && JB[3]); 
    assign JC[4] = (sw_a && sw[4]) || (~sw_a && JC_1[4]);
    assign sw_2[4] = (~sw_a && JB[4]); 
    assign JC[5] = (sw_a && sw[5]) || (~sw_a && JC_1[5]);
    assign sw_2[5] = (~sw_a && JB[5]); 
    assign JC[6] = (sw_a && sw[6]) || (~sw_a && JC_1[6]);
    assign sw_2[6] = (~sw_a && JB[6]);
    assign JC[7] = (sw_a && sw[7]) || (~sw_a && JC_1[7]);
    assign sw_2[7] = (~sw_a && JB[7]);  
 
    //Buttons + Mouse clicks
    assign JA[0] = (sw_a && btnU);
    assign btnU2 = (~sw_a && JXADC[0]);    
    assign JA[1] = (sw_a && btnD);
    assign btnD2 = (~sw_a && JXADC[1]);                 
    assign JA[2] = (sw_a && btnL);
    assign btnL2 = (~sw_a && JXADC[2]);  
    assign JA[3] = (sw_a && btnR);
    assign btnR2 = (~sw_a && JXADC[3]);    
    assign JA[4] = (sw_a && btnC);
    assign btnC2 = (~sw_a && JXADC[4]);    
    assign JA[5] = (sw_a && left);
    assign left2 = (~sw_a && JXADC[5]);
    assign JA[6] = (sw_a && right);
    assign right2 = (~sw_a && JXADC[6]);
    assign JA[7] = (sw_a && middle);
    assign middle2 = (~sw_a && JXADC[7]);   
        
    // CLOCKS 
    wire CLK_6p25MHz, CLK_25MHz, CLK_PLAYER, CLK_BOT, CLK_KEEPER, CLK_D, hz250clk;
    flexible_clock clk_6p25mhz (clock, 7, CLK_6p25MHz);
    flexible_clock clk_25mhz (clock, 1, CLK_25MHz);
    flexible_clock clk_player (clock, 3333330, CLK_PLAYER);
    flexible_clock clk_bot (clock, 6666660, CLK_BOT);  
    flexible_clock clk_keeper (clock, 8888880, CLK_KEEPER);
    flexible_clock clk_D (clock, 24999999, CLK_D);
    flexible_clock cloccc (clock, 199_999, hz250clk);
        
    // OLED and MOUSE
    Oled_Display oled (.clk(CLK_6p25MHz), .reset(0), .pixel_data(oled_data),
                        .frame_begin(fb), .sending_pixels(sdpx), .sample_pixel(sppx), .pixel_index(pixel_index),  
                        .cs(JC_1[0]), .sdin(JC_1[1]), .sclk(JC_1[3]), .d_cn(JC_1[4]), .resn(JC_1[5]), .vccen(JC_1[6]), .pmoden(JC_1[7]));
    MouseCtl mouse (.clk(clock), .rst(0), .value(0), .setx(0), .sety(0), .setmax_x(0), .setmax_y(0), 
                    .xpos(xpos), .ypos(ypos), .zpos(zpos), .left(left), .middle(middle), .right(right), .new_event(new_event), 
                    .ps2_clk(PS2Clk), .ps2_data(PS2Data));
                    
    /* PROJECT */
    wire reset;
    //RESET KEEPER
    wire [1:0] reset_keeper_status; //10 reset by keeper on the left, 01 reset by keeper on the right

    assign reset = ~sw[8];
    wire [6:0] x, y;    
    assign x = pixel_index%96;
    assign y = pixel_index/96;
    wire [15:0] oled_data_player_0, oled_data_player_1, oled_data_player_2, oled_data_player_3, oled_data_player_4, oled_data_player_5, oled_data_keeper_red, oled_data_keeper_blue, oled_data_field, oled_data_start, oled_data_goal, oled_data_winner;

    // COORDINATES for player and ball
    reg [6:0] x0, y0, x1, y1, x2, y2, x3, y3, x4, y4, x5, y5, x6, y6, x7, y7; 
    wire [6:0] x_ball, y_ball;
    wire [6:0] x0_1, y0_1, x1_1, y1_1, x2_1, y2_1, x3_1, y3_1, x4_1, y4_1, x5_1, y5_1, x6_1, y6_1, x7_1, y7_1; 
    wire [7:0] is_moving;
    reg team;

    // Current controlled player
    reg [1:0] player1 = 0;
    reg [1:0] player2 = 0;
    wire [1:0] player1_auto;
    wire [1:0] player2_auto;    
    reg [1:0] direction1_x = 0; //0 - stop, 1 - right, 2 - left
    reg [1:0] direction1_y = 0; //0 - stop, 1 - up, 2 - down
    reg [1:0] direction2_x = 0; 
    reg [1:0] direction2_y = 0;

    // BALL Module
    reg [5:0] possession = 6'b000000; //starting condition
    ball ball_mod (reset, CLK_25MHz, btnL, btnR, btnU, btnD, left,right,middle,CLK_6p25MHz,pixel_index, 
                   x0-1, y0-4, x1-1, y1-4, x2-1, y2-4, x3-1, y3-4, x4-1, y4-4, x5-1, y5-4, player1, player2, x_ball, y_ball,
                   btnL2, btnR2, btnU2, btnD2, left2, right2, middle2, reset_keeper_status, possession );
                       
    // Status for attacking/defending    
    wire status1, status2;
    assign status1 = ~(possession == 6'b000001 || possession == 6'b000010 || possession == 6'b000100);
    assign status2 = ~(possession == 6'b001000 || possession == 6'b010000 || possession == 6'b100000);
    
    // Attack and defense mode
    wire [2:0] defense_mode1, defense_mode2;
    wire attack_mode1, attack_mode2;
    assign defense_mode1 = {sw[7], sw[6], sw[5]};
    assign defense_mode2 = {sw_2[7], sw_2[6], sw_2[5]};
    assign attack_mode1 = sw[4];
    assign attack_mode2 = sw_2[4];
    
    // Automatic Switch Module
    auto_switch team1 (x_ball, y_ball, x0, y0, x1, y1, x2, y2, player1_auto);
    auto_switch team2 (x_ball, y_ball, x3, y3, x4, y4, x5, y5, player2_auto);

    // Player Movement Module
    player_movement move0 (reset, 3'b000, CLK_PLAYER, CLK_BOT, defense_mode1, attack_mode1, x0, y0, ~player1[0] & ~player1[1], direction1_x, direction1_y, status1, x_ball, y_ball, x1, y1, x2, y2, x3, y3, x4, y4, x5, y5, x0_1, y0_1, is_moving[0]);
    player_movement move1 (reset, 3'b001, CLK_PLAYER, CLK_BOT, defense_mode1, attack_mode1, x1, y1, player1[0] & ~player1[1], direction1_x, direction1_y, status1, x_ball, y_ball, x0, y0, x2, y2, x3, y3, x4, y4, x5, y5, x1_1, y1_1, is_moving[1]);
    player_movement move2 (reset, 3'b010, CLK_PLAYER, CLK_BOT, defense_mode1, attack_mode1, x2, y2, ~player1[0] & player1[1], direction1_x, direction1_y, status1, x_ball, y_ball, x0, y0, x1, y1, x3, y3, x4, y4, x5, y5, x2_1, y2_1, is_moving[2]);
    player_movement move3 (reset, 3'b011, CLK_PLAYER, CLK_BOT, defense_mode2, attack_mode2, x3, y3, ~player2[0] & ~player2[1], direction2_x, direction2_y, status2, x_ball, y_ball, x4, y4, x5, y5, x0, y0, x1, y1, x2, y2, x3_1, y3_1, is_moving[3]);
    player_movement move4 (reset, 3'b100, CLK_PLAYER, CLK_BOT, defense_mode2, attack_mode2, x4, y4, player2[0] & ~player2[1], direction2_x, direction2_y, status2, x_ball, y_ball, x3, y3, x5, y5, x0, y0, x1, y1, x2, y2, x4_1, y4_1, is_moving[4]);
    player_movement move5 (reset, 3'b101, CLK_PLAYER, CLK_BOT, defense_mode2, attack_mode2, x5, y5, ~player2[0] & player2[1], direction2_x, direction2_y, status2, x_ball, y_ball, x3, y3, x4, y4, x0, y0, x1, y1, x2, y2, x5_1, y5_1, is_moving[5]);
    goalkeeper_movement move6 (CLK_KEEPER, x6, y6, x_ball, y_ball, x6_1, y6_1, is_moving[6]); 
    goalkeeper_movement move7 (CLK_KEEPER, x7, y7, x_ball, y_ball, x7_1, y7_1, is_moving[7]);                    
    
    // RENDER
    render_field field(.x(x), .y(y), .CLK_25MHz(CLK_25MHz), .oled_data(oled_data_field));    
    render_opponent render_player_0(.x(x), .y(y), .x_center(x0), .y_center(y0), .CLK_25MHz(CLK_25MHz), .holding_ball(0), .is_keeper(0), .is_moving(is_moving[0]), .controlled(~player1[0] & ~player1[1]), .is_kick(left | middle | right | btnC), .oled_data(oled_data_player_0));
    render_opponent render_player_1(.x(x), .y(y), .x_center(x1), .y_center(y1), .CLK_25MHz(CLK_25MHz), .holding_ball(0), .is_keeper(0), .is_moving(is_moving[1]), .controlled(player1[0] & ~player1[1]), .is_kick(left | middle | right | btnC), .oled_data(oled_data_player_1));
    render_opponent render_player_2(.x(x), .y(y), .x_center(x2), .y_center(y2), .CLK_25MHz(CLK_25MHz), .holding_ball(0), .is_keeper(0), .is_moving(is_moving[2]), .controlled(~player1[0] & player1[1]), .is_kick(left | middle | right | btnC), .oled_data(oled_data_player_2));    
    render_player render_player_3(.x(x), .y(y), .x_center(x3), .y_center(y3), .CLK_25MHz(CLK_25MHz), .holding_ball(0), .is_keeper(0), .is_moving(is_moving[3]), .controlled(~player2[0] & ~player2[1]), .is_kick(left2 | middle2 | right2 | btnC2), .oled_data(oled_data_player_3));
    render_player render_player_4(.x(x), .y(y), .x_center(x4), .y_center(y4), .CLK_25MHz(CLK_25MHz), .holding_ball(0), .is_keeper(0), .is_moving(is_moving[4]), .controlled(player2[0] & ~player2[1]), .is_kick(left2 | middle2 | right2 | btnC2), .oled_data(oled_data_player_4));
    render_player render_player_5(.x(x), .y(y), .x_center(x5), .y_center(y5), .CLK_25MHz(CLK_25MHz), .holding_ball(0), .is_keeper(0), .is_moving(is_moving[5]), .controlled(~player2[0] & player2[1]), .is_kick(left2 | middle2 | right2 | btnC2), .oled_data(oled_data_player_5));       
    render_opponent render_keeper_red(.x(x), .y(y), .x_center(x6), .y_center(y6), .CLK_25MHz(CLK_25MHz), .holding_ball(0), .is_keeper(1), .is_moving(is_moving[6]), .controlled(0), .is_kick(btnC), .oled_data(oled_data_keeper_red));    
    render_player render_keeper_blue(.x(x), .y(y), .x_center(x7), .y_center(y7), .CLK_25MHz(CLK_25MHz), .holding_ball(0), .is_keeper(1), .is_moving(is_moving[7]), .controlled(0), .is_kick(btnC), .oled_data(oled_data_keeper_blue));
    
    
    //START MENU
    render_start_menu start_menu(.x(x), .y(y), .CLK_25MHz(CLK_25MHz), .background(oled_data_field), .oled_data(oled_data_start));
    
    //GOAL
    goal_popup goal(.x(x), .y(y), .CLK_25MHz(CLK_25MHz), .CLK_D(CLK_D), .team(team), .oled_data(oled_data_goal));
    
    //WINNER
    winner_popup winner(.x(x), .y(y), .CLK_25MHz(CLK_25MHz), .CLK_D(CLK_D), .team(team), .oled_data(oled_data_winner));
    keeper_reset keeps (clock, x6, y6 + 1, x7, y7 + 1 , x_ball, y_ball, reset_keeper_status);
   
    //Score board
    reg [3:0] team_a = 0; //left side
    reg [3:0] team_b = 0; //right side
    
    reg [6:0] counter = 0;
    always @ (posedge hz250clk) begin
  counter = (counter == 4) ? 1 : counter + 1;
    end
    wire team_a_scored;
    wire team_b_scored;
    reg team_b_has_scored = 0;
    reg team_a_has_scored = 0;
    score_goal goal_scored(x_ball, y_ball, x, y, team_a_scored, team_b_scored);    
    
    // INITIAL POSITION    
    initial begin
        x0 = 30; y0 = 13; x1 = 20; y1 = 31; x2 = 37; y2 = 44;
        x3 = 66; y3 = 17; x4 = 76; y4 = 29; x5 = 66; y5 = 40; 
        x6 = 3; y6 = 31; x7 = 93; y7 = 31; 
    end
    
    //POSSESSION 
    
    wire a_possess = 
(x0 + 2 == x_ball &&  y_ball>= y0-1 && y_ball <= y0 +4) ||
(x0 + 3 == x_ball &&  y_ball>= y0-1 && y_ball <= y0 +4) ||
(x0 + 4 == x_ball &&  y_ball>= y0-1 && y_ball <= y0 +4);

    wire b_possess =    
(x1 + 2 == x_ball &&  y_ball>= y1-1 && y_ball <= y1 +4) || 
(x1 + 3 == x_ball &&  y_ball>= y1-1 && y_ball <= y1 +4) || 
(x1 + 4 == x_ball &&  y_ball>= y1-1 && y_ball <= y1 +4);  
        
    wire c_possess =   
(x2 + 2 == x_ball &&  y_ball>= y2-1 && y_ball <= y2 +4) || 
(x2 + 3 == x_ball &&  y_ball>= y2-1 && y_ball <= y2 +4) || 
(x2 + 4 == x_ball &&  y_ball>= y2-1 && y_ball <= y2 +4);   
        
    wire d_possess = 
 (x3 - 4 == x_ball &&  y_ball>= y3-1 && y_ball <= y3 +4) ||   
 (x3 -3 == x_ball &&  y_ball>= y3-1 && y_ball <= y3 +4) ||       
 (x3 -5 == x_ball &&  y_ball>= y3-1 && y_ball <= y3 +4);         

    
    wire e_possess =
(x4 - 4 == x_ball &&  y_ball>= y4-1 && y_ball <= y4 +4) || 
(x4 -3 == x_ball &&  y_ball>= y4-1 && y_ball <= y4 +4) ||  
(x4 -5 == x_ball &&  y_ball>= y4-1 && y_ball <= y4 +4);    
  
        
     wire f_possess =   
(x5 - 4 == x_ball &&  y_ball>= y5-1 && y_ball <= y5 +4) || 
(x5 -3 == x_ball &&  y_ball>= y5-1 && y_ball <= y5 +4) ||  
(x5 -5 == x_ball &&  y_ball>= y5-1 && y_ball <= y5 +4);    
        
       
    always @ (posedge CLK_25MHz) begin
        if (team_a_scored && sw[8]) begin
            team_a_has_scored = 1;
            team_b <= team_b + 1;
            team = 1;
        end
        if (team_b_scored && sw[8]) begin
            team_b_has_scored = 1;
            team_a <= team_a + 1;
            team = 0;
        end
        //Winning condition, first to score 3 goals
        if (team_b == 3) begin
            //team a wins
            team = 1;
        end
        if (team_a == 3) begin
            //team b wins
            team = 0;
        end
        
        //Scoreboard
        //Team B Score
        if (counter == 1) begin
            if (team_b == 0) begin
                an <= 4'b1110;
                seg <= 7'b1000000; 
            end
            if (team_b == 1) begin
                an <= 4'b1110;
                seg <= 7'b1111001;
            end
            if (team_b == 2) begin
                an <= 4'b1110;
                seg <= 7'b0100100;
            end
            if (team_b == 3) begin
                an <= 4'b1110;
                seg <= 7'b0110000;
            end
        end
        //dash
        if (counter == 2) begin
            an <= 4'b1101;
            seg <= 7'b0111111;
        end
        if (counter == 3) begin
            an <= 4'b1011;
            seg <= 7'b0111111;        
        end
        //Team A score
        if (counter == 4) begin
            if (team_a == 0) begin
                an <= 4'b0111;
                seg <= 7'b1000000; 
            end
            if (team_a == 1) begin
                an <= 4'b0111;
                seg <= 7'b1111001;
            end
            if (team_a == 2) begin
                an <= 4'b0111;
                seg <= 7'b0100100;
            end
            if (team_a == 3) begin
                an <= 4'b0111;
                seg <= 7'b0110000;
            end
        end              
        
        if (~sw[8]) begin
            oled_data <= oled_data_start;
            team_a_has_scored = 0;
            team_b_has_scored = 0;
        end
        else begin
            if (((team_a_has_scored || team_b_has_scored) && (x >= 20 && x <= 76 && y >= 22 && y <= 40)) || ((team_a == 3 || team_b == 3) && (x >= 20 && x <= 76 && y >= 15 && y <= 47))) begin
                oled_data <= (team_a == 3 || team_b == 3) ? oled_data_winner : oled_data_goal; 
            end          
            // RENDER BALL
            else if (x >= x_ball && x <= x_ball + 1 && y >= y_ball && y <= y_ball + 1) begin
                oled_data <= 16'b11100_000000_00111;
            end
            // RENDER PLAYER
            else if ((x >= x3 - 1 && x <= x3 + 1 && y >= y3 - 1 && y <= y3 + 1) || (x >= x3 - 2 && x <= x3 + 2 && y >= y3 + 2 && y <= y3 + 4) || (x >= x3 - 1 && x <= x3 && y >= y3 - 3 && y <= y3 - 2)) begin
                oled_data <= oled_data_player_3;
            end
            else if ((x >= x4 - 1 && x <= x4 + 1 && y >= y4 - 1 && y <= y4 + 1) || (x >= x4 - 2 && x <= x4 + 2 && y >= y4 + 2 && y <= y4 + 4) || (x >= x4 - 1 && x <= x4 && y >= y4 - 3 && y <= y4 - 2)) begin
                oled_data <= oled_data_player_4;
            end
            else if ((x >= x5 - 1 && x <= x5 + 1 && y >= y5 - 1 && y <= y5 + 1) || (x >= x5 - 2 && x <= x5 + 2 && y >= y5 + 2 && y <= y5 + 4) || (x >= x5 - 1 && x <= x5 && y >= y5 - 3 && y <= y5 - 2)) begin
                oled_data <= oled_data_player_5;
            end
            
            else if ((x >= x0 - 1 && x <= x0 + 1 && y >= y0 - 1 && y <= y0 + 1) || (x >= x0 - 2 && x <= x0 + 2 && y >= y0 + 2 && y <= y0 + 4) || (x >= x0 && x <= x0 + 1 && y >= y0 - 3 && y <= y0 - 2)) begin
                oled_data <= oled_data_player_0;
            end 
            else if ((x >= x1 - 1 && x <= x1 + 1 && y >= y1 - 1 && y <= y1 + 1) || (x >= x1 - 2 && x <= x1 + 2 && y >= y1 + 2 && y <= y1 + 4) || (x >= x1 && x <= x1 + 1 && y >= y1 - 3 && y <= y1 - 2)) begin
                oled_data <= oled_data_player_1;
            end  
            else if ((x >= x2 - 1 && x <= x2 + 1 && y >= y2 - 1 && y <= y2 + 1) || (x >= x2 - 2 && x <= x2 + 2 && y >= y2 + 2 && y <= y2 + 4) || (x >= x2 && x <= x2 + 1 && y >= y2 - 3 && y <= y2 - 2)) begin
                oled_data <= oled_data_player_2;
            end
            
            else if ((x >= x6 - 1 && x <= x6 + 1 && y >= y6 - 1 && y <= y6 + 1) || (x >= x6 - 2 && x <= x6 + 2 && y >= y6 + 2 && y <= y6 + 4) || (x >= x6 && x <= x6 + 1 && y >= y6 - 3 && y <= y6 - 2)) begin
                oled_data <= oled_data_keeper_red;
            end  
            else if ((x >= x7 - 1 && x <= x7 + 1 && y >= y7 - 1 && y <= y7 + 1) || (x >= x7 - 2 && x <= x7 + 2 && y >= y7 + 2 && y <= y7 + 4) || (x >= x7 - 1 && x <= x7 && y >= y7 - 3 && y <= y7 - 2)) begin
                oled_data <= oled_data_keeper_blue;
            end
            
            else begin
                oled_data <= oled_data_field;
            end    
        end
    end    
    
    always @ (posedge clock) begin       
        led[5:0] = possession;
        if (a_possess) begin
            possession <= 6'b000001;
        end
        else if (b_possess) begin
            possession <= 6'b000010;
        end
        else if (c_possess) begin
            possession <= 6'b000100;
        end
        else if (d_possess) begin
            possession <= 6'b001000;
        end
        else if (e_possess) begin
            possession <= 6'b010000;
        end
        else if (f_possess) begin
            possession <= 6'b100000;
        end 
        else begin
            possession <= possession;
        end
    
        // SWITCH CONTROLLED PLAYER
        player1 <= sw[1] ? 0 : sw[2] ? 1 : sw[3] ? 2 : sw[0] ? player1_auto : player1;
        player2 <= sw_2[1] ? 0 : sw_2[2] ? 1 : sw_2[3] ? 2 : sw_2[0] ? player2_auto : player2;
        
        // CONTROL OF PLAYER 1
        if (btnC) begin
            direction1_x = 0;
            direction1_y = 0;
        end
        if (btnU) begin
            direction1_y = 1;
        end
        else if (btnD) begin
            direction1_y = 2;
        end
        else begin
            direction1_y = 0;
        end
        if (btnR) begin
            direction1_x = 1;
        end
        else if (btnL) begin
            direction1_x = 2;
        end
        else begin
            direction1_x = 0;
        end
    
        // CONTROL OF PLAYER 2
        if (btnC2) begin
            direction2_x = 0;
            direction2_y = 0;
        end
        if (btnU2) begin
            direction2_y = 1;
        end
        else if (btnD2) begin
            direction2_y = 2;
        end
        else begin
            direction2_y = 0;
        end
        if (btnR2) begin
            direction2_x = 1;
        end
        else if (btnL2) begin
            direction2_x = 2;
        end
        else begin
            direction2_x = 0;
        end
        
        x0 <= ~reset ? x0_1 : 30;
        y0 <= ~reset ? y0_1 : 13;
        x1 <= ~reset ? x1_1 : 20;
        y1 <= ~reset ? y1_1 : 31;
        x2 <= ~reset ? x2_1 : 37;
        y2 <= ~reset ? y2_1 : 44;
        x3 <= ~reset ? x3_1 : 66;
        y3 <= ~reset ? y3_1 : 17; 
        x4 <= ~reset ? x4_1 : 76;
        y4 <= ~reset ? y4_1 : 29;
        x5 <= ~reset ? x5_1 : 66;
        y5 <= ~reset ? y5_1 : 40; 
        
        x6 <= (~reset) ? x6_1 : 3;
        y6 <= (~reset) ? y6_1 : 31;
        x7 <= (~reset) ? x7_1 : 93;
        y7 <= (~reset) ? y7_1 : 31;                                                                                      
    end
    
endmodule