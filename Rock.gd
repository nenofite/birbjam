class_name Rock
extends Node2D

var on_conveyor := false
var taken := false

const max_on_ground_sec := 1.0
var on_ground_secs := 0.0

func _physics_process(delta: float) -> void:
	if taken: return
	var any_convs := false
	var pushes := Vector2.ZERO
	for c in ($InteractionArea as Area2D).get_overlapping_areas():
		var conveyor := Util.parent_of_class(c, Conveyor) as Conveyor
		if !conveyor: continue
		any_convs = true
		pushes += conveyor._force_on(self)
	on_conveyor = any_convs
	if pushes == Vector2.ZERO:
		pass
	else:
		position += pushes.normalized() * Conveyor.speed * delta
	process_despawn(delta)

func process_despawn(delta: float) -> void:
	if on_conveyor || taken:
		on_ground_secs = 0.0
	else:
		on_ground_secs += delta
		if on_ground_secs >= max_on_ground_sec:
			taken = true
			queue_free()

func _on_collected(into: Vector2) -> void:
	taken = true
	var t := Tween.new()
	add_child(t)
	t.interpolate_property(self, "global_position", null, into, 0.3, Tween.TRANS_QUAD, Tween.EASE_IN)
	t.start()
	yield(t, "tween_all_completed")
	queue_free()
