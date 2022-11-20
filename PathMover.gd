class_name PathMover
extends Node

signal started_moving()
signal destination_reached()

export var speed: float

onready var subject := get_parent() as Node2D
var current_path := []
var was_moving := false

func _process(delta: float) -> void:
	var eps := speed * delta
	trim_path(eps)
	if current_path.size() > 0:
		var next := current_path[0] as Vector2
		var diff := next - subject.global_position
		if diff.length() <= eps:
			subject.global_position = next
			current_path.pop_front()
		else:
			subject.position += diff.normalized() * speed * delta
	if was_moving && !is_moving():
		emit_signal("destination_reached")
	elif !was_moving && is_moving():
		emit_signal("started_moving")
	was_moving = is_moving()

func is_moving() -> bool:
	return current_path.size() > 0

func trim_path(eps: float) -> void:
	if current_path.size() == 0: return
	var eps2 := eps * eps
	var gp := subject.global_position
	while current_path.size() > 1:
		var next := current_path[0] as Vector2
		var diff := next - gp
		if diff.length_squared() <= eps2:
			current_path.pop_front()
		else:
			break
