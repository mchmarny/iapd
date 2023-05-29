# Cloud Armor policies 
resource "google_compute_security_policy" "policy" {
  name = "${var.name}-security-policy"

  rule {
    action      = "deny(403)"
    description = "owasp-crs-v030001 protocolattack"
    priority    = 901
    match {
      expr {
        expression = "evaluatePreconfiguredExpr('protocolattack-canary')"
      }
    }
  }

  rule {
    action      = "deny(403)"
    description = "owasp-crs-v030001 sessionfixation"
    priority    = 902
    match {
      expr {
        expression = "evaluatePreconfiguredExpr('sessionfixation-canary')"
      }
    }
  }

  rule {
    action      = "deny(403)"
    description = "owasp-crs-v030001 scannerdetection"
    priority    = 903
    match {
      expr {
        expression = "evaluatePreconfiguredExpr('scannerdetection-canary')"
      }
    }
  }

  rule {
    action      = "deny(403)"
    description = "owasp-crs-v030001 rce"
    priority    = 904
    match {
      expr {
        expression = "evaluatePreconfiguredExpr('rce-canary')"
      }
    }
  }

  rule {
    action      = "deny(403)"
    description = "owasp-crs-v030001 XSS"
    priority    = 905
    match {
      expr {
        expression = "evaluatePreconfiguredExpr('xss-canary')"
      }
    }
  }

  rule {
    action      = "deny(403)"
    description = "common crawlers"
    priority    = 1200
    match {
      expr {
        expression = "request.path.matches('/Autodiscover|/bin/|/ecp/|/owa/|/vendor/|/ReportServer|/_ignition|/index.php')"
      }
    }
  }

  rule {
    action   = "throttle"
    priority = 2147483647
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = ["*"]
      }
    }
    description = "default rule"

    rate_limit_options {
      conform_action = "allow"
      exceed_action  = "deny(429)"

      enforce_on_key = ""

      enforce_on_key_configs {
        enforce_on_key_type = "IP"
      }

      rate_limit_threshold {
        count        = var.rate_limit_threshold_min
        interval_sec = 60
      }
    }
  }
}
