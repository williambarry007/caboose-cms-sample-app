// Load Google Maps API and initialize each Map block on the page

var info_windows = [];
var markers = [];
var locations = [];
var map = null;
var defaultCenter = null;
var mapCenterLat, mapCenterLng, mapDefaultZoom;

function get_markers() {
  $.ajax({
    url: "/api/map-markers",
    type: 'post',
    data: {
      block_id: window.map_block_id
    },
    success: function(data) {
      locations = data;
      initialize_maps();
    }
  });
}

function initialize_maps() {
	$(".locations-map-container").each(function(index, Element) {
		var mapel = $(Element).find(".map"); 
 		var mapCanvasId, style;
    mapCanvasId = mapel.attr("id");
    mapCenterLat = 32.5;
    mapCenterLng = -87.5;
    mapDefaultZoom = (typeof default_zoom !== 'undefined' && default_zoom != "") ? default_zoom : 12;
    if (typeof marker_icon_url !== 'undefined' && marker_icon_url != "") {
      markerIcon = new google.maps.MarkerImage(marker_icon_url, null, null, null, new google.maps.Size(35,56));
    }
    style_code = ''
    if ( typeof map_style_code !== 'undefined' && map_style_code != '' ) {
      style_code = map_style_code;
    }
    else {
      var style = mapel.data("style");
      if (style == "Grayscale") {
        style_code = [{'featureType':'landscape','stylers':[{'saturation':-100},{'lightness':65},{'visibility':'on'}]},{'featureType':'poi','stylers':[{'saturation':-100},{'lightness':51},{'visibility':'simplified'}]},{'featureType':'road.highway','stylers':[{'saturation':-100},{'visibility':'simplified'}]},{'featureType':'road.arterial','stylers':[{'saturation':-100},{'lightness':30},{'visibility':'on'}]},{'featureType':'road.local','stylers':[{'saturation':-100},{'lightness':40},{'visibility':'on'}]},{'featureType':'transit','stylers':[{'saturation':-100},{'visibility':'simplified'}]},{'featureType':'administrative.province','stylers':[{'visibility':'off'}]},{'featureType':'water','elementType':'labels','stylers':[{'visibility':'on'},{'lightness':-25},{'saturation':-100}]},{'featureType':'water','elementType':'geometry','stylers':[{'hue':'#ffff00'},{'lightness':-25},{'saturation':-97}]}];
      }
      else if (style == 'Pale') {
        style_code = [{'featureType':'water','stylers':[{'visibility':'on'},{'color':'#acbcc9'}]},{'featureType':'landscape','stylers':[{'color':'#f2e5d4'}]},{'featureType':'road.highway','elementType':'geometry','stylers':[{'color':'#c5c6c6'}]},{'featureType':'road.arterial','elementType':'geometry','stylers':[{'color':'#e4d7c6'}]},{'featureType':'road.local','elementType':'geometry','stylers':[{'color':'#fbfaf7'}]},{'featureType':'poi.park','elementType':'geometry','stylers':[{'color':'#c5dac6'}]},{'featureType':'administrative','stylers':[{'visibility':'on'},{'lightness':33}]},{'featureType':'road'},{'featureType':'poi.park','elementType':'labels','stylers':[{'visibility':'on'},{'lightness':20}]},{},{'featureType':'road','stylers':[{'lightness':20}]}];
      }
      else if (style == 'Pale Blue') {
        style_code = [{"stylers": [{ "lightness": -8 },{ "gamma": 1.07 },{ "saturation": -30 },{ "hue": "#007fff" }]},{"featureType": "landscape","stylers": [{ "saturation": 37 },{ "lightness": -4 },{ "gamma": 1.54 },{ "hue": "#0077ff" }]},{"featureType": "poi","stylers": [{ "hue": "#007fff" },{ "lightness": 16 },{ "gamma": 1.67 },{ "saturation": 31 }]},{"featureType": "water","stylers": [{ "hue": "#007fff" },{ "lightness": -30 },{ "saturation": -65 },{ "gamma": 1.37 }]},{"featureType": "road","stylers": [{ "saturation": -46 },{ "gamma": 1.26 }]},{"featureType": "transit","stylers": [{ "lightness": -1 },{ "gamma": 1.98 },{ "saturation": 44 },{ "hue": "#0055ff" }]},{}];
      }
      else if (style == 'Blue') {
        style_code = [{'featureType':'water','stylers':[{'color':'#46bcec'},{'visibility':'on'}]},{'featureType':'landscape','stylers':[{'color':'#f2f2f2'}]},{'featureType':'road','stylers':[{'saturation':-100},{'lightness':45}]},{'featureType':'road.highway','stylers':[{'visibility':'simplified'}]},{'featureType':'road.arterial','elementType':'labels.icon','stylers':[{'visibility':'off'}]},{'featureType':'administrative','elementType':'labels.text.fill','stylers':[{'color':'#444444'}]},{'featureType':'transit','stylers':[{'visibility':'off'}]},{'featureType':'poi','stylers':[{'visibility':'off'}]}];
      }
      else if (style == 'Colorful') {
        style_code = [{"featureType":"road","elementType":"geometry","stylers":[{"visibility":"simplified"}]},{"featureType":"road.arterial","stylers":[{"hue":149},{"saturation":-78},{"lightness":0}]},{"featureType":"road.highway","stylers":[{"hue":-31},{"saturation":-40},{"lightness":2.8}]},{"featureType":"poi","elementType":"label","stylers":[{"visibility":"off"}]},{"featureType":"landscape","stylers":[{"hue":163},{"saturation":-26},{"lightness":-1.1}]},{"featureType":"transit","stylers":[{"visibility":"off"}]},{"featureType":"water","stylers":[{"hue":3},{"saturation":-24.24},{"lightness":-38.57}]}];
      }
    }
    if ( mapel.data('lat') && mapel.data('lat') != '' )
      mapCenterLat = parseFloat(mapel.data('lat'));
    if ( mapel.data('lng') && mapel.data('lng') != '' )
      mapCenterLng = parseFloat(mapel.data('lng'));
    var mapOptions = {
      center: new google.maps.LatLng(mapCenterLat, mapCenterLng),
      scrollwheel: false,
      styles: style_code,
      panControl: false,
      streetViewControl: false,
      zoom: mapDefaultZoom,
      zoomControlOptions: {
        position: google.maps.ControlPosition.LEFT_BOTTOM
      }
    };
    defaultCenter = new google.maps.LatLng(mapCenterLat, mapCenterLng);
    map = new google.maps.Map(document.getElementById(mapCanvasId), mapOptions);
    var latlngbounds = new google.maps.LatLngBounds();
    $.each(locations, function(index, mark) {
      var lat = parseFloat(mark['latitude']);
      var lng = parseFloat(mark['longitude']);
      var coords = new google.maps.LatLng(lat, lng);
      latlngbounds.extend(coords);
      var marker;
      if (typeof marker_icon_url !== 'undefined' && marker_icon_url != "") {
        marker = new google.maps.Marker({
         position: coords,
         icon: markerIcon,
         map: map
        });
        markers[index] = marker;
      }
      else {
        marker = new google.maps.Marker({
         position: coords,
         map: map
        });
        markers[index] = marker;
      }
      var text = ''
      if ( mark['text'] && mark['text'] != '' ) {
        text = mark['text']
      }
      else {
        text = mark['address'];
      }
      var info = new google.maps.InfoWindow({
        content: "<div style='text-align:center;width:160px;padding-left:20px;'><h5 style='margin-bottom:5px;'>" + mark['title'] + "</h5><div class='info-box-text'>" + text + "</div></div>"
      });
      info_windows[index] = info;
      google.maps.event.addListener(marker, 'click', function() {
        $.each(info_windows, function(index) {
          info_windows[index].close();
        });
        info.open(map,marker);
        map.panTo(marker.getPosition());
      });
    });
    if ( mapCenterLng == -87.5 && mapCenterLat == 32.5 ) {
      map.setCenter(latlngbounds.getCenter());
      if ( locations.length > 1 )
        map.fitBounds(latlngbounds);
    }
    else {
      map.setCenter(defaultCenter);
      map.setZoom(mapDefaultZoom);
    }
	});
  $(".locations-map-container").removeClass("loading");
}

