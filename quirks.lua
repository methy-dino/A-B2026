local Quirks = {};
function Quirks.basic_damage()
	local tmp = {};
	tmp.activations = 1;
	tmp.initial_activations = 1;
	 function tmp.attempt(self, entity, face)
		 if self.activations > 0 and entity.type == "enemy" then
			self.activations = self.activations - 1;
			entity.health = entity.health - face.value;
		 end

		function tmp.reset(self)
			self.activations = self.initial_activations;
		end

		function tmp.hard_reset(self)
			self.activations = self.initial_activations;
		end

 end
 return tmp;
end
function Quirks.single_use_damage()
	local tmp = {};
	tmp.uses = 1;
	tmp.initial_uses = 1;
	 function tmp.attempt(self, entity, face)
		 print(self.uses);
		 if self.uses > 0 and entity.type == "enemy" then
			self.uses = self.uses - 1;
			entity.health = entity.health - face.value;
		 if self.uses == 0 then 
			 face.color.r = 1;
			 face.color.g = 0;
			 face.color.b = 0;
		 end
		 end
 end
		function tmp.reset(self)
		end
		function tmp.hard_reset(self)
			self.uses = self.initial_uses;
		end
 return tmp;
end
return Quirks;
