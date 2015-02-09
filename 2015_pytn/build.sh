while ,watch -q -r .
do
    # Compile the slide show source to HTML
    rst2html.py \
        --smart-quotes=yes \
        --stylesheet-path=./static/pygments.css,./static/slides2.css \
        --link-stylesheet \
        --syntax-highlight=short \
        clean_and_green.rst | \
    sed 's/<body>/<body class="reading-mode">/;s/<h1>slide<\/h1>//;s/.*BLANKLINE.*//;s/# doctest.*//;' > \
    clean_and_green.html

    dot -Tpng shells.dot > shells.png
    dot -Tpng legacy.dot > legacy.png

    # Reload
    xdotool search --class --onlyvisible firefox key r

    # run the tests, including the doctests in the slideshow. Note that
    # even though it will run all of the doctests, py.test counts all of
    # them as a single test.
    py.test -sqx --doctest-glob=*.rst
done
