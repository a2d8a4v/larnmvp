
    if ( req.http.host == "www.yannyann_web_domain" || req.http.host == "yannyann_web_domain" ) {
      set req.backend_hint = default;
      set req.http.host = "yannyann_web_domain";
      if(req.method == "POST") {
        return (pass);
      }
    }
