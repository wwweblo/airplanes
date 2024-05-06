extends Area2D

@export_enum("Cooldown","HitOnce","DisableHitBox") var HurtBoxType = 0

@onready var collision = $CollisionShape2D
@onready var disableTimer = $DisableTimer

signal hurt(damage)




func _on_disable_timer_timeout():
	collision.call_deferred("set","disabled",false)


func _on_area_entered(area):
	#print("area_entered")
	if area.is_in_group("attack"):
		if not area.get("damage") == null:
			match HurtBoxType:
				0: #Cooldown
					collision.call_deferred("set","disabled",true)
					disableTimer.start()
				1: #HitOnce
					pass
				2: #DisableHitBox
					if area.has_method("tempdisable"):
						area.tempdisable()
			var damage = area.damage
			emit_signal("hurt", damage)	
			if area.has_method("enemy_hit"):
				print("enemy_hit: true")
				area.enemy_hit(1)
			else:
				print(str(area.name) + " enemy_hit: false")
		else:
			print(str(area.name) + " damage = null")
	else:
		print(str(area.name) +  "not in group attack")
