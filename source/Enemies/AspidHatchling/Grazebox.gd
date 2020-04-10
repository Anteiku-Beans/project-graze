extends Grazebox

func _ready():
	self.connect("grazed", self, "_on_grazed")

func _on_grazed(amount):
	print("Aspid grazed: {amount} ({remaining} remaining)".format({amount=amount, remaining = get_mana()}))
