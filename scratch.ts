// import 
// import 'npm:@testing-library/js'
import "global-jsdom/register";
import React from 'react';
import {render, fireEvent, screen} from '@testing-library/react'
// import '@testing-library/jest-dom'
// import {render, fireEvent, screen} from '@testing-library/react';

function App(){
  return React.createElement('div', null, 'Hello, World!');
}

const app = render(React.createElement(App, null));
console.log("app", app)

// test('renders hello world', () => {
// import 'npm:@testing-library/jest-native/extend-expect'
// import "@testing-library/jest-dom"
// globalThis.expect = ( ) => {

// }
// globalThis.expect.extend = ( ) => {
// }
// await import("@testing-library/jest-dom")