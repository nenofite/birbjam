extends Node2D

func on_selected() -> void:
	$"/root/Main/Selection".select(self)

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton && event.pressed:
		on_selected()
