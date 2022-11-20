class_name Tower
extends Node2D

var rocks := 0

func _interact(bird: Bird) -> void:
	if bird.has_rock:
		bird.remove_rock()
		rocks += 1
