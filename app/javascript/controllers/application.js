// app/javascript/application.js
import "@hotwired/turbo-rails"
import "controllers"

// Import Bootstrap if using CDN (optional - can also use importmap)
// import "bootstrap"

// Website Builder specific functionality
document.addEventListener('DOMContentLoaded', function() {
    // Add Font Awesome CSS if not already present
    if (!document.querySelector('link[href*="font-awesome"]')) {
        const link = document.createElement('link')
        link.rel = 'stylesheet'
        link.href = 'https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css'
        document.head.appendChild(link)
    }

    // Initialize Bootstrap components
    initializeBootstrap()

    // Initialize website builder specific functionality
    initializeWebsiteBuilder()

    // Initialize form helpers
    initializeFormHelpers()

    // Initialize preview functionality
    initializePreviewFeatures()
})

// Initialize Bootstrap tooltips and popovers
function initializeBootstrap() {
    // Initialize tooltips
    const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
    tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl)
    })

    // Initialize popovers
    const popoverTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="popover"]'))
    popoverTriggerList.map(function (popoverTriggerEl) {
        return new bootstrap.Popover(popoverTriggerEl)
    })
}

// Initialize website builder specific functionality
function initializeWebsiteBuilder() {
    // Theme selection cards
    const themeCards = document.querySelectorAll('.theme-card')
    themeCards.forEach(card => {
        card.addEventListener('click', function(e) {
            if (!e.target.matches('input[type="radio"]')) {
                const radio = this.querySelector('input[type="radio"]')
                if (radio) {
                    // Remove selected class from all cards
                    themeCards.forEach(c => c.classList.remove('selected'))
                    // Add selected class to clicked card
                    this.classList.add('selected')
                    // Check the radio button
                    radio.checked = true
                }
            }
        })
    })

    // Color picker preview updates
    const colorPickers = document.querySelectorAll('input[type="color"]')
    colorPickers.forEach(picker => {
        picker.addEventListener('change', function() {
            updateColorPreview(this)
            updateLivePreview()
        })
    })

    // Auto-save functionality for forms
    const autoSaveForms = document.querySelectorAll('[data-auto-save]')
    autoSaveForms.forEach(form => {
        let saveTimeout
        form.addEventListener('input', function() {
            clearTimeout(saveTimeout)
            showUnsavedIndicator()
            saveTimeout = setTimeout(() => {
                autoSaveForm(form)
            }, 2000) // Save after 2 seconds of no input
        })
    })
}

// Initialize form helper functions
function initializeFormHelpers() {
    // Add service button functionality
    const addServiceBtns = document.querySelectorAll('[data-action="add-service"]')
    addServiceBtns.forEach(btn => {
        btn.addEventListener('click', function(e) {
            e.preventDefault()
            addServiceField()
        })
    })

    // Add team member button functionality
    const addTeamBtns = document.querySelectorAll('[data-action="add-team-member"]')
    addTeamBtns.forEach(btn => {
        btn.addEventListener('click', function(e) {
            e.preventDefault()
            addTeamMemberField()
        })
    })

    // Remove item buttons
    document.addEventListener('click', function(e) {
        if (e.target.matches('[data-action="remove-item"]') ||
            e.target.closest('[data-action="remove-item"]')) {
            e.preventDefault()
            const button = e.target.closest('[data-action="remove-item"]')
            const item = button.closest('.service-item, .team-member-item')
            if (item) {
                item.remove()
                updateLivePreview()
            }
        }
    })
}

// Initialize preview features
function initializePreviewFeatures() {
    // Refresh preview button
    const refreshBtns = document.querySelectorAll('[data-action="refresh-preview"]')
    refreshBtns.forEach(btn => {
        btn.addEventListener('click', function(e) {
            e.preventDefault()
            refreshPreview()
        })
    })

    // Fullscreen preview toggle
    const fullscreenBtns = document.querySelectorAll('[data-action="fullscreen-preview"]')
    fullscreenBtns.forEach(btn => {
        btn.addEventListener('click', function(e) {
            e.preventDefault()
            togglePreviewFullscreen()
        })
    })

    // Live preview updates for customization forms
    const customizationInputs = document.querySelectorAll('.customization-form input, .customization-form select')
    customizationInputs.forEach(input => {
        input.addEventListener('change', debounce(updateLivePreview, 500))
    })
}

