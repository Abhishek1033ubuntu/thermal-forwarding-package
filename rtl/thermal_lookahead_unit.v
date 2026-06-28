module thermal_lookahead_unit (
    input  wire        clk,           
    input  wire        rst_n,         
    input  wire [1:0]  opcode_weight, // 00: Idle, 01: Vector, 10: Tensor
    input  wire [31:0] current_temp,  // Kelvin
    output reg  [11:0] pmic_i_target  // Max 1.21A mapped (12'h4BA)
);

    parameter CAP_I_OPT = 12'h4BA; 
    parameter VAL_VECTOR = 12'h28A; 
    parameter VAL_IDLE   = 12'h000; 

    reg [11:0] next_i_target;

    always @(*) begin
        if (current_temp >= 350) begin
            next_i_target = CAP_I_OPT; // Emergency Override
        end else begin
            case (opcode_weight)
                2'b00:   next_i_target = VAL_IDLE;   
                2'b01:   next_i_target = VAL_VECTOR; 
                2'b10:   next_i_target = CAP_I_OPT;  
                default: next_i_target = VAL_IDLE;
            endcase
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) pmic_i_target <= 12'h000;
        else        pmic_i_target <= next_i_target;
    end
endmodule

// ==========================================
// Testbench Verification Suite
// ==========================================
module tb_thermal_lookahead;
    reg         clk;
    reg         rst_n;
    reg  [1:0]  opcode_weight;
    reg  [31:0] current_temp;
    wire [11:0] pmic_i_target;

    thermal_lookahead_unit uut (
        .clk(clk),
        .rst_n(rst_n),
        .opcode_weight(opcode_weight),
        .current_temp(current_temp),
        .pmic_i_target(pmic_i_target)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0; rst_n = 0; opcode_weight = 2'b00; current_temp = 300;
        #10 rst_n = 1;
        #10 opcode_weight = 2'b00; 
        #10 opcode_weight = 2'b01; 
        #10 opcode_weight = 2'b10; 
        #10 opcode_weight = 2'b00; 
        #10 current_temp = 360; opcode_weight = 2'b00; 
        #20 $finish;
    end
endmodule
