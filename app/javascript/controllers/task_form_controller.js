import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["submitButton", "loadingSpinner"]

  connect() {
    console.log("Task form controller connected")
  }

  async submit(event) {
    event.preventDefault()
    
    const form = event.target
    const formData = new FormData(form)
    
    // Show loading state
    this.showLoading()
    
    try {
      const response = await fetch(form.action, {
        method: "POST",
        headers: {
          "Accept": "application/json",
          "X-Requested-With": "XMLHttpRequest"
        },
        body: formData
      })
      
      const data = await response.json()
      
      if (response.ok && data.status === "success") {
        this.handleSuccess(data)
      } else {
        this.handleError(data.errors || ["An error occurred"])
      }
    } catch (error) {
      console.error("Task creation failed:", error)
      this.handleError(["Network error occurred"])
    } finally {
      this.hideLoading()
    }
  }

  handleSuccess(data) {
    // Show success flash message
    this.showFlashMessage("Task created successfully!", "notice")
    
    // Close the modal
    const modal = this.element.closest("[data-controller='modal']")
    if (modal) {
      const modalController = this.application.getControllerForElementAndIdentifier(modal, "modal")
      if (modalController) {
        modalController.close()
      }
    }
    
    // Reset form
    this.element.reset()
    
    // Optionally refresh the page or update the task list
    // For now, we'll just reload to show the new task
    setTimeout(() => {
      window.location.reload()
    }, 1000)
  }

  handleError(errors) {
    // Show error flash message
    const errorMessage = Array.isArray(errors) ? errors.join(", ") : errors
    this.showFlashMessage(errorMessage, "alert")
  }

  showFlashMessage(message, type) {
    // Create and show a flash message
    const flashHtml = `
      <div class="flash-${type}" data-controller="flash" data-flash-auto-dismiss-value="5000">
        <span class="flash-message">${message}</span>
        <button class="flash-close" data-action="click->flash#close" type="button" aria-label="Close flash message">
          ×
        </button>
      </div>
    `
    
    // Insert flash message at the top of the main content area
    const mainContent = document.querySelector(".main-content") || document.body
    const tempDiv = document.createElement("div")
    tempDiv.innerHTML = flashHtml
    const flashElement = tempDiv.firstElementChild
    
    mainContent.insertBefore(flashElement, mainContent.firstChild)
  }

  showLoading() {
    if (this.hasSubmitButtonTarget) {
      this.submitButtonTarget.disabled = true
      this.submitButtonTarget.textContent = "Creating..."
    }
    
    if (this.hasLoadingSpinnerTarget) {
      this.loadingSpinnerTarget.style.display = "block"
    }
  }

  hideLoading() {
    if (this.hasSubmitButtonTarget) {
      this.submitButtonTarget.disabled = false
      this.submitButtonTarget.textContent = "Create Task"
    }
    
    if (this.hasLoadingSpinnerTarget) {
      this.loadingSpinnerTarget.style.display = "none"
    }
  }
}