
    if (req.http.X-Forwarded-Proto !~ "(?i)https" && req.http.host ~ "^(?i)yannyann_web_domain$" ) {
      set req.backend_hint = default;
