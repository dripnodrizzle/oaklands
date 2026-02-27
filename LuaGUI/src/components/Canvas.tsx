import React, { useRef, useEffect, useState } from "react";

interface Element {
  id: string;
  type: string;
  x: number;
  y: number;
  width: number;
  height: number;
  background: string;
  text?: string;
  font?: string;
  fontSize?: number;
  fontWeight?: string;
  fontStyle?: string;
  borderColor?: string;
  borderWidth?: number;
  borderStyle?: string;
  iconUrl?: string;
  imageUrl?: string;
  value?: number | string;
  parentId?: string | null;
}

interface CanvasProps {
  elements: Element[];
  setElements: React.Dispatch<React.SetStateAction<Element[]>>;
  onSelect: (el: Element | null, multi?: boolean) => void;
  selectedIds: string[];
  onAddElement: (type: string, x: number, y: number) => void;
  popupAttachMode: boolean;
  onAttachPopupStart: (id: string) => void;
  highlightedButtonId: string | null;
  assets: { id: string; url: string; name: string }[];
  pendingNodeType: string | null;
  setPendingNodeType: React.Dispatch<React.SetStateAction<string | null>>;
}

const HANDLE_SIZE = 10;
const GRID_SIZE = 10;

function snap(val: number) {
  return Math.round(val / GRID_SIZE) * GRID_SIZE;
}

