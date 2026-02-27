import React, { useState, useEffect, useRef } from "react";
import Sidebar from "./components/Sidebar";
import Canvas from "./components/Canvas";
import PropertyEditor from "./components/PropertyEditor";
import HierarchyTree from "./components/HierarchyTree";
import ExportButton from "./components/ExportButton";
import NotificationBox from "./components/NotificationBox";
import "./App.css";

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

const defaultProps = {
  width: 120,
  height: 40,
  background: "#e0e0e0",
  text: "",
  font: "Arial",
  fontSize: 16,
  fontWeight: "normal",
  fontStyle: "normal",
  borderColor: "#888",
  borderWidth: 1,
  borderStyle: "solid",
  iconUrl: "",
  imageUrl: "",
  value: "",
  parentId: null,
};

function deepCopyHierarchy(elements: Element[], selectedIds: string[]): Element[] {
  const toCopy = new Set(selectedIds);
  // Add all children recursively
  let added = true;
  while (added) {
    added = false;
    elements.forEach(el => {
      if (el.parentId && toCopy.has(el.parentId) && !toCopy.has(el.id)) {
        toCopy.add(el.id);
        added = true;
      }
    });
  }
  // Copy with new IDs and offset
  const idMap: Record<string, string> = {};
  const now = Date.now();
  const copied = elements.filter(el => toCopy.has(el.id)).map(el => {
    const newId = `${el.type}-copy-${now}-${el.id}`;
    idMap[el.id] = newId;
    return {
      ...el,
      id: newId,
      x: el.x + 20,
      y: el.y + 20,
      parentId: el.parentId ? idMap[el.parentId] || null : null,
    };
  });
  return copied;
}

const ONBOARDING_TIPS = [
  "Drag components from the sidebar onto the canvas to build your GUI.",
  "Click elements to select and edit their properties.",
  "Use Ctrl/Shift to multi-select, and drag a box to group select.",
  "Right-click elements for context actions like copy, delete, or attach popups.",
  "Save groups as reusable drag-and-drop nodes or popups.",
  "Upload images/icons in the Assets section and drag them onto the canvas.",
  "Use the Export button to generate Roblox Lua code for your GUI.",
  "Zoom with mouse wheel, pan with middle mouse drag.",
  "Undo/redo with Ctrl+Z / Ctrl+Y, and use keyboard shortcuts for efficiency.",
];

