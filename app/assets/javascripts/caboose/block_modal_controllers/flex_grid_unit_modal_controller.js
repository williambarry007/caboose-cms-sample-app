
var FlexGridUnitModalController = BlockModalController.extend({

  print_content: function()
  {
    var that = this;
    that.include_assets('caboose/block_modal_styles/flex_grid.css');
    var div = $('<div/>').attr('id', 'modal_content');      
    if (that.block.block_type.field_type != 'block')
      div.append($('<p/>').append($('<div/>').attr('id', 'block_' + that.block.id + '_value')));
    else
    {
      div.append($('<a class="unit-settings-link" />').text('Unit Settings').click(function(event) { event.preventDefault(); $(".unit-settings-div").toggle(); $(".unit-children-div").toggle(); that.autosize(); }));
      div1 = $("<div/>").addClass("unit-children-div").css("display","block");
      div2 = $("<div/>").addClass("unit-settings-div").css("display","none");
      div.append(div1);
      div.append(div2);
      if (that.block.children.length > 0)
      {
        $.each(that.block.children, function(i, b) {
          if (b.name) return;      
          var div_id = 'block_' + b.id + (that.complex_field_types.indexOf(b.block_type.field_type) == -1 ? '_value' : '');
          div1.append($('<div/>').css('margin-bottom', '10px').append($('<div/>').attr('id', div_id)));                                
        });

        $.each(that.block.children, function(i, b) {
          if (!b.name) return;      
          var div_id = 'block_' + b.id + (that.complex_field_types.indexOf(b.block_type.field_type) == -1 ? '_value' : '');
          div2.append($('<div/>').css('margin-bottom', '10px').append($('<div/>').attr('id', div_id)));                                
        });

      }              
      else
      {
        div.append($('<p/>').append("This block doesn't have any content yet."));
      }
      if (that.block.block_type.allow_child_blocks)
      {        
        div.append($('<p/>').css('clear', 'both').append($('<a/>').attr('href', '#').html(that.add_child_link_text ? that.add_child_link_text : "Add a child block!").click(function(e) {
          e.preventDefault();
          that.add_block();
        })));                            
      }
    }
    $('#modal_content').replaceWith(div);
    that.render_child_blocks();
    that.autosize();
  }

});

$(document).trigger('block_modal_controller_loaded');