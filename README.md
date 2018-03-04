# Josh Schertz Personal Website

This is my website v2. My first site was in Wordpress, and it was slow and bloated. This new site is built on [Jekyll](https://jekyllrb.com/), which is a static web framework. This means that it is super fast!!

My website lists my main projects and my amazing blog posts.

Check it out [here](https://joshschertz.com).

## Installation

These are the instructions for running this Jekyll website locally. Check out the official [Jekyll installation](https://jekyllrb.com/docs/installation/) page for more help.

1. Install Ruby and Ruby development code:

`sudo apt install ruby ruby-all-dev`

Might also need to run the following to allow ffi and nokogiri to install:

`sudo apt install ruby-dev zlib1g-dev`

2. Install Jekyll with either:

`sudo apt install jekyll`

or

`gem install jekyll`

3. Install the bundle gems from within the main website folder:

`bundle install`

If the install fails due to the gems needing an update, run:

`bundle update`

4. Run the Jekyll preview server:

`bundle exec jekyll serve`

Sometimes `jekyll serve` works, but other times it throws an unknown error(?).

Enjoy!
