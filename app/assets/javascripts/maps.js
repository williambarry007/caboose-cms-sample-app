// Load Google Maps API and initialize each Map block on the page

function initialize_maps() {
	$(".map-block-container").each(function(index, Element) {
		var mapel = $(Element).find(".map"); 
 		var mapCanvasId, mapCenterLat, mapCenterLng, mapDefaultZoom, mapInfoWindow, style, style_code;
    mapCanvasId = mapel.attr("id");
    mapCenterLat = mapel.data("lat");
    mapCenterLng = mapel.data("long");
    mapDefaultZoom = mapel.data("zoom");
    mapInfoWindow = mapel.data("info");
    style = mapel.data("style"); 
    style_code = ""
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
    else if (style == 'Yellow') {
      style_code = [{"featureType":"landscape","elementType":"geometry.fill","stylers":[{"hue":"#ffb800"},{"saturation":"81"},{"lightness":"-3"},{"gamma":"1"}]},{"featureType":"poi","elementType":"all","stylers":[{"visibility":"on"},{"weight":"1.21"},{"lightness":"25"}]},{"featureType":"poi","elementType":"geometry.fill","stylers":[{"saturation":"4"},{"visibility":"on"},{"color":"#ffd360"},{"lightness":"13"}]},{"featureType":"poi","elementType":"geometry.stroke","stylers":[{"visibility":"on"}]},{"featureType":"poi","elementType":"labels.text.fill","stylers":[{"visibility":"on"},{"color":"#774900"}]},{"featureType":"poi","elementType":"labels.text.stroke","stylers":[{"visibility":"on"},{"color":"#feba2e"},{"gamma":"2.17"},{"weight":"0.97"}]},{"featureType":"poi","elementType":"labels.icon","stylers":[{"visibility":"on"},{"saturation":"-54"}]},{"featureType":"road","elementType":"all","stylers":[{"saturation":-100},{"lightness":45}]},{"featureType":"road.highway","elementType":"all","stylers":[{"visibility":"simplified"}]},{"featureType":"road.arterial","elementType":"labels.icon","stylers":[{"visibility":"off"}]},{"featureType":"transit","elementType":"all","stylers":[{"visibility":"off"}]},{"featureType":"water","elementType":"all","stylers":[{"color":"#ffcc00"},{"visibility":"on"}]},{"featureType":"water","elementType":"geometry.fill","stylers":[{"visibility":"on"},{"color":"#ffe5a1"},{"lightness":"-17"}]},{"featureType":"water","elementType":"labels.text","stylers":[{"visibility":"off"}]}];
    }
    var mapOptions = {
      center: new google.maps.LatLng(mapCenterLat, mapCenterLng),
      scrollwheel: false,
      styles: style_code,
      zoom: mapDefaultZoom
    };
    var map = new google.maps.Map(document.getElementById(mapCanvasId), mapOptions);
    var marker = new google.maps.Marker({
      position: {lat: mapCenterLat, lng: mapCenterLng},
      map: map
    });
    if(mapInfoWindow != "") {
      var info = new google.maps.InfoWindow({
        content: mapInfoWindow
      });
      info.open(map, marker);
      google.maps.event.addListener(marker, 'click', function() {
        info.open(map,marker);
      });
    }
	});
}

function loadScript() {
  var script = document.createElement('script');
  script.type = 'text/javascript';
  script.src = "https://maps.googleapis.com/maps/api/js?v=3&key=AIzaSyAjSs-Jq6hpuT35RG9wD6LuqaDFzYDCOPk&callback=initialize_maps";
  document.body.appendChild(script);
}
	
window.onload = loadScript;