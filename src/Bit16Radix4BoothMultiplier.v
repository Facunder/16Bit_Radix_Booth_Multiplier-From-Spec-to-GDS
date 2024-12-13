// two unsigned binary variables multiply
// extend unsigned binary to signed binary
// thus can use signed radix-4 booth method
module Bit16Radix4BoothMultiplier(
    input [15 : 0] A,
    input [15 : 0] B,
    output [31 : 0] product
);

wire [16 : 0] extend_B = {B, 1'b0}; // extend sign bit for Booth_13
wire [16 : 0] partial_sum [7 : 0]; // 15+1
wire [31 : 0] final_sum;
wire [31 : 0] final_carry;
wire tmp_cout;

// Radix-4 Booth Encode, generate partial sum
generate 
        genvar i;
        for (i = 0; i < 8; i = i + 1) begin : Booth_Encoders
            Radix4BoothEncoder #(.length(16)) booth_encoder (
                .A(A),
                .partial_B(extend_B[2 * i + 2 : 2 * i]),
                .P_reg(partial_sum[i])
            );
        end
endgenerate

// Wallace Tree Compress
WallaceTree wallace_tree(
    .pp0(partial_sum[0]),
    .pp1(partial_sum[1]),   
    .pp2(partial_sum[2]),
    .pp3(partial_sum[3]),
    .pp4(partial_sum[4]),
    .pp5(partial_sum[5]),
    .pp6(partial_sum[6]),
    .pp7(partial_sum[7]),
    .final_sum(final_sum),
    .final_carry(final_carry)
);

// final add and truncation
// bit redundancy for sign-bit extension
// assign product = final_sum + final_carry; 
SqrtCarrySelectAdder #(.WIDTH(32)) sqrt_carry_select_adder(
    .a(final_sum[31:0]),
    .b(final_carry[31:0]),
    .cin(1'b0),
    .sum(product),
    .cout(tmp_cout)
);

endmodule