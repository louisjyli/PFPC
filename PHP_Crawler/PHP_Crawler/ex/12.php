<?php

$home = 'http://jirs.judicial.gov.tw/FJUD/FJUDQRY02_1.aspx';
// $cookie = 'FJUDQRY01_1=16/1/0/0/0/0//0////////////%u5B8F%u9054%u570B%u969B//%u5B8F%u9054%u570B%u969B///////%u5B8F%u9054%u570B%u969B; ASP.NET_SessionId=isblaq55gxve52ypsvhdn345; BNES_ASP.NET_SessionId=wyhxCemIDKK1tke3zehspyKliDvhJQ1V7SB04jTD+JWkfdrLFf74OHVS57avKhDK7iX32xbIWWcz2lREO8T3Nx3O9mlkTm0iZnjgOxG37A0=';
// $agent = 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.102 Safari/537.36';
// $post = 'v_court=TPD+%E8%87%BA%E7%81%A3%E8%87%BA%E5%8C%97%E5%9C%B0%E6%96%B9%E6%B3%95%E9%99%A2&v_sys=M&jud_year=&sel_judword=%E5%B8%B8%E7%94%A8%E5%AD%97%E5%88%A5&jud_case=&jud_no=&jud_no_end=&jt=&dy1=&dm1=&dd1=&dy2=&dm2=&dd2=&jmain1=&kw=%E5%AE%8F%E9%81%94%E5%9C%8B%E9%9A%9B&keyword=%E5%AE%8F%E9%81%94%E5%9C%8B%E9%9A%9B&sdate=&edate=&jud_title=&jmain=&Button=+%E6%9F%A5%E8%A9%A2&searchkw=%E5%AE%8F%E9%81%94%E5%9C%8B%E9%9A%9B';

$params = array();
$params['v_court']     = iconv('utf-8', 'big5', 'TPD 臺灣臺北地方法院');
$params['v_sys']       = iconv('utf-8', 'big5', 'M');
$params['jud_year']    = iconv('utf-8', 'big5', '');
$params['sel_judword'] = iconv('utf-8', 'big5', '常用字別');
$params['jud_case']    = iconv('utf-8', 'big5', '');
$params['jud_no']      = iconv('utf-8', 'big5', '');
$params['jud_no_end']  = iconv('utf-8', 'big5', '');
$params['jt']          = iconv('utf-8', 'big5', '');
$params['dy1']         = iconv('utf-8', 'big5', '');
$params['dm1']         = iconv('utf-8', 'big5', '');
$params['dd1']         = iconv('utf-8', 'big5', '');
$params['dy2']         = iconv('utf-8', 'big5', '');
$params['dm2']         = iconv('utf-8', 'big5', '');
$params['dd2']         = iconv('utf-8', 'big5', '');
$params['jmain1']      = iconv('utf-8', 'big5', '');
$params['kw']          = iconv('utf-8', 'big5', '宏達國際');
$params['keyword']     = iconv('utf-8', 'big5', '宏達國際');
$params['sdate']       = iconv('utf-8', 'big5', '');
$params['edate']       = iconv('utf-8', 'big5', '');
$params['jud_title']   = iconv('utf-8', 'big5', '');
$params['jmain']       = iconv('utf-8', 'big5', '');
$params['Button']      = iconv('utf-8', 'big5', '查詢');
$params['searchkw']    = iconv('utf-8', 'big5', '宏達國際');
$post = http_build_query($params);

$curl = curl_init($home);
curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
//curl_setopt($curl, CURLOPT_USERAGENT, $agent);		// don't need
//curl_setopt($curl, CURLOPT_COOKIE, $cookie);			// don't need
curl_setopt($curl, CURLOPT_REFERER, $home);
curl_setopt($curl, CURLOPT_POSTFIELDS, $post);
$content = curl_exec($curl);

echo $content;

