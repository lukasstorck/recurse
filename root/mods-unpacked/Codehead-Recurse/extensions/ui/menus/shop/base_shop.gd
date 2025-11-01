extends "res://ui/menus/shop/base_shop.gd"

func recurse_player_locked_items(player_index: int) -> void:
	# assumes that dlc is present, must ensure before calling this function
	var dlc_data = ProgressData.get_dlc_data("abyssal_terrors")
	
	if not ProgressData.mod_settings.RECURSE_ENABLED:
		return

	var curse_locked_items: int = RunData.get_player_effect("curse_locked_items", player_index)
	var locked_items: Array = RunData.locked_shop_items[player_index]

	var potential_recursable_items = 0
	var recursed_items = 0

	for i in locked_items.size():
		if not locked_items[i][0].is_cursed:
			continue

		potential_recursable_items += 1

		var chance_success = Utils.get_chance_success((RunData.players_data[player_index].curse_locked_shop_items_pity + curse_locked_items) / 100.0)
		if ProgressData.mod_settings.RECURSE_IGNORE_CURSE_CHANCE:
			chance_success = true

		if chance_success:
			recursed_items += 1

			var locked_cursed_item = locked_items[i][0]
			var recursed_item = dlc_data.recurse_item(locked_cursed_item, player_index)
			locked_items[i][0] = recursed_item

			if ProgressData.mod_settings.RECURSE_DEBUG:
				var old_item_name = locked_cursed_item.name
				var old_item_curse_factor = locked_cursed_item.curse_factor * 100
				var new_item_curse_factor = recursed_item.curse_factor * 100
				var message = "Recurse Event for %s in slot %s (curse factor %s%%-> %s%%)" % [old_item_name, str(i), old_item_curse_factor, new_item_curse_factor]
				ModLoaderLog.info(message, ProgressData.mod_settings.recurse_mod_id)
	
	if ProgressData.mod_settings.RECURSE_DEBUG:
		var message = "%s out of %s suitable items (locked and already cursed) were recursed for player %s" % [recursed_items, potential_recursable_items, player_index]
		ModLoaderLog.info(message, ProgressData.mod_settings.recurse_mod_id)


func _on_tree_exited() -> void:
	if RunData.enabled_dlcs.has("abyssal_terrors"):
		for player_index in range(RunData.get_player_count()):
			recurse_player_locked_items(player_index)

	# run normal behavior
	._on_tree_exited()
