![CI](https://github.com/Pooksoft/PooksoftTextMagicAPI.jl/workflows/CI/badge.svg)

## Introduction 
``PooksoftTextMagicAPI.jl`` is a [Julia](https://julialang.org) wrapper for the [TextMagic](https://www.textmagic.com) application programming interface (API). This wrapper encodes basic text messaging functionality, namely, sending a string message to a phone number, or a single string message to a collection phone numbers encoded using the [E.164](https://www.twilio.com/docs/glossary/what-e164) standard. 

## Installation and Requirements
``PooksoftTextMagicAPI.jl`` can be installed, updated, or removed using the [Julia package management system](https://docs.julialang.org/en/v1/stdlib/Pkg/). To access the package management interface, open the [Julia REPL](https://docs.julialang.org/en/v1/stdlib/REPL/), and start the package mode by pressing `]`.
While in package mode, to install ``PooksoftTextMagicAPI.jl``, issue the command:

    (@v1.5) pkg> add PooksoftTextMagicAPI

To use ``PooksoftTextMagicAPI.jl`` in your project issue the command (in your project or in the [Julia REPL](https://docs.julialang.org/en/v1/stdlib/REPL/)):

    julia> using PooksoftTextMagicAPI

To use this package you need [TextMagic API authentication credentials](https://www.textmagic.com/docs/api/start/). 

## Documentation

