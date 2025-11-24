///|
/// Benchmark for React element creation and rendering
// This benchmark tests the performance of creating complex nested components

///|
// Initialize a minimal React API for benchmarking (without Node.js)
extern "js" fn ffi_create_minimal_react_api() -> @js.Any =
  #|() => {
  #|  return {
  #|    createElement: (tag, props, children) => {
  #|      return { type: tag, props, children };
  #|    }
  #|  };
  #|}

///|
fn init_minimal_react_api() -> Unit {
  @react.init_react_api(ffi_create_minimal_react_api())
}

///|
/// Create a complex nested component tree simulating a typical web page
fn create_complex_component() -> @react.Element {
  div(id="app", [
    // Header section
    header([
      nav([
        ul([
          li([a(href="/", ["Home"])]),
          li([a(href="/about", ["About"])]),
          li([a(href="/products", ["Products"])]),
          li([a(href="/contact", ["Contact"])]),
        ]),
      ]),
      h1(["Welcome to Our Store"]),
    ]),
    // Main content section
    main_([
      article([
        h2(["Featured Products"]),
        div(class="product-grid", [
          // Product cards
          div(class="product-card", [
            img(src="/product1.jpg", alt="Product 1", []),
            h3(["Product 1"]),
            p(["Description of product 1 with some details."]),
            button(type_="button", ["Add to Cart"]),
          ]),
          div(class="product-card", [
            img(src="/product2.jpg", alt="Product 2", []),
            h3(["Product 2"]),
            p(["Description of product 2 with some details."]),
            button(type_="button", ["Add to Cart"]),
          ]),
          div(class="product-card", [
            img(src="/product3.jpg", alt="Product 3", []),
            h3(["Product 3"]),
            p(["Description of product 3 with some details."]),
            button(type_="button", ["Add to Cart"]),
          ]),
        ]),
      ]),
      aside([
        h3(["Categories"]),
        ul([
          li([a(href="/category/electronics", ["Electronics"])]),
          li([a(href="/category/clothing", ["Clothing"])]),
          li([a(href="/category/books", ["Books"])]),
          li([a(href="/category/home", ["Home & Garden"])]),
        ]),
      ]),
    ]),
    // Footer section
    footer([
      div([
        section([h4(["About Us"]), p(["We are a leading online retailer."])]),
        section([
          h4(["Contact"]),
          p(["Email: info@example.com"]),
          p(["Phone: 123-456-7890"]),
        ]),
        section([
          h4(["Follow Us"]),
          ul([
            li([a(href="https://facebook.com", ["Facebook"])]),
            li([a(href="https://twitter.com", ["Twitter"])]),
            li([a(href="https://instagram.com", ["Instagram"])]),
          ]),
        ]),
      ]),
    ]),
  ])
}

///|
/// Benchmark: Create complex component (element creation only)
test "benchmark: create complex component" (b : @bench.T) {
  init_minimal_react_api()
  b.bench(fn() { b.keep(create_complex_component()) })
}

///|
/// Benchmark: Create simple form with multiple inputs
fn create_form_component() -> @react.Element {
  form([
    div([
      label(["First Name:"], "firstName"),
      input(
        type_="text",
        id="firstName",
        name="firstName",
        placeholder="Enter first name",
      ),
    ]),
    div([
      label(["Last Name:"], "lastName"),
      input(
        type_="text",
        id="lastName",
        name="lastName",
        placeholder="Enter last name",
      ),
    ]),
    div([
      label(["Email:"], "email"),
      input(type_="email", id="email", name="email", placeholder="Enter email"),
    ]),
    div([
      label(["Message:"], "message"),
      textarea(id="message", placeholder="Enter your message", []),
    ]),
    div([
      label(["Country:"], "country"),
      select(id="country", name="country", [
        option(value="us", ["USA"]),
        option(value="ca", ["Canada"]),
        option(value="uk", ["UK"]),
        option(value="jp", ["Japan"]),
      ]),
    ]),
    button(type_="submit", ["Submit"]),
  ])
}

///|
test "benchmark: create form component" (b : @bench.T) {
  init_minimal_react_api()
  b.bench(fn() { b.keep(create_form_component()) })
}

///|

///|

///|
/// Benchmark: Create SVG chart
fn create_svg_chart() -> @react.Element {
  svg(width=400, height=300, [
    // Background
    rect(x=0, y=0, width=400, height=300, fill="white", stroke="black"),
    // Data bars
    rect(x=50, y=250, width=40, height=50, fill="blue"),
    rect(x=100, y=200, width=40, height=100, fill="blue"),
    rect(x=150, y=150, width=40, height=150, fill="blue"),
    rect(x=200, y=180, width=40, height=120, fill="blue"),
    rect(x=250, y=220, width=40, height=80, fill="blue"),
    // Labels
    text(x=200, y=30, ["Chart Title"]),
    text(x=70, y=280, ["2020"]),
    text(x=120, y=280, ["2021"]),
    text(x=170, y=280, ["2022"]),
    text(x=220, y=280, ["2023"]),
    text(x=270, y=280, ["2024"]),
  ])
}

///|
test "benchmark: create SVG chart" (b : @bench.T) {
  init_minimal_react_api()
  b.bench(fn() { b.keep(create_svg_chart()) })
}

///|
