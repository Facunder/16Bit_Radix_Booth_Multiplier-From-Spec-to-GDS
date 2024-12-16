// `timescale 1ns / 1ps

// Testbench for sqrt_carry_select_adder
module tb_sqrt_carry_select_adder;

    // Parameters
    parameter WIDTH = 32; // Data width set to 32 bits

    // Inputs
    reg [WIDTH-1:0] a;
    reg [WIDTH-1:0] b;
    reg cin;

    // Outputs
    wire [WIDTH-1:0] sum;
    wire cout;

    // Instantiate the sqrt_carry_select_adder
    sqrt_carry_select_adder #(.WIDTH(WIDTH)) uut (
        .a(a),
        .b(b),
        .cin(cin),
        .sum(sum),
        .cout(cout)
    );

    // Variables for checking results
    reg [WIDTH:0] expected_sum; // Extra bit for carry out

    // Initialize test cases
    initial begin
        // Display header
        $display("Starting sqrt_carry_select_adder Testbench");
        $display("========================================");
        $display("a\t\t\tb\t\t\tcin\t| sum\t\t\tcout\t| expected_sum");

        // Test Case 1: Simple addition without carry
        a = 32'd15;
        b = 32'd10;
        cin = 1'b0;
        #10; // Wait for propagation
        expected_sum = a + b + cin;
        check_result();

        // Test Case 2: Addition with carry-in
        a = 32'd25;
        b = 32'd30;
        cin = 1'b1;
        #10;
        expected_sum = a + b + cin;
        check_result();

        // Test Case 3: Maximum values without overflow
        a = 32'hFFFFFFFF;
        b = 32'h00000000;
        cin = 1'b0;
        #10;
        expected_sum = a + b + cin;
        check_result();

        // Test Case 4: Maximum values with overflow
        a = 32'hFFFFFFFF;
        b = 32'hFFFFFFFF;
        cin = 1'b1;
        #10;
        expected_sum = a + b + cin;
        check_result();

        // Test Case 5: Random values
        a = 32'h12345678;
        b = 32'h87654321;
        cin = 1'b1;
        #10;
        expected_sum = a + b + cin;
        check_result();

        // Test Case 6: Zero addition
        a = 32'd0;
        b = 32'd0;
        cin = 1'b0;
        #10;
        expected_sum = a + b + cin;
        check_result();

        // Test Case 7: Negative numbers (Two's complement)
        a = -32'd1;
        b = -32'd2;
        cin = 1'b0;
        #10;
        expected_sum = a + b + cin;
        check_result();

        // Test Case 8: Mixed positive and negative
        a = 32'd100;
        b = -32'd50;
        cin = 1'b1;
        #10;
        expected_sum = a + b + cin;
        check_result();

        // Test Case 9: Large random values
        a = 32'hA5A5A5A5;
        b = 32'h5A5A5A5A;
        cin = 1'b1;
        #10;
        expected_sum = a + b + cin;
        check_result();

        // Test Case 10: Carry chain propagation
        a = 32'h7FFFFFFF;
        b = 32'h7FFFFFFF;
        cin = 1'b1;
        #10;
        expected_sum = a + b + cin;
        check_result();

        // Finish simulation
        $display("========================================");
        $display("Testbench completed.");
        $stop;
    end

    // Task to check the result
    task check_result;
        reg expected_cout;
        reg [WIDTH-1:0] expected_sum_truncated;
    begin
        // Calculate expected carry out
        expected_cout = expected_sum[WIDTH];
        // Truncate expected_sum to WIDTH bits
        expected_sum_truncated = expected_sum[WIDTH-1:0];

        // Display the results
        $display("%h\t%h\t%b\t| %h\t%b\t| %h",
                 a, b, cin, sum, cout, expected_sum);

        // Check if the sum and carry out match the expected values
        if (sum !== expected_sum_truncated || cout !== expected_cout) begin
            $display("ERROR: Mismatch detected!");
            $display("Expected Sum: %h, Got: %h", expected_sum_truncated, sum);
            $display("Expected Cout: %b, Got: %b", expected_cout, cout);
        end else begin
            $display("PASS");
        end

        // Add a separator for readability
        $display("--------------------------------------------------");
    end
    endtask

endmodule
