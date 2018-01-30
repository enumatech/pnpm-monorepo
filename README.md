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
├── install.sh
├── mod1
│   ├── index.js
│   ├── node_modules
│   │   ├── mocha -> .registry.npmjs.org/mocha/5.0.0/node_modules/mocha
│   │   └── mod2 -> ../../mod2
│   ├── package.json
│   └── shrinkwrap.yaml
├── mod2
│   ├── index.js
│   └── package.json
└── test.sh
```

## Constructing the scenario

The steps were roughly these:

```
$ for d in mod{1,2} app{1,2}; cd $d; pnpm init -y; cd ..; end

$ cd mod1; pnpm install ../mod2; pnpm install -D mocha; cd ..
$ cd app1; pnpm install ../mod1; cd ..
$ cd app2; pnpm install ../mod1; cd ..

$ cd mod2; echo "module.exports = 'mod2'" > index.js; cd ..
$ cd mod1; echo "module.exports = 'mod1 + ' + require('mod2')" > index.js; cd ..
$ cd app1; echo "console.log('app1 depends on: ' + require('mod1'))" > index.js; cd ..
$ cd app2; echo "console.log('app2 depends on: ' + require('mod1'))" > index.js; cd ..
```

## Installing all packages' dependencies

```
$ rm -rf node_modules/ */node_modules/ */shrinkwrap.yaml 
$ for d in {mod,app}{1,2}; cd $d; pnpm install; cd ..; end
Resolving: total 24, reused 24, downloaded 0, done
Packages: +24
++++++++++++++++++++++++
/Users/onetom/lab/pnpm-monorepo/mod1/node_modules/mod2 -> ../mod2

devDependencies:
+ mocha 5.0.0

Already up-to-date
Already up-to-date
/Users/onetom/lab/pnpm-monorepo/app1/node_modules/mod1 -> ../mod1
Already up-to-date
/Users/onetom/lab/pnpm-monorepo/app2/node_modules/mod1 -> ../mod1
```

## Testing

```
$ cd app1; node index.js; cd ..; cd app2; node index.js; cd ..
app1 depends on: mod1 + mod2
app2 depends on: mod1 + mod2
```
