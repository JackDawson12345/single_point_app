// app/javascript/controllers/website_builder_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["themeCard", "previewFrame", "customizationForm"]
    static values = {
        previewUrl: String,
        websiteId: Number
    }

    connect() {
        this.initializeThemeSelection()
        this.initializeLivePreview()
    }

    initializeThemeSelection() {
        this.themeCardTargets.forEach(card => {
            card.addEventListener('click', (e) => {
                if (!e.target.matches('input[type="radio"]')) {
                    const radio = card.querySelector('input[type="radio"]')
                    if (radio) {
                        radio.checked = true
                        this.updateThemeSelection(radio)
                    }
                }
            })
        })
    }

    initializeLivePreview() {
        if (this.hasCustomizationFormTarget) {
            this.customizationFormTarget.addEventListener('input', this.debounce((e) => {
                this.updatePreview()
            }, 500))
        }
    }

    updateThemeSelection(selectedRadio) {
        // Remove selected class from all cards
        this.themeCardTargets.forEach(card => {
            card.classList.remove('selected')
        })

        // Add selected class to chosen card
        const selectedCard = selectedRadio.closest('.theme-card')
        if (selectedCard) {
            selectedCard.classList.add('selected')
        }
    }

    updatePreview() {
        if (this.hasPreviewFrameTarget && this.previewUrlValue) {
            // Collect form data
            const formData = new FormData(this.customizationFormTarget)

            // Update preview iframe with new customizations
            fetch(this.previewUrlValue, {
                method: 'POST',
                body: formData,
                headers: {
                    'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content,
                    'Accept': 'text/html'
                }
            })
                .then(response => response.text())
                .then(html => {
                    this.previewFrameTarget.srcdoc = html
                })
                .catch(error => console.error('Preview update failed:', error))
        }
    }

    // Add new service field for services page
    addService(event) {
        event.preventDefault()

        const container = document.getElementById('services-container')
        const serviceCount = container.querySelectorAll('.service-item').length

        const serviceHTML = `
      <div class="service-item border p-3 mb-3">
        <div class="d-flex justify-content-end mb-2">
          <button type="button" class="btn btn-sm btn-outline-danger" onclick="this.closest('.service-item').remove()">
            <i class="fas fa-times"></i>
          </button>
        </div>
        <div class="mb-2">
          <input type="text" name="website_page[page_data][services][${serviceCount}][price]" 
                 placeholder="Price" class="form-control">
        </div>
      </div>
    `

        container.insertAdjacentHTML('beforeend', serviceHTML)
    }

    // Save customizations with AJAX
    saveCustomizations(event) {
        event.preventDefault()

        const form = event.target
        const formData = new FormData(form)

        fetch(form.action, {
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
                    this.showNotification('Customizations saved successfully!', 'success')
                    this.updatePreview()
                } else {
                    this.showNotification('Failed to save customizations', 'error')
                }
            })
            .catch(error => {
                console.error('Save failed:', error)
                this.showNotification('An error occurred while saving', 'error')
            })
    }

    showNotification(message, type = 'info') {
        // Create notification element
        const notification = document.createElement('div')
        notification.className = `alert alert-${type === 'error' ? 'danger' : 'success'} alert-dismissible fade show position-fixed`
        notification.style.cssText = 'top: 20px; right: 20px; z-index: 1050; min-width: 300px;'
        notification.innerHTML = `
      ${message}
      <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    `

        document.body.appendChild(notification)

        // Auto-remove after 5 seconds
        setTimeout(() => {
            if (notification.parentNode) {
                notification.remove()
            }
        }, 5000)
    }

    // Utility function for debouncing
    debounce(func, wait) {
        let timeout
        return function executedFunction(...args) {
            const later = () => {
                clearTimeout(timeout)
                func(...args)
            }
            clearTimeout(timeout)
            timeout = setTimeout(later, wait)
        }
    }
}
