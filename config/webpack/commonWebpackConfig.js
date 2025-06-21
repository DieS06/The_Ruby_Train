const { generateWebpackConfig, merge } = require('shakapacker');
const path = require('path');

const baseConfig = generateWebpackConfig();

const svgRule = baseConfig.module.rules.find(rule => rule.test.test('.svg'));
  if (svgRule) {
    svgRule.test = /\.(bmp|gif|jpe?g|png|tiff|ico|avif|webp|eot|otf|ttf|woff|woff2)$/;
}

const svgAsReactRule = {
  test: /\.svg$/i,
  issuer: /\.[jt]sx?$/,
  use: [{ 
    loader: '@svgr/webpack',
    options: { icon: true }
  }]
};

const sassRule = baseConfig.module.rules.find(rule =>
  rule.test && rule.test.toString().includes('scss')
);
if (sassRule) {
  sassRule.use.push({
    loader: 'sass-resources-loader',
    options: {
      resources: path.resolve(__dirname, '../../app/javascript/styles/_globals.scss'),
      hoistUseStatements: true
    }
  });
}

const commonWebpackConfig = () => merge({}, baseConfig, {
  module: {
    rules: [ svgAsReactRule ]
  }
});

module.exports = commonWebpackConfig;
