extends StaticBody2D

var sink = false

export var fragile = false

func _ready():
	if fragile:
		$ColorRect.color = Color.cyan
		$PlayerCollider.monitoring = true

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
		


func _on_PlayerCollider_body_exited(_body):
	queue_free()


func _on_WaterCollider_body_entered(_body):
	try_sink()
