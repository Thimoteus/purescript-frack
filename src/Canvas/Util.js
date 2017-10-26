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

// [r0,g0,b0,a0,r1,g1,b1,a1,...,r_4*width-1,g_4*width-1,b_4*width-1,a_4*width-1
// ,r_4*width,g_4*width,b_4*width,a_4*width,r_4*width+1,g_4*width+1,a_4*width+1]
// therefore there are 4*width "columns"
// yet only height "rows"
// how do we get the column and row?
// if index is bigger than 4*width, successively subtract 4*width from index
// until it isn't. Number of subtractions is the row, remainder/4 is the
// column.
// f(x,y) = y + 4*x
// g(n) = ((n - (n/(4*width)))/4, n/(4*width))