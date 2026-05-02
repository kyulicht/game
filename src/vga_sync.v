module vga_sync (
    input clk,          // Clock
    input rst_n,        // Active low reset
    output hsync,       // Horizontal sync
    output vsync,       // Vertical sync
    output video_on,    // High when inside display area
    output [10:0] pixel_x, // Current X pixel
    output [9:0] pixel_y   // Current Y pixel
);

    // Standard VGA 640x480 @ 60Hz parameters (25.175 MHz)
    parameter H_DISP = 640;
    parameter H_FP   = 16;
    parameter H_SYNC = 96;
    parameter H_BP   = 48;
    parameter V_DISP = 480;
    parameter V_FP   = 10;
    parameter V_SYNC = 2;
    parameter V_BP   = 33;

    localparam H_TOTAL = H_DISP + H_FP + H_SYNC + H_BP; // 1056
    localparam V_TOTAL = V_DISP + V_FP + V_SYNC + V_BP; // 628

    reg [10:0] h_cnt;
    reg [9:0]  v_cnt;

    // Horizontal counter
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            h_cnt <= 0;
        end else begin
            if (h_cnt == H_TOTAL - 1)
                h_cnt <= 0;
            else
                h_cnt <= h_cnt + 1;
        end
    end

    // Vertical counter
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            v_cnt <= 0;
        end else if (h_cnt == H_TOTAL - 1) begin
            if (v_cnt == V_TOTAL - 1)
                v_cnt <= 0;
            else
                v_cnt <= v_cnt + 1;
        end
    end

    // Sync pulses
    assign hsync = (h_cnt >= (H_DISP + H_FP) && h_cnt < (H_DISP + H_FP + H_SYNC)) ? 1'b0 : 1'b1;
    assign vsync = (v_cnt >= (V_DISP + V_FP) && v_cnt < (V_DISP + V_FP + V_SYNC)) ? 1'b0 : 1'b1;

    // Display area indication
    assign video_on = (h_cnt < H_DISP) && (v_cnt < V_DISP);
    
    // Pixel coordinates
    assign pixel_x = h_cnt;
    assign pixel_y = v_cnt;

endmodule
