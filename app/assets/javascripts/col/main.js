$(".show-cutoff-popup").click(function(event) {
	event.preventDefault();
	var game = $(this).data("game");
	$(".cutoff-popup#cp-" + game).show();
});
$(".cutoff-popup .icon-close").click(function(event) {
	event.preventDefault();
	$(this).parent().hide();
});

$(window).load(function() {
	$('.content_body #financial_status #payment_method_container').remove();
	$('.content_body > #payment_form').remove();
	$('.home-content #invoice_table .line_item_details p a').click(function(e) { e.stopPropagation(); } );
});