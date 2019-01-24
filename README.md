# Menu Service #

A mac os x services menu handler

## Services ##

### RPN Calculator ###

Responds to `+ - * / % ^ ++ -- p = avg if>`:

* `2 3 * p` will equal 6

### Markdown ###

Requires a markdown converter to be located at `/usr/local/bin/markdown` or for the following defaults to be set `markdown.cmd` via the defaults command.

### Replace ###

Will run a regular expression to convert text to something else.

uses defaults `convert.data` which contains a JSON list of regular expressions and format settings:

    [
        {
            "r":"([A-Z]+-[0-9]+)",
            "f":"https://link.to.something/%@"
        }
    ]

### Execute ###
Execute clipboard as if it was a shell script.

The first line should be a "shebang" line which is parsed and used to pass as the executable that receives text.

* bash: `#!/bin/bash -S -` (I don't know why yet)
* Python: `#!/usr/bin/env python`
* Ruby: `#!/usr/bin/env ruby`

### Clipboard stack ###

Clipboard, Push
Clipboard, Pop

### Case Changes ###
Case, Upper
Case, Lower
