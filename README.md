# basys3 Repository!

[![Version: 0.1 Beta](https://img.shields.io/badge/Version-0.1%20Beta-red.svg)](https://github.com/sunriax) [![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0) [![Slack: Join](https://img.shields.io/badge/Slack-Join-blue.svg)](https://join.slack.com/t/sunriax-technology/shared_invite/enQtMjg3OTE2MjIyMTE2LTU1MmEwNmY5Y2Y3MTNjNzFhYzE5NTFkYWY4NzE0YmQzNzA5NjBkMWQ3ODkyNDI1NjJmMGIwYzMwOGI5ZjA2MDg)

## Description

The basys3 repository is a set of VHDL entities and simulations which are used to manage components in the [module](https://github.com/sunriax/module) and other repositories for communication with different microchips and/or semiconductors. It has been written to decrease the amount of commands and/or interrupts @ a microcontroller system. The basys3 repository has got some components which are able to run in standalone mode, no microcontoller will be used or the microcontroller is implemented in the FPGA (VHDL code). There are also some standard logic components like SN74HCTXX or an simple ALU.

1. Development Hardware
   * Basys3 ([Digilent](https://reference.digilentinc.com/reference/programmable-logic/basys-3/start))
   * Altera DE1 ([Terasic](http://www.terasic.com.tw/cgi-bin/page/archive.pl?Language=English&CategoryNo=53&No=83))
   * Megacard ([HTL-Rankweil](http://www.htl-rankweil.at/))
1. Additional Hardware
   * Ultrasonic module ([HCSR04](https://cdn.sparkfun.com/datasheets/Sensors/Proximity/HCSR04.pdf))
1. Development Software
   * Atmel Studio (uC C/C++)
   * Altera Quartus II (VHDL)
   * Xilinx Vivado (VHDL)

## Abstraction

![Graphical Description](https://raw.githubusercontent.com/sunriax/manual/master/docs/image/basys3_abstraction.png "Graphical Description")

## Getting Started

Every entity has its own simulation and description (e.g. spi.vhd, spi_tb.vhd and spi.md). Ín the project folder different entities are used for different projects. Additional information can be found in the project.md. We also try to keep our [WIKI](https://wiki.sunriax.at) up-to-date.

* Bus systems
  * [SPI](./modules/bus/spi.md)
  * [TWI](./modules/bus/twi.md)
* Components
  * [HCSR04](./modules/component/hcsr04.md)
* Counter
  * [Standard](./modules/component/standard.md)
  * [DoubleDabble](./modules/component/dd.md)
* Divider
  * [Divider](./modules/divider/divider.md)
* Multiplexer/Demultiplexer
  * [MUX](./modules/demux/mux.md)
  * [Pipeline](./modules/demux/pipeline.md)
  * [DEMUX](./modules/demux/demux.md)
* Signal/Waveforms
  * [DDS](./modules/signal/dds.md)
  * [PWM](./modules/signal/pwm.md)
* Storage
  * [FIFO](./modules/storage/fifo.md)
* Display
  * [VGA](./modules/display/vga.md)

## Projects

In the projects subdirectory there are projects which use some of the above entities. Additional information can be found under the [project.md](./project/project.md).

## Important Notice

This files are valid for all repositories at the SUNriaX Github!
* [Readme](https://github.com/sunriax/manual/blob/master/README.md)
* [License](https://github.com/sunriax/manual/blob/master/LICENSE.md)
* [Warranty](https://github.com/sunriax/manual/blob/master/WARRANTY.md)

## Additional Information

You can find more additional information in the [manual](https://github.com/sunriax/manual/tree/master/docs) repository and/or visit the [SUNriaX Project Wikipedia](https://wiki.sunriax.at/) for further information (currently under construction).

If there are any further questions feel free to start an issue or contact us, we try to react as quick as possible.

---
**R. GÄCHTER, Rankweil Dec/2017**