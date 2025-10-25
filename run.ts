// import { h, render } from "preact";
// import { useState } from "preact/hooks";
import React from "react";
import * as ReactApi from "react";

import { createRoot } from "react-dom/client";
console.log("[js]Starting app...");

// @ts-ignore xxx
globalThis.__ReactApi = {
  ...ReactApi,
  // createElement: React.createElement,
  // useState: useState,
  // useMemo: useMemo,
  // useEffect: useEffect,
  // useRef: useRef,
  // createContext: createContext,
  // useContext: useContext,
  // useCallback: useCallback,
  // Fragment: Fragment,
  render(element: React.ReactElement, container: any) {
    const root = createRoot(container);
    root.render(element);
  },
};

async function main() {
  // @ts-ignore xxx
  await import("./target/js/release/build/examples/examples.js");
}

await main();
