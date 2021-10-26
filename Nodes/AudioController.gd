extends Node2D

var hit = 0

func playGameplaySong():
	$Song1.play()

func _on_Song1_finished():
	$Song2.play()

func _on_Song2_finished():
	$Song3.play()

func _on_Song3_finished():
	$Song1.play()
