# stringex-d

Partial port of Ruby's [stringex](https://github.com/rsl/stringex) into D. Right now it only includes unicode characters replacement via maps provided in YAML files.

## Usage

The simplest way to use it is to simply call a `unidecode` function on a string:

```d
import std.stdio;
import stringex.unidecode;

void main()
{
	writeln("ŻÓŁW".unidecode()); // => "ZOLW"
	writeln("影响".unidecode()); // => "Ying Xiang"
}
```

## What for?

This would probably be mostly useful for web apps and creating URLs for resources with unicode names. Another example is saving files with sane names.

## License

Released under MIT license.
