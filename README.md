![](../../workflows/gds/badge.svg) ![](../../workflows/docs/badge.svg) ![](../../workflows/test/badge.svg) ![](../../workflows/fpga/badge.svg)

# Tiny Tapeout Verilog Project Template

- [Read the documentation for project](docs/info.md)

## What is Tiny Tapeout?

Tiny Tapeout is an educational project that aims to make it easier and cheaper than ever to get your digital and analog designs manufactured on a real chip.

To learn more and get started, visit https://tinytapeout.com.

## Set up your Verilog project

1. Add your Verilog files to the `src` folder.
2. Edit the [info.yaml](info.yaml) and update information about your project, paying special attention to the `source_files` and `top_module` properties. If you are upgrading an existing Tiny Tapeout project, check out our [online info.yaml migration tool](https://tinytapeout.github.io/tt-yaml-upgrade-tool/).
3. Edit [docs/info.md](docs/info.md) and add a description of your project.
4. Adapt the testbench to your design. See [test/README.md](test/README.md) for more information.

The GitHub action will automatically build the ASIC files using [LibreLane](https://www.zerotoasiccourse.com/terminology/librelane/).

## Enable GitHub actions to build the results page

- [Enabling GitHub Pages](https://tinytapeout.com/faq/#my-github-action-is-failing-on-the-pages-part)

## Resources

- [FAQ](https://tinytapeout.com/faq/)
- [Digital design lessons](https://tinytapeout.com/digital_design/)
- [Learn how semiconductors work](https://tinytapeout.com/siliwiz/)
- [Join the community](https://tinytapeout.com/discord)
- [Build your design locally](https://www.tinytapeout.com/guides/local-hardening/)

## What next?

- [Submit your design to the next shuttle](https://app.tinytapeout.com/).
## Diseño y Funcionamiento (Space Invaders)
*Design:##
This project is a minimalist hardware implementation of ##Space Invaders##.

##How ​​it works:##
- ##Video:## Produces a standard VGA signal at 640x480 @60Hz (assuming a 25.175 MHz clock).

- ##Game Logic:## A logic grid processes the aliens' coordinates; the hardware draws them in real time by checking the counter bits.

- ##Collisions:## If the player's laser intercepts an enemy block in sync, it eliminates that alien in the memory register of the next vertical cycle.

##How ​​to test it:##
1. You need a ##VGA PMOD## connected to the output pins (`uo_out`).

2. You need a ##Gamepad PMOD## compatible with the SNES/NES protocol connected to the inputs (`ui_in`).

3. Set the main clock to `25.175 MHz`.

4. Release the reset signal. Move your player (Green) with the left/right direction keys of the Gamepad; use the A/B Button to fire your laser (Blue) and destroy the invaders (Red) at the top before they fully descend.

##Diseño:##
Este proyecto es una implementación minimalista en hardware de ##Space Invaders##

##Cómo funciona:##
- ##Video:## Produce una señal estándar VGA a 640x480 @60Hz (asumiendo reloj a 25.175 MHz).
- ##Lógica del Juego:## Una cuadrícula lógica procesa las coordenadas de los alienígenas; el hardware dibuja en tiempo real comprobando los bits de los contadores.
- ##Colisiones:## Si el láser del jugador intercepta en sincronía un bloque enemigo, elimina a dicho alien en el registro en memoria del siguiente ciclo vertical.

##Cómo probarlo:##
1. Requieres un ##VGA PMOD## conectado a los pines de salida (`uo_out`).
2. Requiere un ##Gamepad PMOD## compatible con protocolo de SNES/NES en las entradas (`ui_in`).
3. Fija el reloj principal en `25.175 MHz`.
4. Libera la señal de reset. Mueve tu jugador (Verde) con las teclas de dirección izquierda/derecha del Gamepad; usa el Botón A/B para disparar tu láser (Azul) y destruir a los invasores (Rojos) de la parte superior antes que desciendan por completo.
- Share your project on your social network of choice:
  - LinkedIn [#tinytapeout](https://www.linkedin.com/search/results/content/?keywords=%23tinytapeout) [@TinyTapeout](https://www.linkedin.com/company/100708654/)
  - Mastodon [#tinytapeout](https://chaos.social/tags/tinytapeout) [@matthewvenn](https://chaos.social/@matthewvenn)
  - X (formerly Twitter) [#tinytapeout](https://twitter.com/hashtag/tinytapeout) [@tinytapeout](https://twitter.com/tinytapeout)
  - Bluesky [@tinytapeout.com](https://bsky.app/profile/tinytapeout.com)
