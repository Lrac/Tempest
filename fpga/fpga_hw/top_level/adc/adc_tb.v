`timescale 1 ns / 10 ps

module adc_tb();

	reg iRST, iCLK, iCLK_n, iGO, iDOUT;
	wire oDIN, oCS, oSCLK;
	wire [11:0] oADC_12_bit_channel_0,
					oADC_12_bit_channel_1,
					oADC_12_bit_channel_2,
					oADC_12_bit_channel_3,
					oADC_12_bit_channel_4,
					oADC_12_bit_channel_5,
					oADC_12_bit_channel_6,
					oADC_12_bit_channel_7;

	adc_ctrl   dut(   
               iRST,
               iCLK,
               iCLK_n,
               iGO,
               
               
               oDIN,
               oCS,
               oSCLK,
               iDOUT,
               
               oADC_12_bit_channel_0,
               oADC_12_bit_channel_1,
               oADC_12_bit_channel_2,
               oADC_12_bit_channel_3,
               oADC_12_bit_channel_4,
               oADC_12_bit_channel_5,
               oADC_12_bit_channel_6,
               oADC_12_bit_channel_7
            );
				
	initial begin
		iRST = 1'b0;
		iCLK = 1'b0;
		iCLK_n = 1'b0;
		iGO = 1'b0;
		iDOUT = 1'b0;
	end
	
	always #10 iCLK = ~iCLK; //toggling every 250ns
	always #20 iDOUT = ~iDOUT;
	
endmodule