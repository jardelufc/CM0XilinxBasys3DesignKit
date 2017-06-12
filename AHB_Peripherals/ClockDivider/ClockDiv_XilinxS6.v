//  --========================================================================--
//  Version and Release Control Information:
//
//  File Name           : ClockDiv.v
//  File Revision       : 1.00
//
//  ----------------------------------------------------------------------------
//  Purpose             : Platform specific Clock Divider
//                        
//  --========================================================================--


module ClockDiv(
	//Clock Input
			input wire 	CLK_I,
	//Clock Output
			output wire CLK_O

    );


// Refer to Spartan 6 clocking resource guide for more info in BUFIO2 and BUFG

wire ck;

BUFIO2 #
	(	.DIVIDE(2),
		.DIVIDE_BYPASS(0)
	)
	uBUFIO2(
	.I				(CLK_I),
	.DIVCLK		(ck),
	.IOCLK		(),
	.SERDESSTROBE()
	);

BUFG uBUFG(
	.I(ck),
	.O(CLK_O)
	);


endmodule
