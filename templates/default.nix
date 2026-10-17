let
  c = {
    path = ./c;
    description = "C dev environment";
  };
  javascript = {
    path = ./javascript;
    description = "Javascript / Typescript dev environment";
  };
  python = {
    path = ./python;
    description = "Python dev environment";
  };
  rust = {
    path = ./rust;
    description = "Rust dev environment";
  };
in
{
  inherit
    c
    javascript
    python
    rust
    ;
  js = javascript;
  ts = javascript;
  py = python;
  rs = rust;
}
