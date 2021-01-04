# company-anywhere

![screencast](./screencast.gif)

Enable company in middle of symbols.

note: this is a wip. there may be some unsupported backends

## Installation

load this package and add `company-anywhere-drop-redundant-candidates`
to `company-transformers`.

```emacs-lisp
(require 'company-anywhere)
(push 'company-anywhere-drop-redundant-candidates company-transformers)
```
