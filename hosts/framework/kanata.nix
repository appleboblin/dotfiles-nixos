{
  services.kanata = {
    enable = true;
    keyboards = {
      internalKeyboard = {
        devices = [
          # ls /dev/input/by-path/
          "/dev/input/by-path/platform-i8042-serio-0-event-kbd"
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

          ;; Graphite special shift pairs
          (defalias
            quote  (fork ' - (lsft rsft)) ;; ' -> _
            comma  (fork , / (lsft rsft)) ;; , -> ?
            hyphen (fork - ' (lsft rsft)) ;; - -> "
            slash  (fork / , (lsft rsft)) ;; / -> <
          )

          ;; Default Graphite Anglemod
          (deflayer graphite-anglemod
           grv  1    2    3    4    5    6      7    8    9       0      [      ]    bspc
           tab  b    l    d    w    z    @quote f    o    u       j      ;      =    \
           lctl n    r    t    s    g    y      h    a    e       i      @comma ret
           lsft q    x    m    c    v    k      p    .    @hyphen @slash rsft
           lctl lalt lmet           spc              @ral rctl
          )

          ;; QWERTY Layout
          (deflayer qwerty
           grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
           tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
           lctl a    s    d    f    g    h    j    k    l    ;    '    ret
           lsft z    x    c    v    b    n    m    ,    .    /    rsft
           lctl lalt lmet           spc            @ral rctl
          )

          ;; Define layer-switching aliases for clean deflayer declarations
          (defalias
           ;; Tap: ralt, Hold: toggles 'layers' for layer switching.
           ral (tap-hold 200 200 ralt (layer-toggle layers))

           ;; Layer-switch aliases
           gar (layer-switch graphite-anglemod)
           qwr (layer-switch qwerty)
          )

          ;; Layer-Switching Layer
          (deflayer layers
           _   @gar @qwr  _    _    _    _    _    _    _    _    _    _   _
           _    _    _    _    _    _    _    _    _    _    _    _    _   _
           caps _    _    _    _    _    left down up   rght _    _    _
           _    _    _    _    _    _    _    _    _    _    _    _
           _    _    _              _              _    _
          )
        '';
      };
    };
  };
}
