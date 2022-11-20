class_name Bird
extends Node2D

onready var mover := $"PathMover" as PathMover
var has_rock := false

var commands := []
var current_command := -1
var is_repeating := false

onready var interaction := $InteractionArea as Area2D
onready var rock := $Rock as Node2D

func _process(delta: float) -> void:
	if !is_moving():
		process_interaction(delta)
		process_commands(delta)
			
func _unhandled_key_input(event):
	if !is_selected(): return
	if event.is_action_released("repeat_commands"):
		get_tree().set_input_as_handled()
		if is_repeating:
			set_repeating(false)
		elif commands.size() > 0:
			set_repeating(true)
		
func is_selected() -> bool:
	return ($"%Selection" as Selection).current == self
			
func process_interaction(_delta: float) -> void:
	var i := query_interaction()
	if i:
		# warning-ignore:unsafe_method_access
		i._interact(self)
		
func process_commands(_delta: float) -> void:
	if !is_repeating: return
	if commands.size() <= 1:
		set_repeating(false)
		return
	current_command = (current_command + 1) % commands.size()
	var cmd := commands[current_command] as Command
	var nav := $"%BirdNav"
	mover.current_path = nav.find_path(global_position, cmd.goto)
			
func query_interaction() -> Node:
	var overlaps := interaction.get_overlapping_areas()
	for o in overlaps:
		var p := find_interactable_parent(o)
		if p: return p
	return null
	
func set_repeating(r: bool) -> void:
	if is_repeating == r: return
	is_repeating = r
	$Repeat.visible = r
	
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
	return mover.is_moving()

func start_path(goal: Vector2, path: Array) -> void:
	mover.current_path = path.duplicate()
	commands.append(Command.to_goto(goal))
	show_commands()
			
func select() -> void:
	($"%Selection" as Selection).select(self)

func _on_selected() -> void:
	show_commands()
	$Selector.show()
	
func _on_deselected() -> void:
	$Selector.hide()

func show_commands() -> void:
	var dots := $"%CommandDots"
	dots.clear()
	for i in range(commands.size()):
		var d := dots.show_command(i, commands[i]) as CommandDot
		d.connect("command_removed", self, "_on_command_removed")
		
func _on_Control_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton && event.pressed:
		select()
		
func _on_command_removed(dot: CommandDot) -> void:
	commands.remove(dot.idx)
	show_commands()

class Command:
	extends Reference
	var goto: Vector2

	static func to_goto(goal: Vector2) -> Command:
		var c := Command.new()
		c.goto = goal
		return c
