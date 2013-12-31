---
layout: post
title: Performance and uptime monitoring Inspire View service
date: 2011-09-06 12:56
author: prinsmc
comments: true
categories: [monitoring, performance]
tags: [inspire, performance, python, rrdtool, tooling]
language: en-GB
description: Measuring uptime and performance of an Inspire view service using a round-robin database and python.
---

The [Inspire directive](http://inspire.jrc.ec.europa.eu/ has some fairly strict requirements 
regarding performance and uptime of services (QOS) 
(see: [32009R0976 Annex 1](http://eur-lex.europa.eu/LexUriServ/LexUriServ.do?uri=CELEX:32009R0976:EN:NOT) 
and the [amendment](http://eur-lex.europa.eu/Result.do?RechType=RECH_celex&amp;lang=en&amp;ihmlang=en&amp;code=32010R1088). 
Monitoring these parameters can easily be done using a few Python scripts and RRDtool. This provides 
an environment that is both lightweight and portable across platforms.

[RRDtool](http://oss.oetiker.ch/rrdtool/index.en.html) has been around for ages and is a de-facto 
instrument for lightweight logging systems gathering large amounts of data. The database aggregates 
the input providing various algorithms such as average, max/min value as well as way more complex 
methods. The aggregation makes it possible to use the same database for years while the file size 
stays constant and the amount of information just keeps growing. Current versions of RRDtool provide 
Python bindings out of the box, however I chose to use [PyRRD](http://pypi.python.org/pypi/PyRRD/) 
because I was unsuccessful compiling them using Visual Studio 10 first time around.

I have chosen to monitor performance based on response time (the time needed for the initial byte 
to be received) and transfer time (the time needed for the last byte to be received).

<figure>
  <img src="/img/2011-09-06-ehs-4h.png" alt="graph showing 4h performance report">
  <figcaption>Performance measurements, note that responses also vary because of variations in 
  requested image size</figcaption>
</figure>

To prevent caching of the image a pseudo random bounding box and image size are used so that each 
request is unique, this generates some variance in the response size so the amount of data 
transferred (total bytes) for each request is also logged.

Next to that uptime is monitored based on the correct mimetype of the GetMap response, the assumption 
here is that a mimetype other that requested means there was an error in the service, thus 
un-availability, this is a rather coarse approach, but it works for me because there is a separate 
error log that provides the details of a failure.

<figure>
  <img src="/img/2011-09-06-ehs-1w-down.png" alt="graph showing 1 week downtime report">
  <figcaption>Any red line in this graph denotes a failure</figcaption>
</figure>

I have a batch file that runs the probe script every five minutes and create a graph every fifteen 
minutes, a HTML page is used to display the resulting graph as wel as provide access to the logfile 
and the last request.

[Browse or get the sourcecode.](https://sourceforge.net/u/mprins/code/1/tree/viewserviceprobe/)


[This post was previously published](http://gispunt.wordpress.com/2011/09/06/performance-and-uptime-monitoring-inspire-view-service/) on GISpunt.