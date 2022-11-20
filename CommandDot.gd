class_name CommandDot
extends Node2D

signal gui_input(event)

func set_idx(idx: int) -> void:
	$Label.text = str(idx)

func _on_TextureRect_gui_input(event):
	emit_signal("gui_input", event)
