"""MCP tool for TileMap / TileMapLayer authoring."""

from __future__ import annotations

from fastmcp import FastMCP

from godot_ai.handlers import tilemap as tilemap_handlers
from godot_ai.tools._meta_tool import register_manage_tool

_DESCRIPTION = """\
TileMap / TileMapLayer authoring (set tiles, fill rects, clear, read cells).

All operations target TileMapLayer nodes in the currently edited scene by
scene-relative path (e.g. "/LavaLake20x20/Ground"). All write ops are
undoable via EditorUndoRedoManager.

source_id is the TileSet source index. atlas_col/atlas_row are the
atlas coordinates of the tile within that source. For full-tile animated
sources (lava, water, sewage) use atlas_col=0, atlas_row=0.

IMPORTANT — Source-ID remapping in specialized .tres files:
When a layer uses a specialized .tres (e.g. volcano_animated.tres),
Source-IDs are re-numbered from 0. Example: volcano lava is Source 8 in
the main volcano.tres but Source 0 in volcano_animated.tres.
Always use the remapped ID when the TileMapLayer references a specialized
.tres, not the original ID from the main .tres.

Ops:
  • tilemap_set_cell(path, source_id, atlas_col, atlas_row, map_x, map_y)
        Set a single tile at (map_x, map_y).
        Returns: {map_x, map_y, source_id, atlas_col, atlas_row}

  • tilemap_set_cells_rect(path, source_id, atlas_col, atlas_row,
                            rect_x, rect_y, rect_w, rect_h)
        Fill a rect_w × rect_h region starting at (rect_x, rect_y) with
        one tile type in a single undo action.
        Returns: {cells_filled, rect: {x, y, w, h}}

  • tilemap_clear(path)
        Remove all tiles from the layer.
        Returns: {cleared: true}

  • tilemap_get_cells(path)
        Return all used cell coordinates.
        Returns: {cells: [{x, y}, ...], count: int}
"""


def register_tilemap_tools(mcp: FastMCP) -> None:
    register_manage_tool(
        mcp,
        tool_name="tilemap_manage",
        description=_DESCRIPTION,
        ops={
            "tilemap_set_cell":       tilemap_handlers.tilemap_set_cell,
            "tilemap_set_cells_rect": tilemap_handlers.tilemap_set_cells_rect,
            "tilemap_clear":          tilemap_handlers.tilemap_clear,
            "tilemap_get_cells":      tilemap_handlers.tilemap_get_cells,
        },
        read_resource_forms={
            # tilemap_get_cells is a read op with no godot:// resource counterpart
            "tilemap_get_cells": None,
        },
    )
