-- faces must be: composed of length, face[i].value, face[i].quirks, 
local Dice_box = {};
function Dice_box.new_dice_box(color, sprite)
	local dice_box = {};
	dice_box.color = color;
	dice_box.name = "generic dice box";
	dice_box.type = "dice_box";
	dice_box.curr_face = 1;
	dice_box.sprite = sprite;
	dice_box.position = {};
	dice_box.position.x = 9;
	dice_box.position.y = 4.5;
	dice_box.has_dice_inside = false;
	dice_box.dice = nil;
	function dice_box.update(self, dt)
		return false;
	end
	function dice_box.answer_mouse_up(self, x, y, button, sched, my_i)
		return false;
	end
	function dice_box.answer_mouse_down(self, x, y, button, sched, my_i)
		if Combat_lock and self.has_dice_inside then
			self.dice:roll(sched);
			if (self.dice.spent == true) then
				self.has_dice_inside = false;
				self.dice.has_box = false;
				self.dice.box = nil;
				self.dice = nil;
			end
			return true;
		else
			local dice_box_x = math.floor(playable_bounds.arena.left + (self.position.x/16)*(playable_bounds.arena.right-playable_bounds.arena.left)-self.sprite:getWidth()*pixel_size/2);
			local dice_box_y = math.floor(playable_bounds.arena.top + (self.position.y/9)*(playable_bounds.arena.bottom-playable_bounds.arena.top)-self.sprite:getHeight()*pixel_size/2);
			if y >= dice_box_y and y <= dice_box_y + self.sprite:getHeight()*pixel_size then
				if x >= dice_box_x and x <= dice_box_x + self.sprite:getWidth()*pixel_size then
					print("["..dice_box.name.."].answer_mouse_down -> targeted, input answered");
					if self.has_dice_inside == true then
					end
					return true;
				end
			end
		end
		print("["..dice_box.name.."].answer_mouse_down -> not targeted, input ignored");
		return false;
	end
	function dice_box.answer_message(self, sender, message)
		if sender.type == "dice" then
			target_x, target_y = love.mouse.getPosition();
			local dice_box_x = math.floor(playable_bounds.arena.left + (self.position.x/16)*(playable_bounds.arena.right-playable_bounds.arena.left));
			local dice_box_y = math.floor(playable_bounds.arena.top + (self.position.y/9)*(playable_bounds.arena.bottom-playable_bounds.arena.top));
			if (math.abs(target_x - dice_box_x) < self.sprite:getWidth()*pixel_size/2 and math.abs(target_y - dice_box_y) < self.sprite:getHeight()*pixel_size/2) then 
				if debug then
					print("["..dice_box.name.."].answer_message -> targeted, message answered (dice put in box)");
				end
				self.has_dice_inside = true;
				self.dice = sender;
				sender.has_box = true;
				sender.box = self;
				return true;
			end
		end
		print("["..dice_box.name.."].answer_message -> not targeted, message ignored (dice not put in box)");
		return false;
	end
	function dice_box.draw(self) 
		love.graphics.setColor(self.color.r, self.color.g, self.color.b);
		local dice_box_x = math.floor(playable_bounds.arena.left + (self.position.x/16)*(playable_bounds.arena.right-playable_bounds.arena.left)-self.sprite:getWidth()*pixel_size/2);
		local dice_box_y = math.floor(playable_bounds.arena.top + (self.position.y/9)*(playable_bounds.arena.bottom-playable_bounds.arena.top));
		love.graphics.draw(self.sprite, dice_box_x, dice_box_y-self.sprite:getHeight()*pixel_size/2,0,pixel_size,pixel_size);
		love.graphics.setColor(255, 255, 255);
	end
	return dice_box;
end
return Dice_box;
