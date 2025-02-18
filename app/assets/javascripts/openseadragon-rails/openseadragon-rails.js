(function (global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? factory(require('openseadragon')) :
  typeof define === 'function' && define.amd ? define(['openseadragon'], factory) :
  (global = typeof globalThis !== 'undefined' ? globalThis : global || self, factory(global.OpenSeadragon));
})(this, (function (OpenSeadragon) { 'use strict';

  (function() {
    let __osd_counter = 0;

    function generateOsdId() {
      __osd_counter++;
      return "Openseadragon" + __osd_counter;
    }

    function openseadragon() {
      this.forEach(function(picture) {
        // Ensure the element is an HTMLElement
        if (!(picture instanceof HTMLElement)) return;

        picture.classList.add('openseadragon-viewer');

        // Set ID if it doesn't exist
        if (!picture.id) {
          picture.id = generateOsdId();
        }

        // Retrieve openseadragon data attribute as JSON
        const collectionOptions = picture.dataset.openseadragon
          ? JSON.parse(picture.dataset.openseadragon)
          : {};

        // Find all <source> elements with media="openseadragon"
        const sources = Array.from(picture.querySelectorAll('source[media="openseadragon"]'));

        const tileSources = sources.map(source => {
          const osdData = source.dataset.openseadragon;
          return osdData ? JSON.parse(osdData) : source.getAttribute('src');
        });

        // Preserve height of the picture
        const height = window.getComputedStyle(picture).height;
        picture.style.height = height;

        // Initialize OpenSeadragon
        picture.osdViewer = OpenSeadragon({
          id: picture.id,
          ...collectionOptions,
          tileSources: tileSources
        });
      });

      return this;
    }

    // Attach the function to NodeList and HTMLElement prototypes for convenience
    NodeList.prototype.openseadragon = openseadragon;
    HTMLCollection.prototype.openseadragon = openseadragon;

    // For a single HTMLElement
    HTMLElement.prototype.openseadragon = function() {
      return openseadragon.call([this]);
    };

  })();

  (function() {
    function initOpenSeadragon() {
      document.querySelectorAll('picture[data-openseadragon]:not(:has(.openseadragon-container))').openseadragon();
    }

    if (typeof Turbo !== 'undefined') {
      addEventListener("turbo:load", () => initOpenSeadragon());
      addEventListener("turbo:frame-load", () => initOpenSeadragon());
    } else {
      addEventListener('load', () => initOpenSeadragon());
    }
  })();

}));
//# sourceMappingURL=openseadragon-rails.js.map
