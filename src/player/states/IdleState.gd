class_name IdleState
extends "res://src/core/state_machine/State.gd"

func enter() -> void:
	player.animated_sprite.play("idle")
	pass

func process_physics(delta: float) -> void:
	if not player.is_on_floor():
		state_machine.change_state("Air")
		return
	
	if player.get_input_direction() != 0:
		state_machine.change_state("Run")
		return
	
	player.velocity.x = move_toward(player.velocity.x, 0, player.friction)

func process_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		state_machine.change_state("Air")
