`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/26/2023 12:00:55 PM
// Design Name: 
// Module Name: ball
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


module ball(input reset, CLK_25MHz, btnL, btnR, btnU, btnD, leftmouse,rightmouse,middlemouse,CLK_6p25MHz,
    [12:0]pixel_index, input [6:0]x0, y0, x1, y1, x2, y2, x3, y3, x4, y4, x5, y5, input [1:0] player1, player2,output reg [6:0] inc_x = 47, inc_y = 30, 
    input  btnL2, btnR2, btnU2, btnD2, leftmouse2, rightmouse2, middlemouse2, [1:0]resetkeeperstatus, input [5:0] possession );
    //mouse
    reg leftmousestate =0;
    reg rightmousestate =0;
    reg middlemousestate=0;
    
    reg leftmousestate2 =0;
    reg rightmousestate2 =0;
    reg middlemousestate2=0;
    //coordinate
    wire [6:0]x;
    wire [5:0]y;
    assign x = pixel_index%96;
    assign y = pixel_index/96;
    //ball
    reg [2:0]move = 3'b000;
    reg [2:0]move2 = 3'b000;
    //movement of ball
    reg [31:0]left =0;
    reg [31:0]right = 0;
    
    reg [31:0]left2 =0;
    reg [31:0]right2 = 0;
    //dribbling the ball
    reg [31:0]counter=0; //right
    reg [31:0]slowcounter=0;
    reg touch = 0;
    reg [31:0]counterl=0;//left
    reg [31:0] slowcounterl=0;
    reg touchl =0;
    
    reg [31:0]counter2=0; //right
    reg [31:0]slowcounter2=0;
    reg touch2 = 0;
    reg [31:0]counterl2=0;//left
    reg [31:0] slowcounterl2=0;
    reg touchl2 =0;
    //debounce
    reg [31:0]debounce=0;
    
    reg [31:0]debounce2=0;
    //pass & shoot
        //upon mouse click
    reg [6:0]xb, xp1click, xp2click =0;
    reg [5:0]yb, yp1click, yp2click =0;
    reg [2:0]clickstate=0;
    
    reg [6:0]xb2, xp1click2, xp2click2 =0;
    reg [5:0]yb2, yp1click2, yp2click2 =0;
    reg [2:0]clickstate2=0;
    
    reg [31:0]deltax = 0;
    reg [31:0]deltay = 0;
    reg [31:0]step=0;
    reg [31:0]stepx=0;
    reg [31:0]stepy=0;
    reg hold=0;
    
    reg [31:0]deltax2 = 0;
    reg [31:0]deltay2 = 0;
    reg [31:0]step2=0;
    reg [31:0]stepx2=0;
    reg [31:0]stepy2=0;
    reg hold2=0;
    
    reg [31:0]passcounter=0;
    reg [3:0] fractionbits = 8;
    reg [31:0]intermediate =0;
    
    reg [31:0]passcounter2=0;
    reg [31:0]intermediate2 =0;
    
    reg [5:0]goaltop = 25;
    reg [5:0]goalmid = 30;
    reg [5:0]goalbot = 35;
    reg [6:0]xgoal0 = 94;
    reg [6:0]xgoal1 = 0;
    reg [2:0]state=0;
    reg [5:0]ygoal;
    //6 players
    reg [6:0] xp, xp1, xp2, yp, yp1, yp2;
    reg [6:0] xpp2, xp1p2, xp2p2, ypp2, yp1p2, yp2p2;
    reg [6:0]xgoal;
    reg [6:0]xgoalp2;
   
    always @ (*) begin
        if (player1 == 2'b00) begin //player 0 controls the ball
            xp = x0;
            yp = y0;
            xp1 = x1;
            yp1 = y1;
            xp2 = x2;
            yp2 = y2;
            xgoal = xgoal0;
            
        end
        else if (player1 == 2'b01) begin //player 1 controls the ball
            xp = x1;
            yp = y1;
            xp1 = x0;
            yp1 = y0;
            xp2 = x2;
            yp2 = y2;
            xgoal = xgoal0;
        end
        else if (player1 == 2'b10) begin //player 2 controls the ball
            xp = x2;
            yp = y2;
            xp1 = x0;
            yp1 = y0;
            xp2 = x1;
            yp2 = y1;
            xgoal = xgoal0;
        end
        if (player2 == 2'b00)begin
            xpp2 = x3;
            ypp2 = y3;
            xp1p2 = x4;
            yp1p2 = y4;
            xp2p2 = x5;
            yp2p2 = y5;
            xgoalp2 = xgoal1;
        end
        else if (player2 == 2'b01)begin
            xpp2 = x4;
            ypp2 = y4;
            xp1p2 = x5;
            yp1p2 = y5;
            xp2p2 = x3;
            yp2p2 = y3;
            xgoalp2 = xgoal1;
        end
        else if (player2 == 2'b10)begin
            xpp2 = x5;
            ypp2 = y5;
            xp1p2 = x3;
            yp1p2 = y3;
            xp2p2 = x4;
            yp2p2 = y4;
            xgoalp2 = xgoal1;
        end
    end
        //distance of teammates upon clicking
    wire [31:0]distp1, distp2, distp3, distp4;
    assign distp1 = (xb > xp1click)?(yb > yp1click) ? ((xb-xp1click)*(xb-xp1click) + (yb-yp1click)*(yb-yp1click)):
    ((xb-xp1click)*(xb-xp1click)+(-yb+yp1click)*(-yb+yp1click)):(yb>yp1click)?((-xb+xp1click)*(-xb+xp1click) 
    + (yb-yp1click)*(yb-yp1click)):((-xb+xp1click)*(-xb+xp1click) + (-yb+yp1click)*(-yb+yp1click));
    
    assign distp2 = (xb > xp2click)?(yb > yp2click) ? ((xb-xp2click)*(xb-xp2click) + (yb-yp2click)*(yb-yp2click)):
        ((xb-xp2click)*(xb-xp2click)+(-yb+yp2click)*(-yb+yp2click)):(yb>yp2click)?((-xb+xp2click)*(-xb+xp2click) 
        + (yb-yp2click)*(yb-yp2click)):((-xb+xp2click)*(-xb+xp2click) + (-yb+yp2click)*(-yb+yp2click));
        
    assign distp3 = (xb2 > xp1click2)?(yb2 > yp1click2) ? ((xb2-xp1click2)*(xb2-xp1click2) + (yb2-yp1click2)*(yb2-yp1click2)):
        ((xb2-xp1click2)*(xb2-xp1click2)+(-yb2+yp1click2)*(-yb2+yp1click2)):(yb2>yp1click2)?((-xb2+xp1click2)*(-xb2+xp1click2) 
        + (yb2-yp1click2)*(yb2-yp1click2)):((-xb2+xp1click2)*(-xb2+xp1click2) + (-yb2+yp1click2)*(-yb2+yp1click2));
    
    assign distp4 = (xb2 > xp2click2)?(yb2 > yp2click2) ? ((xb2-xp2click2)*(xb2-xp2click2) + (yb2-yp2click2)*(yb2-yp2click2)):
            ((xb2-xp2click2)*(xb2-xp2click2)+(-yb2+yp2click2)*(-yb2+yp2click2)):(yb2>yp2click2)?((-xb2+xp2click2)*(-xb2+xp2click2) 
            + (yb2-yp2click2)*(yb2-yp2click2)):((-xb2+xp2click2)*(-xb2+xp2click2) + (-yb2+yp2click2)*(-yb2+yp2click2));
    //state of shooting for "randomness"
    always @(posedge CLK_6p25MHz)begin
        state<=(state==5)?0:state+1;
    end
    always @(posedge CLK_25MHz)begin
        //reset
        if (reset) begin
            inc_x = 47;
            inc_y = 30;
            leftmousestate =0;
            rightmousestate =0;
            middlemousestate =0;
            leftmousestate2 =0;
            middlemousestate2 =0;
            rightmousestate2 =0;
        end
        else begin
        //debounce
        if (btnL||btnR||btnU||btnD)begin
            debounce <= (debounce==250_000)?debounce:debounce+1;end
        if (btnL2||btnR2||btnU2||btnD2)begin
            debounce2 <= (debounce2==250_000)?debounce2:debounce2+1;end
        //stop
        if (move==3'b000)begin
            left <=0;
            right<=0;
            end
        if (move2==3'b000)begin
            left2 <=0;
            right2<=0;
            end
        //right 001    //purposely choose inside player to have dribbling effect
        if (xp == inc_x-1 && btnR && (yp == inc_y-4 || yp ==inc_y-5 || yp == inc_y-6 || yp ==inc_y-7||yp==inc_y-8)
            &&debounce==250000 && leftmousestate==0 && rightmousestate==0&&middlemousestate==0)begin 
            move <= 3'b001;                         //position of ball
            touch <=1;
            inc_x <= (inc_x>=93)?93:xp + 3;
            //reset all counters from other directions
            counterl<=0;slowcounterl<=0; 
            left <=0;debounce<=0;
            end
//        if (xpp2 == inc_x-1 && btnR2 && (ypp2 == inc_y-4 || ypp2 ==inc_y-5 || ypp2 == inc_y-6 || ypp2 ==inc_y-7 ||ypp2 ==inc_y-8)
//            &&debounce2==250000 && leftmousestate2==0 && rightmousestate2==0&&middlemousestate2==0)begin 
//            move2 <= 3'b001;                         //position of ball
//            touch2 <=1;
//            inc_x <= (inc_x>=93)?93:xpp2 + 3;
//            //reset all counters from other directions
//            counterl2<=0;slowcounterl2<=0; 
//            left2 <=0;debounce2<=0;
//            end

        if (slowcounter == 1)begin
            counter <=0;
            slowcounter <=0;
            right <=0;
            end 
//        if (slowcounter2 == 1)begin
//            counter2 <=0;
//            slowcounter2 <=0;
//            right2 <=0;
//            end 
        if (move==3'b001 && touch==1)begin //right
            left <=0; 
            right <= right + 1;
            counter <= (counter==30_000_000)?counter:counter +1;
            if (counter < 10_000_000 && right == 1200000 && inc_x<93)begin//ball goes fast initially
                right <=0;
                inc_x<=inc_x+1;end
            if (counter >= 10_000_000 && right == 1800000 && inc_x<93)begin //ball becomes slower gradually
                 right <= 0;
                 inc_x <= inc_x+1;
                 slowcounter<=(slowcounter==1)?slowcounter:slowcounter+1;end
            if (counter==30_000_000||inc_x==93||resetkeeperstatus==2'b01||resetkeeperstatus==2'b10)begin 
                 move <= 3'b000; counter <=0; end
        end
//        if (move2==3'b001 && touch2==1)begin //right
//            left2 <=0; 
//            right2 <= right2 + 1;
//            counter2 <= (counter2==40_000_000)?counter2:counter2 +1;
//            if (counter2 < 10000_000 && right2 == 1400_000 && inc_x<93)begin//ball goes fast initially
//                right2 <=0;
//                inc_x<=inc_x+1;end
//            if (counter2 >= 10000_000 && right2 == 1_800_000 && inc_x<93)begin //ball becomes slower gradually
//                 right2 <= 0;
//                 inc_x <= inc_x+1;
//                 slowcounter2<=(slowcounter2==1)?slowcounter2:slowcounter2+1;end
//            if (counter2==40_000_000||inc_x==93)begin 
//                 move2 <= 3'b000; counter2 <=0; end
//        end
        //left 100     
//        if (xp == inc_x && btnL && (yp == inc_y-4 || yp ==inc_y-5 || yp == inc_y-6 || yp ==inc_y-7||yp==inc_y-8)
//            &&debounce==250000 && leftmousestate ==0 && rightmousestate==0&&middlemousestate==0)begin 
//            move <= 3'b100;
//            touchl <=1;
//            inc_x <= (inc_x<=2)?2:xp - 2;
//            counter<=0;slowcounter<=0;
//            right <=0; debounce<=0;
//            end

            
        
        if (xpp2 == inc_x && btnL2 && (ypp2 == inc_y-4 || ypp2 ==inc_y-5 || ypp2 == inc_y-6 || ypp2 ==inc_y-7||ypp2==inc_y-8)
            &&debounce2==250000 && leftmousestate2 ==0 && rightmousestate2==0&&middlemousestate2==0)begin 
            move2 <= 3'b100;
            touchl2 <=1;
            inc_x <= (inc_x<=2)?2:xpp2 - 2;
            counter2<=0;slowcounter2<=0;
            right2 <=0; debounce2<=0;
            end
//        if (slowcounterl == 1)begin
//            counterl <=0;
//            slowcounterl <=0;
//            left <=0;
//            end 
        if (slowcounterl2 == 1)begin
            counterl2 <=0;
            slowcounterl2 <=0;
            left2 <=0;
            end 
//        if (move==3'b100 && touchl==1)begin 
//            right <=0; 
//            left <= left + 1;
//            counterl <= (counterl==40_000_000)?counterl:counterl +1;
//            if (counterl < 10000_000 && left == 1400_000 && inc_x>0)begin
//                left <=0;
//                inc_x<=inc_x-1;end
//            if (counterl >= 10000_000 && left == 1_800_000 && inc_x>0)begin 
//                left <= 0;
//                inc_x <= inc_x-1;
//                slowcounterl<=(slowcounterl==1)?slowcounterl:slowcounterl+1;end
//            if (counterl==40_000_000||inc_x==0)begin 
//                move <= 3'b000; counterl <=0; end
//        end
        if (move2==3'b100 && touchl2==1)begin 
              right2 <=0; 
              left2 <= left2 + 1;
              counterl2 <= (counterl2==30_000_000)?counterl2:counterl2 +1;
              if (counterl2 < 10000_000 && left2 == 1200_000 && inc_x>0)begin
                  left2 <=0;
                  inc_x<=inc_x-1;end
              if (counterl2 >= 10000_000 && left2 == 1_800_000 && inc_x>0)begin 
                  left2 <= 0;
                  inc_x <= inc_x-1;
                  slowcounterl2<=(slowcounterl2==1)?slowcounterl2:slowcounterl2+1;end
              if (counterl2==30_000_000||inc_x==0||resetkeeperstatus==2'b01||resetkeeperstatus==2'b10)begin 
                  move2 <= 3'b000; counterl2 <=0; end
          end
        //up and down 111
        if ((xp==inc_x-3||xp==inc_x+2||xp==inc_x+1||xp==inc_x||xp==inc_x-1||xp==inc_x-2||xp==inc_x-4&&btnL) && (btnU||btnD||btnL) && leftmousestate==0 && rightmousestate==0 &&middlemousestate==0
            &&(yp == inc_y-4 || yp ==inc_y-5 || yp == inc_y-6 || yp ==inc_y-7||yp==inc_y-8)&&debounce==250000)begin 
            move <= 3'b111;
            inc_x <= xp+3;
            inc_y <= yp +6; 
            counter<=0;slowcounter<=0;
            counterl<=0;slowcounterl<=0;
            right <=0; left<=0; debounce<=0;
            end
        if ((xpp2==inc_x-3||xpp2==inc_x+2||xpp2==inc_x+1||xpp2==inc_x||xpp2==inc_x-1||xpp2==inc_x-2||xpp2==inc_x+4&&btnR2) && (btnU2||btnD2||btnR2) && leftmousestate2==0 && rightmousestate2==0 &&middlemousestate2==0
            &&(ypp2 == inc_y-4 || ypp2 ==inc_y-5 || ypp2 == inc_y-6 || ypp2 ==inc_y-7||ypp2 == inc_y-8)&&debounce2==250000)begin 
            move2 <= 3'b111;
            inc_x <= xpp2-2;
            inc_y <= ypp2 +6; 
            counter2<=0;slowcounter2<=0;
            counterl2<=0;slowcounterl2<=0;
            right2 <=0; left2<=0; debounce2<=0;
            end
        //up right 011
        if ((xp==inc_x-3) && (btnU && btnR) && leftmousestate ==0 && rightmousestate==0&&middlemousestate==0&&
            (yp == inc_y-4 || yp ==inc_y-5 || yp == inc_y-6 || yp ==inc_y-7)&&debounce==250000)begin
            move <= 3'b011;
            inc_x <= (inc_x>=93)?93:xp + 4;
            inc_y <= (inc_y<=8)?8:yp+4;
            //reset all counters from other directions
            counterl<=0;slowcounterl<=0; 
            counter<=0;slowcounter<=0;debounce<=0;
            left<=0;
            end
         if ((xpp2==inc_x-3) && (btnU2 && btnR2) && leftmousestate2 ==0 && rightmousestate2==0&&middlemousestate2==0&&
           (ypp2 == inc_y-4 || ypp2 ==inc_y-5 || ypp2 == inc_y-6 || ypp2 ==inc_y-7)&&debounce2==250000)begin
               move2 <= 3'b011;
               inc_x <= (inc_x>=93)?93:xpp2 + 4;
               inc_y <= (inc_y<=8)?8:ypp2+4;
               //reset all counters from other directions
               counterl2<=0;slowcounterl2<=0; 
               counter2<=0;slowcounter2<=0;debounce2<=0;
               left2<=0;
               end
        //down right 010
        if ((xp==inc_x-3) && (btnD && btnR) && leftmousestate==0&&rightmousestate==0&&middlemousestate==0
            && (yp == inc_y-4 || yp ==inc_y-5 || yp == inc_y-6 || yp ==inc_y-7)&&debounce==250000)begin 
            move <= 3'b010;
            inc_x <= (inc_x>=93)?93:xp + 4;
            inc_y <= (inc_y>=62)?62:yp+6;
            counter<=0;slowcounter<=0;
            counterl<=0;slowcounterl<=0;
            left<=0;debounce<=0;
            end
        if ((xpp2==inc_x-3) && (btnD2 && btnR2) && leftmousestate2==0&&rightmousestate2==0&&middlemousestate2==0
            && (ypp2 == inc_y-4 || ypp2 ==inc_y-5 || ypp2 == inc_y-6 || ypp2 ==inc_y-7)&&debounce2==250000)begin 
            move2 <= 3'b010;
            inc_x <= (inc_x>=93)?93:xpp2 + 4;
            inc_y <= (inc_y>=62)?62:ypp2+6;
            counter2<=0;slowcounter2<=0;
            counterl2<=0;slowcounterl2<=0;
            left2<=0;debounce2<=0;
            end
        //down left 101
        if ((xp==inc_x+2) && (btnD && btnL) && leftmousestate==0&&rightmousestate==0&&middlemousestate==0
            && (yp == inc_y-4 || yp ==inc_y-5 || yp == inc_y-6 || yp ==inc_y-7)&&debounce==250000)begin 
            move <= 3'b101;
            inc_x <= (inc_x<=2)?2:xp -3;
            inc_y <= (inc_y>=62)?62:yp+6;
            counter<=0;slowcounter<=0;
            counterl<=0;slowcounterl<=0;
            right<=0;debounce<=0;
            end
        if ((xpp2==inc_x+2) && (btnD2 && btnL2) && leftmousestate2==0&&rightmousestate2==0&&middlemousestate2==0
            && (ypp2 == inc_y-4 || ypp2 ==inc_y-5 || ypp2 == inc_y-6 || ypp2 ==inc_y-7)&&debounce2==250000)begin 
            move2 <= 3'b101;
            inc_x <= (inc_x<=2)?2:xpp2 -3;
            inc_y <= (inc_y>=62)?62:ypp2+6;
            counter2<=0;slowcounter2<=0;
            counterl2<=0;slowcounterl2<=0;
            right2<=0;debounce2<=0;
            end
        //up left 110
        if ((xp==inc_x+2) && (btnU && btnL) && leftmousestate==0&&rightmousestate==0&&middlemousestate==0
            && (yp == inc_y-4 || yp ==inc_y-5 || yp == inc_y-6 || yp ==inc_y-7)&&debounce==250000)begin 
            move <= 3'b110;
            inc_x <= (inc_x<=2)?2:xp -3;
            inc_y <= (inc_y<=8)?8:yp+4;
            counter<=0;slowcounter<=0;
            counterl<=0;slowcounterl<=0;
            right<=0;debounce<=0;
            end
        if ((xpp2==inc_x+2) && (btnU2 && btnL2) && leftmousestate2==0&&rightmousestate2==0&&middlemousestate2==0
            && (ypp2 == inc_y-4 || ypp2 ==inc_y-5 || ypp2 == inc_y-6 || ypp2 ==inc_y-7)&&debounce2==250000)begin 
            move2 <= 3'b110;
            inc_x <= (inc_x<=2)?2:xpp2 -3;
            inc_y <= (inc_y<=8)?8:ypp2+4;
            counter2<=0;slowcounter2<=0;
            counterl2<=0;slowcounterl2<=0;
            right2<=0;debounce2<=0;
            end
        //passing
        if ((xp==inc_x-3||xp==inc_x+2||xp==inc_x+1||xp==inc_x||xp==inc_x-1||xp==inc_x-2) && (yp == inc_y-4 || yp ==inc_y-5 || yp == inc_y-6 || yp ==inc_y-7))begin
            hold <=1;end
        if ((xpp2==inc_x-3||xpp2==inc_x+2||xpp2==inc_x+1||xpp2==inc_x||xpp2==inc_x-1||xpp2==inc_x-2) && (ypp2 == inc_y-4 || ypp2 ==inc_y-5 || ypp2 == inc_y-6 || ypp2 ==inc_y-7))begin
            hold2 <=1;end
        if (leftmouse && hold==1)begin
            leftmousestate<=1; 
            xb <= inc_x; 
            yb <= inc_y; 
            xp1click <= xp1+1; 
            yp1click <= yp1+3; 
            xp2click <= xp2+1;
            yp2click <= yp2+3;end //target
        if (leftmouse2 && hold2==1)begin
            leftmousestate2<=1; 
            xb2 <= inc_x; 
            yb2 <= inc_y; 
            xp1click2 <= xp1p2+1; 
            yp1click2 <= yp1p2+3; 
            xp2click2 <= xp2p2+1;
            yp2click2 <= yp2p2+3;end //target
        if (middlemouse && hold==1)begin
            middlemousestate<=1;
            xb <= inc_x;
            yb <= inc_y;
            xp1click <= xp1+1;
            yp1click <= yp1+3;
            xp2click <= xp2+1;
            yp2click <= yp2+3;end
         if (middlemouse2 && hold2==1)begin
               middlemousestate2<=1;
               xb2 <= inc_x;
               yb2 <= inc_y;
               xp1click2 <= xp1p2+1;
               yp1click2 <= yp1p2+3;
               xp2click2 <= xp2p2+1;
               yp2click2 <= yp2p2+3;end
        //short pass
        if (hold==1 && leftmousestate==1 && distp1<=distp2)begin
            deltax <= (xp1click>xb)?(xp1click-xb):(xb-xp1click); 
            deltay <= (yp1click>yb)?(yp1click-yb):(yb-yp1click);
            step<=(deltax>deltay)?deltax:deltay;
            stepx<=(deltax==step)?1:(deltax<<fractionbits)/step;
            stepy<=(deltay==step)?1:(deltay<<fractionbits)/step;
            passcounter <=passcounter+1;
            move <=3'b000;
            if (passcounter==750_000 && xp1click != inc_x +2 && yp1click != inc_y - 4  && (resetkeeperstatus != 2'b01||resetkeeperstatus !=2'b10) )begin
                passcounter <=0;
                if (stepx==1)begin
                    inc_x <= (xp1click>xb)?inc_x+1:inc_x-1;end
                if (stepy==1)begin
                    inc_y <= (yp1click>yb)?inc_y+1:inc_y-1;end
                if (stepx != 1)begin
                    intermediate <= intermediate + stepx;
                    if (intermediate >= (1<<fractionbits))begin
                        inc_x <= (xp1click>xb)?inc_x +1:inc_x-1;
                        intermediate <= intermediate - (1<<fractionbits);end end 
                if (stepy != 1)begin
                    intermediate <= intermediate + stepy;
                    if (intermediate >= (1<<fractionbits))begin
                        inc_y <= (yp1click>yb)?inc_y +1:inc_y-1;
                        intermediate <= intermediate - (1<<fractionbits); end end
            end
            if (inc_x == xp1click-2  ||inc_y == yp1click+4||resetkeeperstatus==2'b01||resetkeeperstatus==2'b10 ||possession == 6'b001000||possession==6'b010000||possession==6'b100000)begin 
                leftmousestate <=0; hold <=0;passcounter<=0;intermediate<=0;
                end
            end
       
       if (hold2==1 && leftmousestate2==1 && distp3<=distp4)begin
            deltax2 <= (xp1click2>xb2)?(xp1click2-xb2):(xb2-xp1click2); 
            deltay2 <= (yp1click2>yb2)?(yp1click2-yb2):(yb2-yp1click2);
            step2<=(deltax2>deltay2)?deltax2:deltay2;
            stepx2<=(deltax2==step2)?1:(deltax2<<fractionbits)/step2;
            stepy2<=(deltay2==step2)?1:(deltay2<<fractionbits)/step2;
            passcounter2 <=passcounter2+1;
            move2 <=3'b000;
            if (passcounter2==750_000 && xp1click2 != inc_x +2 && yp1click2 != inc_y - 4  && (resetkeeperstatus != 2'b01||resetkeeperstatus !=2'b10) )begin
                passcounter2 <=0;
                if (stepx2==1)begin
                    inc_x <= (xp1click2>xb2)?inc_x+1:inc_x-1;end
                if (stepy2==1)begin
                    inc_y <= (yp1click2>yb2)?inc_y+1:inc_y-1;end
                if (stepx2 != 1)begin
                    intermediate2 <= intermediate2 + stepx2;
                    if (intermediate2 >= (1<<fractionbits))begin
                        inc_x <= (xp1click2>xb2)?inc_x +1:inc_x-1;
                        intermediate2 <= intermediate2 - (1<<fractionbits);end end 
                if (stepy2 != 1)begin
                    intermediate2 <= intermediate2 + stepy2;
                    if (intermediate2 >= (1<<fractionbits))begin
                        inc_y <= (yp1click2>yb2)?inc_y +1:inc_y-1;
                        intermediate2 <= intermediate2 - (1<<fractionbits); end end
            end         //||possession == 6'b000001||possession==6'b000010||possession==6'b000100
            if (inc_x == xp1click2-2  ||inc_y == yp1click2+4 ||resetkeeperstatus==2'b01||resetkeeperstatus==2'b10 || possession == 6'b000001 || possession == 6'b000010 || possession == 6'b000100)begin 
                leftmousestate2 <=0; hold2 <=0;passcounter2<=0;intermediate2<=0;
                end
            end
       if (hold==1 && leftmousestate==1 && distp1>distp2)begin
           deltax <= (xp2click>xb)?(xp2click-xb):(xb-xp2click); 
           deltay <= (yp2click>yb)?(yp2click-yb):(yb-yp2click);
           step<=(deltax>deltay)?deltax:deltay;
           stepx<=(deltax==step)?1:(deltax<<fractionbits)/step;
           stepy<=(deltay==step)?1:(deltay<<fractionbits)/step;
           passcounter <=passcounter+1;
           move<=3'b000;
           if (passcounter==750_000 && xp2click != inc_x +2 && yp2click != inc_y - 4  && (resetkeeperstatus != 2'b01||resetkeeperstatus !=2'b10) )begin
                passcounter <=0;
                if (stepx==1)begin
                     inc_x <= (xp2click>xb)?inc_x+1:inc_x-1;end
                if (stepy==1)begin
                     inc_y <= (yp2click>yb)?inc_y+1:inc_y-1;end
                if (stepx != 1)begin
                     intermediate <= intermediate + stepx;
                     if (intermediate >= (1<<fractionbits))begin
                        inc_x <= (xp2click>xb)?inc_x +1:inc_x-1;
                        intermediate <= intermediate - (1<<fractionbits);end end 
                if (stepy != 1)begin
                     intermediate <= intermediate + stepy;
                     if (intermediate >= (1<<fractionbits))begin
                         inc_y <= (yp2click>yb)?inc_y +1:inc_y-1;
                         intermediate <= intermediate - (1<<fractionbits); end end
            end
            if (inc_x == xp2click-2  ||inc_y == yp2click+4 ||resetkeeperstatus==2'b01||resetkeeperstatus==2'b10||possession == 6'b001000||possession==6'b010000||possession==6'b100000)begin 
                leftmousestate <=0; hold <=0;passcounter<=0;intermediate<=0;
                end
           end
      if (hold2==1 && leftmousestate2==1 && distp3>distp4)begin
          deltax2 <= (xp2click2>xb2)?(xp2click2-xb2):(xb2-xp2click2); 
          deltay2 <= (yp2click2>yb2)?(yp2click2-yb2):(yb2-yp2click2);
          step2<=(deltax2>deltay2)?deltax2:deltay2;
          stepx2<=(deltax2==step2)?1:(deltax2<<fractionbits)/step2;
          stepy2<=(deltay2==step2)?1:(deltay2<<fractionbits)/step2;
          passcounter2 <=passcounter2+1;
          move2<=3'b000;
          if (passcounter2==750_000 && xp2click2 != inc_x +2 && yp2click2 != inc_y - 4  && (resetkeeperstatus != 2'b01||resetkeeperstatus !=2'b10) )begin
               passcounter2 <=0;
               if (stepx2==1)begin
                    inc_x <= (xp2click2>xb2)?inc_x+1:inc_x-1;end
               if (stepy2==1)begin
                    inc_y <= (yp2click2>yb2)?inc_y+1:inc_y-1;end
               if (stepx2 != 1)begin
                    intermediate2 <= intermediate2 + stepx2;
                    if (intermediate2 >= (1<<fractionbits))begin
                       inc_x <= (xp2click2>xb2)?inc_x +1:inc_x-1;
                       intermediate2 <= intermediate2 - (1<<fractionbits);end end 
               if (stepy2 != 1)begin
                    intermediate2 <= intermediate2 + stepy2;
                    if (intermediate2 >= (1<<fractionbits))begin
                        inc_y <= (yp2click2>yb2)?inc_y +1:inc_y-1;
                        intermediate2 <= intermediate2 - (1<<fractionbits); end end
           end
           if (inc_x == xp2click2-2  ||inc_y == yp2click2+4 ||resetkeeperstatus==2'b01||resetkeeperstatus==2'b10 || possession == 6'b000001 || possession == 6'b000010 || possession == 6'b000100)begin 
               leftmousestate2 <=0; hold2 <=0;passcounter2<=0;intermediate2<=0;
               end
          end
      //long pass
      if (hold==1 && middlemousestate==1 && distp2>=distp1)begin
            deltax <= (xp2click>xb)?(xp2click-xb):(xb-xp2click); 
            deltay <= (yp2click>yb)?(yp2click-yb):(yb-yp2click);
            step<=(deltax>deltay)?deltax:deltay;
            stepx<=(deltax==step)?1:(deltax<<fractionbits)/step;
            stepy<=(deltay==step)?1:(deltay<<fractionbits)/step;
            passcounter <=passcounter+1;
            move<=3'b000;
            if (passcounter==750_000 && xp2click != inc_x +2 && yp2click != inc_y - 4  && (resetkeeperstatus != 2'b01||resetkeeperstatus !=2'b10) )begin
                passcounter <=0;
                if (stepx==1)begin
                    inc_x <= (xp2click>xb)?inc_x+1:inc_x-1;end
                if (stepy==1)begin
                    inc_y <= (yp2click>yb)?inc_y+1:inc_y-1;end
                if (stepx != 1)begin
                    intermediate <= intermediate + stepx;
                    if (intermediate >= (1<<fractionbits))begin
                        inc_x <= (xp2click>xb)?inc_x +1:inc_x-1;
                        intermediate <= intermediate - (1<<fractionbits);end end 
                if (stepy != 1)begin
                    intermediate <= intermediate + stepy;
                    if (intermediate >= (1<<fractionbits))begin
                        inc_y <= (yp2click>yb)?inc_y +1:inc_y-1;
                        intermediate <= intermediate - (1<<fractionbits); end end
            end
            if (inc_x == xp2click-2  ||inc_y == yp2click+4 ||resetkeeperstatus==2'b01||resetkeeperstatus==2'b10||possession == 6'b001000||possession==6'b010000||possession==6'b100000)begin 
                middlemousestate <=0; hold <=0;passcounter<=0;intermediate<=0;
                end
            end
        if (hold2==1 && middlemousestate2==1 && distp4>=distp3)begin
           deltax2 <= (xp2click2>xb2)?(xp2click2-xb2):(xb2-xp2click2); 
           deltay2 <= (yp2click2>yb2)?(yp2click2-yb2):(yb2-yp2click2);
           step2<=(deltax2>deltay2)?deltax2:deltay2;
           stepx2<=(deltax2==step2)?1:(deltax2<<fractionbits)/step2;
           stepy2<=(deltay2==step2)?1:(deltay2<<fractionbits)/step2;
           passcounter2 <=passcounter2+1;
           move2<=3'b000;
           if (passcounter2==750_000 && xp2click2 != inc_x +2 && yp2click2 != inc_y - 4  && (resetkeeperstatus != 2'b01||resetkeeperstatus !=2'b10) )begin
               passcounter2 <=0;
               if (stepx2==1)begin
                   inc_x <= (xp2click2>xb2)?inc_x+1:inc_x-1;end
               if (stepy2==1)begin
                   inc_y <= (yp2click2>yb2)?inc_y+1:inc_y-1;end
               if (stepx2 != 1)begin
                   intermediate2 <= intermediate2 + stepx2;
                   if (intermediate2 >= (1<<fractionbits))begin
                       inc_x <= (xp2click2>xb2)?inc_x +1:inc_x-1;
                       intermediate2 <= intermediate2 - (1<<fractionbits);end end 
               if (stepy2 != 1)begin
                   intermediate2 <= intermediate2 + stepy2;
                   if (intermediate2 >= (1<<fractionbits))begin
                       inc_y <= (yp2click2>yb2)?inc_y +1:inc_y-1;
                       intermediate2 <= intermediate2 - (1<<fractionbits); end end
           end
           if (inc_x == xp2click2-2  ||inc_y == yp2click2+4 ||resetkeeperstatus==2'b01||resetkeeperstatus==2'b10 || possession == 6'b000001 || possession == 6'b000010 || possession == 6'b000100)begin 
               middlemousestate2 <=0; hold2 <=0;passcounter2<=0;intermediate2<=0;
               end
           end
       if (hold==1 && middlemousestate==1 && distp1>distp2)begin
            deltax <= (xp1click>xb)?(xp1click-xb):(xb-xp1click); 
            deltay <= (yp1click>yb)?(yp1click-yb):(yb-yp1click);
            step<=(deltax>deltay)?deltax:deltay;
            stepx<=(deltax==step)?1:(deltax<<fractionbits)/step;
            stepy<=(deltay==step)?1:(deltay<<fractionbits)/step;
            passcounter <=passcounter+1;
            move <=3'b000;
            if (passcounter==750_000 && xp1click != inc_x +2 && yp1click != inc_y - 4  && (resetkeeperstatus != 2'b01||resetkeeperstatus !=2'b10) )begin
                passcounter <=0;
                if (stepx==1)begin
                    inc_x <= (xp1click>xb)?inc_x+1:inc_x-1;end
                if (stepy==1)begin
                    inc_y <= (yp1click>yb)?inc_y+1:inc_y-1;end
                if (stepx != 1)begin
                    intermediate <= intermediate + stepx;
                    if (intermediate >= (1<<fractionbits))begin
                         inc_x <= (xp1click>xb)?inc_x +1:inc_x-1;
                         intermediate <= intermediate - (1<<fractionbits);end end 
                if (stepy != 1)begin
                     intermediate <= intermediate + stepy;
                     if (intermediate >= (1<<fractionbits))begin
                         inc_y <= (yp1click>yb)?inc_y +1:inc_y-1;
                         intermediate <= intermediate - (1<<fractionbits); end end
            end
            if (inc_x == xp1click-2  ||inc_y == yp1click+4 ||resetkeeperstatus==2'b01||resetkeeperstatus==2'b10||possession == 6'b001000||possession==6'b010000||possession==6'b100000)begin 
                middlemousestate <=0; hold <=0;passcounter<=0;intermediate<=0;
                end
       end
       if (hold2==1 && middlemousestate2==1 && distp3>distp4)begin
           deltax2 <= (xp1click2>xb2)?(xp1click2-xb2):(xb2-xp1click2); 
           deltay2 <= (yp1click2>yb2)?(yp1click2-yb2):(yb2-yp1click2);
           step2<=(deltax2>deltay2)?deltax2:deltay2;
           stepx2<=(deltax2==step2)?1:(deltax2<<fractionbits)/step2;
           stepy2<=(deltay2==step2)?1:(deltay2<<fractionbits)/step2;
           passcounter2 <=passcounter2+1;
           move2 <=3'b000;
           if (passcounter2==750_000 && xp1click2 != inc_x +2 && yp1click2 != inc_y - 4  && (resetkeeperstatus != 2'b01||resetkeeperstatus !=2'b10) )begin
               passcounter2 <=0;
               if (stepx2==1)begin
                   inc_x <= (xp1click2>xb2)?inc_x+1:inc_x-1;end
               if (stepy2==1)begin
                   inc_y <= (yp1click2>yb2)?inc_y+1:inc_y-1;end
               if (stepx2 != 1)begin
                   intermediate2 <= intermediate2 + stepx2;
                   if (intermediate2 >= (1<<fractionbits))begin
                        inc_x <= (xp1click2>xb2)?inc_x +1:inc_x-1;
                        intermediate2 <= intermediate2 - (1<<fractionbits);end end 
               if (stepy2 != 1)begin
                    intermediate2 <= intermediate2 + stepy2;
                    if (intermediate2 >= (1<<fractionbits))begin
                        inc_y <= (yp1click2>yb2)?inc_y +1:inc_y-1;
                        intermediate2 <= intermediate2 - (1<<fractionbits); end end
           end
           if (inc_x == xp1click2-2  ||inc_y == yp1click2+4 ||resetkeeperstatus==2'b01||resetkeeperstatus==2'b10 || possession == 6'b000001 || possession == 6'b000010 || possession == 6'b000100)begin 
               middlemousestate2 <=0; hold2 <=0;passcounter2<=0;intermediate2<=0;
               end
      end
        //shooting
        if (rightmouse && hold==1)begin
            rightmousestate<=1; 
            xb <= inc_x; 
            yb <= inc_y; 
            clickstate <=state;
            end 
        if (rightmouse2 && hold2==1)begin
            rightmousestate2<=1; 
            xb2 <= inc_x; 
            yb2 <= inc_y; 
            clickstate2 <=state;
            end 
        if (hold==1 && rightmousestate==1)begin
            passcounter <=passcounter+1;
            move <=3'b000;
            if ((clickstate==0||clickstate==2||clickstate==4) && yb>=42)begin
                deltax <= (xgoal>xb)?(xgoal-xb):(xb-xgoal); 
                deltay <= (goaltop>yb)?(goaltop-yb):(yb-goaltop);
                step<=(deltax>deltay)?deltax:deltay;
                stepx<=(deltax==step)?1:(deltax<<fractionbits)/step;
                stepy<=(deltay==step)?1:(deltay<<fractionbits)/step;
                ygoal <= goaltop;end
            if ((clickstate==0||clickstate==2||clickstate==4) && yb<=21)begin
                deltax <= (xgoal>xb)?(xgoal-xb):(xb-xgoal); 
                deltay <= (goalbot>yb)?(goalbot-yb):(yb-goalbot);
                step<=(deltax>deltay)?deltax:deltay;
                stepx<=(deltax==step)?1:(deltax<<fractionbits)/step;
                stepy<=(deltay==step)?1:(deltay<<fractionbits)/step;
                ygoal <= goalbot;end
            if ((clickstate==0||clickstate==3) && yb<42 && yb>21)begin
                deltax <= (xgoal>xb)?(xgoal-xb):(xb-xgoal); 
                deltay <= (goaltop>yb)?(goaltop-yb):(yb-goaltop);
                step<=(deltax>deltay)?deltax:deltay;
                stepx<=(deltax==step)?1:(deltax<<fractionbits)/step;
                stepy<=(deltay==step)?1:(deltay<<fractionbits)/step;
                ygoal <= goaltop;end
            if ((clickstate==1||clickstate==4) && yb<42 && yb>21)begin
               deltax <= (xgoal>xb)?(xgoal-xb):(xb-xgoal); 
               deltay <= (goalmid>yb)?(goalmid-yb):(yb-goalmid);
               step<=(deltax>deltay)?deltax:deltay;
               stepx<=(deltax==step)?1:(deltax<<fractionbits)/step;
               stepy<=(deltay==step)?1:(deltay<<fractionbits)/step;
               ygoal <= goalmid;end
            if ((clickstate==2||clickstate==5) && yb<42 && yb>21)begin
                deltax <= (xgoal>xb)?(xgoal-xb):(xb-xgoal); 
                deltay <= (goalbot>yb)?(goalbot-yb):(yb-goalbot);
                step<=(deltax>deltay)?deltax:deltay;
                stepx<=(deltax==step)?1:(deltax<<fractionbits)/step;
                stepy<=(deltay==step)?1:(deltay<<fractionbits)/step;
                ygoal <= goalbot;end
            if ((clickstate==1||clickstate==5) && (yb>=42||yb<=21))begin
                deltax <= (xgoal>xb)?(xgoal-xb):(xb-xgoal); 
                deltay <= (goalmid>yb)?(goalmid-yb):(yb-goalmid);
                step<=(deltax>deltay)?deltax:deltay;
                stepx<=(deltax==step)?1:(deltax<<fractionbits)/step;
                stepy<=(deltay==step)?1:(deltay<<fractionbits)/step;
                ygoal <= goalmid;end
            if (clickstate==3 && yb>=42)begin
                deltax <= (xgoal>xb)?(xgoal-xb):(xb-xgoal); 
                deltay <= (goalbot>yb)?(goalbot-yb):(yb-goalbot);
                step<=(deltax>deltay)?deltax:deltay;
                stepx<=(deltax==step)?1:(deltax<<fractionbits)/step;
                stepy<=(deltay==step)?1:(deltay<<fractionbits)/step;
                ygoal <= goalbot;end
            if (clickstate==3 && yb<=21)begin
                deltax <= (xgoal>xb)?(xgoal-xb):(xb-xgoal); 
                deltay <= (goaltop>yb)?(goaltop-yb):(yb-goaltop);
                step<=(deltax>deltay)?deltax:deltay;
                stepx<=(deltax==step)?1:(deltax<<fractionbits)/step;
                stepy<=(deltay==step)?1:(deltay<<fractionbits)/step;
                ygoal <= goaltop;end
            if (passcounter==750_000 && xgoal != inc_x && (resetkeeperstatus != 2'b01||resetkeeperstatus !=2'b10) )begin
                passcounter <=0;
                if (stepx==1)begin
                    inc_x <= (xgoal>xb)?inc_x+1:inc_x-1;end
                if (stepy==1)begin
                    inc_y <= (ygoal>yb)?inc_y+1:inc_y-1;end
                if (stepx != 1)begin
                    intermediate <= intermediate + stepx;
                    if (intermediate >= (1<<fractionbits))begin
                        inc_x <= (xgoal>xb)?inc_x +1:inc_x-1;
                        intermediate <= intermediate - (1<<fractionbits);end end 
                if (stepy != 1)begin
                    intermediate <= intermediate + stepy;
                    if (intermediate >= (1<<fractionbits))begin
                        inc_y <= (ygoal>yb)?inc_y +1:inc_y-1;
                        intermediate <= intermediate - (1<<fractionbits); end end
            end
            if (inc_x == xgoal ||resetkeeperstatus==2'b01||resetkeeperstatus==2'b10||possession == 6'b001000||possession==6'b010000||possession==6'b100000)begin 
                rightmousestate <=0; hold <=0;passcounter<=0;intermediate<=0;
                end
        end
        
        if (hold2==1 && rightmousestate2==1)begin
            passcounter2 <=passcounter2+1;
            move2 <=3'b000;
            if ((clickstate2==0||clickstate2==2||clickstate2==4) && yb2>=42)begin
                deltax2 <= (xgoalp2>xb2)?(xgoalp2-xb2):(xb2-xgoalp2); 
                deltay2 <= (goaltop>yb2)?(goaltop-yb2):(yb2-goaltop);
                step2<=(deltax2>deltay2)?deltax2:deltay2;
                stepx2<=(deltax2==step2)?1:(deltax2<<fractionbits)/step2;
                stepy2<=(deltay2==step2)?1:(deltay2<<fractionbits)/step2;
                ygoal <= goaltop;end
            if ((clickstate2==0||clickstate2==2||clickstate2==4) && yb2<=21)begin
                deltax2 <= (xgoalp2>xb2)?(xgoalp2-xb2):(xb2-xgoalp2); 
                deltay2 <= (goalbot>yb2)?(goalbot-yb2):(yb2-goalbot);
                step2<=(deltax2>deltay2)?deltax2:deltay2;
                stepx2<=(deltax2==step2)?1:(deltax2<<fractionbits)/step2;
                stepy2<=(deltay2==step2)?1:(deltay2<<fractionbits)/step2;
                ygoal <= goalbot;end
            if ((clickstate2==0||clickstate2==3) && yb2<42 && yb2>21)begin
                deltax2 <= (xgoalp2>xb2)?(xgoalp2-xb2):(xb2-xgoalp2); 
                deltay2 <= (goaltop>yb2)?(goaltop-yb2):(yb2-goaltop);
                step2<=(deltax2>deltay2)?deltax2:deltay2;
                stepx2<=(deltax2==step2)?1:(deltax2<<fractionbits)/step2;
                stepy2<=(deltay2==step2)?1:(deltay2<<fractionbits)/step2;
                ygoal <= goaltop;end
            if ((clickstate2==1||clickstate2==4) && yb2<42 && yb2>21)begin
               deltax2 <= (xgoalp2>xb2)?(xgoalp2-xb2):(xb2-xgoalp2); 
               deltay2 <= (goalmid>yb2)?(goalmid-yb2):(yb2-goalmid);
               step2<=(deltax2>deltay2)?deltax2:deltay2;
               stepx2<=(deltax2==step2)?1:(deltax2<<fractionbits)/step2;
               stepy2<=(deltay2==step2)?1:(deltay2<<fractionbits)/step2;
               ygoal <= goalmid;end
            if ((clickstate2==2||clickstate2==5) && yb2<42 && yb2>21)begin
                deltax2 <= (xgoalp2>xb2)?(xgoalp2-xb2):(xb2-xgoalp2); 
                deltay2 <= (goalbot>yb2)?(goalbot-yb2):(yb2-goalbot);
                step2<=(deltax2>deltay2)?deltax2:deltay2;
                stepx2<=(deltax2==step2)?1:(deltax2<<fractionbits)/step2;
                stepy2<=(deltay2==step2)?1:(deltay2<<fractionbits)/step2;
                ygoal <= goalbot;end
            if ((clickstate2==1||clickstate2==5) && (yb2>=42||yb2<=21))begin
                deltax2 <= (xgoalp2>xb2)?(xgoalp2-xb2):(xb2-xgoalp2); 
                deltay2 <= (goalmid>yb2)?(goalmid-yb2):(yb2-goalmid);
                step2<=(deltax2>deltay2)?deltax2:deltay2;
                stepx2<=(deltax2==step2)?1:(deltax2<<fractionbits)/step2;
                stepy2<=(deltay2==step2)?1:(deltay2<<fractionbits)/step2;
                ygoal <= goalmid;end
            if (clickstate2==3 && yb2>=42)begin
                deltax2 <= (xgoalp2>xb2)?(xgoalp2-xb2):(xb2-xgoalp2); 
                deltay2 <= (goalbot>yb2)?(goalbot-yb2):(yb2-goalbot);
                step2<=(deltax2>deltay2)?deltax2:deltay2;
                stepx2<=(deltax2==step2)?1:(deltax2<<fractionbits)/step2;
                stepy2<=(deltay2==step2)?1:(deltay2<<fractionbits)/step2;
                ygoal <= goalbot;end
            if (clickstate2==3 && yb2<=21)begin
                deltax2 <= (xgoalp2>xb2)?(xgoalp2-xb2):(xb2-xgoalp2); 
                deltay2 <= (goaltop>yb2)?(goaltop-yb2):(yb2-goaltop);
                step2<=(deltax2>deltay2)?deltax2:deltay2;
                stepx2<=(deltax2==step2)?1:(deltax2<<fractionbits)/step2;
                stepy2<=(deltay2==step2)?1:(deltay2<<fractionbits)/step2;
                ygoal <= goaltop;end
            if (passcounter2==750_000 && xgoalp2 != inc_x  && (resetkeeperstatus != 2'b01||resetkeeperstatus !=2'b10)  )begin
                passcounter2 <=0;
                if (stepx2==1)begin
                    inc_x <= (xgoalp2>xb2)?inc_x+1:inc_x-1;end
                if (stepy2==1)begin
                    inc_y <= (ygoal>yb2)?inc_y+1:inc_y-1;end
                if (stepx2 != 1)begin
                    intermediate2 <= intermediate2 + stepx2;
                    if (intermediate2 >= (1<<fractionbits))begin
                        inc_x <= (xgoalp2>xb2)?inc_x +1:inc_x-1;
                        intermediate2 <= intermediate2 - (1<<fractionbits);end end 
                if (stepy2 != 1)begin
                    intermediate2 <= intermediate2 + stepy2;
                    if (intermediate2 >= (1<<fractionbits))begin
                        inc_y <= (ygoal>yb2)?inc_y +1:inc_y-1;
                        intermediate2 <= intermediate2 - (1<<fractionbits); end end
            end
            if (inc_x == xgoalp2 ||resetkeeperstatus==2'b01||resetkeeperstatus==2'b10 || possession == 6'b000001 || possession == 6'b000010 || possession == 6'b000100)begin 
                rightmousestate2 <=0; hold2 <=0;passcounter2<=0;intermediate2<=0;
                end
        end
        end
        if ((inc_x == xgoalp2 || inc_x == xgoal) && inc_y<=42 && inc_y>=21)begin
            inc_x = 47;
            inc_y = 30;
        end
    end
endmodule