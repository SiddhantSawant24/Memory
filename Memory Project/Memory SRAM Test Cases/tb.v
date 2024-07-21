`include "memory.v"
module tb;
parameter DEPTH=16;
parameter WIDTH=8;
parameter ADDR_WIDTH=$clog2(DEPTH);

//input port declaration
reg clk_i,clr_i,wr_rd_en_i,valid_i;
reg [WIDTH-1:0]wdata_i;
reg [ADDR_WIDTH-1:0]addr_i;

//output port declaration
wire ready_o;
wire [WIDTH-1:0]rdata_o;

//memory declaration
wire [WIDTH-1:0] mem[DEPTH-1:0];

reg [8*100:0] testcase;  //String for testcase

integer i;

memory #(.WIDTH(WIDTH),.DEPTH(DEPTH),.ADDR_WIDTH(ADDR_WIDTH)) dut (.*);

always #5 clk_i=~clk_i;

task reset();
	begin
	addr_i=0;
	wdata_i=0;
	valid_i=0;
	wr_rd_en_i=0;
	// All these are set to 0 because theyll give dont care values initially.
	end
endtask

task fd_write(input reg [ADDR_WIDTH-1:0]start_loc, input reg [ADDR_WIDTH-1:0]inc_loc); //Passing starting loaction and increment  as parameters
	begin
	for(i=start_loc;i<=start_loc+inc_loc;i=i+1)begin  //End location = start location + increment
		@(posedge clk_i)
		wr_rd_en_i=1;
		addr_i=i;
		wdata_i=$random();
		valid_i=1;
		wait (ready_o==1);
		end
	
		@(posedge clk_i);
			reset();
	end
endtask


task fd_read(input reg [ADDR_WIDTH-1:0]start_loc, input reg [ADDR_WIDTH-1:0]inc_loc);
	begin
	for(i=start_loc;i<=start_loc+inc_loc;i=i+1)begin
		@(posedge clk_i)
		addr_i=i;
		wr_rd_en_i=0;
		valid_i=1;
		wait (ready_o==1);
		end

		@(posedge clk_i);
			reset();
	end
endtask


task bd_write();  //Writing to memory from file
	begin
		$readmemh("read_mem.h",dut.mem); 
	end
endtask


task bd_read();  //Reading into the file from memory
	begin
		$writememh("write_mem.h",dut.mem); 
	end
endtask


initial begin
clk_i=0;
clr_i=1;
reset();
#30;
clr_i=0;
$value$plusargs("testcase=%s",testcase);
	case (testcase)
		"fd_write_fd_read":begin
			fd_write(0,DEPTH-1);
			fd_read(0,DEPTH-1);
		end

		"bd_write_bd_read":begin
			bd_write();
			bd_read();
		end

		"fd_write_bd_read":begin
			fd_write(0,DEPTH-1);
			bd_read();
		end

		"bd_write_fd_read":begin
			bd_write();
			fd_read(0,DEPTH-1);
		end
	endcase
end

initial begin
#500;
$finish();
end
endmodule











	
