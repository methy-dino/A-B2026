local Player = {};
Player.character = {};
Player.character.animation = {};
if true then
		local image = love.graphics.newImage("player.png");
 	  local animation = {}
    animation.spriteSheet = image;
    animation.quads = {};
		height = 32;
		width = 21;
    for y = 0, image:getHeight() - height, height do
        for x = 0, image:getWidth() - width, width do
            table.insert(animation.quads, love.graphics.newQuad(x, y, width, height, image:getDimensions()))
        end
    end
    animation.duration = 0.3;
    animation.currentTime = 0;

    Player.character.animation = animation;
end
Player.character.position = {};
Player.character.position.x = 9;
Player.character.position.y = 4.5;
Player.character.momentum = {};
Player.character.momentum.x = 0;
Player.character.momentum.y = 0;
Player.character.sprite_time = 0;
function Player.character.draw()
 if Player.character.momentum.x > 0 then
	last_facing = 1;
else 
	last_facing = -1;
end
	if last_facing == 1 then
	love.graphics.draw(Player.character.animation.spriteSheet, Player.character.animation.quads[math.floor(Player.character.animation.currentTime/Player.character.animation.duration+1)],playable_bounds.arena.left + (Player.character.position.x/16)*(playable_bounds.arena.right-playable_bounds.arena.left)-51/2, playable_bounds.arena.top + (Player.character.position.y/9)*(playable_bounds.arena.bottom-playable_bounds.arena.top)-34,0,3*last_facing,3);
else 
	love.graphics.draw(Player.character.animation.spriteSheet, Player.character.animation.quads[math.floor(Player.character.animation.currentTime/Player.character.animation.duration+1)],playable_bounds.arena.left + (Player.character.position.x/16)*(playable_bounds.arena.right-playable_bounds.arena.left)+51/2, playable_bounds.arena.top + (Player.character.position.y/9)*(playable_bounds.arena.bottom-playable_bounds.arena.top)-34,0,3*last_facing,3);

end
	if Player.character.animation.currentTime > 0.4 then
		Player.character.animation.currentTime = 0;
	end
end

function Player.character.move(dt)
	Player.character.animation.currentTime = Player.character.animation.currentTime + dt;
	y_change = 0;
	x_change = 0;
	if math.abs(Player.character.momentum.x) < 0.01 then
		Player.character.momentum.x = 0;
	end
	if math.abs(Player.character.momentum.y) < 0.01 then
		Player.character.momentum.y = 0;
	end
	Player.character.momentum.x = Player.character.momentum.x * 0.9 * (1-dt);
	Player.character.momentum.y = Player.character.momentum.y * 0.9 * (1-dt);
	if love.keyboard.isDown("w") then
		y_change = -1;
	end
	if love.keyboard.isDown("s") then
		y_change = 1;
	end
	if love.keyboard.isDown("a") then
		x_change = -1;
	end
	if love.keyboard.isDown("d") then
		x_change = 1;
	end
	normalized_change = 1;
	if (not (y_change == 0) and not (x_change == 0)) then
		normalized_change = 1/math.sqrt(math.pow(y_change, 2) + math.pow(x_change,2));
	end	
	Player.character.momentum.x = Player.character.momentum.x + x_change*normalized_change*dt;
	Player.character.momentum.y = Player.character.momentum.y + y_change*normalized_change*dt;
	total_speed = math.sqrt(math.pow(Player.character.momentum.x, 2) + math.pow(Player.character.momentum.y,2));
	if total_speed > 8 then
		change_mod = 8/total_speed;
		Player.character.momentum.x = Player.character.momentum.x * change_mod;
		Player.character.momentum.y = Player.character.momentum.y * change_mod;
		total_speed = math.sqrt(math.pow(Player.character.momentum.x, 2) + math.pow(Player.character.momentum.y,2));
	end
	--print("Player moving at: "..total_speed.." (units/s)");
	Player.character.position.x = Player.character.position.x + Player.character.momentum.x * dt * 60; 
	Player.character.position.y = Player.character.position.y + Player.character.momentum.y * dt * 60; 
end
return Player;
