class_name Rocks
extends Node2D

func _interact(b: Bird) -> void:
	b.try_get_rock()
