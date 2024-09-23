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
 (depends ocaml dune logs fmt lwt ppx_deriving ppx_sexp_conv cstruct ppx_cstruct cohttp-lwt-unix alcotest cstruct-lwt duration)
 (tags
  (topics "to describe" your project)))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/reference/dune-project/index.html
