var MapMarkerModalController = BlockModalController.extend({


	save_coords: function(block_id, lat, lng) {
		var that = this;
		console.log('saving');
		$.ajax({
	    url: "/api/update-marker-coordinates",
	    type: 'post',
	    data: {
	    	block_id: block_id,
	    	latitude: lat,
	    	longitude: lng
	    },
	    success: function(resp) {
	      if (resp.success) {
	      	$("#coordinates-message").html("Coordinates updated!").show().delay(1000).fadeOut(200);
	      	$("#latitude").html(lat);
	      	$("#longitude").html(lng);
	      }
	      else if (resp.error) {
	      	$("#coordinates-message").html("ERROR: " + resp.error).show().delay(1000).fadeOut(200);
	      }
	    }
	  });
	},
	get_coords: function(block_id, address) {
		var that = this;
		console.log('getting');
		$.ajax({
	    url: "https://maps.googleapis.com/maps/api/geocode/json",
	    type: 'get',
	    data: {
	    	sensor: false,
	    	address: address
	    },
	    success: function(data) {
	  		if ( data.status != "ZERO_RESULTS") {
	  			var lat = data['results'][0]['geometry']['location']['lat'];
	      	var lng = data['results'][0]['geometry']['location']['lng'];
	      	that.save_coords(block_id, lat, lng);
	  		}
	  		else {
	  			$("#coordinates-message").html("Invalid address, coordinates not saved.").show().delay(2000).fadeOut(200);
	  		}
	    }
	  });
	},

  print_content: function()
  {
    var that = this;
    var address_id = 0;
    var div = $('<div/>').attr('id', 'modal_content');      
    if (that.block.block_type.field_type != 'block')
      div.append($('<p/>').append($('<div/>').attr('id', 'block_' + that.block.id + '_value')));
    else
    {
      if (that.block.children.length > 0)
      {        
    
        $.each(that.block.children, function(i, b) {
          if (b.block_type.name == 'latitude' || b.block_type.name == 'longitude') return;
          if (b.block_type.name == 'address') {
          	console.log('is address block: ' + b.id);
          	address_id = b.id;
          }
          var div_id = 'block_' + b.id + (that.complex_field_types.indexOf(b.block_type.field_type) == -1 ? '_value' : '');
          div.append($('<div/>').css('margin-bottom', '10px').append($('<div/>').attr('id', div_id)));                                
        });

        div.append($('<p/>').attr('id','coordinates-message'));

      }              
      else
      {
        div.append($('<p/>').append("This block doesn't have any content yet."));
      }
    }
    $('#modal_content').replaceWith(div);
    that.render_child_blocks();
    that.autosize();

    console.log('address_id: ' + address_id);
    $("#block_" + address_id + "_value").change(function() {
    	console.log("changed");
    	var address = $("#block_" + address_id + "_value").val();
    	if (address) {
    		console.log('address: ' + address);
    		that.get_coords(that.block.id, address);
    	}
    });
  }

});

$(document).trigger('block_modal_controller_loaded');