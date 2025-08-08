import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["userMenu", "dropdown", "resizeHandle"]

  connect() {
    console.log("Sidebar controller connected")
    this.isResizing = false
    this.startX = 0
    this.startWidth = 0
    
    // Bind event listeners for mouse events during resize
    this.boundMouseMove = this.handleMouseMove.bind(this)
    this.boundMouseUp = this.handleMouseUp.bind(this)
    
    // Handle clicks outside dropdown to close it
    this.boundClickOutside = this.handleClickOutside.bind(this)
    document.addEventListener("click", this.boundClickOutside)
    
    // Debug: Check if resize handle exists
    if (this.hasResizeHandleTarget) {
      console.log("Resize handle found:", this.resizeHandleTarget)
    } else {
      console.error("Resize handle target not found!")
    }
  }

  disconnect() {
    document.removeEventListener("click", this.boundClickOutside)
    document.removeEventListener("mousemove", this.boundMouseMove)
    document.removeEventListener("mouseup", this.boundMouseUp)
  }

  // User menu dropdown toggle
  toggleUserMenu(event) {
    event.preventDefault()
    event.stopPropagation()
    
    const dropdown = this.dropdownTarget
    const isVisible = dropdown.style.display !== "none"
    
    if (isVisible) {
      dropdown.style.display = "none"
    } else {
      dropdown.style.display = "block"
    }
  }

  // Handle clicks outside to close dropdown
  handleClickOutside(event) {
    if (!this.userMenuTarget.contains(event.target)) {
      this.dropdownTarget.style.display = "none"
    }
  }

  // Start resize operation
  startResize(event) {
    console.log("Start resize triggered", event)
    event.preventDefault()
    
    this.isResizing = true
    this.startX = event.clientX
    
    // Get current sidebar width
    const sidebar = this.element
    const rect = sidebar.getBoundingClientRect()
    this.startWidth = rect.width
    
    console.log("Initial width:", this.startWidth)
    
    // Add mouse event listeners for resize
    document.addEventListener("mousemove", this.boundMouseMove)
    document.addEventListener("mouseup", this.boundMouseUp)
    
    // Add visual feedback
    document.body.style.cursor = "col-resize"
    document.body.style.userSelect = "none"
  }

  // Handle mouse move during resize
  handleMouseMove(event) {
    if (!this.isResizing) return
    
    event.preventDefault()
    
    const deltaX = event.clientX - this.startX
    const newWidth = this.startWidth + deltaX
    
    // Convert to viewport width percentage
    const viewportWidth = window.innerWidth
    const newWidthVw = (newWidth / viewportWidth) * 100
    
    // Apply constraints: min 160px, max 25vw  
    const minWidthVw = (160 / viewportWidth) * 100
    const maxWidthVw = 25
    
    const constrainedWidthVw = Math.max(minWidthVw, Math.min(maxWidthVw, newWidthVw))
    
    // Update CSS custom property
    this.element.style.setProperty("--sidebar-width", `${constrainedWidthVw}vw`)
  }

  // End resize operation
  handleMouseUp(event) {
    if (!this.isResizing) return
    
    this.isResizing = false
    
    // Remove mouse event listeners
    document.removeEventListener("mousemove", this.boundMouseMove)
    document.removeEventListener("mouseup", this.boundMouseUp)
    
    // Remove visual feedback
    document.body.style.cursor = ""
    document.body.style.userSelect = ""
  }

  // Open task creation modal
  openTaskModal(event) {
    event.preventDefault()
    
    const modal = document.getElementById("create-task-modal")
    if (modal) {
      modal.style.display = "flex"
      
      // Get the modal controller and show it
      const modalController = this.application.getControllerForElementAndIdentifier(
        modal.querySelector("[data-controller='modal']"), 
        "modal"
      )
      if (modalController) {
        modalController.show()
      }
    }
  }
}