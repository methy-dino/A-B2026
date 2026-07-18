	pixel_size = 4;
love.graphics.setDefaultFilter("nearest", "nearest")
Player = require("player");
Life_bar = require("life_bar");
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
	 local target = {};
	 target.length = 1;
	 target[1] = "player";
	 local quirks = {};
	 quirks.length = 1;
	 quirks[1] = Quirks.basic_damage(target);
	 local faces = {};
	 faces.length = 1;
	 local color = {};
	 color.r = 0;
	 color.g = 0;
	 color.b = 0;
	 faces[1] = Dice_utils.new_face(1, quirks);
   local dadopng = love.graphics.newImage("dado.png");
love.graphics.setDefaultFilter("nearest", "nearest")
	 local die = Dice_utils.new_enemy_die(faces, color, dadopng);
	 enemies.length = 1;
	 enemies[1] = Enemy.new_enemy(die);
	 root_scheduler:add(Initializer.start_battle_interface(Player, enemies));
end


function love.update(dt)
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
	if key == 'e' then
		Player.character.health = Player.character.health-1;
	end
end
