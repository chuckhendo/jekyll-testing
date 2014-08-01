
$ ->
	imageEl = $('.front-page-hero .bg-image')
	if imageEl.length < 1
		return

	fpImages = imageEl.data 'image-options'
	imageSrc = fpImages[Math.floor((Math.random() * 3) )]


	$(imageEl).lazyload(imageSrc)
	

	