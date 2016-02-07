---
layout: post
title: "DokuWikiSpatial: spatial indexing and search for your wiki"
date: 2014-09-17 10:00
author: prinsmc
language: en-GB
categories: [dokuwiki, webmapping]
tags: [seo, dokuwiki, dokuwikispatial, GeoCMS]
description: "Adding geohash based spatial indexing and search capabilities to DokuWiki."
image: 2014-09-17-findnearbyresult.png
---

## Indexing

Now that we can add location to our wiki pages using the [mapping]({% post_url 2014-04-14-dokuwikispatial_mapping %}) and [geotagging]({% post_url 2014-07-16-dokuwikispatial_geotag %}) plugins discussed in previous posts lets start making use of that data. Next to the <abbr title="Search Engine Optimization">SEO</abbr> benefits it would be nice to be able to use that data for generating information. To start off this data needs to be made searchable in a fast manner, this is done by creating a (spatial) index.

The chosen index algorithm is based on a value calculated from the coordinate pair, the [geohash](https://en.wikipedia.org/wiki/Geohash). This hash provides a one dimensional representation of a coordinate pair with the length of the hash being a measure for the accuracy of the coordinates. For example the coordinates `(57.64911 10.40744)` gives a hash of `u4pruydqqvj` and `(57.6 10.4)` gives a hash of `u4pru`. A big advantage is that this can be easily stored in an array with the geohash as a key and the resource(s) as value. Using PHP's built-in serialisation it is stored on disk in plain text, just like the other indexes and wiki metadata.

As part of the indexing both a [KML](https://en.wikipedia.org/wiki/Keyhole_Markup_Language) and a [GeoRSS](https://en.wikipedia.org/wiki/GeoRSS) file are generated, these can be served up as a spatial sitemap but may also be used in a map on the wiki. Also, as DokuWiki provides support for [EXIF](https://en.wikipedia.org/wiki/Exchangeable_image_file_format#Geolocation) data in images, when uploading JPEG or TIFF media into the wiki's media store these are added to the spatial index as well if they have the proper EXIF GPS tags.

## Searching

The most typical question for generating information is "What is near (to)?..." In case of the wiki resources this would yield one or more pages or images.

Looking back at the example above note that there is an overlap in the hash, this is another benefit of using the geohash. This allows selective matching implicitly enabling the use of a bounding box search ie. longer geohashes specify a more accurate location but in reverse also a smaller serach area.

A small drawback with using a geohash this way is that the positional error and boundingbox grow rapidly with shortening geohash length. For example, a geohash of five characters (`u4pru`) has an error of ±2.4km where a geohash that is three characters shorter (`u4`) has a positional error of ±630km. This means that when doing hash based lookups the actual search location is not static with shortening the hash/enlarging the bounds. This requires some more work, but for the initial 0.1 release of the [plugin](https://www.dokuwiki.org/plugin:spatialhelper) it is sufficient.

The plugin integrates with the geotag plugin to link to a page with dynamic search results. So a geotag with coordinates `48º11'36.384"N;16º27'39.06"E` links to `?do=findnearby&lat=48.19344&lon=16.46085` which initially does a lookup in the index for a geohash of `u2ednt67js`. This will render as a html page with a list of results. The search interface will be augmented to support other output formats, eg. a complete map or a GeoRSS document are also possibilities.

<figure id="screen">
  <img src="/img/2014-09-17-findnearbyresult.png" alt="search results screen capture">
  <figcaption>An example of a list of search results on a wiki page of a
        <a href="http://wild-water.nl/dokuwiki/start?do=findnearby&amp;geohash=u0urcr">
        findnearby to 50.62ºN;6.04ºE</a>.</figcaption>
</figure>

Some more examples are available on the [sample site](http://dokuwikispatial.sourceforge.net/dokuwiki/spatialhelper:start) and [wild-water.nl](http://wild-water.nl/dokuwiki/start?do=findnearby&geohash=u0urcr)

[Talk about this on twitter](https://twitter.com/GeoDiensten/status/512158204290408448).
