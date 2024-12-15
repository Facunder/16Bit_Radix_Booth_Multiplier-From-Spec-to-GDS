module half_adder(
    input A,
    input B,
    output S,
    output Cout
);
    assign S = A ^ B;
    assign Cout = A & B;
endmodule

// Unit 3:2 Compressor
module full_adder(
    input A,
    input B,
    input C,
    output S,
    output Cout
);
    assign S = A ^ B ^ C;
    assign Cout = (A & B) | (B & C) | (A & C);
endmodule

module wallace_tree_compressor(
    input [19:0] pp0,
    input [20:0] pp1,
    input [20:0] pp2,
    input [20:0] pp3,
    input [20:0] pp4,
    input [20:0] pp5,
    input [20:0] pp6,
    input [19:0] pp7,
    input rest_S,
    output [31:0] final_part_0,
    output [31:0] final_part_1
);

// level 0
// rearrange partial products
wire [31:0] rearranged_pp0;
wire [30:0] rearranged_pp1; 
wire [26:0] rearranged_pp2; 
wire [22:0] rearranged_pp3;
wire [18:0] rearranged_pp4;
wire [14:0] rearranged_pp5;
wire [10:0] rearranged_pp6;
wire [7:0] rearranged_pp7;
wire rearranged_pp8;

assign rearranged_pp0 = {pp7[19:8], pp0};
assign rearranged_pp1 = {pp6[20:11], pp1};
assign rearranged_pp2 = {pp5[20:15], pp2};
assign rearranged_pp3 = {pp4[20:19], pp3};
assign rearranged_pp4 = pp4[18:0];
assign rearranged_pp5 = pp5[14:0];
assign rearranged_pp6 = pp6[10:0];
assign rearranged_pp7 = pp6[7:0];
assign rearranged_pp8 = rest_S;

// level 1 
// half_adder * 6 
// raw: 9 -> 8
wire [5:0] l1_ha_S;
wire [5:0] l1_ha_Cout;

half_adder l1_ha_0(
    .A(rearranged_pp7[2]),
    .B(rearranged_pp8),
    .S(l1_ha_S[0]),
    .Cout(l1_ha_Cout[0])
);

generate
    genvar i;
    for(i = 0; i < 5; i = i + 1) begin : L1_HA_GEN
        half_adder l1_ha_i(
            .A(rearranged_pp6[i+5]),
            .B(rearranged_pp7[i+3]),
            .S(l1_ha_S[i+1]),
            .Cout(l1_ha_Cout[i+1])
        );
    end
endgenerate

// level 2
// full_adder * 8 & half_adder * 1
// raw: 8 -> 7
wire [10:0] l2_rearranged_pp6;
wire [8:0] l2_rearranged_pp7;
assign l2_rearranged_pp6 = {rearranged_pp6[10], l1_ha_S[5:1], rearranged_pp6[4:0]};
assign l2_rearranged_pp7 = {l1_ha_Cout[5:0], l1_ha_S[0], rearranged_pp7[1:0]};

wire l2_ha_S, l2_ha_Cout;
wire [7:0] l2_fa_S, l2_fa_Cout;
half_adder l2_ha_0(
    .A(l2_rearranged_pp7[0]),
    .B(l2_rearranged_pp6[0]),
    .S(l2_ha_S),
    .Cout(l2_ha_Cout)
);

generate
    genvar n;
    for(n = 0; n < 8; n = n + 1) begin : L2_FA_GEN
        full_adder l2_fa_i(
            .A(rearranged_pp5[n+5]),
            .B(l2_rearranged_pp6[n+3]),
            .C(l2_rearranged_pp7[n+1]),
            .S(l2_fa_S[n]),
            .Cout(l2_fa_Cout[n])
        );
    end
endgenerate

