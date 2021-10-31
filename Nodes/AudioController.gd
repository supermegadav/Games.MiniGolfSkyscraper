extends Node2D


func _physics_process(delta):
	$Song1.volume_db = PlayerVariables.musicVolume
	$Song2.volume_db = PlayerVariables.musicVolume
	$Song3.volume_db = PlayerVariables.musicVolume

func playGameplaySong():
	$Song1.play()

func _on_Song1_finished():
	$Song2.play()

func _on_Song2_finished():
	$Song3.play()

func _on_Song3_finished():
	$Song1.play()
