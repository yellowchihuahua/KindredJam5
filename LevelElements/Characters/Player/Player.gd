extends KinematicBody2D

signal moved ()
signal set_warming(is_warming)

var is_moving = false
var move_primed:Vector2
var move_prime_expire = 0.2
var move_prime_time = move_prime_expire+1

var move_finish_time = 0
var move_cooldown = 0.1

var hold_time = 0
var hold_delay = 0.4

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
		var move_delta = lerp(position, grid_position*grid_size, 0.004) - position
		for i in range(len(pushing)):
			var cube = pushing[i]
			if position.distance_to(grid_position * grid_size) < 1:
				
				cube.position = grid_position * grid_size + i*move_delta.normalized()*grid_size
				is_moving = false
				move_finish_time = 0
				cube.get_node("SideDetect").position = Vector2(40,35)
			else:
				var side_pos = cube.get_node("SideDetect").global_position
				cube.position = position + (move_delta * grid_size) + move_delta.normalized()*i * grid_size
				cube.get_node("SideDetect").global_position = side_pos


func _process(delta):
	get_input()
	move_finish_time += delta
	move_prime_time += delta
	hold_time += delta
	if not is_moving and move_prime_time < move_prime_expire and can_move and move_finish_time > move_cooldown:
		try_move(move_primed)


func get_input():
	var dir = Vector2.ZERO
	if Input.is_action_just_pressed("move_left") or (Input.is_action_pressed("move_left") and hold_time > hold_delay):
		dir = Vector2.LEFT
	if Input.is_action_just_pressed("move_right") or (Input.is_action_pressed("move_right") and hold_time > hold_delay):
		dir = Vector2.RIGHT
	if Input.is_action_just_pressed("move_up") or (Input.is_action_pressed("move_up") and hold_time > hold_delay):
		dir = Vector2.UP
	if Input.is_action_just_pressed("move_down") or (Input.is_action_pressed("move_down") and hold_time > hold_delay):
		dir = Vector2.DOWN
		
	if dir != Vector2.ZERO:
		hold_time = 0
		move_primed = dir
		move_prime_time = 0

func try_move(direction:Vector2):
	move_prime_time = move_prime_expire +1
	move_primed = Vector2.ZERO
	
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
