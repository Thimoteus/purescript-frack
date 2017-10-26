exports.mutateData = function (ctx) {
  return function (imageData) {
    return function (rgba) {
      return function () {
        var newImgData = ctx.createImageData(imageData);
        var data = newImgData.data;
        var total = data.length;
        for (var i = 0; i < total; i += 4) {
          data[i] = rgba(i)(data[i]).r;
          data[i + 1] = rgba(i)(data[i + 1]).g;
          data[i + 2] = rgba(i)(data[i + 2]).b;
          data[i + 3] = rgba(i)(data[i + 3]).a;
        }
        return newImgData;
      }
    }
  }
}

exports.createNodeCanvas = function (width) {
  return function (height) {
    return function () {
      var Canvas = require('canvas');
      return new Canvas(width, height);
    }
  }
}

exports.createPngStream = function (canvas) {
  return function () {
    return canvas.pngStream();
  }
}