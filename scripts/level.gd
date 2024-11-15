extends Node2D

var has_kitten = false
@export var nextScene: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Door.connect("body_entered", on_door_entered)
	$Kitten.connect("body_entered", on_kitten_entered)
	
	# add the hud
	var hud_scene = load("res://scenes/hud.tscn")
	var instance = hud_scene.instantiate()
	add_child(instance)
	instance.connect("on_reset", on_reset)
	
	for bat in get_tree().get_nodes_in_group("bats"):
		bat.on_hit.connect(on_hit_enemy)
		
	
func on_reset():
	get_tree().reload_current_scene()
	
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

func on_hit_enemy():
	reload_level.call_deferred()

func reload_level():
	get_tree().reload_current_scene()
