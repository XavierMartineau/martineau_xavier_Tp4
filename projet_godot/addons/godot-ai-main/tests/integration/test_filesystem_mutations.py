"""Await real deferred filesystem operations in an isolated native editor."""

import json
import shutil
import subprocess
import sys
from pathlib import Path

import pytest

from tests.integration._self_update_fixture import (
    PLUGIN_ROOT,
    godot_bin_or_skip,
    run_godot_editor,
)

pytestmark = pytest.mark.editor

DRIVER = '''@tool
extends Node
const Suite = preload("res://mutation_suite.gd")
func _ready() -> void:
    if Engine.is_editor_hint():
        run.call_deferred()
func run() -> void:
    await get_tree().create_timer(2.0).timeout
    while EditorInterface.get_resource_filesystem().is_scanning():
        await get_tree().process_frame
    var suite := Suite.new()
    suite.suite_setup({})
    var results: Array[Dictionary] = []
    var failed := false
    for method in suite.get_method_list():
        var name := str(method.name)
        if not name.begins_with("test_mutation_"):
            continue
        suite._reset()
        await suite.call(name)
        var bad: bool = suite._failed or suite._assertion_count == 0 or suite._skipped
        results.append({"name": name, "failed": bad, "message": suite._message,
            "assertions": suite._assertion_count})
        failed = failed or bad
    suite.suite_teardown()
    var file := FileAccess.open("res://result.json", FileAccess.WRITE)
    file.store_string(JSON.stringify(results))
    file.close()
    get_tree().quit(1 if failed or results.size() < 10 else 0)
'''


def test_filesystem_mutations_native(tmp_path: Path) -> None:
    godot = godot_bin_or_skip()
    project = tmp_path / "project"
    shutil.copytree(PLUGIN_ROOT, project / "addons/godot_ai")
    (project / "tests").mkdir()
    shutil.copyfile(
        Path(__file__).with_name("_filesystem_mutation_suite.gd"),
        project / "mutation_suite.gd",
    )
    (project / "project.godot").write_text(
        'config_version=5\n[autoload]\nDriver="*res://driver.gd"\n', encoding="utf-8"
    )
    (project / "driver.gd").write_text(DRIVER, encoding="utf-8")
    environment = {"GODOT_AI_DISABLE_TELEMETRY": "true"}
    for key in ("APPDATA", "LOCALAPPDATA", "USERPROFILE", "HOME", "XDG_CONFIG_HOME"):
        directory = tmp_path / key.lower()
        directory.mkdir()
        environment[key] = directory.as_posix()
    outside = tmp_path / "outside"
    outside.mkdir()
    sentinel = outside / "sentinel.txt"
    sentinel.write_text("outside sentinel", encoding="utf-8")
    parked_link = tmp_path / "parked_link"
    if sys.platform == "win32":
        create_link = tmp_path / "create_link.ps1"
        create_link.write_text(
            "param([string]$LinkPath, [string]$TargetPath)\n"
            "New-Item -ItemType Junction -Path $LinkPath -Target $TargetPath | Out-Null\n",
            encoding="utf-8",
        )
        subprocess.run(
            [
                "powershell", "-NoProfile", "-NonInteractive", "-File", str(create_link),
                "-LinkPath", str(parked_link), "-TargetPath", str(outside),
            ],
            check=True, capture_output=True, text=True, timeout=15,
        )
    else:
        parked_link.symlink_to(outside, target_is_directory=True)
    environment["FILESYSTEM_LINK_FIXTURE"] = parked_link.as_posix()
    environment["FILESYSTEM_OUTSIDE_SENTINEL"] = sentinel.as_posix()
    log = run_godot_editor(project, godot, allow_headless=False, environment=environment)
    assert "SCRIPT ERROR" not in log, log
    results = json.loads((project / "result.json").read_text(encoding="utf-8"))
    assert len(results) >= 10, results
    assert all(not item["failed"] and item["assertions"] > 0 for item in results), results
