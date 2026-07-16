local Player = {};
Player.character = {};
Player.character.inventory = {};
-- 1 pixel do sprite == 4 pixeis da imagem
function Player.init(class)
	Player.character.animation = {};
	Player.character.type = "player";
	local image = love.graphics.newImage("player.png");
	local animation = {}
	animation.spriteSheet = image;
	animation.quads = {};
	local height = 32;
	local width = 21;
	Player.character.sprite_height = height;
	Player.character.sprite_width = width;
	for y = 0, image:getHeight() - height, height do
		for x = 0, image:getWidth() - width, width do
			table.insert(animation.quads, love.graphics.newQuad(x, y, width, height, image:getDimensions()))
		end
	end
	animation.duration = 0.3;
	animation.currentTime = 0;
	Player.character.animation = animation;
	Player.character.position = {};
	Player.character.position.x = 9;
	Player.character.position.y = 4.5;
	Player.character.momentum = {};
	Player.character.momentum.x = 0;
	Player.character.momentum.y = 0;
	Player.character.sprite_time = 0;
	Player.character.facing = 1;
	Player.character.inventory.dice = {};
	Player.character.inventory.dice.length = 2;
	Player.character.inventory.relics = {};
	Player.character.inventory.interface = {};
	Player.character.inventory.interface.type = "inventory";
   local dadopng = love.graphics.newImage("dado.png");cor = {};cor.r = 125/255;cor.g =0;cor.b = 125/255;
	 faces_tst = {};
	 faces_tst.length = 4;
	 	if true then 
		 local quirks = {};
		 quirks[1] = Quirks.basic_damage();
		 quirks.length = 1;
		 local quirks4 = {};
		 quirks4[1] = Quirks.basic_damage();
		 quirks4.length = 1;
		 local quirks3 = {};
		 quirks3[1] = Quirks.basic_damage();
		 quirks3.length = 1;
		 local quirks2 = {};
		 quirks2[1] = Quirks.basic_damage();
		 quirks2.length = 1;
		 faces_tst[1] = Dice_utils.new_face(1, quirks);
		 faces_tst[2] = Dice_utils.new_face(2, quirks2);
		 faces_tst[3] = Dice_utils.new_face(3, quirks3);
		 faces_tst[4] = Dice_utils.new_face(4, quirks4);
	 end
		 faces_tst2 = {};
		 faces_tst2.length = 4;
	 if true then
	 local quirks = {};
	 quirks[1] = Quirks.single_use_damage();
	 quirks.length = 1;
	 local quirks4 = {};
	 quirks4[1] = Quirks.single_use_damage();
	 quirks4.length = 1;
	 local quirks3 = {};
	 quirks3[1] = Quirks.single_use_damage();
	 quirks3.length = 1;
	 local quirks2 = {};
	 quirks2[1] = Quirks.single_use_damage();
	 quirks2.length = 1;
	 faces_tst2[1] = Dice_utils.new_face(2, quirks);
	 faces_tst2[2] = Dice_utils.new_face(3, quirks2);
	 faces_tst2[3] = Dice_utils.new_face(3, quirks3);
	 faces_tst2[4] = Dice_utils.new_face(5, quirks4);
 end
	 local dado_teste = Dice_utils.new_die(faces_tst, cor, dadopng);
	 local dado_teste2 = Dice_utils.new_die(faces_tst2, cor, dadopng);
	function Player.character.inventory.interface.draw()
		love.graphics.setColor(255, 255, 255);
		local start_x = playable_bounds.arena.left;
		local width = playable_bounds.arena.right-playable_bounds.arena.left;
		local height = (playable_bounds.arena.bottom-playable_bounds.arena.top)/4;
		local start_y= playable_bounds.arena.bottom - height;
		love.graphics.rectangle("fill", start_x, start_y, width, height);
	end
	function Player.character.inventory.interface.answer_mouse_down()
		return false;
	end
	function Player.character.inventory.interface.answer_mouse_up()
		return false;
	end
	function Player.character.inventory.interface.answer_message()
		return false;
	end
	function Player.character.inventory.interface.update(dt)
	end
	 Player.character.inventory.dice[1] = dado_teste;
	 Player.character.inventory.dice[2] = dado_teste2;
