# Browser Compatibility

| Browser | Status | Solution |
|---------|--------|----------|
| Firefox | OK | 
| Chrome | Not OK | [Solution](#user-content-chrome)|
| IE | Unknown | |
| Safari | Unknown | |

### Chrome

Google chrome prevents jQuery from loading local files.

There is not a perfect solution for google chrome.

There are two solutions:

- **Solution 1**: Using other brower for `flymd-flyit`

   Add this to your `init` file.

   ``` elisp
    (defun my-flymd-browser-function (url)
      (let ((browse-url-browser-function 'browse-url-firefox))
        (browse-url url)))
    (setq flymd-browser-open-function 'my-flymd-browser-function)
   ```

- **Solution 2**: Still using goolge chrome. But you need to kill all google chrome process before using `flymd-flyit`. This is not recommended.

   Add this to your `init` file.

   ```elisp
    (defun my-flymd-browser-function (url)
      (let* ((process-environment (browse-url-process-environment)))
        (apply 'start-process
               (concat "google-chrome " url) nil
               "google-chrome"
               (list "--new-window" "--allow-file-access-from-files" url))))
    (setq flymd-browser-open-function 'my-flymd-browser-function)

   ```













