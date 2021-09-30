(hall-description
  (name "muddle")
  (prefix "guile")
  (version "0.1.0")
  (author "Ben M. Sutter")
  (copyright (2021))
  (synopsis "MUD Server")
  (description "Lispy MUD Server")
  (home-page "")
  (license gpl3+)
  (dependencies `())
  (files (libraries
           ((scheme-file "muddle")
            (directory
              "muddle"
              ((scheme-file "players")
               (scheme-file "user")
               (scheme-file "server")
               (scheme-file "repl")))))
         (tests ((directory "tests" ())))
         (programs ((directory "scripts" ())))
         (documentation
           ((org-file "README")
            (symlink "README" "README.org")
            (text-file "HACKING")
            (text-file "COPYING")
            (directory "doc" ((texi-file "muddle")))))
         (infrastructure
           ((scheme-file "guix") (scheme-file "hall")))))