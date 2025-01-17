module memory(clk_i,clr_i,addr_i,wdata_i,rdata_o,wr_rd_en_i,valid_i,ready_o);
//parameter declaration
parameter DEPTH=16;
parameter WIDTH=8;
parameter ADDR_WIDTH=$clog2(DEPTH);

//input port declaration
input clk_i,clr_i,wr_rd_en_i,valid_i;
input [WIDTH-1:0]wdata_i;
input [ADDR_WIDTH-1:0]addr_i;

//output port declaration
output reg ready_o;
output reg [WIDTH-1:0]rdata_o;

//memory declaration
reg [WIDTH-1:0] mem[DEPTH-1:0];
integer i;

always @(posedge clk_i)begin
	if (clr_i)begin  //if clear is high set all reg data types to low.
		ready_o=0;
		rdata_o=0;
		for(i=0;i<DEPTH;i=i+1)begin
			mem[i]=0;
		end
	end

	else begin
		if(valid_i)begin
			ready_o=1;    //handshaking is done.

			if(wr_rd_en_i)begin  //when read write enable is high them write operation will be performed
			mem[addr_i]=wdata_i;
			end
			else begin
			rdata_o=mem[addr_i];
			end
		end
		else begin
		ready_o=0;
		end
	end
end
endmodule






