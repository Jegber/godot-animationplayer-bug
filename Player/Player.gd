extends KinematicBody2D
class_name Player, "res://Player/player-icon.png"

enum {
	MOVE,
	ROLL,
	ATTACK
}
var state = MOVE
var velocity = Vector2.ZERO
const MAX_SPEED = 100
const ACCELERATION = 1000
const FRICTION = 800

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

func _ready():
	animationTree.active = true

# Called when the node enters the scene tree for the first time.
func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			pass
		ATTACK:
			attack_state(delta)
	
func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	velocity = velocity.move_toward(input_vector.normalized() * MAX_SPEED, ACCELERATION * delta)
	
	if input_vector != Vector2.ZERO:
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationState.travel("Run")
	else:
		animationState.travel("Idle")
	
	velocity = move_and_slide(velocity)
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
	
func attack_state(delta):
	animationState.travel("Attack")
	
func attack_animation_finished():
	state = MOVE
	print("AnimationPlayer's Call Method Track Key called!")
	print(OS.get_ticks_msec())

