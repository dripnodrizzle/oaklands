import React from "react";

interface Element {
  id: string;
  type: string;
  parentId?: string | null;
}

interface HierarchyTreeProps {
  elements: Element[];
  setElements: React.Dispatch<React.SetStateAction<Element[]>>;
  onSelect: (el: Element | null) => void;
  selectedId?: string | null;
}

const renderTree = (elements: Element[], parentId: string | null, onSelect: (el: Element | null) => void, selectedId?: string | null) => {
  return elements
    .filter((el) => el.parentId === parentId)
    .map((el) => (
      <li key={el.id}>
        <span
          className={selectedId === el.id ? "selected" : ""}
          style={{ cursor: "pointer" }}
          onClick={() => onSelect(el)}
        >
          {el.type} ({el.id})
        </span>
        <ul>{renderTree(elements, el.id, onSelect, selectedId)}</ul>
      </li>
    ));
};

const HierarchyTree: React.FC<HierarchyTreeProps> = ({ elements, setElements, onSelect, selectedId }) => {
  // Simple re-parenting: select element, then choose new parent
  const handleReparent = (childId: string, newParentId: string | null) => {
    setElements((prev) =>
      prev.map((el) =>
        el.id === childId ? { ...el, parentId: newParentId } : el
      )
    );
  };

  return (
    <aside className="hierarchy-tree">
      <h2>Hierarchy</h2>
      <ul>{renderTree(elements, null, onSelect, selectedId)}</ul>
      {/* Simple re-parent UI (for demo): */}
      <div style={{ marginTop: 16 }}>
        <strong>Re-parent:</strong>
        <form
          onSubmit={e => {
            e.preventDefault();
            const childId = (e.target as any).childId.value;
            const newParentId = (e.target as any).newParentId.value || null;
            handleReparent(childId, newParentId);
          }}
        >
          <input name="childId" placeholder="Child ID" />
          <input name="newParentId" placeholder="New Parent ID (blank for root)" />
          <button type="submit">Set Parent</button>
        </form>
      </div>
    </aside>
  );
};

export default HierarchyTree;
