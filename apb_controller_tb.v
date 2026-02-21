`timescale 1ns / 100ps
module apb_controller_tb;
reg hclk,hresetn,valid,hwritereg;
reg [31:0] haddr1,haddr2,hwdata1,hwdata2,prdata;
reg [2:0] tempselx;

wire pwrite,penable;
wire [2:0] pselx;
wire [31:0] paddr, pwdata;

parameter cycle = 10;

apb_controller DUT(.hclk(hclk),.hresetn(hresetn),.valid(valid),.hwritereg(hwritereg),.haddr1(haddr1),.haddr2(haddr2),.hwdata1(hwdata1),
    .hwdata2(hwdata2),.prdata(prdata),.tempselx(tempselx),.pwrite(pwrite),.penable(penable),.pselx(pselx),.paddr(paddr),.pwdata(pwdata));

initial hclk = 0;

always begin
#(cycle/2) hclk = ~hclk;
end
initial
begin
    $dumpfile("apb_controller.vcd");
    $dumpvars(0,apb_controller_tb);
    #cycle;
    hresetn = 1;
    {valid,hwritereg} = 2'b11;
    haddr1 = 32'h8000_0000;
    hwdata1 = 32'h8000_0000;
    tempselx = 3'b001;
    #cycle;
    haddr1 = 32'h8100_0000;
    hwdata1 = 32'h8100_0000;
    haddr2 = 32'h8200_0000;
    hwdata2 = 32'h8200_0000;
    #cycle;
    hresetn = 0;
    #cycle;
    hresetn = 1;
    #(cycle);    
    $finish;
end

endmodule