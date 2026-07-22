local Life_bar = {};
function Life_bar.create_drawer(filled_image, empty_image, x1, x2)
	local image_height = filled_image:getHeight();
	local image_width = filled_image:getHeight();
	local life_bar = {};
	life_bar.x = 0;
	life_bar.x1 = x1;
	life_bar.x2 = x2;
	life_bar.y = 0;
	life_bar.filled = {};
	life_bar.filled.image = filled_image;
	life_bar.filled.quads = {};
	life_bar.empty = {};
	life_bar.empty.image = empty_image;
	life_bar.empty.quads = {};
	table.insert(life_bar.empty.quads, love.graphics.newQuad(0, 0, x1, image_height, empty_image:getDimensions()));
	table.insert(life_bar.empty.quads, love.graphics.newQuad(x1, 0, x2-x1, image_height, empty_image:getDimensions()));
	table.insert(life_bar.empty.quads, love.graphics.newQuad(x2, 0, image_width-x2, image_height, empty_image:getDimensions()));
	table.insert(life_bar.filled.quads, love.graphics.newQuad(0, 0, x1, image_height, filled_image:getDimensions()));
	table.insert(life_bar.filled.quads, love.graphics.newQuad(x1, 0, x2-x1, image_height, filled_image:getDimensions()));
	table.insert(life_bar.filled.quads, love.graphics.newQuad(x2, 0, image_width-x2, image_height, filled_image:getDimensions()));
	function life_bar.draw(self, max_hp, curr_hp, shield) 	
			love.graphics.setColor(1, 1, 1);
		love.graphics.draw(life_bar.empty.image, life_bar.empty.quads[1], self.x, self.y, 0,pixel_size, pixel_size);
			love.graphics.setColor(1, 1, 1);
		love.graphics.draw(life_bar.empty.image, life_bar.empty.quads[2], self.x+pixel_size*self.x1, self.y, 0,pixel_size*(max_hp-1), pixel_size);
			love.graphics.setColor(1, 1, 1);
		love.graphics.draw(life_bar.empty.image, life_bar.empty.quads[3], self.x+pixel_size*(max_hp-1)*(self.x2-self.x1) + pixel_size*self.x1, self.y, 0,pixel_size, pixel_size);
		if curr_hp > 0 then
			love.graphics.setColor(0, 1, 0);
		love.graphics.draw(life_bar.filled.image, life_bar.filled.quads[1], self.x, self.y, 0,pixel_size, pixel_size);
		love.graphics.draw(life_bar.filled.image, life_bar.filled.quads[2], self.x+pixel_size*self.x1, self.y, 0,pixel_size*(curr_hp-1), pixel_size);
		love.graphics.draw(life_bar.filled.image, life_bar.filled.quads[3], self.x+pixel_size*(curr_hp-1)*(self.x2-self.x1) + pixel_size*self.x1, self.y, 0,pixel_size, pixel_size);
		end
		if shield > 0 then
			love.graphics.setColor(1, 1, 1);
		love.graphics.draw(life_bar.filled.image, life_bar.filled.quads[1], self.x, self.y, 0,pixel_size, pixel_size);
		love.graphics.draw(life_bar.filled.image, life_bar.filled.quads[2], self.x+pixel_size*self.x1, self.y, 0,pixel_size*(shield-1), pixel_size);
		love.graphics.draw(life_bar.filled.image, life_bar.filled.quads[3], self.x+pixel_size*(shield-1)*(self.x2-self.x1) + pixel_size*self.x1, self.y, 0,pixel_size, pixel_size);
		end
	end
	return life_bar;
end
return Life_bar;
