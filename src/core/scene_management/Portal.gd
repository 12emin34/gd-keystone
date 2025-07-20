extends Area2D

@export_group("Portal Configuration")
@export_file("*.tscn") var target_scene: String

@export var transition_data: TransitionData

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		set_deferred("monitoring", false)
		
		if not target_scene or not transition_data:
			push_warning("Portal is missing a Target Scene or Transition Data.")
			return
		
		SceneManager.scene_requested.emit(target_scene, transition_data)
