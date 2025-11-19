///|
using @js {type Js, unsafe_cast, js}

///|
using @react {
  type ReactRef,
  trait ReactNode,
  createElementDirect,
  type MouseEventHandler,
  type ChangeEventHandler,
  type KeyboardEventHandler,
  type DragEventHandler,
  type FocusEventHandler,
  type FormEventHandler,
}

///|
/// Import DOM HTML element types
using @dom {
  type HTMLDivElement,
  type HTMLSpanElement,
  type HTMLButtonElement,
  type HTMLInputElement,
  type HTMLTextAreaElement,
  type HTMLFormElement,
  type HTMLSelectElement,
  type HTMLOptionElement,
  type HTMLLabelElement,
  type HTMLAnchorElement,
  type HTMLImageElement,
  type HTMLParagraphElement,
  type HTMLHeadingElement,
  type HTMLUListElement,
  type HTMLOListElement,
  type HTMLLIElement,
}
