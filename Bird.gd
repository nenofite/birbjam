class_name Bird
extends Node2D

const speed := 128

var current_path := []
var has_rock := false

var commands := []
var current_command := -1
var running_commands := false

onready var interaction := $InteractionArea as Area2D
onready var rock := $Rock as Node2D

func _process(delta: float) -> void:
	process_movement(delta)
	if !is_moving():
		var i := query_interaction()
		if i:
			# warning-ignore:unsafe_method_access
			i._interact(self)
		if running_commands:
			current_command = (current_command + 1) % commands.size()
			var cmd := commands[current_command] as Command
			var nav := $"%BirdNav"
			current_path = nav.find_path(global_position, cmd.goto)
			
func _unhandled_key_input(event):
	if !is_selected(): return
	if event.is_action_released("repeat_commands"):
		get_tree().set_input_as_handled()
		if commands.size() > 0:
			current_command = -1
			running_commands = true
		
func is_selected() -> bool:
	return ($"%Selection" as Selection).current == self
			
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
	rock.show()
	print("Got a rock!")
	
func remove_rock() -> void:
	if !has_rock: return
	has_rock = false
	rock.hide()
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

func start_path(goal: Vector2, path: Array) -> void:
	current_path = path.duplicate()
	commands.append(Command.to_goto(goal))
	
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
	($"%Selection" as Selection).select(self)

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton && event.pressed:
		on_selected()

class Command:
	extends Reference
	var goto: Vector2

	static func to_goto(goal: Vector2) -> Command:
		var c := Command.new()
		c.goto = goal
		return c
