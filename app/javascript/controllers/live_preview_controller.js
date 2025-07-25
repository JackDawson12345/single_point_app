// app/javascript/controllers/live_preview_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["frame"]
    static values = { url: String }

    connect() {
        this.refreshPreview()
    }

    refreshPreview() {
        if (this.hasFrameTarget && this.urlValue) {
            this.frameTarget.src = this.urlValue + '?t=' + Date.now()
        }
    }

    toggleFullscreen() {
        const frame = this.frameTarget

        if (!document.fullscreenElement) {
            frame.requestFullscreen().catch(err => {
                console.error('Error attempting to enable fullscreen:', err)
            })
        } else {
            document.exitFullscreen()
        }
    }
}