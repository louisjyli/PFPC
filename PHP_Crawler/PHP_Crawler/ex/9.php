<?php

$home = 'http://axe-level-4.herokuapp.com/lv4/';
$agent = 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.84 Safari/537.36';

$json_content=array();

$curl = curl_init($home);
curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
curl_setopt($curl, CURLOPT_USERAGENT, $agent);
curl_setopt($curl, CURLOPT_REFERER, $home);
$html = curl_exec($curl);

$doc = new DOMDocument();
@$doc->loadHTML($html);			                    	// add @ to igore the warning message

foreach ($doc->getElementsByTagName('a') as $tag_A) {

  $nextUrl = $home . $tag_A->getAttribute('href');
  curl_setopt($curl, CURLOPT_URL, $nextUrl);			// udpate target url to the next page link
  $html = curl_exec($curl);
  @$doc->loadHTML($html);  					// add @ to igore the warning message
  $json_content = parsing($doc, $json_content);
  // break;
}

curl_close($curl);

echo json_encode($json_content);			// encode data to json format via json_encode
// echo json_encode($json_content, JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT);

//==== Utility ======================================================================================

function parsing($doc, $ary) {

  $row = 1;
  foreach ($doc->getElementsByTagName('tr') as $tag_tr) {
    if ($row++ == 1) {
        continue;
    }

    $tag_tds = $tag_tr->getElementsByTagName('td');
    $town    = $tag_tds->item(0)->nodeValue;
    $village = $tag_tds->item(1)->nodeValue;
    $name    = $tag_tds->item(2)->nodeValue;
  
    $ary[] =  array('town' => $town, 'village' => $village, 'name' => $name);
  }

  return $ary;
}

