-- faces must be: composed of length, face[i].value, face[i].quirks, 
local Dice = {};
Dice.die_font = love.graphics.newFont("kiwi.ttf", 60);
function Dice.new_face(value, quirks) 
	local face = {};
	face.value = value;
	face.quirks = quirks;
	face.color = {};
	face.color.r = 1;
	face.color.g = 1;
	face.color.b = 1;
	function face.exec(self, entity)
		for i = 1, self.quirks.length do
			-- acao certa
			self.quirks[i]:attempt(entity, face);
			self.quirks[i]:reset();
		end
	end
	return face;
end

function Dice.new_enemy_die(faces, color, sprite)
	local die = {};
	die.name = "generic enemy die";
	die.faces = faces;
	die.color = color;
	die.curr_face = 1;
	die.sprite = sprite;
	die.position = {};
	die.position.x = 9;
	die.position.y = 4.5;
	die.position.origin_x = 9;
	die.position.origin_y = 4.5;
	die.has_click_focus = false;
	die.type = "dice";
	die.has_box = false;
	die.box = nil;
	die.spent = false;
	die.original_ind = 0;
	die.acumulated_dt = 0;
	function die.roll(self, sched) 
		local i = math.random(1, self.faces.length);
		if not (i == self.curr_face) then
			self.curr_face = math.random(1, self.faces.length);
		end
		sched:execute(self.faces[self.curr_face],"exec");
	end	
	function die.answer_message(self, sender, message) 
		return false;
	end
	function die.update(self, dt)
		if self.has_box then
			self.acumulated_dt = self.acumulated_dt + dt;
			if self.acumulated_dt > 0.5 then
				self.color.r = math.random();
				self.color.g = math.random();
				self.color.b = math.random();
				self.curr_face = self.curr_face + math.random(1, self.faces.length-1);
				if self.curr_face > self.faces.length then
					self.curr_face = self.curr_face - self.faces.length;
				end
				self.acumulated_dt = 0;
			end
		end
		local die_x = math.floor(playable_bounds.arena.left + (self.position.x/16)*(playable_bounds.arena.right-playable_bounds.arena.left));
		local die_y = math.floor(playable_bounds.arena.top + (self.position.y/9)*(playable_bounds.arena.bottom-playable_bounds.arena.top));
		local target_x = 0;
		local target_y = 0;
		if self.has_click_focus then 
			target_x, target_y = love.mouse.getPosition();
		elseif self.has_box == true then
			target_x = math.floor(playable_bounds.arena.left + (self.box.position.x/16)*(playable_bounds.arena.right-playable_bounds.arena.left));
			target_y = math.floor(playable_bounds.arena.top + (self.box.position.y/9)*(playable_bounds.arena.bottom-playable_bounds.arena.top));
		else 
			target_x = math.floor(playable_bounds.arena.left + (self.position.origin_x/16)*(playable_bounds.arena.right-playable_bounds.arena.left));
			target_y = math.floor(playable_bounds.arena.top + (self.position.origin_y/9)*(playable_bounds.arena.bottom-playable_bounds.arena.top));
		end
				local x_diff = (target_x - die_x);
				local y_diff = (target_y - die_y);
				local vec_mod = math.sqrt(math.pow(x_diff,2) + math.pow(y_diff, 2));
				if not(vec_mod < 0.0001) then 
				local x_change = x_diff / vec_mod * math.abs(x_diff*dt*10);
				if math.abs(x_diff-x_change) < 60*dt then
					x_change = x_diff;
				end
				if x_change > 0 then
					x_change = math.ceil(x_change);
				else 
					x_change = math.floor(x_change);
				end
				local y_change = y_diff / vec_mod * math.abs(y_diff*dt*10);
				if math.abs(y_diff-y_change) < 60*dt then
						y_change = y_diff;
				end
				if y_change > 0 then
					y_change = math.ceil(y_change);
				else 
					y_change = math.floor(y_change);
				end
				self.position.x = (die_x+x_change-playable_bounds.arena.left)/(playable_bounds.arena.right-playable_bounds.arena.left)*16;
				self.position.y = (die_y+y_change-playable_bounds.arena.top)/(playable_bounds.arena.bottom-playable_bounds.arena.top)*9;
			end
	end
	function die.answer_mouse_up(self, x, y, button, sched, my_i)
		return false;
	end
	function die.answer_mouse_down(self, x, y, button, sched, my_i)
		if Combat_lock and self.spent == false then
			self:roll(sched);
			self.spent = true;
			return true;
		end
		return false;
	end
	function die.draw(self) 
		love.graphics.setColor(self.color.r, self.color.g, self.color.b);
		local die_x = math.floor(playable_bounds.arena.left + (self.position.x/16)*(playable_bounds.arena.right-playable_bounds.arena.left)-self.sprite:getWidth()*pixel_size/2);
		local die_y = math.floor(playable_bounds.arena.top + (self.position.y/9)*(playable_bounds.arena.bottom-playable_bounds.arena.top));
		love.graphics.draw(self.sprite, die_x, die_y-self.sprite:getHeight()*pixel_size/2,0,pixel_size,pixel_size);
		love.graphics.setFont(Dice.die_font);
		local width_text = Dice.die_font:getWidth(self.faces[self.curr_face].value.."");
		love.graphics.setColor(self.faces[self.curr_face].color.r, self.faces[self.curr_face].color.g, self.faces[self.curr_face].color.b);
		love.graphics.printf(self.faces[self.curr_face].value.."", die_x, math.floor(die_y-Dice.die_font:getHeight()/2), self.sprite:getWidth()*pixel_size, "center");
	end
	return die;
