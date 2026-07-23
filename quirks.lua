local Quirks = {};
Quirks.sprites= {};
Quirks.sprites.sheet = love.graphics.newImage("quirks.png")
Quirks.sprites.basic_damage = love.graphics.newQuad(0, 0, 16, 16, Quirks.sprites.sheet:getDimensions());
Quirks.sprites.basic_shield = love.graphics.newQuad(0, 16, 16, 16, Quirks.sprites.sheet:getDimensions());
Quirks.sprites.single_use_damage = love.graphics.newQuad(16, 0, 16, 16, Quirks.sprites.sheet:getDimensions());
Quirks.sprites.single_use_damage_spent = love.graphics.newQuad(32, 0, 16, 16, Quirks.sprites.sheet:getDimensions());
Quirks.sprites.reroll_bg = love.graphics.newQuad(0, 80, 16, 16, Quirks.sprites.sheet:getDimensions());
Quirks.sprites.vampirism_bg = love.graphics.newQuad(16, 80, 16, 16, Quirks.sprites.sheet:getDimensions());
function Quirks.reroll_subquirk(quirk, uses)
	quirk.subquirks.length = quirk.subquirks.length + 1;
	quirk.subquirks[quirk.subquirks.length] = {};
	quirk.subquirks[quirk.subquirks.length].uses = uses;
	quirk.subquirks[quirk.subquirks.length].max_uses = uses;
	local curr = quirk.subquirks[quirk.subquirks.length];
	function curr.draw(self, die_x, die_y)	
		if self.uses == 0 then 
			love.graphics.setColor(0.6,0.6,0.6);
		else
			love.graphics.setColor((15*16+5)/255,(15+11*16)/255,3/255);
		end
		love.graphics.draw(Quirks.sprites.sheet, Quirks.sprites.reroll_bg, die_x, die_y,0,pixel_size, pixel_size);
	end
	function curr.activate(self, face, dice, quirk)	
		if self.uses > 0 and dice.spent == true then
			self.uses = self.uses - 1;
			dice.spent = false;
			dice.wait_timer = 2;
			quirk.uses = quirk.uses + quirk.restored_uses;
			dice.acumulated_dt = 0;
		end
	end
	function curr.reset(self) 
		self.uses = self.max_uses;
	end
	function curr.hard_reset(self) 
		self.uses = self.max_uses;
	end
	return quirk
end
function Quirks.vampirism_subquirk(quirk, uses)
	quirk.subquirks.length = quirk.subquirks.length + 1;
	quirk.subquirks[quirk.subquirks.length] = {};
	quirk.subquirks[quirk.subquirks.length].uses = uses;
	quirk.subquirks[quirk.subquirks.length].max_uses = uses;
	local curr = quirk.subquirks[quirk.subquirks.length];
	function curr.draw(self, die_x, die_y)	
		if self.uses == 0 then 
			love.graphics.setColor(0.6,0.6,0.6);
		else
			love.graphics.setColor(0.65,0,0);
		end
		love.graphics.draw(Quirks.sprites.sheet, Quirks.sprites.vampirism_bg, die_x, die_y,0,pixel_size, pixel_size);
	end
	function curr.activate(self, face, dice, quirk)	
		if self.uses > 0 and dice.spent == true then
			self.uses = self.uses - 1;
			dice.owner.health = dice.owner.health + math.ceil(face.value/2);
			if dice.owner.health > dice.owner.maxHealth then
				dice.owner.health = dice.owner.health
			end
		end
	end
	function curr.reset(self) 
		self.uses = self.max_uses;
	end
	function curr.hard_reset(self) 
		self.uses = self.max_uses;
	end
	return quirk
end
function Quirks.draw_value(die_x, die_y, value) 
			local add_x = 12;
			local add_y = 13;
		love.graphics.setColor(0.1,0.1,0.1);
			while value >= 5 do
			love.graphics.rectangle("fill", die_x+pixel_size*add_x, die_y+pixel_size*add_y-pixel_size*2,pixel_size*2, pixel_size*3);
			add_y = add_y - 4;
			value = value - 5;
			end
			while value > 0 do
			love.graphics.rectangle("fill", die_x+pixel_size*add_x, die_y+pixel_size*add_y,pixel_size*2, pixel_size);
			add_y = add_y - 2;
			value = value - 1;
		end
