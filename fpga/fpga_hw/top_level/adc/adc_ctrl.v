/*
	Reads data from the ADC
	Currently configured to only read from a single channel
	Conversion takes between 1.3-1.6us so with a 2MHz iCLK, need to hold oCS for about 4 cycles
	Afterwards, begin clocking oSCLK
	ADC will grab oDIN (channel configuration bits) on the first 6 posedges of oSCLK
	First bit of data from ADC will arrive the moment oCS goes down, then subsequent bits shifted in on the negedge of oSCLK
	More details on timing and channel configuration can be found in the ADC datasheet (somewhere...)
	
	-Carl, May 2016
*/

module adc_ctrl   (   
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
               
	input            iRST;
	input            iCLK;
	input            iCLK_n;
	input          	iGO;

	output            oDIN;
	output            oCS;
	output            oSCLK;
	input            iDOUT;

	output  reg [11:0]    oADC_12_bit_channel_0 = 12'b0;
	output  reg [11:0]    oADC_12_bit_channel_1 = 12'b0;
	output  reg [11:0]    oADC_12_bit_channel_2 = 12'b0;
	output  reg [11:0]    oADC_12_bit_channel_3 = 12'b0;
	output  reg [11:0]    oADC_12_bit_channel_4 = 12'b0;
	output  reg [11:0]    oADC_12_bit_channel_5 = 12'b0;
	output  reg [11:0]    oADC_12_bit_channel_6 = 12'b0;
	output  reg [11:0]    oADC_12_bit_channel_7 = 12'b0;

	reg      [3:0]    count = 4'b0;
	reg      [3:0]    ch_config = 4'b1111; 	//select ch 7
	reg					uni = 1'b1; 				//unipolar/~bipolar bit
	reg					slp = 1'b0; 				//sleep mode bit
	reg      [11:0]   adc_data = 12'b0;
	reg 					data_out = 1'b0;

	assign   oCS      =   (count < 4);
	assign   oSCLK    =   (count >= 4 && count < 15)? iCLK : 1'b0;
	assign   oDIN     =   data_out;

	always@(negedge iCLK)
	begin
		if(iRST)
		begin
			count <= 0;
			
		end
		else
		begin
			count <= count + 1'b1;
			case (count)
				4'd3: begin
					data_out <= ch_config[3];
				end
				4'd4: begin
					data_out <= ch_config[2];
				end
				4'd5: begin
					data_out <= ch_config[1];
				end
				4'd6: begin
					data_out <= ch_config[0];
				end
				4'd7: begin
					data_out <= uni;
				end
				4'd8: begin
					data_out <= slp;
				end
			endcase
		end
	end
	
	always@(posedge iCLK) begin
		if (iRST) begin
			adc_data <= 12'b0;
		end
		else
		begin
			case (count)
				4'd0: begin
					oADC_12_bit_channel_0 <= adc_data;
					oADC_12_bit_channel_1 <= adc_data;
					oADC_12_bit_channel_2 <= adc_data;
					oADC_12_bit_channel_3 <= adc_data;
					oADC_12_bit_channel_4 <= adc_data;
					oADC_12_bit_channel_5 <= adc_data;
					oADC_12_bit_channel_6 <= adc_data;
					oADC_12_bit_channel_7 <= adc_data;
				end
				4'd4: begin
					adc_data[11] <= iDOUT;
				end
				4'd5: begin
					adc_data[10] <= iDOUT;
				end
				4'd6: begin
					adc_data[9] <= iDOUT;
				end
				4'd7: begin
					adc_data[8] <= iDOUT;
				end
				4'd8: begin
					adc_data[7] <= iDOUT;
				end
				4'd9: begin
					adc_data[6] <= iDOUT;
				end
				4'd10: begin
					adc_data[5] <= iDOUT;
				end
				4'd11: begin
					adc_data[4] <= iDOUT;
				end
				4'd12: begin
					adc_data[3] <= iDOUT;
				end
				4'd13: begin
					adc_data[2] <= iDOUT;
				end
				4'd14: begin
					adc_data[1] <= iDOUT;
				end
				4'd15: begin
					adc_data[0] <= iDOUT;
				end
			endcase
		end	
	end

endmodule
