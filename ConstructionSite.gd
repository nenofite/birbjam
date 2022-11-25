extends Node2D

const Dir = Conveyor.Dir

var logs_needed := 2
var logs_supplied := 0 setget set_logs
onready var collection := $CollectionArea as Area2D
onready var sprite := $Sprite as Sprite
var dir: int setget set_dir

func _ready():
	set_logs(logs_supplied)

func _interact(b) -> void:
	b.try_drop()

func _physics_process(_delta):
	try_collect_rocks()

func set_dir(d: int) -> void:
	dir = d
	if !is_instance_valid(sprite): return
	var idx := -1
	if dir == Dir.UP:
		idx = 0
	elif dir == Dir.RIGHT:
		idx = 1
	elif dir == Dir.DOWN:
		idx = 2
	elif dir == Dir.LEFT:
		idx = 3
	sprite.frame = idx
	
func try_collect_rocks() -> void:
	for c in collection.get_overlapping_areas():
		var rock := Util.parent_of_class(c, Log) as Log
		if !is_instance_valid(rock): continue
		if rock.taken || rock.on_conveyor: continue
		rock._on_collected(global_position)
		set_logs(logs_supplied + 1)

func set_logs(r: int) -> void:
	logs_supplied = r
	var pb := $ProgressBar as ProgressBar
	pb.value = clamp(logs_supplied / float(logs_needed), 0, 1)
	if logs_supplied >= logs_needed:
		call_deferred("build")
		
func build() -> void:
	var conv := preload("res://Conveyor.tscn").instance() as Node2D
	get_parent().add_child(conv)
	conv.set_dir(dir)
	conv.global_position = global_position
	get_parent().remove_child(self)
	queue_free()
