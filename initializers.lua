local Init = {};
function Init.start_battle_interface(player, enemies)
	local battle_scheduler = Scheduler.new_scheduler(); 
	player.character.position.x = 3;
	player.character.position.y = 4.5;
	local box_image = love.graphics.newImage("dado_caixa.png");
	battle_scheduler:add(player.character);
	player.max_actions = 2;
	local color = {};
	color.r = 157/255;
	color.g = 108/255;
	color.b = 60/255;
	local ref_width = (box_image:getWidth()*pixel_size)/(playable_bounds.arena.right-playable_bounds.arena.left)*16;
	local ref_height = (box_image:getHeight()*pixel_size)/(playable_bounds.arena.right-playable_bounds.arena.left)*16;
	local player_ref_height = (player.character.sprite_height*pixel_size)/(playable_bounds.arena.right-playable_bounds.arena.left)*16;
	local total_width_consumed = ref_width * player.max_actions + (player.max_actions - 1)*0.1; 
	local ref_x = player.character.position.x - total_width_consumed/2 + ref_width/2;
	local ref_y = player.character.position.y - player_ref_height/2 - ref_height/2 -0.3;
	for i = enemies.length,1,-1 do
	 battle_scheduler:add(enemies[i]);
	 battle_scheduler:add(enemies[i].die);
	end
	for i = player.max_actions,1,-1 do
	 local caixa_teste = Dice_box.new_dice_box(color, box_image);
	 caixa_teste.position.x = ref_x + 1.1 * ref_width * (i-1);
	 caixa_teste.position.y = ref_y;
	 battle_scheduler:add(caixa_teste);
	end
	Player.character.inventory.init_drawer(battle_scheduler);
	return battle_scheduler;
end
function Init.game_init()
	print("[ GAME INIT START ]");
	Player.init();
	local root_scheduler = Scheduler.new_scheduler(); 
	love.graphics.setNewFont("kiwi.ttf", 25);
	love.graphics.setColor(0,0,0);
	love.graphics.setBackgroundColor(255,255,255);
	love.window.setFullscreen(true);
	playable_bounds = {};
	playable_bounds.bottom = 0; 
	local bottom = 0;
	local top = 0;
	local left = 0;
	local right = 0;
	local adequado = 0;
	local altura_janela = love.graphics.getHeight();
	local largura_janela = love.graphics.getWidth();
	print("screen dimensions:");
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
	local left = (largura_janela-width)/2;
	local right = largura_janela - left;
	local top = (altura_janela-height)/2;
	local bottom = altura_janela - top;
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
	print("[ PLAYABLE DIMENSIONS ]");
	print("left = "..left.."\n right = "..right);
	print("top = "..(playable_bounds.bottom-playable_bounds.top)/4 .."\n bottom = "..bottom);
	print("[ ARENA DIMENSIONS ]");
	print("left = "..playable_bounds.arena.left.."\nright = "..playable_bounds.arena.right);
	print("top = "..playable_bounds.arena.top.."\nbottom = "..playable_bounds.arena.bottom);
	print("[ GAME INIT END ]");
	pixel_size = math.floor((playable_bounds.right-playable_bounds.left)/256 + 0.49);
	return root_scheduler;
end
function Init.new_color(r, g, b)
	local ret = {};
	ret.r = r;
	ret.g = g;
	ret.b = b;
	return ret;
end

return Init;
