
`timescale 1ns/100ps

module ahb_slave_tb;
  parameter CYCLE = 10;

  reg hclk, hresetn;
  reg hwrite, hreadyin;
  reg [31:0] hwdata, haddr, prdata;
  reg [1:0] htrans;
  wire [1:0] hresp;
  wire [31:0] hrdata;
  wire valid;
  wire [31:0] haddr1, haddr2, hwdata1, hwdata2;
  wire [2:0] tempselx;
  wire hwritereg;

  // Instantiate the AHB Slave
  ahb_slave DUT (
    .hclk(hclk),
    .hresetn(hresetn),
    .hwrite(hwrite),
    .hreadyin(hreadyin),
    .hwdata(hwdata),
    .haddr(haddr),
    .prdata(prdata),
    .htrans(htrans),
    .hresp(hresp),
    .hrdata(hrdata),
    .valid(valid),
    .haddr1(haddr1),
    .haddr2(haddr2),
    .hwdata1(hwdata1),
    .hwdata2(hwdata2),
    .tempselx(tempselx),
    .hwritereg(hwritereg)
  );

  // Clock generation
  always #(CYCLE/2) hclk = ~hclk;

  initial begin
    $dumpfile("ahb_slave.vcd");
    $dumpvars(0, ahb_slave_tb);

    // Initial reset
    hresetn = 0;
    hclk = 0;
    hwrite = 0;
    hreadyin = 1;
    hwdata = 0;
    haddr = 0;
    htrans = 2'b00;
	prdata = 32'b3000_0000;
    #20;
    hresetn = 1;

    // Test write
    haddr = 32'h8000_0000;
    hwrite = 1;
    htrans = 2'b10;
    hwdata = 32'hDEAD_BEEF;
    #CYCLE;

    // Test read
    hwrite = 0;
    #CYCLE;

    // Test invalid address
    haddr = 32'h9000_0000;
    hwrite = 0;
    htrans = 2'b10;
    #CYCLE;

    $finish;
  end
endmodule  