// level 3
// full_adder * 11 & half_adder * 2 
// raw: 7 -> 6
wire [14:0] l3_rearranged_pp5;
wire [11:0] l3_rearranged_pp6;
assign l3_rearranged_pp5 = {rearranged_pp5[14:12], l2_fa_S[7:0], rearranged_pp5[4:0]};
assign l3_rearranged_pp6 = {l2_fa_Cout[7:0], l2_ha_Cout, l2_ha_S, l2_rearranged_pp6[1:0]};

wire [1:0] l3_ha_S, l3_ha_Cout;
wire [10:0] l3_fa_S, l3_fa_Cout; 
half_adder l3_ha_0(
    .A(l3_rearranged_pp5[2]),
    .B(l3_rearranged_pp6[0]),
    .S(l3_ha_S[0]),
    .Cout(l3_ha_Cout[0])
);
half_adder l3_ha_1(
    .A(rearranged_pp4[16]),
    .B(l3_rearranged_pp5[14]),
    .S(l3_ha_S[1]),
    .Cout(l3_ha_Cout[1])
);
generate
    genvar j;
    for(j = 0; j < 11; j = j + 1) begin : L3_FA_GEN
        full_adder l3_fa_i(
            .A(rearranged_pp4[j+5]),
            .B(l3_rearranged_pp5[j+3]),
            .C(l3_rearranged_pp6[j+1]),
            .S(l3_fa_S[j]),
            .Cout(l3_fa_Cout[j])
        );
    end
endgenerate

// level 4
// full_adder * 15 & half_adder * 2 
// raw: 6 -> 5
wire [18:0] l4_rearranged_pp4;
wire [15:0] l4_rearranged_pp5;
assign l4_rearranged_pp4 = {rearranged_pp4[18:17], l3_ha_S[1], l3_fa_S[10:0], rearranged_pp4[4:0]};
assign l4_rearranged_pp5 = {l3_ha_Cout[1], l3_fa_Cout[10:0], l3_ha_Cout[0], l3_ha_S[0], l3_rearranged_pp5[1:0]};

wire [1:0] l4_ha_S, l4_ha_Cout;
wire [14:0] l4_fa_S, l4_fa_Cout;
half_adder l4_ha_0(
    .A(l4_rearranged_pp4[2]),
    .B(l4_rearranged_pp5[0]),
    .S(l4_ha_S[0]),
    .Cout(l4_ha_Cout[0])
);
half_adder l4_ha_1(
    .A(rearranged_pp3[20]),
    .B(l4_rearranged_pp4[18]),
    .S(l4_ha_S[1]),
    .Cout(l4_ha_Cout[1])
);
generate
    genvar k;
    for(k = 0; k < 15; k = k + 1) begin : L4_FA_GEN
        full_adder l4_fa_i(
            .A(rearranged_pp3[k+5]),
            .B(l4_rearranged_pp4[k+3]),
            .C(l4_rearranged_pp5[k+1]),
            .S(l4_fa_S[k]),  
            .Cout(l4_fa_Cout[k])
        );
    end
endgenerate

// level 5
// full_adder * 19 & half_adder * 2 
// raw: 5 -> 4
wire [22:0] l5_rearranged_pp3;
wire [19:0] l5_rearranged_pp4;
assign l5_rearranged_pp3 = {rearranged_pp3[22:21], l4_ha_S[1], l4_fa_S[14:0], rearranged_pp3[4:0]};
assign l5_reaaranged_pp4 = {l4_ha_Cout[1], l4_fa_Cout[14:0], l4_ha_Cout[0], l4_ha_S[0], l4_rearranged_pp4[1:0]};

wire [1:0] l5_ha_S, l5_ha_Cout;
wire [18:0] l5_fa_S, l5_fa_Cout;
half_adder l5_ha_0(
    .A(l5_rearranged_pp3[2]),
    .B(l5_rearranged_pp4[0]),
    .S(l5_ha_S[0]),
    .Cout(l5_ha_Cout[0])
);
half_adder l5_ha_1(
    .A(rearranged_pp2[24]),
    .B(l5_rearranged_pp3[22]),
    .S(l5_ha_S[1]),
    .Cout(l5_ha_Cout[1])
);
generate
   genvar l;
   for(l = 0; l < 19; l = l + 1) begin : L5_FA_GEN
       full_adder l5_fa_i(
           .A(rearranged_pp2[l+5]),
           .B(l5_rearranged_pp3[l+3]),
           .C(l5_rearranged_pp4[l+1]),
           .S(l5_fa_S[l]),
           .Cout(l5_fa_Cout[l])
       );
   end
