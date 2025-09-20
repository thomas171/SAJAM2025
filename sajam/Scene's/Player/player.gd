extends CharacterBody2D


@export var follow_camera: Camera2D
@export var pull_force: float = 800.0
@export var damage_tick: int = 1
@export var damage_interval: float = 0.15
@export var acceleration := 800.0
@export var friction := 600.0


@export var cruise_speed: float = 150.0  
@export var max_speed: float    = 250.0   
@export var accel: float        = 600.0   
@export var decel: float        = 600.0  
@export var turn_rate: float    = 1.5   
@export var drift_jitter: float = 5.0     

@onready var sprite: Sprite2D = $Sprite

var inside_wind: Array = []
var break_targets: Array = []
var _damage_t := 0.0
var tornado_speed := 100.0
var heading: Vector2 = Vector2.RIGHT

func _physics_process(delta: float) -> void:
	var x := Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y := Input.get_action_strength("move_down")  - Input.get_action_strength("move_up")
	var input_dir := Vector2(x,y).normalized()
	
	if input_dir != Vector2.ZERO:
		heading = heading.move_toward(input_dir, turn_rate * delta).normalized()
	else:
		heading = heading.rotated(randf_range(-drift_jitter, drift_jitter)* delta).normalized()

	var speed := velocity.length()
	if input_dir != Vector2.ZERO:
		speed = min(max_speed, speed + accel * delta)
	else:
		speed = max(cruise_speed, speed - decel *  delta)
	
	velocity = heading * speed
	move_and_slide()

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
