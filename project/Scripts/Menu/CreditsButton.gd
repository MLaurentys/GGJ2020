extends Button

func _on_Credits_pressed() -> void:
	$Effect.play()
	var tree = self.get_tree()
	var locator: Locator = Locator.new(tree)
	var menu = locator.find_entity("menu")
	var credits = menu.get_node("CreditsMenu")
	credits.show()
