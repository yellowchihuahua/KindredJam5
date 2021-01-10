extends KinematicBody2D

var is_sliding
var is_pushed = false

var last_direction:Vector2
var direction:Vector2
var grid_position:Vector2
var pushing = []

export var fragile = false

func _ready():
	if fragile:
		$ColorRect.color = Color.cyan
		$PlayerCollider.monitoring = true
		
func _physics_process(delta):
	if direction != Vector2.ZERO and not is_pushed:
		var move_delta = (grid_position - position/Global.grid_size).normalized()*4
		var settle = (grid_position - position/Global.grid_size).length() < 0.1
		position += move_delta
		var offset = Global.grid_size*direction
		for i in range(1, len(pushing)):
			var block = pushing[i]
			if settle and not is_sliding:
				block.position = grid_position*Global.grid_size + i*Global.grid_size*direction
			else:
				block.position = position + i*offset
				
		if settle:
			snap_to_grid()
			clear_push()
			if is_sliding:
				try_move(last_direction)

func clear_push():
	for i in range(1, len(pushing)):
		pushing[i].stopped_push(last_direction)
	pushing = []
	
	direction = Vector2.ZERO

func try_sink():
	
	var water_colliders = $WaterCollider.get_overlapping_bodies()
	
	var on_water = false
	var on_sunk = false
	for i in range(len(water_colliders)):
		var body:CollisionObject2D = water_colliders[i]
		if body.get_collision_layer_bit(Global.water_bit):
			on_water = true
		if body.get_collision_layer_bit(Global.sunken_bit):
			on_sunk = true
	
	if on_water and not on_sunk:
		set_collision_layer_bit(Global.pushable_bit, false)
		set_collision_layer_bit(Global.sunken_bit, true)
		$WaterSplash.play()

func snap_to_grid():
	if grid_position != position/Global.grid_size:
		print("snap")
		grid_position = position/Global.grid_size
		grid_position = grid_position.round()
		position = grid_position*Global.grid_size
		try_sink()

func stopped_push(push_direction):
	snap_to_grid()
	
	is_pushed = false
	if is_sliding:
		try_move(push_direction)
		
func claim_push():
	is_pushed = true
		
func try_move(push_direction):
	last_direction = push_direction
	if direction == Vector2.ZERO or is_sliding:	
		pushing = $SideDetect.can_move(push_direction)
		if len(pushing) > 0:
			direction = push_direction
			grid_position = position/Global.grid_size + direction
			grid_position = grid_position.floor()
			for i in range(1, len(pushing)):
				pushing[i].claim_push()


func _on_PlayerCollider_body_exited(_body):
	queue_free()




func _on_SlickCollider_body_exited(body):
	is_sliding = false
func _on_SlickCollider_body_entered(body):
	is_sliding = true
