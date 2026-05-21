module pe_block#(parameter N = 8)(
    input logic clk,
    input logic rst_n,
    input logic en, //from left neighbor
    input logic [N-1:0] a,
    input logic [N-1:0] b,
    output logic [N-1:0] a_out, //to the next-neighbor
    output logic [N-1:0] b_out, // to the next neighbor
    output logic[2*N-1:0] acc
    );
    
    always_ff @(posedge clk) begin
        if (!rst_n) begin
            acc <= '0;
            a_out <= '0;
            b_out <= '0;
        end
        else if (en) begin
            acc <= acc + a * b; //mac
            a_out <= a;  //pass operand right
            b_out <= b;  //pass operand down
        end
      end
endmodule
