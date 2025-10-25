extends CharacterBody2D

class_name Player

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var area_collision_shape_2d = $Area2D/AreaCollisionShape2D
@onready var body_collision_shape_2d = $BodyCollisionShape2D

@export_group("Locomotion")
@export var run_speed_damping = 0.5
@export var speed = 100.0
@export var jump_velocity = -360.0
@export_group("")

func _ready():
	$Camera2D.enabled = true

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		if Input.is_action_just_pressed("ui_up"):
			velocity.y = jump_velocity

	var direction = Input.get_axis("ui_left", "ui_right")
	velocity.x = direction * speed

	move_and_slide()
	
	if not is_on_floor():
		animated_sprite_2d.play("cat_jump")
	elif direction != 0:
		animated_sprite_2d.play("cat_run")
	else:
		animated_sprite_2d.play("cat_idle")
	if direction != 0:
		animated_sprite_2d.flip_h = direction > 0
