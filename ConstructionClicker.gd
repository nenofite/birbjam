extends Node2D

const Dir = Conveyor.Dir

var active := false
var dir: int = Dir.UP
onready var hint := $Hint as Node2D

func _on_Backdrop_gui_input(event: InputEvent) -> void:
	if !active: return
	if event.is_action_pressed("select_build"):
		get_tree().set_input_as_handled()
		if hint.is_colliding(): return
		var pos := hint.global_position
		var conv := preload("res://Conveyor.tscn").instance() as Conveyor
		$"%Conveyors".add_child(conv)
		conv.global_position = pos
		conv.set_dir(dir)
	elif event.is_action_pressed("build_next_dir"):
		get_tree().set_input_as_handled()
		dir = posmod(dir + 1, 4)
		hint.set_dir(dir)
	elif event.is_action_pressed("build_prev_dir"):
		get_tree().set_input_as_handled()
		dir = posmod(dir - 1, 4)
		hint.set_dir(dir)
	elif event is InputEventMouseMotion:
		var pos := Util.snap_grid_center(get_global_mouse_position())
		hint.global_position = pos
		hint.show()
			
func _on_Backdrop_mouse_exited() -> void:
	hint.hide()

func _on_ConveyorBtn_toggled(button_pressed: bool) -> void:
	active = button_pressed
	$"../NavigationClicker".active = !button_pressed
