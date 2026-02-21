`timescale 1ns/100ps

module top_module_tb;

reg hclk,hresetn,hwrite,hreadyin;
reg [31:0] hwdata,haddr,prdata;
reg [1:0]  htrans;

wire pwrite,penable;
wire [2:0] pselx;
wire [31:0] paddr,pwdata,hrdata;
wire [1:0]  hresp;

bridge_top DUT(hclk,hresetn,hwrite,hreadyin,hwdata,haddr,prdata,htrans,pwrite,penable,pselx,paddr,pwdata,hrdata,hresp);

always #5 hclk = ~hclk;

initial
begin
	{hclk,hwrite,hreadyin,hwdata,haddr,prdata,htrans} = 0;
end

initial
begin
	$dumpfile("top_module.vcd");
	$dumpvars(0,top_module_tb);
	hresetn = 0;
	#10 hresetn = 1;
	hwrite = 1;
	hreadyin = 1;
	hwdata = 32'h8000_0000;
	haddr = 32'h8000_0000;
	htrans = 2'b11;
	#10
	hwdata = 32'h8400_0000;
	haddr = 32'h8400_0000;
	#10
	hwrite = 0;
	htrans = 0;
	$finish;
end

endmodule