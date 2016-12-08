
var FourColumnRowModalController = BlockModalController.extend({
  
//  add_child_link_text: "Add a slide!",
  child_block_header_text: "Columns",

  print_content: function()
  {
    var that = this;
    that.include_assets('caboose/block_modal_styles/flex_grid.css');
    var div = $('<div/>').attr('id', 'modal_content');      
    if (that.block.block_type.field_type != 'block')
      div.append($('<p/>').append($('<div/>').attr('id', 'block_' + that.block.id + '_value')));
    else
    {
      if (that.block.children.length > 0)
      {        
        var separate_children = true;
    //    var separate_child_id = separate_children ? that.block.block_type.default_child_block_type_id : false;
    
        $.each(that.block.children, function(i, b) {
          if (separate_children && b.name.indexOf('column') > 0) return;                    
          var div_id = 'block_' + b.id + (that.complex_field_types.indexOf(b.block_type.field_type) == -1 ? '_value' : '');
          div.append($('<div/>').css('margin-bottom', '10px').append($('<div/>').attr('id', div_id)));                                
        });
        if (separate_children)
        {
      //    console.dir(that);
          if (that.child_block_header_text) div.append($('<h2/>').append(that.child_block_header_text));
          div.append('<div class="modal-flex-grid"></div>');
          $.each(that.block.children, function(i, b) {
            if (b.name.indexOf('column') > 0)
            {
              var div_id = 'block_' + b.id + (that.complex_field_types.indexOf(b.block_type.field_type) == -1 ? '_value' : '');
              div.append($('<div/>').css('margin-bottom', '10px').append($('<div/>').attr('id', div_id)));
            }             
          });
        }    
      }              
      else
      {
        div.append($('<p/>').append("This block doesn't have any content yet."));
      }
    }
    $('#modal_content').replaceWith(div);
    that.render_child_blocks();
    that.autosize();
  },

  render_child_block: function(b)
  {
    var that = this;
//    console.dir(b);
    if (b.name.indexOf('column') < 0)
      return that._super(b);


      var div = $('<div/>').attr('id', 'block_' + b.id).addClass('unit1of4').addClass(b.name)
        .append($('<a/>').attr('href', '#')
          .append('Edit Column')
          .click(function(e) {
            e.preventDefault();
            e.stopPropagation();
            that.parent_controller.edit_block(b.id); 
          })
        );
    
    $('#the_modal #block_' + b.id).remove();
    $("#modal_content .modal-flex-grid").append(div);       
    that.autosize();    
  },

});

$(document).trigger('block_modal_controller_loaded');