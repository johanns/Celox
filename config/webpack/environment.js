const { environment } = require('@rails/webpacker')

module.exports = environment

environment.loaders.get('sass').use.splice(-1, 0, {
  loader: 'resolve-url-loader',
  options: {
    attempts: 1
  }
});