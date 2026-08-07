# Only needed to preview the site locally. GitHub Pages ignores this file and
# builds with its own pinned gem set.
#   bundle install
#   bundle exec jekyll serve --drafts
source "https://rubygems.org"

gem "github-pages", group: :jekyll_plugins
gem "webrick"

# Windows has no zoneinfo database, so `timezone:` in _config.yml raises
# TZInfo::DataSourceNotFound without these. Linux (i.e. GitHub) doesn't need
# them.
platforms :windows do
  gem "tzinfo", ">= 1", "< 3"
  gem "tzinfo-data"
  # Native filesystem notifications. Without it Jekyll polls, which took ~30s
  # to even notice an edit in this directory.
  gem "wdm", "~> 0.2"
end
