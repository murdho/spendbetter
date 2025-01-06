import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  initialize() {
    this.blaId = Math.floor(Math.random() * 1000000);
    this.log("initialized");
    window.addEventListener('beforeunload', () => this.disconnect());
  }

  connect() {
    this.log("connected");

    console.log("Controller element:", this.element.tagName);

    // Let's also watch Turbo events
    document.addEventListener("turbo:load", () => {
      this.log("turbo:load event");
    });

    document.addEventListener("turbo:visit", () => {
      this.log("turbo:visit event");
    });
  }

  disconnect() {
    this.log("disconnected");
  }

  log(event) {
    const timestamp = new Date().toISOString();
    console.log(`[BlaController ${this.blaId}] ${event} at ${timestamp}`);
  }
}
