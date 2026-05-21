`timescale 1ns / 1ps
module tb_mat_mul;
parameter int N = 8;
logic clk;
logic rst_n;
logic [N-1:0] a_row_0, a_row_1;
logic [N-1:0] b_col_0, b_col_1;
logic [2*N-1:0] c00, c01, c10, c11;

mat_mul #(.N(N)) dut(
    .clk(clk),
    .rst_n(rst_n),
    .a_row_0(a_row_0),
    .a_row_1(a_row_1),
    .b_col_0(b_col_0),
    .b_col_1(b_col_1),
    .c00(c00), .c01(c01), .c10(c10), .c11(c11)
);
always #5 clk = ~clk;

initial begin
    clk = 0;
    rst_n = 0;
    a_row_0 = 0; a_row_1 = 0;
    b_col_0 = 0; b_col_1 = 0;

    // test 1: from your waveform
    // A = [[4,3],[2,1]]  B = [[8,7],[6,5]]
    // expected: C[0][0]=50, C[0][1]=43, C[1][0]=22, C[1][1]=19
    repeat(2) @(posedge clk);
    rst_n = 1;

    // cycle 1: A00, B00
    @(negedge clk);
    a_row_0 = 8'd4; a_row_1 = 8'd0;
    b_col_0 = 8'd8; b_col_1 = 8'd0;
    // cycle 2: A01,A10 / B10,B01
    @(negedge clk);
    a_row_0 = 8'd3; a_row_1 = 8'd2;
    b_col_0 = 8'd6; b_col_1 = 8'd7;
    // cycle 3: A11 / B11
    @(negedge clk);
    a_row_0 = 8'd0; a_row_1 = 8'd1;
    b_col_0 = 8'd0; b_col_1 = 8'd5;
    // drain
    @(negedge clk);
    a_row_0 = 0; a_row_1 = 0; b_col_0 = 0; b_col_1 = 0;
    repeat(3) @(posedge clk);

    // test 2: identity x identity
    // expected: C = identity (1,0,0,1)
    rst_n = 0;
    a_row_0 = 0; a_row_1 = 0; b_col_0 = 0; b_col_1 = 0;
    repeat(2) @(posedge clk);
    rst_n = 1;

    @(negedge clk);
    a_row_0 = 8'd1; a_row_1 = 8'd0;
    b_col_0 = 8'd1; b_col_1 = 8'd0;
    @(negedge clk);
    a_row_0 = 8'd0; a_row_1 = 8'd0;
    b_col_0 = 8'd0; b_col_1 = 8'd0;
    @(negedge clk);
    a_row_0 = 8'd0; a_row_1 = 8'd1;
    b_col_0 = 8'd0; b_col_1 = 8'd1;
    @(negedge clk);
    a_row_0 = 0; a_row_1 = 0; b_col_0 = 0; b_col_1 = 0;
    repeat(3) @(posedge clk);

    // test 3: zero A, nonzero B
    // expected: C = all zeros
    rst_n = 0;
    a_row_0 = 0; a_row_1 = 0; b_col_0 = 0; b_col_1 = 0;
    repeat(2) @(posedge clk);
    rst_n = 1;

    @(negedge clk);
    a_row_0 = 8'd0; a_row_1 = 8'd0;
    b_col_0 = 8'd9; b_col_1 = 8'd0;
    @(negedge clk);
    a_row_0 = 8'd0; a_row_1 = 8'd0;
    b_col_0 = 8'd2; b_col_1 = 8'd3;
    @(negedge clk);
    a_row_0 = 8'd0; a_row_1 = 8'd0;
    b_col_0 = 8'd0; b_col_1 = 8'd7;
    @(negedge clk);
    a_row_0 = 0; a_row_1 = 0; b_col_0 = 0; b_col_1 = 0;
    repeat(3) @(posedge clk);

    // test 4: larger values
    // A = [[15,10],[12,8]]  B = [[20,15],[5,25]]
    // expected: C[0][0]=350, C[0][1]=475, C[1][0]=280, C[1][1]=380
    rst_n = 0;
    a_row_0 = 0; a_row_1 = 0; b_col_0 = 0; b_col_1 = 0;
    repeat(2) @(posedge clk);
    rst_n = 1;

    @(negedge clk);
    a_row_0 = 8'd15; a_row_1 = 8'd0;
    b_col_0 = 8'd20; b_col_1 = 8'd0;
    @(negedge clk);
    a_row_0 = 8'd10; a_row_1 = 8'd12;
    b_col_0 = 8'd5;  b_col_1 = 8'd15;
    @(negedge clk);
    a_row_0 = 8'd0;  a_row_1 = 8'd8;
    b_col_0 = 8'd0;  b_col_1 = 8'd25;
    @(negedge clk);
    a_row_0 = 0; a_row_1 = 0; b_col_0 = 0; b_col_1 = 0;
    repeat(3) @(posedge clk);

    $finish;
end
endmodule