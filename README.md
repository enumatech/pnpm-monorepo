# pnpm monorepo

Demonstrate the structure and management of a monorepo which contains
library and application node packages which depend on each other.


## Constructing a scenario

The steps were roughly these:

```
$ for d in mod{1,2} app{1,2}; cd $d; pnpm init -y; cd ..; end

$ cd mod1; pnpm install ../mod2; cd ..
$ cd app1; pnpm install ../mod1; cd ..
$ cd app2; pnpm install ../mod1; cd ..

$ cd mod2; echo "module.exports = 'mod2'" > index.js; cd ..
$ cd mod1; echo "module.exports = 'mod1 + ' + require('mod2')" > index.js; cd ..
$ cd app1; echo "console.log(require('mod1'))" > index.js; cd ..
$ cd app2; echo "console.log(require('mod1'))" > index.js; cd ..
```

## Install all dependencies

```
$ pnpm recursive install
```

## Testing

```
$ pnpm test

> pnpm-monorepo@1.0.0 test /private/tmp/pnpm-monorepo
> cd app1; node index.js; cd ..; cd app2; node index.js; cd ..

mod1 + mod2
mod1 + mod2
```
