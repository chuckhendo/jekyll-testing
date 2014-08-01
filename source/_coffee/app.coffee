#= require_tree .
$ ->
	$('[data-lazy-load]').each ->
		$(this).lazyload($(this).data('lazy-load'))


	