const Canvas: React.FC<CanvasProps> = ({ elements, setElements, onSelect, selectedIds, onAddElement, popupAttachMode, onAttachPopupStart, highlightedButtonId, assets, pendingNodeType, setPendingNodeType }) => {
  const dragInfo = useRef<{ id: string; offsetX: number; offsetY: number } | null>(null);
  const resizeInfo = useRef<{ id: string; direction: string; startX: number; startY: number; startW: number; startH: number } | null>(null);
  const [zoom, setZoom] = useState(1);
  const [pan, setPan] = useState({ x: 0, y: 0 });
  const panInfo = useRef<{ startX: number; startY: number; startPanX: number; startPanY: number } | null>(null);
  const [contextMenu, setContextMenu] = useState<{ x: number; y: number; targetId?: string } | null>(null);
  const [selectBox, setSelectBox] = useState<null | { x1: number; y1: number; x2: number; y2: number }>(null);
  const groupMoveInfo = useRef<null | { startX: number; startY: number; ids: string[]; orig: { [id: string]: { x: number; y: number } } }>(null);

  useEffect(() => {
    const handleKeyDown = (e: KeyboardEvent) => {
      if (!selectedIds.length) return;
      let dx = 0, dy = 0;
      if (e.key === "ArrowLeft") dx = -GRID_SIZE;
      if (e.key === "ArrowRight") dx = GRID_SIZE;
      if (e.key === "ArrowUp") dy = -GRID_SIZE;
      if (e.key === "ArrowDown") dy = GRID_SIZE;
      if (dx !== 0 || dy !== 0) {
        setElements(prev => prev.map(el =>
          selectedIds.includes(el.id) ? { ...el, x: snap(el.x + dx), y: snap(el.y + dy) } : el
        ));
      }
    };
    window.addEventListener("keydown", handleKeyDown);
    return () => window.removeEventListener("keydown", handleKeyDown);
  }, [selectedIds, setElements]);

  const handleWheel = (e: React.WheelEvent) => {
    e.preventDefault();
    setZoom(z => Math.max(0.2, Math.min(3, z - e.deltaY * 0.001)));
  };

  const handlePanMouseDown = (e: React.MouseEvent) => {
    if (e.button !== 1) return; // Middle mouse
    panInfo.current = {
      startX: e.clientX,
      startY: e.clientY,
      startPanX: pan.x,
      startPanY: pan.y,
    };
    document.addEventListener("mousemove", handlePanMouseMove);
    document.addEventListener("mouseup", handlePanMouseUp);
  };

  const handlePanMouseMove = (e: MouseEvent) => {
    if (!panInfo.current) return;
    setPan({
      x: panInfo.current.startPanX + (e.clientX - panInfo.current.startX),
      y: panInfo.current.startPanY + (e.clientY - panInfo.current.startY),
    });
  };

  const handlePanMouseUp = () => {
    panInfo.current = null;
    document.removeEventListener("mousemove", handlePanMouseMove);
    document.removeEventListener("mouseup", handlePanMouseUp);
  };

  // Handle asset and advanced control drop
  const handleDrop = (e: React.DragEvent) => {
    e.preventDefault();
    const assetId = e.dataTransfer.getData("asset-id");
    const assetUrl = e.dataTransfer.getData("asset-url");
    const assetName = e.dataTransfer.getData("asset-name");
    const advType = e.dataTransfer.getData("advanced-type");
    const customType = e.dataTransfer.getData("custom-node-type");
    if (assetId && assetUrl) {
      const newElement = {
        id: Date.now() + Math.random() + "",
        type: "image",
        x: (e.nativeEvent.offsetX - pan.x) / zoom,
        y: (e.nativeEvent.offsetY - pan.y) / zoom,
        width: 64,
        height: 64,
        icon: assetUrl,
        text: assetName,
        backgroundColor: "#fff",
      };
      setElements(prev => [...prev, newElement]);
      return;
    }
    if (customType) {
      // For custom palette nodes
      if (typeof onAddElement === 'function') {
        onAddElement(customType, (e.nativeEvent.offsetX - pan.x) / zoom, (e.nativeEvent.offsetY - pan.y) / zoom);
      } else {
        const newElement = {
          id: Date.now() + Math.random() + "",
          type: customType,
          x: (e.nativeEvent.offsetX - pan.x) / zoom,
          y: (e.nativeEvent.offsetY - pan.y) / zoom,
          width: 120,
          height: 40,
          backgroundColor: "#e0e0e0",
          text: customType,
        };
        setElements(prev => [...prev, newElement]);
      }
      return;
    }
    if (advType) {
      let newElement;
      const x = (e.nativeEvent.offsetX - pan.x) / zoom;
      const y = (e.nativeEvent.offsetY - pan.y) / zoom;
      if (advType === "searchbox") {
        newElement = {
          id: Date.now() + Math.random() + "",
          type: "searchbox",
          x, y,
          width: 160,
          height: 36,
          backgroundColor: "#fff",
          value: "",
        };
      } else if (advType === "calendar") {
        newElement = {
          id: Date.now() + Math.random() + "",
          type: "calendar",
          x, y,
          width: 180,
          height: 140,
          backgroundColor: "#f5f5f5",
        };
      } else if (advType === "fileupload") {
        newElement = {
          id: Date.now() + Math.random() + "",
          type: "fileupload",
          x, y,
          width: 160,
          height: 36,
          backgroundColor: "#fff",
        };
      } else if (advType === "rating") {
        newElement = {
          id: Date.now() + Math.random() + "",
          type: "rating",
          x, y,
          width: 120,
          height: 36,
          backgroundColor: "#fff",
          value: 3,
          max: 5,
        };
      } else if (advType === "chip") {
        newElement = {
          id: Date.now() + Math.random() + "",
          type: "chip",
          x, y,
          width: 60,
          height: 28,
          backgroundColor: "#e0e0e0",
          label: "Chip",
        };
      } else if (advType === "timeline") {
        newElement = {
          id: Date.now() + Math.random() + "",
          type: "timeline",
          x, y,
          width: 180,
          height: 80,
          backgroundColor: "#f5f5f5",
          events: ["Start", "Progress", "Finish"],
        };
      } else if (advType === "carousel") {
        newElement = {
          id: Date.now() + Math.random() + "",
          type: "carousel",
          x, y,
          width: 180,
          height: 80,
          backgroundColor: "#f5f5f5",
          images: ["https://placehold.co/60x60", "https://placehold.co/60x60?2"],
          selected: 0,
        };
      } else if (advType === "accordion") {
        newElement = {
          id: Date.now() + Math.random() + "",
          type: "accordion",
          x, y,
          width: 180,
          height: 60,
          backgroundColor: "#f5f5f5",
          open: false,
          title: "Accordion Title",
          content: "Accordion content...",
        };
      } else if (advType === "breadcrumb") {
        newElement = {
          id: Date.now() + Math.random() + "",
          type: "breadcrumb",
          x, y,
          width: 160,
          height: 28,
          backgroundColor: "#fff",
          items: ["Home", "Section", "Page"],
        };
      } else if (advType === "spinner") {
        newElement = {
          id: Date.now() + Math.random() + "",
          type: "spinner",
          x, y,
          width: 36,
          height: 36,
          backgroundColor: "#fff",
        };
      } else if (advType === "divider") {
        newElement = {
          id: Date.now() + Math.random() + "",
          type: "divider",
          x, y,
          width: 160,
          height: 8,
          backgroundColor: "#ccc",
        };
      } else if (advType === "listgroup") {
        newElement = {
          id: Date.now() + Math.random() + "",
          type: "listgroup",
          x, y,
          width: 120,
          height: 80,
          backgroundColor: "#fff",
          items: ["List 1", "List 2", "List 3"],
        };
      } else if (advType === "treeview") {
        newElement = {
          id: Date.now() + Math.random() + "",
          type: "treeview",
          x, y,
          width: 140,
          height: 100,
          backgroundColor: "#f5f5f5",
          nodes: [{ label: "Root", children: [{ label: "Child 1" }, { label: "Child 2" }] }],
        };
      } else if (advType === "notification") {
        newElement = {
          id: Date.now() + Math.random() + "",
          type: "notification",
          x, y,
          width: 180,
          height: 48,
          backgroundColor: "#fffbe7",
          text: "Notification message!",
        };
      } else if (advType === "popover") {
        newElement = {
          id: Date.now() + Math.random() + "",
          type: "popover",
          x, y,
          width: 120,
          height: 36,
          backgroundColor: "#fff",
          text: "Popover info",
        };
      } else if (advType === "collapse") {
        newElement = {
          id: Date.now() + Math.random() + "",
          type: "collapse",
          x, y,
          width: 160,
          height: 40,
          backgroundColor: "#f5f5f5",
          open: false,
          title: "Collapse Title",
          content: "Collapsed content...",
        };
      } else if (advType === "tag") {
        newElement = {
          id: Date.now() + Math.random() + "",
          type: "tag",
          x, y,
          width: 60,
          height: 28,
          backgroundColor: "#e0e0e0",
          label: "Tag",
        };
      } else if (advType === "pagination") {
        newElement = {
          id: Date.now() + Math.random() + "",
          type: "pagination",
          x, y,
          width: 120,
          height: 36,
          backgroundColor: "#fff",
          page: 1,
          total: 5,
        };
      } else if (advType === "menu") {
        newElement = {
          id: Date.now() + Math.random() + "",
          type: "menu",
          x, y,
          width: 120,
          height: 80,
          backgroundColor: "#fff",
          items: ["Menu 1", "Menu 2", "Menu 3"],
        };
      } else if (advType === "appbar") {
        newElement = {
          id: Date.now() + Math.random() + "",
          type: "appbar",
          x, y,
          width: 200,
          height: 40,
          backgroundColor: "#1976d2",
          title: "App Bar",
        };
      } else if (advType === "drawer") {
        newElement = {
          id: Date.now() + Math.random() + "",
          type: "drawer",
          x, y,
          width: 120,
          height: 180,
          backgroundColor: "#f5f5f5",
          open: false,
          items: ["Drawer 1", "Drawer 2", "Drawer 3"],
        };
      }
      if (newElement) setElements(prev => [...prev, newElement]);
      setPendingNodeType(null);
      return;
    }
    // ...existing drop logic...
  };

  const handleDragOver = (e: React.DragEvent) => {
    e.preventDefault();
  };

  const handleElementClick = (el: Element, e: React.MouseEvent) => {
    onSelect(el, e.ctrlKey || e.shiftKey);
  };

  const handleMouseDown = (e: React.MouseEvent, el: Element) => {
    dragInfo.current = {
      id: el.id,
      offsetX: e.clientX - el.x,
      offsetY: e.clientY - el.y,
    };
    document.addEventListener("mousemove", handleMouseMove);
    document.addEventListener("mouseup", handleMouseUp);
  };

  const handleMouseMove = (e: MouseEvent) => {
    if (dragInfo.current) {
      setElements((prev) =>
        prev.map((el) =>
          el.id === dragInfo.current!.id
            ? { ...el, x: snap(e.clientX - dragInfo.current!.offsetX), y: snap(e.clientY - dragInfo.current!.offsetY) }
            : el
        )
      );
    } else if (resizeInfo.current) {
      setElements((prev) =>
        prev.map((el) => {
          if (el.id !== resizeInfo.current!.id) return el;
          let { startX, startY, startW, startH, direction } = resizeInfo.current!;
          let dx = e.clientX - startX;
          let dy = e.clientY - startY;
          let newW = startW;
          let newH = startH;
          let newX = el.x;
          let newY = el.y;
          if (direction === "right") newW = snap(Math.max(20, startW + dx));
          if (direction === "bottom") newH = snap(Math.max(20, startH + dy));
          if (direction === "left") {
            newW = snap(Math.max(20, startW - dx));
            newX = snap(startX + dx);
          }
          if (direction === "top") {
            newH = snap(Math.max(20, startH - dy));
            newY = snap(startY + dy);
          }
          return { ...el, width: newW, height: newH, x: newX, y: newY };
        })
      );
    }
  };

  const handleMouseUp = () => {
    dragInfo.current = null;
    resizeInfo.current = null;
    document.removeEventListener("mousemove", handleMouseMove);
    document.removeEventListener("mouseup", handleMouseUp);
  };

  const handleResizeMouseDown = (e: React.MouseEvent, el: Element, direction: string) => {
    e.stopPropagation();
    resizeInfo.current = {
      id: el.id,
      direction,
      startX: e.clientX,
      startY: e.clientY,
      startW: el.width,
      startH: el.height,
    };
    document.addEventListener("mousemove", handleMouseMove);
    document.addEventListener("mouseup", handleMouseUp);
  };

  const handleContextMenu = (e: React.MouseEvent, id?: string) => {
    e.preventDefault();
    const el = elements.find(el => el.id === id);
    if (el && el.type === "button") {
      setHighlightedButtonId(id!);
      if (onAttachPopupStart) onAttachPopupStart(id!);
    }
    setContextMenu({ x: e.clientX, y: e.clientY, targetId: id });
    if (id) onSelect([id]);
  };

  const handleMenuAction = (action: string) => {
    if (!contextMenu) return;
    const { targetId } = contextMenu;
    if (action === "delete" && targetId) {
      setElements(prev => prev.filter(el => el.id !== targetId));
      setContextMenu(null);
    } else if (action === "copy" && targetId) {
      // ...existing copy logic...
      setContextMenu(null);
    } else if (action === "paste") {
      // ...existing paste logic...
      setContextMenu(null);
    } else if (action === "bringToFront" && targetId) {
      setElements(prev => {
        const idx = prev.findIndex(el => el.id === targetId);
        if (idx === -1) return prev;
        const el = prev[idx];
        const newArr = prev.slice(0, idx).concat(prev.slice(idx + 1)).concat([el]);
        return newArr;
      });
      setContextMenu(null);
    } else if (action === "sendToBack" && targetId) {
      setElements(prev => {
        const idx = prev.findIndex(el => el.id === targetId);
        if (idx === -1) return prev;
        const el = prev[idx];
        const newArr = [el].concat(prev.slice(0, idx)).concat(prev.slice(idx + 1));
        return newArr;
      });
      setContextMenu(null);
    } else {
      setContextMenu(null);
    }
  };

  useEffect(() => {
    const handleClick = () => setContextMenu(null);
    if (contextMenu) document.addEventListener("mousedown", handleClick);
    return () => document.removeEventListener("mousedown", handleClick);
  }, [contextMenu]);

  // Bounding box selection handlers
  const handleCanvasMouseDown = (e: React.MouseEvent) => {
    if (e.button !== 0 || e.ctrlKey || e.altKey || e.metaKey) return;
    // Only start select box if not clicking on element
    if ((e.target as HTMLElement).classList.contains("canvas")) {
      setSelectBox({ x1: e.nativeEvent.offsetX, y1: e.nativeEvent.offsetY, x2: e.nativeEvent.offsetX, y2: e.nativeEvent.offsetY });
    }
  };

  const handleCanvasMouseMove = (e: React.MouseEvent) => {
    if (selectBox) {
      setSelectBox(box => box && { ...box, x2: e.nativeEvent.offsetX, y2: e.nativeEvent.offsetY });
    }
  };

  const handleCanvasMouseUp = () => {
    if (selectBox) {
      const { x1, y1, x2, y2 } = selectBox;
      const minX = Math.min(x1, x2), maxX = Math.max(x1, x2);
      const minY = Math.min(y1, y2), maxY = Math.max(y1, y2);
      const selected = elements.filter(el =>
        el.x + el.width > minX && el.x < maxX && el.y + el.height > minY && el.y < maxY
      ).map(el => el.id);
      onSelect(selected);
      setSelectBox(null);
    }
  };

  // Group move handlers
  const handleGroupMoveStart = (e: React.MouseEvent) => {
    if (selectedIds.length > 1 && (e.target as HTMLElement).classList.contains("canvas")) {
      groupMoveInfo.current = {
        startX: e.clientX,
        startY: e.clientY,
        ids: selectedIds,
        orig: Object.fromEntries(selectedIds.map(id => {
          const el = elements.find(e => e.id === id)!;
          return [id, { x: el.x, y: el.y }];
        }))
      };
      document.addEventListener("mousemove", handleGroupMove);
      document.addEventListener("mouseup", handleGroupMoveEnd);
    }
  };

  const handleGroupMove = (e: MouseEvent) => {
    if (!groupMoveInfo.current) return;
    const dx = snap(e.clientX - groupMoveInfo.current.startX);
    const dy = snap(e.clientY - groupMoveInfo.current.startY);
    setElements(prev => prev.map(el =>
      groupMoveInfo.current!.ids.includes(el.id)
        ? { ...el, x: snap(groupMoveInfo.current!.orig[el.id].x + dx), y: snap(groupMoveInfo.current!.orig[el.id].y + dy) }
        : el
    ));
  };

  const handleGroupMoveEnd = () => {
    groupMoveInfo.current = null;
    document.removeEventListener("mousemove", handleGroupMove);
    document.removeEventListener("mouseup", handleGroupMoveEnd);
  };

  // Click-to-place for palette nodes
  const handleCanvasClick = (e: React.MouseEvent) => {
    if (pendingNodeType) {
      // Place new node at click position
      const rect = (e.target as HTMLElement).getBoundingClientRect();
      const x = (e.clientX - rect.left - pan.x) / zoom;
      const y = (e.clientY - rect.top - pan.y) / zoom;
      onAddElement(pendingNodeType, snap(x), snap(y));
      setPendingNodeType(null);
      e.stopPropagation();
      return;
    }
    // ...existing click logic if needed...
  };
  function renderAdvancedElement(el) {
    if (el.type === "scrollbox") {
      return (
        <div style={{ width: "100%", height: "100%", overflow: "auto", background: el.backgroundColor, borderRadius: 4, border: "1px solid #bbb", padding: 4 }}>
          <div style={{ minHeight: 180 }}>
            <div style={{ color: "#888", fontSize: 12 }}>ScrollBox (drag items here)</div>
            {/* Could render children here */}
          </div>
        </div>
      );
    }
    if (el.type === "dynamiclist") {
      return (
        <div style={{ width: "100%", height: "100%", background: el.backgroundColor, borderRadius: 4, border: "1px solid #bbb", padding: 4, overflowY: "auto" }}>
          <div style={{ fontWeight: 600, fontSize: 13, marginBottom: 4 }}>Inventory</div>
          <ul style={{ margin: 0, padding: 0, listStyle: "none" }}>
            {el.items.map(item => (
              <li key={item.id} style={{ padding: "2px 0", fontSize: 12 }}>{item.label}</li>
            ))}
          </ul>
          <button style={{ fontSize: 11, marginTop: 4 }} onClick={e => { e.stopPropagation(); setElements(prev => prev.map(e2 => e2.id === el.id ? { ...e2, items: [...e2.items, { id: Date.now() + "", label: `Item ${e2.items.length + 1}` }] } : e2)); }}>Add Item</button>
        </div>
      );
    }
    if (el.type === "purchasable") {
      return (
        <div style={{ width: "100%", height: "100%", background: el.backgroundColor, borderRadius: 4, border: "1px solid #bbb", display: "flex", flexDirection: "column", alignItems: "center", justifyContent: "center" }}>
          <div style={{ fontWeight: 600, fontSize: 14, marginBottom: 2 }}>{el.label}</div>
          <div style={{ fontSize: 12, color: "#888" }}>{el.price} {el.currency}</div>
          <button style={{ fontSize: 12, marginTop: 4, background: "#ffe082", border: "1px solid #e0b800", borderRadius: 4, padding: "2px 10px" }}>Purchase</button>
        </div>
      );
    }
    if (el.type === "slider") {
      return (
        <div style={{ width: "100%", height: "100%", display: "flex", alignItems: "center", justifyContent: "center", gap: 8 }}>
          <span style={{ fontSize: 12, color: "#888" }}>Slider</span>
          <input
            type="range"
            min={el.min}
            max={el.max}
            value={el.value}
            style={{ flex: 1 }}
            onChange={e => setElements(prev => prev.map(e2 => e2.id === el.id ? { ...e2, value: Number(e.target.value) } : e2))}
          />
          <span style={{ fontSize: 12 }}>{el.value}</span>
        </div>
      );
    }
    if (el.type === "toggle") {
      return (
        <div style={{ width: "100%", height: "100%", display: "flex", alignItems: "center", justifyContent: "center", gap: 8 }}>
          <span style={{ fontSize: 12, color: "#888" }}>Toggle</span>
          <input
            type="checkbox"
            checked={el.checked}
            onChange={e => setElements(prev => prev.map(e2 => e2.id === el.id ? { ...e2, checked: e.target.checked } : e2))}
          />
        </div>
      );
    }
    if (el.type === "dropdown") {
      return (
        <div style={{ width: "100%", height: "100%", display: "flex", alignItems: "center", justifyContent: "center", gap: 8 }}>
          <span style={{ fontSize: 12, color: "#888" }}>Dropdown</span>
          <select
            value={el.selected}
            onChange={e => setElements(prev => prev.map(e2 => e2.id === el.id ? { ...e2, selected: Number(e.target.value) } : e2))}
            style={{ fontSize: 12 }}
          >
            {el.options.map((opt, idx) => (
              <option key={idx} value={idx}>{opt}</option>
            ))}
          </select>
        </div>
      );
    }
    if (el.type === "progressbar") {
      return (
        <div style={{ width: "100%", height: "100%", background: el.backgroundColor, borderRadius: 4, border: "1px solid #bbb", display: "flex", alignItems: "center", padding: 2 }}>
          <div style={{ width: `${(el.value / el.max) * 100}%`, height: "100%", background: "#4caf50", borderRadius: 4, transition: "width 0.2s" }} />
          <span style={{ fontSize: 12, marginLeft: 8 }}>{el.value} / {el.max}</span>
        </div>
      );
    }
    if (el.type === "tabview") {
      return (
        <div style={{ width: "100%", height: "100%", background: el.backgroundColor, borderRadius: 4, border: "1px solid #bbb", display: "flex", flexDirection: "column" }}>
          <div style={{ display: "flex", borderBottom: "1px solid #ccc" }}>
            {el.tabs.map((tab, idx) => (
              <button
                key={tab}
                style={{
                  flex: 1,
                  background: el.selected === idx ? "#e3e3e3" : "#f5f5f5",
                  border: "none",
                  borderBottom: el.selected === idx ? "2px solid #0078d4" : "2px solid transparent",
                  fontWeight: el.selected === idx ? 600 : 400,
                  fontSize: 12,
                  padding: 4,
                  cursor: "pointer",
                }}
                onClick={e => { e.stopPropagation(); setElements(prev => prev.map(e2 => e2.id === el.id ? { ...e2, selected: idx } : e2)); }}
              >
                {tab}
              </button>
            ))}
          </div>
          <div style={{ flex: 1, padding: 8, fontSize: 12, color: "#888" }}>
            Tab Content: {el.tabs[el.selected]}
          </div>
        </div>
      );
    }
    if (el.type === "radiogroup") {
      return (
        <div style={{ width: "100%", height: "100%", display: "flex", flexDirection: "column", justifyContent: "center", gap: 2 }}>
          {el.options.map((opt, idx) => (
            <label key={idx} style={{ fontSize: 12 }}>
              <input
                type="radio"
                name={el.id}
                checked={el.selected === idx}
                onChange={() => setElements(prev => prev.map(e2 => e2.id === el.id ? { ...e2, selected: idx } : e2))}
              /> {opt}
            </label>
          ))}
        </div>
      );
    }
    if (el.type === "checkboxgroup") {
      return (
        <div style={{ width: "100%", height: "100%", display: "flex", flexDirection: "column", justifyContent: "center", gap: 2 }}>
          {el.options.map((opt, idx) => (
            <label key={idx} style={{ fontSize: 12 }}>
              <input
                type="checkbox"
                checked={el.checked[idx]}
                onChange={() => setElements(prev => prev.map(e2 => e2.id === el.id ? { ...e2, checked: e2.checked.map((c, i) => i === idx ? !c : c) } : e2))}
              /> {opt}
            </label>
          ))}
        </div>
      );
    }
    if (el.type === "datepicker") {
      return (
        <div style={{ width: "100%", height: "100%", display: "flex", alignItems: "center", justifyContent: "center" }}>
          <input
            type="date"
            value={el.value}
            onChange={e => setElements(prev => prev.map(e2 => e2.id === el.id ? { ...e2, value: e.target.value } : e2))}
            style={{ fontSize: 12 }}
          />
        </div>
      );
    }
    if (el.type === "colorpicker") {
      return (
        <div style={{ width: "100%", height: "100%", display: "flex", alignItems: "center", justifyContent: "center" }}>
          <input
            type="color"
            value={el.value}
            onChange={e => setElements(prev => prev.map(e2 => e2.id === el.id ? { ...e2, value: e.target.value } : e2))}
            style={{ width: 32, height: 24, border: "none", background: "none" }}
          />
        </div>
      );
    }
    if (el.type === "numericinput") {
      return (
        <div style={{ width: "100%", height: "100%", display: "flex", alignItems: "center", justifyContent: "center" }}>
          <input
            type="number"
            value={el.value}
            onChange={e => setElements(prev => prev.map(e2 => e2.id === el.id ? { ...e2, value: Number(e.target.value) } : e2))}
            style={{ fontSize: 12, width: 48 }}
          />
        </div>
      );
    }
    if (el.type === "stepper") {
      return (
        <div style={{ width: "100%", height: "100%", display: "flex", alignItems: "center", justifyContent: "center", gap: 4 }}>
          <button style={{ fontSize: 14, width: 24 }} onClick={e => { e.stopPropagation(); setElements(prev => prev.map(e2 => e2.id === el.id ? { ...e2, value: e2.value - 1 } : e2)); }}>-</button>
          <span style={{ fontSize: 13 }}>{el.value}</span>
          <button style={{ fontSize: 14, width: 24 }} onClick={e => { e.stopPropagation(); setElements(prev => prev.map(e2 => e2.id === el.id ? { ...e2, value: e2.value + 1 } : e2)); }}>+</button>
        </div>
      );
    }
    if (el.type === "avatar") {
      return (
        <div style={{ width: "100%", height: "100%", display: "flex", alignItems: "center", justifyContent: "center" }}>
          <img src={el.url} alt="avatar" style={{ width: 40, height: 40, borderRadius: "50%" }} />
        </div>
      );
    }
    if (el.type === "badge") {
      return (
        <div style={{ width: "100%", height: "100%", background: el.backgroundColor, borderRadius: 12, display: "flex", alignItems: "center", justifyContent: "center", fontSize: 13, fontWeight: 600, color: "#333" }}>
          {el.label}
        </div>
      );
    }
    if (el.type === "tooltip") {
      const [showTooltip, setShowTooltip] = React.useState(true);
      return (
        <div
          style={{ width: "100%", height: "100%", display: "flex", alignItems: "center", justifyContent: "center", position: "relative" }}
          onMouseMove={() => setShowTooltip(false)}
          onClick={() => setShowTooltip(false)}
        >
          <span style={{ fontSize: 12, color: "#888" }}>Hover me</span>
          {showTooltip && (
            <div style={{ position: "absolute", bottom: "110%", left: "50%", transform: "translateX(-50%)", background: "#222", color: "#fff", padding: "4px 8px", borderRadius: 4, fontSize: 11, whiteSpace: "nowrap", opacity: 0.9, pointerEvents: "none" }}>{el.text}</div>
          )}
        </div>
      );
    }
    if (el.type === "modal") {
      return (
        <div style={{ width: "100%", height: "100%", background: el.backgroundColor, borderRadius: 8, border: "1px solid #bbb", display: "flex", flexDirection: "column", alignItems: "center", justifyContent: "center" }}>
          <div style={{ fontWeight: 600, fontSize: 15, marginBottom: 6 }}>{el.title}</div>
          <div style={{ fontSize: 13, color: "#555" }}>{el.content}</div>
        </div>
      );
    }
    return null;
  }

  return (
    <main
      className="canvas"
      onDrop={handleDrop}
      onDragOver={handleDragOver}
      onClick={handleCanvasClick}
      onWheel={handleWheel}
      onMouseDown={e => { handlePanMouseDown(e); handleCanvasMouseDown(e); handleGroupMoveStart(e); }}
      onMouseMove={handleCanvasMouseMove}
      onMouseUp={handleCanvasMouseUp}
      onContextMenu={e => handleContextMenu(e)}
      style={{ overflow: "hidden", position: "relative" }}
    >
      <div
        style={{
          transform: `translate(${pan.x}px, ${pan.y}px) scale(${zoom})`,
          transformOrigin: "0 0",
          width: "100%",
          height: "100%",
          position: "relative",
        }}
      >
        {elements.map((el) => (
          <div
            key={el.id}
            style={{
              position: "absolute",
              left: el.x,
              top: el.y,
              width: el.width,
              height: el.height,
              border: highlightedButtonId === el.id ? "2.5px solid #ff9800" : selectedIds.includes(el.id) ? "2px solid #0078d4" : "1px solid #aaa",
              background: el.backgroundColor || "#fff",
              zIndex: 2,
              boxShadow: highlightedButtonId === el.id ? "0 0 8px 2px #ff980088" : undefined,
              overflow: "hidden",
              display: "flex",
              alignItems: "center",
              justifyContent: "center",
            }}
            onContextMenu={e => handleContextMenu(e, el.id)}
            title={el.type === "button" ? "Right-click to attach popup" : undefined}
          >
            {renderAdvancedElement(el)}
          </div>
        ))}
        {selectBox && (
          <div
            style={{
              position: "absolute",
              left: Math.min(selectBox.x1, selectBox.x2),
              top: Math.min(selectBox.y1, selectBox.y2),
              width: Math.abs(selectBox.x2 - selectBox.x1),
              height: Math.abs(selectBox.y2 - selectBox.y1),
              border: "1.5px dashed #0078d4",
              background: "rgba(0,120,212,0.08)",
              pointerEvents: "none",
              zIndex: 10,
            }}
          />
        )}
        <div className="canvas-placeholder">Drag components here</div>
      </div>
      <div style={{ position: "absolute", top: 8, left: 8, background: "#fff", borderRadius: 4, padding: 4, fontSize: "0.9em", zIndex: 10 }}>
        Zoom: {Math.round(zoom * 100)}% | Pan: ({pan.x}, {pan.y})<br />
        (Mouse wheel to zoom, middle mouse to pan)
      </div>
      {contextMenu && (
        <ul
          style={{
            position: "absolute",
            top: contextMenu.y,
            left: contextMenu.x,
            background: "#fff",
            border: "1px solid #ccc",
            borderRadius: 4,
            boxShadow: "0 2px 8px rgba(0,0,0,0.15)",
            padding: 0,
            margin: 0,
            zIndex: 100,
            listStyle: "none",
            minWidth: 120,
          }}
        >
          {contextMenu.targetId && (
            <>
              <li style={{ padding: "8px", cursor: "pointer" }} onClick={() => handleMenuAction("delete")}>Delete</li>
              <li style={{ padding: "8px", cursor: "pointer" }} onClick={() => handleMenuAction("copy")}>Copy</li>
              <li style={{ padding: "8px", cursor: "pointer" }} onClick={() => handleMenuAction("bringToFront")}>Bring to Front</li>
              <li style={{ padding: "8px", cursor: "pointer" }} onClick={() => handleMenuAction("sendToBack")}>Send to Back</li>
            </>
          )}
          <li style={{ padding: "8px", cursor: "pointer" }} onClick={() => handleMenuAction("paste")}>Paste</li>
        </ul>
      )}
      {popupAttachMode && highlightedButtonId && (
        <div style={{ position: "fixed", top: 80, left: 80, background: "#fffbe7", border: "2px solid #ff9800", borderRadius: 8, padding: 16, zIndex: 200, boxShadow: "0 2px 12px #ff980033" }}>
          <b>Attach Popup:</b> Select a popup from the list to bind to this button.<br />
          <span style={{ color: "#ff9800" }}>Button highlighted. Choose popup at right.</span>
        </div>
      )}
    </main>
  );
};

export default Canvas;
