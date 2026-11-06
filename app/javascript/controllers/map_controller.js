import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { markers: Array }

  async connect() {
    if (!this.markersValue.length) return

    await import("leaflet")
    if (!this.element.isConnected) return

    const L = globalThis.L
    this.map = L.map(this.element, { scrollWheelZoom: false })
    L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
      maxZoom: 19,
      attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
    }).addTo(this.map)

    const points = []
    this.markersValue.forEach((marker) => {
      const latitude = Number(marker.latitude)
      const longitude = Number(marker.longitude)
      if (!Number.isFinite(latitude) || !Number.isFinite(longitude)) return

      const point = [latitude, longitude]
      points.push(point)
      const link = document.createElement("a")
      link.href = marker.url
      link.textContent = marker.title
      L.marker(point).addTo(this.map).bindPopup(link)
    })

    if (points.length === 1) {
      this.map.setView(points[0], 11)
    } else if (points.length > 1) {
      this.map.fitBounds(points, { padding: [24, 24] })
    }
  }

  disconnect() {
    this.map?.remove()
  }
}
