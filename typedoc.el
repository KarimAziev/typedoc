;;; typedoc.el --- Typedoc utils -*- lexical-binding: t; -*-

;; Copyright (C) 2023 Karim Aziiev <karim.aziiev@gmail.com>

;; Author: Karim Aziiev <karim.aziiev@gmail.com>
;; URL: https://github.com/KarimAziev/typedoc
;; Version: 0.1.0
;; Keywords: languages
;; Package-Requires: ((emacs "25.1"))

;; This file is NOT part of GNU Emacs.

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
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Typedoc utils

;;; Code:



;;;###autoload


;;;###autoload
(defun typedoc-region-to-example ()
  "Copy active region as comments with jsdoc example tag."
  (interactive)
  (if-let ((reg (when (and (region-active-p)
                           (use-region-p))
                  (concat "@example\n```ts\n"
                          (string-trim (buffer-substring-no-properties
                                        (region-beginning)
                                        (region-end)))
                          "\n```"))))
      (let ((result (mapconcat
                     (lambda (line)
                       (if (string-match-p "^\s[\\*]" line)
                           line
                         (concat "\s*\s" line)))
                     (split-string reg "[\n]")
                     "\n")))
        (pop-mark)
        (setq result (format "/**\n%s\n\s*/" result))
        (message "Copied @example")
        (kill-new result)
        result)
    (when (fboundp 'tide-jsdoc-template)
      (tide-jsdoc-template))))

(provide 'typedoc)
;;; typedoc.el ends here