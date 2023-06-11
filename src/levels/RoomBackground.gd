extends ParallaxBackground

signal background_changed

onready var parallaxLayerFrontSprite = $ParallaxLayerFront/Sprite
onready var parallaxLayerBackSprite = $ParallaxLayerBack/Sprite


func set_background(frontLayer, backLayer):
	parallaxLayerBackSprite.texture = backLayer
	parallaxLayerFrontSprite.texture = frontLayer
	emit_signal("background_changed")
