const { generateWebpackConfig, merge } = require('shakapacker');
const path = require('path');
const baseConfig = generateWebpackConfig();
const webpack = require('webpack');

const glbLoader = {
  test: /\.(glb|gltf)$/,
  use: [
    {
      loader: 'file-loader',
      options: {
        outputPath: 'models/',
        name: '[name].[hash].[ext]',
      },
    },
  ]
};

const sassRule = baseConfig.module.rules.find(rule => rule.test && rule.test.toString().includes('scss'));
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
    rules: [glbLoader] 
  },
  resolve: {
    alias: {
    '@': path.resolve(__dirname, '../../app/javascript'),
    '@assets': path.resolve(__dirname, '../../app/javascript/assets'),
    '@styles': path.resolve(__dirname, '../../app/javascript/styles'),
    '@types': path.resolve(__dirname, '../../app/javascript/types'),
    '@services': path.resolve(__dirname, '../../app/javascript/services'),
    '@stores': path.resolve(__dirname, '../../app/javascript/stores'),
    '@components': path.resolve(__dirname, '../../app/javascript/components'),
    '@pages': path.resolve(__dirname, '../../app/javascript/bundles/pages'),
    '@graphql' : path.resolve(__dirname, '../../app/javascript/apollo'),
  },
    extensions: ['.js', '.jsx', '.ts', '.tsx', '.json', '.svg']
  },
  plugins: [
    new webpack.DefinePlugin({
      'process.env.TRACE_TURBOLINKS': JSON.stringify(process.env.TRACE_TURBOLINKS || false),
    }),
  ],
});

module.exports = commonWebpackConfig;
