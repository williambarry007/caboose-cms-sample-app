var AocuLoginSliderModalController = BlockModalController.extend({
  
  add_child_link_text: "Add a slide!",
  child_block_header_text: "Slides",

  assets_to_include: function() {
    return ['caboose/block_modal_styles/slider.css']
  },

  print_content: function()
  {
    var that = this;
    var div = $('<div/>').attr('id', 'modal_content');    
    if (that.block.block_type.field_type != 'block')
      div.append($('<p/>').append($('<div/>').attr('id', 'block_' + that.block.id + '_value')));
    else
    {
      if (that.block.children.length > 0)
      {        
        var separate_children = that.block.block_type.allow_child_blocks && that.block.block_type.default_child_block_type_id;
        var separate_child_id = separate_children ? that.block.block_type.default_child_block_type_id : false;
    
        $.each(that.block.children, function(i, b) {
          if (separate_children && b.block_type.id == separate_child_id) return;                    
          var div_id = 'block_' + b.id + (that.complex_field_types.indexOf(b.block_type.field_type) == -1 ? '_value' : '');
          div.append($('<div/>').css('margin-bottom', '10px').append($('<div/>').attr('id', div_id)));                                
        });
        if (separate_children)
        {
          if (that.child_block_header_text) div.append($('<h2/>').append(that.child_block_header_text));   
          var div1 = $('<div/>').addClass('slide-thumb-holder');
          div.append(div1);                   
          $.each(that.block.children, function(i, b) {
            if (b.block_type.id == separate_child_id)
            {
              var div_id = 'block_' + b.id + (that.complex_field_types.indexOf(b.block_type.field_type) == -1 ? '_value' : '');
              div1.append($('<div/>').append($('<div/>').attr('id', div_id)));
            }             
          });
        }    
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
  },

  render_child_block: function(b)
  {
    var that = this;
    if (b.block_type.id != 3231)
      return that._super(b);

    
    var div = $('<div/>').attr('id', 'block_' + b.id).addClass('slide-thumb')
   //   .css('width', '160px').css('height', '120px').css('float', 'left').css('border', '#ccc 1px solid').css('overflow', 'hidden').css('margin', '0 4px 4px 0')
      .append($('<a/>').attr('href', '#')
        .append($('<img/>').attr('id', 'block_' + b.id + '_image').attr('src', 'http://placehold.it/150x75'))       
      //  .append($('<span/>').attr('style','font-size:12px;color:#111;position:relative;top:6px;').append(that.child_block_value('title', b)))
        .click(function(e) {
          e.preventDefault();
          e.stopPropagation();
          that.parent_controller.edit_block(b.id); 
        })
      );    

    $('#the_modal #block_' + b.id).replaceWith(div);        
        
    var image_block = that.child_block('background_image', b);            
    $.ajax({      
      url: that.block_url(image_block) + '/render',
      type: 'get',
      success: function(html) {          
        $('#the_modal #block_' + b.id + '_image').replaceWith(html);                            
        that.autosize();
      },            
    });    
    that.autosize();
  },

});

$(document).trigger('block_modal_controller_loaded');