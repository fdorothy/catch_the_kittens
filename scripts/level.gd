extends Node2D

var has_kitten = false
@export var nextScene: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Door.connect("body_entered", on_door_entered)
	$Kitten.connect("body_entered", on_kitten_entered)
	$HUD/Kitten.hide()
	
func on_door_entered(body):
	if body.name == "Player":
		if has_kitten:
			load_next_scene.call_deferred()

func load_next_scene():
	get_tree().change_scene_to_file(nextScene)
		
func on_kitten_entered(body):
	if body.name == "Player":
		has_kitten = true
		$HUD/Kitten.show()
		$Kitten.queue_free.call_deferred()
