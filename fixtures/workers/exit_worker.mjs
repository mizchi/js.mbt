// Worker that exits after receiving a message
import { parentPort } from "node:worker_threads";

if (parentPort) {
  parentPort.on("message", (msg) => {
    if (msg.type === "exit") {
      parentPort.postMessage({ type: "exiting" });
      process.exit(msg.code || 0);
    }
  });
}
