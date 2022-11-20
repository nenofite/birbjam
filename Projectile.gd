class_name Projectile
extends Node2D

const cleanup_dist := 2000
const cleanup_dist2 := cleanup_dist * cleanup_dist

export var speed := 300.0

var velocity: Vector2

func _physics_process(delta: float) -> void:
	position += velocity * delta
	if position.length_squared() > cleanup_dist2:
		queue_free()

func fire(origin: Vector2, dir: Vector2) -> void:
	global_position = origin
	velocity = dir.normalized() * speed
