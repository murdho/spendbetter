// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails";
import "controllers";

BigInt.prototype.toJSON = function () {
  return Number(this);
};

// // TODO: replace this hackery with proper setup in a right place
// import * as duckdb from "@duckdb/duckdb-wasm";
//
// const JSDELIVR_BUNDLES = duckdb.getJsDelivrBundles();
// const bundle = await duckdb.selectBundle(JSDELIVR_BUNDLES);
//
// console.log("Bundle", bundle);
//
// const worker_url = URL.createObjectURL(
//   new Blob([`importScripts("${bundle.mainWorker}");`], {
//     type: "text/javascript"
//   })
// );
//
// console.log(worker_url);
//
// // Instantiate the asynchronus version of DuckDB-wasm
// const worker = new Worker(worker_url);
// // const logger = null //new duckdb.ConsoleLogger();
// const logger = new duckdb.ConsoleLogger();
// const db = new duckdb.AsyncDuckDB(logger, worker);
// await db.instantiate(bundle.mainModule, bundle.pthreadWorker);
// URL.revokeObjectURL(worker_url);
// window._db = db;
//
// window.querydb = async query => {
//   const conn = await window._db.connect();
//   const arrowResult = await conn.query(query);
//   const result = arrowResult.toArray().map((row) => row.toJSON());
//   await conn.close();
//   return result;
// }
