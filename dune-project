(lang dune 3.16)

(name tpm2)

(generate_opam_files true)

(source
 (github nickrobison/ocaml-tpm2))

(authors "Nick Robison")

(maintainers "Maintainer Name")

(license LICENSE)

(documentation https://url/to/documentation)

(package
 (name tpm2)
 (synopsis "A short synopsis")
 (description "A longer description")
 (depends (ocaml (>= 4.08)) dune logs fmt lwt ppx_deriving ppx_sexp_conv cstruct ppx_cstruct alcotest cstruct-lwt duration ohex)
 (tags
  (topics "to describe" your project)))

(package
 (name tpm2_unix)
 (depends (tpm2 (= :version)) lwt ))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/reference/dune-project/index.html
