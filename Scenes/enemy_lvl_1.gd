extends CharacterBody2D

@export var movement_speed = 80
@export var hp = 10

@onready var sprite = $Sprite2D
@onready var player = get_tree().get_first_node_in_group("player")

func _physics_process(_delta):
	var direction = global_position.direction_to(player.global_position)
	
	# Установим угол поворота спрайта в направлении движения
	sprite.rotation_degrees = (direction.angle() + PI/2) * 180 / PI
	
	velocity = direction.normalized() * movement_speed
	move_and_slide()


func _on_hurtbox_hurt(damage):
	hp -= damage
	print("enemy hp: " + str(hp))
	if hp <= 0:
		queue_free()
