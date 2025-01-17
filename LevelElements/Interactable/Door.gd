extends Node2D

export var switches:PoolIntArray = [0]
export var or_mode = false
export var not_mode = false
var switch_dict = {}

var is_open = false


func _ready():
	Global.get_level_root().connect("switch_set", self, "on_switch_set")
	$DoorOpen.visible = false;
	$DoorClosed.visible = true;
	
	for i in switches:
		switch_dict[i] = false
		
	set_open(not_mode)
	
	
	for i in [$DoorOpen, $DoorClosed]:
		i.modulate = Global.interactable_colors[switches[0]]
		i.modulate.a = 1
	
func on_switch_set(num, enabled):
	if num in switches:
		switch_dict[num] = enabled
		
		var open = not or_mode
		
		for i in switches:
			if or_mode:
				open = open or switch_dict[i]
			else:
				open = open and switch_dict[i]
		
		if not_mode:
			open = not open
		if open != is_open:
			set_open(open)
		
func set_open(open):
	is_open = open
	
	$"StaticBody2D/CollisionShape2D".set_deferred("disabled", open)
	if open:
		$DoorOpen.visible = true;
		$DoorClosed.visible = false;
	else:
		$DoorOpen.visible = false;
		$DoorClosed.visible = true;
	
	#$AnimationPlayer.play("open" if open else "close")
