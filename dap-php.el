;;; dap-php.el --- Debug Adapter Protocol mode for Php      -*- lexical-binding: t; -*-

;; Copyright (C) 2018  Ivan Yonchovski

;; Author: Ivan Yonchovski <yyoncho@gmail.com>
;; Author: Thomas Regner <tom@tomsdiner.org>
;; Keywords: languages

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;; URL: https://github.com/yyoncho/dap-mode
;; Package-Requires: ((emacs "25.1") (dash "2.14.1") (lsp-mode "4.0"))
;; Version: 0.2

;;; Commentary:
;; Adapter for https://github.com/felixfbecker/vscode-php-debug

;;; Code:

(require 'dap-mode)

(defcustom dap-php-debug-program `("node" ,(expand-file-name "~/.extensions/php/out/phpDebug.js"))
  "The path to the php debugger."
  :group 'dap-php
  :type '(repeat string))

(defun dap-php--populate-start-file-args (conf)
  "Populate CONF with the required arguments."
  (-> conf
      (dap--put-if-absent :dap-server-path dap-php-debug-program)
      (dap--put-if-absent :type "node")
      (dap--put-if-absent :cwd (lsp-find-session-folder (lsp-session) (buffer-file-name)))
      (dap--put-if-absent :name "Php Debug")))

(dap-register-debug-provider "php" 'dap-php--populate-start-file-args)
(dap-register-debug-template "Php Run Configuration"
                             (list :type "node"
                                   :cwd nil
                                   :request "launch"
                                   :name "Php Debug"
                                   :args '("--server=4711")
                                   :sourceMaps t
                                   ))

(provide 'dap-php)
;;; dap-php.el ends here
