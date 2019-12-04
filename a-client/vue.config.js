const webpack = require('webpack')
const path = require('path');
module.exports = {
  devServer: {
    proxy: 'http://localhost:3200',
  },
}
