<?php

$url  = 'https://www.ptt.cc/bbs/Gossiping/M.1465540420.A.CA6.html';
$form_url = 'https://www.ptt.cc/ask/over18';
$post = 'from=%2Fbbs%2FGossiping%2FM.1465540420.A.CA6.html&yes=yes';

$curl = curl_init($form_url);
curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);			// MUST HAVE
curl_setopt($curl, CURLOPT_COOKIEFILE, '');				// Eanble cookie handling
curl_setopt($curl, CURLOPT_POSTFIELDS, $post);
curl_exec($curl);							// trigger over19 checking to get the cookie

curl_setopt($curl, CURLOPT_URL, $url);					// change to target url when cookie data is ready
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
