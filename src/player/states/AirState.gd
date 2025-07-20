class_name AirState
extends "res://src/core/state_machine/State.gd"

func enter() -> void:
	player.animated_sprite.play("jump")
	
	if player.is_on_floor():
		player.velocity.y = player.jump_velocity

func process_physics(delta: float) -> void:
	var input_direction = player.get_input_direction()
	var target_velocity_x = input_direction * player.speed
	player.velocity.x = move_toward(player.velocity.x, target_velocity_x, player.air_acceleration)
	
	if input_direction != 0:
		player.animated_sprite.flip_h = input_direction < 0
	
	if player.is_on_floor():
		if player.get_input_direction() == 0:
			state_machine.change_state("Idle")
		else:
			state_machine.change_state("Run")
