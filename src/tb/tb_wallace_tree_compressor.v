// `timescale 1ns/1ps

module tb_wallace_tree_compressor;

    // Declare input signals
    reg [19:0] pp0, pp7;
    reg [20:0] pp1, pp2, pp3, pp4, pp5, pp6;
    reg        rest_S;

    // Declare output signals
    wire [31:0] final_part_0;
    wire [31:0] final_part_1;

    // Instantiate the Device Under Test (DUT)
    wallace_tree_compressor dut (
        .pp0    (pp0),
        .pp1    (pp1),
        .pp2    (pp2),
        .pp3    (pp3),
        .pp4    (pp4),
        .pp5    (pp5),
        .pp6    (pp6),
        .pp7    (pp7),
        .rest_S (rest_S),
        .final_part_0 (final_part_0),
        .final_part_1 (final_part_1)
    );

    // Variables for checking simulation results
    reg [63:0] expected_sum;
    reg [63:0] final_compressed_sum;

    integer i;

    // Main test process
    initial begin
        $display("============ Start Wallace Tree Compressor Test ============");

        // Perform multiple random test iterations
        for (i = 0; i < 10; i = i + 1) begin
            // Assign random values to partial products
            pp0    = {$random} & 20'hFFFFF;   // Mask to 20 bits
            pp1    = {$random} & 21'h1FFFFF;  // Mask to 21 bits
            pp2    = {$random} & 21'h1FFFFF;
            pp3    = {$random} & 21'h1FFFFF;
            pp4    = {$random} & 21'h1FFFFF;
            pp5    = {$random} & 21'h1FFFFF;
            pp6    = {$random} & 21'h1FFFFF;
            pp7    = {$random} & 20'hFFFFF;
            rest_S = {$random} & 1'b1;

            // Wait a short time for combinational logic to stabilize
            #5;

            // Combine final outputs into a single sum
            // final_part_0 + (final_part_1 << 1)
            final_compressed_sum = final_part_0 + ( (64'(final_part_1)) << 1 );

            // Calculate the expected sum of all partial products plus rest_S
            expected_sum = pp0 + pp1 + pp2 + pp3 + pp4 + pp5 + pp6 + pp7 + rest_S;

            // Compare the compressor output to the expected sum
            if (final_compressed_sum !== expected_sum) begin
                $display("[ERROR] Mismatch at iteration %0d:", i);
                $display("  pp0=%d pp1=%d pp2=%d pp3=%d pp4=%d pp5=%d pp6=%d pp7=%d rest_S=%b",
                          pp0, pp1, pp2, pp3, pp4, pp5, pp6, pp7, rest_S);
                $display("  final_part_0=%d final_part_1=%d => final_sum=%d, expected_sum=%d\n",
                          final_part_0, final_part_1, final_compressed_sum, expected_sum);
            end else begin
                $display("[PASS ] Iteration %0d: final_sum=%d (matches expected_sum)", 
                          i, final_compressed_sum);
            end

            #5; // Additional delay for waveform observation
        end

        $display("============ Wallace Tree Compressor Test Finished ============");
        $stop;  // End simulation
    end

endmodule
