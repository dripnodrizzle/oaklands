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
  parentId?: string | null;
}

function hexToColor3(hex: string): string {
  // Accepts #RRGGBB or RRGGBB
  hex = hex.replace("#", "");
  if (hex.length !== 6) return "Color3.new(1,1,1)";
  const r = parseInt(hex.slice(0, 2), 16) / 255;
  const g = parseInt(hex.slice(2, 4), 16) / 255;
  const b = parseInt(hex.slice(4, 6), 16) / 255;
  return `Color3.new(${r.toFixed(3)}, ${g.toFixed(3)}, ${b.toFixed(3)})`;
}

function generateLua(elements: Element[]): string {
  let lua = "-- Roblox GUI Exported from LuaGUI\nlocal gui = Instance.new('ScreenGui')\n";
  const idToVar: Record<string, string> = {};
  elements.forEach((el, idx) => {
    const varName = `el${idx}`;
    idToVar[el.id] = varName;
    let className = "Frame";
    if (el.type === "TextLabel") className = "TextLabel";
    else if (el.type === "Button") className = "TextButton";
    else if (el.type === "ImageLabel" || el.type === "ImageBox") className = "ImageLabel";
    else if (el.type === "IconBox") className = "ImageLabel";
    // Sliders and others can be custom
    lua += `local ${varName} = Instance.new('${className}')\n`;
    lua += `-- ${el.type} (${el.id})\n`;
    lua += `${varName}.Position = UDim2.new(0, ${Math.round(el.x)}, 0, ${Math.round(el.y)})\n`;
    lua += `${varName}.Size = UDim2.new(0, ${Math.round(el.width)}, 0, ${Math.round(el.height)})\n`;
    lua += `${varName}.BackgroundColor3 = ${hexToColor3(el.background)}\n`;
    if (el.borderColor) lua += `${varName}.BorderColor3 = ${hexToColor3(el.borderColor)}\n`;
    if (el.borderWidth) lua += `${varName}.BorderSizePixel = ${el.borderWidth}\n`;
    if (el.text) lua += `${varName}.Text = "${el.text}"\n`;
    if (el.font) lua += `${varName}.Font = Enum.Font.${el.font}\n`;
    if (el.fontSize) lua += `${varName}.TextSize = ${el.fontSize}\n`;
    if (el.fontWeight === "bold") lua += `${varName}.TextWrapped = true\n`;
    if (el.iconUrl || el.imageUrl) lua += `${varName}.Image = "${el.iconUrl || el.imageUrl}"\n`;
    if (el.type === "Slider" && el.value) lua += `-- Slider value: ${el.value}\n`;
    if (el.parentId) lua += `${varName}.Parent = ${idToVar[el.parentId]}\n`;
    else lua += `${varName}.Parent = gui\n`;
  });
  lua += "return gui\n";
  return lua;
}

const ExportButton: React.FC<{ elements?: Element[] }> = ({ elements = [] }) => {
  const handleExport = () => {
    const lua = generateLua(elements);
    const blob = new Blob([lua], { type: "text/plain" });
    const url = URL.createObjectURL(blob);
    const a = document.createElement("a");
    a.href = url;
    a.download = "gui_export.lua";
    a.click();
    URL.revokeObjectURL(url);
  };

  return (
    <button style={{ margin: 16, padding: 8, fontWeight: "bold" }} onClick={handleExport}>
      Export to Roblox Lua
    </button>
  );
};

export default ExportButton;
