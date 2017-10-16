<?php

$url  = 'https://www.ptt.cc/bbs/Gossiping/M.1465540420.A.CA6.html';

$curl = curl_init($url);
curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);			// MUST HAVE
curl_setopt($curl, CURLOPT_COOKIE, 'utma=156441338.2055474782.1466041013.1466041013.1466041272.2; __utmb=156441338.3.10.1466041272; __utmc=156441338; __utmz=156441338.1466041272.2.2.utmcsr=google|utmccn=(organic)|utmcmd=organic|utmctr=(not%20provided); over18=1');
$html = curl_exec($curl);
curl_close($curl);

$doc = new DOMDocument();	
@$doc->loadHTML($html);							// add @ to igore the warning message

$output = fopen('php://output', 'w');

foreach ($doc->getElementsByTagName('div') as $tag_DIV) {

  if ($tag_DIV->getAttribute('class') != 'push') {
    continue;
  }

  foreach ($tag_DIV->getElementsByTagName('span') as $tag_SPAN) {
  
    $clsValues = explode(' ', $tag_SPAN->getAttribute('class'));
    
    if (in_array('push-tag', $clsValues)) {
      $tag = trim($tag_SPAN->nodeValue);
    } else if (in_array('push-userid', $clsValues)) {
      $userid = trim($tag_SPAN->nodeValue);
    } else if (in_array('push-content', $clsValues)) {
      $content = trim($tag_SPAN->nodeValue);
    } else if (in_array('push-ipdatetime', $clsValues)) {
      $ipdatetime = trim($tag_SPAN->nodeValue);
    }

  }

  fputcsv($output, array($tag, $userid, $content, $ipdatetime));	// format $output as csv
}
