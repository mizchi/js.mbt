// Simple worker that echoes messages back
import { parentPort, workerData } from "node:worker_threads";

if (parentPort) {
  // Send initial message with workerData
  parentPort.postMessage({ type: "init", workerData });

  // Echo back any messages received
  parentPort.on("message", (msg) => {
    parentPort.postMessage({ type: "echo", data: msg });
  });
}
