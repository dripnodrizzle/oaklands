
// Browser-based JWT-like token parser and WASM call demo
// Usage: Open in browser, input JWT and WASM file

function base64urlDecode(str) {
    str = str.replace(/-/g, '+').replace(/_/g, '/');
    while (str.length % 4) str += '=';
    return atob(str);
}

function parseJWT(token) {
    const parts = token.split('.');
    if (parts.length !== 3) throw new Error('Invalid token format');
    const header = JSON.parse(base64urlDecode(parts[0]));
    const payload = JSON.parse(base64urlDecode(parts[1]));
    const signature = parts[2];
    return { header, payload, signature };
}

function getUnixTimestamp() {
    return Math.floor(Date.now() / 1000);
}

async function loadWasmFromFile(file) {
    const buffer = await file.arrayBuffer();
    const wasmModule = await WebAssembly.instantiate(buffer);
    return wasmModule.instance.exports;
}

async function runDemo() {
    const token = document.getElementById('jwtInput').value.trim();
    const wasmFile = document.getElementById('wasmInput').files[0];
    const output = document.getElementById('output');
    output.textContent = '';
    if (!token) {
        output.textContent = 'Please enter a JWT-like token.';
        return;
    }
    if (!wasmFile) {
        output.textContent = 'Please select a WASM file.';
        return;
    }
    let payload;
    try {
        payload = parseJWT(token).payload;
    } catch (e) {
        output.textContent = 'Token parse error: ' + e.message;
        return;
    }
    const timestamp = getUnixTimestamp();
    output.textContent += 'Payload: ' + JSON.stringify(payload) + '\n';
    output.textContent += 'Current UNIX timestamp: ' + timestamp + '\n';
    let wasm;
    try {
        wasm = await loadWasmFromFile(wasmFile);
    } catch (e) {
        output.textContent += 'Failed to load WASM: ' + e.message + '\n';
        return;
    }
    if (typeof wasm.compute_proof !== 'function') {
        output.textContent += 'WASM does not export compute_proof.\n';
        return;
    }
    const userId = payload.user_id || 0;
    let proof;
    try {
        proof = wasm.compute_proof(userId, timestamp);
    } catch (e) {
        output.textContent += 'WASM call error: ' + e.message + '\n';
        return;
    }
    output.textContent += 'WASM proof: ' + proof + '\n';
}

// Simple HTML UI
document.body.innerHTML = `
<div style="font-family:monospace;max-width:600px;margin:2em auto;padding:2em;border:1px solid #ccc;border-radius:8px;">
  <h2>JWT + WASM Demo</h2>
  <label>JWT-like token:<br><input id="jwtInput" type="text" style="width:100%"></label><br><br>
  <label>WASM file:<br><input id="wasmInput" type="file" accept=".wasm"></label><br><br>
  <button onclick="runDemo()">Run</button>
  <pre id="output" style="background:#f9f9f9;padding:1em;margin-top:1em;white-space:pre-wrap;"></pre>
</div>
`;

window.runDemo = runDemo;
