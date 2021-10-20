extends RigidBody2D

signal ball_finished_moving
signal ball_entered_hole
signal ball_freefall_done

var ballIsMoving = false
var ballIsFreefalling = false
var ballIsInPerspective = 0

func _physics_process(delta):
	#slowdown faster
	if abs(linear_velocity.x) <= 50 && abs(linear_velocity.y) < 50:
		if ballIsMoving:
			emit_signal("ball_finished_moving")
			ballIsMoving = false
			linear_velocity = Vector2(0,0)
	else:
		if ballIsFreefalling && linear_velocity.y < 0:
			resetToTopDownMode()
			ballIsFreefalling = false
		elif ballIsFreefalling:
			get_parent().changeCamera(position)


func resetToTopDownMode():
	var perspectives = get_tree().get_nodes_in_group("Perspective")
	for perspective in perspectives:
		perspective.get_node("Perspective1").get_node("CollisionShape2D").set_deferred("disabled", false)
		perspective.get_node("Perspective2").get_node("CollisionShape2D").set_deferred("disabled", false)
		perspective.get_node("Perspective3").get_node("CollisionShape2D").set_deferred("disabled", false)
		perspective.get_node("Perspective4").get_node("CollisionShape2D").set_deferred("disabled", false)
		perspective.get_node("Perspective5").get_node("CollisionShape2D").set_deferred("disabled", false)
		perspective.get_node("Perspective6").get_node("CollisionShape2D").set_deferred("disabled", false)
	set_collision_mask_bit(0, true)
	set_collision_mask_bit(9+ballIsInPerspective, false)
	emit_signal("ball_freefall_done")
	

func move(velocity:Vector2):
	linear_velocity = velocity
	ballIsMoving = true
	
	
func collision_with_hole():
	linear_velocity = Vector2(0,0)
	ballIsMoving = false
	emit_signal("ball_entered_hole")
	emit_signal("ball_finished_moving")
	
	
func enteredVoid():
	linear_velocity = Vector2(linear_velocity.x,1200)
	set_collision_mask_bit(0, false)
	set_collision_mask_bit(9+ballIsInPerspective, true)
	ballIsFreefalling = true
	

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
	ballIsInPerspective = perspective


func resetPosition(pos:Vector2):
	global_transform.origin = pos
