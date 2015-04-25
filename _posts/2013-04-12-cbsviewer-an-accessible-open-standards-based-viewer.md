---
layout: post
title: CBSviewer, an accessible, open standards based webmap viewer
date: 2013-04-12 15:31
author: prinsmc
language: en-GB
categories: [accessibility, webmapping]
tags: [accessibility, geotools, ogc, openlayers, openls, wcag2]
description: "Developing a webmapping application together with Statistics Netherlands to replace
  their current offerings of webmapping such as 'CBS in uw Buurt' which have various accessibility
  issues and has Google looking in over your shoulder."
image: 2013-04-12-screencapture.png
---

The past months I've been busy developing a web mapping application together with
[Statistics Netherlands](http://www.cbs.nl/) to replace their current offerings of web mapping such
as [CBS in uw Buurt](http://www.cbsinuwbuurt.nl/) which have various accessibility issues and has
Google looking in over your shoulder.
The new application can be used with both the keyboard and a mouse and and will fallback to a non
CSS and/or non Javascript version if needed (or requested) by the user providing a much better
and safer experience.

Key features of the application are:

  - open standards based interfaces [WMS](http://www.opengeospatial.org/standards/wms "Web Map Server specifications"),
    [WMTS](http://www.opengeospatial.org/standards/wmts "Web Map Tile Service specifications"),
    [OpenLS LUS](http://www.opengeospatial.org/standards/ols "Open Location Service specification")
    and [WCAG](http://www.w3.org/TR/WCAG/ "Web Content Accessibility Guidelines specification")
  - easy modification using [maven war overlay techniques](http://maven.apache.org/plugins/maven-war-plugin/overlays.html "WAR Overlays")
    (as an example you can look into the [NOK viewer project on Github](https://github.com/MinELenI/NOKviewer)
  - easy to localize using property files / resource bundles for all the text
  - easy to configure thematic maps using a set of xml files
  - easy styling adjustments using Sass and modular CSS

The project builds on well documented, well supported and proven open source libraries such as
[GeoTools](http://www.geotools.org/), [OpenLayers](http://openlayers.org/), [jQuery](http://jquery.com/)
and [jQuery UI](http://jqueryui.com/).

We're not quite there yet but you can follow the progress of the project through the
[Github site](http://mineleni.github.io/CBSviewer/)

<figure>
  <img src="/img/2013-04-12-screencapture.png" alt="screen capture of the application">
  <figcaption>Rich client screen showing WOZ (property tax) values aggregrated to 100m blocks</figcaption>
</figure>

[This post was previously published](https://gispunt.wordpress.com/2013/04/12/cbsviewer-an-accessible-open-standards-based-viewer/)
on GISpunt.
