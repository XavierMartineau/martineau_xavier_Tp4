@tool
extends McpTestSuite

const Authority := preload("res://addons/godot_ai/utils/server_authority.gd")


func suite_name() -> String:
	return "server_authority"


func test_transport_authority_keeps_secrets_out_of_public_snapshot() -> void:
	var value := Authority.TransportAuthority.new(
		8000,
		9500,
		"b".repeat(32),
		"h".repeat(32),
		"a".repeat(64),
	)
	assert_true(value.is_valid())
	var snapshot := value.public_snapshot()
	assert_eq(snapshot.server_instance_id, "b".repeat(32))
	assert_false(snapshot.has("http_capability"))
	assert_false(snapshot.has("ws_capability"))


func test_transport_authority_requires_distinct_scoped_capabilities() -> void:
	var shared := "a".repeat(64)
	var value := Authority.TransportAuthority.new(
		8000, 9500, "b".repeat(32), shared, shared
	)
	assert_false(value.is_valid())


func test_owned_process_grant_binds_pid_and_fingerprint() -> void:
	var value := Authority.OwnedProcessGrant.new(4242, "start-1", 100)
	assert_true(value.is_valid())
	assert_true(value.matches(4242, "start-1"))
	assert_false(value.matches(4242, "start-2"))
	assert_false(value.matches(4243, "start-1"))


func test_replacement_authorization_is_bound_expiring_and_spend_once() -> void:
	var value := Authority.ReplacementAuthorization.new(
		"server-a", "4.0.0", 8000, 200
	)
	assert_false(value.spend(100, "server-b", "4.0.0", 8000))
	assert_false(value.is_spent())
	assert_true(value.spend(200, "server-a", "4.0.0", 8000))
	assert_true(value.is_spent())
	assert_false(value.spend(200, "server-a", "4.0.0", 8000))


func test_replacement_authorization_cannot_be_spent_after_expiry() -> void:
	var value := Authority.ReplacementAuthorization.new(
		"server-a", "4.0.0", 8000, 200
	)
	assert_false(value.spend(201, "server-a", "4.0.0", 8000))
	assert_false(value.is_spent())
