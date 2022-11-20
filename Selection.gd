class_name Selection
extends Node

var current: Node2D

func _process(_delta):
	if current:
		selector().onto(current)

func selector() -> Node2D:
	return $"../Selector" as Node2D

func select(n: Node2D) -> void:
	if current == n: return
	current = n
	if current:
		selector().onto(current)
	else:
		selector().hide()

#func _unhandled_input(event):
#	if event is InputEventMouseButton && event.pressed:
#		select(null)
