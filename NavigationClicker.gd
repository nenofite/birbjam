extends Node2D

var active := true

func birdnav() -> BirdNav:
	return $"%BirdNav" as BirdNav

func _on_Backdrop_gui_input(event: InputEvent) -> void:
	if !active: return
	if event.is_action_pressed("move_to"):
		var selected := $"%Selection".current as Bird
		if !selected: return
		if selected.is_moving(): return
		get_tree().set_input_as_handled()
		var mouse := Util.snap_grid_center(get_global_mouse_position())
		var spos := selected.global_position
		var points = birdnav().find_path(spos, mouse)
		if points:
			selected.start_path(mouse, points)
			birdnav().hide_path()
	elif event is InputEventMouseMotion:
		var selected := $"%Selection".current as Bird
		if !selected: return
		if selected.is_moving(): return
		var mouse := Util.snap_grid_center(get_global_mouse_position())
		var spos := selected.global_position
		var points = birdnav().find_path(spos, mouse)
		if points:
			birdnav().show_path(points)
		else:
			birdnav().hide_path()
			
func _on_Backdrop_mouse_exited() -> void:
	birdnav().hide_path()
	
func _on_Selection_selection_changed(_prev, _current) -> void:
	birdnav().hide_path()
