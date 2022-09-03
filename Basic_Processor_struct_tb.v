`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:15:07 02/06/2022 
// Design Name: 
// Module Name:    Basic_Processor_struct_tb 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Basic_Processor_struct_tb();
	reg CLK, RST;
	reg [7:0] ld_ext, instr;
	wire [7:0] OUT;
	Basic_Processor_Struct stimulus(instr, CLK, RST, ld_ext, OUT);
	initial begin
		CLK = 1'b0;
		RST = 1'b1;
//		forever #10 CLK = ~CLK; //time period of clock is 20 time units
	end
	initial begin
		#50 
		begin
			RST = 1'b0;
			ld_ext = 8'd15;	//load external value is 15
			instr = 8'b00000000; //Load value of 15 into A
			#10 CLK = ~CLK;
			#10 CLK = ~CLK;
		end

		#20 instr = 8'b11000111;	//output value of A = 15		-----	15
		#10 CLK = ~CLK;
		#10 CLK = ~CLK;					

		#80 instr = 8'b01001000;//load value of A into B
		#10 CLK = ~CLK;
		#10 CLK = ~CLK;		

		#60 instr = 8'b11001000; //output value of B = 15			--- 15
		#10 CLK = ~CLK;
		#10 CLK = ~CLK;	
 
		#80 instr = 8'b10000001; //add value of A to B and store in A
		#10 CLK = ~CLK;
		#10 CLK = ~CLK;		

		#40 instr = 8'b11000000; //output value of A	-- ----- 15+15 = 30		------30
		#10 CLK = ~CLK;
		#10 CLK = ~CLK;			
		
		#80 instr = 8'b10000001; //add value of A to B and store in A
		#10 CLK = ~CLK;
		#10 CLK = ~CLK;	
		
		#40 instr = 8'b11000000; //output value of A	-- ----- 30+15 = 45	----45
 		#10 CLK = ~CLK;
		#10 CLK = ~CLK;		
		 
	end  
	initial $monitor("Time: ", $time, " and Output = %d", OUT); //Printing the Output
	initial #(1000) $finish ;

endmodule
