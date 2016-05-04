!function() {

  const BACKGROUND_IMAGE_X = 1215;
  const BACKGROUND_IMAGE_Y = 717;
  const BACKGROUND_IMAGE_ASPECT_RATIO = BACKGROUND_IMAGE_X / BACKGROUND_IMAGE_Y;

  function throttle(type, name, obj) {
    obj = obj || window;
    let running = false;

    function func() {
      if (running) return;
      running = true;
      requestAnimationFrame(() => {
        obj.dispatchEvent(new CustomEvent(name));
        running = false;
      });
    }

    obj.addEventListener(type, func);
  };

  throttle("resize", "optimizedResize");


  function handleResize(id) {
    const backgroundNode = document.getElementById(id);
    const windowAspectRatio = window.innerWidth / window.innerHeight;

    if (windowAspectRatio > BACKGROUND_IMAGE_ASPECT_RATIO) {
      backgroundNode.style.backgroundSize = '100%';
      backgroundNode.style.backgroundPosition = 'inherit';
    } else {
      backgroundNode.style.backgroundSize = 'auto 100%';
      backgroundNode.style.backgroundPosition = 'center center';
    }
  }

  function registerBackgroundImageHandler(id) {
    handleResize(id);
    window.addEventListener("optimizedResize", function() {
      handleResize(id);
    });
  }

  LolCupid.registerBackgroundImageHandler = registerBackgroundImageHandler;

}();
