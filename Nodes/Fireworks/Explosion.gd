extends Node2D

export var color_set = -1 # -1 == random

onready var particles = $Particles

func _ready():
	particles.one_shot = true
	var color_number = color_set if (color_set >= 0 && color_set < 6) else randi() % 6
	particles.color_ramp = load(str("res://Nodes/Fireworks/" + str(color_number) + ".tres"))
	#$AudioStreamPlayer.play()

func _physics_process(delta):
	if not particles.is_emitting():
		queue_free()
