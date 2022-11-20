class_name Util

static func call_children(node: Node, before: String, after = null) -> void:
	pass

static func clear_children(node: Node) -> void:
	for c in node.get_children():
		node.remove_child(c)
		c.queue_free()

static func snap_grid_center(pos: Vector2) -> Vector2:
#	var terr := $"%Terrain" as TileMap
#	var gp := terr.global_position
	return ((pos / 32.0 - Vector2(0.5, 0.5)).round() + Vector2(0.5, 0.5)) * 32
