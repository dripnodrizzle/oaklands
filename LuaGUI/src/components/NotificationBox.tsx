import React, { useState, useRef } from "react";

interface NotificationBoxProps {
  message: string;
  onConfirm?: () => void;
  onCancel?: () => void;
  confirmText?: string;
  cancelText?: string;
  draggable?: boolean;
}

const NotificationBox: React.FC<NotificationBoxProps> = ({
  message,
  onConfirm,
  onCancel,
  confirmText = "OK",
  cancelText = "Cancel",
  draggable = true,
}) => {
  const [pos, setPos] = useState({ x: 200, y: 200 });
  const dragRef = useRef<HTMLDivElement>(null);
  const dragging = useRef(false);
  const offset = useRef({ x: 0, y: 0 });

  const handleMouseDown = (e: React.MouseEvent) => {
    if (!draggable) return;
    dragging.current = true;
    offset.current = {
      x: e.clientX - pos.x,
      y: e.clientY - pos.y,
    };
    document.addEventListener("mousemove", handleMouseMove);
    document.addEventListener("mouseup", handleMouseUp);
  };

  const handleMouseMove = (e: MouseEvent) => {
    if (!dragging.current) return;
    setPos({ x: e.clientX - offset.current.x, y: e.clientY - offset.current.y });
  };

  const handleMouseUp = () => {
    dragging.current = false;
    document.removeEventListener("mousemove", handleMouseMove);
    document.removeEventListener("mouseup", handleMouseUp);
  };

  return (
    <div
      ref={dragRef}
      style={{
        position: "fixed",
        left: pos.x,
        top: pos.y,
        minWidth: 260,
        background: "#fff",
        border: "2px solid #0078d4",
        borderRadius: 8,
        boxShadow: "0 2px 12px #0078d433",
        zIndex: 9999,
        cursor: draggable ? "move" : "default",
        userSelect: "none",
      }}
    >
      <div
        style={{
          padding: "12px 16px 8px 16px",
          fontWeight: 600,
          background: "#f3faff",
          borderTopLeftRadius: 8,
          borderTopRightRadius: 8,
          cursor: draggable ? "move" : "default",
        }}
        onMouseDown={handleMouseDown}
      >
        Notification
      </div>
      <div style={{ padding: "16px", fontSize: "1em" }}>{message}</div>
      <div style={{ display: "flex", justifyContent: "flex-end", gap: 8, padding: "8px 16px 12px 16px" }}>
        {onCancel && (
          <button onClick={onCancel} style={{ background: "#eee", border: "1px solid #bbb", borderRadius: 4, padding: "4px 12px" }}>{cancelText}</button>
        )}
        {onConfirm && (
          <button onClick={onConfirm} style={{ background: "#0078d4", color: "#fff", border: "none", borderRadius: 4, padding: "4px 16px" }}>{confirmText}</button>
        )}
      </div>
    </div>
  );
};

export default NotificationBox;
