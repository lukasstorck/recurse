extends "res://dlcs/dlc_1/dlc_1_data.gd"

var precalculated_curse_factor: float = -1.0

enum RECURSE_MODE {
	OFF, SIMPLE, LEVEL_BASED, IMPROVING, FULL, OVERCHARGED
}

func get_current_max_curse() -> float:
	var wave_basis = RunData.current_wave
	var wave_modifier = cursed_item_percent_modifier_increase_each_wave * min(20, (wave_basis - 1))
	var max_modifier = cursed_item_base_percent_modifier + wave_modifier + cursed_item_random_percent_modifier
	return max_modifier / 100.0

func get_random_curse_factor(min_curse_factor: float, max_curse_factor: float) -> float:
	var rng = RandomNumberGenerator.new()
	var curse_factor = rng.randf_range(min_curse_factor, max_curse_factor)
	return stepify(curse_factor, 0.01)

# override to allow for different random value calcualtion in get_random_curse_factor()
func _get_cursed_item_effect_modifier(turn_randomization_off: bool = false, min_modifier: float = 0.0) -> float:
	if precalculated_curse_factor > 0:
		return precalculated_curse_factor
	return ._get_cursed_item_effect_modifier(turn_randomization_off, min_modifier)

func recurse_item(item_data: ItemParentData, player_index: int) -> ItemParentData:
	if ProgressData.mod_settings.RECURSE_MODE == RECURSE_MODE.OFF:
		return item_data

	# find base version of item
	var base_item
	if item_data is ItemData:
		base_item = ItemService.get_item_from_id(item_data.my_id_hash)
	else:
		base_item = ItemService.get_element(ItemService.weapons, item_data.my_id_hash)

	var recursed_item: ItemParentData
	
	if ProgressData.mod_settings.RECURSE_MODE == RECURSE_MODE.SIMPLE:
		# reroll the curse factor, but discard values that are lower than before
		recursed_item = .curse_item(base_item, player_index, false, item_data.curse_factor)
	elif ProgressData.mod_settings.RECURSE_MODE == RECURSE_MODE.LEVEL_BASED:
		# chose the non-randomized, level based curse factor (if it is higher than before)
		recursed_item = .curse_item(base_item, player_index, true, item_data.curse_factor)
	elif ProgressData.mod_settings.RECURSE_MODE == RECURSE_MODE.IMPROVING:
		# roll a random curse factor between the current and maximal achievable curse value
		# pre-set a curse factor, which overrides the modified random function used in .curse_item()
		var max_curse_factor = get_current_max_curse()
		precalculated_curse_factor = get_random_curse_factor(item_data.curse_factor, max_curse_factor)
		recursed_item = .curse_item(base_item, player_index)
		precalculated_curse_factor = -1.0 # reset to get normal behavior
	elif ProgressData.mod_settings.RECURSE_MODE == RECURSE_MODE.FULL:
		# always set the curse factor to the highest possible level
		precalculated_curse_factor = get_current_max_curse()
		recursed_item = .curse_item(base_item, player_index)
		precalculated_curse_factor = -1.0 # reset to get normal behavior
	elif ProgressData.mod_settings.RECURSE_MODE == RECURSE_MODE.OVERCHARGED:
		# roll a random curse factor between the curent and current + 50% curse value
		# pre-set a curse factor, which overrides the modified random function used in .curse_item()
		precalculated_curse_factor = get_random_curse_factor(item_data.curse_factor, item_data.curse_factor + 0.5)
		recursed_item = .curse_item(base_item, player_index)
		precalculated_curse_factor = -1.0 # reset to get normal behavior
	else:
		ModLoaderLog.warning("unknown recurse_mode specified: %s" % str(RunData.recurse_mode), ProgressData.mod_settings.recurse_mod_id)

	return recursed_item
