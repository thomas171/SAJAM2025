extends StaticBody2D
class_name TreeObject

@export var max_health := 3
@export var wind_shake_px := 1.0
@export var wind_sway_deg := 1.5
@export var wind_speed := 6.0

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var col: CollisionShape2D = $CollisionShape2D

var health := 3
var _wind_on := false
var _t := 0.0
var _phase := randf() * TAU
var _base_pos := Vector2.ZERO
var _base_rot := 0.0

func _ready() -> void:
	health = max_health
	_base_pos = anim.position
	_base_rot = anim.rotation
	anim.play("intact")

func set_wind_active(on: bool) -> void:
	_wind_on = on
	if not on:
		anim.position = _base_pos
		anim.rotation = _base_rot

func apply_damage(amount: int) -> void:
	if health <= 0: return
	health -= amount
	if health <= 0:
		anim.play("break")
		anim.animation_finished.connect(func():
			anim.play("stump")
		, CONNECT_ONE_SHOT)

func _process(delta: float) -> void:
	if not _wind_on: return
	_t += delta * wind_speed
	var off := Vector2(cos(_t + _phase), sin(_t * 1.3 + _phase)) * wind_shake_px
	anim.position = _base_pos + off
	anim.rotation = _base_rot + deg_to_rad(sin(_t * 0.8 + _phase) * wind_sway_deg)