function App() {
  const [elements, setElements] = useState<Element[]>([]);
  const [selectedElement, setSelectedElement] = useState<Element | null>(null);
  const [selectedIds, setSelectedIds] = useState<string[]>([]);
  const history = useRef<Element[][]>([]);
  const future = useRef<Element[][]>([]);
  const clipboard = useRef<Element[]>([]);
  const [savedNodes, setSavedNodes] = useState<Array<{ id: string; name: string; elements: any[] }>>([]);
  const [popups, setPopups] = useState<Array<{ id: string; name: string; elements: any[] }>>([]);
  const [popupAttachMode, setPopupAttachMode] = useState<{ buttonId: string | null } | null>(null);
  const [buttonPopupBindings, setButtonPopupBindings] = useState<{ [buttonId: string]: string }>( {} );

  React.useEffect(() => {
    const handleKeyDown = (e: KeyboardEvent) => {
      if (e.ctrlKey && e.key === "z") {
        handleUndo();
      } else if (e.ctrlKey && e.key === "y") {
        handleRedo();
      } else if (e.ctrlKey && e.key === "c") {
        handleCopy();
      } else if (e.ctrlKey && e.key === "v") {
        handlePaste();
      }
    };
    window.addEventListener("keydown", handleKeyDown);
    return () => window.removeEventListener("keydown", handleKeyDown);
  }, [elements, selectedIds]);

  const pushHistory = (newElements: Element[]) => {
    history.current.push([...elements]);
    setElements(newElements);
    future.current = [];
  };

  const handleSelect = (el: Element | null, multi = false) => {
    if (!el) {
      setSelectedElement(null);
      setSelectedIds([]);
      return;
    }
    setSelectedElement(el);
    if (multi) {
      setSelectedIds((prev) => prev.includes(el.id) ? prev : [...prev, el.id]);
    } else {
      setSelectedIds([el.id]);
    }
  };

  const handleUpdate = (updated: Element) => {
    pushHistory(elements.map((el) => (el.id === updated.id ? updated : el)));
    setSelectedElement(updated);
  };

  const handleAddElement = (type: string, x: number, y: number) => {
    const newElement: Element = {
      id: `${type}-${Date.now()}`,
      type,
      x,
      y,
      ...defaultProps,
      text: type === "TextLabel" ? "Sample Text" : "",
      value: type === "Slider" ? 50 : "",
    };
    pushHistory([...elements, newElement]);
    handleSelect(newElement);
  };

  const handleDelete = () => {
    pushHistory(elements.filter((el) => !selectedIds.includes(el.id)));
    setSelectedElement(null);
    setSelectedIds([]);
  };

  const handleUndo = () => {
    if (history.current.length > 0) {
      future.current.push([...elements]);
      const prev = history.current.pop();
      setElements(prev || []);
    }
  };

  const handleRedo = () => {
    if (future.current.length > 0) {
      history.current.push([...elements]);
      const next = future.current.pop();
      setElements(next || []);
    }
  };

  const handleCopy = () => {
    clipboard.current = deepCopyHierarchy(elements, selectedIds);
  };

  const handlePaste = () => {
    if (clipboard.current.length > 0) {
      pushHistory([...elements, ...clipboard.current]);
      setSelectedIds(clipboard.current.map(el => el.id));
      setSelectedElement(clipboard.current[0] || null);
    }
  };

  const handleSaveNode = () => {
    if (!selectedIds.length) return;
    const nodeElements = elements.filter(el => selectedIds.includes(el.id)).map(el => ({ ...el }));
    const name = prompt("Name for saved node?") || `Node ${savedNodes.length + 1}`;
    setSavedNodes(prev => [...prev, { id: Date.now() + "", name, elements: nodeElements }]);
  };

  const handleDeleteNode = (id: string) => {
    setSavedNodes(prev => prev.filter(n => n.id !== id));
  };

  const handleAddNode = (nodeElements: any[]) => {
    // Offset new elements to avoid overlap
    const offset = 40;
    const newElements = nodeElements.map(el => ({ ...el, id: Date.now() + Math.random() + "", x: el.x + offset, y: el.y + offset }));
    setElements(prev => [...prev, ...newElements]);
  };

  const handleSavePopup = () => {
    if (!selectedIds.length) return;
    const popupElements = elements.filter(el => selectedIds.includes(el.id)).map(el => ({ ...el }));
    const name = prompt("Name for popup?") || `Popup ${popups.length + 1}`;
    setPopups(prev => [...prev, { id: Date.now() + "", name, elements: popupElements }]);
  };

  // Delete popup
  const handleDeletePopup = (id: string) => {
    setPopups(prev => prev.filter(p => p.id !== id));
  };

  // Attach popup to button
  const handleAttachPopupStart = (buttonId: string) => {
    setPopupAttachMode({ buttonId });
    setHighlightedButtonId(buttonId);
  };

  // Attach popup to button with notification box
  const handleAttachPopupFinish = (popupId: string) => {
    if (!popupAttachMode?.buttonId) return;
    setNotification({
      message: "Bind this popup to the selected button?",
      onConfirm: () => {
        setButtonPopupBindings(prev => ({ ...prev, [popupAttachMode!.buttonId as string]: popupId }));
        setPopupAttachMode(null);
        setHighlightedButtonId(null);
        setNotification({ message: "Popup attached to button!" });
      },
      onCancel: () => {
        setPopupAttachMode(null);
        setHighlightedButtonId(null);
        setNotification(null);
      },
    });
  };

  // Show popup when button is clicked
  const [activePopup, setActivePopup] = useState<{ popupId: string; x: number; y: number } | null>(null);
  const handleButtonClick = (buttonId: string, x: number, y: number) => {
    const popupId = buttonPopupBindings[buttonId];
    if (popupId) setActivePopup({ popupId, x, y });
  };

  const [highlightedButtonId, setHighlightedButtonId] = useState<string | null>(null);

  const [notification, setNotification] = useState<null | { message: string; onConfirm?: () => void; onCancel?: () => void }>(null);

  const handleAddPopup = (popupElements: any[]) => {
    const offset = 40;
    const newElements = popupElements.map(el => ({ ...el, id: Date.now() + Math.random() + "", x: el.x + offset, y: el.y + offset }));
    setElements(prev => [...prev, ...newElements]);
  };

  const [assets, setAssets] = useState<Array<{ id: string; name: string; url: string }>>([]);

  // Upload asset
  const handleUploadAsset = (file: File) => {
    const reader = new FileReader();
    reader.onload = e => {
      setAssets(prev => [
        ...prev,
        { id: Date.now() + Math.random() + "", name: file.name, url: e.target?.result as string },
      ]);
    };
    reader.readAsDataURL(file);
  };

  // Rename asset
  const handleRenameAsset = (id: string, newName: string) => {
    setAssets(prev => prev.map(a => a.id === id ? { ...a, name: newName } : a));
  };

  // Delete asset
  const handleDeleteAsset = (id: string) => {
    setAssets(prev => prev.filter(a => a.id !== id));
  };

  // Handle asset drag and drop
  const handleAssetDrag = (asset: { id: string; name: string; url: string }, e: React.DragEvent) => {
    e.dataTransfer.setData("asset-id", asset.id);
    e.dataTransfer.setData("asset-url", asset.url);
    e.dataTransfer.setData("asset-name", asset.name);
  };

  const [showOnboarding, setShowOnboarding] = useState(false);

  useEffect(() => {
    if (!localStorage.getItem("luagui-onboarded")) {
      setShowOnboarding(true);
      localStorage.setItem("luagui-onboarded", "1");
    }
  }, []);

  const [pendingNodeType, setPendingNodeType] = useState<string | null>(null);

  return (
    <div className="app">
      <div className="menubar">
        <span style={{ marginRight: 32, fontWeight: 700, fontSize: "1.15em", letterSpacing: 1 }}>LuaGUI</span>
        <span style={{ marginRight: 24, cursor: "pointer" }}>File</span>
        <span style={{ marginRight: 24, cursor: "pointer" }}>Edit</span>
        <span style={{ marginRight: 24, cursor: "pointer" }}>View</span>
        <span style={{ marginRight: 24, cursor: "pointer" }}>Window</span>
        <span style={{ marginRight: 24, cursor: "pointer" }}>Help</span>
      </div>
      <div className="main-layout">
        <div className="toolbar">
          {/* Render palette as vertical toolbar icons */}
          <Sidebar
            savedNodes={savedNodes}
            onSaveNode={handleSaveNode}
            onDeleteNode={handleDeleteNode}
            popups={popups}
            onAddPopup={handleAddPopup}
            onDeletePopup={handleDeletePopup}
            assets={assets}
            onAssetDrag={handleAssetDrag}
            onPaletteNodeClick={setPendingNodeType}
            pendingNodeType={pendingNodeType}
            isToolbar
          />
        </div>
        <div className="canvas-area">
          <Canvas
            elements={elements}
            setElements={setElements}
            onSelect={handleSelect}
            selectedIds={selectedIds}
            onAddElement={handleAddElement}
            popupAttachMode={!!popupAttachMode}
            onAttachPopupStart={handleAttachPopupStart}
            highlightedButtonId={highlightedButtonId}
            assets={assets}
            pendingNodeType={pendingNodeType}
            setPendingNodeType={setPendingNodeType}
          />
        </div>
        <div className="right-panel">
          <div className="panel-section">
            {/* Property editor goes here */}
            <PropertyEditor element={selectedElement} onUpdate={handleUpdate} />
          </div>
          <div className="panel-section">
            {/* Hierarchy/layers tree goes here */}
            <HierarchyTree
              elements={elements}
              setElements={setElements as React.Dispatch<React.SetStateAction<any[]>>}
              onSelect={(el) => handleSelect(el as any, false)}
              selectedId={selectedIds[0] || null}
            />
          </div>
        </div>
      </div>
      <button onClick={handleDelete} style={{ position: "fixed", bottom: 16, right: 16 }}>Delete Selected</button>
      <button onClick={handleUndo} style={{ position: "fixed", bottom: 56, right: 16 }}>Undo</button>
      <button onClick={handleRedo} style={{ position: "fixed", bottom: 96, right: 16 }}>Redo</button>
      <button onClick={handleCopy} style={{ position: "fixed", bottom: 136, right: 16 }}>Copy</button>
      <button onClick={handlePaste} style={{ position: "fixed", bottom: 176, right: 16 }}>Paste</button>
      <button style={{ position: "fixed", bottom: 16, left: 16, zIndex: 100 }} onClick={handleSaveNode} disabled={!selectedIds.length}>Save Selected as Drag & Drop</button>
      <button style={{ position: "fixed", bottom: 56, left: 16, zIndex: 100 }} onClick={handleSavePopup} disabled={!selectedIds.length}>Save Selected as Popup</button>
      <div style={{ position: "fixed", bottom: 16, right: 16, zIndex: 100, background: "#fff", borderRadius: 4, padding: 8, boxShadow: "0 2px 8px #0002" }}>
        <h4>Popups</h4>
        {popups.length === 0 && <div style={{ color: "#888" }}>No popups yet.</div>}
        {popups.map(popup => (
          <div key={popup.id} style={{ marginBottom: 8 }}>
            <div style={{ fontSize: "0.9em", color: "#555" }}>{popup.name}</div>
            <button style={{ fontSize: "0.8em", marginRight: 4 }} onClick={() => handleDeletePopup(popup.id)}>Delete</button>
            {popupAttachMode && (
              <button style={{ fontSize: "0.8em" }} onClick={() => handleAttachPopupFinish(popup.id)}>Attach to Selected Button</button>
            )}
          </div>
        ))}
      </div>
      <div style={{ position: "fixed", top: 16, right: 16, zIndex: 100, background: "#fff", borderRadius: 4, padding: 8, boxShadow: "0 2px 8px #0002", minWidth: 220 }}>
        <h4>Assets</h4>
        <input type="file" accept="image/*" onChange={e => e.target.files && handleUploadAsset(e.target.files[0])} />
        <div style={{ maxHeight: 180, overflowY: "auto", marginTop: 8 }}>
          {assets.length === 0 && <div style={{ color: "#888" }}>No assets uploaded.</div>}
          {assets.map(asset => (
            <div key={asset.id} style={{ display: "flex", alignItems: "center", marginBottom: 8 }}>
              <img src={asset.url} alt={asset.name} style={{ width: 32, height: 32, objectFit: "cover", borderRadius: 4, marginRight: 8 }} />
              <input
                value={asset.name}
                onChange={e => handleRenameAsset(asset.id, e.target.value)}
                style={{ flex: 1, fontSize: "0.95em", marginRight: 4 }}
              />
              <button style={{ color: "#c00", fontSize: "0.9em" }} onClick={() => handleDeleteAsset(asset.id)}>Delete</button>
            </div>
          ))}
        </div>
      </div>
      {/* Render popup when active */}
      {activePopup && (
        <div style={{ position: "absolute", left: activePopup.x, top: activePopup.y, background: "#fff", border: "2px solid #0078d4", borderRadius: 8, boxShadow: "0 2px 12px #0078d433", padding: 16, zIndex: 200 }}>
          {popups.find(p => p.id === activePopup.popupId)?.elements.map(el => (
            <div
              key={el.id}
              style={{
                position: "absolute",
                left: el.x,
                top: el.y,
                width: el.width,
                height: el.height,
                background: el.backgroundColor || "#fff",
                border: "1px solid #aaa",
                zIndex: 2,
              }}
            >
              {el.text || el.icon ? <span>{el.text || <img src={el.icon} alt="icon" style={{ width: 16, height: 16 }} />}</span> : null}
            </div>
          ))}
          <button style={{ marginTop: 8 }} onClick={() => setActivePopup(null)}>Close</button>
        </div>
      )}
      {notification && (
        <NotificationBox
          message={notification.message}
          onConfirm={notification.onConfirm}
          onCancel={notification.onCancel}
          confirmText="Confirm"
          cancelText={notification.onCancel ? "Cancel" : undefined}
        />
      )}
      <button
        style={{ position: "fixed", top: 16, left: 16, zIndex: 200, background: "#1976d2", color: "#fff", border: "none", borderRadius: 6, padding: "6px 16px", fontWeight: 600, fontSize: "1em" }}
        onClick={() => setShowOnboarding(true)}
      >
        ? Help
      </button>
      {showOnboarding && (
        <div style={{ position: "fixed", top: 0, left: 0, width: "100vw", height: "100vh", background: "rgba(0,0,0,0.18)", zIndex: 9999, display: "flex", alignItems: "center", justifyContent: "center" }}>
          <div style={{ background: "#fff", borderRadius: 12, boxShadow: "0 4px 32px #1976d244", padding: 32, minWidth: 340, maxWidth: 420 }}>
            <h2 style={{ color: "#1976d2", marginTop: 0 }}>Welcome to LuaGUI!</h2>
            <ul style={{ fontSize: "1.08em", color: "#333", paddingLeft: 20 }}>
              {ONBOARDING_TIPS.map((tip, idx) => (
                <li key={idx} style={{ marginBottom: 10 }}>{tip}</li>
              ))}
            </ul>
            <button style={{ marginTop: 18, background: "#1976d2", color: "#fff", fontWeight: 600 }} onClick={() => setShowOnboarding(false)}>Got it!</button>
          </div>
        </div>
      )}
    </div>
  );
};

export default App;
