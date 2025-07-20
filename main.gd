extends Node

@export var starting_level: PackedScene

@onready var _current_level_node: Node = $CurrentLevel

func _ready() -> void:
	if starting_level:
		var level_instance = starting_level.instantiate()
		_current_level_node.add_child(level_instance)
	else:
		push_warning("No starting level has been assigned in the Main node inspector.")
