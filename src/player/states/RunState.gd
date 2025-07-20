class_name RunState
extends "res://src/core/state_machine/State.gd"

func enter() -> void:
	player.animated_sprite.play("run")
	pass

func process_physics(delta: float) -> void:
	if not player.is_on_floor():
		state_machine.change_state("Air")
		return
	
	var input_direction = player.get_input_direction()
	
	if input_direction == 0:
		state_machine.change_state("Idle")
		return
	
	var target_velocity_x = input_direction * player.speed
	player.velocity.x = move_toward(player.velocity.x, target_velocity_x, player.acceleration)
	
	player.animated_sprite.flip_h = input_direction < 0

func process_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		state_machine.change_state("Air")
