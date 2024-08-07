#!/usr/bin/env node

import { build } from 'esbuild';

try {
  const results = await build({
    entryPoints: ['./src/lambda.ts'],
    outdir: './dist',
    platform: 'node',
    bundle: true,
    format: 'esm',
    packages: 'external',
    outExtension: {
      '.js': '.mjs',
    },
    target: `node${process.versions.node}`,
    sourcemap: true,
  });

  const errors = [...results.warnings, ...results.errors];

  if (errors.length) {
    throw new AggregateError(errors, 'Build error and warnings');
  }
} catch (error) {
  console.error(error);

  process.exitCode ||= 1;
}
