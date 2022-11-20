class_name Recharge
extends Node

export var is_charged := true
export var powered := true setget set_powered
export var cooldown: float

var remaining := 0.0

func _process(delta: float) -> void:
	if !powered: return
	if is_charged: return
	remaining -= delta
	if remaining <= 0:
		is_charged = true
#		emit_signal("charged")

func reset() -> void:
	is_charged = false
	remaining = cooldown

func set_powered(p: bool) -> void:
	if p == powered: return
	powered = p
	if powered:
		remaining = cooldown
	else:
		is_charged = false
		remaining = cooldown
