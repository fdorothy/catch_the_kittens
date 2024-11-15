extends Area2D

signal on_hit
var targets: Array[Vector2]
var start_position: Vector2
var current_target = 0
var t: float = 0.0
var delay: bool = true
@export var speed = .5
@export var delay_time = 0.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("bats")
	$AnimatedSprite2D.play("idle")
	var target = find_child("Target")
	targets.append(global_position)
	if target:
		targets.append(target.global_position)
	start_position = position

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		on_hit.emit()

func _process(delta: float) -> void:
	if delay:
		t -= delta
		if t < 0.0:
			t = 0.0
			delay = false
	else:
		t += delta * speed
		if t > 1.0:
			t = delay_time
			delay = true
			start_position = targets[current_target]
			current_target = (current_target+1) % targets.size()
		else:
			global_position = start_position.lerp(targets[current_target], sin_wave(t))
	
func sin_wave(t) -> float:
	return sin(t * PI / 2.0)
