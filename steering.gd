extends KinematicBody2D

const MAX_SPEED = 300 #Define a velocidade Máxima
const MAX_FORCE = 0.02 #Define a força Máxima usada para 'dirigir' o vetor de velocidade.
const arriving_radius = 1000
var velocity = Vector2()
onready var target = get_pos()

export (int, "SEEK", "FLEE") var mode = 0

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	velocity = steer(target)
	move(velocity * delta)
	target = get_viewport().get_mouse_pos()

func steer(target_pos):
	var desired_velocity = target_pos - get_pos()
	var distance = desired_velocity.length()
	
	if mode == 0:
		pass
	if mode == 1:
		desired_velocity = -desired_velocity
	
	if distance < arriving_radius:
		desired_velocity = desired_velocity.normalized() * MAX_SPEED * (distance / arriving_radius)
	else:
		desired_velocity = desired_velocity.normalized() * MAX_SPEED
	var steer = desired_velocity - velocity
	var target_velocity = velocity + (steer * MAX_FORCE)
	return(target_velocity)
	
	
