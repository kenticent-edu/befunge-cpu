<img align="right" src="images/befunge_cpu.png"/>

# Befunge CPU

[Final Presentation](https://docs.google.com/presentation/d/1pbjpH5fVG8pJlD72wulHJ-D56113g_8V_So1CMj0kX0/edit?usp=sharing)

Befunge CPU is processor, which can interpret Befunge at the machine code level. Befunge is a 2-dimensional language, yet it was designed "a nightmare 
to compile". Here's an example of the "Hello World" program written in it:

```
052*"dlroW olleH">:#,_@
```

The following idea was taken as a basis: https://www.bedroomlan.org/hardware/fungus/

> It's perverted, it's baroque, it's vector-based, it's 18 bits wide... Here it is, in all its glory.

## Description

The design of the CPU intentionally resembles a simplified version of the MIPS R×000 architecture (this and subsequent images are taken from the 
original article).

![fungus block diagram](https://www.bedroomlan.org/hardware/fungus/d/figure/default/1920w/fungus-block-diagram.png)

We expanded this simplified block diagram (see docs/CPU_block diagram.vsdx) and extended its functionality to the ability to 
communicate with the outside world via UART. Although some of the functionality was truncated due to the time limit (the ALU operations, for example).

[First presentation](https://docs.google.com/presentation/d/1fmOQRMMFil1ZESH2bRg40HTYU4H_mSZeBrUqtN1Gc4g/edit?usp=sharing).</br>
[Second presentation](https://docs.google.com/presentation/d/1zNu8uXSY3uFxFTMYpfJK2zGMwWUqqrF3dppOvs8dN0E/edit?usp=sharing).

## Roadmap

* ~~Register File(8x18)~~
* ~~Other registers~~
* ~~ALU~~
* ~~MUX A~~
* ~~MUX B~~
* ~~VC~~
* ~~Memory MUX~~
* ~~Memory 1Kx18~~
* State machine for a control unit

## Authors and acknowledgment

Pavlo Yasinovskyi, Diana Kypybida, Andriy Oksenchuk, Oleh Humenchuk
