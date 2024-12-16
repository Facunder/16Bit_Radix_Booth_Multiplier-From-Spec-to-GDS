module radix4_booth_encoder #(parameter WIDTH=16) (
    input [WIDTH - 1 : 0] A,  // Multiplicand
    input [2:0] partial_B,  // Multiplier
    output reg [WIDTH : 0] P_reg,  // Product
    output reg S, //Symbol bit extension optimization method - tail
    output reg E  //Symbol bit extension optimization method - head  
);    

    always @(*) begin
        case(partial_B)
            3'b000 : begin
                P_reg <= 0;
                S <= 1'b0;
                E <= 1'b1;
            end
            3'b001 : begin
                P_reg <= { A[WIDTH - 1], A};
                S <= 1'b0;
                E <= ~A[WIDTH - 1];
            end
            3'b010 : begin
                P_reg <= { A[WIDTH - 1], A};
                S <= 1'b0;
                E <= ~A[WIDTH - 1];
            end
            3'b011 : begin
                P_reg <= A << 1;
                S <= 1'b0;
                E <= ~A[WIDTH - 1];
            end
            3'b100 : begin
                // P_reg <= -(A<<1);
                P_reg <= ~(A<<1);
                S <= 1'b1;
                E <= A[WIDTH - 1];
            end
            3'b101 : begin
                // P_reg <= -{A[WIDTH - 1], A};
                P_reg <= ~{A[WIDTH - 1], A};
                S <= 1'b1;
                E <= A[WIDTH - 1];
            end
            3'b110 : begin
                // P_reg <= -{A[WIDTH - 1], A};
                P_reg <= ~{A[WIDTH - 1], A};
                S <= 1'b1;
                E <= A[WIDTH - 1];
            end
            3'b111 : begin
                P_reg <= ~0;
                S <= 1'b1;
                E <= 1'b0;
            end
        endcase
    end
endmodule
