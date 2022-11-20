class_name BirdNav
extends Navigation2D

func _on_Backdrop_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("move_to"):
		var selected := $"%Selection".current as Bird
		if !selected: return
		if selected.is_moving(): return
		get_tree().set_input_as_handled()
		var mouse := get_global_mouse_position()
		var spos := selected.global_position
		var points = find_path(spos, mouse)
		if points:
			selected.start_path(mouse, points)
			hide_path()
	elif event is InputEventMouseMotion:
		var selected := $"%Selection".current as Bird
		if !selected: return
		if selected.is_moving(): return
		var mouse := get_global_mouse_position()
		var spos := selected.global_position
		var points = find_path(spos, mouse)
		if points:
			show_path(points)
		else:
			hide_path()
			
func _on_Backdrop_mouse_exited() -> void:
	hide_path()
			
func find_path(start: Vector2, goal: Vector2):
	var p := get_simple_path(start, goal, false)
	if p.size() > 1:
		return p
	else:
		return null

func hide_path() -> void:
	Util.clear_children($"../Dots")

func show_path(points: Array) -> void:
	hide_path()
	var dots := $"../Dots"
	if points.size() <= 1: return
	for i in range(1, points.size()):
		var p := points[i] as Vector2
		var dot := preload("res://Dot.tscn").instance() as Node2D
		dots.add_child(dot)
		dot.global_position = p
