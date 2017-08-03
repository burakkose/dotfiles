# linter-clojure

This linter plugin for [Linter](https://github.com/AtomLinter/Linter) provides
an interface to [clojure-x.x.x.jar](http://clojure.org/). It will be used with
files that have the "Clojure" syntax.

## Installation

On first activation the plugin will install all dependencies automatically, you
no longer have to worry about installing Linter.

## Settings

You can configure linter-clojure by editing `~/.atom/config.cson` (choose Open
Your Config in Atom menu):

**Windows Example Settings**

```coffeescript
'linter-clojure':
  'clojureExecutablePath': 'D:\\downloads\\clojure-1.6.0\\clojure-1.6.0.jar' # <- point directly to the jar file
  'javaExecutablePath': 'C:\\Program Files (x86)\\Java\\jdk1.7.0\\bin' # to find java in this directory
```

**Mac Example Settings**

*It is important to note that 'javaExecutablePath' MUST point at the Java
executable, not just the path it resides within.*

```coffeescript
  "linter-clojure":
    "clojureExecutablePath": "/Users/theusername/.m2/repository/org/clojure/clojure/1.6.0/clojure-1.6.0.jar"
    "javaExecutablePath": "/usr/bin/java"
```