end
function Player.character.answer_message(self, sender, message) 
	return false;
end
function Player.character.draw()
	love.graphics.setColor(255, 255, 255);
	local char_x = playable_bounds.arena.left + (Player.character.position.x/16)*(playable_bounds.arena.right-playable_bounds.arena.left)-Player.character.sprite_width*pixel_size/2;
	local char_y = playable_bounds.arena.top + (Player.character.position.y/9)*(playable_bounds.arena.bottom-playable_bounds.arena.top)-Player.character.sprite_height*pixel_size/2;
 if Player.character.momentum.x > 0 then
	Player.character.facing = 1;
	elseif Player.character.momentum.x < 0 then
	Player.character.facing = -1;
end
	if Player.character.facing == 1 then
	love.graphics.draw(Player.character.animation.spriteSheet, Player.character.animation.quads[math.floor(Player.character.animation.currentTime/Player.character.animation.duration+1)], char_x, char_y,0,4,4);
else 
	char_x = playable_bounds.arena.left + (Player.character.position.x/16)*(playable_bounds.arena.right-playable_bounds.arena.left)+Player.character.sprite_width*pixel_size/2;
	love.graphics.draw(Player.character.animation.spriteSheet, Player.character.animation.quads[math.floor(Player.character.animation.currentTime/Player.character.animation.duration+1)],char_x, char_y,0,-4,4);

end
	if Player.character.animation.currentTime > 0.4 then
		Player.character.animation.currentTime = 0;
	end
end

	function Player.character.answer_mouse_up(self, x, y, button)
	return false;
end
function Player.character.answer_mouse_down(self, x, y, button)
	local char_x = playable_bounds.arena.left + (Player.character.position.x/16)*(playable_bounds.arena.right-playable_bounds.arena.left)-Player.character.sprite_width*pixel_size/2;
	local char_y = playable_bounds.arena.top + (Player.character.position.y/9)*(playable_bounds.arena.bottom-playable_bounds.arena.top)-Player.character.sprite_height*pixel_size/2;
	if Player.character.momentum.x < 0 then
		char_x = playable_bounds.arena.left + (Player.character.position.x/16)*(playable_bounds.arena.right-playable_bounds.arena.left);
	end
		if y >= char_y and y <= char_y + Player.character.sprite_height*pixel_size then
			if x >= char_x and x <= char_x + Player.character.sprite_width*pixel_size then
				return true;
			end
		end
		return false;
end
function Player.character.answer_message()
	return false;
end
function Player.character.update(self, dt)
	local y_change = 0;
	local x_change = 0;
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
	if total_speed > 0 then
		Player.character.animation.currentTime = Player.character.animation.currentTime + dt;
	end
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
function Player.character.inventory.init_drawer(sched)
	sched:add(Player.character.inventory.interface);
	local height = (playable_bounds.arena.bottom-playable_bounds.arena.top)/4;
	local draw_y = playable_bounds.arena.bottom - (height/2);
	local draw_x = 0;
	local curr_dice = {};
	for i = 1, Player.character.inventory.dice.length do
		curr_dice = Player.character.inventory.dice[i];
		curr_dice.position.origin_y = (draw_y-playable_bounds.arena.top)/(playable_bounds.arena.bottom-playable_bounds.arena.top)*9;
		curr_dice.position.origin_x = 0 + (curr_dice.sprite:getWidth()*pixel_size)/(playable_bounds.arena.right-playable_bounds.arena.left)*16 * i + 0.80 * i;
		sched:add(curr_dice);
	end
end
return Player;
