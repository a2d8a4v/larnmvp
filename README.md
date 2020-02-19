#########################################################################################################################
## Version : 0.0.7-1
## Developer : Yannyann (https://github.com/a2d8a4v)
## Website : https://www.yannyann.com
## License : MIT License
#########################################################################################################################

# LARNMVP VERSION 0.0.7-1

"larnmvp" is the abbreviate of Liunx, Aapche, Redis, Nginx, Mariadb, Varnish and Php.

It an automatic unattended scirpt shell written by bash command for installing Apache 2.4, Nginx 1.17, Varnish 6.3, Redis 5, PHP 7.4 running on Ubuntu 18.04.2 LTS to build up a fast proxy server.

I am not sure whether Ubuntu 18.10 can use this program or not, for there is a problem with varnish package resources.

## 說明（Getting Started）

It is just my little projects for usually I have to test some VPS machine, but I have install thoes packages really tired my body; therefore, I script down all the command I need, also want to share with you how I install a proxy server by Apache 2.4, Nginx 1.17, Varnish 6.3, Redis 5, PHP 7.4.

But please notice that I only test on Ubuntu 18.04.2 LTS on Google Computer Engine before. This script should run smoothly on Linode VPS but, If you use Amazon Ec2 VPS, you should firest fix the sources.lists file in order to find the packages you need when running the script.

If you want to know more about the concept of Using proxy server with Nginx, Apache and Varnish, please visit my article.(Sorry this article have written in Traditional Chinese and I have no much time translate my article into English.)

