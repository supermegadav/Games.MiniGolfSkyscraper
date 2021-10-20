extends Node2D


func _on_Void_body_entered(body):
	if body.is_in_group("Ball"):
		var perspective = body.enteredVoid()
		switchToSideScrollerMode()

func switchToSideScrollerMode():
	self.get_node("SideScroller").get_node("Plane1").get_node("CollisionPolygon2D").set_deferred("disabled", true)
	self.get_node("SideScroller").get_node("Plane2").get_node("CollisionPolygon2D").set_deferred("disabled", true)
	self.get_node("SideScroller").get_node("Plane3").get_node("CollisionPolygon2D").set_deferred("disabled", true)
	self.get_node("SideScroller").get_node("Plane4").get_node("CollisionPolygon2D").set_deferred("disabled", true)
	self.get_node("SideScroller").get_node("Plane5").get_node("CollisionPolygon2D").set_deferred("disabled", true)
	self.get_node("SideScroller").get_node("Plane6").get_node("CollisionPolygon2D").set_deferred("disabled", true)
	yield(get_tree().create_timer(1, false), "timeout")
	self.get_node("SideScroller").get_node("Plane1").get_node("CollisionPolygon2D").set_deferred("disabled", false)
	self.get_node("SideScroller").get_node("Plane2").get_node("CollisionPolygon2D").set_deferred("disabled", false)
	self.get_node("SideScroller").get_node("Plane3").get_node("CollisionPolygon2D").set_deferred("disabled", false)
	self.get_node("SideScroller").get_node("Plane4").get_node("CollisionPolygon2D").set_deferred("disabled", false)
	self.get_node("SideScroller").get_node("Plane5").get_node("CollisionPolygon2D").set_deferred("disabled", false)
	self.get_node("SideScroller").get_node("Plane6").get_node("CollisionPolygon2D").set_deferred("disabled", false)
