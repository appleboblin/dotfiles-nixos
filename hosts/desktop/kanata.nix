{
  services.kanata = {
    keyboards = {
      default = {
        devices = [
          # ls /dev/input/by-path/
        ];
        extraDefCfg = "process-unmapped-keys yes";
        config = ''
          (defsrc
           grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
           tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
           caps a    s    d    f    g    h    j    k    l    ;    '    ret
           lsft z    x    c    v    b    n    m    ,    .    /    rsft
           lctl lmet lalt           spc            ralt rctrl
          )

          (deflayer default
           grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
           tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
           caps a    s    d    f    g    h    j    k    l    ;    '    ret
           lsft z    x    c    v    b    n    m    ,    .    /    rsft
           lctl lmet lalt           spc            ralt rctrl
          )

          (defoverrides
            (lctl q) (lctl .)
            (rctl q) (rctl .)
          )
        '';
      };
    };
  };
}
