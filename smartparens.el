;;; smartparens.el --- Automatic insertion, wrapping and paredit-like navigation with user defined pairs.

;; Copyright (C) 2014 Matúš Goljer <matus.goljer@gmail.com>

;; Author: Matúš Goljer <matus.goljer@gmail.com>
;; Maintainer: Matúš Goljer <matus.goljer@gmail.com>
;; Version: 0.0.1
;; Created: 15th July 2014
;; Package-requires: ((dash "2.8.0"))
;; Keywords: lisp, convenience, editing

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 3
;; of the License, or (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program. If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; We are temporarily using the spp prefix to differentiate against
;; the 1.* versions.

;;; Code:

(require 'dash)

(defconst spp-pair-settings '(
                              mode
                              open
                              close
                              )
  "All possible settings for a smartparens pair.")

(defmacro spp-with-setting ()
  "Create `spp-with' macros for easier setup.

For each setting in `spp-pair-settings' this creates a macro
`spp-with-<setting-name>'.  Each of these takes two arguments,
the value for the setting and &rest forms.  The setting is then
added to every `sp-pair' form in forms."
  `(progn
     ,@(-map
        (lambda (setting-name)
          `(defmacro ,(intern (concat "spp-with-" (symbol-name setting-name))) (value &rest forms)
             (declare (indent 1)
                      (debug (form body)))
             (let ((re (-tree-map-nodes
                        (lambda (it) (and (listp it)
                                          (eq (car it) 'sp-pair)))
                        (lambda (it) (-concat it (list ,(intern (concat ":" (symbol-name setting-name))) value)))
                        forms)))
               `(progn ,@re))))
        spp-pair-settings)))

(spp-with-setting)

(provide 'smartparens)

(provide 'smartparens2)
;;; smartparens.el ends here
