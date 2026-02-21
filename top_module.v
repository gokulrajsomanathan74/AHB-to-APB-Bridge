module bridge_top (
    input         hclk,
    input         hresetn,
    input         hwrite,
    input         hreadyin,
    input  [31:0] hwdata,
    input  [31:0] haddr,
    input  [31:0] prdata,
    input  [1:0]  htrans,

    output        pwrite,
    output        penable,
    output [2:0]  pselx,
    output [31:0] paddr,
    output [31:0] pwdata,
    output [31:0] hrdata,
    output [1:0]  hresp
);

    wire          valid;
    wire          hwrite_reg;
    wire [31:0]   hwdata_1, hwdata_2;
    wire [31:0]   haddr_1, haddr_2;
    wire [2:0]    temp_selx;
    
    apb_controller apb_c (hclk,hresetn,valid,hwrite_reg,haddr_1,haddr_2,hwdata_1,hwdata_2,prdata,temp_selx,
    pwrite,penable,pselx,pwdata,paddr);
    
    ahb_slave ahb_s (
        hclk,
        hresetn,
        hwrite,
        hreadyin,
        htrans,
        haddr,
        hwdata,
        prdata,
        valid,
        hwrite_reg,
        hresp,
        temp_selx,
        haddr_1,
        haddr_2,
        hwdata_1,
        hwdata_2,
        hrdata
    );

    

endmodule
