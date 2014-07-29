# Header
$ ->
	siteHeader = $('.site-header')

	$('.show-nav').on 'click', (e) ->
		e.preventDefault()
		siteHeader.toggleClass('nav-visible')