Article -> [用 Varnish Nginx 和 Apache 製作 HTTP2 反向代理伺服器 | Wordpress- ヤンヤン的研究之路](https://www.yannyann.com/2018/03/wp-ssl-ubuntu-lamp-nginx-varnish-redis-6/)

## 功能列表（Functions menu）

1. 建立 Apache、Nginx、Varnish 的反向代理伺服器架構
2. 採用 MaraiDB 作為資料庫伺服器
3. 預先搭載 Redis 可透過 PHP 程式去連接，WordPress 也預先安裝「wp redis 外掛」可利用其進行資料庫快取功能。
4. 自動安裝申請 Let's encrypt 憑證（申請失敗的話也可以完成安裝程序，但憑證另外從系統端自行申請）
5. 自動完成 WordPress 5.3 安裝。系統端預設搭載 wp-cli 以方便管理。
6. 自動分割 SWAP 空間 3GB。
7. Fail2ban 防止基礎的 DDOS 攻擊、內建 UFW。
8. 內建 PostFix
9. 內建 phpMyAdmin
10. 方便開發者，所有相關開發需用的資訊，全部加密後透過 SSL 的方式傳送到我們的主機上。
11. 採用 BoringSSL, Redis 5.0.4, Nginx 1.17.8, Varnish 6.3.2 , Apache 2.4.39, MariaDB 10.4, WordPress 5.3.2, PHP 7.4
12. 預設啟用 SFTP 帳戶，已帳號密碼做驗證，暫時不使用密鑰登入。
13. 預設刪除 Ubuntu 帳戶，預設關閉 root 透過 ssh 登入的功能，預設建立別的隨機名稱的帳戶進行管理。
14. 預設會把資訊傳回給 Bigdata-mkt 主機相關資訊，資料演算法加密過後再透過加密方式傳送到 Bigdata-mkt 主機當中。
15. 救援模式，當安裝真的不幸中斷，自動傳回重要訊息到 Bigdata-mkt 主機當中。

## 支援的作業系統（OS system）

目前僅支援 Ubuntu 18.04.x lts

## 版本，新增/改善功能（Version）

-@ 0.0.7-1
1. 更新（安全）：WordPress 升級至 5.3.2，PHP 升級至 7.4，Nginx 升級至 1.17.8，Varnish 升級至 6.3.2

-@ 0.0.7
@@- 與伺服器運行有關
1. 更新（安全）：Nginx 升級至 1.16.0 Stable（僅限使用選擇源碼安裝的方式才提供，Google 維護的 Nginx 維持在 1.15.9）。
2. 新功能（穩定）：針對一開始是否選擇安裝 www 之時，決定 .htaccess 的轉網址寫法，影響 SEO。
3. 更新（安全）：改採用 Varnish 6.2.x，捨棄 6.0.x 長期支援版。
4. 更新（安全）：改採用 Apache2 的官方套件庫，即時得到更新檔案。
5. 新功能（穩定）：加入 keyboard-configuration 更新的靜默化安裝。
6. 更新（速度）：對於系統的速度和網路速度進行了調整。
7. 更新（速度）：對於 PHP 的設定檔案做仔細的效能改進，隨著主機等級而改變。
8. 新功能（穩定）：設定 SWAP 容量不超過硬碟的 10％。
9. 更新（穩定）：移除 main server 模組。
10. 新功能（穩定）：對於硬碟容量小於 10 GB 的電腦，可用的硬碟空間小於 8 GB 者，硬碟使用率超過 20% 者不可安裝。
11. 更新（穩定）：把 crontab 改採用直接把設定寫在 root 檔案當中的方式，防止 /tmp 清空時排程可能失效的問題。
12. 新增（穩定）：加入 DNS 設定檢驗，在開始安裝前，先確認有正確修改 DNS 設定。
13. 更新（安全）：對於 Email 驗證進行了修正。之前的網域只支援到一個分隔點 domain.tld，過去未支援更長的結尾。
14. 更新（安全）：對於網域驗證進一步嚴格化的修正，避免讓不合格的網域名稱通過。
15. 新功能（穩定）：透過 Nginx 的轉址設定，強制解決有無 www 時都可以順利轉址的問題。
ps. ## 不管網址有無 www，都需要再 DNS 當中設定一條給 www 的設定，才有辦法生效。
16. 更新 WordPress 至 5.2 版本號。
@@- 與 Larnmvp 安裝包有關
1. 更新（穩定）：對於透過 Golang 進行網域驗證的方式，進行了程式碼的修正，在 "&" 指令後加上 "wait $!" 來解決背景執行等待的問題。
2. 更新（穩定）：改善程式碼，crontab 排成獨立出來運作。
3. 更新（穩定）：對於一些特別的域名的支援，例如 .org.tw, .com.tw 等等
4. 新功能（穩定）：強制要求在 DNS 加入 www 紀錄，否則不給予安裝。

-@ 0.0.6-1
1. 加入 Caddy web server 的安裝選擇。
2. 優化程式碼的執行效率。優化許多細節的撰寫方式，防止腳本中斷。優化程式碼的執行架構，對程式碼進行保護措施。
3. 加入管理 Server 的架構，使此程式所建立出來的後端架構可以透過機制進行保護，並加密後透過 SSL 方式傳送。
4. 修復 crontab 的 bug。
5. 修正 SFTP 的 bug。一個導致無法上傳檔案的權限設定的錯誤。
6. 增加 hyperdb 的 WordPress 套件在裡面。
7. 因為安全性因素，取消在安裝好的機器裡面存放任何的機器相關資訊。
8. 優化 Nginx 設定檔案，增加 backup server 當 Varnish server 掛掉時還可以用 Apache server 承接。
9. 預設啟用 SFTP 帳戶，已帳號密碼做驗證，暫時不使用密鑰登入。
10. 預設刪除 Ubuntu 帳戶，預設關閉 root 透過 ssh 登入的功能，預設建立別的隨機名稱的帳戶進行管理。
11. 預設會把資訊傳回給 Bigdata-mkt 主機相關資訊，資料演算法加密過後再透過加密方式傳送到 Bigdata-mkt 主機當中。
12. 增加救援模式，當安裝真的不幸中斷，自動傳回重要訊息到 Bigdata-mkt 主機當中。

-@ 0.0.6
1. 移除手動輸入的安裝模式，將當中的驗證元素拆出，並改為自動安裝模式，讓驗證元素可以先在安裝前檢查安裝參數是否正確且數量完全。並且改寫自動安裝模式時，所有的密碼產生方式從原本自己手動寫入，全改成自動產生亂碼，並加入參數驗證檢查的功能，確認參數格式正確和每個參數都存在。
2. Varnish 設定優化，針對不同訪客使用的裝置把快取作區別，有效利用快取並減少快取數量。
3. 加入 SFTP 上傳功能（chroot jail）。
4. 更新 Nginx 至 1.15.9 mainline 版本號。保留 Google 維護的 Nginx 版本，版本號是 1.15.8。
5. 新增了把 WordPress 核心程式碼建立在另一個資料夾管理的功能，不和 .htaccess 等檔案放在一起，或是共同放在另外建立的資料夾當中（為了 SFTP 帳號登入做準備）。
6. 為了增強安全性，對於 wp-config.php 檔案進行的安全性優化（資料庫帳密另外方式保存、移動位置？、wp_prefix 贅頭改成隨機編碼）。
7. php 加入 php-ssh2 模組。

-@ 0.0.5
1. 採用 Google 的 BoringSSL 為預設，OpenSSL 改為選配，為了可以選擇使用兩種加密演算法（AES-GCM 或是 ChaCha20）。
2. 為了效能以及安裝時間能大幅度縮短，預設採用 Google 另外維護的 Nginx 版本，但原本的 Nginx 和 Openssl 可透過開關來進行選擇是否安裝。版本號由 Nginx 的 Stable 1.14.2 升級到 Mainline 1.15.8。
3. 在 Nginx 當中加入 websocket 設定、http2 push 啟用支援、加入 early data、Strict SNI 等功能。
4. 更新 Nginx moudles 的版本們並預先加入多種的 modules，方便之後的架構轉換。
5. 加入的一些 WordPress 預先搭載的外掛。
6. 優化 mariadb 的設定，防止在大資料庫下產生的大紀錄檔案，造成系統硬碟資源被用盡。
7. 修改 Varnish 設定，使檔案 cookie 重設而可以正常被 Varnish 快取。更新了幾項 Varnish 的設定檔案。
8. 修復了一個 WP_AD 變數的 bug，會導致 sed 指令失敗。新增辨識執行個體屬於哪一家公司的功能。
9. 加入了系統底層優化功能，開啟 BBR 模式。
10. 修復 Let's encrypt SSL 發行時 Python 的錯誤。
11. 改用 WordPress 5.1，為了解決跨大版本時 WordPress 會出現的一些不明錯誤。
12. 加入 測試版版本切換的功能。
13. 改用 PHP 7.3 版本。

-@ 0.0.4
1. Nginx 新增 TFO 功能、ip-geo module、gperftools module...等。
2. 修正 WordPress 時區問題
3. 新增 Lets encrypt 自動更新憑證功能。
4. PHP 可以選擇 7.3 版本安裝
5. 自動優化 Nginx 系統設定
6. 自動啟用 Redis 功能（注意：此功能在更換網站內容時須先進行清除的動作。對於 WordPress 的話，比較建議使用 W3TC 此快取外掛）
7. 修正 HTTP 沒有正確轉址到 HTTPS 的問題
8. 修訂 Varnish 的程式紀錄，納入 js/css 的快取。加入 Varnish 快取定時清除。
9. 可以記錄整個安裝過程。
10. 重新整理雜亂的設定檔案們，歸類於各自的資料夾當中。
11. 加入安裝完成後，自動清除各個帳戶裡面的操作記錄，以防危險。

-@ 0.0.3-1
1. 預先搭載 Redis 可透過 PHP 程式去連接，WordPress 也預先安裝「wp redis 外掛」可利用其進行資料庫快取功能。
2. 優化 PHP 可以選擇安裝版本的功能。

-@ 0.0.3
1. 優化安裝選單的項目和功能，新增如自訂「系統帳戶名稱和密碼」、「資料庫帳號密碼」。優化網域的驗證模式。
2. 優化憑證申請的過程，即使申請失敗也可以不中斷安裝。（但憑證另外從系統端自行申請）
3. 改用 WordPress 4.9.9。新增可以選擇 WordPress 要另外安裝在什麼資料夾的功能。

-@ 0.0.2
1. 加入 WordPress 4.9.8 自動安裝。
2. 加入自動申請 Lets encrypt 憑證。
3. 修正程式整體架構。修正幾個導致安裝無法正常進行的 bugs
4. 加入自動分割 SWAP 空間 3GB。
5. 開始內建 PostFix
6. 開始內建 phpMyAdmin

-@ 0.0.1（Initial project）
1. 建立 Apache、Nginx、Varnish 的反向代理伺服器架構
2. 建立可以自動化安裝或是預先手動設定之選單的安裝模式。

### 考慮新增的功能（Want to add in the future）
1. 加入 Caddy server 選項、traefik server 微服務選項。
2. 加入主機內核優化設定。（針對連線數擴增、效能）
3. 改用 docker 把所有服務給容器化。
4. 針對 log 檔案作統一管理系統
5. PHP 改從 7.2 到 7.3 版本。

## 作者（Authors）

* **李俊廷（LEE JIUN TING）* - *Initial work* - [a2d8a4v](https://github.com/a2d8a4v)


## 條款（ License ）

This project is licensed under the Apache License - see the [LICENSE](LICENSE) file for details
