---
layout: post
title: "DokuWikiSpatial: maps for your wiki"
date: 2014-04-14 23:31
author: prinsmc
language: en-GB
categories: [webmapping, dokuwiki]
tags: [accessibility, dokuwiki, openstreetmap, openlayers, dokuwikispatial, GeoCMS]
description: "A brief introduction to DokuWiki and the mapping capabilities provided by the openlayersmap plugin."
image: 2014-04-12-openlayersmap.png
---

## Spatially enable your Wiki, part 1: mapping

In this series we will look at spatially enabling the DokuWiki system by adding mapping, data management and spatial indexing with the help of geotagging and other means. In general this functionality is described using the term GeoCMS and are provided as plugins by the [DokuwikiSpatial project](http://dokuwikispatial.sourceforge.net/dokuwiki/doku.php). In this first post we'll look at mapping after quick introduction to the base [DokuWiki](https://www.dokuwiki.org/) stack.


## About DokuWiki

The Dokuwiki software is a plain text driven PHP powered wiki engine with a well defined API and plugin mechanism. A big advantage of having a plain text storage is that you can easily run it from a USB stick (eg. [DokuWiki on a stick](https://www.dokuwiki.org/install:dokuwiki_on_a_stick) or [other portable methods](https://www.dokuwiki.org/install?s[]=portable#alternative_install_methods), another feature is that its easy to set up and manage because there is just the webserver to handle, contrary to most other wiki software that requires some sort of SQL-enabled back-end.

At the time I started using DokuWiki some seven years ago there were already some plugin's that allowed putting a map in a page, however these did not fit my bill of having free basemap data and user editable content for overlays or points of interest. Also they suffer from major accessibility issues. Having only a little experience using PHP at the time I looked into the plugin system and found a well [documented API](http://xref.dokuwiki.org/reference/dokuwiki/nav.html?index.html) and extensive list of samples kick-starting me to write my own mapping plugin for the wiki, [openlayersmap](https://www.dokuwiki.org/plugin:openlayersmap).

## Maps in your wiki

As the name suggests the openlayersmap pluging uses the [OpenLayers library](http://openlayers.org). It has a choice of both free and proprietary basemap options [OSM](http://www.openstreetmap.org/about) or [MapQuest](http://developer.mapquest.com/products/maps/) and Bing or Google if you really want that.

The latest version (4.0) of the openlayersmap plugin enables users to add wiki markup to a page that contains a simple configuration for the map such as dimensions, initial location and initial scale. It also allows for entering a list of points of interest with a descriptive text and a symbol layout (image, rotation, opacity). Next to having a list of points a GPX, KML or GeoJSON file may be loaded from the wiki's media directory. The POI data, just like the media files is actually part of the page/wiki so that it can be indexed and queried and the initial location of the map is added to the page metadata so it can be used by internal and external search engines.

<figure>
  <img src="/img/2014-04-12-openlayersmap.png" alt="screen capture an example map">
  <figcaption>An example of the slippy map showing a popup with a photograph of the Gumpen waterfall in the Loisach. The wiki markup for this is listed below</figcaption>
</figure>

``` html
<olmap id="olmap" width="660px" height="400px" lat="47.48" lon="10.98"
   zoom="13" statusbar="1" baselyr="landscape">
47.446383,10.918047,0,.8,stuw.png,Gumpen waterval \\
 {% raw %}{{http://www.hooidonksekanoclub.nl/fotoalbum/2009-05-hemelvaart/slides/IMG_7114.jpg?150|Gumpen waterval gezien van stroomaf"}}{% endraw %}
47.452819,10.923728,0,.8,uitstap.png,uitstap bovenloop Loisach
47.482083,10.989167,0,.8,instap.png,Instap Gschwandsteg
47.48146,11.04633,0,.8,uitstap.png, Uitstap "Zielhaus Grainau"
</olmap>
```

In the rendered page the map is available both as a static image with an associated table listing the points of interest and as slippy map that provides dynamic navigation and information display (progressive enhancement). The slippy map can be used (navigated and queried) using both the keyboard and pointing devices. (For more on this see: [Enhancing OpenLayers control  accessibility](/blog/accessibility/webmapping/2014-02-14/enhancing-openlayers-controls.html))
The static image and table are used when printing and may also be used by screen readers (actually this needs a little more work) and provide a fall-back mechanism should the browser not (properly) support javascript or CSS.

Stay tuned for other posts in this series on:

  - [geotagging]({% post_url 2014-07-16-dokuwikispatial_geotag %})
  - [indexing and search]({% post_url 2014-09-17-dokuwikispatial_indexing %})

[Talk about this on twitter](https://twitter.com/GeoDiensten/status/455822576007528448).
