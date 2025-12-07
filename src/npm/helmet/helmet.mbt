///| npm helmet package FFI bindings
/// https://github.com/helmetjs/helmet
/// https://www.npmjs.com/package/helmet
/// Help secure Express/Connect apps with various HTTP headers

///|
extern "js" fn helmet_module() -> @core.Any =
  #| () => require("helmet")

///| Main helmet middleware

///|
/// Get the default helmet middleware with all protections enabled
pub fn helmet() -> @core.Any {
  helmet_module()._invoke([])
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
  helmet_module()._invoke([opts])
}

///| Individual middleware functions

///|
/// Content Security Policy middleware
#alias(content_security_policy)
pub fn contentSecurityPolicy(directives? : @core.Any) -> @core.Any {
  let helmet = helmet_module()
  match directives {
    Some(v) => {
      let opts = @core.from_entries([("directives", v)])
      helmet["contentSecurityPolicy"]._invoke([opts])
    }
    None => helmet["contentSecurityPolicy"]._invoke([])
  }
}

///|
/// Cross-Origin-Embedder-Policy middleware
#alias(cross_origin_embedder_policy)
pub fn crossOriginEmbedderPolicy(policy? : String) -> @core.Any {
  let helmet = helmet_module()
  match policy {
    Some(v) => {
      let opts = @core.from_entries([("policy", @core.any(v))])
      helmet["crossOriginEmbedderPolicy"]._invoke([opts])
    }
    None => helmet["crossOriginEmbedderPolicy"]._invoke([])
  }
}

///|
/// Cross-Origin-Opener-Policy middleware
#alias(cross_origin_opener_policy)
pub fn crossOriginOpenerPolicy(policy? : String) -> @core.Any {
  let helmet = helmet_module()
  match policy {
    Some(v) => {
      let opts = @core.from_entries([("policy", @core.any(v))])
      helmet["crossOriginOpenerPolicy"]._invoke([opts])
    }
    None => helmet["crossOriginOpenerPolicy"]._invoke([])
  }
}

///|
/// Cross-Origin-Resource-Policy middleware
#alias(cross_origin_resource_policy)
pub fn crossOriginResourcePolicy(policy? : String) -> @core.Any {
  let helmet = helmet_module()
  match policy {
    Some(v) => {
      let opts = @core.from_entries([("policy", @core.any(v))])
      helmet["crossOriginResourcePolicy"]._invoke([opts])
    }
    None => helmet["crossOriginResourcePolicy"]._invoke([])
  }
}

///|
/// X-DNS-Prefetch-Control middleware
#alias(dns_prefetch_control)
pub fn dnsPrefetchControl(allow? : Bool) -> @core.Any {
  let helmet = helmet_module()
  match allow {
    Some(v) => {
      let opts = @core.from_entries([("allow", @core.any(v))])
      helmet["dnsPrefetchControl"]._invoke([opts])
    }
    None => helmet["dnsPrefetchControl"]._invoke([])
  }
}

///|
/// Expect-CT middleware (deprecated)
#alias(expect_ct)
pub fn expectCt(
  maxAge? : Int,
  enforce? : Bool,
  reportUri? : String,
) -> @core.Any {
  let helmet = helmet_module()
  let opts = @core.new_object()
  match maxAge {
    Some(v) => opts["maxAge"] = @core.any(v)
    None => ()
  }
  match enforce {
    Some(v) => opts["enforce"] = @core.any(v)
    None => ()
  }
  match reportUri {
    Some(v) => opts["reportUri"] = @core.any(v)
    None => ()
  }
  helmet["expectCt"]._invoke([opts])
}

///|
/// X-Frame-Options middleware
pub fn frameguard(action? : String) -> @core.Any {
  let helmet = helmet_module()
  match action {
    Some(v) => {
      let opts = @core.from_entries([("action", @core.any(v))])
      helmet["frameguard"]._invoke([opts])
    }
    None => helmet["frameguard"]._invoke([])
  }
}

///|
/// Hide X-Powered-By middleware
#alias(hide_powered_by)
pub fn hidePoweredBy() -> @core.Any {
  let helmet = helmet_module()
  helmet["hidePoweredBy"]._invoke([])
}

///|
/// Strict-Transport-Security middleware
pub fn hsts(
  maxAge? : Int,
  includeSubDomains? : Bool,
  preload? : Bool,
) -> @core.Any {
  let helmet = helmet_module()
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
  helmet["hsts"]._invoke([opts])
}

///|
/// X-Download-Options middleware for IE8+
#alias(ie_no_open)
pub fn ieNoOpen() -> @core.Any {
  let helmet = helmet_module()
  helmet["ieNoOpen"]._invoke([])
}

///|
/// X-Content-Type-Options middleware
#alias(no_sniff)
pub fn noSniff() -> @core.Any {
  let helmet = helmet_module()
  helmet["noSniff"]._invoke([])
}

///|
/// Origin-Agent-Cluster middleware
#alias(origin_agent_cluster)
pub fn originAgentCluster() -> @core.Any {
  let helmet = helmet_module()
  helmet["originAgentCluster"]._invoke([])
}

///|
/// X-Permitted-Cross-Domain-Policies middleware
#alias(permitted_cross_domain_policies)
pub fn permittedCrossDomainPolicies(permittedPolicies? : String) -> @core.Any {
  let helmet = helmet_module()
  match permittedPolicies {
    Some(v) => {
      let opts = @core.from_entries([("permittedPolicies", @core.any(v))])
      helmet["permittedCrossDomainPolicies"]._invoke([opts])
    }
    None => helmet["permittedCrossDomainPolicies"]._invoke([])
  }
}

///|
/// Referrer-Policy middleware
#alias(referrer_policy)
pub fn referrerPolicy(policy? : String) -> @core.Any {
  let helmet = helmet_module()
  match policy {
    Some(v) => {
      let opts = @core.from_entries([("policy", @core.any(v))])
      helmet["referrerPolicy"]._invoke([opts])
    }
    None => helmet["referrerPolicy"]._invoke([])
  }
}

///|
/// X-XSS-Protection middleware (legacy, not recommended for modern browsers)
#alias(xss_filter)
pub fn xssFilter() -> @core.Any {
  let helmet = helmet_module()
  helmet["xssFilter"]._invoke([])
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
