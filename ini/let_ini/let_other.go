
package main

import (
    "crypto/tls"
    "golang.org/x/crypto/acme/autocert"
    "golang.org/x/net/http2"
    "net/http"
)

const (
    contactEmail = "yannyann_email_using"
    domain       = "yannyann_web_domain"
    certs        = "yannyann_golang_ssl_cert_dic"
)

func main() {
    // https://blog.wu-boy.com/2017/04/1-line-letsencrypt-https-servers-in-golang/
    // https://www.golangnote.com/topic/211.html
    // https://github.com/kjk/go-cookbook/blob/master/free-ssl-certificates/main.go#L77

    //go func(domain string) {
    //  http.ListenAndServe(":http", http.RedirectHandler("https://"+domain, 301))
    //}(domain)

    certManager := autocert.Manager{
        Prompt:     autocert.AcceptTOS,
        HostPolicy: autocert.HostWhitelist(domain),
        Cache:      autocert.DirCache(certs),     //folder for storing certificates
        Email:      contactEmail,
    }

    http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
        w.Write([]byte("www.YannYann.site ヤンヤン的研究之路"))
    })

    go http.ListenAndServe(":http", certManager.HTTPHandler(nil)) // 支持 http-01
    server := &http.Server{
        Addr: ":https",
        TLSConfig: &tls.Config{
            GetCertificate: certManager.GetCertificate,
            NextProtos:     []string{http2.NextProtoTLS, "http/1.1"},
            MinVersion:     tls.VersionTLS12,
        },
        MaxHeaderBytes: 32 << 20,
    }

    server.ListenAndServeTLS("", "") //key and cert are comming from Let's Encrypt
}
