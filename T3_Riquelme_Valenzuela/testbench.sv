module main_tb;
  reg clk, reset;
  reg [7:0] A, B, out;
  reg [8:0] flag;
  
  main M(clk, reset, A, B, out, flag);
  
  initial 
    begin
      $dumpfile("dump.vcd");
      $dumpvars;
      
      clk = 1;
      reset = 1;
      A = 8'h7f;
      B = 8'h2f;
      #10;

      clk = 0;
      reset = 0;
	  #10;
      
      clk = 1;
      reset = 0;
      A = 8'hff;
      B = 8'h01;
      #10;
      
      clk = 0;
      #10;
      
      clk = 1;
      reset = 0;
      A = 8'h11;
      B = 8'h04;
      #10;
      
      clk = 0;
      #10;
      
      clk = 1;
      reset = 0;
      A = 8'h55;
      #10;
      
      clk = 0;
      #10;
      
      clk = 1;
      reset = 0;
      A = 8'h64;
      B = 8'h60;
      #10;
      
      clk = 0;
      #10;
      
      clk = 1;
      reset = 0;
      A = 8'h07;
      B = 8'h04;
      #10;
      
      clk = 0;
      #10;
      
      clk = 1;
      reset = 0;
      A = 8'h3c;
      B = 8'h53;
      #10;
      
      clk = 0;
      #10;
      
      clk = 1;
      reset = 0;
      A = 8'h04;
      B = 8'h04;
      #10;
      
      clk = 0;
      #10;
      
      clk = 1;
      reset = 0;
      A = 8'h0f;
      B = 8'h15;
      #10;
      
      clk = 0;
      #10;
      
      clk = 1;
      reset = 0;
      A = 8'h06;
      B = 8'h01;
      #10;
      
      clk = 0;
      #10;
      
      clk = 1;
      reset = 0;
      A = 8'h05;
      B = 8'h05;
      #10;
      
      clk = 0;
      #10;
      
      clk = 1;
      reset = 0;
      A = 8'h03;
      B = 8'h05;
      #10;
      
      clk = 0;
      #10;
      
      clk = 1;
      reset = 0;
      A = 8'hff;
      B = 8'h02;
      #10;
      
      clk = 0;
      #10;
      
      clk = 1;
      reset = 0;
      A = 8'hff;
      B = 8'h02;
      #10;
      
      clk = 0;
      #10;
      
      clk = 1;
      reset = 0;
      A = 8'haa;
      B = 8'h03;
      #10;
      
      clk = 0;
      #10;
      
      clk = 1;
      reset = 0;
      A = 8'h3b;
      B = 8'h00;
      #10;
      
      clk = 0;
      #10;
      

    end
endmodule
