//= require openseadragon/jquery

(function($) {
  function initOpenSeadragon() {
    $('picture[data-openseadragon]:not(:has(.openseadragon-container))').openseadragon();
  }

  const jquery3 = parseInt($.fn.jquery.split('.')[0]) >= 3;
  let handler = 'ready';

  if (typeof Turbo !== 'undefined') {
    handler = 'turbo:load turbo:frame-load';
  } else if (typeof Turbolinks !== 'undefined' && Turbolinks.supported) {
    // Turbolinks 5
    if (Turbolinks.BrowserAdapter) {
      handler = 'turbolinks:load';
    } else {
      // Turbolinks < 5
      handler = 'page:load ready';
    }
  }

  // Support for $(document).on( "ready", handler ) was removed in jQuery 3
  if (jquery3 && handler.includes('ready')) {
    handler = handler.replace('ready', '').trim();
    $(initOpenSeadragon);
  }

  if (handler) {
    $(document).on(handler, initOpenSeadragon);
  }
})(jQuery);