endgenerate

// level 6
// full_adder * 23 & half_adder * 2 
// raw: 4 -> 3
wire [26:0] l6_rearranged_pp2;
wire [23:0] l6_rearranged_pp3;
assign l6_rearranged_pp2 = {rearranged_pp2[26:25], l5_ha_S[1], l5_fa_S[18:0], rearranged_pp2[4:0]};
assign l6_rearranged_pp3 = {l5_ha_Cout[1], l5_fa_Cout[18:0], l5_ha_Cout[0], l5_ha_S[0], l5_rearranged_pp3[1:0]};

wire [1:0] l6_ha_S, l6_ha_Cout;
wire [22:0] l6_fa_S, l6_fa_Cout;
half_adder l6_ha_0(
    .A(l6_rearranged_pp2[2]),
    .B(l6_rearranged_pp3[0]),
    .S(l6_ha_S[0]),
    .Cout(l6_ha_Cout[0])
);
half_adder l6_ha_1(
    .A(rearranged_pp1[28]),
    .B(l6_rearranged_pp2[26]),
    .S(l6_ha_S[1]),
    .Cout(l6_ha_Cout[1])
);
generate
    genvar m;
    for(m = 0; m < 23; m = m + 1) begin : L6_FA_GEN
        full_adder l6_fa_i(
            .A(rearranged_pp1[m+5]),
            .B(l6_rearranged_pp2[m+3]),
            .C(l6_rearranged_pp3[m+1]),
            .S(l6_fa_S[m]),
            .Cout(l6_fa_Cout[m])
        );
    end
endgenerate

// level 6
// full_adder * 27 & half_adder * 2 
// raw: 3 -> 2
wire [30:0] l7_rearranged_pp1;
wire [27:0] l7_rearranged_pp2;
assign l7_rearranged_pp1 = {rearranged_pp1[30:29], l6_ha_S[1], l6_fa_S[22:0], rearranged_pp1[4:0]};
assign l7_rearranged_pp2 = {l6_ha_Cout[1], l6_fa_Cout[22:0], l6_ha_Cout[0], l6_ha_S[0], l6_rearranged_pp2[1:0]};

wire [1:0] l7_ha_S, l7_ha_Cout;
wire [26:0] l7_fa_S, l7_fa_Cout;
half_adder l7_ha_0(
    .A(l7_rearranged_pp1[2]),
    .B(l7_rearranged_pp2[0]),
    .S(l7_ha_S[0]),
    .Cout(l7_ha_Cout[0])
);
half_adder l7_ha_1(
    .A(rearranged_pp0[30]),
    .B(l7_rearranged_pp1[30]),
    .S(l7_ha_S[1]),
    .Cout(l7_ha_Cout[1])
);
generate
    genvar o;
    for(o = 0; o < 27; o = o + 1) begin : L7_FA_GEN
        full_adder l7_fa_i(
            .A(rearranged_pp0[o+3]),
            .B(l7_rearranged_pp1[o+3]),
            .C(l7_rearranged_pp2[o+1]),
            .S(l7_fa_S[o]),
            .Cout(l7_fa_Cout[o])
        );
    end
endgenerate

// generate compressed result
assign final_part_0 = {rearranged_pp0[31], l7_ha_S[1], l7_fa_S[26:0], rearranged_pp0[2:0]};
assign final_part_1 = {l7_ha_Cout[1], l7_fa_Cout[26:0], l7_ha_Cout[0], l7_ha_S[0], l7_rearranged_pp1[1:0]};

endmodule