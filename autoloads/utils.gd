extends Node

func remove_all_childs(parent_node):
	for c in parent_node.get_children():
		parent_node.remove_child(c)
		c.queue_free()
