module mat_mul#(parameter N = 8)(
    input logic clk ,rst_n,
    input logic [N-1:0] a_row_0, a_row_1,
    input logic [N-1:0] b_col_0, b_col_1,
    output logic [2*N-1:0] c00, c01, c10, c11
    );
    logic [N-1:0] a00_to_a01, a10_to_a11;
    logic [N-1:0] b00_to_b10, b01_to_b11;
    
    pe_block #(N) pe00(
    .clk, .rst_n, .en(1'b1),
    .a(a_row_0), .b(b_col_0),
    .a_out(a00_to_a01), .b_out(b00_to_b10), .acc(c00)
);
pe_block #(N) pe01(
    .clk, .rst_n, .en(1'b1),
    .a(a00_to_a01), .b(b_col_1),
    .a_out(), .b_out(b01_to_b11), .acc(c01)
);
pe_block #(N) pe10(
    .clk, .rst_n, .en(1'b1),
    .a(a_row_1), .b(b00_to_b10),
    .a_out(a10_to_a11), .b_out(), .acc(c10)
);
pe_block #(N) pe11(
    .clk, .rst_n, .en(1'b1),
    .a(a10_to_a11), .b(b01_to_b11),
    .a_out(), .b_out(), .acc(c11)
);
endmodule
