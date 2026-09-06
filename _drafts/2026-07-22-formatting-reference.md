---
title: "Formatting Reference"
subtitle: "Every element the blog knows how to style"
date: 2026-07-22 10:00:00 -0500
tags: [meta]
---

PLACEHOLDER POST — this exists so you can see how each element renders. Delete
it once you have seen the styling. The paragraph you are reading now is the
post's *excerpt*: whatever sits above the first blank line is what shows on the
blog index.

## Headings and body text

Body text sits at a comfortable measure — about 70 characters per line — in a
darker gray than the rest of the site, because a CV page and a 1,200-word essay
have different readability needs.

### A third-level heading

You can **bold**, *italicize*, use `inline code`, and [link out](https://business.rice.edu/person/diana-jue-rajasingh).

## Lists

Unordered:

- Clean cookstoves
- Water treatment technologies
- Biodegradable sanitary products

Ordered:

1. Collect the data
2. Doubt the data
3. Collect more data

## Quotes

> Markets do not simply exist; they are made, and someone has to do the making.

## Footnotes

Claims can carry footnotes.[^1]

[^1]: And footnotes render at the bottom, separated by a rule.

## Tables

| Setting     | Method        | Year |
| ----------- | ------------- | ---- |
| East Africa | Mixed methods | 2019 |
| India       | Fieldwork     | 2021 |

## Code

```python
tidy = (df.query("year >= 2015")
          .groupby("country")
          .size())
```

## Images

Put blog image files in `img/blog/` and reference them with a leading slash.
Never put them in `_drafts/` -- Jekyll skips that whole folder, so the image
would 404 even after the post is published.

`![Description](/img/blog/your-image.jpg)`

The description is **alt text**. It is not displayed on the page; screen
readers read it aloud, and it appears if the image fails to load. Write it as
a plain description of what is in the picture.

### Captions

For a caption people can actually see, put an italic line directly under the
image with **no blank line between them**:

```
![A sheet of paper with a recipe written out by hand](/img/blog/recipe.png)
*Ammini's handwritten biriyani recipe.*
```

The missing blank line is what makes it a caption -- it keeps the two together
in one paragraph, which is what the stylesheet looks for. Leave a blank line
and you just get an ordinary italic sentence.

Images and captions are centred in the column automatically.

### Banner image

To run an image across the top of a post, set it in the front matter instead:

```yaml
image: /img/blog/your-image.jpg
image_alt: What is in the picture
image_caption: Caption shown under the banner
```
