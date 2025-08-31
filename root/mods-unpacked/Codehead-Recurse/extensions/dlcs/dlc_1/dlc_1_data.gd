extends "res://dlcs/dlc_1/dlc_1_data.gd"

var precalculated_curse_factor: float = -1.0

func get_random_curse_factor(min_curse_factor: float) -> float:
	var rng = RandomNumberGenerator.new()
	var wave_basis = RunData.current_wave
	var wave_modifier = cursed_item_percent_modifier_increase_each_wave * min(20, (wave_basis - 1))
	var max_modifier = cursed_item_base_percent_modifier + wave_modifier + cursed_item_random_percent_modifier
	var max_curse_factor = max_modifier / 100.0
	var curse_factor = rng.randf_range(min_curse_factor, max_curse_factor)
	return stepify(curse_factor, 0.01)

# override to allow for different random value calcualtion in get_random_curse_factor()
func _get_cursed_item_effect_modifier(turn_randomization_off: bool = false, min_modifier: float = 0.0) -> float:
	if precalculated_curse_factor > 0:
		return precalculated_curse_factor
	return ._get_cursed_item_effect_modifier(turn_randomization_off, min_modifier)

func recurse_item(item_data: ItemParentData, player_index: int) -> ItemParentData:
	if RunData.recurse_mode == "off":
		return item_data

	# find base version of item
	var base_item
	if item_data is ItemData:
		base_item = ItemService.get_item_from_id(item_data.my_id)
	else:
		base_item = ItemService.get_element(ItemService.weapons, item_data.my_id)
	

	var recursed_item: ItemParentData
	
	if RunData.recurse_mode == "simple":
		# reroll the curse factor, but discard values that are lower than before
		recursed_item = .curse_item(base_item, player_index, false, item_data.curse_factor)
	elif RunData.recurse_mode == "level_based":
		# chose the non-randomized, level based curse factor (if it is higher than before)
		recursed_item = .curse_item(base_item, player_index, true, item_data.curse_factor)
	elif RunData.recurse_mode == "improving":
		# roll a random curse factor between the current and maximal achievable curse value
		# pre-set a curse factor, which overrides the modified random function used in .curse_item()
		precalculated_curse_factor = get_random_curse_factor(item_data.curse_factor)
		recursed_item = .curse_item(base_item, player_index)
		precalculated_curse_factor = -1.0 # reset to get normal behavior
	else:
		ModLoaderLog.warning("unknown recurse_mode specified: %s" % RunData.recurse_mode, RunData.RecurseSettingsHandler.MOD_ID)

	return recursed_item
