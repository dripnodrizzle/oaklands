interface SidebarProps {
  palette: string[];
  onAddElement: (type: string) => void;
  onClickToPlace: (type: string) => void;
  assets: Array<{ id: string; name: string; url: string }>;
  onAssetClick: (asset: any) => void;
  onAssetDrag: (asset: any, e: React.DragEvent) => void;
  pendingNodeType: string | null;
  savedNodes: Array<{ id: string; name: string; elements: any[] }>;
  onSaveNode: () => void;
  onDeleteNode: (id: string) => void;
  popups: Array<{ id: string; name: string; elements: any[] }>;
  onAddPopup: (popupElements: any[]) => void;
  onDeletePopup: (id: string) => void;
  isToolbar?: boolean;
  onPaletteNodeClick: (type: string | null) => void;
}

const Sidebar: React.FC<SidebarProps> = ({
  palette = [],
  onAddElement,
  onClickToPlace,
  assets = [],
  onAssetClick,
  onAssetDrag,
  pendingNodeType,
  savedNodes,
  onSaveNode,
  onDeleteNode,
  popups,
  onAddPopup,
  onDeletePopup,
  isToolbar,
  onPaletteNodeClick,
}) => {
  // No asset upload handler here; handled in App

  const handleDragStart = (control: any, e: React.DragEvent) => {
    // For advanced controls, set a custom type for Canvas drop
    e.dataTransfer.setData("advanced-type", control.type);
    if (control.name) {
      e.dataTransfer.setData("advanced-name", control.name);
    }
    if (control.icon) {
      e.dataTransfer.setData("advanced-icon", control.icon);
    }
  };

  const handlePaletteClick = (control: any) => {
    onClickToPlace(control.type);
  };

  return (
    <aside className="sidebar-fixed">
      <div className="sidebar-scrollable" style={{ minHeight: 0, height: '100%' }}>
        <div className="sidebar-section">
          <h3>Palette</h3>
          <div className="palette-list" style={{ overflowY: 'auto', maxHeight: 300 }}>
            {palette.map((type) => (
              <div
                key={type}
                className="palette-item"
                draggable
                onDragStart={e => {
                  e.dataTransfer.setData("custom-node-type", type);
                  e.dataTransfer.effectAllowed = "copy";
                }}
              >
                <button onClick={() => onAddElement(type)}>{type}</button>
                <button className="click-to-place" onClick={() => onClickToPlace(type)} title="Click to place">🎯</button>
              </div>
            ))}
          </div>
        </div>
        <div className="sidebar-section">
          <h3>Assets</h3>
          {/* Asset upload handled in App, not Sidebar */}
          <div className="asset-list">
            {assets && assets.map(asset => (
              <div
                key={asset.id}
                draggable
                onDragStart={e => onAssetDrag && onAssetDrag(asset, e)}
                className="asset-thumb-container"
                title={asset.name}
              >
                <img src={asset.url} alt={asset.name} className="asset-thumb" />
                <div className="asset-label">{asset.name}</div>
              </div>
            ))}
          </div>
        </div>
        <div className="sidebar-section">
          <h3>Advanced Controls</h3>
          <div className="advanced-controls-list">
            {ADVANCED_CONTROLS.map(control => (
              <div
                key={control.type}
                draggable
                onDragStart={e => {
                  handleDragStart(control, e);
                  e.dataTransfer.effectAllowed = "copy";
                }}
                onClick={() => handlePaletteClick(control)}
                className={"advanced-control-item" + (pendingNodeType === control.type ? " selected" : "")}
                title={control.description}
              >
                <div className="advanced-control-icon">{control.icon}</div>
                <div className="advanced-control-label">{control.name}</div>
              </div>
            ))}
          </div>
        </div>
      </div>
    </aside>
  );
};

export default Sidebar;
import React, { useState } from "react";
const ADVANCED_CONTROLS = [
  {
    type: "checkboxgroup",
    name: "Checkbox Group",
    icon: "☑️",
    description: "A group of checkboxes.",
  },
  {
    type: "datepicker",
    name: "Date Picker",
    icon: "📅",
    description: "A date selection control.",
  },
  {
    type: "colorpicker",
    name: "Color Picker",
    icon: "🎨",
    description: "A color selection control.",
  },
  {
    type: "numericinput",
    name: "Numeric Input",
    icon: "🔢",
    description: "A numeric input field.",
  },
  {
    type: "stepper",
    name: "Stepper",
    icon: "➕",
    description: "A stepper for increment/decrement.",
  },
  {
    type: "avatar",
    name: "Avatar",
    icon: "👤",
    description: "A user avatar image.",
  },
  {
    type: "badge",
    name: "Badge",
    icon: "🏷️",
    description: "A badge or label indicator.",
  },
  {
    type: "tooltip",
    name: "Tooltip",
    icon: "💬",
    description: "A tooltip for hints/info.",
  },
  {
    type: "modal",
    name: "Modal",
    icon: "🪟",
    description: "A modal dialog box.",
  },
  {
    type: "searchbox",
    name: "Search Box",
    icon: "🔍",
    description: "A search input box.",
  },
  {
    type: "calendar",
    name: "Calendar",
    icon: "🗓️",
    description: "A calendar view.",
  },
  {
    type: "fileupload",
    name: "File Upload",
    icon: "📤",
    description: "A file upload control.",
  },
  {
    type: "rating",
    name: "Rating",
    icon: "⭐",
    description: "A star rating control.",
  },
  {
    type: "chip",
    name: "Chip",
    icon: "💠",
    description: "A small block for tags or actions.",
  },
  {
    type: "timeline",
    name: "Timeline",
    icon: "⏳",
    description: "A timeline of events.",
  },
];
      const handleFileChange = (e: React.ChangeEvent<HTMLInputElement>) => {
        if (e.target.files && e.target.files[0]) {
          onAssetAdd(e.target.files[0]);
        }
      }

