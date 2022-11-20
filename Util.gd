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

static func parent_in_group(node: Node, group: String) -> Node:
	while node:
		if node.is_in_group(group):
			return node
		node = node.get_parent()
	return null
