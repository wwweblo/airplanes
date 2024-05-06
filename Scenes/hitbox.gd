extends Area2D

@export var damage = 1

@onready var disable_hitbox_timer = $DisableHitboxTimer
@onready var collision = $CollisionShape2D

func tempdisable():
	collision.call_deferred("set", "disabled", true)
	disable_hitbox_timer.start()
	

func _on_disable_hitbox_timer_timeout():
	collision.call_deferred("set", "disabled", false)
