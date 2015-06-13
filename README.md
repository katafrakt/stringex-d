# stringex-d

Partial port of Ruby's [stringex](https://github.com/rsl/stringex) into D. Right now it only includes unicode characters replacement via maps provided in YAML files.

Note that using it will create a directory `unidecode-yaml` in your project's root, where all YAML files will be put (if you know any other way to do it better, please let me know).

## Usage

The simplest way to use it is to simply call a `unidecode` function on a string:

```d
import std.stdio;
import stringex.unidecode;

void main()
{
	writeln("ŻÓŁW".unidecode());
}
```

The result will be `ZOLW`.

However, note that using it that way will create a `UniDecoder` class every time you call it and, as a result, loading YAML files on every use. The sane way to use it is to manually instantiate a decoder and reuse it, thus limiting filesystem operations (once loaded, map will be kept in memory):

```d
auto decoder = new UniDecoder();
auto decoded = decoder.decode("żółw"); // => "zolw"
decoded = decoder.decode("影响"); // => "Ying Xiang"
```

## What for?

This would probably be most useful for web apps and creating URLs for resources with unicode names. Another example is saving files with sane names.

## License

Released under MIT license.