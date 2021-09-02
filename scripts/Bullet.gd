extends Area2D

var SPEED = 500

func _ready() -> void:
	connect("body_entered", self, "on_body_entered")

func _physics_process(delta: float) -> void:
	position += transform.x * SPEED * delta
	
func on_body_entered(body: Node):
	if body.is_in_group("enemy"):
		return
	if body.is_in_group("player") and body.has_method("take_damage"):
		body.take_damage(self)
	queue_free()