end
function Quirks.basic_damage(targets)
	local tmp = {};
	tmp.type = "offensive";
	tmp.subquirks = {};
	tmp.subquirks.length = 0;
	tmp.uses = 1;
	tmp.targets = targets;
	tmp.initial_uses = 1;
	tmp.restored_uses = 1;
	tmp.lock = false;
	 function tmp.attempt(self, entity, face, ...)
		 local tmp = select(1,...);
		 for i = 1, self.targets.length do
			 if entity.type == self.targets[i] then
				select(1,...).spent = true;
				 if self.uses > 0 then
					self.uses = self.uses - 1;
					if entity.shield > 0 then
						entity.shield = entity.shield - face.value;
						if entity.shield < 0 then
						entity.health = entity.health + entity.shield;
						entity.shield = 0;
					end
					else 
						entity.health = entity.health - face.value;
					end
				end
				for i = 1, self.subquirks.length do
					self.subquirks[i]:activate(face, tmp, self)
				end
			 end
		 end
		 return true;
	 end
		function tmp.reset(self)
			self.uses = self.initial_uses;
			lock = false;
			for i = 1, self.subquirks.length do
				self.subquirks[i]:reset();
			end
		end

		function tmp.hard_reset(self)
			self.uses = self.initial_uses;
			for i = 1, self.subquirks.length do
				self.subquirks[i]:hard_reset();
			end
		end
		function tmp.draw(self, die_x, die_y, face) 
				for i = 1, self.subquirks.length do
					self.subquirks[i]:draw(die_x,die_y);
				end
			if self.uses > 0 then
			love.graphics.setColor(1,1,1);
		else
			love.graphics.setColor(0.6,0.6,0.6);
		end
			love.graphics.draw(Quirks.sprites.sheet, Quirks.sprites.basic_damage, die_x, die_y,0,pixel_size, pixel_size);
			Quirks.draw_value(die_x, die_y, face.value);
		end
 return tmp;
 end
function Quirks.single_use_damage(targets)
	local tmp = {};
	tmp.type = "offensive";
	tmp.uses = 1;
	tmp.initial_uses = 1;
	tmp.restored_uses = 0;
	tmp.subquirks = {};
	tmp.subquirks.length = 0;
	tmp.targets = targets;
	 function tmp.attempt(self, entity, face, ...)
		local tmp = select(1, ...);
		 for i = 1, self.targets.length do
			 if entity.type == self.targets[i] then
				 select(1, ...).spent = true;
				 if self.uses > 0 then
					self.uses = self.uses - 1;
					if entity.shield > 0 then
						entity.shield = entity.shield - face.value;
						if entity.shield < 0 then
						entity.health = entity.health + entity.shield;
						entity.shield = 0;
					end
					else 
						entity.health = entity.health - face.value;
					end
				end
				for i = 1, self.subquirks.length do
					self.subquirks[i]:activate(face, tmp, self)
				end
		 end
	 end
		 return true;
 end
		function tmp.reset(self)
			for i = 1, self.subquirks.length do
				self.subquirks[i]:reset();
			end
		end
		function tmp.hard_reset(self)
			for i = 1, self.subquirks.length do
				self.subquirks[i]:hard_reset();
			end
			self.uses = self.initial_uses;
		end
		function tmp.draw(self, die_x, die_y, face) 
				for i = 1, self.subquirks.length do
					self.subquirks[i]:draw(die_x,die_y);
				end
			if self.uses > 0 then
			love.graphics.setColor(1,1,1);
			love.graphics.draw(Quirks.sprites.sheet, Quirks.sprites.single_use_damage, die_x, die_y,0,pixel_size, pixel_size);
		else
			love.graphics.setColor(0.6,0.6,0.6);
			love.graphics.draw(Quirks.sprites.sheet, Quirks.sprites.single_use_damage_spent, die_x, die_y,0,pixel_size, pixel_size);
		end
			Quirks.draw_value(die_x, die_y, face.value);
		end
 return tmp;
end

function Quirks.basic_shield(targets)
	local tmp = {};
	tmp.type = "defensive";
	tmp.subquirks = {};
	tmp.subquirks.length = 0;
	tmp.uses = 1;
	tmp.targets = targets;
	tmp.initial_uses = 1;
	tmp.restored_uses = 1;
	tmp.lock = false;
	 function tmp.attempt(self, entity, face, ...)
		 local tmp = select(1,...);
		 for i = 1, self.targets.length do
			 if entity.type == self.targets[i] then
				select(1,...).spent = true;
				 if self.uses > 0 then
					self.uses = self.uses - 1;
					entity.shield = entity.shield + face.value;
				end
				for i = 1, self.subquirks.length do
					self.subquirks[i]:activate(face, tmp, self)
				end
			 end
		 end
		 return true;
	 end
		function tmp.reset(self)
			self.uses = self.initial_uses;
			lock = false;
			for i = 1, self.subquirks.length do
				self.subquirks[i]:reset();
			end
		end

		function tmp.hard_reset(self)
			self.uses = self.initial_uses;
			for i = 1, self.subquirks.length do
				self.subquirks[i]:hard_reset();
			end
		end
		function tmp.draw(self, die_x, die_y, face) 
				for i = 1, self.subquirks.length do
					self.subquirks[i]:draw(die_x,die_y);
				end
			if self.uses > 0 then
			love.graphics.setColor(1,1,1);
		else
			love.graphics.setColor(0.6,0.6,0.6);
		end
			love.graphics.draw(Quirks.sprites.sheet, Quirks.sprites.basic_shield, die_x, die_y,0,pixel_size, pixel_size);
			Quirks.draw_value(die_x, die_y, face.value);
		end
 return tmp;
 end
 Quirks.quirks= {};
 Quirks.quirks.length = 3;
Quirks.quirks[1] = Quirks.basic_damage;
Quirks.quirks[2] = Quirks.single_use_damage;
Quirks.quirks[3] = Quirks.basic_shield;
Quirks.subquirks = {};
 Quirks.subquirks.length = 1;
Quirks.subquirks[1] = Quirks.reroll_subquirk;
--Quirks.subquirks[2] = Quirks.vampirism_subquirk;
return Quirks;
