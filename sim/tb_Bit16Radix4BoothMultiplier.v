// `timescale 1ns / 1ps
// test module Bit16Radix4BoothMultiplier
module Test_Bit16Radix4BoothMultiplier;

reg [15:0] A, B;
wire [31:0] product;
integer i;

// Instantiate the multiplier module
Bit16Radix4BoothMultiplier multiplier (
    .A(A),
    .B(B),
    .product(product)
);

initial begin
    // Initialize inputs
    A = 0; B = 0;
    // Wait for the simulation to stabilize
    #10;
    
    // Testing with basic input combinations
    // Test smallest non-zero values
    A = 16'h0001; B = 16'h0001;
    #10;
    $display("Test Case 1: %h(%d) * %h(%d) = %h(%d)", A, $signed(A), B, $signed(B), product, $signed(product));

    // Test with A as maximum positive and B as minimum non-zero
    A = 16'hFFFF; B = 16'h0001;
    #10;
    $display("Test Case 2: %h(%d) * %h(%d) = %h(%d)", A, $signed(A), B, $signed(B), product, $signed(product));

    // Test with both A and B as the maximum 16-bit values
    A = 16'hFFFF; B = 16'hFFFF;
    #10;
    $display("Test Case 3: %h(%d) * %h(%d) = %h(%d)", A, $signed(A), B, $signed(B), product, $signed(product));

    // Zero multiplied by maximum value
    A = 16'h0000; B = 16'hFFFF;
    #10;
    $display("Test Case 4: %h(%d) * %h(%d) = %h(%d)", A, $signed(A), B, $signed(B), product, $signed(product));

    // Positive and negative combination
    A = 16'h1234; B = 16'hFEDC;
    #10;
    $display("Test Case 5: %h(%d) * %h(%d) = %h(%d)", A, $signed(A), B, $signed(B), product, $signed(product));

    // Randomized tests for diverse coverage
    for (i = 0; i < 20; i++) begin
        A = $random % 65536; // Ensure A is within 16-bit range
        B = $random % 65536; // Ensure B is within 16-bit range
        #10;
        $display("Random Test Case %d: %h(%d) * %h(%d) = %h(%d)", i+1, A, $signed(A), B, $signed(B), product, $signed(product));
    end

    // Special cases with boundaries and zeros
    A = 16'h7FFF; B = 16'h8000; // Crossing positive to negative
    #10;
    $display("Boundary Test Case 1: %h(%d) * %h(%d) = %h(%d)", A, $signed(A), B, $signed(B), product, $signed(product));

    A = 16'h8000; B = 16'h8000; // Large number multiplication
    #10;
    $display("Boundary Test Case 2: %h(%d) * %h(%d) = %h(%d)", A, $signed(A), B, $signed(B), product, $signed(product));

    // Finish the test
    $finish;
end

endmodule
