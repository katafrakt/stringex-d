import std.algorithm;
import std.conv;
import std.file;
import std.format;
import std.path;
import std.range;
import std.stdio;
import std.string;

void main()
{
	string[][256] replacements;

	foreach (de; dirEntries("unidecode-yaml/", "*.yml", SpanMode.shallow)) {
		auto prefix = de.name.baseName(".yml");
		assert(prefix.startsWith('x') && prefix.length == 3);
		auto nprefix = prefix[1 .. $].to!uint(16);

		foreach (ln; File(de.name, "rt").byLine) {
			if (ln == "---" || ln.strip.empty) continue;
			assert(ln.startsWith("- "));
			ln = ln[2 .. $];
			string s;
			if (ln.startsWith('\'')) {
				assert(ln.endsWith('\''));
				s = ln[1 .. $-1].idup;
				s = s.replace(`\`, `\\`);
				s = s.replace(`"`, `\"`);
			} else if (ln.startsWith('"')) {
				assert(ln.endsWith('"'));
				s = ln[1 .. $-1].idup;
				s = s.replace(`\e`, `\x18`);
			} else {
				s = ln.idup.strip;
				s = s.replace(`\`, `\\`);
			}

			replacements[nprefix] ~= s;
		}
	}

	auto of = File("source/stringex/replacements.d", "wb");
	of.writeln("module stringex.replacements;");
	of.writeln();
	of.writeln("static immutable string[][256] replacements = [");
	foreach (i; 0 .. 256) {
		if (!replacements[i].length) {
			of.writefln("\tnull, // 0x%02x", i);
			continue;
		}
		//assert(replacements[i].length == 256, format("failed for %02X", i));
		of.writefln("\t[ // 0x%02x", i);
		size_t col = 8;
		of.write("\t\t");
		foreach (j, s; replacements[i]) {
			if (j > 0) {
				if (col + s.length + 4 >= 80) {
					of.write(",\n\t\t");
					col = 8;
				} else {
					of.write(", ");
					col += 2;
				}
			}
			of.writef("\"%s\"", s);
			col += 2 + s.length;
		}
		of.writefln("\n\t],");
	}
	of.writeln("];");
}