// Global utility functions for website builder
window.WebsiteBuilder = {
    // Add service field dynamically
    addServiceField: function() {
        const container = document.getElementById('services-container')
        if (!container) return

        const serviceCount = container.querySelectorAll('.service-item').length
        const serviceHTML = `
      <div class="service-item border p-3 mb-3 position-relative">
        <button type="button" class="btn btn-sm btn-outline-danger position-absolute" 
                style="top: 0.5rem; right: 0.5rem;" data-action="remove-item">
          <i class="fas fa-times"></i>
        </button>
        <div class="mb-2">
          <label class="form-label">Service Name</label>
          <input type="text" name="website_page[page_data][services][${serviceCount}][name]" 
                 placeholder="Enter service name" class="form-control">
        </div>
        <div class="mb-2">
          <label class="form-label">Description</label>
          <textarea name="website_page[page_data][services][${serviceCount}][description]" 
                    placeholder="Describe your service" rows="3" class="form-control"></textarea>
        </div>
        <div class="mb-2">
          <label class="form-label">Price</label>
          <input type="text" name="website_page[page_data][services][${serviceCount}][price]" 
                 placeholder="e.g., $99, Contact for quote" class="form-control">
        </div>
      </div>
    `
        container.insertAdjacentHTML('beforeend', serviceHTML)
    },

    // Add team member field dynamically
    addTeamMemberField: function() {
        const container = document.getElementById('team-container')
        if (!container) return

        const memberCount = container.querySelectorAll('.team-member-item').length
        const memberHTML = `
      <div class="team-member-item border p-3 mb-3 position-relative">
        <button type="button" class="btn btn-sm btn-outline-danger position-absolute" 
                style="top: 0.5rem; right: 0.5rem;" data-action="remove-item">
          <i class="fas fa-times"></i>
        </button>
        <div class="mb-2">
          <label class="form-label">Name</label>
          <input type="text" name="website_page[page_data][team_members][${memberCount}][name]" 
                 placeholder="Team member name" class="form-control">
        </div>
        <div class="mb-2">
          <label class="form-label">Position</label>
          <input type="text" name="website_page[page_data][team_members][${memberCount}][position]" 
                 placeholder="Job title or role" class="form-control">
        </div>
        <div class="mb-2">
          <label class="form-label">Bio</label>
          <textarea name="website_page[page_data][team_members][${memberCount}][bio]" 
                    placeholder="Brief bio or description" rows="2" class="form-control"></textarea>
        </div>
      </div>
    `
        container.insertAdjacentHTML('beforeend', memberHTML)
    },

    // Preview theme in modal
    previewTheme: function(themeId, themeName) {
        const modal = document.createElement('div')
        modal.className = 'modal fade'
        modal.innerHTML = `
      <div class="modal-dialog modal-xl">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">Theme Preview: ${themeName}</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
          </div>
          <div class="modal-body p-0">
            <iframe src="/admin/themes/${themeId}/preview" 
                    style="width: 100%; height: 600px; border: none;"
                    onload="this.style.opacity = 1"
                    style="opacity: 0; transition: opacity 0.3s;"></iframe>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
          </div>
        </div>
      </div>
    `
        document.body.appendChild(modal)

        const bsModal = new bootstrap.Modal(modal)
        bsModal.show()

        modal.addEventListener('hidden.bs.modal', () => {
            modal.remove()
        })
    },

    // Show notification
    showNotification: function(message, type = 'info', duration = 5000) {
        const alertType = type === 'error' ? 'danger' : (type === 'success' ? 'success' : 'info')
        const notification = document.createElement('div')
        notification.className = `alert alert-${alertType} alert-dismissible fade show position-fixed`
        notification.style.cssText = 'top: 20px; right: 20px; z-index: 1060; min-width: 300px; max-width: 400px;'
        notification.innerHTML = `
      <div class="d-flex align-items-center">
        <i class="fas fa-${type === 'success' ? 'check-circle' : type === 'error' ? 'exclamation-triangle' : 'info-circle'} me-2"></i>
        <span>${message}</span>
      </div>
      <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    `

        document.body.appendChild(notification)

        // Auto-remove after duration
        setTimeout(() => {
            if (notification.parentNode) {
                const bsAlert = new bootstrap.Alert(notification)
                bsAlert.close()
            }
        }, duration)
    }
}

// Helper functions

// Add service field (global function)
function addServiceField() {
    WebsiteBuilder.addServiceField()
}

