class_name Recharge
extends Node

signal progressed(frac)

export var is_charged := true
export var powered := true setget set_powered
export var cooldown: float

var remaining := 0.0

func _ready():
	emit_signal("progressed", progress())

func _process(delta: float) -> void:
	if !powered: return
	if is_charged: return
	remaining -= delta
	if remaining <= 0:
		is_charged = true
	emit_signal("progressed", progress())

func progress() -> float:
	if powered:
		if is_charged:
			return 1.0
		else:
			return 1.0 - remaining / cooldown
	else:
		return 0.0

func reset() -> void:
	is_charged = false
	remaining = cooldown
	emit_signal("progressed", progress())

func set_powered(p: bool) -> void:
	if p == powered: return
	powered = p
	if powered:
		remaining = cooldown
	else:
		is_charged = false
		remaining = cooldown
	emit_signal("progressed", progress())
