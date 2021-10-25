extends RigidBody2D

func enteredFlag():
	queue_free()

func enteredVoid():
	queue_free()

func _physics_process(delta):
	if abs(linear_velocity.x) <= 50 && abs(linear_velocity.y) < 50:
		linear_velocity = Vector2(0,0)

func changeScale(perspective):
	if perspective == 1:
		$Sprite.scale = Vector2(1.15, 1.15)
	elif perspective == 2:
		$Sprite.scale = Vector2(1.075, 1.075)
	elif perspective == 3:
		$Sprite.scale = Vector2(1, 1)
	elif perspective == 4:
		$Sprite.scale = Vector2(0.92, 0.92)
	elif perspective == 5:
		$Sprite.scale = Vector2(0.86, 0.86)
	elif perspective == 6:
		$Sprite.scale = Vector2(0.80, 0.80)
