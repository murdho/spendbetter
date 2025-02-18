import * as duckdb from "@duckdb/duckdb-wasm";

export async function startDuckDB(databasePath) {
  if (!databasePath) {
    throw new Error("Cannot start DuckDB, invalid database path: '" + databasePath + "'");
  }

  const db = await initialize();
  await openDatabase(db, databasePath);
  return db;
}

export async function stopDuckDB(database) {
  if (database) {
    await database.close();
  }
}

async function initialize() {
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
  return db;
}

async function openDatabase(db, databasePath) {
  const response = await fetch(databasePath, {
    cache: "default"
  });

  const buffer = await response.arrayBuffer();
  await db.registerFileBuffer("database.duckdb", new Uint8Array(buffer));
  await db.open({
    path: "database.duckdb",
    query: {
      castTimestampToDate: true
    }
  });
}
