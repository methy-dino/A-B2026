
love.graphics.setDefaultFilter("nearest", "nearest")
local Player = require("player")
function love.load()
   image = love.graphics.newImage("cobble.jpg")
	 face_rolada = -1;
   love.graphics.setNewFont(12)
   love.graphics.setColor(0,0,0)
   love.graphics.setBackgroundColor(255,255,255)
	 love.window.setFullscreen(true);
	 dt_acumulado = 0;
	 dado = {5, '1', '2', '3', '4', '5', '6'};
	 dado.atual = 2;
	 function dado.rolar() 
		 max = dado[1];
		 dado.atual = math.floor(math.random(0, max)+0.5) + 2;
	 end
	 ind_face = 2;
	 playable_bounds = {};
	 playable_bounds.bottom = 0; 
	 bottom = 0;
	 top = 0;
	 left = 0;
	 right = 0;
	 adequado = 0;
	 altura_janela = love.graphics.getHeight();
	 largura_janela = love.graphics.getWidth();
	 print("altura = "..altura_janela.."\n largura = "..largura_janela);
	 width = largura_janela;
	 height = math.floor((width/4)*3);
	 if height <= altura_janela then
		 adequado = 1;
	 end 
	 if adequado == 0 then
		 height = altura_janela;
		 width= math.floor((height/3)*4);
		 adequado = 1;
	 end
		-- configurar vordas
		left = (largura_janela-width)/2;
		right = largura_janela - left;
		top = (altura_janela-height)/2;
		bottom = altura_janela - top;
	 playable_bounds.bottom = bottom; 
	 playable_bounds.top = top; 
	 playable_bounds.right = right; 
	 playable_bounds.left = left; 
	 playable_bounds.arena = {};
	 playable_bounds.arena.left = playable_bounds.left + math.floor((playable_bounds.right-playable_bounds.left)/100 * 5 + 0.5);
	 playable_bounds.arena.right = playable_bounds.right - (playable_bounds.arena.left-playable_bounds.left);
	 playable_bounds.arena.top = playable_bounds.top + math.floor((playable_bounds.bottom-playable_bounds.top)/4 + (playable_bounds.bottom-(playable_bounds.bottom-playable_bounds.top)/4)/100 * 5 + 0.5);
	 playable_bounds.arena.bottom = playable_bounds.bottom - (playable_bounds.arena.top - ((playable_bounds.bottom-playable_bounds.top)/4));
	 playable_bounds.hud = {};
	 playable_bounds.hud.left = playable_bounds.left;
	 playable_bounds.hud.right = playable_bounds.right;
	 playable_bounds.hud.top = playable_bounds.top;
	 playable_bounds.hud.bottom = playable_bounds.top + (playable_bounds.bottom-playable_bounds.top)/4;
	 print("left = "..left.."\n right = "..right);
	 print("\ntop = "..(playable_bounds.bottom-playable_bounds.top)/4 .."\n bottom = "..bottom);
	 print("\n ARENA DIMENSIONS\n");
	 print("left = "..playable_bounds.arena.left.."\n right = "..playable_bounds.arena.right);
	 print("\ntop = "..playable_bounds.arena.top.."\n bottom = "..playable_bounds.arena.bottom);
end

function selecionar_numero()
	face_atual = dado.atual;
	dado.rolar();
	if (dado.atual == face_atual) then
		face_rolada = dado.atual;
	else 
		dado.rolar();
		face_rolada = dado.atual;
	end
end

function love.update(dt)
   if love.keyboard.isDown("up") and (face_rolada == -1) then
		 selecionar_numero();
   end
   if love.keyboard.isDown("down") and not (face_rolada == -1) then
		 face_rolada = -1;
		 dt_acumulado = 1;
   end
	 dt_acumulado = dt_acumulado + dt;
	 if dt_acumulado > 0.5 then 
		 dado.rolar();
		 dt_acumulado = 0;
	 end
	 Player.character.move(dt);
end
-- references <BOOLEAN> = desenhar referencias de depuração
function draw_base_interface(references) 
	love.graphics.clear(0,0,0,1);
	love.graphics.setColor(255, 255, 255);
		love.graphics.draw(image, playable_bounds.left, playable_bounds.top, 0,(playable_bounds.right-playable_bounds.left)/image:getWidth(), (playable_bounds.bottom-playable_bounds.top)/image:getHeight());
	if references then
		love.graphics.setColor(0,255,0)
		love.graphics.line(left, top, left, bottom);
		love.graphics.line(right, top, right, bottom);
		love.graphics.line(right, top, left, top);
		love.graphics.line(right, bottom, left, bottom);
		love.graphics.line(right, top+((bottom-top)/4), left, top+((bottom-top)/4));
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
function love.draw()
	draw_base_interface(true);
	love.graphics.setColor(255, 255, 255);
	Player.character.draw(0.1);
	-- love.graphics.print("seu personagem aqui", 400, 600);
	-- love.graphics.print("acao inimigo aqui", 800, 300);
	-- love.graphics.print("inimigo aqui", 800, 600);
	if (face_rolada == -1) then
--			love.graphics.print("face dado = "..dado[dado.atual], 400, 300);
	else 
	--		love.graphics.print("voce rolou "..dado[face_rolada].."  SETA BAIXO PARA REROLAR", 400, 300);
	end
end
