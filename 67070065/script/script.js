async function loadStatus() {
  try {
    const res = await fetch("data.json?cache=" + Date.now());
    const data = await res.json();

    // Basic Info
    document.getElementById("cpu").textContent = data.cpu_usage + " %";
    document.getElementById("memory").textContent = data.mem_usage + " %";
    document.getElementById("disk").textContent = data.disk_usage;
    document.getElementById("diskDetail").textContent =
      data.disk_used + " / " + data.disk_total;

    document.getElementById("lastUpdated").textContent =
      "Last updated: " + data.last_updated;

    document.getElementById("neofetch").textContent = data.neofetch;

    // Location Text
    document.getElementById("locationText").textContent =
      `Latitude: ${data.latitude}, Longitude: ${data.longitude}`;

    // Map Marker Placement
    const lat = parseFloat(data.latitude);
    const lng = parseFloat(data.longitude);

    // Convert lat/lng into % on equirectangular map
    const xPercent = (lng + 180) / 360 * 100;
    const yPercent = (90 - lat) / 180 * 100;

    const marker = document.getElementById("server-marker");
    marker.style.left = xPercent + "%";
    marker.style.top = yPercent + "%";

  } catch (err) {
    console.error("Loading error:", err);
  }
}

loadStatus();
setInterval(loadStatus, 60000);
