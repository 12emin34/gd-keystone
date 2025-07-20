class_name StateMachine
extends Node

@export var initial_state: State

var current_state: State

var states: Dictionary = {}

@onready var player: Player = get_parent() as Player

func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name] = child
			child.state_machine = self
			child.player = player
	
	await get_parent().ready
	
	if initial_state:
		change_state(initial_state.name)

func change_state(new_state_name: String) -> void:
	if current_state and current_state.name == new_state_name:
		return
	
	if not states.has(new_state_name):
		push_warning("StateMachine: State '%s' not found." % new_state_name)
		return
	
	if current_state:
		current_state.exit()
	
	current_state = states[new_state_name]
	
	current_state.enter()
	
	player.state_changed.emit(current_state.name)

func process_input(event: InputEvent) -> void:
	if current_state:
		current_state.process_input(event)

func process_physics(delta: float) -> void:
	if current_state:
		current_state.process_physics(delta)
