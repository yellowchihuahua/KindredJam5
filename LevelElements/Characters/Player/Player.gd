extends KinematicBody2D

signal moved
signal done_moving
signal set_warming(is_warming)
signal in_water

var is_moving = false
var last_move:Vector2
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

var is_sliding = false


var heat_sources = 0

onready var anim = $AnimationTree.get("parameters/playback")

func _ready():
	connect_signals()
	
	grid_position = position/Global.grid_size

func connect_signals():
	Global.get_level_root().connect("out_of_warmth", self, "on_out_of_warmth")
	Global.get_level_root().connect("level_finished", self, "on_level_finished")
	var _out = connect("in_water", Global.get_level_root(), "on_player_in_water")


func _physics_process(_delta):
	if is_moving:
		var direction = (grid_position*Global.grid_size - position).normalized()
		var move_delta = direction*8
		if is_sliding:
			move_delta = move_delta.normalized()*8
		var do_settle = position.distance_to(grid_position * Global.grid_size) < max(move_delta.length(), 0.2)
		
		var offset = Global.grid_size*last_move
		
		position += move_delta
		if do_settle:
			position = grid_position*Global.grid_size
		for i in range(len(pushing)):
			var cube = pushing[i]
			if do_settle:
				stop_moving()
				if cube.has_method("stopped_push"):
					cube.stopped_push(last_move)
			else:
				var new_position = position + offset*i
				cube.position = new_position

func stop_moving():
	is_moving = false
	move_finish_time = 0
	emit_signal("done_moving")
	
	try_drown()
	
	update_anim()
	
func try_drown():
	var bodies = $"SideDetect/Center".get_overlapping_bodies()
	var on_water = false
	var on_sunk = false
	for i in bodies:
		on_water = on_water or i.get_collision_layer_bit(Global.water_bit)
		on_sunk = on_sunk or i.get_collision_layer_bit(Global.sunken_bit)
	if on_water and not on_sunk:
		emit_signal("in_water")
		$WaterSplash.play()
		
	update_anim()
	
func _process(delta):
	get_input()
	move_finish_time += delta
	move_prime_time += delta
	hold_time += delta
	if not is_moving and move_prime_time < move_prime_expire and can_move and move_finish_time > move_cooldown:
		try_move(move_primed)
		
	# sliding move
	var dist_to_target = (position/Global.grid_size - grid_position).length()
	if is_sliding and dist_to_target < 0.1:
		try_move(last_move, true)


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
		
	update_anim()

func clear_pushing():
	for i in range(1, len(pushing)):
		var block = pushing[i]
		block.stopped_push(last_move)
		
	pushing = []

func try_move(direction:Vector2, slide_move=false):
	move_prime_time = move_prime_expire +1
	move_primed = Vector2.ZERO
	clear_pushing()
	pushing = $SideDetect.can_move(direction)
	if len(pushing) > 0:
		is_moving = true
		grid_position += direction
		if not slide_move:
			emit_signal("moved")
		last_move = direction
		
		if len(pushing) > 1 and not slide_move:
			$CubePush.play()
			for i in range(1, len(pushing)):
				pushing[i].claim_push()
		
	elif is_moving:
		stop_moving()
		
		
func update_anim():
	if is_moving:
		anim.travel("Walk")
	else:
		anim.travel("Idle")
	
	if last_move.x < 0:
		$Penguin.scale.x = abs($Penguin.scale.x) * -1
	elif last_move.x > 0:
		$Penguin.scale.x = abs($Penguin.scale.x)

func on_out_of_warmth():
	can_move = false
	
func on_level_finished():
	can_move = false

func _on_WarmthCollector_area_entered(_area):
	heat_sources += 1
	if heat_sources == 1:
		$FirePlayer.play("FadeIn")
		emit_signal("set_warming", true)

func _on_WarmthCollector_area_exited(_area):
	heat_sources -= 1
	if heat_sources == 0:
		$FirePlayer.play("FadeOut")
		emit_signal("set_warming", false)


func _on_SlickDetector_body_entered(_body):
	is_sliding = true
	$SideDetect.water_stop = false
func _on_SlickDetector_body_exited(_body):
	is_sliding = false
	$SideDetect.water_stop = true


