import { Controller } from "@hotwired/stimulus"
import { startDuckDB, stopDuckDB } from "helpers/duckdb";

// Connects to data-controller="duckdb"
export default class extends Controller {
  static values = {
    databasePath: String,
  }

  async connect() {
    this.db = await startDuckDB(this.databasePathValue);
    window.duckdb = this.db;
    this.dispatch("ready");
  }

  async disconnect() {
    await stopDuckDB(this.db);
  }
}
