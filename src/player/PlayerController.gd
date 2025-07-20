class_name Player
extends CharacterBody2D

signal state_changed(new_state_name)

@export_group("Movement Properties")
@export var speed: float = 300.0
@export var acceleration: float = 25.0
@export var air_acceleration: float = 10.0
@export var friction: float = 25.0

@export_group("Jump Properties")
@export var jump_velocity: float = -400.0
@export var gravity: float = 800.0

@onready var state_machine: StateMachine = $StateMachine
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	add_to_group("player")

func _physics_process(delta: float) -> void:
	if state_machine.current_state:
		state_machine.process_physics(delta)
	
	if not is_on_floor():
		velocity.y += gravity * delta
	
	move_and_slide()

func _input(event: InputEvent) -> void:
	if state_machine.current_state:
		state_machine.process_input(event)

func get_input_direction() -> float:
	return Input.get_axis("move_left", "move_right")
