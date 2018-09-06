extends KinematicBody2D

const MAX_SPEED = 300 #Define a velocidade Máxima
const MAX_FORCE = 0.02 #Define a força Máxima usada para 'dirigir' o vetor de velocidade.
const arriving_radius = 100
var velocity = Vector2()
onready var target = get_pos()

export (int, "SEEK", "FLEE", "SEEK - ARRIVE", "FLEE - LIMIT") var mode = 0

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	velocity = steer(target)
	move(velocity * delta)
	target = get_viewport().get_mouse_pos()

func steer(target_pos):	
	if mode == 0:
		movement_seek(taget_pos)
	if mode == 1:
		movement_seek_arrival(target_pos)
	if mode == 2:
		movement_flee(target_pos)
	if mode == 3:
		movement_flee_limited(target_pos)
	
func movement_seek(target_pos):
	var desired_velocity = target_pos - get_pos()
	var distance = desired_velocity.length()
	desired_velocity = desired_velocity.normalized() * MAX_SPEED
	var steer = desired_velocity - velocity
	var target_velocity = velocity + (steer * MAX_FORCE)
	return(target_velocity)

func movement_seek_arrival(target_pos):
	var desired_velocity = target_pos - get_pos()
	var distance = desired_velocity.length()
	if distance < arriving_radius:
		desired_velocity = desired_velocity.normalized() * MAX_SPEED * (distance / arriving_radius)
	else:
		desired_velocity = desired_velocity.normalized() * MAX_SPEED
	var steer = desired_velocity - velocity
	var target_velocity = velocity + (steer * MAX_FORCE)
	return(target_velocity)

func movement_flee(target_pos):
	var desired_velocity = target_pos - get_pos()
	var distance = desired_velocity.length()
	desired_velocity = -(desired_velocity.normalized() * MAX_SPEED)
	var steer = desired_velocity - velocity
	var target_velocity = velocity + (steer * MAX_FORCE)
	return(target_velocity)

func movement_flee_limited(target_pos):
	var desired_velocity = target_pos - get_pos()
	var distance = desired_velocity.length()
	if distance > arriving_radius:
		desired_velocity = desired_velocity.normalized() * MAX_SPEED * (distance / arriving_radius)
	else:
		desired_velocity = desired_velocity.normalized() * MAX_SPEED
	var steer = desired_velocity - velocity
	var target_velocity = velocity + (steer * MAX_FORCE)
	return(target_velocity)

func _on_Seek_pressed():
	mode = 0

func _on_Seek__Arrive_pressed():
	mode = 1

func _on_Flee_pressed():
	mode = 2

func _on_Flee__Limit_pressed():
	mode = 3
