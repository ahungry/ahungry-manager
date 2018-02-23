;; ahungry-manager - A project template generated by ahungry-fleece
;; Copyright (C) 2016 Your Name <ahungry-manager@example.com>
;;
;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU Affero General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU Affero General Public License for more details.
;;
;; You should have received a copy of the GNU Affero General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;;; ahungry-manager.run.tests.lisp

(in-package #:cl-user)

(defpackage ahungry-manager.run.tests
  (:use :cl
        :ahungry-manager.lib.stub
        :af.lib.ansi-colors
        :af.lib.coverage
        :af.lib.testy)
  (:export :main))

(in-package #:ahungry-manager.run.tests)

(defparameter *base-directory* (asdf:system-source-directory :ahungry-manager))

(defun main ()
  "Run the tests, or the tests with coverage."
  (if (and (sb-ext:posix-getenv "AF_LIB_TESTY_COVERAGE")
           (> (length (sb-ext:posix-getenv "AF_LIB_TESTY_COVERAGE")) 0))
      (coverage)
      (test)
      ))

(defun test ()
  "Begin the tests!"
    (unless (and (sb-ext:posix-getenv "AF_LIB_TESTY_COLORIZE")
                 (> (length (sb-ext:posix-getenv "AF_LIB_TESTY_COLORIZE")) 0))
      (setf af.lib.ansi-colors:*colorize-p* nil))

    (if (suite
         "ahungry-manager.lib"

         (desc
          "ahungry-manager.lib.stub"

          (it "Should echo the input"
              (eq 3 (ahungry-manager.lib.stub:echo 3)))
          )
         ) ;; end suite
        (setf sb-ext:*exit-hooks* (list (lambda () (sb-ext:exit :code 0))))
        (setf sb-ext:*exit-hooks* (list (lambda () (sb-ext:exit :code 1)))))
    )

(defun coverage ()
  "Begin the tests!"
  ;; See if we're in the shell environment or not (SLIME will use 'dumb' here)
  (af.lib.coverage:with-coverage :ahungry-manager
    (test)
    (terpri)
    (with-color :blue (format t "Summary of coverage:~%"))
    (with-open-stream (*error-output* (make-broadcast-stream))
      (af.contrib.sb-cover:report (merge-pathnames #P"coverage/" *base-directory*)))

    (with-open-stream (*error-output* (make-broadcast-stream))
      (af.lib.coverage:report-cli (merge-pathnames #P"coverage/" *base-directory*))
      )

    (with-open-stream (*error-output* (make-broadcast-stream))
      (af.lib.coverage:report-json (merge-pathnames #P"coverage/" *base-directory*))
      )

    (with-color :light-blue
      (format t "~%Full coverage report generated in: ~a" (merge-pathnames #P"coverage/" *base-directory*))
      (format t "~%Coverage summary generated in: ~acoverage.json~%~%" (merge-pathnames #P"coverage/" *base-directory*))
      )
    )
  )

;;; "ahungry-manager.run.tests" goes here. Hacks and glory await!