//////////////////////////////////////////////////////////////////////////////////
//END USER LICENCE AGREEMENT                                                    //
//                                                                              //
//Copyright (c) 2012, ARM All rights reserved.                                  //
//                                                                              //
//THIS END USER LICENCE AGREEMENT (ï¿½LICENCEï¿½) IS A LEGAL AGREEMENT BETWEEN      //
//YOU AND ARM LIMITED ("ARM") FOR THE USE OF THE SOFTWARE EXAMPLE ACCOMPANYING  //
//THIS LICENCE. ARM IS ONLY WILLING TO LICENSE THE SOFTWARE EXAMPLE TO YOU ON   //
//CONDITION THAT YOU ACCEPT ALL OF THE TERMS IN THIS LICENCE. BY INSTALLING OR  //
//OTHERWISE USING OR COPYING THE SOFTWARE EXAMPLE YOU INDICATE THAT YOU AGREE   //
//TO BE BOUND BY ALL OF THE TERMS OF THIS LICENCE. IF YOU DO NOT AGREE TO THE   //
//TERMS OF THIS LICENCE, ARM IS UNWILLING TO LICENSE THE SOFTWARE EXAMPLE TO    //
//YOU AND YOU MAY NOT INSTALL, USE OR COPY THE SOFTWARE EXAMPLE.                //
//                                                                              //
//ARM hereby grants to you, subject to the terms and conditions of this Licence,//
//a non-exclusive, worldwide, non-transferable, copyright licence only to       //
//redistribute and use in source and binary forms, with or without modification,//
//for academic purposes provided the following conditions are met:              //
//a) Redistributions of source code must retain the above copyright notice, this//
//list of conditions and the following disclaimer.                              //
//b) Redistributions in binary form must reproduce the above copyright notice,  //
//this list of conditions and the following disclaimer in the documentation     //
//and/or other materials provided with the distribution.                        //
//                                                                              //
//THIS SOFTWARE EXAMPLE IS PROVIDED BY THE COPYRIGHT HOLDER "AS IS" AND ARM     //
//EXPRESSLY DISCLAIMS ANY AND ALL WARRANTIES, EXPRESS OR IMPLIED, INCLUDING     //
//WITHOUT LIMITATION WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR //
//PURPOSE, WITH RESPECT TO THIS SOFTWARE EXAMPLE. IN NO EVENT SHALL ARM BE LIABLE/
//FOR ANY DIRECT, INDIRECT, INCIDENTAL, PUNITIVE, OR CONSEQUENTIAL DAMAGES OF ANY/
//KIND WHATSOEVER WITH RESPECT TO THE SOFTWARE EXAMPLE. ARM SHALL NOT BE LIABLE //
//FOR ANY CLAIMS, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, //
//TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE    //
//EXAMPLE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE EXAMPLE. FOR THE AVOIDANCE/
// OF DOUBT, NO PATENT LICENSES ARE BEING LICENSED UNDER THIS LICENSE AGREEMENT.//
//////////////////////////////////////////////////////////////////////////////////


module AHB2MEM
#(parameter MEMWIDTH = 12)					// SIZE = 1KB = 256 Words
(
	//AHBLITE INTERFACE
		//Slave Select Signals
			input wire HSEL,
		//Global Signal
			input wire HCLK,
			input wire HRESETn,
		//Address, Control & Write Data
			input wire HREADY,
			input wire [31:0] HADDR,
			input wire [1:0] HTRANS,
			input wire HWRITE,
			input wire [2:0] HSIZE,
			
			input wire [31:0] HWDATA,
		// Transfer Response & Read Data
			output wire HREADYOUT,
			output wire [31:0] HRDATA,
	//		output wire [7:0] deLED
	
	//LED Output
			output wire [7:0] LED
);


  assign HREADYOUT = 1'b1; // Always ready

