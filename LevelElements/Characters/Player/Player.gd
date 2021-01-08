extends KinematicBody2D

signal moved ()
signal set_warming(is_warming)

var is_moving = false
var can_move = true
var pushing = []
var grid_position:Vector2

export var grid_size = Vector2(80, 70)


var heat_sources = 0

func _ready():
	connect_signals()
	
	grid_position = position/grid_size
	

func connect_signals():
	Global.get_level_root().connect("out_of_warmth", self, "on_out_of_warmth")
	Global.get_level_root().connect("level_finished", self, "on_level_finished")

func _physics_process(_delta):
	if is_moving:
		var move_delta = lerp(position, grid_position*grid_size, 0.001) - position
		
		for i in range(len(pushing)):
			var cube = pushing[i]
			if position.distance_to(grid_position * grid_size) < 1:
				
				cube.position = grid_position * grid_size + i*move_delta.normalized()*grid_size
				is_moving = false
				cube.get_node("SideDetect").position = Vector2(40,35)
			else:
				var side_pos = cube.get_node("SideDetect").global_position
				cube.position = position + (move_delta.normalized() * grid_size)*(i+1)
				cube.get_node("SideDetect").global_position = side_pos
			
		

	
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
	pushing = $SideDetect.can_move(direction)
	if len(pushing) > 0:
		is_moving = true
		grid_position += direction
		emit_signal("moved")


func on_out_of_warmth():
	can_move = false
	
func on_level_finished():
	can_move = false

func _on_WarmthCollector_area_entered(_area):
	heat_sources += 1
	if heat_sources == 1:
		emit_signal("set_warming", true)

func _on_WarmthCollector_area_exited(_area):
	heat_sources -= 1
	if heat_sources == 0:
		emit_signal("set_warming", false)
