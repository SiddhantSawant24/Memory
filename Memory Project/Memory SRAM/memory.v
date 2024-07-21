module memory(clk_i,clr_i,addr_i,wdata_i,rdata_o,wr_rd_en_i,valid_i,ready_o);
//parameter declaration
parameter DEPTH=16;
parameter WIDTH=8;
parameter ADDR_WIDTH=$clog2(DEPTH);

//declaring input ports
input clk_i,clr_i,wr_rd_en_i,valid_i;
input [ADDR_WIDTH-1:0]addr_i;
input [WIDTH-1:0]wdata_i;

//declaring output ports
output reg [WIDTH-1:0]rdata_o;
output reg ready_o;

//declaring memory
reg[WIDTH-1:0]mem[DEPTH-1:0];

integer i;

always @(posedge clk_i)begin
	if(clr_i)begin   //if clear is high set all the reg ports to 0
		rdata_o=0;
		ready_o=0;
			for(i=0;i<DEPTH;i=i+1) begin
				mem[i]=0;
			end
		end
	
	else begin
		if (valid_i)begin
		ready_o=1;     //Valid is high and ready also becomes high leading to handshaking and allows CPU to access memory
			if (wr_rd_en_i)begin      //if ReadWriteEnable is high write the signal
				mem[addr_i]=wdata_i;
				end
			else begin                //if ReadWriteEnable is low then read the signal
				rdata_o=mem[addr_i];
				end
			end

		else begin
			ready_o=0;
		end
	end
end
endmodule
