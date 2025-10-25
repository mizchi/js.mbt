// import { h, render } from "preact";
// import { useState } from "preact/hooks";
import React, {
  useState,
  useEffect,
  useCallback,
  useMemo,
  useRef,
} from "react";
import { createRoot } from "react-dom/client";
console.log("[js]Starting app...");

// @ts-ignore xxx
globalThis.ReactLib = {
  createElement: React.createElement,
  useState: useState,
  useMemo: useMemo,
  useEffect: useEffect,
  useRef: useRef,
  useCallback: useCallback,
  render(element: React.ReactElement, container: any) {
    const root = createRoot(container);
    root.render(element);
  },
};

async function js_main() {
  // @ts-ignore xxx
  await import("./target/js/release/build/examples/examples.js");
}

await js_main();
