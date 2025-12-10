///| npm helmet package FFI bindings
/// https://github.com/helmetjs/helmet
/// https://www.npmjs.com/package/helmet
/// Help secure Express/Connect apps with various HTTP headers

///| Main helmet middleware - default export is a function

///|
#module("helmet")
extern "js" fn ffi_helmet() -> @core.Any = "default"

///|
#module("helmet")
extern "js" fn ffi_helmet_with_options(options : @core.Any) -> @core.Any = "default"

///|
/// Get the default helmet middleware with all protections enabled
pub fn helmet() -> @core.Any {
  ffi_helmet()
}

///|
/// Get helmet middleware with custom options
pub fn helmetWithOptions(
  contentSecurityPolicy? : @core.Any,
  crossOriginEmbedderPolicy? : Bool,
  crossOriginOpenerPolicy? : @core.Any,
  crossOriginResourcePolicy? : @core.Any,
  dnsPrefetchControl? : @core.Any,
  expectCt? : @core.Any,
  frameguard? : @core.Any,
  hidePoweredBy? : Bool,
  hsts? : @core.Any,
  ieNoOpen? : Bool,
  noSniff? : Bool,
  originAgentCluster? : Bool,
  permittedCrossDomainPolicies? : @core.Any,
  referrerPolicy? : @core.Any,
  xssFilter? : Bool,
) -> @core.Any {
  let opts = @core.new_object()
  match contentSecurityPolicy {
    Some(v) => opts["contentSecurityPolicy"] = v
    None => ()
  }
  match crossOriginEmbedderPolicy {
    Some(v) => opts["crossOriginEmbedderPolicy"] = @core.any(v)
    None => ()
  }
  match crossOriginOpenerPolicy {
    Some(v) => opts["crossOriginOpenerPolicy"] = v
    None => ()
  }
  match crossOriginResourcePolicy {
    Some(v) => opts["crossOriginResourcePolicy"] = v
    None => ()
  }
  match dnsPrefetchControl {
    Some(v) => opts["dnsPrefetchControl"] = v
    None => ()
  }
  match expectCt {
    Some(v) => opts["expectCt"] = v
    None => ()
  }
  match frameguard {
    Some(v) => opts["frameguard"] = v
    None => ()
  }
  match hidePoweredBy {
    Some(v) => opts["hidePoweredBy"] = @core.any(v)
    None => ()
  }
  match hsts {
    Some(v) => opts["hsts"] = v
    None => ()
  }
  match ieNoOpen {
    Some(v) => opts["ieNoOpen"] = @core.any(v)
    None => ()
  }
  match noSniff {
    Some(v) => opts["noSniff"] = @core.any(v)
    None => ()
  }
  match originAgentCluster {
    Some(v) => opts["originAgentCluster"] = @core.any(v)
    None => ()
  }
  match permittedCrossDomainPolicies {
    Some(v) => opts["permittedCrossDomainPolicies"] = v
    None => ()
  }
  match referrerPolicy {
    Some(v) => opts["referrerPolicy"] = v
    None => ()
  }
  match xssFilter {
    Some(v) => opts["xssFilter"] = @core.any(v)
    None => ()
  }
  ffi_helmet_with_options(opts)
}

///| Individual middleware functions with #module directive

///|
#module("helmet")
extern "js" fn ffi_contentSecurityPolicy() -> @core.Any = "contentSecurityPolicy"

///|
#module("helmet")
extern "js" fn ffi_contentSecurityPolicy_with_opts(
  opts : @core.Any,
) -> @core.Any = "contentSecurityPolicy"

///|
/// Content Security Policy middleware
#alias(content_security_policy)
pub fn contentSecurityPolicy(directives? : @core.Any) -> @core.Any {
  match directives {
    Some(v) => {
      let opts = @core.from_entries([("directives", v)])
      ffi_contentSecurityPolicy_with_opts(opts)
    }
    None => ffi_contentSecurityPolicy()
  }
}

///|
#module("helmet")
extern "js" fn ffi_crossOriginEmbedderPolicy() -> @core.Any = "crossOriginEmbedderPolicy"

///|
#module("helmet")
extern "js" fn ffi_crossOriginEmbedderPolicy_with_opts(
  opts : @core.Any,
) -> @core.Any = "crossOriginEmbedderPolicy"

