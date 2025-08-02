extends Area2D

@export var teleport_destination: NodePath

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if body.name == "player":
		var destination_node = get_node(teleport_destination)
		if destination_node:
			body.global_position = destination_node.global_position
