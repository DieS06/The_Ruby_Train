const { generateWebpackConfig, merge } = require('shakapacker');
const path = require('path');

const baseConfig = generateWebpackConfig();

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

const commonWebpackConfig = () => merge({}, baseConfig, {});

module.exports = commonWebpackConfig;
