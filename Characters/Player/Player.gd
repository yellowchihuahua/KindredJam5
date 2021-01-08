extends KinematicBody2D

var is_moving = false
var grid_position:Vector2

export var grid_size = Vector2(80, 70)

func _ready():
	grid_position = position/grid_size

func _physics_process(delta):
	if is_moving:
		position = lerp(position, grid_position*grid_size, 0.3)
		if position.distance_to(grid_position*grid_size) < 1:
			is_moving = false
			position = grid_position*grid_size

func _process(delta):
	handle_movement()
	
func handle_movement():
	if Input.is_action_just_pressed("move_left") and not is_moving:
		try_move(Vector2.LEFT)
	if Input.is_action_just_pressed("move_right") and not is_moving:
		try_move(Vector2.RIGHT)
	if Input.is_action_just_pressed("move_up") and not is_moving:
		try_move(Vector2.UP)
	if Input.is_action_just_pressed("move_down") and not is_moving:
		try_move(Vector2.DOWN)

func try_move(direction:Vector2):
	if $SideDetect.can_move(direction):
		is_moving = true
		grid_position += direction
