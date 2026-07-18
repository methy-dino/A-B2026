local Drawers = {};
local hp_image = love.graphics.newImage("vida.png");
local hp_image_empty = love.graphics.newImage("vida_vazia.png");
Drawers.life_bar = Life_bar.create_drawer(hp_image, hp_image_empty, 6, 10);
-- references <BOOLEAN> = desenhar referencias de depuração
function Drawers.draw_base_interface(references) 
	love.graphics.clear(0,0,0,1);
	love.graphics.setColor(255, 255, 255);
		love.graphics.draw(image, playable_bounds.left, playable_bounds.top, 0,(playable_bounds.right-playable_bounds.left)/image:getWidth(), (playable_bounds.bottom-playable_bounds.top)/image:getHeight());
	love.graphics.setColor(255, 0, 0);
	if references then
		love.graphics.setColor(0,255,0)
		love.graphics.line(playable_bounds.left, playable_bounds.top, playable_bounds.left, playable_bounds.bottom);
		love.graphics.line(playable_bounds.right, playable_bounds.top, playable_bounds.right, playable_bounds.bottom);
		love.graphics.line(playable_bounds.right, playable_bounds.top, playable_bounds.left, playable_bounds.top);
		love.graphics.line(playable_bounds.right, playable_bounds.bottom, playable_bounds.left, playable_bounds.bottom);
		love.graphics.line(playable_bounds.right, playable_bounds.top+((playable_bounds.bottom-playable_bounds.top)/4), playable_bounds.left, playable_bounds.top+((playable_bounds.bottom-playable_bounds.top)/4));
		love.graphics.print("HUD (16 X 3)", playable_bounds.left+50, playable_bounds.top+20);
	end
	if references then
		love.graphics.setColor(255,0,0)
		love.graphics.line(playable_bounds.arena.left, playable_bounds.arena.top, playable_bounds.arena.left, playable_bounds.arena.bottom);
		love.graphics.line(playable_bounds.arena.right, playable_bounds.arena.top, playable_bounds.arena.right, playable_bounds.arena.bottom);
		love.graphics.line(playable_bounds.arena.left, playable_bounds.arena.top, playable_bounds.arena.right, playable_bounds.arena.top);
		love.graphics.line(playable_bounds.arena.left, playable_bounds.arena.bottom, playable_bounds.arena.right, playable_bounds.arena.bottom);
	end
end
function Drawers.draw_upper_interface(references) 	
	love.graphics.setColor(255, 255, 255);
	local start_x = playable_bounds.hud.left;
	local width = playable_bounds.hud.right-playable_bounds.hud.left;
	local height = (playable_bounds.hud.bottom-playable_bounds.hud.top);
	local start_y = playable_bounds.hud.bottom - height;
	love.graphics.rectangle("fill", start_x, start_y, width, height);
	love.graphics.setColor(0, 255, 0);
	local hp_width = math.ceil(width/3);
	local hp_height = math.ceil(height/3);
	local hp_start_x = start_x + width/10;
	local hp_start_y = height/2-hp_height/2;
	Drawers.life_bar.x = playable_bounds.hud.left + 3*pixel_size;
	Drawers.life_bar.y = playable_bounds.hud.top + 3*pixel_size;
	Drawers.life_bar:draw(Player.character.maxHealth, Player.character.health);
end
return Drawers;
