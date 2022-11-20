class_name CommandDot
extends Node2D

signal command_removed(dot)

var idx: int

func set_idx(idx: int) -> void:
	$Label.text = str(idx+1)
	self.idx = idx

func _on_TextureRect_gui_input(event: InputEvent) -> void:
	if event.is_action_released("remove_command"):
		get_tree().set_input_as_handled()
		emit_signal("command_removed", self)
