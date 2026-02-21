module apb_controller(input hclk,hresetn,valid,hwritereg,
	input [31:0] haddr1,haddr2,hwdata1,hwdata2,prdata,input [2:0]tempselx,
    output reg  pwrite,penable,output reg [2:0] pselx,output reg [31:0] pwdata,paddr);

reg [2:0] present,next;
parameter idle = 3'b000, wwait = 3'b001, read = 3'b010,
	write = 3'b011, writep = 3'b100, wenablep = 3'b101,
	wenable = 3'b110, renable = 3'b111;

always@(posedge hclk)
begin
    if(!hresetn)
        present <= idle;
    else
        present <= next;
end

always@(valid, hwritereg)
begin
    case(present)
        idle:begin
            if(valid && hwritereg)
                next = wwait;
            else if(valid && !hwritereg)
                next = read;
            else
                next = idle;
        end
        wwait:begin
            if(valid)
                next = writep;
            else
                next = write;
        end
        read: next = renable;
        write:begin
            if(valid)
                next = wenablep;
            else
                next = wenable;
        end
        writep: next = wenablep;
        wenablep:begin
            if(valid && hwritereg)
                next = writep;
            else if(!valid && hwritereg)
                next = write;
             else
                next = wenable;
        end
        wenable:begin
            if(valid && hwritereg)
                next = wwait;
            else if(valid && !hwritereg)
                next = read;
            else
                next = idle;
        end
        renable:begin
            if(valid && !hwritereg)
                next = read;
            else if(valid && hwritereg)
                next = wwait;
            else
                next = idle;
        end
        default:next = idle;
endcase
end

always @(present) begin
        pwrite  = 0;
        penable = 0;
        pselx   = 0;
        paddr   = 0;
        pwdata  = 0;

        case (present)
            read: begin
                pselx   = tempselx;
                paddr   = haddr1;
                pwrite  = 0;
                penable = 0; // Setup phase
            end
            renable: begin
                pselx   = tempselx;
                paddr   = haddr1;
                pwrite  = 0;
                penable = 1; // Access phase
            end
            wwait: begin
                // Waiting for data phase of AHB
                pselx   = 0;
                penable = 0;
            end
            write: begin
                pselx   = tempselx;
                paddr   = haddr1; 
                pwrite  = 1;
                pwdata  = hwdata1;
                penable = 0; // Setup phase
            end
            writep: begin
                pselx   = tempselx;
                paddr   = haddr1; 
                pwrite  = 1;
                pwdata  = hwdata1;
                penable = 0; // Setup phase
            end
            wenable: begin
                pselx   = tempselx;
                paddr   = haddr2;
                pwrite  = 1;
                pwdata  = hwdata2;
                penable = 1; // Access phase
            end
            wenablep: begin
                pselx   = tempselx;
                paddr   = haddr2;
                pwrite  = 1;
                pwdata  = hwdata2;
                penable = 1; // Access phase
            end
    endcase
end

endmodule