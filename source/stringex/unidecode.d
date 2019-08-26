module stringex.unidecode;

import stringex.replacements;
import std.utf;
import std.format;
import std.path;
import std.array;

string unidecode(string input)
{
	auto result = appender!string();

	foreach(c; input.byDchar()) {
		auto grp = c >> 8;
		auto grouped_point = c & 255;

		if (grp >= replacements.length || grouped_point >= replacements[grp].length)
			result ~= "";
		else
			result ~= replacements[grp][grouped_point];
	}

	return result.data;
}

unittest {
	assert(unidecode("abcd") == "abcd");
	assert(unidecode("ABcd") == "ABcd");
	assert(unidecode("ABcd ff") == "ABcd ff");
	assert(unidecode("żółw") == "zolw");
	assert(unidecode("反清復明") == "Fan Qing Fu Ming ");
	assert(unidecode("أنا قادر على أكل الزجاج و هذا لا يؤلمن") == "'n qdr 'l~ 'kl lzjj w hdh l yw'lmn");
}
