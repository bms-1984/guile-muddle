(hall-description
  (name "muddle")
  (prefix "guile")
  (version "0.2.0")
  (author "Ben M. Sutter")
  (copyright (2021))
  (synopsis "MUD Server")
  (description "Lispy MUD Server")
  (home-page "https://github.com/bms-1984/guile-muddle")
  (license gpl3+)
  (dependencies `())
  (files (libraries
           ((scheme-file "muddle")
            (directory
              "muddle"
              ((scheme-file "players")
               (scheme-file "server")
               (scheme-file "repl")))))
         (tests ((directory "tests" ())))
         (programs
           ((directory "scripts" ((in-file "muddle")))))
         (documentation
           ((org-file "README")
            (symlink "README" "README.org")
            (text-file "HACKING")
            (text-file "COPYING")
            (directory "doc" ((texi-file "muddle")))))
         (infrastructure
           ((scheme-file "guix") (scheme-file "hall")))))