///|
/// Cross-Origin-Embedder-Policy middleware
#alias(cross_origin_embedder_policy)
pub fn crossOriginEmbedderPolicy(policy? : String) -> @core.Any {
  match policy {
    Some(v) => {
      let opts = @core.from_entries([("policy", @core.any(v))])
      ffi_crossOriginEmbedderPolicy_with_opts(opts)
    }
    None => ffi_crossOriginEmbedderPolicy()
  }
}

///|
#module("helmet")
extern "js" fn ffi_crossOriginOpenerPolicy() -> @core.Any = "crossOriginOpenerPolicy"

///|
#module("helmet")
extern "js" fn ffi_crossOriginOpenerPolicy_with_opts(
  opts : @core.Any,
) -> @core.Any = "crossOriginOpenerPolicy"

///|
/// Cross-Origin-Opener-Policy middleware
#alias(cross_origin_opener_policy)
pub fn crossOriginOpenerPolicy(policy? : String) -> @core.Any {
  match policy {
    Some(v) => {
      let opts = @core.from_entries([("policy", @core.any(v))])
      ffi_crossOriginOpenerPolicy_with_opts(opts)
    }
    None => ffi_crossOriginOpenerPolicy()
  }
}

///|
#module("helmet")
extern "js" fn ffi_crossOriginResourcePolicy() -> @core.Any = "crossOriginResourcePolicy"

///|
#module("helmet")
extern "js" fn ffi_crossOriginResourcePolicy_with_opts(
  opts : @core.Any,
) -> @core.Any = "crossOriginResourcePolicy"

///|
/// Cross-Origin-Resource-Policy middleware
#alias(cross_origin_resource_policy)
pub fn crossOriginResourcePolicy(policy? : String) -> @core.Any {
  match policy {
    Some(v) => {
      let opts = @core.from_entries([("policy", @core.any(v))])
      ffi_crossOriginResourcePolicy_with_opts(opts)
    }
    None => ffi_crossOriginResourcePolicy()
  }
}

///|
#module("helmet")
extern "js" fn ffi_dnsPrefetchControl() -> @core.Any = "dnsPrefetchControl"

///|
#module("helmet")
extern "js" fn ffi_dnsPrefetchControl_with_opts(opts : @core.Any) -> @core.Any = "dnsPrefetchControl"

///|
/// X-DNS-Prefetch-Control middleware
#alias(dns_prefetch_control)
pub fn dnsPrefetchControl(allow? : Bool) -> @core.Any {
  match allow {
    Some(v) => {
      let opts = @core.from_entries([("allow", @core.any(v))])
      ffi_dnsPrefetchControl_with_opts(opts)
    }
    None => ffi_dnsPrefetchControl()
  }
}

///|
#module("helmet")
extern "js" fn ffi_frameguard() -> @core.Any = "frameguard"

///|
#module("helmet")
extern "js" fn ffi_frameguard_with_opts(opts : @core.Any) -> @core.Any = "frameguard"

///|
/// X-Frame-Options middleware
pub fn frameguard(action? : String) -> @core.Any {
  match action {
    Some(v) => {
      let opts = @core.from_entries([("action", @core.any(v))])
      ffi_frameguard_with_opts(opts)
    }
    None => ffi_frameguard()
  }
}

///|
#module("helmet")
extern "js" fn ffi_hidePoweredBy() -> @core.Any = "hidePoweredBy"

///|
/// Hide X-Powered-By middleware
#alias(hide_powered_by)
pub fn hidePoweredBy() -> @core.Any {
  ffi_hidePoweredBy()
}

///|
#module("helmet")
extern "js" fn ffi_hsts_with_opts(opts : @core.Any) -> @core.Any = "hsts"

///|
#module("helmet")
extern "js" fn ffi_hsts() -> @core.Any = "hsts"

///|
/// Strict-Transport-Security middleware
pub fn hsts(
  maxAge? : Int,
  includeSubDomains? : Bool,
  preload? : Bool,
) -> @core.Any {
  if maxAge is None && includeSubDomains is None && preload is None {
    return ffi_hsts()
  }
  let opts = @core.new_object()
  match maxAge {
    Some(v) => opts["maxAge"] = @core.any(v)
    None => ()
  }
  match includeSubDomains {
    Some(v) => opts["includeSubDomains"] = @core.any(v)
    None => ()
  }
  match preload {
    Some(v) => opts["preload"] = @core.any(v)
    None => ()
  }
  ffi_hsts_with_opts(opts)
}

