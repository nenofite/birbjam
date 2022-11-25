class_name Selection
extends Node

signal selection_changed(prev, current)

var current: Node2D

func _process(_delta):
	if current && !is_instance_valid(current):
		current = null

func _unhandled_key_input(event) -> void:
	if event.is_action_pressed("prev_bird"):
		get_tree().set_input_as_handled()
		wrap_select(-1)
	elif event.is_action_pressed("next_bird"):
		get_tree().set_input_as_handled()
		wrap_select(1)
			
func wrap_select(di: int) -> void:
	var birds := get_tree().get_nodes_in_group("bird")
	if current:
		var cur_i := birds.find(current)
		var next := birds[(cur_i + di) % birds.size()] as Node2D
		select(next)
	else:
		select(birds[0])

func select(n: Node2D) -> void:
	if current == n: return
	if current:
		current._on_deselected()
	var prev := current
	current = n
	if n: n._on_selected()
	emit_signal("selection_changed", prev, current)
