
    if (req.http.X-Forwarded-Proto !~ "(?i)https" && req.http.host ~ "^(?i)yannyann_web_domain$" || req.http.host ~ "^(?i)www.yannyann_web_domain$" ) {
