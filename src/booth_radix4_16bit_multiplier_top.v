module booth_radi4_16bit_multiplier_top(
    input clk,
    input rst_n,
    input [15:0] a,
    input [15:0] b,
    output reg [31:0] product
);

wire [16:0] partial_sum [7:0]; 

wire opt_bit_S, opt_bit_E;
wire [19:0] extend_pp_0, extend_pp_7;
wire [20:0] extend_pp_1, extend_pp_2, extend_pp_3, extend_pp_4, extend_pp_5, extend_pp_6;

/********** Stage1: Booth Encode and Symbol bit extension optimization method **********/
generate 
        genvar i;
        for (i = 0; i < 8; i = i + 1) begin : Booth_Encoders
            radix4_booth_encoder #(.WIDTH(16)) booth_encoder (
                .A(A),
                .partial_B(extend_B[2 * i + 2 : 2 * i]),
                .P_reg(partial_sum[i]),
                .S(opt_bit_S[i]),
                .E(opt_bit_E[i])
            );
        end
endgenerate

assign extend_pp_0 = {opt_bit_E[0], ~opt_bit_E[0], ~opt_bit_E[0], partial_sum[0]};
assign extend_pp_1 = {1'b1, opt_bit_E[1], partial_sum[1], 1'b0, opt_bit_S[0]};
assign extend_pp_2 = {1'b1, opt_bit_E[2], partial_sum[2], 1'b0, opt_bit_S[1]};
assign extend_pp_3 = {1'b1, opt_bit_E[3], partial_sum[3], 1'b0, opt_bit_S[2]};
assign extend_pp_4 = {1'b1, opt_bit_E[4], partial_sum[4], 1'b0, opt_bit_S[3]};
assign extend_pp_5 = {1'b1, opt_bit_E[5], partial_sum[5], 1'b0, opt_bit_S[4]};
assign extend_pp_6 = {1'b1, opt_bit_E[6], partial_sum[6], 1'b0, opt_bit_S[5]};
assign extend_pp_7 = {opt_bit_E[7], partial_sum[7], 1'b0, opt_bit_S[6]};

// Pipeline: Stage1 -> Stage2
reg rest_opt_bit_S_reg;
reg [19:0] extend_pp_0_reg, extend_pp_7_reg;
reg [20:0] extend_pp_1_reg, extend_pp_2_reg, extend_pp_3_reg, extend_pp_4_reg, extend_pp_5_reg, extend_pp_6_reg;
always @(posedge clk) begin
    if(~rst_n) begin
        extend_pp_0_reg <= 0;
        extend_pp_1_reg <= 0;
        extend_pp_2_reg <= 0;
        extend_pp_3_reg <= 0;
        extend_pp_4_reg <= 0;
        extend_pp_5_reg <= 0;
        extend_pp_6_reg <= 0;
        extend_pp_7_reg <= 0;
        rest_opt_bit_S_reg <= 0;
    end else begin
        extend_pp_0_reg <= extend_pp_0;
        extend_pp_1_reg <= extend_pp_1;
        extend_pp_2_reg <= extend_pp_2;
        extend_pp_3_reg <= extend_pp_3;
        extend_pp_4_reg <= extend_pp_4;
        extend_pp_5_reg <= extend_pp_5;
        extend_pp_6_reg <= extend_pp_6;
        extend_pp_7_reg <= extend_pp_7;
        rest_opt_bit_S_reg <= opt_bit_S[7];
    end
end

/********** Stage2: Vanilla Wallace Tree Compress **********/
wire [31:0] compressed_final_part_0, compressed_final_part_1;
wallace_tree_compressor wallace_tree_compressor_inst(
    .pp0(extend_pp_0_reg),
    .pp1(extend_pp_1_reg),
    .pp2(extend_pp_2_reg),
    .pp3(extend_pp_3_reg),
    .pp4(extend_pp_4_reg),
    .pp5(extend_pp_5_reg),
    .pp6(extend_pp_6_reg),
    .pp7(extend_pp_7_reg),
    .rest_S(rest_opt_bit_S_reg),
    .final_part_0(),
    .final_part_1()
);

// Pipeline: Stage2 -> Stage3
reg [31:0] compressed_final_part_0_reg, compressed_final_part_1_reg;
always @(posedge clk) begin
    if(~rst_n) begin
        compressed_final_part_0_reg <= 0;
        compressed_final_part_1_reg <= 0;
    end else begin
        compressed_final_part_0_reg <= compressed_final_part_0;
        compressed_final_part_1_reg <= compressed_final_part_1;
    end
end

/********** Stage3: Final Addition **********/
wire [31:0] compressed_final_parts_sum;
sqrt_carry_select_adder #(.WIDTH(16))sqrt_carry_select_adder_inst(
    .A(compressed_final_part_0_reg),
    .B(compressed_final_part_1_reg),
    .C_in(1'b0),
    .S(compressed_final_parts_sum)
);

assign product = compressed_final_parts_sum;

endmodule;