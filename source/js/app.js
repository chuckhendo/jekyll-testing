(function() {
  $(function() {
    return $('[data-lazy-load]').each(function() {
      return $(this).lazyload($(this).data('lazy-load'));
    });
  });

  $(function() {
    var fpImages, imageEl, imageSrc;
    imageEl = $('.front-page-hero .bg-image');
    if (imageEl.length < 1) {
      return;
    }
    fpImages = imageEl.data('image-options');
    imageSrc = fpImages[Math.floor(Math.random() * 3)];
    return $(imageEl).lazyload(imageSrc);
  });

  $(function() {
    var siteHeader;
    siteHeader = $('.site-header');
    return $('.show-nav').on('click', function(e) {
      e.preventDefault();
      return siteHeader.toggleClass('nav-visible');
    });
  });

  $.fn.lazyload = function(imageSrc) {
    return this.each(function() {
      var image;
      image = new Image();
      image.onload = (function(_this) {
        return function() {
          return $(_this).css('background-image', "url(" + image.src + ")").addClass('loaded');
        };
      })(this);
      return image.src = imageSrc;
    });
  };

  $(function() {
    return $('[data-lazy-load]').each(function() {
      return $(this).lazyload($(this).data('lazy-load'));
    });
  });

}).call(this);
