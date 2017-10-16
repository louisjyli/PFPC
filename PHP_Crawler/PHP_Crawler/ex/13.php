<?php

$InitUrl = "https://www.ptt.cc/hotboard.html";
$curl = curl_init($InitUrl);
curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
curl_setopt($curl, CURLOPT_USERAGENT, 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.102 Safari/537.36');
$html = iconv('big5', 'utf-8//IGNORE', curl_exec($curl));

// ==== List the latest update time ===============================================================

preg_match_all("/最後更新時間(.*)\)/", $html, $matches);
print_r($matches);

// ==== List the hotboard articles info (ex1) =====================================================

preg_match_all('~<td width="100">(.*)</td>\s.*<a.*">(.*)</a>.*\s.*">(.*)</a>.*\s.*">(.*)</a>~', $html, $matches);
print_r($matches);

