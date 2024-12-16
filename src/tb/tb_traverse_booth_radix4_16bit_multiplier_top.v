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

    // 统计正确和错误的计数器
    integer correct_count;
    integer error_count;

    reg signed [31:0] expected_product;

    // 用于遍历的有符号循环变量
    integer i, j;

    initial begin
        // 初始化
        rst_n = 0;
        a     = 16'd0;
        b     = 16'd0;
        correct_count = 0;
        error_count   = 0;

        // 先给一段复位时间
        #20;
        rst_n = 1;

        // 双重循环，遍历 a,b = -155 ~ 155
        for (i = -1234; i <= 1234; i = i + 1) begin
            for (j = -1234; j <= 1234; j = j + 1) begin
                a = i;
                b = j;

                // 等待若干时间使输入稳定
                #50;

                // 等待一段时间后读取输出
                #100;

                // 计算期望结果
                expected_product = $signed(i) * $signed(j);

                // 判断 DUT 输出是否正确
                if ($signed(product) == expected_product) begin
                    correct_count = correct_count + 1;
                end else begin
                    error_count = error_count + 1;
                    // 打印错误信息
                    $display($time, 
                             " ns -- ERROR: a=%d, b=%d, product(DUT)=%d, expected=%d", 
                             i, j, $signed(product), expected_product);
                end
            end
        end

        // 打印最终统计结果
        $display("Simulation finished!");
        $display("Correct results: %d", correct_count);
        $display("Error   results: %d", error_count);

        #100;  // 给最后一组结果一些输出时间
        $finish;
    end
endmodule
