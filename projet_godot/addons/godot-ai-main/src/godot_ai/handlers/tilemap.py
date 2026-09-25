"""Shared handlers for TileMap / TileMapLayer authoring tools."""

from __future__ import annotations

from godot_ai.handlers._readiness import require_writable_async
from godot_ai.runtime.direct import DirectRuntime


async def tilemap_set_cell(
    runtime: DirectRuntime,
    path: str,
    source_id: int,
    atlas_col: int,
    atlas_row: int,
    map_x: int,
    map_y: int,
) -> dict:
    """Set a single tile at (map_x, map_y) on a TileMapLayer node."""
    await require_writable_async(runtime)
    return await runtime.send_command(
        "tilemap_set_cell",
        {
            "path": path,
            "source_id": source_id,
            "atlas_col": atlas_col,
            "atlas_row": atlas_row,
            "map_x": map_x,
            "map_y": map_y,
        },
    )


async def tilemap_set_cells_rect(
    runtime: DirectRuntime,
    path: str,
    source_id: int,
    atlas_col: int,
    atlas_row: int,
    rect_x: int,
    rect_y: int,
    rect_w: int,
    rect_h: int,
) -> dict:
    """Fill a rect_w × rect_h region starting at (rect_x, rect_y) with one
    tile type in a single undo action.
    """
    await require_writable_async(runtime)
    return await runtime.send_command(
        "tilemap_set_cells_rect",
        {
            "path": path,
            "source_id": source_id,
            "atlas_col": atlas_col,
            "atlas_row": atlas_row,
            "rect_x": rect_x,
            "rect_y": rect_y,
            "rect_w": rect_w,
            "rect_h": rect_h,
        },
    )


async def tilemap_clear(
    runtime: DirectRuntime,
    path: str,
) -> dict:
    """Remove all tiles from a TileMapLayer node."""
    await require_writable_async(runtime)
    return await runtime.send_command("tilemap_clear", {"path": path})


async def tilemap_get_cells(
    runtime: DirectRuntime,
    path: str,
) -> dict:
    """Return all used cell coordinates of a TileMapLayer node.

    Returns ``{cells: [{x, y}, ...], count: int}``.
    """
    return await runtime.send_command("tilemap_get_cells", {"path": path})
