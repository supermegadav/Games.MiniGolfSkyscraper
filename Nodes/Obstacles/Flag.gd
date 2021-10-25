extends Area2D

func _on_Flag_body_entered(body):
	if body.is_in_group("Ball"):
		body.collision_with_hole()
	if body.is_in_group("FakeBall"):
		body.enteredFlag()
