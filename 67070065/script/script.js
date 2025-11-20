async function loadStatus() {
  try {
    const res = await fetch("data.json?cache=" + Date.now());
    const data = await res.json();

    document.getElementById("cpu-main").textContent = data.cpu_usage + " %";
    document.getElementById("memory-main").textContent = data.mem_usage + " %";
    document.getElementById("disk-main").textContent = data.disk_usage;

    document.getElementById("memory-detail").textContent =
      `Used ~${data.mem_usage}% of RAM`;
    document.getElementById("disk-detail-main").textContent =
      `${data.disk_used} / ${data.disk_total}`;

    document.getElementById("lastUpdated").textContent =
      "Last updated: " + data.last_updated;

    document.getElementById("neofetch").textContent = data.neofetch;

    // top → table
    if (data.top) {
      renderTopTable(data.top);
    }

  } catch (err) {
    console.error("Error loading data.json", err);
  }
}

function renderTopTable(topStr) {
  const tbody = document.querySelector("#top-table tbody");
  tbody.innerHTML = "";

  const lines = topStr.split("\n");

  for (const line of lines) {
    const trimmed = line.trim();
    if (!trimmed) continue;

    if (!/^[0-9]/.test(trimmed)) continue;

    const cols = trimmed.split(/\s+/);
    if (cols.length < 12) continue;

    const pid = cols[0];
    const user = cols[1];
    const cpu = cols[8];
    const mem = cols[9];
    const command = cols.slice(11).join(" ");

    const tr = document.createElement("tr");
    [pid, user, cpu, mem, command].forEach((val) => {
      const td = document.createElement("td");
      td.textContent = val;
      tr.appendChild(td);
    });
    tbody.appendChild(tr);
  }
}

loadStatus();
setInterval(loadStatus, 60000);