// Registers to store Adress Phase Signals

  reg APhase_HSEL;
  reg APhase_HWRITE;
  reg [1:0] APhase_HTRANS;
  reg [31:0] APhase_HADDR;
  reg [2:0] APhase_HSIZE;

// Memory Array  
  reg [31:0] memory[0:(2**(MEMWIDTH-2)-1)];
  

   initial
  begin
memory[0]='h00000C00;
memory[1]='h000001CB;
memory[2]='h00000081;
memory[3]='h00000081;
memory[4]='h00000000;
memory[5]='h00000000;
memory[6]='h00000000;
memory[7]='h00000000;
memory[8]='h00000000;
memory[9]='h00000000;
memory[10]='h00000000;
memory[11]='h00000081;
memory[12]='h00000000;
memory[13]='h00000000;
memory[14]='h00000081;
memory[15]='h00000083;
memory[16]='h00000081;
memory[17]='h00000081;
memory[18]='h00000081;
memory[19]='h00000081;
memory[20]='h00000081;
memory[21]='h00000081;
memory[22]='h00000081;
memory[23]='h00000081;
memory[24]='h00000081;
memory[25]='h00000081;
memory[26]='h00000081;
memory[27]='h00000081;
memory[28]='h00000081;
memory[29]='h00000081;
memory[30]='h00000081;
memory[31]='h00000081;
memory[32]='h48E4E7FE;
memory[33]='h31016881;
memory[34]='h68416081;
memory[35]='hD0764309;
memory[36]='h8109F3EF;
memory[37]='hC1F03920;
memory[38]='h464B4642;
memory[39]='h465D4654;
memory[40]='h3920C13C;
memory[41]='h8809F381;
memory[42]='h43366806;
memory[43]='hD501B2F6;
memory[44]='hE00860C1;
memory[45]='h31200171;
memory[46]='h68CA1809;
memory[47]='hD9022A01;
memory[48]='h8209F3EF;
memory[49]='h2120600A;
memory[50]='h22031809;
memory[51]='h185B0153;
memory[52]='h2C0568DC;
memory[53]='h69DDD108;
memory[54]='h27016944;
memory[55]='h423C40AF;
memory[56]='h433CD115;
memory[57]='hE00A6144;
memory[58]='hD0012C03;
memory[59]='hD10E2C04;
memory[60]='h3C01695C;
memory[61]='hD10A615C;
memory[62]='h2D0468DD;
memory[63]='h681DD005;
memory[64]='h34026BAC;
memory[65]='hF3BF63AC;
memory[66]='h24028F4F;
memory[67]='h3A0160DC;
memory[68]='h2504D5DC;
memory[69]='h36012300;
memory[70]='h40162203;
memory[71]='h18120172;
memory[72]='h68D13220;
memory[73]='hD0122902;
memory[74]='hD00D2901;
memory[75]='hD1F23D01;
memory[76]='h31016901;
memory[77]='h68016101;
memory[78]='h07D22201;
memory[79]='h60014311;
memory[80]='h49B568C0;
memory[81]='hE00E6381;
memory[82]='h21022301;
memory[83]='h003160D1;
memory[84]='h69916001;
memory[85]='h61913101;
memory[86]='hF3816811;
memory[87]='h431B8809;
memory[88]='hF3EFD10D;
memory[89]='hC8F08009;
memory[90]='h68426801;
memory[91]='h46886883;
memory[92]='h469A4691;
memory[93]='h468B68C1;
memory[94]='hF3803010;
memory[95]='hF3BF8809;
memory[96]='h47708F6F;
memory[97]='h4CA64DA5;
memory[98]='hF0002000;
memory[99]='h4300F917;
memory[100]='hB672D119;
memory[101]='h43096829;
memory[102]='hD011D40D;
memory[103]='h19521D0A;
memory[104]='hD20D42A2;
memory[105]='h431B6813;
memory[106]='hD101D405;
memory[107]='h3B041AA3;
memory[108]='h310418C9;
memory[109]='hB2896029;
memory[110]='h186D3104;
memory[111]='hD3E842A5;
memory[112]='hF0002000;
memory[113]='hB662F8F1;
memory[114]='hB672E7FE;
memory[115]='hF3804893;
memory[116]='hF3808808;
memory[117]='hF3EF8809;
memory[118]='h21028014;
memory[119]='hF3804308;
memory[120]='hF3BF8814;
memory[121]='h488B8F6F;
memory[122]='h22012100;
memory[123]='hF0000252;
memory[124]='h488CF8AA;
memory[125]='h498C6841;
memory[126]='h68816041;
memory[127]='h60812100;
memory[128]='h60012107;
memory[129]='hF815F000;
memory[130]='hF81FF000;
memory[131]='hF000B662;
memory[132]='hE7FEF972;
memory[133]='h01404A7F;
memory[134]='h18803020;
memory[135]='h47706081;
memory[136]='h497CB500;
memory[137]='hF86AF000;
memory[138]='h30200140;
memory[139]='h68801840;
memory[140]='h487EBD00;
memory[141]='hBA0921C1;
memory[142]='h60413808;
memory[143]='h3A044976;
memory[144]='h38386001;
memory[145]='h60C84973;
memory[146]='hB51F4770;
memory[147]='h30204871;
memory[148]='h014A2103;
memory[149]='h23001812;
memory[150]='h4B7560D3;
memory[151]='h01CB6053;
memory[152]='h1AE44C74;
memory[153]='h60143C20;
memory[154]='hD5F23901;
memory[155]='hB510BD1F;
memory[156]='h4968B672;
memory[157]='h01532203;
memory[158]='h3320185B;
memory[159]='h2C0068DC;
memory[160]='h3001D10E;
memory[161]='h68196058;
memory[162]='h20C16188;
memory[163]='h61C8BA00;
memory[164]='h60D82001;
memory[165]='h684C495F;
memory[166]='h604C3401;
memory[167]='hE0030010;
memory[168]='hD5E83A01;
memory[169]='h43C02000;
memory[170]='hBD10B662;
memory[171]='h4A59B672;
memory[172]='h32200140;
memory[173]='h61511812;
memory[174]='h290368D1;
memory[175]='h2104D001;
memory[176]='hB66260D1;
memory[177]='h4A534770;
memory[178]='h68100001;
memory[179]='h32200140;
memory[180]='h61511812;
memory[181]='h60D12103;
memory[182]='h4770E7FE;
memory[183]='h21033001;
memory[184]='h014A4B4C;
memory[185]='h18D23220;
memory[186]='h42986853;
memory[187]='h3901D001;
memory[188]='h0008D5F6;
memory[189]='h48474770;
memory[190]='h47706840;
memory[191]='h68004845;
memory[192]='h48444770;
memory[193]='h47706880;
memory[194]='h688A4942;
memory[195]='h00106088;
memory[196]='h49404770;
memory[197]='h32200142;
memory[198]='hB6721852;
memory[199]='h60D32300;
memory[200]='h4C4401C3;
memory[201]='h3C201AE4;
memory[202]='h4B416014;
memory[203]='h684B6053;
memory[204]='hD5003B01;
memory[205]='h604BE7FE;
memory[206]='h4770B662;
memory[207]='hFFDEF7FF;
memory[208]='hFFE7F7FF;
memory[209]='hC002E7FE;
memory[210]='hD1FC3A01;
memory[211]='hB5304770;
memory[212]='h20000004;
memory[213]='hF83DF000;
memory[214]='h21030020;
memory[215]='h43883003;
memory[216]='h4B2F492E;
memory[217]='h4312680A;
memory[218]='hD100D411;
memory[219]='h42904A32;
memory[220]='h1A15D80D;
memory[221]='h42A52404;
memory[222]='h1B2DD909;
memory[223]='hBA242480;
memory[224]='h60084320;
memory[225]='hB2803104;
memory[226]='h60051840;
memory[227]='hB292E005;
memory[228]='h18893104;
memory[229]='hD3E54299;
memory[230]='h000C2100;
memory[231]='hF0002000;
memory[232]='h0020F803;
memory[233]='h4770BD30;
memory[234]='h2301491A;
memory[235]='h43DB4083;
memory[236]='h694AB672;
memory[237]='h614A401A;
memory[238]='h4770B662;
memory[239]='h23014915;
memory[240]='hB6724083;
memory[241]='h0010694A;
memory[242]='hD0134018;
memory[243]='h2001B662;
memory[244]='h49104770;
memory[245]='h40832301;
memory[246]='h694AB672;
memory[247]='hD009401A;
memory[248]='h680AB662;
memory[249]='h32200152;
memory[250]='h61D01852;
memory[251]='h60D02005;
memory[252]='h4770E7FE;
memory[253]='h431A694A;
memory[254]='hB662614A;
memory[255]='h47702000;
memory[256]='h49063804;
memory[257]='hD3034288;
memory[258]='hB2896801;
memory[259]='h47706001;
memory[260]='h47702000;
memory[261]='h00000800;
memory[262]='h00000185;
memory[263]='h00000C00;
memory[264]='h00000E00;
memory[265]='hE000E010;
memory[266]='h000003E8;
memory[267]='h00000B00;
memory[268]='h00000213;
memory[269]='h00001000;
memory[270]='h000001FC;
memory[271]='hB084B580;
memory[272]='h2300AF00;
memory[273]='h200D60FB;
memory[274]='hFF81F7FF;
memory[275]='h60BB0003;
memory[276]='h68BB491A;
memory[277]='h00182204;
memory[278]='hFF75F7FF;
memory[279]='hF7FF2010;
memory[280]='h0003FF76;
memory[281]='h4916607B;
memory[282]='h2204687B;
memory[283]='hF7FF0018;
memory[284]='h68BBFF6A;
memory[285]='hD0032B00;
memory[286]='h001868BB;
memory[287]='hFFC0F7FF;
memory[288]='h05DB23A0;
memory[289]='h00182100;
memory[290]='hF850F000;
memory[291]='hF7FF2002;
memory[292]='h687BFF1A;
memory[293]='hD0032B00;
memory[294]='h0018687B;
memory[295]='hFFB0F7FF;
memory[296]='h05DB23A0;
memory[297]='h00182100;
memory[298]='hF840F000;
memory[299]='hF7FF2044;
memory[300]='h68FBFF0A;
memory[301]='h60FB3301;
memory[302]='h46C0E7C5;
memory[303]='h41414141;
memory[304]='h42424242;
memory[305]='hAF00B580;
memory[306]='h05DB23A0;
memory[307]='h00182103;
memory[308]='hF843F000;
memory[309]='h00DB23FA;
memory[310]='hF7FF0018;
memory[311]='h23A0FEF4;
memory[312]='h210305DB;
memory[313]='hF0000018;
memory[314]='h23FAF851;
memory[315]='h0018011B;
memory[316]='hFEE9F7FF;
memory[317]='hB580E7E8;
memory[318]='h23A0AF00;
memory[319]='h22A005DB;
memory[320]='h681205D2;
memory[321]='h00C92180;
memory[322]='h601A430A;
memory[323]='h00184B05;
memory[324]='hFEADF7FF;
memory[325]='h00184B04;
memory[326]='hFEA9F7FF;
memory[327]='h46BD46C0;
memory[328]='h46C0BD80;
memory[329]='h0000043D;
memory[330]='h000004C5;
memory[331]='hB084B580;
memory[332]='h6078AF00;
memory[333]='h687B6039;
memory[334]='h60FB681B;
memory[335]='h683B2201;
memory[336]='h0013409A;
memory[337]='h68FB001A;
memory[338]='h60FB4053;
memory[339]='h68FA687B;
memory[340]='h46C0601A;
memory[341]='hB00446BD;
memory[342]='hB580BD80;
memory[343]='hAF00B084;
memory[344]='h60396078;
memory[345]='h60FB687B;
memory[346]='h681B68FB;
memory[347]='h220160BB;
memory[348]='h409A683B;
memory[349]='h001A0013;
memory[350]='h431368BB;
memory[351]='h68FB60BB;
memory[352]='h601A68BA;
memory[353]='h46BD46C0;
memory[354]='hBD80B004;
memory[355]='hB084B580;
memory[356]='h6078AF00;
memory[357]='h687B6039;
memory[358]='h68FB60FB;
memory[359]='h60BB681B;
memory[360]='h683B2201;
memory[361]='h0013409A;
memory[362]='h001A43DB;
memory[363]='h401368BB;
memory[364]='h68FB60BB;
memory[365]='h601A68BA;
memory[366]='h46BD46C0;
memory[367]='hBD80B004;
  end

