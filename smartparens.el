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


;; Pair settings
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

(defvar spp-pairs nil
  "Alist of pair definitions.

Maps a configuration name to list of pair definitions.

The symbol t represents global settings that should be active in
every buffer.

Configuration name can be a symbol representing a major mode (as
set in the variable `major-mode'), in which case this is
automatically merged into the global configuration when
smartparens is activated in a buffer with given major mode
active.")

(defun spp-pair (&rest keys)
  "Add a pair definition.

\(fn &key MODE OPEN CLOSE INSERT-TRIGGER WRAP-TRIGGER INSERT-KEY WRAP-KEY ACTIONS HOOKS)"
  (let ((data (-pl-to-alist (-pl-delete keys :mode)))
        (mode (or (-pl-get :mode) t)))
    ;; insert into `spp-pairs' here.
    ))

;; example call
;; (spp-pair :open "("
;;           :close ")"
;;           :insert-trigger "("
;;           :wrap-trigger "("
;;           :insert-key "("
;;           :wrap-key ")"
;;           :actions '((:insert
;;                       (:when pred)
;;                       (:unless pred)
;;                       (:delayed pred command event))
;;                      (:wrap
;;                       (:when pred)
;;                       (:unless pred))
;;                      (:autoskip)
;;                      (:navigate)
;;                      (:highlight))
;;           :hooks '((:before-insert function)
;;                    (:after-insert function)
;;                    (:before-wrap function)
;;                    (:after-wrap function)))

;; data structure
;; ((:open . "(")
;;  (:close . ")")
;;  (:insert-trigger . "(")
;;  (:wrap-trigger . "(")
;;  (:insert-key . "(")
;;  (:wrap-key . ")")
;;  (:actions
;;   (:insert
;;    (:when pred)
;;    (:unless pred)
;;    (:delayed pred command event))
;;   (:wrap
;;    (:when pred)
;;    (:unless pred))
;;   (:autoskip)
;;   (:navigate)
;;   (:highlight))
;;  (:hooks
;;   (:before-insert function)
;;   (:after-insert function)
;;   (:before-wrap function)
;;   (:after-wrap function)))

;; We want to also support pairs like {} and {--}.  In this case, only
;; the extra portions should be inserted.
(defun spp-insert-pair (&optional pair)

  )

(provide 'smartparens2)
;;; smartparens.el ends here
