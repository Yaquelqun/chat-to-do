import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { autoDismiss: Number }
  
  connect() {
    if (this.hasAutoDismissValue && this.autoDismissValue > 0) {
      this.timeout = setTimeout(() => {
        this.dismiss()
      }, this.autoDismissValue)
    }
  }

  disconnect() {
    if (this.timeout) {
      clearTimeout(this.timeout)
    }
  }

  close(event) {
    event.preventDefault()
    this.dismiss()
  }

  dismiss() {
    this.element.style.transition = "opacity 0.3s ease-out"
    this.element.style.opacity = "0"
    
    setTimeout(() => {
      this.element.remove()
    }, 300)
  }
}