local Enemy = {};
-- 1 pixel do sprite == 4 pixeis da imagem
function Enemy.new_enemy(dice)
	local enm = {};
	enm.animation = {};
	enm.health = 20;
	enm.type = "enemy";
	local image = love.graphics.newImage("player.png");
	local animation = {}
	animation.spriteSheet = image;
	animation.quads = {};
	local height = 32;
	local width = 21;
	enm.sprite_height = height;
	enm.sprite_width = width;
	for y = 0, image:getHeight() - height, height do
		for x = 0, image:getWidth() - width, width do
			table.insert(animation.quads, love.graphics.newQuad(x, y, width, height, image:getDimensions()))
		end
	end
	animation.duration = 0.3;
	animation.currentTime = 0;
	enm.animation = animation;
	enm.position = {};
	enm.position.x = 9;
	enm.position.y = 4.5;
	enm.sprite_time = 0;
	enm.facing = -1;
	function enm.answer_message(self, sender, message) 
		return false;
	end
	function enm.draw(self)
		if self.health > 0 then
		love.graphics.setColor(255, 0, 0);
		local char_x = playable_bounds.arena.left + (self.position.x/16)*(playable_bounds.arena.right-playable_bounds.arena.left)-self.sprite_width*pixel_size/2;
		local char_y = playable_bounds.arena.top + (self.position.y/9)*(playable_bounds.arena.bottom-playable_bounds.arena.top)-self.sprite_height*pixel_size/2;
		if self.animation.currentTime > 0.4 then
			self.animation.currentTime = 0;
		end
	if self.facing == 1 then
		love.graphics.draw(self.animation.spriteSheet, self.animation.quads[math.floor(self.animation.currentTime/self.animation.duration+1)], char_x, char_y,0,4,4);
else 
	char_x = playable_bounds.arena.left + (self.position.x/16)*(playable_bounds.arena.right-playable_bounds.arena.left)+self.sprite_width*pixel_size/2;
	love.graphics.draw(self.animation.spriteSheet, self.animation.quads[math.floor(self.animation.currentTime/self.animation.duration+1)],char_x, char_y,0,-4,4);
		love.graphics.setColor(0, 0, 0);
		love.graphics.print(self.health.."/20", char_x, char_y);
end
end
	end

	function enm.answer_mouse_up(self, x, y, button)
		return false;
	end
	function enm.answer_mouse_down(self, x, y, button)
		local char_x = playable_bounds.arena.left + (self.position.x/16)*(playable_bounds.arena.right-playable_bounds.arena.left)-self.sprite_width*pixel_size/2;
		local char_y = playable_bounds.arena.top + (self.position.y/9)*(playable_bounds.arena.bottom-playable_bounds.arena.top)-self.sprite_height*pixel_size/2;
			if y >= char_y and y <= char_y + self.sprite_height*pixel_size then
				if x >= char_x and x <= char_x + self.sprite_width*pixel_size then
					return true;
				end
			end
			return false;
	end
	function enm.answer_message()
		return false;
	end
	function enm.update(self, dt)
	end
	return enm;
end
return Enemy;
