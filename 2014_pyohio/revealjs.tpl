<!DOCTYPE html>
<html$if(lang)$ lang="$lang$"$endif$>
<head>
  <meta charset="utf-8">
  <meta name="generator" content="pandoc">
$for(author-meta)$
  <meta name="author" content="$author-meta$" />
$endfor$
$if(date-meta)$
  <meta name="dcterms.date" content="$date-meta$" />
$endif$
  <title>$if(title-prefix)$$title-prefix$ - $endif$$pagetitle$</title>
  <meta name="apple-mobile-web-app-capable" content="yes" />
  <meta name="apple-mobile-web-app-status-bar-style" content="black-translucent" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
  <link rel="stylesheet" href="$revealjs-url$/css/reveal.min.css"/>
    <style type="text/css">code{white-space: pre;}</style>
$if(highlighting-css)$
    <style type="text/css">
$highlighting-css$
    </style>
$endif$
$if(css)$
$for(css)$
    <link rel="stylesheet" href="$css$"/>
$endfor$
$else$
    <link rel="stylesheet" href="$revealjs-url$/css/theme/simple.css" id="theme">
$endif$
  <link rel="stylesheet" media="print" href="$revealjs-url$/css/print/pdf.css" />
  <!--[if lt IE 9]>
  <script src="$revealjs-url$/lib/js/html5shiv.js"></script>
  <![endif]-->
$if(math)$
    $math$
$endif$
$for(header-includes)$
    $header-includes$
$endfor$
</head>
<body>
$for(include-before)$
$include-before$
$endfor$
  <div class="reveal">
    <div class="slides">

$if(title)$
<section>
    <h1 class="title">$title$</h1>
$if(subtitle)$
  <h1 class="subtitle">$subtitle$</h1>
$endif$
$for(author)$
    <h2 class="author">$author$</h2>
$endfor$
    <h3 class="date">$date$</h3>
</section>
$endif$
$if(toc)$
<section id="$idprefix$TOC">
$toc$
</section>
$endif$

$body$
    </div>
  </div>
$for(include-after)$
$include-after$
$endfor$

  <script src="$revealjs-url$/lib/js/head.min.js"></script>
  <script src="$revealjs-url$/js/reveal.min.js"></script>

  <script>

      // Full list of configuration options available here:
      // https://github.com/hakimel/reveal.js#configuration
      Reveal.initialize({
        controls: true,
        progress: true,
        history: true,
        center: true,
        theme: $if(theme)$'$theme$'$else$Reveal.getQueryHash().theme$endif$, // available themes are in /css/theme
        transition: 'linear',
        parallaxBackgroundImage: 'static/images/ballet.jpg',
        parallaxBackgroundSize: '1600px 768px',

        // Optional libraries used to extend on reveal.js
        dependencies: [
          { src: '$revealjs-url$/lib/js/classList.js', condition: function() { return !document.body.classList; } },
          { src: '$revealjs-url$/plugin/zoom-js/zoom.js', async: true, condition: function() { return !!document.body.classList; } },
          { src: '$revealjs-url$/plugin/notes/notes.js', async: true, condition: function() { return !!document.body.classList; } },
//          { src: '$revealjs-url$/plugin/search/search.js', async: true, condition: function() { return !!document.body.classList; }, }
//          { src: '$revealjs-url$/plugin/remotes/remotes.js', async: true, condition: function() { return !!document.body.classList; } }
]});
    </script>
  </body>
</html>