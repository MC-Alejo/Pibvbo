<?php
require_once __DIR__.'\includes\Page.php';

require_once __DIR__.'\mvc_controler\pagecontroller.php';

$page= new Page();

$page->setBody($body);

echo $page->getHtml();


?>