---
layout: post
title: GEOZET, Building a dual-mode GIS webapp
date: 2010-07-06 15:53
author: prinsmc
language: en-GB
comments: true
categories: [accessibility, webmapping]
tags: [geotools, geozet, pdok]
description: Within the GEOZET viewer project an accessible GIS web viewer is being developed by Geonovum as one of the launching products of the PDOK programme.
image: 2010-07-06-geozet-core-screen.png
---

Within the GEOZET viewer project a dual mode GIS web application is being developed by [Geonovum](https://www.geonovum.nl/) as one of the launching products of the [PDOK programme](https://www.geonovum.nl/themas/pdok). Dual mode in this case being on the one hand a rich, map enabled client/GUI and on the other hand a lean non-javascript, non-css client/GUI for cases like screenreaders.
[Bart](http://www.osgis.nl/) has [written](http://osgisjs.blogspot.com/) about the OpenLayers based "rich" client in his posts, I'm working on the "core" version, that this post is about.

## Application

GEOZET viewer is a web application that provides access to government publications (government in this case the local, provincial and state governments and associations) through a geographic means. Publications are documents such as building, cutting, liquor and other permits and licenses, press releases, legislation and so forth. It has been commissioned by ICTU and will serve as the "launching application" of the PDOK motor project.

## Architecture Overview

In a quick overview we have three open standards based webservices;

  - A tile service for the base map, only used in the rich client,
  - an OpenLS service for the Gazetteer/Geocoding that will probably run on the
        [Adres Coordinaten Nederland](http://www.kadaster.nl/web/artikel/productartikel/Adrescoordinaten-Nederland.htm) database
  - and a WFS service that has geocoded metadata about the publications; this includes
        address data and a hyperlink to the publication.

The WFS service is specific for this application, the former two are part of the <a href="https://www.geonovum.nl/nieuws/pdok/update-van-stand-van-zaken-binnen-pdok"  data-proofer-ignore="true">PDOK infrastucture</a>. Because of some extra's that we need (like returning area's) we'll probably be building our own Gazetteer using Hibernate Spatial and Lucene, more about this some other time.

## Implementation

As part of this project I've been working on the WFS client that does the queries and renders the information based on user input. Two of the requirements to meet were easily transferable license(s) of the software stack between the hosting parties and platform independence. This boils down to using OpenSource toolkits on the Java platform. As most of the PDOK stack is based on [Geoserver](https://geoserver.org/) and [Postgis](https://postgis.refractions.net/) already our choice was easy, [GeoTools](https://geotools.org/). It's been quite a while since I've used GeoTools and a "first" look was quite overwhelming. I've opted to use the upcoming [2.7  release](https://docs.geotools.org/latest/userguide/welcome/upgrade.html#geotools-2-7) (which already has some milestones released) mainly because of the new, simplified Query and SimpleFeature objects that I need. This way implementing the WFS client, as a servlet, becomes a fairly straightforward exercise.

The servlet essentially receives query input from the user though a simple HTML form, using either POST or GET, a radius and a location and optionally some filter categories. The user doesn't actually see the location coordinate pair, just the placename they've entered and which has been sent to the Gazetteer for lookup.

<figure>
  <img src="/img/2010-07-06-geozet-core-screen.png" alt="User input form for GEOZET viewer">
  <figcaption>This information is used to create a CQL filter to retrieve information.</figcaption>
</figure>

```java
private Filter maakFilter(double xcoord, double ycoord, double straal,
		String[] categorieen) throws ServletException {

	Filter filter;
	final StringBuilder filterString = new StringBuilder();
	filterString.append("DWITHIN("
			+ this.schema.getGeometryDescriptor().getLocalName()
			+ ", POINT(" + xcoord + " " + ycoord + "), " + straal
			+ ", meters)");
	if (categorieen != null) {
		filterString.append(" AND (");
		for (int i = 0; i < categorieen.length; i++) {
			filterString.append(FILTER_CATEGORIE_NAAM + "='");
			filterString.append(categorieen[i]);
			filterString.append("'");
			if (i < categorieen.length - 1) {
				filterString.append(" OR ");
			}
		}
		filterString.append(")");
	}

	try {
		filter = CQL.toFilter(filterString.toString());
	} catch (final CQLException e) {
		throw new ServletException("CQL Fout in de query voor de WFS.", e);
	}
	return filter;
}
```

Once we have the filter constructed we can fire off a query to the WFS and the result is parsed and rendered in a HTML list to the client. This way the information becomes accessible to screenreaders and other types of small capability" devices. In the parsing of the response I also calculate the distance between the objects in the response and the requested place so that the list can be sorted based on this distance, I'm using the UserData Map on the feature to store this information and then the sort method from the Collections framework.

```java
protected Vector<SimpleFeature> ophalenBekendmakingen(Filter filter,
		double xcoord, double ycoord) throws ServletException, IOException {
	final Query query = new Query();
	try {
		query.setCoordinateSystem(CRS.decode("EPSG:28992"));
		query.setTypeName(this.typeName);
		query.setFilter(filter);
		query.setPropertyNames(Query.ALL_NAMES);
		query.setHandle("GEOZET-handle");
	} catch (final NoSuchAuthorityCodeException e) {
		throw new ServletException(
				"De gevraagde CRS autoriteit is niet gevonden.", e);
	} catch (final FactoryException e) {
		throw new ServletException(
				"Gevraagde GeoTools factory voor CRS is niet gevonden.", e);
	}

	final SimpleFeatureCollection features = this.source.getFeatures(query);

	final Point p = this.geometryFactory.createPoint(new Coordinate(xcoord,
			ycoord));

	double afstand = -1d;
	final Vector<SimpleFeature> bekendmakingen = new Vector<SimpleFeature>();

	final SimpleFeatureIterator iterator = features.features();
	try {
		while (iterator.hasNext()) {
			final SimpleFeature feature = iterator.next();
			afstand = p.distance((Geometry) feature
					.getDefaultGeometryProperty().getValue());
			feature.getUserData().put(AFSTAND_NAAM, afstand);
			bekendmakingen.add(feature);
		}
	} finally {
		iterator.close();
	}
	Collections.sort(bekendmakingen, new AfstandComparator());
	return bekendmakingen;
}
```

In a later stage we'll probably also provide a "REST like" url, I'm still not sure how to do this though as the URL should be something "human" readable/understandable; we might end up just supporting the location information and not the filter as that makes things much simpler.

> This project will go live on [overheid.nl](https://www.overheid.nl/) and be open sourced on the [Open Source Observatory and Repository](http://www.osor.eu/) (OSOR) November 1st, 2011.

[This post was previously  published](https://gispunt.wordpress.com/2010/07/06/geozet-building-a-dual-mode-gis-webapp/) on GISpunt.

