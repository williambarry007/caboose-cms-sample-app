var SuiteMenuController = function(params) { this.init(params); };

SuiteMenuController.prototype = {
  authenticity_token: false,
  suite_menu_id: false,
  is_preview: false,
  
  init: function(params) {
    for (var i in params)
      this[i] = params[i];
    this.bind_events();
  },

  bind_events: function() {
    var that = this;
    $('input.limited-checkbox').on('change', function(evt) {
      var list = $(this).closest(".menu-item-list");
      var limit = list.data("limit");
      var name = $(this).attr("name");
      if(list.find("input[name='" + name + "']:checked").length > limit) {
        this.checked = false;
        list.prev(".mi-instructions").find(".color").fadeIn(200).fadeOut(200).fadeIn(200).fadeOut(200).fadeIn(200);
      }
      else
        that.toggle_menu_item( $(this).data("smi"), $(this).is(":checked"), false );
      that.toggle_parent( $(this) );
    });
    $(".menu-order-options .btn").click(function(event) {
      event.preventDefault();
      var not_btns = $(this).siblings();
      $.each(not_btns, function(k) {
        $(this).removeClass("selected");
        $(".menu-category-choice#mc-" + $(this).data("menu-id")).hide();
      });
      $(this).toggleClass("selected");
      $(".menu-category-choice#mc-" + $(this).data("menu-id")).show();
      $("select.custom").trigger('render');
      that.toggle_menu_item( $(this).data("smi"), $(this).hasClass("selected"), true );
    });
    $(".menu-item-option input[type='radio']").on('change', function() {
        that.toggle_menu_item( $(this).data("smi"), $(this).is(":checked"), true );
        that.toggle_parent( $(this) );
        $(this).parent().siblings("ul.is-sub").removeClass("disabled");
        $(this).closest(".menu-item-option").siblings(".menu-item-option").children(".text-holder").children("ul.is-sub").addClass("disabled");
    });
    $(".subvariant-select").change(function() {
      if ( $(this).val() == "" ) {
        console.log("nothing selected");
        that.toggle_menu_item( $(this).data("smi"), false, true, true );
      }
      else {
        that.toggle_menu_item( $(this).val(), true, true );
        var input = $(this).closest(".menu-item-option").children(".text-holder").children("label").children("input");
        if ( input && !input.is(':checked') ) {
          input.trigger("click");
          input.checked = true;
        }
      }
    });
    $("#submit-suite-menu").click(function(event) {
      event.preventDefault();
      that.submit_menu();
    });
    $(document).ready(function() {
      $.each( $(".menu-order-options"), function(k) {
        var btns = $(this).find(".btn.selected");
        var btn = null;
        if ( btns.length == 0 ) {
          btn = $(this).find(".btn").first()
          btn.addClass("selected");
        }
        else {
          btn = btns.first()
        }
        var selected = btn.data("menu-id");
        $(".menu-category-choice#mc-" + selected).show();
        that.toggle_menu_item( btn.data("smi"), true, false );
      })
    });
  },

  // if parent isn't selected, select it
  toggle_parent: function(el) {
    var that = this;
    if ( el.is(":checked") ) {
      var input = el.closest(".menu-item-list").closest(".menu-item-option").children(".text-holder").children("label").children("input");
      if ( input && !input.is(':checked') ) { 
        input.checked = true;
        input.trigger("click");
      }
    }
  },

  show_loading: function() {
    $("#screen-loading").show();
  },

  hide_loading: function() {
    $("#screen-loading").hide();
  },

  toggle_menu_item: function(smi_id, selected, toggle_siblings_off, override) {
    var that = this;
    var toggle_siblings = (selected && toggle_siblings_off) ? true : false
    toggle_siblings = override == true ? true : toggle_siblings
    if ( !that.is_preview ) {
      $.ajax({
        url: '/suite-menu-items/' + smi_id,
        type: 'put',
        data: {
          selected: selected,
          toggle_siblings: toggle_siblings
        },
        success: function(resp) {
     //     console.log("saved");
        }
      });
    }
  },

  submit_menu: function() {
    var that = this;
    that.show_loading();
   // $("#sm-message").html("<p class='note loading'>Submitting menu...</p>");
    $.ajax({
      url: '/suite-menus/' + that.suite_menu_id + '/submit',
      type: 'put',
      data: {
        special_requests: $("#special-requests").val(),
        delivery_time: $(".delivery-time-selector select").val()
      },
      success: function(resp) {
        if ( resp && resp.redirect ) {
          window.location = resp.redirect;
        }
        else if ( resp && resp.error ) {
          that.hide_loading();
          $("#sm-message").html("<p class='note error'>" + resp.error + "</p>");
        }
      }
    });
  }
  
};