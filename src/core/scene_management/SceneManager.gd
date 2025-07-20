extends Node

signal scene_requested(target_scene_path: String, transition_data: TransitionData)

@onready var _game_root := get_tree().get_root()
@onready var _current_level_node: Node = get_node("/root/Main/CurrentLevel")

func _ready() -> void:
	scene_requested.connect(_on_scene_requested)

func _on_scene_requested(target_scene_path: String, transition_data: TransitionData) -> void:
	if get_tree().get_nodes_in_group("scene_transitioner").size() > 0:
		return
	
	var transitioner: CanvasLayer = transition_data.transition_scene.instantiate()
	transitioner.add_to_group("scene_transitioner")
	_game_root.add_child(transitioner)
	
	transitioner.process_mode = Node.PROCESS_MODE_ALWAYS
	
	var anim_player: AnimationPlayer = transitioner.get_node("AnimationPlayer")
	if anim_player == null:
		push_error("Scene Transitioner is missing an AnimationPlayer node.")
		_game_root.remove_child(transitioner)
		transitioner.queue_free()
		return
	
	get_tree().paused = true
	
	anim_player.play(transition_data.fade_out_animation)
	await anim_player.animation_finished
	
	if is_instance_valid(_current_level_node) and _current_level_node.get_child_count() > 0:
		_current_level_node.get_child(0).queue_free()
	
	ResourceLoader.load_threaded_request(target_scene_path)
	while ResourceLoader.load_threaded_get_status(target_scene_path) != ResourceLoader.THREAD_LOAD_LOADED:
		await get_tree().process_frame
	
	var next_scene_resource: PackedScene = ResourceLoader.load_threaded_get(target_scene_path)
	if not next_scene_resource:
		push_error("Failed to load scene: " + target_scene_path)
		return
	
	var new_scene_instance := next_scene_resource.instantiate()
	_current_level_node.add_child(new_scene_instance)
	
	anim_player.play(transition_data.fade_in_animation)
	await anim_player.animation_finished
	
	get_tree().paused = false
	
	transitioner.queue_free()
