#import "/packages.typ": codetastic
#import codetastic: qrcode

#let qrlink(
  url,
  quiet-zone: 4,
  min-version: 1,
  ecl: "l",
  mask: auto,
  size: auto,
  width: auto,
  colors: (white, black),
  debug: false,
) = link(url)[#qrcode(
    url,
    quiet-zone: quiet-zone,
    min-version: min-version,
    ecl: ecl,
    mask: mask,
    size: size,
    width: width,
    colors: colors,
    debug: debug,
  )]
