// `timescale 1ns/1ps

module booth_radix4_16bit_multiplier_top_tb();

    // DUT 接口信号
    reg         clk;
    reg         rst_n;
    reg  [15:0] a;
    reg  [15:0] b;
    wire [31:0] product;

    // 实例化待测模块
    booth_radix4_16bit_multiplier_top UUT (
        .clk    (clk),
        .rst_n  (rst_n),
        .a      (a),
        .b      (b),
        .product(product)
    );

    // 产生时钟，周期 10ns
    initial clk = 1'b0;
    always #5 clk = ~clk;

    // 存放测试向量
    reg signed [15:0] test_a [0:19];
    reg signed [15:0] test_b [0:19];
    reg signed [31:0] expected_product;

    integer i;

    initial begin
        // 初始化
        rst_n = 0;
        a     = 16'd0;
        b     = 16'd0;

        // 先给一段复位时间
        #20;
        rst_n = 1;

        // 准备 15 组测试向量（有符号数）
        test_a[0]  = 16'sd0;      test_b[0]  = 16'sd0;       // 0 * 0 = 0
        test_a[1]  = 16'sd1;      test_b[1]  = 16'sd1;       // 1 * 1 = 1
        test_a[2]  = 16'sd1;      test_b[2]  = -16'sd1;      // 1 * (-1) = -1
        test_a[3]  = 16'sd2;      test_b[3]  = 16'sd3;       // 2 * 3 = 6
        test_a[4]  = -16'sd3;     test_b[4]  = 16'sd7;       // -3 * 7 = -21
        test_a[5]  = -16'sd10;    test_b[5]  = -16'sd10;     // (-10) * (-10) = 100
        test_a[6]  = 16'sd123;    test_b[6]  = 16'sd456;     // 123 * 456 = 56088
        test_a[7]  = -16'sd200;   test_b[7]  = 16'sd300;     // -200 * 300 = -60000
        test_a[8]  = 16'sh7FFF;   test_b[8]  = 16'sd1;       // 32767 * 1 = 32767
        test_a[9]  = 16'sh8000;   test_b[9]  = 16'sd1;       // -32768 * 1 = -32768
        test_a[10] = -16'sd1;     test_b[10] = -16'sd1;      // (-1) * (-1) = 1
        test_a[11] = 16'sd32767;  test_b[11] = -16'sd1;      // 32767 * -1 = -32767
        // 注意 0x8000(=-32768) 乘 -1 在理想数学下结果应为 32768，但 16bit 表示下它仍视为 -32768
        // 这里仅测试硬件输出是否匹配 Verilog 乘法结果。
        test_a[12] = 16'sh8000;   test_b[12] = -16'sd1;      // -32768 * (-1) = 32768 (截断后是 -32768 的表示)
        test_a[13] = 16'sd12345;  test_b[13] = -16'sd6789;   // 12345 * (-6789) = -83810205
        test_a[14] = -16'sd32768; test_b[14] = 16'sd2;       // -32768 * 2 = -65536
        test_a[15] = 16'sd22624;     test_b[15] = 16'sd28743;
        test_a[16] = -16'sd225;    test_b[16] = -16'sd154;
        test_a[17] = 16'sd1315;     test_b[17] = -16'sd19119;
        test_a[18] = -16'sd648;    test_b[18] = 16'sd268;
        test_a[19] = 16'sd12345;     test_b[19] = 16'sd6789;


        // 逐个喂测试向量，并在 100ns 后读取输出
        for (i = 0; i < 20; i = i + 1) begin
            a = test_a[i];
            b = test_b[i];

            // 每组输入先等待 50ns（相当于题目所说 "每 50ns 给一对输入"）
            #50;

            // 然后再等待 100ns 后读取输出
            #100;

            expected_product = $signed(test_a[i]) * $signed(test_b[i]);
            $display($time, 
                     " ns -- Testcase %0d: a=%d, b=%d, product(DUT)=%d, expected=%d", 
                     i, $signed(a), $signed(b), $signed(product), expected_product);
        end

        #100;  // 给最后一组结果一些输出时间
        $finish;
    end
endmodule
