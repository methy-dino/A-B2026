local Quirks = {};
function Quirks.basic_damage(targets)
	local tmp = {};
	tmp.activations = 1;
	tmp.targets = targets;
	tmp.initial_activations = 1;
	 function tmp.attempt(self, entity, face)
		 for i = 0, self.targets.length do
			 if self.activations > 0 and entity.type == tmp.targets[i] then
				self.activations = self.activations - 1;
				entity.health = entity.health - face.value;
			 end
		 end
	 end
		function tmp.reset(self)
			self.activations = self.initial_activations;
		end

		function tmp.hard_reset(self)
			self.activations = self.initial_activations;
		end

 return tmp;
 end
function Quirks.single_use_damage(targets)
	local tmp = {};
	tmp.uses = 1;
	tmp.initial_uses = 1;
	tmp.targets = targets;
	 function tmp.attempt(self, entity, face)
		 print(self.uses);
		 for i = 0, self.targets.length do
			 if self.uses > 0 and entity.type == self.targets[i] then
					self.uses = self.uses - 1;
					entity.health = entity.health - face.value;
			 if self.uses == 0 then 
				 face.color.r = 1;
				 face.color.g = 0;
				 face.color.b = 0;
			 end
				break;
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
