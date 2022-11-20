class_name Selection
extends Node

var current: Bird

func _process(_delta):
	if current:
		selector().onto(current)

func selector() -> Node2D:
	return $"../Selector" as Node2D

func select(n: Bird) -> void:
	if current == n: return
	current = n
	if current:
		selector().onto(current)
	else:
		selector().hide()

#func _unhandled_input(event):
#	if event is InputEventMouseButton && event.pressed:
#		select(null)
