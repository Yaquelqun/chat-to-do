import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // Focus trap and initial setup
    this.element.style.display = "flex"
    this.trapFocus()
  }

  disconnect() {
    this.element.style.display = "none"
  }

  close(event) {
    if (event) {
      event.preventDefault()
    }
    this.hide()
  }

  closeOnBackdrop(event) {
    // Only close if clicking directly on the backdrop, not on child elements
    if (event.target === event.currentTarget) {
      this.close()
    }
  }

  hide() {
    this.element.style.display = "none"
    // Optionally remove the modal from DOM
    setTimeout(() => {
      if (this.element.parentNode) {
        this.element.remove()
      }
    }, 300)
  }

  show() {
    this.element.style.display = "flex"
    this.trapFocus()
  }

  trapFocus() {
    // Simple focus trap - focus on first focusable element
    const focusableElements = this.element.querySelectorAll(
      'button, [href], input, select, textarea, [tabindex]:not([tabindex="-1"])'
    )
    
    if (focusableElements.length > 0) {
      focusableElements[0].focus()
    }
  }
}