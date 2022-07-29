/////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////// OPERACIONES ARITMETICAS //////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
module ripple_carry_subtractor(A, B, out, flag);
  output [7:0] out;   
  output logic [8:0] flag;
	input [7:0] A; 
	input [7:0] B;   
	reg Op = 1; 
	reg C, V;

	wire C0,C1,C2,C3,C4,C5,C6,C7; 

   	wire B0,B1,B2,B3,B4,B5,B6,B7; 

   	xor(B0, B[0], Op);
   	xor(B1, B[1], Op);
   	xor(B2, B[2], Op);
   	xor(B3, B[3], Op);
  	xor(B4, B[4], Op);
   	xor(B5, B[5], Op);
   	xor(B6, B[6], Op);
   	xor(B7, B[7], Op);
  	xor(C, !C3, Op);     
  	xor(V, !C3, C2);     
   
  full_adder fa0(out[0], C0, A[0], B0, Op);    
  full_adder fa1(out[1], C1, A[1], B1, C0);
  full_adder fa2(out[2], C2, A[2], B2, C1);
  full_adder fa3(out[3], C3, A[3], B3, C2);
  full_adder fa4(out[4], C4, A[4], B4, C3);
  full_adder fa5(out[5], C5, A[5], B5, C4);
  full_adder fa6(out[6], C6, A[6], B3, C5);
  full_adder fa7(out[7], C7, A[7], B7, C6);
  
  assign flag = {{1'b1}, {3{1'b0 }},!(&out), out[7] , C ,V, {1'b0 }};
endmodule: ripple_carry_subtractor

module full_adder(S, Cout, A, B, Cin);
   output S;
   output Cout;
   input  A;
   input  B;
   input  Cin;
   
   wire   w1;
   wire   w2;
   wire   w3;
   wire   w4;
   
   xor(w1, A, B);
   xor(S, Cin, w1);
   and(w2, A, B);   
   and(w3, A, Cin);
   and(w4, B, Cin);   
   or(Cout, w2, w3, w4);
endmodule:full_adder

module CLA4Bit (A, B, cin, sum, cout);
  	input [3:0] A, B;
	input cin;
	output logic [3:0] sum;
	output logic cout;
	wire p0,p1,p2,p3,g0,g1,g2,g3,c1,c2,c3,c4,c0;

  	assign p0=(A[0]^B[0]),
    p1=(A[1]^B[1]),
    p2=(A[2]^B[2]),
    p3=(A[3]^B[3]);

  	assign g0=(A[0]&B[0]),
    g1=(A[1]&B[1]),
    g2=(A[2]&B[2]),
    g3=(A[3]&B[3]);
       
	assign c0=cin,
       c1=g0|(p0&cin),
       c2=g1|(p1&g0)|(p1&p0&cin),
  		c3=g2|(p2&g1)|(p2&p1&g0)|(p2&p1&p0&cin),
       c4=g3|(p3&g2)|(p3&p2&g1)|(p3&p2&p1&g0)|(p3&p2&p1&p0&cin);
       
  	assign sum[0] = A[0] ^ B[0] ^ cin,
    sum[1] = A[1] ^ B[1] ^ c1,
    sum[2] = A[2] ^ B[2] ^ c2,
    sum[3] = A[3] ^ B[3] ^ c3;
       
	assign cout=c4;     
endmodule: CLA4Bit


module cla_adder(A, B, out, flag);
  	input [7:0] A, B;
  	reg [7:0] cin;
  	reg cout;
  output logic [7:0] out;
  output logic [8:0] flag;
  	wire c1;
  	assign cin = 0;
  CLA4Bit c11(A[3:0],B[3:0],cin,out[3:0],c1);
  CLA4Bit c22(A[7:4],B[7:4],c1,out[7:4],cout);
  
  assign flag = {{1'b1}, {3{1'b0 }},{out==0}, out[7] , cout ,{(A[7]==B[7])^cout}, {1'b0}};
endmodule: cla_adder

module division(A,B,out,flag);
  input logic [7:0] A, B;
  output logic [7:0] out;
  output logic [8:0] flag;
  reg[7:0] cond = B;
  
  always @B begin
    if (!B) begin
      assign out = 8'b0;
    end else begin
      assign out = A/B;
    end 
  end
  assign flag = {{1'b1}, {3{1'b0 }}, {(&B)&(out==0)},out[7] , {1'b0} ,{(A[7]&!(&A[6:0]))&(B[0]&!(&B[7:1]))}, {B==0}};
endmodule: division

module amult(bin1, bin2, out, flag);
  input logic [7:0] bin1;
  input logic [7:0] bin2;
  output logic [7:0] out;
  output logic [8:0] flag;
  
  assign out = bin1*bin2;
  assign flag = {{1'b1},{{3'b0}},{out==0},out[7],{1'b0},{1'b1},{1'b0}};
  
endmodule: amult

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////// OPERACIONES LOGICAS ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
module bitwise_not(A, out, flag);
    input logic [7:0] A;
    output logic [7:0] out;
  	output logic [8:0] flag;
    
  	assign out[0]= !A[0];
  	assign out[1]= !A[1];
  	assign out[2]= !A[2];
  	assign out[3]= !A[3];
  	assign out[4]= !A[4];
  	assign out[5]= !A[5];
  	assign out[6]= !A[6];
  	assign out[7]= !A[7];
    
  assign flag = {{1'b0},{1'b1},{2{1'b0}},{out==0},{out[7]},{3{1'b0}}};
endmodule: bitwise_not

module bitwise_or(A, B, out, flag);
    input logic [7:0] A;
    input logic [7:0] B;
    output logic [7:0] out;
  	output logic [8:0] flag;
    
    assign out[0]= A[0] | B[0];
    assign out[1]= A[1] | B[1];
    assign out[2]= A[2] | B[2];
    assign out[3]= A[3] | B[3];
    assign out[4]= A[4] | B[4];
    assign out[5]= A[5] | B[5];
    assign out[6]= A[6] | B[6];
    assign out[7]= A[7] | B[7];
    
  	assign flag = {{1'b0},{1'b1},{2{1'b0}},{out==0},{out[7]},{3{1'b0}}};
endmodule: bitwise_or

module bitwise_and(A, B, out, flag);
    input logic [7:0] A;
    input logic [7:0] B;
    output logic [7:0] out;
  	output logic [8:0] flag;
    
    assign out[0]= A[0] & B[0];
    assign out[1]= A[1] & B[1];
    assign out[2]= A[2] & B[2];
    assign out[3]= A[3] & B[3];
    assign out[4]= A[4] & B[4];
    assign out[5]= A[5] & B[5];
    assign out[6]= A[6] & B[6];
    assign out[7]= A[7] & B[7];
    
    assign flag = {{1'b0},{1'b1},{2{1'b0}},{out==0},{out[7]},{3{1'b0}}};
endmodule: bitwise_and

module bitwise_xor(A, B, out, flag);
    input logic [7:0] A;
    input logic [7:0] B;
    output logic [7:0] out;
  	output logic [8:0] flag;
    
  assign out[0]= A[0] ^ B[0];
  assign out[1]= A[1] ^ B[1];
  assign out[2]= A[2] ^ B[2];
  assign out[3]= A[3] ^ B[3];
  assign out[4]= A[4] ^ B[4];
  assign out[5]= A[5] ^ B[5];
  assign out[6]= A[6] ^ B[6];
  assign out[7]= A[7] ^ B[7];
    
    assign flag = {{1'b0},{1'b1},{2{1'b0}},{out==0},{out[7]},{3{1'b0}}};
endmodule: bitwise_xor


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////// OPERACIONES DE TRANSPOSICIÓN ////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
module lsl(A, B, out, flag);
    input logic [7:0] A;
    input logic [7:0] B;
    output logic [7:0] out;
  	output logic [8:0] flag;

    assign out = A >> B;
    assign flag = {{2{1'b0}},{1'b1},{1'b0},{out==0},{out[7]},{3{1'b0}}};
endmodule: lsl

module lsr(A, B, out, flag);
    input logic [7:0] A;
    input logic [7:0] B;
    output logic [7:0] out;
  	output logic [8:0] flag;

    assign out = A << B;
    assign flag = {{2{1'b0}},{1'b1},{1'b0},{out==0},{out[7]},{3{1'b0}}};
endmodule: lsr

module asr(A, B, out, flag);
    input signed [7:0] A;
    input logic [7:0] B;
    output signed [7:0] out;
  	output logic [8:0] flag;

    assign out = $signed(A >>> B);
    assign flag = {{2{1'b0}},{1'b1},{1'b0},{out==0},{out[7]},{3{1'b0}}};
endmodule: asr

module ror(A,B,out,flag);
    input logic[7:0] A;
    input logic[7:0]B;
  	output logic [7:0] out;
  	output logic[8:0] flag;
  	
  	assign out = (A << ('h8-B)) | (A >> 'h8-('h8-B)); 
 	assign flag = {{2{1'b0}},{1'b1},{1'b0},{out==0},{out[7]},{3{1'b0}}};
endmodule:ror

module rol(A,B,out,flag);
    input logic[7:0] A;
    input logic[7:0]B;
  	output logic [7:0] out;
  	output logic[8:0] flag;
  	
    assign out = (A << B) | (A >> ('h8-B)); 
 	assign flag = {{2{1'b0}},{1'b1},{1'b0},{out==0},{out[7]},{3{1'b0}}};
endmodule:rol

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////  OPERACIONES DEL TORNEO //////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
module pLigero(clk, A, B, winner, flag);
  input [7:0] A,B;
  input clk;
  output [7:0] winner;
  output [8:0] flag;
  
  reg [7:0] height_A, AGI_A, height_B, AGI_B;
  logic cycle;
  
  always@(clk) begin
  case(cycle)
    0: begin
      assign AGI_A = A;
      assign AGI_B = B;
      assign cycle = 1;
    end
    default: begin
      assign height_A = A;
      assign height_B = B;
      assign cycle = 0;
    end
      
  endcase	
  end

  
  assign winner = ((height_A/AGI_A) + (100/height_A) + AGI_A) > ((height_B/AGI_B) + (100/height_B) + AGI_B) ? 8'h00 : 9'hff;
  
  assign flag = winner[0] == 1'b1 ? 9'h028 : 9'h020;

endmodule : pLigero


module pPesado(clk, A, B, winner, flag);
  input [7:0] A, B;
  input clk;
  output [7:0] winner;
  output [8:0] flag;
  
  reg [7:0] weight_A, RES_A, weight_B, RES_B;
  logic [3:0] cycle;
  
  always@(clk) begin
  case(cycle)
    0: begin
      assign RES_A = A;
      assign RES_B = B;
      assign cycle = 1;
    end
    default: begin
      assign weight_A = A;
      assign weight_B = B;
      assign cycle = 0;
    end
      
  endcase	
  end
  
  
  assign winner = ((5*weight_A) + (2*RES_A)) > ((5*weight_B) + (2*RES_B)) ? 8'h00 : 9'hff;
  assign flag = winner[0] == 1'b1 ? 9'h028 : 9'h020;
  
endmodule : pPesado

module pMixto(clk, A, B, winner, flag);
  input [7:0] A, B;
  input clk;
  output [7:0] winner;
  output [8:0] flag;
  
  reg [7:0] height_A, AGI_A, weight_A, STR_A, RES_A, height_B, AGI_B, weight_B, STR_B, RES_B;
  logic [3:0]cycle;
  
  always@(clk) begin
  case(cycle)
    0: begin
      assign AGI_A = A;
      assign AGI_B = B;
      assign cycle = 1;
    end
    1: begin
      assign weight_A = A;
      assign weight_B = B;
      assign cycle = 2;
    end
    2: begin
      assign STR_A = A;
      assign STR_B = B;
      assign cycle = 3;
    end
    3: begin
      assign RES_A = A;
      assign RES_B = B;
      assign cycle = 4;
    end
      
    default: begin
      assign height_A = A;
      assign height_B = B;
      assign cycle = 0;
    end
      
  endcase	
  end
  
  
  assign winner = ((height_A/AGI_A) + (3*weight_A) + ((STR_A+AGI_A+RES_A)/3)) > ((height_B/AGI_B) + (3*weight_B) + ((STR_B+AGI_B+RES_B)/3)) ? 8'h00 : 9'hff;
  assign flag = winner[0] == 1'b1 ? 9'h028 : 9'h020;
  
endmodule : pMixto


/////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////  GESTION DE MEMORIA ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

module rom(cs,addr,data);
  input[3:0]addr;
  input cs;
  output reg[3:0]data;
  
  logic [3:0] mem [15:0];
  
  initial begin
    mem[0] = 4'h0;
    mem[1] = 4'h0;
    mem[2] = 4'h3;
    mem[3] = 4'h4;
    mem[4] = 4'hd;
    mem[5] = 4'hd;
    mem[6] = 4'hf;
    mem[7] = 4'hf;
    mem[8] = 4'hf;
    mem[9] = 4'hf;
    mem[10] = 4'hf;
    mem[11] = 4'h2;
    mem[12] = 4'ha;
    mem[13] = 4'h9;
    mem[14] = 4'hb;
    mem[15] = 4'h3;
  end
  
always@(cs or addr)
begin
  data = mem[addr];
end

endmodule :rom


module PC(clk,reset,count);
  input clk,reset;
  output reg [3:0] count;
  always@(posedge clk)
  begin
    if(reset)
      count <= 0;
    else
      count <= count + 1;
  end
endmodule :PC



module main(clk, reset, A, B, out, flag);
  input clk, reset;
  input [7:0] A, B;
  output reg [7:0] out;
  output reg [8:0] flag;

  logic [7:0] A2,B2 [4:0];
  logic [3:0] count, data;
  logic [2:0] cycle;
  reg [7:0] outputs [15:0];
  reg [8:0] flags [15:0];
  
  
  PC pca (clk, reset, count);
  rom roma (clk, count, data);
  
  cla_adder add(A, B, outputs[0], flags[0]);
  ripple_carry_subtractor sub(A, B, outputs[1], flags[1]);
  amult mult(A, B, outputs[2], flags[2]);
  division div(A, B, outputs[3], flags[3]);
  bitwise_not nott(A, outputs[4], flags[4]);
  bitwise_or orr(A, B, outputs[5], flags[5]);
  bitwise_and andd(A, B, outputs[6], flags[6]);
  bitwise_xor xorr(A, B, outputs[7], flags[7]);
  lsl lsleft(A, B, outputs[8], flags[8]);
  lsr lsright(A, B, outputs[9], flags[9]);
  asr asright(A, B, outputs[10], flags[10]);
  rol roleft(A, (B%8), outputs[11], flags[11]);
  ror roright(A, (B%8), outputs[12], flags[12]);
  pLigero pl(clk,A,B,outputs[13], flags[13]);
  pPesado pp(clk,A,B,outputs[14], flags[14]);
  pMixto pm(clk,A,B,outputs[15], flags[15]);
  
  always@(posedge clk)
  begin
    assign out = outputs[data];
    assign flag = flags[data];
  end


endmodule :main

