extends Area2D

signal collected (id)

var id

func _on_Collectable_body_entered(_body):
	emit_signal("collected", id)
	queue_free()

