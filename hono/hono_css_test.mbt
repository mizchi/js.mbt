///|
/// Tests for hono/css with @core.tag integration

///|
async test "HonoCss::css - simple string" {
  let hono_css = @hono.import_hono_css()
  let cls = hono_css.css("color: red")
  let class_name = cls.to_string()
  // Should generate a class name (hashed)
  assert_true(class_name.length() > 0)
}

///|
async test "HonoCss::css - with interpolation" {
  let hono_css = @hono.import_hono_css()
  let color = "blue"
  let size = 20
  let cls = hono_css.css("color: ${@0}; font-size: ${@1}px", args=[
    @core.any(color),
    @core.any(size),
  ])
  let class_name = cls.to_string()
  // Should generate a class name (hashed)
  assert_true(class_name.length() > 0)
}

///|
async test "HonoCss::css - multiple values" {
  let hono_css = @hono.import_hono_css()
  let bg = "#fff"
  let fg = "#000"
  let padding = 10
  let cls = hono_css.css("background: ${@0}; color: ${@1}; padding: ${@2}px", args=[
    @core.any(bg),
    @core.any(fg),
    @core.any(padding),
  ])
  let class_name = cls.to_string()
  assert_true(class_name.length() > 0)
}

///|
async test "HonoCss::keyframes - simple string" {
  let hono_css = @hono.import_hono_css()
  let anim = hono_css.keyframes("from { opacity: 0 } to { opacity: 1 }")
  let anim_name = anim.to_string()
  // Should generate an animation name (hashed)
  assert_true(anim_name.length() > 0)
}

///|
async test "HonoCss::keyframes - with interpolation" {
  let hono_css = @hono.import_hono_css()
  let start_scale = 0.5
  let end_scale = 1.0
  let anim = hono_css.keyframes(
    "from { transform: scale(${@0}) } to { transform: scale(${@1}) }",
    args=[@core.any(start_scale), @core.any(end_scale)],
  )
  let anim_name = anim.to_string()
  assert_true(anim_name.length() > 0)
}

///|
async test "HonoCss::cx - combine classes" {
  let hono_css = @hono.import_hono_css()
  let cls1 = hono_css.css("color: red")
  let cls2 = hono_css.css("font-size: 16px")
  let combined = hono_css.cx([cls1, cls2])
  let class_name = combined.to_string()
  // Combined class should include both
  assert_true(class_name.length() > 0)
}
