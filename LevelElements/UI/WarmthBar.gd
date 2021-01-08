extends ProgressBar

var target_value = -1

# how fast the bar fills up (#seconds for bar from 0-full)
export var fill_rate = 0.5

func _ready():
	Global.get_level_root().connect("warmth_set", self, "on_set_warmth")

func on_set_warmth(val):
	target_value = val
	
func _process(_delta):
	value = lerp(value, target_value, fill_rate)
