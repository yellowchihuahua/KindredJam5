extends StaticBody2D

var sink = false

func _process(_delta):
	
	if not get_collision_layer_bit(Global.sunken_bit):
		try_sink()
		
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
		$CollisionShape2D.disabled = true
		set_collision_layer_bit(Global.pushable_bit, false)
		set_collision_layer_bit(Global.sunken_bit, true)
		$CollisionShape2D.set_deferred("disabled", false)
		
