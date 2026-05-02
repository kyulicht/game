module space_invaders (
    input clk,            // Clock (25.175MHz)
    input rst_n,          // Reset (active low)
    input btn_left,       // Move player left
    input btn_right,      // Move player right
    input btn_shoot,      // Shoot projectile
    output hsync,
    output vsync,
    output [2:0] rgb      // Output color RGB (1 bit per channel)
);

    wire video_on;
    wire [10:0] pixel_x;
    wire [9:0]  pixel_y;
    wire vsync_w;

    vga_sync vga_inst (
        .clk(clk),
        .rst_n(rst_n),
        .hsync(hsync),
        .vsync(vsync_w),
        .video_on(video_on),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y)
    );
    assign vsync = vsync_w;

    // ----- Game Objects Variables -----
    reg [10:0] player_x;
    reg [10:0] alien_x;
    reg [9:0]  alien_y;
    reg        alien_dir; // 0: right, 1: left
    reg [7:0]  aliens_alive;
    
    reg [10:0] proj_x;
    reg [9:0]  proj_y;
    reg        proj_active;

    reg [2:0]  wait_cnt; // To slow down alien movement
    
    // Edge detection for vsync to update logic once per frame (60Hz)
    reg vsync_d;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) vsync_d <= 0;
        else vsync_d <= vsync_w;
    end
    wire frame_tick = (~vsync_w & vsync_d); // Falling edge of vsync
    
    // ----- Projectile Hit Logic -----
    // Alien row: 8 aliens, each width=32, gap=32 (cell spacing 64). Height 32.
    wire [10:0] rel_p_x = proj_x - alien_x;
    wire [2:0]  p_idx   = rel_p_x[8:6];   // rel_p_x / 64 (bit slicing handles division)
    wire [5:0]  p_rem   = rel_p_x[5:0];   // rel_p_x % 64
    // Condition to hit: proj is active, Y overlap, X overlap, inside alien cell, alien alive.
    wire hit_alien = proj_active && 
                     (proj_y >= alien_y) && (proj_y < alien_y + 32) &&
                     (rel_p_x < 512) && (p_rem < 32) &&
                     aliens_alive[p_idx];

    // ----- Game State & Update Logic -----
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            player_x     <= 300; // Center screen
            alien_x      <= 10;
            alien_y      <= 30;
            alien_dir    <= 0;
            aliens_alive <= 8'b11111111; // 8 aliens alive initially
            proj_active  <= 0;
            proj_y       <= 0;
            proj_x       <= 0;
            wait_cnt     <= 0;
        end else if (frame_tick) begin
            // 1. Player movement
            if (btn_left && player_x > 2) player_x <= player_x - 3;
            if (btn_right && player_x < 598) player_x <= player_x + 3; // 640 - player_width (40)
            
            // 2. Projectile logic
            if (btn_shoot && !proj_active) begin
                proj_active <= 1;
                proj_x      <= player_x + 18; // Center of the 40-wide player
                proj_y      <= 420;           // Start just above player
            end
            
            if (proj_active) begin
                if (proj_y > 4) begin
                    proj_y <= proj_y - 8; // Move projectile up quickly
                end else begin
                    proj_active <= 0;     // Off screen
                end
                
                // Active Hit checking
                if (hit_alien) begin
                    proj_active <= 0; // Deactivate projectile
                    aliens_alive[p_idx] <= 1'b0; // Destroy the struck alien
                end
            end
            
            // 3. Alien movement (slowed down: wait_cnt wraps every 8 frames)
            wait_cnt <= wait_cnt + 1;
            if (wait_cnt == 0) begin
                if (alien_dir == 0) begin // moving right
                    if (alien_x < 110) alien_x <= alien_x + 1;
                    else begin
                        alien_dir <= 1;
                        alien_y <= alien_y + 32; // Move down when hitting boundary
                    end
                end else begin // moving left
                    if (alien_x > 10) alien_x <= alien_x - 1;
                    else begin
                        alien_dir <= 0;
                        alien_y <= alien_y + 32;
                    end
                end
            end
        end
    end

    // ----- Rendering Logic -----
    // Check if pixel_x, pixel_y hits any object's bounding box.

    // Player (40x20 block)
    wire draw_player = (pixel_x >= player_x) && (pixel_x < player_x + 40) && 
                       (pixel_y >= 440) && (pixel_y < 460);
                       
    // Aliens
    wire [10:0] rel_x  = pixel_x - alien_x;
    wire [2:0]  a_idx  = rel_x[8:6];
    wire [5:0]  a_rem  = rel_x[5:0];
    wire draw_alien    = (pixel_y >= alien_y) && (pixel_y < alien_y + 32) &&
                         (rel_x < 512) && (a_rem < 32) &&
                         aliens_alive[a_idx];
                      
    // Projectile (4x8 block)
    wire draw_proj   = proj_active && 
                       (pixel_x >= proj_x) && (pixel_x < proj_x + 4) &&
                       (pixel_y >= proj_y) && (pixel_y < proj_y + 8);
                     
    // Combine object rendering with standard RGB colors.
    // Red for aliens, Green for player, Blue for projectile.
    wire [2:0] target_rgb;
    assign target_rgb[0] = draw_alien;
    assign target_rgb[1] = draw_player;
    assign target_rgb[2] = draw_proj;
    
    // Mask with video_on to prevent drawing in blanking intervals.
    assign rgb = (video_on) ? target_rgb : 3'b000;

endmodule