function loadScript() {
  var script = document.createElement('script');
  script.type = 'text/javascript';
  script.src = "https://maps.googleapis.com/maps/api/js?v=3&key=AIzaSyAjSs-Jq6hpuT35RG9wD6LuqaDFzYDCOPk&callback=get_markers";
  document.body.appendChild(script);
}
	
window.onload = loadScript;

function filter_results(lat, lng, radius) {
  search_area = {
    map: map,
    strokeOpacity: 0,
    fillOpacity: 0,
    clickable: false,
    center : new google.maps.LatLng(lat, lng),
    radius : parseInt(radius)
  }
  search_area = new google.maps.Circle(search_area);
  var bounds = search_area.getBounds();
  var number_results = 0;
  var latlngbounds = new google.maps.LatLngBounds();
  $.each(markers, function(i,marker) {
    if ( bounds.contains(  marker.getPosition()  ) ) {
      marker.setVisible(true);
      latlngbounds.extend(marker.getPosition());
      number_results += 1;
     }
     else {
      marker.setVisible(false);
     }
  });
  if (number_results == 0) {
    $("#filter-message").html("<p>Sorry, no results were found.<a class='clear-map-results' href='#' onclick='reset_map()'>clear</a></p>").show();
  }
  else if (number_results == 1) {
    $("#filter-message").html("<p>1 result found.<a class='clear-map-results' href='#' onclick='reset_map()'>clear</a></p>").show();
    map.setCenter(latlngbounds.getCenter());
    map.setZoom(default_zoom);
  }
  else {
    $("#filter-message").html("<p>" + number_results + " results found.<a class='clear-map-results' href='#' onclick='reset_map()'>clear</a></p>").show();
    map.setCenter(latlngbounds.getCenter());
    map.fitBounds(latlngbounds);
  }
}

function reset_map() {
  //console.log("resetting map");
  $("#filter-message").html("");
  $("input#address").val("");
  var latlngbounds = new google.maps.LatLngBounds();
  $.each(markers, function(i,marker) {
    marker.setVisible(true);
    latlngbounds.extend(marker.getPosition());
  });
  if ( mapCenterLng == -87.5 && mapCenterLat == 32.5 ) {
    map.setCenter(latlngbounds.getCenter());
    if ( locations.length > 1 )
      map.fitBounds(latlngbounds);
  }
  else {
    map.setCenter(defaultCenter);
    map.setZoom(mapDefaultZoom);
  }
}

function filter_location_map(zip, radius) {
  $.ajax({
    url: protocol + "maps.googleapis.com/maps/api/geocode/json",
    type: 'get',
    data: {
      sensor: false,
      components: "country:us",
      address: zip
    },
    success: function(data) {
      if ( data.status != "ZERO_RESULTS") {
        var lat = data['results'][0]['geometry']['location']['lat'];
        var lng = data['results'][0]['geometry']['location']['lng'];
        filter_results(lat, lng, radius);
      }
      else {
        $("#filter-message").html("<p>Invalid address.</p>").show().delay(2000).fadeOut(200);
      }
    }
  });
}