extends KinematicBody2D

signal moved

var is_moving = false
var grid_position:Vector2

export var grid_size = Vector2(80, 70)

var can_move = true

func _ready():
	connect_signals()
	
	grid_position = position/grid_size
	

func connect_signals():
	Global.get_level_root().connect("out_of_warmth", self, "on_out_of_warmth")
	Global.get_level_root().connect("level_finished", self, "on_level_finished")

func _physics_process(_delta):
	if is_moving:
		var move_delta = lerp(position, grid_position*grid_size, 0.3) - position
		
		position += move_delta
			
		if position.distance_to(grid_position*grid_size) < 1:
			is_moving = false
			position = grid_position*grid_size
			
		for i in range(len($SideDetect.pushing)):
			var cube = $SideDetect.pushing[i]
			cube.position = position + (move_delta.normalized() * grid_size)*(i+1)

	
func _process(_delta):
	if can_move:
		get_input()
	
func get_input():
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
		emit_signal("moved")


func on_out_of_warmth():
	can_move = false
	
func on_level_finished():
	can_move = false
