import { Controller } from "@hotwired/stimulus";
import { startDuckDB } from "helpers";

// Connects to data-controller="duckdb"
export default class extends Controller {
  async initialize() {
    this.db = await startDuckDB();
    window.duckdb = this.db;

    // document.documentElement.dispatchEvent(
    //   new CustomEvent("duckdb:initialized")
    // );

    this.dispatch("ready");
  }
}
