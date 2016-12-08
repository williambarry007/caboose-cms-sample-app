
var FlexGridModalController = BlockModalController.extend({
  
  add_child_link_text: "Add a unit!",
  child_block_header_text: "Units",

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
        var separate_children = that.block.block_type.allow_child_blocks && that.block.block_type.default_child_block_type_id;
        var separate_child_id = separate_children ? that.block.block_type.default_child_block_type_id : false;
    
        $.each(that.block.children, function(i, b) {
          if (separate_children && b.block_type.id == separate_child_id) return;                    
          var div_id = 'block_' + b.id + (that.complex_field_types.indexOf(b.block_type.field_type) == -1 ? '_value' : '');
          div.append($('<div/>').css('margin-bottom', '10px').append($('<div/>').attr('id', div_id)));                                
        });
        if (separate_children)
        {
     //     console.dir(that);
          if (that.child_block_header_text) div.append($('<h2/>').append(that.child_block_header_text));
          div.append('<div class="modal-flex-grid"></div>');
          if ( that.child_block('settings') ) {
            var st = that.child_block('settings');
      //      console.log(st);
            var uw = false;
            $.each(st.children, function(i, b2) {
              if (b2.name == 'unit_width') {
                uw = b2.value;
              }
            });
            if ( uw ) {
        //      console.log("override unit width");
              that.include_inline_css(".modal-flex-grid > div { -webkit-box-flex: 0 1 " + uw + " !important;-moz-box-flex: 0 1 " + uw + " !important;-webkit-flex: 0 1 " + uw + " !important;-ms-flex: 0 1 " + uw + " !important;flex: 0 1 " + uw + " !important;}");
            }
          }
          $.each(that.block.children, function(i, b) {
            if (b.block_type.id == separate_child_id)
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

   // $("#modal_content > h2").after("<div class='flex-grid-container'></div>");
  //  console.dir(that);
  //  console.log(that.block.default_child_block_id);
    if (b.block_type.id != that.block.block_type.default_child_block_type_id)
      return that._super(b);
    var div = $('<div/>').attr('id', 'block_' + b.id)
      .append($('<a/>').attr('href', '#')
        .append('Edit Unit')
        .click(function(e) {
          e.preventDefault();
          e.stopPropagation();
          that.parent_controller.edit_block(b.id); 
        })
      );
    $('#the_modal #block_' + b.id).remove(); //replaceWith(div);
    $("#modal_content .modal-flex-grid").append(div);  
    that.autosize();    
  },

});

$(document).trigger('block_modal_controller_loaded');