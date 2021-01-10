extends CPUParticles2D

export var freeze_color = Color.cyan
export var show_text = false

func _ready():
	Global.get_level_root().connect("warmth_set", self, "set_fill")
	$Label.visible = show_text

func set_fill(val:float):
	var frac = fmod(val, 1.0)
	var new_color = lerp(Color.white, freeze_color, 0 if frac == 0 else 1-frac)
	$Label.modulate = new_color
	if val < 0:
		$Label.text = "0"
	else:
		$Label.text = str(ceil(val))
