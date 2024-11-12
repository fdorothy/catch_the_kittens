extends Area2D

signal on_hit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("bats")
	$AnimatedSprite2D.play("idle")

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		on_hit.emit()
