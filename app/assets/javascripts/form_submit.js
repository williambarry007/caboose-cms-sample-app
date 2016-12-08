function submit_form(form_id) {
  var mess = $("#" + form_id).next("#message");
  mess.html("<p class='note loading'>Submitting form... </p>");
  var form = $("#" + form_id); 
  form.find("input, textarea").each(function() {
    if ( $(this).attr("placeholder") == $(this).val() ) {
      $(this).val("");
    }
  });
  $.ajax({
    url: '/form',
    type: 'post',
    data: form.serialize(),
    success: function(resp) {
      if(resp.error) {
        form.find("input, textarea").each(function() {
          if ( $(this).val() == "" ) {
            $(this).val( $(this).attr("placeholder") );
          }
        });
        mess.html("<p class='note error'>" + resp.error + "</p>");
      } 
      if(resp.success) {
        form.slideUp(); 
        mess.html("<p class='note success'>" + resp.success + "</p>");
      }
    }
  });
}