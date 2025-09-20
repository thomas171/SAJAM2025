extends CharacterBody2D

@export var move_speed: float = 200.0
@export var follow_camera: Camera2D
@export var pull_force: float = 800.0
@export var damage_tick: int = 1
@export var damage_interval: float = 0.15

var inside_wind: Array = []
var break_targets: Array = []
var _damage_t := 0.0
var tornado_speed := 100.0

@onready var sprite: Sprite2D = $Sprite
@onready var wind_shape: CollisionShape2D = $WindArea/CollisionShape2D

func _ready() -> void:
	if follow_camera: follow_camera.make_current()

func _physics_process(delta: float) -> void:
	var x := Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y := Input.get_action_strength("move_down")  - Input.get_action_strength("move_up")
	var dir := Vector2(x, y).normalized()
	velocity = dir * move_speed
	move_and_slide()

	for b in inside_wind:
		if is_instance_valid(b) and b is RigidBody2D:
			var to_center = (global_position - b.global_position).normalized()
			b.apply_central_force(to_center * pull_force)

	_damage_t += delta
	if _damage_t >= damage_interval:
		_damage_t = 0.0
		for b in break_targets:
			if is_instance_valid(b) and b.has_method("apply_damage"):
				b.apply_damage(damage_tick)

func _on_wind_area_body_entered(body: Node2D) -> void:
	inside_wind.append(body)
	if body.has_method("set_wind_active"):
		body.set_wind_active(true)

func _on_wind_area_body_exited(body: Node2D) -> void:
	inside_wind.erase(body)
	if body.has_method("set_wind_active"):
		body.set_wind_active(false)

func _on_break_area_body_entered(body: Node2D) -> void:
	break_targets.append(body)

func _on_break_area_body_exited(body: Node2D) -> void:
	break_targets.erase(body)
