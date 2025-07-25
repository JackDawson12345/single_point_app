// app/javascript/controllers/color_picker_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["input", "preview"]
    static values = { variable: String }

    connect() {
        this.updatePreview()
    }

    colorChanged() {
        this.updatePreview()
        this.updateCSSVariable()
    }

    updatePreview() {
        if (this.hasPreviewTarget) {
            this.previewTarget.style.backgroundColor = this.inputTarget.value
        }
    }

    updateCSSVariable() {
        const variableName = `--${this.variableValue.replace(/_/g, '-')}`
        document.documentElement.style.setProperty(variableName, this.inputTarget.value)
    }
}