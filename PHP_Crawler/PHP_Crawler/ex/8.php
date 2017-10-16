<?php

$home = 'http://axe-level-1.herokuapp.com/lv3/';
$json_content=array();

$curl = curl_init($home);
curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
curl_setopt($curl, CURLOPT_COOKIEFILE, '');

$hasNext = true;

// $idx = 1;

while ($hasNext) {

  $html = curl_exec($curl);
  $doc = new DOMDocument;
  @$doc->loadHTML($html);
  $json_content = parsing($doc, $json_content);

  $nextUrl = getNextUrl($doc, $home);

  if ($nextUrl == '') {
    $hasNext = false;
  } else {
    curl_setopt($curl, CURLOPT_URL, $nextUrl);    	// udpate target url to the next link
  }
  
  /*
  if ($idx++ > 80) {
    break;
  }
  */
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

function getNextUrl($doc, $home) {
  
  $url = '';

  foreach ($doc->getElementsByTagName('a') as $tag_A) {
    $href = $tag_A->getAttribute('href');
    if (strpos($href, 'page=next') !== false) {
      $url = $home . $href;
    }
  }

  return $url;
}
