// app/javascript/controllers/form_auto_save_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static values = {
        url: String,
        interval: { type: Number, default: 30000 } // Auto-save every 30 seconds
    }

    connect() {
        this.startAutoSave()
        this.element.addEventListener('input', this.handleInput.bind(this))
    }

    disconnect() {
        this.stopAutoSave()
    }

    startAutoSave() {
        this.autoSaveInterval = setInterval(() => {
            this.save()
        }, this.intervalValue)
    }

    stopAutoSave() {
        if (this.autoSaveInterval) {
            clearInterval(this.autoSaveInterval)
        }
    }

    handleInput() {
        this.hasUnsavedChanges = true
        this.showUnsavedIndicator()
    }

    save() {
        if (!this.hasUnsavedChanges) return

        const formData = new FormData(this.element)

        fetch(this.urlValue, {
            method: 'PATCH',
            body: formData,
            headers: {
                'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content,
                'Accept': 'application/json'
            }
        })
            .then(response => response.json())
            .then(data => {
                if (data.status === 'success') {
                    this.hasUnsavedChanges = false
                    this.showSavedIndicator()
                }
            })
            .catch(error => {
                console.error('Auto-save failed:', error)
            })
    }

    showUnsavedIndicator() {
        let indicator = document.getElementById('save-indicator')
        if (!indicator) {
            indicator = document.createElement('div')
            indicator.id = 'save-indicator'
            indicator.className = 'position-fixed bg-warning text-dark px-3 py-2 rounded'
            indicator.style.cssText = 'top: 20px; left: 20px; z-index: 1050;'
            document.body.appendChild(indicator)
        }
        indicator.innerHTML = '<i class="fas fa-circle text-warning"></i> Unsaved changes'
    }

    showSavedIndicator() {
        const indicator = document.getElementById('save-indicator')
        if (indicator) {
            indicator.innerHTML = '<i class="fas fa-check-circle text-success"></i> Saved'
            indicator.className = 'position-fixed bg-success text-white px-3 py-2 rounded'

            setTimeout(() => {
                if (indicator.parentNode) {
                    indicator.remove()
                }
            }, 2000)
        }
    }
}