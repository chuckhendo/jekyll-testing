# Header
$ ->
	siteHeader = $('.site-header')

	$('.show-nav').on 'click', (e) ->
		e.preventDefault()
		siteHeader.toggleClass('nav-visible')

		if siteHeader.hasClass 'nav-visible'
			siteHeader.addClass('animate-in')
			setTimeout ->
				siteHeader.removeClass('animate-in')
			, 1000

		else
			siteHeader.addClass('animate-out')
			setTimeout ->
				siteHeader.removeClass('animate-out')
			, 1000