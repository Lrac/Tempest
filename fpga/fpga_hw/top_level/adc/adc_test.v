module adc_test(CLOCK_50, LED, KEY, ADC_CONVST, ADC_SCK, ADC_SDI, ADC_SDO);
	input CLOCK_50;
	input KEY;
	output [7:0] LED;
	
	input  ADC_SDO;
	output ADC_CONVST;
	output ADC_SCK;
	output ADC_SDI;
	
	reg clock_2ishMHz = 1'b0;
	reg [4:0] counter = 5'b0;
	
	always@(posedge CLOCK_50) begin
		if (counter == 5'd12) begin
			counter <= 5'd0;
			clock_2ishMHz = ~clock_2ishMHz;
		end
		else begin
			counter <= counter + 1'b1;
		end
	end
	
	wire [8*32-1:0] adc_channels;
	assign LED = adc_channels[11:4]; //put the 8 most significant bits on LEDs
	
	adc my_adc( .reset_n(~KEY),
					.spi_clk(clock_2ishMHz),
   				.sys_clk(CLOCK_50),
					.sda(),
					.scl(),
					.adc_channels(adc_channels),

   //////////// ADC //////////
					.ADC_SDO(ADC_SDO),
					.ADC_CONVST(ADC_CONVST),
					.ADC_SDI(ADC_SDI),
					.ADC_SCK(ADC_SCK)
					
	);
	
endmodule
	