// Add team member field (global function)
function addTeamMemberField() {
    WebsiteBuilder.addTeamMemberField()
}

// Update color preview
function updateColorPreview(colorInput) {
    const previewElement = colorInput.nextElementSibling
    if (previewElement && previewElement.classList.contains('color-preview')) {
        previewElement.style.backgroundColor = colorInput.value
    }
}

// Update live preview
function updateLivePreview() {
    const previewFrame = document.getElementById('live-preview-frame')
    if (previewFrame && previewFrame.src) {
        // Add timestamp to force refresh
        const url = new URL(previewFrame.src)
        url.searchParams.set('t', Date.now())
        previewFrame.src = url.toString()
    }
}

// Refresh preview
function refreshPreview() {
    const previewFrame = document.getElementById('live-preview-frame')
    if (previewFrame) {
        previewFrame.src = previewFrame.src
    }
}

// Toggle preview fullscreen
function togglePreviewFullscreen() {
    const previewFrame = document.getElementById('live-preview-frame')
    if (!previewFrame) return

    if (!document.fullscreenElement) {
        previewFrame.requestFullscreen().catch(err => {
            console.error('Error attempting to enable fullscreen:', err)
            WebsiteBuilder.showNotification('Fullscreen not supported', 'error')
        })
    } else {
        document.exitFullscreen()
    }
}

// Auto-save form
function autoSaveForm(form) {
    const formData = new FormData(form)
    const url = form.dataset.autoSaveUrl || form.action

    fetch(url, {
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
                showSavedIndicator()
            } else {
                WebsiteBuilder.showNotification('Auto-save failed', 'error', 3000)
            }
        })
        .catch(error => {
            console.error('Auto-save failed:', error)
            WebsiteBuilder.showNotification('Auto-save failed', 'error', 3000)
        })
}

// Show unsaved changes indicator
function showUnsavedIndicator() {
    let indicator = document.getElementById('save-indicator')
    if (!indicator) {
        indicator = document.createElement('div')
        indicator.id = 'save-indicator'
        indicator.className = 'position-fixed bg-warning text-dark px-3 py-2 rounded shadow'
        indicator.style.cssText = 'top: 20px; left: 20px; z-index: 1050; font-size: 0.875rem;'
        document.body.appendChild(indicator)
    }
    indicator.innerHTML = '<i class="fas fa-circle text-warning me-1"></i> Unsaved changes'
    indicator.className = 'position-fixed bg-warning text-dark px-3 py-2 rounded shadow'
}

// Show saved indicator
function showSavedIndicator() {
    const indicator = document.getElementById('save-indicator')
    if (indicator) {
        indicator.innerHTML = '<i class="fas fa-check-circle text-success me-1"></i> Saved'
        indicator.className = 'position-fixed bg-success text-white px-3 py-2 rounded shadow'

        setTimeout(() => {
            if (indicator.parentNode) {
                indicator.style.opacity = '0'
                indicator.style.transition = 'opacity 0.3s'
                setTimeout(() => {
                    if (indicator.parentNode) {
                        indicator.remove()
                    }
                }, 300)
            }
        }, 2000)
    }
}

// Debounce utility function
function debounce(func, wait) {
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

// Handle Turbo navigation
document.addEventListener('turbo:load', function() {
    // Re-initialize components after Turbo navigation
    initializeBootstrap()
    initializeWebsiteBuilder()
    initializeFormHelpers()
    initializePreviewFeatures()
})

// Handle form submissions with better UX
document.addEventListener('submit', function(e) {
    const form = e.target
    if (form.classList.contains('website-form')) {
        const submitBtn = form.querySelector('[type="submit"]')
        if (submitBtn) {
            const originalText = submitBtn.textContent
            submitBtn.disabled = true
            submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-1"></i> Saving...'

            // Re-enable button after 5 seconds as fallback
            setTimeout(() => {
                submitBtn.disabled = false
                submitBtn.textContent = originalText
            }, 5000)
        }
    }
})

// Handle page visibility changes to pause/resume auto-save
document.addEventListener('visibilitychange', function() {
    if (document.hidden) {
        // Page is hidden, pause auto-save timers
        window.autoSavePaused = true
    } else {
        // Page is visible, resume auto-save
        window.autoSavePaused = false
    }
})

// Export for use in other files
window.addServiceField = addServiceField
window.addTeamMemberField = addTeamMemberField
window.updateLivePreview = updateLivePreview