### Out of the Yards

[Hakyll]: https://jaspervdj.be/hakyll/
[SASS]: http://sass-lang.com/
[Bower]: http://bower.io/

This site is built using [Hakyll][], a static site generator written in Haskell.
It also uses [SASS][] and [Bower][].

### Writing a new post
Images added to new posts should be 600px wide JPEGs or links to external images.
Ideally, images should have a 16:9 aspect ratio.

Images account for the largest portion of data required for each blog post, so
they should be compressed, if possible. To compress all of the images for a blog
post, run `tools/compress-images.sh posts/my-new-post/images`.

### Development
```bash
source ~/.bash_profile # set up PATH for rvm (SASS)
cabal run site watch
```

### Deployment
```
tools/deploy.sh
```
