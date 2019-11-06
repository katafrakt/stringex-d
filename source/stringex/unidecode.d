module stringex.unidecode;

import stringex.replacements;
import std.utf;
import std.array;
import std.conv;

string unidecode(string input)
{
	auto result = appender!string();

	foreach(c; input.byDchar()) {
		result ~= decoded(c);
	}

	return result.data;
}

private string decoded(dchar c) {
	if (c <= 128) return c.to!string(); // match https://github.com/rsl/stringex/blob/v2.8.5/lib/stringex/unidecoder.rb#L49

	auto grp = c >> 8;
	auto grouped_point = c & 255;

	if (grp >= replacements.length || grouped_point >= replacements[grp].length)
		return "";
	else
		return replacements[grp][grouped_point];
}

unittest {
	assert(unidecode("abcd") == "abcd");
	assert(unidecode("ABcd") == "ABcd");
	assert(unidecode("ABcd ff") == "ABcd ff");
	assert(unidecode("żółw") == "zolw");
	assert(unidecode("反清復明") == "Fan Qing Fu Ming ");
	assert(unidecode("أنا قادر على أكل الزجاج و هذا لا يؤلمن") == "'n qdr 'l~ 'kl lzjj w hdh l yw'lmn");
}

unittest {
	// regressions found in https://github.com/katafrakt/stringex-d/issues/3
	assert(unidecode("`") == "`");
	assert(unidecode("[") == "[");
}