//  deLED <= memory[0][0:7];
// Sample the Address Phase   
  always @(posedge HCLK or negedge HRESETn)
  begin
	 if(!HRESETn)
	 begin
		APhase_HSEL <= 1'b0;
      APhase_HWRITE <= 1'b0;
      APhase_HTRANS <= 2'b00;
		APhase_HADDR <= 32'h0;
		APhase_HSIZE <= 3'b000;
	 end
    else if(HREADY)
    begin
      APhase_HSEL <= HSEL;
      APhase_HWRITE <= HWRITE;
      APhase_HTRANS <= HTRANS;
		APhase_HADDR <= HADDR;
		APhase_HSIZE <= HSIZE;
    end
  end

// Decode the bytes lanes depending on HSIZE & HADDR[1:0]

  wire tx_byte = ~APhase_HSIZE[1] & ~APhase_HSIZE[0];
  wire tx_half = ~APhase_HSIZE[1] &  APhase_HSIZE[0];
  wire tx_word =  APhase_HSIZE[1];
  
  wire byte_at_00 = tx_byte & ~APhase_HADDR[1] & ~APhase_HADDR[0];
  wire byte_at_01 = tx_byte & ~APhase_HADDR[1] &  APhase_HADDR[0];
  wire byte_at_10 = tx_byte &  APhase_HADDR[1] & ~APhase_HADDR[0];
  wire byte_at_11 = tx_byte &  APhase_HADDR[1] &  APhase_HADDR[0];
  
  wire half_at_00 = tx_half & ~APhase_HADDR[1];
  wire half_at_10 = tx_half &  APhase_HADDR[1];
  
  wire word_at_00 = tx_word;
  
  wire byte0 = word_at_00 | half_at_00 | byte_at_00;
  wire byte1 = word_at_00 | half_at_00 | byte_at_01;
  wire byte2 = word_at_00 | half_at_10 | byte_at_10;
  wire byte3 = word_at_00 | half_at_10 | byte_at_11;

// Writing to the memory

  always @(posedge HCLK)
  begin
	 if(APhase_HSEL & APhase_HWRITE & APhase_HTRANS[1])
	 begin
		if(byte0)
			memory[APhase_HADDR[MEMWIDTH:2]][7:0] <= HWDATA[7:0];
		if(byte1)
			memory[APhase_HADDR[MEMWIDTH:2]][15:8] <= HWDATA[15:8];
		if(byte2)
			memory[APhase_HADDR[MEMWIDTH:2]][23:16] <= HWDATA[23:16];
		if(byte3)
			memory[APhase_HADDR[MEMWIDTH:2]][31:24] <= HWDATA[31:24];
	  end
  end

// Reading from memory 
  assign HRDATA = memory[APhase_HADDR[MEMWIDTH:2]];

// Diagnostic Signal out
  assign LED = memory[35][7:0];
  
endmodule