///|
#module("helmet")
extern "js" fn ffi_ieNoOpen() -> @core.Any = "ieNoOpen"

///|
/// X-Download-Options middleware for IE8+
#alias(ie_no_open)
pub fn ieNoOpen() -> @core.Any {
  ffi_ieNoOpen()
}

///|
#module("helmet")
extern "js" fn ffi_noSniff() -> @core.Any = "noSniff"

///|
/// X-Content-Type-Options middleware
#alias(no_sniff)
pub fn noSniff() -> @core.Any {
  ffi_noSniff()
}

///|
#module("helmet")
extern "js" fn ffi_originAgentCluster() -> @core.Any = "originAgentCluster"

///|
/// Origin-Agent-Cluster middleware
#alias(origin_agent_cluster)
pub fn originAgentCluster() -> @core.Any {
  ffi_originAgentCluster()
}

///|
#module("helmet")
extern "js" fn ffi_permittedCrossDomainPolicies() -> @core.Any = "permittedCrossDomainPolicies"

///|
#module("helmet")
extern "js" fn ffi_permittedCrossDomainPolicies_with_opts(
  opts : @core.Any,
) -> @core.Any = "permittedCrossDomainPolicies"

///|
/// X-Permitted-Cross-Domain-Policies middleware
#alias(permitted_cross_domain_policies)
pub fn permittedCrossDomainPolicies(permittedPolicies? : String) -> @core.Any {
  match permittedPolicies {
    Some(v) => {
      let opts = @core.from_entries([("permittedPolicies", @core.any(v))])
      ffi_permittedCrossDomainPolicies_with_opts(opts)
    }
    None => ffi_permittedCrossDomainPolicies()
  }
}

///|
#module("helmet")
extern "js" fn ffi_referrerPolicy() -> @core.Any = "referrerPolicy"

///|
#module("helmet")
extern "js" fn ffi_referrerPolicy_with_opts(opts : @core.Any) -> @core.Any = "referrerPolicy"

///|
/// Referrer-Policy middleware
#alias(referrer_policy)
pub fn referrerPolicy(policy? : String) -> @core.Any {
  match policy {
    Some(v) => {
      let opts = @core.from_entries([("policy", @core.any(v))])
      ffi_referrerPolicy_with_opts(opts)
    }
    None => ffi_referrerPolicy()
  }
}

///|
#module("helmet")
extern "js" fn ffi_xssFilter() -> @core.Any = "xssFilter"

///|
/// X-XSS-Protection middleware (legacy, not recommended for modern browsers)
#alias(xss_filter)
pub fn xssFilter() -> @core.Any {
  ffi_xssFilter()
}

///| Helper functions for building CSP directives

///|
/// Create CSP directives object
#alias(csp_directives)
pub fn cspDirectives(
  defaultSrc? : Array[String],
  scriptSrc? : Array[String],
  styleSrc? : Array[String],
  imgSrc? : Array[String],
  connectSrc? : Array[String],
  fontSrc? : Array[String],
  objectSrc? : Array[String],
  mediaSrc? : Array[String],
  frameSrc? : Array[String],
  baseUri? : Array[String],
  formAction? : Array[String],
) -> @core.Any {
  let directives = @core.new_object()
  match defaultSrc {
    Some(v) => directives["defaultSrc"] = @core.any(v)
    None => ()
  }
  match scriptSrc {
    Some(v) => directives["scriptSrc"] = @core.any(v)
    None => ()
  }
  match styleSrc {
    Some(v) => directives["styleSrc"] = @core.any(v)
    None => ()
  }
  match imgSrc {
    Some(v) => directives["imgSrc"] = @core.any(v)
    None => ()
  }
  match connectSrc {
    Some(v) => directives["connectSrc"] = @core.any(v)
    None => ()
  }
  match fontSrc {
    Some(v) => directives["fontSrc"] = @core.any(v)
    None => ()
  }
  match objectSrc {
    Some(v) => directives["objectSrc"] = @core.any(v)
    None => ()
  }
  match mediaSrc {
    Some(v) => directives["mediaSrc"] = @core.any(v)
    None => ()
  }
  match frameSrc {
    Some(v) => directives["frameSrc"] = @core.any(v)
    None => ()
  }
  match baseUri {
    Some(v) => directives["baseUri"] = @core.any(v)
    None => ()
  }
  match formAction {
    Some(v) => directives["formAction"] = @core.any(v)
    None => ()
  }
  directives
}
