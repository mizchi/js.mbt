///|
/// React event handler types with generic target element type
/// Similar to TypeScript's React.MouseEventHandler<T>

///|
/// React.MouseEventHandler<T>
/// Generic mouse event handler that receives the target element type
pub type MouseEventHandler[T] = (@dom.MouseEvent) -> Unit

///|
/// React.ChangeEventHandler<T>
/// Generic change event handler for form elements
pub type ChangeEventHandler[T] = (@dom.ChangeEvent) -> Unit

///|
/// React.KeyboardEventHandler<T>
/// Generic keyboard event handler
pub type KeyboardEventHandler[T] = (@dom.KeyboardEvent) -> Unit

///|
/// React.DragEventHandler<T>
/// Generic drag event handler
pub type DragEventHandler[T] = (@dom.DragEvent) -> Unit

///|
/// React.FocusEventHandler<T>
/// Generic focus event handler
pub type FocusEventHandler[T] = (@dom.FocusEvent) -> Unit

///|
/// React.FormEventHandler<T>
/// Generic form event handler
pub type FormEventHandler[T] = (@dom.Event) -> Unit

///|
/// React.TouchEventHandler<T>
/// Generic touch event handler
pub type TouchEventHandler[T] = (@dom.TouchEvent) -> Unit

///|
/// React.PointerEventHandler<T>
/// Generic pointer event handler
pub type PointerEventHandler[T] = (@dom.PointerEvent) -> Unit

///|
/// React.WheelEventHandler<T>
/// Generic wheel event handler
pub type WheelEventHandler[T] = (@dom.WheelEvent) -> Unit

///|
/// React.ClipboardEventHandler<T>
/// Generic clipboard event handler
pub type ClipboardEventHandler[T] = (@dom.ClipboardEvent) -> Unit

///|
/// React.AnimationEventHandler<T>
/// Generic animation event handler
pub type AnimationEventHandler[T] = (@dom.AnimationEvent) -> Unit

///|
/// React.TransitionEventHandler<T>
/// Generic transition event handler
pub type TransitionEventHandler[T] = (@dom.TransitionEvent) -> Unit
