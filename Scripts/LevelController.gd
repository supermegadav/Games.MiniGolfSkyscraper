extends Node2D

func _ready():
	var wheel = $Obstacles/WheelMovingAnim
	if not wheel == null:
		wheel.play("New Anim")
	var piston1 = $Obstacles/Pistons
	var piston2 = $Obstacles/Pistons2
	var piston3 = $Obstacles/Pistons3
	var piston4 = $Obstacles/Pistons4
	var piston5 = $Obstacles/Pistons5
	if not piston1 == null:
		piston1.get_node("AnimationPlayer").play("PistonAnimation")
		yield(get_tree().create_timer(0.1, false), "timeout")
	if not piston2 == null:
		piston2.get_node("AnimationPlayer").play("PistonAnimation")
		yield(get_tree().create_timer(0.1, false), "timeout")
	if not piston3 == null:
		piston3.get_node("AnimationPlayer").play("PistonAnimation")
		yield(get_tree().create_timer(0.1, false), "timeout")
	if not piston4 == null:
		piston4.get_node("AnimationPlayer").play("PistonAnimation")
		yield(get_tree().create_timer(0.1, false), "timeout")
	if not piston5 == null:
		piston5.get_node("AnimationPlayer").play("PistonAnimation")

func _on_Void_body_entered(body):
	if body.is_in_group("Ball"):
		var perspective = body.enteredVoid()
		switchToSideScrollerMode()

func switchToSideScrollerMode():
	self.get_node("SideScroller").get_node("Plane1").get_node("CollisionShape2D").set_deferred("disabled", true)
	self.get_node("SideScroller").get_node("Plane2").get_node("CollisionShape2D").set_deferred("disabled", true)
	self.get_node("SideScroller").get_node("Plane3").get_node("CollisionShape2D").set_deferred("disabled", true)
	self.get_node("SideScroller").get_node("Plane4").get_node("CollisionShape2D").set_deferred("disabled", true)
	self.get_node("SideScroller").get_node("Plane5").get_node("CollisionShape2D").set_deferred("disabled", true)
	self.get_node("SideScroller").get_node("Plane6").get_node("CollisionShape2D").set_deferred("disabled", true)
	self.z_index = 10
	yield(get_tree().create_timer(1, false), "timeout")
	self.get_node("SideScroller").get_node("Plane1").get_node("CollisionShape2D").set_deferred("disabled", false)
	self.get_node("SideScroller").get_node("Plane2").get_node("CollisionShape2D").set_deferred("disabled", false)
	self.get_node("SideScroller").get_node("Plane3").get_node("CollisionShape2D").set_deferred("disabled", false)
	self.get_node("SideScroller").get_node("Plane4").get_node("CollisionShape2D").set_deferred("disabled", false)
	self.get_node("SideScroller").get_node("Plane5").get_node("CollisionShape2D").set_deferred("disabled", false)
	self.get_node("SideScroller").get_node("Plane6").get_node("CollisionShape2D").set_deferred("disabled", false)
	self.z_index = 0


func _on_Ramp_body_entered(body):
	if body.is_in_group("Ball"):
		var currentVelocity = body.enteredJump()


func _on_Ramp_body_exited(body):
	if body.is_in_group("Ball"):
		var currentVelocity = body.exitJump()
