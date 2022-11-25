tool
class_name Conveyor
extends Node2D

const speed := 64.0

enum Dir {UP,RIGHT,DOWN,LEFT}
export(Dir) var dir := Dir.UP setget set_dir

var direction: Vector2

func _ready():
	set_dir(dir)
	
func _force_on(item: Node2D) -> Vector2:
	var toward := global_position + direction * 32
	return (toward - item.global_position).normalized()
	
func _interact(b) -> void:
	b.try_drop()

func update_sprite() -> void:
	var s := $Sprite as Sprite
	if !is_instance_valid(s): return
	var idx := -1
	if dir == Dir.UP:
		idx = 0
	elif dir == Dir.RIGHT:
		idx = 1
	elif dir == Dir.DOWN:
		idx = 2
	elif dir == Dir.LEFT:
		idx = 3
	s.frame = idx

func set_dir(dir_: int) -> void:
	dir = dir_
	update_sprite()
	if dir == Dir.UP:
		direction = Vector2.UP
	elif dir == Dir.RIGHT:
		direction = Vector2.RIGHT
	elif dir == Dir.DOWN:
		direction = Vector2.DOWN
	elif dir == Dir.LEFT:
		direction = Vector2.LEFT
