import { Controller } from "@hotwired/stimulus";

BigInt.prototype.toJSON = function () {
  return Number(this);
};

// Connects to data-controller="perspective--results"
export default class extends Controller {
  static targets = ["query", "results", "rowTemplate", "tableTemplate"];

  columnFormats = {
    date: value => this.formatDate(value),
  };

  async connect() {
    if (window.duckdb) {
      await this.executeQuery();
    } else {
      document.addEventListener(
        "duckdb:ready",
        async () => await this.executeQuery(),
        { once: true }
      );
    }
  }

  async executeQuery() {
    const query = this.queryTarget.value;
    if (!query) return;

    const conn = await window.duckdb.connect();
    try {
      const arrowResult = await conn.query(query);
      const result = arrowResult.toArray().map((row) => row.toJSON());
      this.displayResults(result);
    } catch (error) {
      this.displayError(error.message);
    } finally {
      await conn.close();
    }
  }

  displayResults(results) {
    if (!results.length) {
      this.resultsTarget.innerHTML = "<p>No results found</p>";
      return;
    }

    const table = this.tableTemplateTarget.content.cloneNode(true);
    const headers = Object.keys(results[0]);

    // Add headers
    const headerRow = table.querySelector("thead tr");
    headers.forEach(header => {
      const th = document.createElement("th");
      th.textContent = header;
      headerRow.appendChild(th);
    });

    // Add data rows
    const tbody = table.querySelector("tbody");
    results.forEach(row => {
      const tr = this.rowTemplateTarget.content.cloneNode(true);
      const rowElement = tr.querySelector("tr");

      headers.forEach(header => {
        const td = document.createElement("td");
        td.textContent = this.formatValue(header, row[header]);
        rowElement.appendChild(td);
      });

      tbody.appendChild(rowElement);
    });

    this.resultsTarget.innerHTML = "";
    this.resultsTarget.appendChild(table);
  }

  displayError(message) {
    this.resultsTarget.innerHTML = "<p>" + message + "</p>";
  }

  formatValue(header, value) {
    if (this.columnFormats[header]) {
      return this.columnFormats[header](value);
    }

    if (header.endsWith("_at")) {
      return this.formatDateTime(value);
    }

    return value;
  }

  formatDate(millis_as_string) {
    if (!millis_as_string) return "";
    const date = new Date(parseInt(millis_as_string));
    return date.toLocaleDateString().replace(/\//g, ".");
  }

  formatDateTime(millis_as_string) {
    if (!millis_as_string) return "";
    const date = new Date(parseInt(millis_as_string));
    return date.toLocaleString().replace(/\//g, ".").replace(/,/g, "");
  }
}
