pixel_size = 4;
love.graphics.setDefaultFilter("nearest", "nearest")
Player = require("player");
Dice_utils = require("dice");
Dice_box = require("dice_box");
Scheduler = require("scheduler");
Initializer = require("initializers");
Quirks = require("quirks");
Enemy = require("enemy");
Combat_lock = false;
Drawers = require("drawers");
function love.load()
   image = love.graphics.newImage("cobble.jpg")
	 root_scheduler = Initializer.game_init();
	 local enemies = {};
	 enemies.length = 1;
	 enemies[1] = Enemy.new_enemy();
	 enemies[1]:update(0.1);
	 root_scheduler:add(Initializer.start_battle_interface(Player, enemies));
end


function love.update(dt)
	root_scheduler:update(dt);
end

function love.draw()
	Drawers.draw_base_interface(true);
	if Combat_lock then
		love.graphics.print("MODO COMBATE", playable_bounds.left+50, playable_bounds.top+200);
	end
	root_scheduler:draw();
end

function love.mousepressed(x, y, button, istouch)
	root_scheduler:answer_mouse_down(x, y, button);
end
function love.mousereleased(x, y, button, istouch)
	root_scheduler:answer_mouse_up(x, y, button);
end
function love.keypressed(key)
	if key == 'c' then
		Combat_lock = not(Combat_lock);
	end
end
