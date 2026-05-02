`default_nettype none

module tt_um_shiho_space_invaders (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  // Unused pins
  assign uio_out = 0;
  assign uio_oe  = 0;
  wire _unused = &{ena, uio_in, ui_in[3:0], ui_in[7], 1'b0};

  // Gamepad outputs
  wire gamepad_left;
  wire gamepad_right;
  wire gamepad_a;
  wire gamepad_b;
  wire gamepad_up;
  wire gamepad_down;
  wire gamepad_start;
  wire gamepad_select;
  wire gamepad_y;
  wire gamepad_x;
  wire gamepad_l;
  wire gamepad_r;
  wire gamepad_is_present;

  gamepad_pmod_single gamepad (
      .rst_n(rst_n),
      .clk(clk),
      .pmod_data(ui_in[6]),
      .pmod_clk(ui_in[5]),
      .pmod_latch(ui_in[4]),
      .is_present(gamepad_is_present),
      .b(gamepad_b),
      .y(gamepad_y),
      .select(gamepad_select),
      .start(gamepad_start),
      .up(gamepad_up),
      .down(gamepad_down),
      .left(gamepad_left),
      .right(gamepad_right),
      .a(gamepad_a),
      .x(gamepad_x),
      .l(gamepad_l),
      .r(gamepad_r)
  );

  wire hsync;
  wire vsync;
  wire [2:0] rgb; // R=0, G=1, B=2

  space_invaders game (
      .clk(clk),
      .rst_n(rst_n),
      .btn_left(gamepad_left),
      .btn_right(gamepad_right),
      .btn_shoot(gamepad_a | gamepad_b), // User can shoot with A or B
      .hsync(hsync),
      .vsync(vsync),
      .rgb(rgb)
  );

  // Map to TinyTapeout VGA Pmod
  // rgb[0] = Red (uo_out[0], uo_out[4])
  // rgb[1] = Green (uo_out[1], uo_out[5])
  // rgb[2] = Blue (uo_out[2], uo_out[6])
  assign uo_out[0] = rgb[0];
  assign uo_out[4] = rgb[0];
  assign uo_out[1] = rgb[1];
  assign uo_out[5] = rgb[1];
  assign uo_out[2] = rgb[2];
  assign uo_out[6] = rgb[2];
  assign uo_out[3] = vsync;
  assign uo_out[7] = hsync;

endmodule
