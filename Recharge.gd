class_name Recharge
extends Node

signal charged()

var is_charged := true
var remaining := 0.0

func _process(delta: float) -> void:
	if is_charged: return
	remaining -= delta
	if remaining <= 0:
		is_charged = true
		emit_signal("charged")

func reset(dur: float) -> void:
	is_charged = false
	remaining = dur
