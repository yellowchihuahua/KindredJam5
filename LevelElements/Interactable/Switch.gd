extends StaticBody2D

signal set_switch (num, switch_on)

var is_on = false

export var switch_num = -1

func _ready():
	$SwitchOff.visible = true
	$SwitchOn.visible = false
	
	$SwitchOff.modulate = Global.interactable_colors[switch_num]/2
	$SwitchOff.modulate.a = 1
	$SwitchOn.modulate = Global.interactable_colors[switch_num]/2
	$SwitchOn.modulate.a = 1
	
	var _out = connect("set_switch", Global.get_level_root(), "on_switch_set")
	emit_signal("set_switch", switch_num, is_on)
	
	if is_on:
		$AnimationPlayer.play("turn")

func interact():
	if is_on:
		$SwitchOff.visible = true
		$SwitchOn.visible = false
	else:
		$SwitchOff.visible = false
		$SwitchOn.visible = true
		
	is_on = not is_on
	
	$AudioStreamPlayer.play()
	
	emit_signal("set_switch", switch_num, is_on)
	
