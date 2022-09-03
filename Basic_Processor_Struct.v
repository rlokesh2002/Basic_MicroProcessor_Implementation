`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:43:26 02/06/2022 
// Design Name: 
// Module Name:    Basic_Processor_Struct 
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
module Basic_Processor_Struct(
    input [7:0] INSTR,
    input CLK, input RST,
    input [7:0] Load,
    output [7:0] OUT
    );
	 
	wire [2:0] MUX_2to1_OUT;
	wire [7:0] MUX_8to1_OUT, MUX_4to1_OUT, ADD_OUT, DCDR;
	wire [7:0] A_out, B_out, C_out, D_out, E_out, F_out, G_out, H_out;
	
	wire flag, Car_out;
	
	RGSTR8CE A(A_out, CLK, DCDR[0], RST, MUX_4to1_OUT);
	RGSTR8CE B(B_out, CLK, DCDR[1], RST, MUX_4to1_OUT);
	RGSTR8CE C(C_out, CLK, DCDR[2], RST, MUX_4to1_OUT);
	RGSTR8CE D(D_out, CLK, DCDR[3], RST, MUX_4to1_OUT);
	RGSTR8CE E(E_out, CLK, DCDR[4], RST, MUX_4to1_OUT);
	RGSTR8CE F(F_out, CLK, DCDR[5], RST, MUX_4to1_OUT);
	RGSTR8CE G(G_out, CLK, DCDR[6], RST, MUX_4to1_OUT);
	RGSTR8CE H(H_out, CLK, DCDR[7], RST, MUX_4to1_OUT);
	
	AND2 A1(flag, INSTR[7], INSTR[6]);
	MUX2_1 M1(MUX_2to1_OUT, INSTR[2:0], INSTR[5:3], flag);
	MUX8_1 M2(MUX_8to1_OUT, A_out, B_out, C_out, D_out, E_out, F_out, G_out, H_out, MUX_2to1_OUT);
	
	ADDSUB_MACRO #(
		.DEVICE("VIRTEX6"), // Target Device: "VIRTEX5", "VIRTEX6", "SPARTAN6"
		.LATENCY(0), // Desired clock cycle latency, 0-2
		.WIDTH(8) // Input / output bus width, 1-48
		) ADDSUB_MACRO_inst (
		.CARRYOUT(Car_out), // 1-bit carry-out output signal
		.RESULT(ADD_OUT), // Add/sub result output, width defined by WIDTH parameter
		.A(MUX_8to1_OUT), // Input A bus, width defined by WIDTH parameter
		.ADD_SUB(1'b1), // 1-bit add/sub input, high selects add, low selects subtract
		.B(A_out), // Input B bus, width defined by WIDTH parameter
		.CARRYIN(1'b0), // 1-bit carry-in input
		.CE(1'b1), // 1-bit clock enable input
		.CLK(CLK), // 1-bit clock input
		.RST(RST) // 1-bit active high synchronous reset
		);
		
	MUX4_1 M3(MUX_4to1_OUT, Load, MUX_8to1_OUT, ADD_OUT, MUX_8to1_OUT, INSTR[7:6]);
	
	DCDR3_8 D1(DCDR, INSTR[5:3]);
	
	RGSTR8CE OTPT(OUT, CLK, flag, RST, MUX_4to1_OUT);
	
endmodule

module RGSTR8CE(output reg [7:0] OUT, input CLK, input CE, input CLR, input [7:0] D);
	always @(negedge CLK or posedge CLR)
		begin
		if(CLR)
			OUT = 8'd0;
		else
			if(CE)
				begin
						OUT = D;
				end
		end
endmodule

module MUX2_1(output reg [2:0] OUT, input [2:0] I0, input [2:0] I1, input S);
	always @(S or I0 or I1)
	begin 
		case(S)
		1'b0:	OUT = I0;
		1'b1:	OUT = I1;
		default: OUT = 3'dx;
		endcase
	end
endmodule


//8 to 1 MUX
module MUX8_1 (output reg [7:0] OUT, input [7:0] I0, input [7:0] I1, input [7:0] I2, input [7:0] I3, input [7:0] I4, input [7:0] I5, input [7:0] I6, input [7:0] I7, input [2:0] S);
	always @(S or I0 or I1 or I2 or I3 or I4 or I5 or I6 or I7)
	begin 
		case(S)
		3'b000:	OUT = I0;
		3'b001:	OUT = I1;
		3'b010:	OUT = I2;
		3'b011:	OUT = I3;
		3'b100:	OUT = I4;
		3'b101:	OUT = I5;
		3'b110:	OUT = I6;
		3'b111:	OUT = I7;
		default: OUT = 8'dx;
		endcase
	end
endmodule

module MUX4_1 (output reg [7:0] OUT, input [7:0] I0, input [7:0] I1, input [7:0] I2, input [7:0] I3, input [1:0] S);	//4 to 1 MUX
	always @(S or I0 or I1 or I2 or I3)
	begin
		case(S)
		2'd0: OUT = I0;		//INPUT LOAD into OUT	
		2'd1: OUT = I1;		//MOVE Register(INSTR[2:0]) to Register(INSTR[5:3])
		2'd2: OUT = I2;		//ADD Register(INSTR[2:0]) with A to store in Register(INSTR[5:3])
		2'd3: OUT = I3;		//OUTPUT Register(INSTR[5:3]) 
		default: OUT = 8'dx;
		endcase
	end
endmodule

module DCDR3_8(output reg [7:0] OUT, input [2:0] IN);	//3 to 8 Decoder
	always @(IN)
	begin 
		case(IN)
		3'd0: OUT = 8'b00000001;
		3'd1: OUT = 8'b00000010;
		3'd2: OUT = 8'b00000100;
		3'd3: OUT = 8'b00001000;
		3'd4: OUT = 8'b00010000;
		3'd5: OUT = 8'b00100000;
		3'd6: OUT = 8'b01000000;
		3'd7: OUT = 8'b10000000;
		default: OUT = 8'd0;
		endcase
	end
endmodule