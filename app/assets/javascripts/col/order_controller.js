var OrderController = function(params) { this.init(params); };

OrderController.prototype = {
  cart_table: $('.additional-order-table.cart table'),
  added_vars: false,
  authenticity_token: false,
  subtotal: 0.0,
  suite_menu: false,
  ov: $("#additional-order-modal"),
  too_late: false,
  
  init: function(params)
  {
    for (var i in params)
      this[i] = params[i];
    this.bind_events();
  },

  bind_events: function() {
    var that = this;
    $(window).load(function(e){ that.toggle_sidebar(); });
    $(window).scroll(function(e){ that.toggle_sidebar(); });
    $(".add-item").click(function(event) { that.add_item($(this), event); });
    $(".options-link").click(function(event) { that.toggle_options($(this), event); });
    $(".show-description").click(function(event) { that.show_modal($(this), event); });
    $("#close-ad-modal").click(function(event) { that.close_modal(event); });
  },

  toggle_sidebar: function() {
    var that = this;
    $el = $('.additional-order-table.cart');
    var y = $("header.menu-header").outerHeight() - 48 + $("header.dashboard").outerHeight() + $("header.main").outerHeight();
    var p = $(".dashboard-wrapper").offset().left;
    var s = $(".sizer").width();
    if ( $(window).scrollTop() > y ) { 
      $el.addClass("fixed").css("right",p + 20).css("width",s);
    }
    else {
      $el.removeClass("fixed").css("right",0).css("width","39%"); 
    }
  },  

  toggle_options: function( el, event ) {
    var that = this;
    event.preventDefault();
    if ( el.find(".show-options").text() == 'options' ) {
      el.find(".show-options").text("hide");
      el.find(".increase").text("-");
      el.closest(".product-unit").find(".variants").slideDown();
    }
    else {
      el.find(".show-options").text("options");
      el.find(".increase").text("+");
      el.closest(".product-unit").find(".variants").slideUp();
    }
  },

  show_modal: function( el, event ) {
    var that = this;
    event.preventDefault();
    var pid = el.data("product-id");
    $.ajax({
      url: '/dashboard/products/' + pid + '/json',
      type: 'get',
      success: function(resp) {
        if (resp) {
          that.ov.fadeIn();
          that.ov.find(".modal-wrapper").fadeIn();
          that.ov.find(".product-name .name").text( resp.title );
          resp.caption == null ? that.ov.find(".product-name .caption").hide() : that.ov.find(".product-name .caption").show().text( resp.caption );
          resp.handle == null ? that.ov.find(".handle").hide() : that.ov.find(".handle").show().text( resp.handle );
          resp.desc == null ? that.ov.find(".richtext").hide() : that.ov.find(".richtext").show().html( resp.desc );
          resp.img == null ? that.ov.find(".item-photo").hide() : that.ov.find(".item-photo").show().attr("src", resp.img);
        }
      }
    });
  },

  close_modal: function(event) {
    var that = this;
    event.preventDefault();
    that.ov.fadeOut();
    that.ov.find(".modal-wrapper").fadeOut();
  },

  format_currency: function( number ) {
    return ("$" + number.toFixed(2).replace(/(\d)(?=(\d{3})+\.)/g, '$1,'));
  },

  update_subtotal: function() {
    var that = this;
    var sub = 0.0;
    that.cart_table.find("tbody").find("tr").each(function() {
      var q = $(this).data("quantity");
      var p = $(this).data("price");
      try {
        var z = parseFloat(p.replace("$",""));
        if ( typeof(q) == "number" && typeof(z) == "number" ) {
          sub += (q * z);
        }
      }
      catch(err) {
        console.log("error");
      }
    });
    that.subtotal = sub;
    that.cart_table.find(".total-row .amount").text(that.format_currency(sub));
  },

  add_item: function( el, event ) {
    var that = this;
    event.preventDefault();
    var id = el.data("variant-id");
    var price = el.data("price");
    var title = el.data("title");
    var exists = that.added_vars.indexOf(id) >= 0;
    if ( exists == false ) {
      var html = "<tr id='row-" + id + "' data-quantity='1' data-price='" + price + "'><td>";
      html += "<h5>" + title + "</h5>";
      html += "<div class='right'><h4><span class='quant'>1</span><span class='x'>x</span><span class='numb'>" + price + "</span></h4>";
      html += "<a href='#' class='remove' onclick='return controller.remove_var(" + id + ")'>-</a>";
      html += "<a href='#' class='add' onclick='return controller.add_var(" + id + ")'>+</a>";
      html += "</div></td></tr>"
      if ( $(".additional-order-table.cart table").hasClass("empty") ) {
        $(".additional-order-table.cart table").removeClass("empty");
        $(".additional-order-table.cart table tbody").html("");
      }
      $(".additional-order-table.cart table tbody").append(html);
      that.added_vars.push(id);
      that.add_to_cart(id);
    }
    else {
      that.add_var(id);
    }
    that.update_subtotal();
  },

  remove_var: function(var_id) {
    var that = this;
    var row = $("#row-" + var_id);
    var quant = row.data("quantity");
    if ( quant == 1 ) {
      row.remove();
      that.change_cart(var_id, 0);
    }
    else {
      row.data("quantity", quant - 1);
      row.find("span.quant").text(quant - 1);
      that.change_cart(var_id, quant - 1);
    }
    var index = that.added_vars.indexOf(var_id);
    if ( index > -1 && that.added_vars )
      that.added_vars.splice(index, 1);
    that.update_subtotal();
    return false;
  },

  add_var: function(var_id) {
    var that = this;
    var row = $("#row-" + var_id);
    var quant = row.data("quantity");
    row.data("quantity",quant + 1);
    row.find("span.quant").text(quant + 1);
    that.change_cart(var_id, quant + 1);
    that.update_subtotal();
    return false;
  },

  change_cart: function(var_id, quantity) {
    var that = this;
    if ( !that.too_late ) {
      $.ajax({
        url: '/suite-menus/' + that.suite_menu + '/variants/' + var_id + '/ai-id',
        type: 'get',
        success: function(resp) {
          if(resp.ai_id) {
            that.update_cart(resp.ai_id, quantity);
          }
        }
      });
    }
  },

  update_cart: function(ai_id, quantity) {
    var that = this;
    if ( !that.too_late && quantity >= 0 ) {
      $.ajax({
        url: '/suite-menus/' + that.suite_menu + '/additional-items/' + ai_id,
        type: 'put',
        data: {
          quantity: quantity
        },
        success: function(resp) {
          if(resp.success) {
            console.log("deleted");
          }
        }
      });
    }
    // else if ( !that.too_late ) {
    //   $.ajax({
    //     url: '/suite-menus/' + that.suite_menu + '/additional-items/' + ai_id,
    //     type: 'put',
    //     data: {
    //       quantity: quantity
    //     },
    //     success: function(resp) {
    //       if(resp.success) {
    //         console.log("added");
    //       }
    //     }
    //   });
    // }
  },

  add_to_cart: function(var_id) {
    var that = this;
    if ( !that.too_late ) {
      $.ajax({
        url: '/suite-menus/' + that.suite_menu + '/additional-items',
        type: 'post',
        data: {
          variant_id: var_id,
          quantity: 1
        },
        success: function(resp) {
          if(resp.success) {
            console.log("added");
          }
        }
      });
    }
  }

  // submit_order: function(event) {
  //   var that = this;
  //   event.preventDefault();
  //   $.ajax({
  //     url: '/suite-menus/' + that.suite_menu + '/submit-additional-order',
  //     type: 'post',
  //     success: function(resp) {
  //       if(resp.redirect) {
  //         window.location = resp.redirect;
  //       }
  //     }
  //   });
  // }
  
};