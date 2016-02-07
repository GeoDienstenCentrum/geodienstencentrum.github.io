---
layout: post
title: "DokuWikiSpatial: geotagging for your wiki"
date: 2014-07-16 15:31
author: prinsmc
language: en-GB
categories: [webmapping, dokuwiki]
tags: [seo, microdata, dokuwiki, dokuwikispatial, GeoCMS]
description: "Adding geotagging capabilities to DokuWiki using a custom syntax plugin."
image: 2014-07-16-geotag.png
---

## Geotagging

After adding mapping capabilities to your wiki using the [openlayersmap plugin]({% post_url 2014-04-14-dokuwikispatial_mapping %}) we will now look into actually creating spatial data as part of your content using geotagging. [Geotagging](http://en.wikipedia.org/wiki/Geotagging) is the process of adding geographic (meta) data to content, in our case wiki pages.


To accomplish this a [syntax plugin](https://www.dokuwiki.org/plugin:geotag) was developed which allows adding the relevant data to the page. An example of this syntax is shown in the following code snippet.

```
{% raw %}
{{geotag>lat:48.19344, lon:16.46085, placename:VERBUND-Wasserarena,
    country:AT, region:AT-9}}
{% endraw %}
```

This syntax is parsed and rendered as part of the page metadata:

```html
...
<meta name="geo.region" content="AT-9"/>
<meta name="geo.placename" content="VERBUND-Wasserarena"/>
<meta name="geo.position" content="48.19344;16.46085"/>
<meta name="geo.country" content="AT"/>
<meta name="ICBM" content="48.19344, 16.46085"/>
<meta name="geo.geohash" content="u2ednt67js"/>
<meta name="DC.title" content="nieuwe Wildwaterbaan Donau Insel, Wenen"/>
...
```

This metadata is also stored in the wiki's metadata system so that it can be indexed and searched. When using a plugin such as [socialcards](https://www.dokuwiki.org/plugin:socialcards) the appropriate [OpenGraph](http://ogp.me/) elements are also exported in the page headers.

The geotag is rendered as part of the page content/body in the form of a [geo microformat](http://microformats.org/wiki/geo) and a [schema.org Place](http://schema.org/Place). This allows indexing of the page location by search engines such as [Yandex](https://help.yandex.com/webmaster/schema-org/semantic-faq.xml), [Bing](http://www.bing.com/webmaster/help/marking-up-your-site-with-structured-data-3a93e731)  and [Google](https://support.google.com/webmasters/answer/1211158).

```html
...
<span class="geotagPrint">Geotag (locatie) voor: </span>
<div class="geo" title="Geotag (locatie) voor VERBUND-Wasserarena"
    itemscope itemtype="http://schema.org/Place">
  <span itemprop="name">VERBUND-Wasserarena</span>:&nbsp;<a
     href="wildwaterbaan_donau_insel_wenen?do=findnearby&amp;lat=48.19344&amp;lon=16.46085"
     title="Zoek in de buurt van VERBUND-Wasserarena">
  <span itemprop="geo" itemscope itemtype="http://schema.org/GeoCoordinates">
  <span class="latitude" itemprop="latitude" content="48.19344">48º11'36.384"N</span>;
  <span class="longitude" itemprop="longitude" content="16.46085">16º27'39.06"E</span>
  <span class="a11y">Zoek in de buurt van VERBUND-Wasserarena</span></a></span>
</div>
...
```

Which looks something like the [figure](\#screen) below in the default DokuWiki layout.

<figure id="screen">
  <img src="/img/2014-07-16-geotag.png" alt="geotag example screen capture">
  <figcaption>An example of a rendered geotag on a wiki page locating the
    VERBUND-Wasserarena at 48º11'36.384"N;16º27'39.06"E.</figcaption>
</figure>

Using the geotags on your pages opens up other ways of exploring and viewing your pages. One example is using the content in an augmented reality application such as [Mixare](http://www.mixare.org/). Another is finding pages that are located nearby to the current page or using a map as a browsing interface for exploration of yout wiki.

Read more posts in this series on:

  - [mapping]({% post_url 2014-04-14-dokuwikispatial_mapping %})
  - [indexing and search]({% post_url 2014-09-17-dokuwikispatial_indexing %})


[Talk about this on twitter](https://twitter.com/GeoDiensten/status/489358340515176448).
