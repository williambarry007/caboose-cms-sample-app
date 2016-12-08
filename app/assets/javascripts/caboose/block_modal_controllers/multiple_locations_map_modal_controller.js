var MultipleLocationsMapModalController = BlockModalController.extend({
  
  add_child_link_text: "Add a marker!",
  child_block_header_text: "Markers",

  render_child_block: function(b)
  {
    var that = this;
    if (b.block_type.id != that.block.block_type.default_child_block_type_id)
      return that._super(b);
    var div = $('<div/>').attr('id', 'block_' + b.id)
      .append($('<a/>').attr('href', '#')  
        .append($('<p/>').append(that.child_block_value('title', b)))
        .click(function(e) {
          e.preventDefault();
          e.stopPropagation();
          that.parent_controller.edit_block(b.id); 
        })
      );    

    $('#the_modal #block_' + b.id).replaceWith(div);        
  
    that.autosize();
  },

});

$(document).trigger('block_modal_controller_loaded');