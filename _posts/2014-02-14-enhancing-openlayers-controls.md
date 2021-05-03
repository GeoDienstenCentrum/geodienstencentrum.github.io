---
layout: post
title: Enhancing OpenLayers control accessibility
date: 2014-02-14 18:31
author: prinsmc
language: en-GB
categories: [accessibility, webmapping]
tags: [accessibility, openlayers, wcag2]
description: Enhancing OpenLayers interoperability and keyboard accessibility by extending the default controls.
  A short description of some modifications and extensions of the original OpenLayers code.
image: 2014-02-14-enhancing-openlayers-controls.png
---

Most [OpenLayers](http://openlayers.org/) control widgets suffer from poorly designed or missing keyboard interoperability. Some attempts have been made to enhance ([1](http://wet-boew.github.io/wet-boew/docs/ref/geomap/geomap-en.html), [2](https://github.com/openlayers/openlayers/pull/425)) these shortcomings. However these changes and enhancements have not landed, are difficult to implement or carry a burden of extra javascript frameworks. Also they don't address some of the semantic issues that are present in OpenLayers generated markup.

I have extended some of the most used controls to be keyboard accessible and have enhanced usability by adding tooltips as part of the markup.

## Zoom control

The problem with the original zoom control is that it uses a hash hyperlink (`<a href="#" />` element) for something that is an action. Hyperlinks are supposed to navigate somewhere within a page with a consistent manner, eg. clicking the zoom in link should always take you to the same place within the page. This is not the case, clicking the link more than once does not always take you to the same place. The `anchor` element is really misused to emulate a button, people smarter than me have explained that [you can't create a button](http://www.nczonline.net/blog/2013/01/29/you-cant-create-a-button/) and [links are not buttons](http://www.karlgroves.com/2013/05/14/links-are-not-buttons-neither-are-divs-and-spans/).

_Note that the before/after code snippets below have been abbreviated by shortening style, class and id attributes._

### Before
Markup of the original:

```html
<div id="..." class="..."
    unselectable="on" style="...">
  <a href="#zoomIn" class="olControlZoomIn olButton">+</a>
  <a href="#zoomOut" class="olControlZoomOut olButton">-</a>
</div>
```

### After
The enhancement consists of replacing the `anchor` element with a `button`. The good thing of using a `button` is that it allows for additional markup inside the element, giving us room for a tooltip. The tooltip `span` element of the button is made visible on :hover and :focus using regular css, the tooltip also greatly enhances screen reader interoperability.

Modified and enhanced markup:

```html
<div id="..." class="..."
    unselectable="on" style="...">
  <button class="olControlZoomIn olButton olHasTooltip_bttm_r">
    <span role="tooltip">Zoom in</span>
    +
  </button>
  <button class="olControlZoomOut olButton olHasTooltip_bttm_r">
    <span role="tooltip">Zoom uit</span>
    −
  </button>
</div>
```

These modifications were proposed in [PR
1708](https://github.com/openlayers/ol3/pull/1708) and [PR 1249](https://github.com/openlayers/openlayers/pull/1249)

## LayerSwitcher

The LayerSwitcher suffers from some of the same problems as noted above, with the difference that the buttons to activate (expand / collapse) the control are actually `div`'s with images with an associated mouseclick handler. The bigger (compared to hyperlinks) problem with this is that these are only available to users with a pointing device.

### Before
Markup of the original:

```html
<div id="..." class="olControlLayerSwitcher..."
    unselectable="on" style="...">
  <div id="..." class="layersDiv" style="display: none;">
  <div class="baseLbl">Achtergrondkaart</div>
  <div class="baseLayersDiv">
    <input id="..." name="..." type="radio"
      value="0 buffer: OpenLayers WMS"
      checked="" class="olButton">
    <label class="labelSpan olButton"
      style="...">0 buffer: OpenLayers WMS</label>
    <br>
  </div>
  <div class="dataLbl" style="...">Overlays</div>
  <div class="dataLayersDiv">
  </div>
  </div>
  <div id="..." class="maximizeDiv olButton" style="...">
    <img id="..." class="..." src="../img/layer-switcher-maximize.png" style="...">
  </div>
  <div id="..." class="minimizeDiv olButton" style="...">
    <img id="..." class="..." src="../img/layer-switcher-minimize.png" style="...">
  </div>
</div>
```

### After

Again the solution here is to use the proper semantic element for the expand and collapse actions; a `button`. Next to that, to enhance usability, the buttons are moved to the top of the control so they end up as first element in the tab order. The images were replaced with the ubiquitous hamburger symbol `≡` for opening and a multiply symbol `×` for collapsing the popover. Also extra focus handling was applied so that when expanding the control focus is moved to the first option that can be selected and when closing the control focus is moved back to the map (the map's `div` element needs to be made programatically focusable by adding `tabindex="-1"`), next to that the selected option or checkbox remains selected until the LayerSwitcher is closed.

```html
<div id="..." class="olControlLayerSwitcher..."
    unselectable="on" style="...">
  <button name="show" class="maximizeDiv olButton..." style="...">
    <span role="tooltip">Toon kaartlagen</span>
      ≡
  </button>
  <button name="hide" class="minimizeDiv olButton..." style="">
    <span role="tooltip">Verberg kaartlagen</span>
      ×
  </button>
  <div id="..." class="layersDiv" style="">
    <div class="baseLbl">Achtergrondkaart</div>
      <div id="baseLayersDiv" class="baseLayersDiv">
        <input id="..." name="..." type="radio"
            value="OpenStreetMap" checked="" class="olButton">
        <label class="labelSpan olButton"
            style="...">OpenStreetMap</label>
        <br>
      </div>
      <div class="dataLbl">Overlays</div>
        <div class="dataLayersDiv">
          <input id="..." name="POI" type="checkbox"
              value="POI" checked="" class="olButton">
          <label class="labelSpan olButton"
              style="...">POI</label>
          <br>
        </div>
    </div>
  </div>
```
_This could be enhanced a little further by explicitly linking the `label` and the `input` elements using a `for` attribute or nesting the `input` elements inside their labeling element, however the above changes are enough to make the control keyboard operable._

<figure>
  <img src="/img/2014-02-14-enhancing-openlayers-controls.png" alt="Screen capture showing enhanced popup">
  <figcaption>The enhanced FramedCloud popup and KeyboardClick controls in action. Showing the tooltip on
  keyboard focus of the close button on the popup.</figcaption>
</figure>

## OverviewMap control

The OverviewMap is a widget that presents a small map with an indication of the bounding box of the parent map, the indicator may be moved using a pointing device thus doubling in function as a navigating tool as well. This control is using the same pattern as the LayerSwitcher.

### Before

```html
<div id="..." class="olControlOverviewMap..." unselectable="on" style="...">
  <div class="olControlOverviewMapElement">
    <div id="..." class="olMap" style="...">
      <div id="..." class="olMapViewport" style="...">
        <div id="..." style="...">
          <div id="..." dir="ltr" class="olLayerDiv olLayerGrid" style="...">
            <img class="olTileImage" src="..." style="...">
          </div>
        </div>
        <div class="olControlOverviewMapExtentRectangle" style="...">
        </div>
      </div>
    </div>
  </div>
  <div id="olControlOverviewMapMaximizeButton"
        class="olControlOverviewMapMaximizeButton olButton" style="...">
    <img id="olControlOverviewMapMaximizeButton_innerImage"
        class="olAlphaImg" src="../img/layer-switcher-maximize.png" style="...">
  </div>
  <div id="OpenLayers_Control_minimizeDiv"
        class="olControlOverviewMapMinimizeButton olButton" style="...">
    <img id="OpenLayers_Control_minimizeDiv_innerImage"
        class="olAlphaImg" src="../img/layer-switcher-minimize.png" style="...">
  </div>
</div>
```


### After
I've replaced the images with proper buttons like the LayerSwitcher and added tooltips. The navigation function hasn't been touched yet, my experience shows that even experienced users hardly know how to find this and is rarely used. Also since the map responds to the regular arrow keys on the keyboard, adding this function to the overview does not seem neccesary.

```html
<div id="..." class="olOverviewMap..." unselectable="on" style="...">
  <div class="olOverviewMapElement">
    <div id="..." class="olMap" style="...">
      <div id="..." class="olMapViewport" style="...">
        <div id="..." style="...">
          <div id="..." dir="ltr" class="olLayerDiv olLayerGrid" style="...">
            <img class="olTileImage" src="..." style="...">
          </div>
        </div>
        <div class="olOverviewMapExtentRectangle" style="...">
        </div>
      </div>
    </div>
  </div>
  <button name="show" class="olOverviewMapMaximizeButton
        olOverviewMapButton olButton olHasTooltip" style="...">
    <span role="tooltip">Toon overzicht</span>
    +
  </button>
  <button name="hide" class="olOverviewMapMinimizeButton
        olOverviewMapButton olButton olHasTooltip">
    <span role="tooltip">Verberg overzicht</span>
    ×
  </button>
</div>
```

## FramedCloud popup and feature info control

The information popup I tend to use most is the FramedCloud popup. It is the most feature rich of the available popups. The popup provides a dynamic panel floating over the map to show information to the user. Most commonly it will display attribute information of a feature in the map as a result of a user interaction with eg. a [SelectFeature](http://dev.openlayers.org/apidocs/files/OpenLayers/Control/SelectFeature-js.html) or a [FeatureInfo](http://dev.openlayers.org/apidocs/files/OpenLayers/Control/WMTSGetFeatureInfo-js.html) control.

Markup-wise this control isn't that interesting so I'll spare you the code. The problem with the popup is that because it uses a clickable `div` with a background image it firstly may be hard to find and secondly it won't react to key events, no focus, no click thus impossible to close without a pointing device. To fix it I inserted a tooltip enabled `button` as above and added a focus handler to move focus to the popup when it opens. When the popup is closed focus is moved back to the map.

To actually retrieve the attribute information in a keyboard friendly manner [Eric Lemoine](https://github.com/elemoine) created the [KeyboardClick](https://github.com/GeoDienstenCentrum/openlayers/blob/master/examples/accessible-click-control.js) control. This control enables moving a cursor on-screen using the arrow keys. With some additional code in the click handler it will select the first feature it finds closeby to the cursor.

```javascript
onClick : function(geometry) {
  var lyrs = this.selectControl.layers, selTarget;
  var px = this.map.getPixelFromLonLat(
               new OpenLayers.LonLat(geometry.x, geometry.y)
             );
  // create a small polygon around the click
  px = px.add(this.handler.STEP_SIZE * 1.5, 0);
  var lonlat = this.map.getLonLatFromPixel(px);
  var radius = Math.round(lonlat.lon - geometry.x);
  var sides = 8;
  var rotation = 0;
  var clicked = OpenLayers.Geometry.Polygon
                  .createRegularPolygon(geometry, radius, sides, rotation);

  // hit detection, the first intersection is a hit
  for (var resized = 1; resized < 4; resized++) {
    // try a few (resized-1) times with larger click polygon each time
    clicked = clicked.resize(resized, geometry);
    for (var i = 0; i < lyrs.length; i++) {
      if (lyrs[i].getVisibility()) {
        for (var f = 0; f < lyrs[i].features.length; f++) {
          selTarget = lyrs[i].features[f];
          if (clicked.intersects(selTarget.geometry)) {
            this.selectControl.clickFeature(selTarget);
            return;
          }
        }
      }
    }
  }
},
```

When using WMS or WMTS layers this code can be limited to passing the coordinate pair of the click location to a feature info control as is done in the [CBS viewer project](https://github.com/mprins/CBSviewer/blob/master/src/main/js/KeyboardClick.js#L52).

For some of the other javascript and Sass code you can look into the [openlayersmap](https://github.com/mprins/dokuwiki-plugin-openlayersmap/tree/master/javascript) [DokuWiki plugin](https://www.dokuwiki.org/plugin:openlayersmap) source tree.

[Talk about this on twitter](https://twitter.com/GeoDiensten/status/434063976347860992).