end

function Dice.new_die(faces, color, sprite)
	local die = {};
	die.name = "generic die";
	die.faces = faces;
	die.color = color;
	die.curr_face = 1;
	die.sprite = sprite;
	die.position = {};
	die.position.x = 9;
	die.position.y = 4.5;
	die.position.origin_x = 9;
	die.position.origin_y = 4.5;
	die.has_click_focus = false;
	die.type = "dice";
	die.has_box = false;
	die.box = nil;
	die.original_ind = 0;
	die.acumulated_dt = 0;
	function die.roll(self, sched) 
		local i = math.random(1, self.faces.length);
		if not (i == self.curr_face) then
			self.curr_face = math.random(1, self.faces.length);
		end
		sched:execute(self.faces[self.curr_face],"exec");
	end	
	function die.answer_message(self, sender, message) 
		return false;
	end
	function die.update(self, dt)
		if self.has_box then
			self.acumulated_dt = self.acumulated_dt + dt;
			if self.acumulated_dt > 0.5 then
				self.curr_face = self.curr_face + math.random(1, self.faces.length-1);
				if self.curr_face > self.faces.length then
					self.curr_face = self.curr_face - self.faces.length;
				end
				self.acumulated_dt = 0;
			end
		end
		local die_x = math.floor(playable_bounds.arena.left + (self.position.x/16)*(playable_bounds.arena.right-playable_bounds.arena.left));
		local die_y = math.floor(playable_bounds.arena.top + (self.position.y/9)*(playable_bounds.arena.bottom-playable_bounds.arena.top));
		local target_x = 0;
		local target_y = 0;
		if self.has_click_focus then 
			target_x, target_y = love.mouse.getPosition();
		elseif self.has_box == true then
			target_x = math.floor(playable_bounds.arena.left + (self.box.position.x/16)*(playable_bounds.arena.right-playable_bounds.arena.left));
			target_y = math.floor(playable_bounds.arena.top + (self.box.position.y/9)*(playable_bounds.arena.bottom-playable_bounds.arena.top));
		else 
			target_x = math.floor(playable_bounds.arena.left + (self.position.origin_x/16)*(playable_bounds.arena.right-playable_bounds.arena.left));
			target_y = math.floor(playable_bounds.arena.top + (self.position.origin_y/9)*(playable_bounds.arena.bottom-playable_bounds.arena.top));
		end
				local x_diff = (target_x - die_x);
				local y_diff = (target_y - die_y);
				local vec_mod = math.sqrt(math.pow(x_diff,2) + math.pow(y_diff, 2));
				if not(vec_mod < 0.0001) then 
				local x_change = x_diff / vec_mod * math.abs(x_diff*dt*10);
				if math.abs(x_diff-x_change) < 60*dt then
					x_change = x_diff;
				end
				if x_change > 0 then
					x_change = math.ceil(x_change);
				else 
					x_change = math.floor(x_change);
				end
				local y_change = y_diff / vec_mod * math.abs(y_diff*dt*10);
				if math.abs(y_diff-y_change) < 60*dt then
						y_change = y_diff;
				end
				if y_change > 0 then
					y_change = math.ceil(y_change);
				else 
					y_change = math.floor(y_change);
				end
				self.position.x = (die_x+x_change-playable_bounds.arena.left)/(playable_bounds.arena.right-playable_bounds.arena.left)*16;
				self.position.y = (die_y+y_change-playable_bounds.arena.top)/(playable_bounds.arena.bottom-playable_bounds.arena.top)*9;
			end
	end
	function die.answer_mouse_up(self, x, y, button, sched, my_i)
		if self.has_click_focus then
			print("["..die.name.."].answer_mouse_up -> had click focus, input answered");
			self.has_click_focus = false;
				sched:move(my_i, die.original_ind); 	
				if sched:message(self, "") == false then
				print("["..die.name.."].answer_mouse_up -> snapped to original position");
				end
				return true;
		end
		print("["..self.name.."].answer_mouse_up -> no click focus, input ignored");
		return false;
	end
	function die.gain_click_focus(self, sched, my_i)
				if self.has_box then
					self.has_box = false;
					self.box.has_dice_inside = false;
					self.box.dice_inside = nil;
					self.box = nil;
				end
				self.original_ind = my_i;
				self.has_click_focus = true;
				sched:move(my_i, sched.entities.length); 	
	end
	function die.answer_mouse_down(self, x, y, button, sched, my_i)
		if Combat_lock then
			return false;
		end
		local die_x = math.floor(playable_bounds.arena.left + (self.position.x/16)*(playable_bounds.arena.right-playable_bounds.arena.left)-self.sprite:getWidth()*pixel_size/2);
		local die_y = math.floor(playable_bounds.arena.top + (self.position.y/9)*(playable_bounds.arena.bottom-playable_bounds.arena.top)-self.sprite:getHeight()*pixel_size/2);
		if y >= die_y and y <= die_y + self.sprite:getHeight()*pixel_size then
			if x >= die_x and x <= die_x + self.sprite:getWidth()*pixel_size then
				if button == 1 then
					print("["..self.name.."].answer_mouse_down -> targeted, input answered");
					die:gain_click_focus(sched, my_i);
				elseif button == 2 then
					print("["..self.name.."].answer_mouse_down -> targeted, input answered (button = 2)");
				end
				return true;
			end
		end
		print("["..self.name.."] die.answer_mouse_down -> not targeted, input ignored");
		return false;
	end
	function die.draw(self) 
		love.graphics.setColor(self.color.r, self.color.g, self.color.b);
		local die_x = math.floor(playable_bounds.arena.left + (self.position.x/16)*(playable_bounds.arena.right-playable_bounds.arena.left)-self.sprite:getWidth()*pixel_size/2);
		local die_y = math.floor(playable_bounds.arena.top + (self.position.y/9)*(playable_bounds.arena.bottom-playable_bounds.arena.top));
		love.graphics.draw(self.sprite, die_x, die_y-self.sprite:getHeight()*pixel_size/2,0,pixel_size,pixel_size);
		love.graphics.setFont(Dice.die_font);
		local width_text = Dice.die_font:getWidth(self.faces[self.curr_face].value.."");
		love.graphics.setColor(self.faces[self.curr_face].color.r, self.faces[self.curr_face].color.g, self.faces[self.curr_face].color.b);
		love.graphics.printf(self.faces[self.curr_face].value.."", die_x, math.floor(die_y-Dice.die_font:getHeight()/2), self.sprite:getWidth()*pixel_size, "center");
	end
	return die;
end
return Dice;
