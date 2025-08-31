extends Node

var MOD_ID: String
const FALLBACK_CONFIG = {
	"RECURSE_MODE": "simple"
}

func set_mod_id(mod_id: String) -> void:
	MOD_ID = mod_id

func get_settings() -> Dictionary:
	var version = ModLoaderStore.mod_data[MOD_ID].manifest.version_number
	var config = ModLoaderConfig.get_config(MOD_ID, version)

	if config != null:
		return config.data
	
	var default_config = ModLoaderConfig.get_default_config(MOD_ID)
	if default_config == null:
		ModLoaderLog.warn("Neither a saved config or the default config were found, using static fallback values %s" % str(FALLBACK_CONFIG), MOD_ID)
		return FALLBACK_CONFIG

	config = ModLoaderConfig.create_config(MOD_ID, version, default_config.data)
	ModLoaderLog.info("Created recurse config from default values", MOD_ID)
	return config.data
