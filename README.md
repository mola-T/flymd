# FLYMD

On the fly markdown preview.

### Requirements

- A computer
- Emacs
- A modern browser

### Demostration (Link to youtube)

<a href="https://www.youtube.com/watch?v=xMVe9Ka-CDI"
target="_blank"><img src="image/Emacs_On_the_fly_markdown_preview.png" 
alt="Emacs Multithread Demo on Youtube" width="960" height="540" border="10" /></a>

### Features

- Esay to use
- Auto scroll
- GFM compatible
- Online image render
- GFMize
- No external dependency (unless the browser is counted)

### Setup

``` emacs-lisp
(require 'flymd)
```

### Usage

# `flymd-flyit`

**One and only one** interactive function in this package.

<kbd>M-x</kbd> `flymd-flyit`, current markdown buffer opened in a browser.

If you close the page accidentally, <kbd>M-x</kbd> `flymd-flyit` to reopen the page.

### Browser button

- Auto Scroll -------- Toggle auto scroll.
- Auto Refresh ----- Toggle auto refresh.
- GFM Mode ------- Toggle GFM mode.

  Render the page in GFM style (autolink, table and tasklist) if enabled.

- MathJaxize (experimental) - On click rendering MathJax.

- GFMize ------------ On click rendering the page by github API

  Codeblock should be correctly highlight after action.

  Notice that github API allows only 60 accesses per hour.

### Customize output directory

Change the value of `flymd-output-directory` to change where flymd temp output files are stored.

If `nil`, the current markdown working directory will be used.

### Browser Compatibility

Please see [here](browser.md) for browser compatibility issue.

It will be grateful if you can report your browser compatibility or solution throught pull request.

### Change Log

- 1.1.0 - Add MathJaxize; Add `flymd-close-buffer-delete-temp-files` customize option.

## Contacts

mola@molamola.xyz

If you find any bugs or have any suggestions, you can make a pull request, report an issue or send me an email.

## Support

[![paypal](image/buy_me_a_beer.png)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=AG4M5N3TZQ2DJ)    [![paypal](image/buy_me_a_bear.png)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=AZ8SZKK4MZQQE)

## License

* Copyright (C) 2015-2016 Mola-T
* Author: Mola-T <Mola@molamola.xyz>
* URL: https://github.com/mola-T/flymd
* [GNU GENERAL PUBLIC LICENSE](LICENSE)
