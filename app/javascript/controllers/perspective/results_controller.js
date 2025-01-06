import { Controller } from "@hotwired/stimulus";
import * as duckdb from "@duckdb/duckdb-wasm";

export default class extends Controller {
  static targets = ["results", "query"];

  async connect() {
    if (window.db) {
      this.db = window.db;
    } else {
      await this.initializeDuckDB();
      await this.loadData();
    }

    await this.executeQuery();
  }

  disconnect() {
    // if (this.db) {
    //   this.db.terminate();
    // }
  }

  async initializeDuckDB() {
    const bundles = duckdb.getJsDelivrBundles();
    const bundle = await duckdb.selectBundle(bundles);

    const worker_url = URL.createObjectURL(
      new Blob([`importScripts("${bundle.mainWorker}");`], {
        type: "text/javascript"
      })
    );

    const worker = new Worker(worker_url);
    const logger = new duckdb.ConsoleLogger();
    const db = new duckdb.AsyncDuckDB(logger, worker);
    await db.instantiate(bundle.mainModule, bundle.pthreadWorker);
    URL.revokeObjectURL(worker_url);
    this.db = db;
    window.db = db;
  }

  async loadData() {
    const response = await fetch("/databases/duckdb", {
      cache: "default"
    });

    const buffer = await response.arrayBuffer();
    await this.db.registerFileBuffer("database.duckdb", new Uint8Array(buffer));
    await this.db.open({
      path: "database.duckdb",
      query: {
        // castTimestampToDate: true
      }
    });
  }

  async executeQuery() {
    const conn = await this.db.connect();
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
