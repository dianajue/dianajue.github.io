# dianajue.github.io

Personal academic site for Diana Jue-Rajasingh. Static site on GitHub Pages,
served at **https://www.dianajue.com**.

- Repo: `dianajue/dianajue.github.io` (a GitHub Pages *user* site — the `main`
  branch is what's live)
- Built from the [Start Bootstrap Resume](https://startbootstrap.com/template-overviews/resume)
  template v5.0.2 (Bootstrap 4.1.3, jQuery 3.3.1, Font Awesome 5.3.1)
- The blog is Jekyll; the rest of the site is hand-written static HTML

## Blog status: not launched

The blog is built but deliberately not public yet:

1. All posts live in `_drafts/`, which Jekyll does not build. Nothing is served.
2. The **Blog** nav link in `index.html` is commented out.

`/blog/` itself is still reachable by direct URL and renders "No posts yet."

To launch: move the files from `_drafts/` into `_posts/` (they already carry
`YYYY-MM-DD-` prefixes, so it's a plain move), uncomment the nav link in
`index.html`, and push.

## ⚠️ Do not run the gulp build

`package.json` and `gulpfile.js` compile `scss/` → `css/resume.css` →
`css/resume.min.css`. **Both `scss/` and `css/resume.css` are stale.** The live
design exists only in `css/resume.min.css`, which has been hand-edited:

| Style | In `resume.min.css` | In `resume.css` | In `scss/` |
| --- | --- | --- | --- |
| Maroon palette (`#af103b`) | yes | yes | **no** — still the template's orange `#BD5D38` |
| `.about-banner`, `.banner-*` | yes | **no** | **no** |

Running `gulp` would revert the site to an orange template and delete the
homepage banner. Edit `css/resume.min.css` directly. Mirror the change into
`css/resume.css` if you like, but `index.html` only loads the `.min` file.

## Layout

```
index.html            Home page. Plain static HTML, no front matter, so Jekyll
                      copies it through untouched. Contains its own hard-coded
                      sidebar.
CNAME                 Custom domain (www.dianajue.com). Do not delete.
_config.yml           Jekyll config.
_layouts/             default.html (page shell), post.html (single post).
_includes/            head.html, sidebar.html, scripts.html.
_posts/               Published posts: YYYY-MM-DD-slug.md. Currently empty.
_drafts/              Not built by Jekyll, so never served. Date prefixes are
                      kept here so publishing is a move with no rename.
blog/index.html       Post listing at /blog/
blog/tags.html        Tag archive at /blog/tags/
css/resume.min.css    THE stylesheet (see warning above).
css/blog.css          Blog-only overrides, loaded after resume.min.css.
new-post.ps1          Scaffolds a new post.
img/  pdfs/  cvs/     Assets.
vendor/               Bootstrap, jQuery, Font Awesome. Must stay published —
                      that's why _config.yml's `exclude` list only names
                      vendor/{bundle,cache,gems,ruby}, never `vendor` itself.
```

## Colors

| Token | Hex |
| --- | --- |
| Primary (maroon) | `#af103b` |
| Link hover | `#824027` |
| Heading text | `#343a40` |
| Body text (site) | `#868e96` |
| Body text (post) | `#495057` |

Headings use `Saira Extra Condensed`, body uses `Muli`, both from Google Fonts.
Sitewide, all headings are uppercase and `h1` is `6rem` — `css/blog.css` undoes
both inside `.post-content` and `.post-title`, since that sizing is built for a
CV page, not prose.

## Writing a post

```powershell
.\new-post.ps1 "Your Title Here" -Tags research,fieldwork
```

That writes `_posts/YYYY-MM-DD-your-title-here.md` with front matter filled in.
Then write, and:

```powershell
git add . ; git commit -m "Add post: Your Title Here" ; git push
```

GitHub rebuilds in a minute or two. Post front matter:

```yaml
---
title: "Required"
date: 2026-08-06 09:00:00 -0500   # offset required; -0500 CDT, -0600 CST
tags: [research, teaching]        # optional; drives /blog/tags/
subtitle: Optional line under the title
image: /img/banner.jpg            # optional banner across the top
---
```

Conventions:

- The **first paragraph is the excerpt** shown on the blog index. Make it stand
  alone.
- Filenames must be `YYYY-MM-DD-slug.md`. Jekyll silently ignores files that
  don't match.
- Files must be **UTF-8 without BOM**. A BOM hides the front matter and the post
  vanishes from the build with no error. `new-post.ps1` handles this; if you
  create a file another way, check the encoding.
- Post URLs are `/blog/:year/:month/:day/:title/`. Changing `permalink` in
  `_config.yml` breaks every existing link.

## Editing the sidebar

The sidebar is duplicated in two places and both must be updated:

1. `index.html` — in-page anchors, each with `class="nav-link js-scroll-trigger"`
2. `_includes/sidebar.html` — the blog's copy, linking back to `/#anchor`

The `js-scroll-trigger` class comes from `js/resume.js` and smooth-scrolls to an
anchor on the *current* page. Cross-page links (Blog, CV) must not have it.

## Local preview

Ruby 3.3 (`C:\Ruby33-x64`, on the user PATH) with MSYS2/gcc is installed, so the
site builds locally:

```powershell
.\serve.ps1        # http://localhost:4000, drafts shown
.\serve.ps1 -NoDrafts   # exactly what the live site shows
```

`--drafts` renders `_drafts/` as if published — the only way to see a draft,
since Jekyll otherwise skips that folder entirely. LiveReload is on, so the
browser refreshes itself on save. `_config.yml` is the one file read only at
startup, so restart the server after editing it.

### Builds are slow, and the cause is Box

This repo lives under `C:\Users\dj55\Box\`, and Box's filesystem driver adds
roughly 24 ms of latency per file. With ~1,450 files (mostly `vendor/`) that
dominates everything:

| | Full build |
| --- | --- |
| In the Box folder | 91–109 s |
| Identical copy outside Box | **25 s** |

`serve.ps1` already applies the two fixes that don't require moving anything:
it builds to `%TEMP%` instead of `.\_site` (so Box isn't also syncing 13 MB of
output on every rebuild), and the `wdm` gem replaces Jekyll's polling watcher,
which was taking ~30 s just to notice an edit.

The remaining 4x is inherent to Box. Cloning the repo somewhere local
(`C:\Users\dj55\dev\`) and pushing from there would fix it — GitHub is already
the backup, so Box adds nothing here.

Ruby 3.3 specifically: `github-pages` pins Jekyll 3.10, which breaks on Ruby
3.4+ where `logger` and `csv` left the standard library. Don't upgrade Ruby
without checking that.

A plain static file server will *not* work in place of this: it won't process
Liquid, so `/blog/` renders as raw template tags.

## Things that will silently break the site

- **Deleting `CNAME`** — the custom domain reverts to `dianajue.github.io`.
  GitHub sometimes rewrites this file server-side, so `git pull` before pushing.
- **A YAML syntax error in `_config.yml` or in any post's front matter** — the
  whole build fails and the site stops updating. GitHub emails the repo owner.
- **Adding a Jekyll plugin that isn't on the
  [GitHub Pages allowlist](https://pages.github.com/versions/)** — builds run
  without it, so the feature just never appears. Currently used, all allowed:
  `jekyll-feed`, `jekyll-seo-tag`, `jekyll-sitemap`.
- **Liquid syntax in non-blog files** — `index.html` has no front matter so it's
  passed through verbatim, but if you ever add front matter to it, its inline
  `<script>` blocks with `{` and `}` may need `{% raw %}` fencing.

## Not built yet

Deliberately left out; add if wanted:

- **Pagination** — the index lists every post. Fine under ~50; past that, add
  `jekyll-paginate`.
- **Comments** — would need a third-party service, e.g.
  [utterances](https://utteranc.es) (GitHub issues as the comment store).
- **Per-tag pages** — tags currently resolve to anchors on `/blog/tags/` rather
  than standalone `/blog/tags/research/` pages, which would need a plugin or a
  stub file per tag.
