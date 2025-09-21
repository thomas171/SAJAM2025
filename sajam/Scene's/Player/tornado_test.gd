extends RigidBody2D

var tornado_rotation_speed := -5
var tornado_speed := 150.0
@onready var tornado: Sprite2D = $TornadoSprite

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("move_up"):
		apply_force(Vector2.UP * tornado_speed)
	if Input.is_action_pressed("move_down"):
		apply_force(Vector2.DOWN * tornado_speed)
	if Input.is_action_pressed("move_right"):
		apply_force(Vector2.RIGHT * tornado_speed)
	if Input.is_action_pressed("move_left"):
		apply_force(Vector2.LEFT * tornado_speed)
		
	tornado.rotate(tornado_rotation_speed * delta)
