import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["results", "query"];

  async connect() {
    if (window.duckdb) {
      await this.executeQuery();
    } else {
      document.addEventListener("duckdb:ready",
        async () => await this.executeQuery(),
        { once: true }
      );
    }
  }

  async executeQuery() {
    const conn = await window.duckdb.connect();
    try {
      const query = this.queryTarget.value;
      const arrowResult = await conn.query(query);
      window.lastArrowResult = arrowResult;
      const result = arrowResult.toArray().map((row) => row.toJSON());
      this.displayResults(result);
    } catch (error) {
      this.displayError(error.message);
    } finally {
      await conn.close();
    }
  }

  displayResults(result) {
    this.resultsTarget.innerHTML = "<pre>" + JSON.stringify(result, null, 2) + "</pre>";
  }

  displayError(message) {
    this.resultsTarget.innerHTML = "<p>" + message + "</p>";
  }
}
