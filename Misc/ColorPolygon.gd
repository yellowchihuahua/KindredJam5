extends Polygon2D


func _ready():
	set("polygon", get_parent().polygon)
