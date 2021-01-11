extends Node2D



func _ready():
	var level_name = Global.get_level_name()
	
	if Global.level_paths[Global.current_level][1] != get_child_count():
		printerr("Number of collectables in Global does not match number of children of ", level_name, " CollectableHandler")
	
	for i in range(get_child_count()):
		var c = get_child(i)
		c.id = Global.get_collectable_id(i)
		c.connect("collected", Global, "on_collected_pickup")
