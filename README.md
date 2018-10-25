# netlify-redirector

[![Build Status](https://travis-ci.org/crdschurch/netlify-redirector.svg?branch=master)](https://travis-ci.org/crdschurch/netlify-redirector)

NetlifyRedirector is a RubyGem that parses CSV and renders redirects suitable for Netlify's build and deployment pipeline. This library aims to take sensitive ENV variables that cannot be exposed in a public repo/logs and parses them prior to Netlify's post-processing tasks.

## Installation

Add the following to your project's Gemfile and bundle...

```
gem 'netlify-redirector', github: 'crdschurch/netlify-redirector'
```

## Usage

Create a new file called `redirects.csv` and put it in the root of your application directory ([example](https://github.com/crdschurch/netlify-redirector/blob/master/redirects.csv)). Each row in your CSV file should contain the following columns:

| Source | Destination | Status | Context |
| --- | --- | --- | --- |
| This is the path you want to match | This is the destination for your rule | The status code associated with the rule | Comma delimited string of branch names for your deployment context, leave this column blank for "no context" |

If you have defined a context for a rule, it will only be rendered for when the current branch name is included within that column; if you have not defined a context, that rule will be deployed everywhere.

When referring to exported ENV variables, you need to use the following convention in your CSV...

```
${env:SOME_ENV_VARIABLE}
```

This gem provides a Rake task for building your `_redirects` file. You'll need to update your build command the reflect the following...

```
$ bundle exec rake redirects:write
```

## License

This project is licensed under the [3-Clause BSD License](https://opensource.org/licenses/BSD-3-Clause).
