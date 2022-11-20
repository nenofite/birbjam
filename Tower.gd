class_name Tower
extends Node2D

export var rocks_needed := 10
var rocks := 0

func _interact(bird: Bird) -> void:
	if bird.has_rock:
		bird.remove_rock()
		rocks += 1

func _process(_delta):
	var pb := $ProgressBar as ProgressBar
	pb.value = clamp(rocks / float(rocks_needed), 0, 1)
