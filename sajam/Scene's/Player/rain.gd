extends Node2D

@onready var cam := get_viewport().get_camera_2d()

func _process(_delta): 
	if cam: global_position = cam.global_position
