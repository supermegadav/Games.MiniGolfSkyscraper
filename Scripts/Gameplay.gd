extends Node2D

export var windUpOriginalPosition = 100
export var windUpRate = 20
export var windUpMax = 1400
export var windUpMin = 100
export var angleRate = 4
export var currentLevel = 1
var windUp = 100
var angleFromUp = 0
var windUpIncrease = true
var hasWindUpInAction = false
var hasShotInAction = false



func _ready():
	$Ball.connect("ball_finished_moving", self, "on_ball_finished_moving")
	$Ball.connect("ball_entered_hole", self, "on_ball_entered_hole")
	$WindUpBar.min_value = windUpMin
	$WindUpBar.max_value = windUpMax

func _physics_process(delta):
	if hasWindUpInAction:
		$WindUpBar.value = windUp
		if windUpIncrease:
			windUp += windUpRate
		else:
			windUp -= windUpRate
		if windUp > windUpMax:
			windUpIncrease = false
		elif windUp < windUpMin:
			windUpIncrease = true
	if !hasShotInAction:
		if Input.is_action_pressed("left"):
			angleFromUp += angleRate
		if Input.is_action_pressed("right"):
			angleFromUp -= angleRate
		if Input.is_action_just_pressed("shoot"):
			if !hasWindUpInAction:
				hasWindUpInAction = true
			else:
				hasShotInAction = true
				hasWindUpInAction = false
				shoot()
		$Club.rotation_degrees = angleFromUp

func shoot():
	hasShotInAction = true
	var deg = deg2rad(angleFromUp)
	var directionx = cos(deg) * windUp
	var directiony = sin(deg) * windUp
	$Ball.move(Vector2(directionx, directiony))


func on_ball_finished_moving():
	windUp = windUpOriginalPosition
	angleFromUp = 0
	hasShotInAction = false
	$Club.global_position = $Ball.global_position
	$Club.rotation_degrees = 0
	$WindUpBar.value = 100

func on_ball_entered_hole():
	windUp = windUpOriginalPosition
	currentLevel += 1
	angleFromUp = 0
	hasShotInAction = false
