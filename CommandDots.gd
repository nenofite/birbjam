class_name CommandDots
extends Node2D

func show_command(idx: int, cmd: Bird.Command) -> void:
	var dot := preload("res://CommandDot.tscn").instance() as CommandDot
	dot.set_idx(idx)
	add_child(dot)
	dot.global_position = cmd.goto

func clear() -> void:
	Util.clear_children(self)
