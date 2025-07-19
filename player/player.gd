extends CharacterBody2D

@export var speed = 100

var should_flip: bool = false

func get_input():
	var input_direction = Input.get_axis("ui_left", "ui_right")
	velocity.x = input_direction * speed
	if velocity.x == 0:
		$AnimatedSprite2D.play("default")
	else:
		$AnimatedSprite2D.play("walk")
		should_flip = velocity.x < 0
	
	$AnimatedSprite2D.flip_h = should_flip
	
func _physics_process(delta):
	get_input()
	move_and_slide()
