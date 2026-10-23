;;; install-packages.el --- run: emacs --batch -l install-packages.el

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
(package-refresh-contents)

(dolist (pkg '(evil corfu kind-icon orderless rust-mode vterm dashboard nerd-icons))
  (unless (package-installed-p pkg)
    (package-install pkg)))

;; build vterm's native module now (needs cmake, libtool, libvterm-devel)
(setq vterm-always-compile-module t)
(require 'vterm)
