
-- TODO: Make a li'l sample game of just walking around and interacting with one or two things.
-- SEE: I downloaded this and it looks fine? CC0! https://pixel-boy.itch.io/ninja-adventure-asset-pack

local text_x = 64
local text_y = 64
local angle_display = 0


function load()
    display_set_text_tilesheet(1)
    display_set_text("", Vector2(8, 8))
    print("Loaded :) And print is working! Wahoo!")
end


function update()
    if input_is_pressed(input_UP) then
        text_y = text_y - 1
        text_y = math.max(text_y, 0)
    end
    if input_is_pressed(input_DOWN) then
        text_y = text_y + 1
        text_y = math.min(text_y, display_HEIGHT - 2*16)
    end
    if input_is_pressed(input_LEFT) then
        text_x = text_x - 1
        text_x = math.max(text_x, 0)
    end
    if input_is_pressed(input_RIGHT) then
        text_x = text_x + 1
        text_x = math.min(text_x, display_WIDTH - 5*16)
    end
    angle_display = math.round(360 * input_get_axis_1d(input_WHEEL) / math.tau)
end


function draw()
    display_draw_sprite(Vector2(text_x+16*0, text_y), Vector2(128, 0))
    display_draw_sprite(Vector2(text_x+16*1, text_y), Vector2(80, 0))
    display_draw_sprite(Vector2(text_x+16*2, text_y), Vector2(192, 0))
    display_draw_sprite(Vector2(text_x+16*3, text_y), Vector2(192, 0))
    display_draw_sprite(Vector2(text_x+16*4, text_y), Vector2(240, 0))
    
    display_draw_sprite(Vector2(text_x+16*0, text_y+16), Vector2(112, 16))
    display_draw_sprite(Vector2(text_x+16*1, text_y+16), Vector2(240, 0))
    display_draw_sprite(Vector2(text_x+16*2, text_y+16), Vector2(32, 16))
    display_draw_sprite(Vector2(text_x+16*3, text_y+16), Vector2(192, 0))
    display_draw_sprite(Vector2(text_x+16*4, text_y+16), Vector2(64, 0))
    
    local angle_string = tostring(angle_display)
    display_draw_text(Vector2(8, 8), angle_string)
end
