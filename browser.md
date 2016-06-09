# Browser Compatibility

| Browser | *uix | Windows | MacOS |
|---------|--------|----------|----|
| Firefox | :smiley: | :smiley: | :smiley: |
| Chrome | [Solution](#user-content-chrome-windows-or-uix) | [Solution](#user-content-chrome-windows-or-uix) | [Solution](#user-content-chrome-macos) |
| IE | Unknown | Unknown | Unknown |
| Safari | Unknown | Unknown | Unknown |

### Chrome (Windows or *uix)

Google chrome prevents jQuery from loading local files.

There is not a perfect solution for google chrome.

There are two solutions:

- **Solution 1**: Using other browser for `flymd-flyit`, like Firefox.

   Add this to your `init` file.

   ``` elisp
    (defun my-flymd-browser-function (url)
      (let ((browse-url-browser-function 'browse-url-firefox))
        (browse-url url)))
    (setq flymd-browser-open-function 'my-flymd-browser-function)
   ```

- **Solution 2**: Still using google chrome. But you need to kill all google chrome process before using `flymd-flyit`. This is not recommended.

   Add this to your `init` file.

```elisp
    (defun my-flymd-browser-function (url)
      (let ((process-environment (browse-url-process-environment)))
        (apply 'start-process
               (concat "google-chrome " url) nil
               "google-chrome"
               (list "--new-window" "--allow-file-access-from-files" url))))
               (setq flymd-browser-open-function 'my-flymd-browser-function)

```

### Chrome (MacOS)

There are two solutions:

- **Solution 1**: Using other browser for `flymd-flyit`, like Firefox.

Add this to your `init` file.

```elisp
(defun my-flymd-browser-function (url)
  (let ((process-environment (browse-url-process-environment)))
    (apply 'start-process
           (concat "firefox " url)
           nil
           "/usr/bin/open"
           (list "-a" "firefox" url))))
(setq flymd-browser-open-function 'my-flymd-browser-function)
```
- **Solution 2**: Still using google chrome. But you need to kill all google chrome process before using `flymd-flyit`. This is not recommended.

   Add this to your `init` file.

```elisp
    (defun my-flymd-browser-function (url)
      (let ((process-environment (browse-url-process-environment)))
        (apply 'start-process
               (concat "google-chrome " url) nil
               "/usr/bin/open"
               (list "google-chrome" "--new-window" "--allow-file-access-from-files" url))))
               (setq flymd-browser-open-function 'my-flymd-browser-function)

```













