extends CharacterBody2D

var movement_speed = 100
var hp = 100

#Attack
var fork = preload("res://Scenes/fork.tscn")

#AttackNodes
@onready var forkTimer = %ForkTimer
@onready var forkAttackTimer = %ForkAttackTimer

#Fork
var fork_ammo = 0
var fork_baseammo = 1
var fork_attack_speed = 1
var fork_level = 1

#Enemy Related
var enemy_close = []

@onready var sprite = $Sprite2D
var last_rotation = 0

func _ready():
	attack()

func _physics_process(delta):
	movement()
	
func movement():
	var x_mov = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_mov = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	var mov = Vector2(x_mov, y_mov) 
	# Поворот по направлению движения
	if mov != Vector2.ZERO:
		var angle = mov.angle() + PI/2 
		sprite.rotation_degrees = angle * 180 / PI
		last_rotation = sprite.rotation_degrees
	sprite.rotation_degrees = last_rotation
	
	velocity = mov.normalized() * movement_speed
	move_and_slide()

func _on_hurtbox_hurt(damage):
		hp -= damage
		print("player get damaged:" + str(hp))
		
func attack():
	if fork_level > 0:
		forkTimer.wait_time = fork_attack_speed
		if forkTimer.is_stopped():
			forkTimer.start()

func _on_fork_timer_timeout():
	fork_ammo += fork_baseammo
	forkAttackTimer.start()


func _on_fork_attack_timer_timeout():
	if fork_ammo > 0:
		var fork_attack = fork.instantiate()
		fork_attack.position = position
		fork_attack.target = get_random_target()
		fork_attack.level = fork_level
		add_child(fork_attack)
		fork_ammo -= 1
		if fork_ammo > 0:
			forkAttackTimer.start()
		else:
			forkAttackTimer.stop

func get_random_target():
	if enemy_close.size() > 0:
		#print("enemy_selected")
		return enemy_close.pick_random().global_position
	else:
		print("enemy is not found")
		return Vector2.UP

func _on_enemy_detection_area_body_entered(body):
	#print("enemy_detacted")
	if not enemy_close.has(body):
		enemy_close.append(body)

func _on_enemy_detection_area_body_exited(body):
		if not enemy_close.has(body):
			enemy_close.erase(body)
