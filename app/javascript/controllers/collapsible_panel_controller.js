import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content"]

  connect() {
    this.updateToggleIcon()
  }

  toggle() {
    const isCollapsed = this.element.classList.contains("collapsed")
    
    if (isCollapsed) {
      this.expand()
    } else {
      this.collapse()
    }
  }

  expand() {
    this.element.classList.remove("collapsed")
    this.contentTarget.setAttribute("aria-hidden", "false")
    this.element.querySelector(".panel-header").setAttribute("aria-expanded", "true")
    this.updateToggleIcon()
  }

  collapse() {
    this.element.classList.add("collapsed")
    this.contentTarget.setAttribute("aria-hidden", "true")
    this.element.querySelector(".panel-header").setAttribute("aria-expanded", "false")
    this.updateToggleIcon()
  }

  updateToggleIcon() {
    const toggle = this.element.querySelector(".panel-toggle")
    const isCollapsed = this.element.classList.contains("collapsed")
    
    if (toggle) {
      toggle.textContent = isCollapsed ? "▶" : "▼"
      toggle.setAttribute("aria-label", isCollapsed ? "Expand panel" : "Collapse panel")
    }
  }
}