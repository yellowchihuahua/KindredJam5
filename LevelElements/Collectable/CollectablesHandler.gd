extends Node2D

var pickedup = []


func _ready():
	var level_name = Global.get_level_name()
	
	if Global.level_paths[Global.current_level][1] != get_child_count():
		printerr("Number of collectables in Global does not match number of children of ", level_name, " CollectableHandler")
	
	for i in range(get_child_count()):
		var c = get_child(i)
		c.id = Global.get_collectable_id(i)
		c.connect("collected", self, "on_collected_pickup")
		
	Global.get_level_root().connect("out_of_warmth", self, "level_lost")
	Global.get_level_root().connect("level_finished", self, "level_finished")

func on_collected_pickup(id):
	pickedup.append(id)
	
func level_finished():
	for i in pickedup:
		Global.on_collected_pickup(i)
	
func level_lost():
	pickedup = []
