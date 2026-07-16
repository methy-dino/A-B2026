local Scheduler = {};
function Scheduler.new_scheduler()
	local sched = {};
	sched.entities = {};
	sched.entities.length = 0;
	function sched.update(self, dt)
		local i = self.entities.length;
		while i > 0 do
			self.entities[i]:update(dt);
			i = i - 1;
		end
	end
	function sched.answer_mouse_down(self, x, y, button)
		local i = self.entities.length;
		used = {};
		local retorno = false;
		while i > 0 and retorno == false do
			retorno = self.entities[i]:answer_mouse_down(x, y, button, self, i);
			i = i - 1;
		end
		return retorno;
	end
	function sched.answer_mouse_up(self, x, y, button)
		local i = self.entities.length;
		used = {};
		local retorno = false;
		while i > 0 and retorno == false do
			retorno = self.entities[i]:answer_mouse_up(x, y, button, self, i);
			i = i - 1;
		end
		return retorno;
	end
	function sched.draw(self)
		local i = 1;
		while i <= self.entities.length do
			self.entities[i]:draw();
			i = i + 1;
		end
	end
	function sched.add(self, entity) 
		self.entities.length = self.entities.length + 1;
		self.entities[self.entities.length] = entity;
	end
	function sched.answer_message(self, sender, message) 
		local i = self.entities.length;
		local retorno = false;
		while i > 0 and retorno == false do
			retorno = self.entities[i]:answer_message(sender, message);
			i = i - 1;
		end
		return retorno;
	end
	function sched.message(self, sender, message) 
		local i = self.entities.length;
		local retorno = false;
		while i > 0 and retorno == false do
			retorno = self.entities[i]:answer_message(sender, message);
			i = i - 1;
		end
		return retorno;
	end
	function sched.move(self, ind, new_ind)
		local tmp = self.entities[ind];
		if ind > new_ind then 
		local i = ind;
		while i > new_ind do
			self.entities[i] = self.entities[i-1];
			i = i - 1;
		end
		else
		local i = ind;
		while i <= new_ind do
			self.entities[i] = self.entities[i+1];
			i = i + 1;
		end
	end
		self.entities[new_ind] = tmp;
	end
	function sched.execute(self, caller, fn_name)
		local i = self.entities.length;
		while i > 0 do
			caller[fn_name](caller, self.entities[i]);
			i = i - 1;
		end
	end
	return sched;
end
return Scheduler;
