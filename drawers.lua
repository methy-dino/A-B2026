local Drawers = {};
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
		love.graphics.print("ARENA (16 X 9)", playable_bounds.arena.left+50, playable_bounds.arena.top+20);
	end
end
return Drawers;
