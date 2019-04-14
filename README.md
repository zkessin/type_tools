# Erlang Type Tools

Tools to allow Erlang and Elixir Developers to use type specs in different ways

The first goal for this project is to allow Erlang and Elixir
Developers to use type specs to validate user input in JSON (XML Is
next) data. The goal is that it should be able to ensure that input
entering your system is valid. This is useful with Cowboy Rest or
WebMachine where it can be used with the `malformed_request/2`
callback.

Roadmap (With things still to do)
* Two Element Tuple Types
* Flat Maps with Simple Types
* Maps with Optional Fields
* ~~Peramertized Types~~
* ~~Recursive Data Types~~
* ~~Maps with Complex Fields~~
* ~~Ability to express types as `module:type(arguments)`~~
