(function() {
  function initOpenSeadragon() {
    document.querySelectorAll('picture[data-openseadragon]:not(:has(.openseadragon-container))').openseadragon();
  }

  if (typeof Turbo !== 'undefined') {
    addEventListener("turbo:load", () => initOpenSeadragon())
    addEventListener("turbo:frame-load", () => initOpenSeadragon())
  } else {
    addEventListener('load', () => initOpenSeadragon())
  }
})();
