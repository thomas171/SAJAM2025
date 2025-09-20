extends CharacterBody2D

@export var move_speed: float = 200.0
@export var follow_camera: Camera2D

var input_vec: Vector2 = Vector2.ZERO


func _ready() -> void:
	if follow_camera:
		follow_camera.make_current()
		

func _physics_process(delta: float) -> void:
	var x := Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y := Input.get_action_strength("move_down")  - Input.get_action_strength("move_up")
	var dir := Vector2(x, y).normalized()
	
	velocity = dir * move_speed
	move_and_slide()
