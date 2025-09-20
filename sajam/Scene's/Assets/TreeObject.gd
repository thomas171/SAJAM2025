extends StaticBody2D
class_name TreeObject

@export var intact_hp := 3
@export var break_hp := 2
@export var stump_rect_size := Vector2(10,10) 
@export var wind_shake_px := 1.5
@export var wind_sway_deg := 4.0
@export var wind_speed := 6.0

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var col: CollisionShape2D = $CollisionShape2D

var _phase := randf() * TAU
var _t := 0.0
var _base_pos := Vector2.ZERO
var _base_rot := 0.0
var _wind_on := false
var _state := "intact"   # intact, break, stump from animationsprite2d
var _hp := 0

func _ready() -> void:
	_base_pos = anim.position
	_base_rot = anim.rotation
	_state = "intact"
	_hp = intact_hp
	anim.play("intact")
	anim.animation_finished.connect(_on_anim_finished)

func set_wind_active(on: bool) -> void:
	_wind_on = on
	if not on:
		anim.position = _base_pos
		anim.rotation = _base_rot

func apply_damage(amount: int) -> void:
	if _state == "stump": return
	_hp -= amount
	if _hp <= 0:
		if _state == "intact":
			_state = "break"
			_hp = break_hp
			anim.play("break")
		elif _state == "break":
			_to_stump()

func _on_anim_finished() -> void:
	if _state == "break" and _hp <= 0:
		_to_stump()

func _to_stump() -> void:
	_state = "stump"
	anim.play("stump")
	var shape := col.shape
	if shape is RectangleShape2D:
		shape.size = stump_rect_size
	elif shape is CircleShape2D:
		(shape as CircleShape2D).radius = min(stump_rect_size.x, stump_rect_size.y) * 0.5
	_wind_on = false
	anim.position = _base_pos
	anim.rotation = _base_rot

func _process(delta: float) -> void:
	if not _wind_on or _state == "stump": return
	_t += delta * wind_speed
	var off := Vector2(cos(_t + _phase), sin(_t * 1.3 + _phase)) * wind_shake_px
	anim.position = _base_pos + off
	anim.rotation = _base_rot + deg_to_rad(sin(_t * 0.8 + _phase) * wind_sway_deg)
