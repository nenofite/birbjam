class_name BirdNav
extends Navigation2D

func find_path(start: Vector2, goal: Vector2):
	var eps := 32
	goal = Util.snap_grid_center(goal)
	var p := get_simple_path(start, goal, true)
	if p.size() > 1 && p[p.size()-1] == goal:
		var i := 0
		while i < p.size():
			if i > 0 && i < p.size() - 1 && (p[i] - p[i-1]).length() <= eps:
				p.remove(i)
			else:
				i += 1
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
