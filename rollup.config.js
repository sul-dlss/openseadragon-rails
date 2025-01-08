import includePaths from 'rollup-plugin-includepaths';
import commonjs from '@rollup/plugin-commonjs';

const BUNDLE = process.env.BUNDLE === 'true'
const ESM = process.env.ESM === 'true'

const fileDest = `index${ESM ? '.esm' : ''}`
const external = [
  'openseadragon',
]
const globals = {
  openseadragon: 'OpenSeadragon',
}
let includePathOptions = {
  include: {},
  paths: ['app/javascript'],
  external: [],
  extensions: ['.js', '.es6']
};

const rollupConfig = {
  input: 'app/javascript/openseadragon-rails/index.js',
  output: {
    file: `app/assets/javascripts/openseadragon-rails/${fileDest}.js`,
    format: ESM ? 'es' : 'umd',
    globals,
    generatedCode: { preset: 'es2015' },
    name: ESM ? undefined : 'OpenseadragonRails'
  },
  external,
  plugins: [includePaths(includePathOptions), commonjs()]
}

export default rollupConfig
