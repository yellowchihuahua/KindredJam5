extends Node2D

var pushing

func _ready():
	for side in [$Right, $Down, $Left, $Up]:
		side.add_exception(get_parent())

func can_move(direction):
	pushing = []
	var cast = get_cast(direction)
	
	var collider = cast.get_collider()
	if collider == null:
		return true
		
	if not collider.get_collision_layer_bit(2): # is not pushable
		return false
		
	pushing = collider.get_node("SideDetect").can_push(direction)
	if not pushing[-1].get_collision_layer_bit(2): # chain unpushable
		return false
	
	return true
	
# array of objects in direction (terminates with first unpushable or empty square)
func can_push(direction):
	var cast = get_cast(direction)
	var collider = cast.get_collider()
	if collider == null:
		return [get_parent()]
	
	if not collider.get_collision_layer_bit(2): # is not pushable
		return [get_parent(), collider]
	
	return [self.get_parent()] + collider.get_node("SideDetect").can_push(direction)
	
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
