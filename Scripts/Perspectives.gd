extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _on_Perspective6_body_entered(body):
	if body.is_in_group("Ball"):
		body.changeScale(6)

func _on_Perspective5_body_entered(body):
	if body.is_in_group("Ball"):
		body.changeScale(5)


func _on_Perspective4_body_entered(body):
	if body.is_in_group("Ball"):
		body.changeScale(4)


func _on_Perspective3_body_entered(body):
	if body.is_in_group("Ball"):
		body.changeScale(3)


func _on_Perspective2_body_entered(body):
	if body.is_in_group("Ball"):
		body.changeScale(2)


func _on_Perspective1_body_entered(body):
	if body.is_in_group("Ball"):
		body.changeScale(1)
