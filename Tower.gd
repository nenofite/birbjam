class_name Tower
extends Node2D

export var rocks_needed := 10
var rocks: int setget set_rocks
onready var recharge := $Recharge as Recharge

func _ready():
	set_rocks(rocks_needed)

func _interact(bird: Bird) -> void:
	if bird.has_rock:
		bird.remove_rock()
		set_rocks(rocks + 1)

func _process(_delta):
	try_fire_at_cat()

func try_fire_at_cat() -> void:
	if !recharge.is_charged: return
	if rocks == 0: return
	var target := find_nearest_cat()
	if is_instance_valid(target):
		recharge.reset()
		set_rocks(rocks - 1)
		fire_at(target.global_position)
	
func find_nearest_cat() -> Node2D:
	var nearest_dist2 := INF
	var nearest: Node2D
	var gp := global_position
	for c in get_tree().get_nodes_in_group("cat"):
		var dist2 := (gp - (c as Node2D).global_position).length_squared()
		if !nearest || dist2 < nearest_dist2:
			nearest_dist2 = dist2
			nearest = c
	return nearest

func fire_at(pos: Vector2) -> void:
	var origin := $ProjectileOrigin.global_position as Vector2
	var p := preload("res://Projectile.tscn").instance() as Projectile
	$"/root/Main".get_node("%Projectiles").add_child(p)
	p.fire(origin, pos - origin)

func set_rocks(r: int) -> void:
	rocks = r
	var pb := $ProgressBar as ProgressBar
	pb.value = clamp(rocks / float(rocks_needed), 0, 1)
	recharge.powered = rocks > 0
