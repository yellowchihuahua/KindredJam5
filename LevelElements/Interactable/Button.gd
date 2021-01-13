extends Area2D

signal set_switch (num, switch_on)

export var switch_num = -1

var body_count = 0

func _ready():
	var _out = connect("set_switch", Global.get_level_root(), "on_switch_set")
	emit_signal("set_switch", switch_num, false)
	
	for i in [$ButtonRing, $ButtonPressedSprite, $ButtonSprite]:
		i.modulate = Global.interactable_colors[switch_num]/2
		i.modulate.a = 1
		
	$ButtonPressedSprite.visible = false;
	$ButtonSprite.visible = true;


func _on_Button_body_entered(_body):
	body_count += 1
	if body_count == 1:
		$ButtonPressedSprite.visible = true;
		$ButtonSprite.visible = false;
		$ButtonPressed.play()
		emit_signal("set_switch", switch_num, true)


func _on_Button_body_exited(_body):
	body_count -= 1
	if body_count == 0:
		$ButtonPressedSprite.visible = false;
		$ButtonSprite.visible = true; 
		$ButtonReleased.play()
		emit_signal("set_switch", switch_num, false)
