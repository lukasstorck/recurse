extends "res://ui/menus/shop/base_shop.gd"

func recurse_player_locked_items(player_index: int) -> void:
	# assumes that dlc is present, must ensure before calling this function
	var dlc_data = ProgressData.get_dlc_data("abyssal_terrors")

	var curse_locked_items: int = RunData.get_player_effect("curse_locked_items", player_index)
	var locked_items: Array = RunData.locked_shop_items[player_index]

	for i in locked_items.size():
		var item = locked_items[i][0]
		var chance_success = Utils.get_chance_success((RunData.players_data[player_index].curse_locked_shop_items_pity + curse_locked_items) / 100.0)
		if locked_items[i][0].is_cursed and chance_success:
			locked_items[i][0] = dlc_data.recurse_item(locked_items[i][0], player_index)

func _on_tree_exited() -> void :
	if RunData.enabled_dlcs.has("abyssal_terrors"):
		for player_index in range(RunData.get_player_count()):
			recurse_player_locked_items(player_index)

	# run normal behavior
	._on_tree_exited()
