extends Polygon2D


func _ready():
	if len(get_parent().polygon) > 2:
		set("polygon", get_parent().polygon)
