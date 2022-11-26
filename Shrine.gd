class_name Shrine
extends Node2D

signal filled()

export var logs_needed := 1

var logs: int setget set_logs
onready var buildArea := $BuildArea as Area2D
onready var pb := $ProgressBar as ProgressBar
var already_filled := false

func _ready():
	set_logs(0)

func _interact(bird: Bird) -> void:
	bird.try_drop()

func _physics_process(_delta):
	try_collect_logs()
	
func try_collect_logs() -> void:
	for c in buildArea.get_overlapping_areas():
		var l := Util.parent_of_class(c, Log) as Log
		if !is_instance_valid(l): continue
		if l.taken || l.on_conveyor: continue
		l._on_collected(global_position)
		set_logs(logs + 1)

func set_logs(r: int) -> void:
	logs = r
	pb.value = clamp(logs / float(logs_needed), 0, 1)
	if logs >= logs_needed && !already_filled:
		already_filled = true
		emit_signal("filled")
