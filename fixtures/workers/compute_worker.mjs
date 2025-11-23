// Worker that performs computations
import { parentPort } from "node:worker_threads";

if (parentPort) {
  parentPort.on("message", (msg) => {
    if (msg.type === "add") {
      const result = msg.a + msg.b;
      parentPort.postMessage({ type: "result", value: result });
    } else if (msg.type === "multiply") {
      const result = msg.a * msg.b;
      parentPort.postMessage({ type: "result", value: result });
    }
  });
}
