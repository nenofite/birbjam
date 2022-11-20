class_name Bird
extends Node2D

const speed := 128

var current_path := []

func _process(delta: float) -> void:
	var eps := speed * delta
	trim_path(eps)
	if current_path.size() > 0:
		var next := current_path[0] as Vector2
		var diff := next - global_position
		if diff.length() <= eps:
			global_position = next
			current_path.pop_front()
		else:
			position += diff.normalized() * speed * delta
			
func is_moving() -> bool:
	return current_path.size() > 0

func start_path(path: Array) -> void:
	current_path = path.duplicate()
	
func trim_path(eps: float) -> void:
	if current_path.size() == 0: return
	var eps2 := eps * eps
	var gp := global_position
	while current_path.size() > 1:
		var next := current_path[0] as Vector2
		var diff := next - gp
		if diff.length_squared() <= eps2:
			current_path.pop_front()
		else:
			break

func on_selected() -> void:
	$"/root/Main/Selection".select(self)

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton && event.pressed:
		on_selected()
