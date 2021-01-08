extends Node2D

# does water prevent from moving
export var water_stop = false

func _ready():
	for side in [$Right, $Down, $Left, $Up]:
		var mask = side.get_collision_mask()
		if water_stop:
			side.set_collision_mask(mask|(Global.water_bit*Global.water_bit)) # set water bit to true

func set_sides_enable(val):
	for side in [$Right, $Down, $Left, $Up]:
		side.monitoring = val
		
# array of objects in direction (terminates with first unpushable or empty square)
func can_move(direction):
	set_sides_enable(true)
	var pushing = [get_parent()]
	
	var cast = get_cast(direction)
	var colliders = cast.get_overlapping_bodies()
	if len(colliders) == 0:
		return pushing
	
	var is_wall = false
	var push_thing = null
	var is_water = false
	var is_sunken = false
	
	for c in colliders:
		is_wall = is_wall or c.get_collision_layer_bit(Global.level_bit)
		if c.get_collision_layer_bit(Global.pushable_bit):
			push_thing = c
		is_water = is_water or c.get_collision_layer_bit(Global.water_bit)
		is_sunken = is_sunken or c.get_collision_layer_bit(Global.sunken_bit)
	
	if is_wall:
		return []
	if is_water and not is_sunken and water_stop:
		return []
	
	if push_thing:
		pushing += push_thing.get_node("SideDetect").can_move(direction)
	
	return pushing
	
# returns the raycast aligned with a direction
func get_cast(direction:Vector2):
	if direction == Vector2.LEFT:
		return $Left
	if direction == Vector2.RIGHT:
		return $Right
	if direction == Vector2.UP:
		return $Up
	if direction == Vector2.DOWN:
		return $Down
	
	printerr("ERROR: no raycast for ", direction, ". Ensure direction is a unit, grid vector.")