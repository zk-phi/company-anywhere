(require 'company)
(require 'company-capf)
(require 'company-tng)

(defun company-anywhere-after-finish (completion)
  (when (and (stringp completion)
             (looking-at "\\(?:\\sw\\|\\s_\\)+")
             (save-match-data
               (string-match (regexp-quote (match-string 0)) completion)))
    (delete-region (match-beginning 0) (match-end 0))))
(add-hook 'company-after-completion-hook 'company-anywhere-after-finish)

(defun company-anywhere-grab-word (_)
  (buffer-substring (point) (save-excursion (skip-syntax-backward "w") (point))))
(advice-add 'company-grab-word :around 'company-anywhere-grab-word)

(defun company-anywhere-grab-symbol (_)
  (buffer-substring (point) (save-excursion (skip-syntax-backward "w_") (point))))
(advice-add 'company-grab-symbol :around 'company-anywhere-grab-symbol)

(defun company-anywhere-dabbrev-prefix (_)
  (company-grab-line (format "\\(?:^\\| \\)[^ ]*?\\(\\(?:%s\\)*\\)" company-dabbrev-char-regexp) 1))
(advice-add 'company-dabbrev--prefix :around 'company-anywhere-dabbrev-prefix)

(defun company-anywhere-capf (fn command &rest args)
  (if (eq command 'prefix)
      (let ((res (company--capf-data)))
        (when res
          (let ((length (plist-get (nthcdr 4 res) :company-prefix-length))
                (prefix (buffer-substring-no-properties (nth 1 res) (point))))
            (cond
             (length (cons prefix length))
             (t prefix)))))
    (apply fn command args)))
(advice-add 'company-capf :around 'company-anywhere-capf)

(defun company-anywhere-tng-frontend (command)
  (when (and (eq command 'update)
             company-selection
             (looking-at "\\(?:\\sw\\|\\s_\\)+")
             (save-match-data
               (string-match (regexp-quote (match-string 0))
                             (nth company-selection company-candidates))))
    (move-overlay company-tng--overlay (overlay-start company-tng--overlay) (match-end 0))))
(advice-add 'company-tng-frontend :after 'company-anywhere-tng-frontend)

(provide 'company-anywhere)
