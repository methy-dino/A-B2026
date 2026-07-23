love.graphics.setDefaultFilter("nearest", "nearest")
Player = require("player");
Life_bar = require("life_bar");
Dice_utils = require("dice");
Dice_box = require("dice_box");
Scheduler = require("scheduler");
Initializer = require("initializers");
Quirks = require("quirks");
Enemy = require("enemy");
Music = require("music");
Combat_lock = false;
Drawers = require("drawers");
function love.load()
		math.randomseed(os.time())
		love.graphics.setDefaultFilter("nearest", "nearest")
   image = love.graphics.newImage("cobble.jpg")
	 root_scheduler = Initializer.game_init();
	 root_scheduler:add(Initializer.main_menu());
end


function love.update(dt)
	Music:update(dt);
	root_scheduler:update(dt);
end

function love.draw()
	Drawers.draw_base_interface(true);
	Drawers.draw_upper_interface();
	if Combat_lock then
		love.graphics.print("MODO COMBATE", playable_bounds.left+50, playable_bounds.top+200);
	end
	root_scheduler:draw();
end

function love.mousepressed(x, y, button, istouch)
	if root_scheduler:answer_mouse_down(x, y, button) == false and Combat_lock then 
		Combat_lock = false;
		local reset_die = {};
		reset_die.type = "reset";
		root_scheduler:message(reset_die, "");
	end
end
function love.mousereleased(x, y, button, istouch)
	root_scheduler:answer_mouse_up(x, y, button);
end
function love.keypressed(key)
	if key == 'c' and not Combat_lock then
		Combat_lock = true;
		local reset_die = {};
		reset_die.type = "reset";
		root_scheduler:message(reset_die, "");
	end
	root_scheduler:answer_key_down(key);
end
