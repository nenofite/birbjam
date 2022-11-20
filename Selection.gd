class_name Selection
extends Node

var current: Node2D

func select(n: Node2D) -> void:
	if current == n: return
	if current:
		current._on_deselected()
	current = n
