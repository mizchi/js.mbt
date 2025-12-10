///| Tests for helmet bindings

///| Basic module tests

///|
test "helmet module can be imported" {
  let h = helmet()
  inspect(@core.typeof_(h), content="function")
}

///|
test "helmet with options" {
  let h = helmetWithOptions(hidePoweredBy=true, noSniff=true, xssFilter=false)
  inspect(@core.typeof_(h), content="function")
}

///| Individual middleware creation tests

///|
test "contentSecurityPolicy middleware" {
  let middleware = contentSecurityPolicy()
  inspect(@core.typeof_(middleware), content="function")
}

///|
test "contentSecurityPolicy with directives" {
  let directives = cspDirectives(
    defaultSrc=["'self'"],
    scriptSrc=["'self'", "'unsafe-inline'"],
    styleSrc=["'self'", "https://fonts.googleapis.com"],
  )
  let middleware = contentSecurityPolicy(directives~)
  inspect(@core.typeof_(middleware), content="function")
}

///|
test "crossOriginEmbedderPolicy middleware" {
  let middleware = crossOriginEmbedderPolicy()
  inspect(@core.typeof_(middleware), content="function")
}

///|
test "crossOriginEmbedderPolicy with policy" {
  let middleware = crossOriginEmbedderPolicy(policy="require-corp")
  inspect(@core.typeof_(middleware), content="function")
}

///|
test "crossOriginOpenerPolicy middleware" {
  let middleware = crossOriginOpenerPolicy()
  inspect(@core.typeof_(middleware), content="function")
}

///|
test "crossOriginOpenerPolicy with policy" {
  let middleware = crossOriginOpenerPolicy(policy="same-origin")
  inspect(@core.typeof_(middleware), content="function")
}

///|
test "crossOriginResourcePolicy middleware" {
  let middleware = crossOriginResourcePolicy()
  inspect(@core.typeof_(middleware), content="function")
}

///|
test "crossOriginResourcePolicy with policy" {
  let middleware = crossOriginResourcePolicy(policy="cross-origin")
  inspect(@core.typeof_(middleware), content="function")
}

///|
test "dnsPrefetchControl middleware" {
  let middleware = dnsPrefetchControl()
  inspect(@core.typeof_(middleware), content="function")
}

///|
test "dnsPrefetchControl with allow option" {
  let middleware_allow = dnsPrefetchControl(allow=true)
  let middleware_deny = dnsPrefetchControl(allow=false)
  inspect(@core.typeof_(middleware_allow), content="function")
  inspect(@core.typeof_(middleware_deny), content="function")
}

///| Note: expectCt was removed in helmet 8.x as it's deprecated

///| See: https://github.com/helmetjs/helmet/issues/380

///|
test "frameguard middleware" {
  let middleware = frameguard()
  inspect(@core.typeof_(middleware), content="function")
}

///|
test "frameguard with action" {
  let middleware_deny = frameguard(action="deny")
  let middleware_sameorigin = frameguard(action="sameorigin")
  inspect(@core.typeof_(middleware_deny), content="function")
  inspect(@core.typeof_(middleware_sameorigin), content="function")
}

///|
test "hidePoweredBy middleware" {
  let middleware = hidePoweredBy()
  inspect(@core.typeof_(middleware), content="function")
}

///|
test "hsts middleware" {
  let middleware = hsts()
  inspect(@core.typeof_(middleware), content="function")
}

///|
test "hsts with options" {
  let middleware = hsts(maxAge=31536000, includeSubDomains=true, preload=true)
  inspect(@core.typeof_(middleware), content="function")
}

///|
test "ieNoOpen middleware" {
  let middleware = ieNoOpen()
  inspect(@core.typeof_(middleware), content="function")
}

///|
test "noSniff middleware" {
  let middleware = noSniff()
  inspect(@core.typeof_(middleware), content="function")
}

///|
test "originAgentCluster middleware" {
  let middleware = originAgentCluster()
  inspect(@core.typeof_(middleware), content="function")
}

///|
test "permittedCrossDomainPolicies middleware" {
  let middleware = permittedCrossDomainPolicies()
  inspect(@core.typeof_(middleware), content="function")
}

///|
test "permittedCrossDomainPolicies with policy" {
  let middleware = permittedCrossDomainPolicies(permittedPolicies="none")
  inspect(@core.typeof_(middleware), content="function")
}

///|
test "referrerPolicy middleware" {
  let middleware = referrerPolicy()
  inspect(@core.typeof_(middleware), content="function")
}

///|
test "referrerPolicy with policy" {
  let middleware = referrerPolicy(policy="no-referrer")
  inspect(@core.typeof_(middleware), content="function")
}

///|
test "xssFilter middleware" {
  let middleware = xssFilter()
  inspect(@core.typeof_(middleware), content="function")
}

///| CSP directives helper tests

///|
test "cspDirectives creates directives object" {
  let directives = cspDirectives(
    defaultSrc=["'self'"],
    scriptSrc=["'self'", "'unsafe-inline'"],
    styleSrc=["'self'", "https://fonts.googleapis.com"],
    imgSrc=["'self'", "data:", "https:"],
    connectSrc=["'self'"],
    fontSrc=["'self'", "https://fonts.gstatic.com"],
    objectSrc=["'none'"],
    mediaSrc=["'self'"],
    frameSrc=["'none'"],
    baseUri=["'self'"],
    formAction=["'self'"],
  )
  inspect(@core.typeof_(directives), content="object")
}

///|
test "cspDirectives with minimal options" {
  let directives = cspDirectives(defaultSrc=["'self'"])
  inspect(@core.typeof_(directives), content="object")
}
