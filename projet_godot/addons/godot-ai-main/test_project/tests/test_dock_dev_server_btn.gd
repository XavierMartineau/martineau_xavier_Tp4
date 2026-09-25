@tool
extends McpTestSuite

## Truth-table tests for McpDock's static dev-section button helpers:
##  - `_dev_primary_btn_state(managed, external)` renders process authority.
##  - `_dev_stop_btn_state(managed)` gates the "✕" stop affordance.
## Static helpers so the truth table can be verified without a real plugin.

const McpDockScript = preload("res://addons/godot_ai/mcp_dock.gd")


func suite_name() -> String:
	return "dock_dev_server_btn"


# --- _dev_primary_btn_state ---------------------------------------------

func test_primary_label_says_restart_when_managed_running() -> void:
	var state: Dictionary = McpDockScript._dev_primary_btn_state(true, false)
	assert_eq(state["text"], "Restart Managed Server",
		"Managed running means click will kill+respawn — label says Restart")
	assert_true(state["enabled"])
	assert_contains(state["tooltip"], "plugin-owned")


func test_primary_disables_when_external_server_is_running() -> void:
	var state: Dictionary = McpDockScript._dev_primary_btn_state(false, true)
	assert_eq(state["text"], "External Server Running")
	assert_false(state["enabled"])
	assert_contains(state["tooltip"], "process that launched it")


func test_primary_label_says_start_when_nothing_running() -> void:
	var state: Dictionary = McpDockScript._dev_primary_btn_state(false, false)
	assert_eq(state["text"], "Start Managed Server",
		"Nothing running means click is a fresh spawn — label adapts to Start")
	assert_true(state["enabled"])
	assert_contains(state["tooltip"], "current checkout")


func test_primary_label_prefers_owned_grant_when_both_inputs_are_true() -> void:
	var state: Dictionary = McpDockScript._dev_primary_btn_state(true, true)
	assert_eq(state["text"], "Restart Managed Server")


# --- _dev_stop_btn_state ------------------------------------------------

func test_stop_btn_enabled_when_managed_server_is_running() -> void:
	var state: Dictionary = McpDockScript._dev_stop_btn_state(true)
	assert_eq(state["enabled"], true,
		"Stop button enables only when there's a dev server to kill")
	assert_contains(state["tooltip"], "Stop")


func test_stop_btn_disabled_when_no_dev_server() -> void:
	var state: Dictionary = McpDockScript._dev_stop_btn_state(false)
	assert_eq(state["enabled"], false,
		"No managed server means nothing to stop — button stays disabled")
	assert_contains(state["tooltip"], "No plugin-owned",
		"Tooltip explains why so the user isn't left guessing")
