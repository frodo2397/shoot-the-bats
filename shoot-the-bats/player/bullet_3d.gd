extends Area3D

const SPEED = 55.0
const RANGE = 100.0

var traveled_distance = 0.0

func _physics_process(delta):
	position += SPEED * transform.basis.z * delta
	traveled_distance += SPEED * delta
	
#will emit this signal when it enters any object
#this is how we calculate when the bullet hits the mob. 
func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage()
		queue_free() #delete the bullet (but only if the mob has taken damage, otherwise auto deletes from touching gun)
