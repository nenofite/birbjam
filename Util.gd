class_name Util

static func call_children(node: Node, before: String, after = null) -> void:
	pass

static func clear_children(node: Node) -> void:
	for c in node.get_children():
		node.remove_child(c)
		c.queue_free()
