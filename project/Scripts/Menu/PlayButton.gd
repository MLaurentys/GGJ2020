extends Button

func _on_Play_pressed() -> void:
	$Effect.play()
	var tree = self.get_tree()
	var locator: Locator = Locator.new(tree)
	var menu = locator.find_entity("menu")
	global.play_tutorial = menu.get_node("EnableTutorial").pressed
	var error_flag = tree.change_scene("res://Game.tscn")
