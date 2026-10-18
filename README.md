# saeed-anwar.github.io

Academic website of Saeed Anwar, built with Jekyll and hosted on GitHub Pages.

## Updating content

| To change | Edit |
| --- | --- |
| Papers on /publications/ (and "Selected work" on the homepage) | `_data/publications.yml` |
| People on /people/ (the counts update themselves) | `_data/people.yml` |
| News, code and dataset lists on the homepage | `_layouts/home_editorial.html` |
| Profile links, menu, analytics, link-preview image | `_config.yml` |
| Other pages | `_layouts/<Page>.html` |

Tips:

- A news item can link to a paper with `/publications/?q=WORD`, where WORD appears in the paper's title. The link opens the list filtered to that paper.
- To feature a paper on the homepage, add `selected: true` to it. Add `teaser: /images/teasers/name.jpg` (16:9 works best) to show a picture on its card.
- The picture shown when a page is shared on LinkedIn, X, Slack or WhatsApp is `images/social-card.png` (1200 × 630).

## How the site is put together

- `_layouts/default.html` is the shared page frame: head, menu, sidebar, footer and scripts. Every page layout builds on it.
- Shared styles live in `assets/css/custom.css`; each page's own styles are in `assets/css/pages/`.
- Plugins (both supported by GitHub Pages): `jekyll-seo-tag` writes page titles, link-preview tags and search-engine data; `jekyll-sitemap` writes `sitemap.xml` and `robots.txt`.

## Running it locally

Needs Ruby 3 and Bundler.

```sh
bundle install
bundle exec jekyll serve
```

Then open http://localhost:4000.
