extends Node2D

signal destination_reached()

var async_action
var target: Node2D
onready var mover := $PathMover as PathMover

func _process(_delta):
	if target && !is_instance_valid(target):
		target = null
	if !async_action:
		run_async_action()
		
func run_async_action():
	if async_action: return
	async_action = find_and_kill()
	yield(async_action, "completed")
	async_action = null
	
func find_and_kill():
	print("started find_and_kill")
	var wait := get_tree().create_timer(rand_range(0.3, 1.0), false)
	var bird := yield(find_nearest_bird(), "completed") as Node2D
	yield(wait, "timeout")
	if !is_instance_valid(bird): return
	mover.current_path = ($"%BirdNav" as BirdNav).find_path(global_position, bird.global_position)
	yield(mover, "destination_reached")
	print("completed find_and_kill")

func find_nearest_bird() -> Node2D:
	var shortest
	var shortest_bird: Node2D
	for b in get_tree().get_nodes_in_group("bird"):
		yield(get_tree(), "idle_frame")
		var p = ($"%BirdNav" as BirdNav).find_path(global_position, b.global_position)
		if !p: continue
		if shortest:
			if p.size() < shortest.size():
				shortest = p
				shortest_bird = b
		else:
			shortest = p
			shortest_bird = b
	yield(get_tree(), "idle_frame")
	return shortest_bird

func _on_InteractionArea_area_entered(area: Area2D) -> void:
	var bird := Util.parent_in_group(area, "bird") as Node2D
	if bird:
		bird._on_attacked(self)
