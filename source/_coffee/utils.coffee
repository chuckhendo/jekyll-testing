$.fn.lazyload = (imageSrc) ->
	@each ->
		image = new Image()

		image.onload = =>
			$(this).css('background-image', "url(#{image.src})").addClass('loaded')

		image.src = imageSrc