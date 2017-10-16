<?php

$home = 'http://map.tgos.nat.gov.tw/TGOSCloud/Generic/Project/GHTGOSViewer_Map.ashx?pagekey=z718hbqgbo8fj+C8z1+db5eZe+AzzeO/';
$cookie = 'ASP.NET_SessionId=nuvhyffovawb4pjdleeciuzb; slb_cookie=3257746123.20480.0000; _ga=GA1.3.2022201933.1466050258; _gat=1';
$agent = 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.102 Safari/537.36';
//$post = 'method=querymoiaddr&address=臺北市市府路&useoddeven=false&sid=nuvhyffovawb4pjdleeciuzb';

$params = array();
$params['method'] = 'querymoiaddr';
$params['address'] = '臺北市市府路';
$params['useoddeven'] = 'false';
$params['sid'] = 'nuvhyffovawb4pjdleeciuzb';
$post = http_build_query($params);

$curl = curl_init($home);
curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
curl_setopt($curl, CURLOPT_USERAGENT, $agent);
curl_setopt($curl, CURLOPT_COOKIE, $cookie);
curl_setopt($curl, CURLOPT_REFERER, $home);
curl_setopt($curl, CURLOPT_POSTFIELDS, $post);
$content = curl_exec($curl);

echo $content;

