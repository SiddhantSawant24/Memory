`include "memory.v"
module tb;
parameter DEPTH=16;
parameter WIDTH=8;
parameter ADDR_WIDTH=$clog2(DEPTH);

//declaring input ports
reg clk_i,clr_i,wr_rd_en_i,valid_i;
reg [ADDR_WIDTH-1:0]addr_i;
reg [WIDTH-1:0]wdata_i;

//declaring output ports
wire [WIDTH-1:0]rdata_o;
wire ready_o;

//declaring memory
wire[WIDTH-1:0]mem[DEPTH-1:0];

integer i;

memory #(.WIDTH(WIDTH),.DEPTH(DEPTH),.ADDR_WIDTH(ADDR_WIDTH)) dut (.*);

always #5 clk_i=~clk_i;

task reset();
	begin
	valid_i=0;
	wdata_i=0;
	addr_i=0;
	wr_rd_en_i=0;
	end
endtask

task write();
	begin
	for(i=0;i<9;i=i+1)begin 
		@(posedge clk_i);
		addr_i=i; //Setting a counter so that the write operation can be done at all the locations of memory
		wdata_i=$random; //Random values to write into memory
		wr_rd_en_i=1; //When ReadWriteEnable is high it performs write operation
		valid_i=1;
		wait(ready_o==1);
	end

	@(posedge clk_i)begin  //Clearing all the operations
	valid_i=0;
	wdata_i=0;
	addr_i=0;
	wr_rd_en_i=0;
	end
end
endtask

task read();
	begin
		for(i=9;i<DEPTH;i=i+1)begin
		@(posedge clk_i);
		addr_i=i;
		wr_rd_en_i=0;   //Read operation is performed when ReadWriteEnable is Low
		valid_i=1;
		wait (ready_o==1);
		end
	end
endtask

initial begin
clk_i=0;clr_i=1;
reset();
clr_i=0;
fork
write();
read();
join
end

initial begin
#500;
$finish();
end

endmodule

	












