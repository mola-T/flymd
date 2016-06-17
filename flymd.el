;;; flymd.el --- On the fly markdown preview -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2016 Mola-T
;; Author: Mola-T <Mola@molamola.xyz>
;; URL: https://github.com/mola-T/flymd
;; Version: 1.2.0
;; Package-Requires: ((cl-lib "0.5"))
;; Keywords: markdown, convenience
;;
;;; License:
;; This file is NOT part of GNU Emacs.
;;
;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.
;;
;;; Commentary:
;;
;; flymd is a on the fly markdown preview package.
;; It is super, super, super easy to use.
;; Open a markdown file, M-x flymd-flyit
;; The markdown file is opened in your favourite browser.
;; When you finished, close the browser page and kill the markdwon buffer.
;;
;; Please go https://github.com/mola-T/flymd for more info
;;
;;; code:
(require 'cl-lib)
(require 'browse-url)

(defgroup flymd nil
  "Group for flymd"
  :group 'markdown
  :group 'convenience)

(defcustom flymd-refresh-interval 0.5
  "Time to refresh the README."
  :group 'flymd)

(defcustom flymd-markdown-file-type
  '("\\.md\\'" "\\.markdown\\'")
  "Regexp to match markdown file."
  :group 'flymd
  :type '(repeat string))

(defcustom flymd-browser-open-function nil
  "Function used to open the browser.
It needs to accept one string argument which is the url.
If it is not defined, `browse-url-default-browser' is used."
  :group 'flymd
  :type 'function)

(defcustom flymd-output-directory nil
  "The directory where flymd output files will be stored.
If nil, the working directory of the markdown file is used."
  :group 'flymd
  :type 'directory)

(defcustom flymd-close-buffer-delete-temp-files nil
  "If this is non-nil, flymd.md and flymd.html will be deleted
upon markdown buffer killed."
  :group 'flymd
  :type 'boolean)

(defvar flymd-markdown-regex nil
  "A concatenated verion of `flymd-markdown-file-type'.")

(defconst flymd-preview-html-filename "flymd.html"
  "File name for flymd html.")

(defconst flymd-preview-md-filename "flymd.md"
  "File name for flymd md.")

(defconst flymd-point-identifier "fLyMd-mAkEr"
  "Insert this at point to help auto scroll.")

(defvar flymd-timer nil
  "Store the flymd timer.")

(defvar flymd-markdown-buffer-list nil
  "Store the markdown which has been flyit.")

;;;###autoload
(defun flymd-flyit ()
  "Enable realtime markdown preview on the current buffer."
  (interactive)
  (unless flymd-markdown-regex
    (setq flymd-markdown-regex (mapconcat 'identity flymd-markdown-file-type "\\|")))
  (if (string-match-p flymd-markdown-regex (or (buffer-file-name) ""))
      (let ((working-buffer (current-buffer))
            (working-point (point)))
        (flymd-copy-html (flymd-get-output-directory working-buffer))
        (flymd-generate-readme working-buffer working-point)
        (flymd-open-browser working-buffer)
        (unless flymd-timer
          (setq flymd-timer (run-with-idle-timer flymd-refresh-interval t 'flymd-generate-readme)))
        (cl-pushnew working-buffer flymd-markdown-buffer-list :test 'eq)
        (add-hook 'kill-buffer-hook #'flymd-unflyit t))
    (message "What's wrong with you???!\nDon't flyit if you are not viewing a markdown file.")))

(defun flymd-copy-html (dir)
  "Copy flymd.html to working directory DIR if it is no present."
  (unless (file-exists-p (concat dir flymd-preview-html-filename))
    (copy-file (concat (file-name-directory (locate-library "flymd")) flymd-preview-html-filename)
               dir)
    (unless (file-exists-p (concat dir flymd-preview-html-filename))
      (error "Oops! Cannot copy %s to %s" flymd-preview-html-filename dir))))

(defun flymd-generate-readme (&optional buffer point)
  "Save working markdown file from BUFFER to flymd.md and add identifier to POINT."
  (when (or buffer (memq (current-buffer) flymd-markdown-buffer-list))
    (setq buffer (or buffer (current-buffer)))
    (setq point (or point (point)))
    (with-temp-buffer
      (insert-buffer-substring-no-properties buffer)
      (goto-char point)
      (when (string-match-p "\\````" (or (thing-at-point 'line t) ""))
        (forward-line))
      (end-of-line)
      (insert flymd-point-identifier)
      (write-region (point-min)
                    (point-max)
                    (concat (flymd-get-output-directory buffer) flymd-preview-md-filename)
                    nil
                    'hey-why-are-you-inspecting-my-source-code?))))

(defun flymd-open-browser (&optional buffer)
  "Open the browser with the flymd.html if BUFFER succeeded converting to flymd.md."
  (if (file-readable-p (concat (flymd-get-output-directory buffer) flymd-preview-md-filename))
      (if flymd-browser-open-function
          (funcall flymd-browser-open-function
                   (concat (flymd-get-output-directory buffer) flymd-preview-html-filename))
        (browse-url (concat (flymd-get-output-directory buffer) flymd-preview-html-filename)))
    (error "Oops! flymd cannot create preview markdown flymd.md")))

(defsubst flymd-delete-file-maybe (path)
  "Delete flymd temp file under PATH if file exists."
  (when flymd-close-buffer-delete-temp-files
    (when (file-exists-p (concat path flymd-preview-md-filename))
      (delete-file (concat path flymd-preview-md-filename)))
    (when (file-exists-p (concat path flymd-preview-html-filename))
      (delete-file (concat path flymd-preview-html-filename)))))

(defun flymd-unflyit ()
  "Untrack a markdown buffer in `flymd-markdown-buffer-list'."
  (when (buffer-file-name)
    (setq flymd-markdown-buffer-list (remq (current-buffer) flymd-markdown-buffer-list))
    (flymd-delete-file-maybe (flymd-get-output-directory (current-buffer)))
    (unless flymd-markdown-buffer-list
      (when (timerp flymd-timer)
        (cancel-timer flymd-timer))
      (setq flymd-timer nil))))

(defun flymd-get-output-directory (buffer)
  "Gets the correct output directory for flymd preview files of BUFFER."
  (if flymd-output-directory
      (let ((output-dir (file-name-as-directory
                         (concat (file-name-as-directory flymd-output-directory)
                                 (secure-hash 'md5 (buffer-file-name buffer))))))
        (make-directory output-dir t)
        output-dir)
    (file-name-directory (buffer-file-name buffer))))

(provide 'flymd)
;;; flymd.el ends here
