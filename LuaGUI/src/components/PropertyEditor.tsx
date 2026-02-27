import React from "react";

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
}

interface PropertyEditorProps {
  element: Element | null;
  onUpdate: (el: Element) => void;
}

const PropertyEditor: React.FC<PropertyEditorProps> = ({ element, onUpdate }) => {
  if (!element) {
    return (
      <section className="property-editor">
        <h2>Properties</h2>
        <div className="property-placeholder">Select an element</div>
      </section>
    );
  }

  const handleChange = (field: keyof Element, value: number | string) => {
    onUpdate({ ...element, [field]: value });
  };

  const handleFileUpload = (field: "iconUrl" | "imageUrl", files: FileList | null) => {
    if (files && files[0]) {
      const reader = new FileReader();
      reader.onload = (e) => {
        handleChange(field, e.target?.result as string);
      };
      reader.readAsDataURL(files[0]);
    }
  };

  return (
    <section className="property-editor">
      <h2>Properties</h2>
      <div>
        <strong>Type:</strong> {element.type}
      </div>
      <div>
        <label>
          X:
          <input type="number" value={element.x} onChange={e => handleChange("x", Number(e.target.value))} />
        </label>
      </div>
      <div>
        <label>
          Y:
          <input type="number" value={element.y} onChange={e => handleChange("y", Number(e.target.value))} />
        </label>
      </div>
      <div>
        <label>
          Width:
          <input type="number" value={element.width} onChange={e => handleChange("width", Number(e.target.value))} />
        </label>
      </div>
      <div>
        <label>
          Height:
          <input type="number" value={element.height} onChange={e => handleChange("height", Number(e.target.value))} />
        </label>
      </div>
      <div>
        <label>
          Background:
          <input type="color" value={element.background} onChange={e => handleChange("background", e.target.value)} />
        </label>
      </div>
      <div>
        <label>
          Font:
          <input type="text" value={element.font || ""} onChange={e => handleChange("font", e.target.value)} />
        </label>
      </div>
      <div>
        <label>
          Font Size:
          <input type="number" value={element.fontSize || 16} onChange={e => handleChange("fontSize", Number(e.target.value))} />
        </label>
      </div>
      <div>
        <label>
          Font Weight:
          <select value={element.fontWeight || "normal"} onChange={e => handleChange("fontWeight", e.target.value)}>
            <option value="normal">Normal</option>
            <option value="bold">Bold</option>
          </select>
        </label>
      </div>
      <div>
        <label>
          Font Style:
          <select value={element.fontStyle || "normal"} onChange={e => handleChange("fontStyle", e.target.value)}>
            <option value="normal">Normal</option>
            <option value="italic">Italic</option>
          </select>
        </label>
      </div>
      <div>
        <label>
          Border Color:
          <input type="color" value={element.borderColor || "#888"} onChange={e => handleChange("borderColor", e.target.value)} />
        </label>
      </div>
      <div>
        <label>
          Border Width:
          <input type="number" value={element.borderWidth || 1} onChange={e => handleChange("borderWidth", Number(e.target.value))} />
        </label>
      </div>
      <div>
        <label>
          Border Style:
          <select value={element.borderStyle || "solid"} onChange={e => handleChange("borderStyle", e.target.value)}>
            <option value="solid">Solid</option>
            <option value="dashed">Dashed</option>
            <option value="dotted">Dotted</option>
          </select>
        </label>
      </div>
      {element.type === "TextLabel" && (
        <div>
          <label>
            Text:
            <input type="text" value={element.text || ""} onChange={e => handleChange("text", e.target.value)} />
          </label>
        </div>
      )}
      {element.type === "Button" && (
        <div>
          <label>
            Text:
            <input type="text" value={element.text || ""} onChange={e => handleChange("text", e.target.value)} />
          </label>
        </div>
      )}
      {element.type === "Slider" && (
        <div>
          <label>
            Value:
            <input type="range" min={0} max={100} value={element.value || 50} onChange={e => handleChange("value", Number(e.target.value))} />
          </label>
        </div>
      )}
      {element.type === "IconBox" && (
        <div>
          <label>
            Icon Upload:
            <input type="file" accept="image/*" onChange={e => handleFileUpload("iconUrl", e.target.files)} />
          </label>
        </div>
      )}
      {element.type === "ImageBox" && (
        <div>
          <label>
            Image Upload:
            <input type="file" accept="image/*" onChange={e => handleFileUpload("imageUrl", e.target.files)} />
          </label>
        </div>
      )}
    </section>
  );
};

export default PropertyEditor;
