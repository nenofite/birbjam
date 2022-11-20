class_name Bird
extends Node2D

const speed := 128

var current_path := []
var has_rock := false

onready var interaction := $InteractionArea as Area2D

func _process(delta: float) -> void:
	process_movement(delta)
	if !is_moving():
		var i := query_interaction()
		if i:
			# warning-ignore:unsafe_method_access
			i._interact(self)
			
func process_movement(delta: float) -> void:
	var eps := speed * delta
	trim_path(eps)
	if current_path.size() > 0:
		var next := current_path[0] as Vector2
		var diff := next - global_position
		if diff.length() <= eps:
			global_position = next
			current_path.pop_front()
		else:
			position += diff.normalized() * speed * delta
			
func query_interaction() -> Node:
	var overlaps := interaction.get_overlapping_areas()
	for o in overlaps:
		var p := find_interactable_parent(o)
		if p: return p
	return null
	
func try_get_rock() -> void:
	if is_moving(): return
	if has_rock: return
	has_rock = true
	print("Got a rock!")
	
func remove_rock() -> void:
	if !has_rock: return
	has_rock = false
	print("No more rock!")
	
func find_interactable_parent(n: Node) -> Node:
	while n:
		if n.has_method("_interact"):
			return n
		else:
			n = n.get_parent()
	return null
			
func is_moving() -> bool:
	return current_path.size() > 0

func start_path(path: Array) -> void:
	current_path = path.duplicate()
	
func trim_path(eps: float) -> void:
	if current_path.size() == 0: return
	var eps2 := eps * eps
	var gp := global_position
	while current_path.size() > 1:
		var next := current_path[0] as Vector2
		var diff := next - gp
		if diff.length_squared() <= eps2:
			current_path.pop_front()
		else:
			break

func on_selected() -> void:
	($"/root/Main/Selection" as Selection).select(self)

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton && event.pressed:
		on_selected()
