# pnpm monorepo

Demonstrate the structure and management of a monorepo which contains
library and application node packages which depend on each other.

```
$ tree .
.
├── README.md
├── app1
│   ├── index.js
│   ├── node_modules
│   │   └── mod1 -> ../../mod1
│   ├── package.json
│   └── shrinkwrap.yaml
├── app2
│   ├── index.js
│   ├── node_modules
│   │   └── mod1 -> ../../mod1
│   ├── package.json
│   └── shrinkwrap.yaml
├── mod1
│   ├── index.js
│   ├── node_modules
│   │   └── mod2 -> ../../mod2
│   ├── package.json
│   └── shrinkwrap.yaml
├── mod2
│   ├── index.js
│   └── package.json
├── node_modules
│   └── pnpmr -> .registry.npmjs.org/pnpmr/0.3.0/node_modules/pnpmr
├── package.json
└── shrinkwrap.yaml

12 directories, 14 files
```

## Constructing the scenario

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

$ pnpm install -D pnpmr
```

## Install all dependencies

Recurse directories and install dependencies if they are node modules:

```
$ pnpx pnpmr install
Running at /Users/onetom/lab/pnpm-monorepo
Already up-to-date
Running at /Users/onetom/lab/pnpm-monorepo/mod2
Already up-to-date
Running at /Users/onetom/lab/pnpm-monorepo/mod1
mod2 is linked to /Users/onetom/lab/pnpm-monorepo/mod1/node_modules from /Users/onetom/lab/pnpm-monorepo/mod2
Already up-to-date

dependencies:
# mod2 linked from /Users/onetom/lab/pnpm-monorepo/mod2

Running at /Users/onetom/lab/pnpm-monorepo/app1
mod1 is linked to /Users/onetom/lab/pnpm-monorepo/app1/node_modules from /Users/onetom/lab/pnpm-monorepo/mod1
Already up-to-date

dependencies:
# mod1 linked from /Users/onetom/lab/pnpm-monorepo/mod1

Running at /Users/onetom/lab/pnpm-monorepo/app2
mod1 is linked to /Users/onetom/lab/pnpm-monorepo/app2/node_modules from /Users/onetom/lab/pnpm-monorepo/mod1
Already up-to-date

dependencies:
# mod1 linked from /Users/onetom/lab/pnpm-monorepo/mod1
```

## Install all dependencies in a fresh clone

```
$ pnpx pnpmr install
Packages: +77
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Resolving: total 77, reused 77, downloaded 0, done

dependencies:
+ pnpmr 0.3.0

Running at /private/tmp/pnpm-monorepo
Packages: +77
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Resolving: total 77, reused 77, downloaded 0, done

devDependencies:
+ pnpmr 0.3.0

Running at /private/tmp/pnpm-monorepo/mod2
Already up-to-date
Running at /private/tmp/pnpm-monorepo/mod1
Already up-to-date
/private/tmp/pnpm-monorepo/mod1/node_modules/mod2 -> ../mod2
Running at /private/tmp/pnpm-monorepo/app1
Already up-to-date
/private/tmp/pnpm-monorepo/app1/node_modules/mod1 -> ../mod1
Running at /private/tmp/pnpm-monorepo/app2
Already up-to-date
/private/tmp/pnpm-monorepo/app2/node_modules/mod1 -> ../mod1
```


## Testing

```
$ pnpm test

> pnpm-monorepo@1.0.0 test /private/tmp/pnpm-monorepo
> cd app1; node index.js; cd ..; cd app2; node index.js; cd ..

mod1 + mod2
mod1 + mod2
```
