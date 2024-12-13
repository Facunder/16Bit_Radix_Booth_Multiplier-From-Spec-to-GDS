// compress three pp_(2) to sum and carry
// ps: carry is 1-bit front than sum 
module compressor32 #(parameter DATA_WIDTH = 8)
(
  input  [DATA_WIDTH - 1 : 0]  in1,
  input  [DATA_WIDTH - 1 : 0]  in2,
  input  [DATA_WIDTH - 1 : 0]  in3,
  output [DATA_WIDTH - 1 : 0]  sum, 
  output [DATA_WIDTH - 1 : 0]  carry
);
    generate
        genvar i;
        for (i = 0; i < DATA_WIDTH; i = i + 1) begin : bit_csa_unit
            assign sum[i] = in1[i] ^ in2[i] ^ in3[i];
            assign carry[i] = in1[i] & in2[i] | in2[i] & in3[i] | in3[i] &in1[i];
        end
    endgenerate
endmodule

// wallace tree compress using 3:2 CSA compressor
module WallaceTree (
    input  [16:0] pp0, // i.e. partial product
    input  [16:0] pp1,
    input  [16:0] pp2,
    input  [16:0] pp3,
    input  [16:0] pp4,
    input  [16:0] pp5,
    input  [16:0] pp6,
    input  [16:0] pp7,
    output [31:0] final_sum,
    output [31:0] final_carry
);

    wire [20:0] l1_u1_sum, l1_u2_sum, l1_u1_carry, l1_u2_carry;
    
    wire [26:0] l2_u1_sum, l2_u1_carry;
    wire [23:0] l2_u2_sum, l2_u2_carry;
    
    wire [30:0] l3_u1_sum, l3_u1_carry;

    wire [31:0] l4_u1_sum, l4_u1_carry;
    
    // Stage 1: 8 -> 6 (6 + 2 -> 4 + 2)
    // length = 17 + 4
    compressor32 #(.DATA_WIDTH(21)) cp32_l1_u1(
        .in1({{4{pp0[16]}}, pp0}),
        .in2({{2{pp1[16]}}, pp1, 2'b0}), 
        .in3({pp2, 4'b0}), 
        .sum(l1_u1_sum), 
        .carry(l1_u1_carry)
    ); 
    compressor32 #(.DATA_WIDTH(21)) cp32_l1_u2(
        .in1({{4{pp3[16]}}, pp3}),
        .in2({{2{pp4[16]}}, pp4, 2'b0}), 
        .in3({pp5, 4'b0}), 
        .sum(l1_u2_sum), 
        .carry(l1_u2_carry)
    ); 

    // Stage 2: 6 -> 4
    // // length = 21 + 6
    compressor32 #(.DATA_WIDTH(27)) cp32_l2_u1(
        .in1({{6{l1_u1_sum[20]}}, l1_u1_sum}),
        .in2({{5{l1_u1_carry[20]}}, l1_u1_carry, 1'b0}), 
        .in3({l1_u2_sum, 6'b0}), 
        .sum(l2_u1_sum), 
        .carry(l2_u1_carry)
    ); 
    // // length = 21 + 3
    compressor32 #(.DATA_WIDTH(24)) cp32_l2_u2(
        .in1({{3{l1_u2_carry[20]}}, l1_u2_carry}),
        .in2({{2{pp6[16]}}, pp6, 5'b0}), 
        .in3({pp7, 7'b0}), 
        .sum(l2_u2_sum), 
        .carry(l2_u2_carry)
    ); 

    // Stage 3: 4 -> 3
    // length = 27 + 4
    compressor32 #(.DATA_WIDTH(31)) cp32_l3_u1( 
        .in1({{4{l2_u1_sum[26]}}, l2_u1_sum}),
        .in2({{3{l2_u1_carry[26]}}, l2_u1_carry, 1'b0}), 
        .in3({l2_u2_sum, 7'b0}), 
        .sum(l3_u1_sum), 
        .carry(l3_u1_carry)
    ); 

    // Stage 4: 3 -> 2
    // length = 31 + 1
    compressor32 #(.DATA_WIDTH(32)) cp32_l4_u1( 
        .in1({l3_u1_sum[30], l3_u1_sum}),
        .in2({l3_u1_carry, 1'b0}), 
        .in3({l2_u2_carry, 8'b0}), 
        .sum(l4_u1_sum), 
        .carry(l4_u1_carry)
    );

    assign final_sum = l4_u1_sum;
    assign final_carry = {l4_u1_carry[30:0], 1'b0};

endmodule
