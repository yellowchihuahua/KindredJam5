extends KinematicBody2D

func _on_PlayerDetector_body_exited(body):
	queue_free()
