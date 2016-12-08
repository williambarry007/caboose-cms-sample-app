var ResidentialMapController = function(params) { this.init(params); };

ResidentialMapController.prototype = {

  authenticity_token: false,
  map_el: false,
  info_windows: false,
  markers: false,
  properties: false,
  map: null,
  marker_cluster: null,
  map_canvas_id: null,
  protocol: false,
  location: false,
  radius: false,
  bounds: false,
  default_lat: false,
  default_lng: false,
  default_zoom: false,
  marker_width: false,
  marker_height: false,
  cluster_font_color: false,
  map_style: false,
  site_slug: false,
  image_base: false,
  
  init: function(params)
  {
    for (var i in params)
      this[i] = params[i];
    this.create_map();
    this.get_properties(null, true);
    this.bind_events();
  },

  get_bounds: function(first_time) {
    var that = this;
    that.location = $(".filter-bar #address").val();
    that.radius = parseInt($(".filter-bar #radius").val());
    if (that.location && that.radius && that.location != "" && that.radius != "" && that.location != "Address, City, ZIP code") {
      $.ajax({
        url: that.protocol + "maps.googleapis.com/maps/api/geocode/json",
        type: 'get',
        data: {
          sensor: false,
          components: "country:us",
          address: that.location
        },
        success: function(data) {
          if ( data.status != "ZERO_RESULTS") {
            var lat = data['results'][0]['geometry']['location']['lat'];
            var lng = data['results'][0]['geometry']['location']['lng'];
            var search_area = {
              map: that.map,
              strokeOpacity: 0,
              fillOpacity: 0,
              clickable: false,
              center : new google.maps.LatLng(lat, lng),
              radius : parseInt(that.radius)
            }
            search_area = new google.maps.Circle(search_area);
            that.bounds = search_area.getBounds();
            that.add_markers(first_time);
          }
          else {
            $("#filter-message").html("<p>Invalid address</p>").show().delay(2000).fadeOut(200);
            that.add_markers(first_time);
          }
        }
      });
    }
    else {
      that.bounds = false;
      that.add_markers(first_time);
    }
  },

  get_properties: function(params, first_time) {
    var that = this;
    $.ajax({
      url: "/rets/residential.json",
      type: 'get',
      data: params,
      success: function(data) {
        that.properties = data;
        that.get_bounds(first_time);
      }
    });
  },

  bind_events: function() {
    var that = this;
    $("#map-filter-form").submit(function(event) {
      event.preventDefault();
      that.get_properties( $(this).serialize(), false );
    });
    $("#clear-map-filter").click(function(event) {
      event.preventDefault();
      $(".filter-bar").find("#address").val("");
      $(".filter-bar select").each(function() {
        $(this).val($(this).find("option").first().val()).trigger("render");
      });
      that.get_properties(null, true);
    });
  },

  format_price: function(price) {
    var that = this;
    return ( price ? price.toLocaleString() : 0 );
  },

  create_map: function() {
    var that = this;
    var mapCenterLat, mapCenterLng, mapDefaultZoom, style_code;
    that.map_canvas_id = that.map_el.attr("id");
    mapCenterLat = that.default_lat ? that.default_lat : 33.2;
    mapCenterLng = that.default_lng ? that.default_lng : -87.5;
    mapDefaultZoom = that.default_zoom ? that.default_zoom : 12;
    style_code = that.map_style == 'Pink' ? [{"featureType":"all","elementType":"all","stylers":[{"weight":0.53},{"hue":"#4d1b4d"},{"saturation":0},{"lightness":-3},{"gamma":1.05}]}] : (that.map_style == "Grayscale" ? [{'featureType':'landscape','stylers':[{'saturation':-100},{'lightness':65},{'visibility':'on'}]},{'featureType':'poi','stylers':[{'saturation':-100},{'lightness':51},{'visibility':'simplified'}]},{'featureType':'road.highway','stylers':[{'saturation':-100},{'visibility':'simplified'}]},{'featureType':'road.arterial','stylers':[{'saturation':-100},{'lightness':30},{'visibility':'on'}]},{'featureType':'road.local','stylers':[{'saturation':-100},{'lightness':40},{'visibility':'on'}]},{'featureType':'transit','stylers':[{'saturation':-100},{'visibility':'simplified'}]},{'featureType':'administrative.province','stylers':[{'visibility':'off'}]},{'featureType':'water','elementType':'labels','stylers':[{'visibility':'on'},{'lightness':-25},{'saturation':-100}]},{'featureType':'water','elementType':'geometry','stylers':[{'hue':'#ffff00'},{'lightness':-25},{'saturation':-97}]}] : []);
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
    that.map = new google.maps.Map(document.getElementById(that.map_canvas_id), mapOptions);
    var clusterStyles = [{textColor: that.cluster_font_color,url: 'http://cabooseit.s3.amazonaws.com/assets/' + that.site_slug + '/images/cluster_40.png',height: 40,width: 40},{textColor: that.cluster_font_color,url: 'http://cabooseit.s3.amazonaws.com/assets/' + that.site_slug + '/images/cluster_60.png',height: 60,width: 60},{textColor: that.cluster_font_color,url: 'http://cabooseit.s3.amazonaws.com/assets/' + that.site_slug + '/images/cluster_80.png',height: 80,width: 80}];
    var mcOptions = { styles: clusterStyles };
    that.marker_cluster = new MarkerClusterer(that.map, [], mcOptions);
    $(".real-estate-map-container").removeClass("loading");
  },

  clear_map: function() {
    var that = this;
    that.markers = [];
    that.info_windows = [];
    that.marker_cluster.clearMarkers();
    $("#filter-message").html("");
  },

  add_markers: function(first_time) {
    var that = this;
   // console.dir(that);
    that.clear_map();
    var markerIcon = new google.maps.MarkerImage('http://cabooseit.s3.amazonaws.com/assets/' + that.site_slug + '/images/marker.png', null, null, null, new google.maps.Size(that.marker_width,that.marker_height));
    var latlngbounds = new google.maps.LatLngBounds();
    var result_count = 0;
    if (that.properties.length == 0) {
      $("#filter-message").html("<p>No results found</p>");
      var center = new google.maps.LatLng(that.default_lat, that.default_lng);
      that.map.panTo(center);
      that.map.setZoom(that.default_zoom);
    }
    else {
      $.each(that.properties, function(index, mark) {
        var lat = parseFloat(mark['latitude']);
        var lng = parseFloat(mark['longitude']);
        var coords = new google.maps.LatLng(lat, lng);
        var price = parseInt(mark['current_price']);
        var marker = new google.maps.Marker({
         position: coords,
         icon: markerIcon
        });
        if ( !that.bounds || that.bounds.contains(  marker.getPosition()  ) ) {
          latlngbounds.extend(coords);
          that.markers[result_count] = marker;
          var text = "<div class='res-pop'><h3 class='price'>$" + that.format_price(price) + "<a href='/residential/" + mark['mls_acct'] + "' title='Details'>View</a></h3>";
          if (mark['file_name'] && mark['file_name'] != "") { text += "<img src='" + that.image_base + mark['file_name'] + "' width='150' />"; }
          text += "<p class='specs'><span class='val br'>" + mark['bedrooms'] + "</span> Beds <span class='val bf'>" + mark['baths_full'] + "</span> Baths <span class='val bh'>" + mark['baths_half'] + "</span> &frac12; Baths</p>";
          text += "</div>";
          var info = new google.maps.InfoWindow({
            content: text
          });
          that.info_windows[result_count] = info;
          google.maps.event.addListener(marker, 'click', function() {
            $.each(that.info_windows, function(index) {
              that.info_windows[index].close();
            });
            info.open(that.map,marker);
            that.map.panTo(marker.getPosition());
          });
          result_count += 1;
        }
      });
      if (result_count > 0) {
        that.marker_cluster.addMarkers(that.markers);
        $("#filter-message").html("<p>" + result_count + " results</p>");
        if (that.default_lat && that.default_lng && that.default_zoom && first_time) {
          var center = new google.maps.LatLng(that.default_lat, that.default_lng);
          that.map.panTo(center);
          that.map.setZoom(that.default_zoom);
        }
        else {
          that.map.setCenter(latlngbounds.getCenter());
          that.map.fitBounds(latlngbounds);
          if (!that.default_lat && !that.default_zoom) {
            that.default_lat = that.map.center.lat();
            that.default_lng = that.map.center.lng();
            that.default_zoom = that.map.zoom;
          }
        }
      }
      else {
        $("#filter-message").html("<p>No results found</p>");
        var center = new google.maps.LatLng(that.default_lat, that.default_lng);
        that.map.panTo(center);
        that.map.setZoom(that.default_zoom);
      }
    }
  }
};